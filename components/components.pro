TEMPLATE = subdirs
TARGET = components
CONFIG(x64){
TARGET = $$TARGET"64"
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

CONFIG(x64){
imgdecoder-png.depends += zlib64 png64
render-skia.depends += skia64
render-d2d.depends += utilities464
resprovider-zip.depends += zlib64 utilities464
translator.depends += utilities464
resprovider-7zip.depends += 7z64 utilities464
ScriptModule-LUA.depends += soui464 lua-5464
TaskLoop.depends += utilities464
SIpcObject.depends += utilities464
httpclient.depends += utilities464
}
else {
imgdecoder-png.depends += zlib png
render-skia.depends += skia
render-d2d.depends += utilities4
resprovider-zip.depends += zlib utilities4
translator.depends += utilities4
resprovider-7zip.depends += 7z utilities4
ScriptModule-LUA.depends += soui4 lua-54
TaskLoop.depends += utilities4
SIpcObject.depends += utilities4
httpclient.depends += utilities4
}
