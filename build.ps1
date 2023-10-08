#powershell -ExecutionPolicy bypass -File build.ps1
param ([string] $arch="x64",
    [string] $workdir,
    [string] $target="build",
    [string] $config="release",
    [switch] $cmake)

#SOUI编译模式[1=全模块DLL;2=全模块LIB;3=内核LIB,组件DLL(不能使用LUA脚本模块)]
$SOUI_DYNAMIC=1
#字符集[1=UNICODE;2=MBCS]
$SOUI_UNICODE=1
#将WCHAR作为内建类型[1=是;2=否]
$SOUI_WCHAR=1
#CRT链接模式[1=静态链接(MT);2=动态链接(MD)]
$SOUI_MT=2
#为release版本生成调试信息[1=生成;2=不生成]
$SOUI_DEBUG=1
#是否支持xp[1=支持;2=不支持
$SOUI_XP=2

if(Test-Path "${PSScriptRoot}/build-env.ps1")
{
    . "${PSScriptRoot}/build-env.ps1"
}

$allowed_arch = "all", "x86", "x64", "arm64"
if (-Not($allowed_arch.Contains($arch)))
{
    Write-Host "-arch must be:" $allowed_arch
    exit 1
}

$vswhere="${env:ProgramFiles(x86)}\microsoft visual studio\installer\vswhere.exe"
$vspath=&"$vswhere" -nologo -products Microsoft.VisualStudio.Product.BuildTools -property installationPath -format value
$instanceId=&"$vswhere" -nologo -products Microsoft.VisualStudio.Product.BuildTools -property instanceId -format value
$vsversion=&"$vswhere" -nologo -products Microsoft.VisualStudio.Product.BuildTools -property catalog_productLineVersion -format value

if(-Not($vspath)) {
    $vspath=&"$vswhere" -nologo -property installationPath -format value
    $instanceId=& "$vswhere" -nologo -property instanceId -format value
}

Write-Host "vspath=$vspath"

Import-Module "$vspath\Common7\Tools\Microsoft.VisualStudio.DevShell.dll"
&Enter-VsDevShell -SkipAutomaticLocation $instanceId

if($cmake)
{
    $vsname=&"$vswhere" -nologo -products Microsoft.VisualStudio.Product.BuildTools -property catalog_productName -format value
    $vsline=&"$vswhere" -nologo -products Microsoft.VisualStudio.Product.BuildTools -property catalog_productLine -format value
    $vsline=$vsline -replace "Dev"
    if(-Not($workdir))
    {
        $workdir="build-$arch"
    }
    cmake -S . -B $workdir -G "$vsname $vsline $vsversion" -A $arch
    cmake --build $workdir --config $config -j $ENV:NUMBER_OF_PROCESSORS
} else {
    Set-Content -Path "./config/build.cfg" -Value "[BuiltConfig]"
    Add-Content -Path "./config/build.cfg" -Value "UNICODE=$SOUI_UNICODE"
    Add-Content -Path "./config/build.cfg" -Value "WCHAR=$SOUI_WCHAR"
    Add-Content -Path "./config/build.cfg" -Value "MT=$SOUI_MT"
    Add-Content -Path "./config/build.cfg" -Value "DYNAMIC_SOUI=$SOUI_DYNAMIC"

    $cfg = "SPECTRE"
    if($SOUI_DYNAMIC -eq 1)
    {
        Set-Content -Path "./config/config.h" -Value "#define DLL_SOUI_COM    //SOUI组件编译为dll"
        Add-Content -Path "./config/config.h" -Value "#define DLL_CORE        //SOUI内核编译为dll"
    } elseif($SOUI_DYNAMIC -eq 2) {
        Set-Content -Path "./config/config.h" -Value "#define LIB_SOUI_COM    //SOUI组件编译为lib"
        Add-Content -Path "./config/config.h" -Value "#define LIB_CORE        //SOUI内核编译为lib"
        $cfg = "$cfg LIB_ALL"
    } elseif($SOUI_DYNAMIC -eq 3) {
        Set-Content -Path "./config/config.h" -Value "#define DLL_SOUI_COM    //SOUI组件编译为dll"
        Add-Content -Path "./config/config.h" -Value "#define LIB_CORE        //SOUI内核编译为lib"
        $cfg = "$cfg LIB_CORE"
    }

    if(-Not(Test-Path "./tools/qmake515.exe" ))
    {
        Push-Location "./tools/src/qmake"
        nmake
        Pop-Location
        Copy-Item -Path "./tools/src/qmake/qmake.exe" -Destination "./tools/qmake515.exe"
    }
    if($SOUI_XP -eq 1)
    {
        $cfg = "$cfg TOOLSET_XP"
    }
    if($SOUI_UNICODE -eq 2)
    {
        $cfg = "$cfg MBCS"
    }
    if($SOUI_WCHAR -eq 2)
    {
        $cfg = "$cfg DISABLE_WCHAR"
    }
    if($SOUI_MT -eq 1)
    {
        $cfg = "$cfg USING_MT"
    }
    if($SOUI_DEBUG -eq 1)
    {
        $cfg = "$cfg CAN_DEBUG"
    }
    $sln = "soui4.sln"
    if(-Not($arch -eq "x86"))
    {
        $cfg = "$cfg $arch"
        $sln = "soui464.sln"
    }
    cmd /c "call ""$vspath\VC\Auxiliary\Build\vcvarsall.bat"" $arch & .\tools\qmake515.exe -tp vc -r -spec "".\tools\mkspecs\win32-msvc$vsversion"" ""CONFIG += $cfg"""
    msbuild "$sln" /maxcpucount /t:$target /p:Configuration=$config  /fl /v:m
}
