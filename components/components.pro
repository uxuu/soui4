TEMPLATE = subdirs
TARGET = components
FIX=""
CONFIG(x64){
FIX="-x64"
}
CONFIG(arm64){
FIX="-arm64"
}
TARGET = $$TARGET$$FIX
DEPENDPATH += .
INCLUDEPATH += .

SUBDIRS += imgdecoder-wic
SUBDIRS += render-gdi
SUBDIRS += render-skia
SUBDIRS += render-d2d
SUBDIRS += translator
SUBDIRS += resprovider-zip
SUBDIRS += imgdecoder-stb
SUBDIRS += imgdecoder-png
SUBDIRS += imgdecoder-gdip
SUBDIRS += ScriptModule-LUA
SUBDIRS += log4z
SUBDIRS += resprovider-7zip
SUBDIRS += TaskLoop
SUBDIRS += SIpcObject
SUBDIRS += httpclient


imgdecoder-png.depends += zlib$$FIX png$$FIX
render-skia.depends += skia$$FIX
render-d2d.depends += utilities4$$FIX
resprovider-zip.depends += zlib$$FIX utilities4$$FIX
translator.depends += utilities4$$FIX
resprovider-7zip.depends += 7z$$FIX utilities4$$FIX
ScriptModule-LUA.depends += soui4$$FIX lua-54$$FIX
TaskLoop.depends += utilities4$$FIX
SIpcObject.depends += utilities4$$FIX
httpclient.depends += utilities4$$FIX
