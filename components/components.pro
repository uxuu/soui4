TEMPLATE = subdirs
TARGET = components
CONFIG(x64){
TARGET = $$TARGET"64"
X64=64
}
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

imgdecoder-png.depends += zlib$$X64 png$$X64
render-skia.depends += skia$$X64
render-d2d.depends += utilities4$$X64
resprovider-zip.depends += zlib$$X64 utilities4$$X64
translator.depends += utilities4$$X64
resprovider-7zip.depends += 7z$$X64 utilities4$$X64
ScriptModule-LUA.depends += soui4$$X64 lua-54$$X64
TaskLoop.depends += utilities4$$X64
SIpcObject.depends += utilities4$$X64
httpclient.depends += utilities4$$X64