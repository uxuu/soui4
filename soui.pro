TEMPLATE = subdirs
TARGET = soui4
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

SUBDIRS += third-part
SUBDIRS += utilities
SUBDIRS += soui-sys-resource
SUBDIRS += soui-sys-resource2
SUBDIRS += soui
SUBDIRS += components
SUBDIRS += demo
SUBDIRS += demo2

soui.depends += utilities4$$FIX soui-sys-resource$$FIX
demo.depends += soui4$$FIX
demo2.depends += soui4$$FIX
