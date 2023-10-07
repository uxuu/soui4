TEMPLATE = subdirs
TARGET = soui4
CONFIG(x64){
TARGET = $$TARGET"64"
}
DEPENDPATH += .
INCLUDEPATH += .

SUBDIRS += third-part
SUBDIRS += utilities
SUBDIRS += soui-sys-resource
SUBDIRS += soui-sys-resource2
SUBDIRS += soui
SUBDIRS += components
SUBDIRS += demo
SUBDIRS += demo2

CONFIG(x64){
soui.depends += utilities464 soui-sys-resource64
demo.depends += soui464
demo2.depends += soui464
}
else {
soui.depends += utilities4 soui-sys-resource
demo.depends += soui4
demo2.depends += soui4
}
