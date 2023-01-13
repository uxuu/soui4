@set echo=off
@echo %echo%
cls

setlocal enabledelayedexpansion
rem color 1f

cd /d %~dp0
if exist .\build-env.bat (
    call .\build-env.bat
)

if defined SOUIPATH (
    echo.set SOUIPATH=%SOUIPATH%
    echo.
) else (
    echo can't find env variable SOUIPATH, clone soui core and install wizard first, please.
    goto :end
)

call %SOUIPATH%\build-env.bat

set cfg=CAN_DEBUG

set msbit=%1

if "%msbit%" == "64" (
    set cfg=%cfg% x64
    set msplatform=x64
    set xplatform=x64
) else if "%msbit%" == "32" (
    set msplatform=Win32
    set xplatform=x86
    set msbit=
) else (
    echo unknown bit...
    goto end
)

set mstarget=%2

if "%mstarget%" == "" (
    set mstarget=Build
)

set msconfig=%3

if "%msconfig%" == "" (
    set msconfig=Release
)


for /f %%b in ('dir /b *.pro') do (
    set msname=%%b
)
set msname=%msname:~0,-4%
set mssolution=%msname%%msbit%.sln

call %build_vsvarbat% %xplatform%
@echo %echo%

if not exist %mssolution% call :qmake

if not exist subdir.xml goto :build
rem WindowsSDKVersion
rem TargetPlatformVersion
for /f "tokens=3 delims==</" %%b in (subdir.xml) do (
    if exist %%b\uires\uires.idx (
        pushd %%b
        %SOUIPATH%\tools\uiresbuilder.exe -p uires -i uires\uires.idx -r res\soui_res.rc2 -h res\resource.h idtable
        popd
    )
)

:build
msbuild %mssolution% /t:%mstarget% /p:Configuration=%msconfig%;Platform=%msplatform%;PlatformToolset=v142  /fl /v:m

goto :end

:qmake
set cfgname=%SOUIPATH%\config\build.cfg
set section=BuiltConfig

call :readini %cfgname% %section% MT CFG_MT
call :readini %cfgname% %section% UNICODE CFG_UNICODE
call :readini %cfgname% %section% WCHAR CFG_WCHAR
call :readini %cfgname% %section% SUPPORT_XP CFG_SUPPORT_XP

if x%CFG_MT%==x1 (set cfg=%cfg% USING_MT)
if x%CFG_UNICODE%==x0 (set cfg=%cfg% MBCS)
if x%CFG_WCHAR%==x0 (set cfg=%cfg% DISABLE_WCHAR)
if x%CFG_SUPPORT_XP%==x1 (set cfg=%cfg% TOOLSET_XP)


if x%build_specs%==xwin32-msvc2017 (
    %SOUIPATH%\tools\qmake2017 -tp vc -r -spec %SOUIPATH%\tools\mkspecs\%build_specs% "CONFIG += !cfg! "
    if x%CFG_SUPPORT_XP% == x1 (
        %SOUIPATH%\tools\ConvertPlatformToXp -f subdir.xml
    )
) else (
    %SOUIPATH%\tools\qmake -tp vc -r -spec %SOUIPATH%\tools\mkspecs\%build_specs% "CONFIG += !cfg! "
)
powershell -c "(Get-Content '%mssolution%' -Raw) -Replace '(Format Version ).*', '$1 12.0' | Set-Content '%mssolution%'"
goto :eof

:: 读取ini配置. %~1:文件名，%~2:域，%~3:key %~4:返回的value值
:readini 
@setlocal enableextensions
set cfgname=%~1
set section=[%~2]
set key=%~3
set cur_section=
for /f "usebackq delims=" %%a in ("!cfgname!") do (
    set line=%%a
    if "x!line:~0,1!"=="x[" (
        set cur_section=!line!
    ) else (
        for /f "tokens=1,2 delims==" %%b in ("!line!") do (
            set currkey=%%b
            set curval=%%c
            if "x!section!"=="x!cur_section!" (
                if "x!key!"=="x!currkey!" (
                    set var=!curval!
                )
            )
        )
    )
)
(endlocal
    set "%~4=%var%"
    echo set %~4=%var%
)
goto:eof

:end
rem pause
