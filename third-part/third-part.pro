TEMPLATE = subdirs
TARGET = third-part
FIX=""
CONFIG(x64){
FIX="_x64"
}
CONFIG(arm64){
FIX="_arm64"
}
TARGET = $$TARGET$$FIX
DEPENDPATH += .
INCLUDEPATH += .

SUBDIRS += gtest
SUBDIRS += png
SUBDIRS += skia
SUBDIRS += zlib
SUBDIRS += lua-54
SUBDIRS += smiley
SUBDIRS += mhook
SUBDIRS += 7z
SUBDIRS += scintilla
SUBDIRS += sqlite3
SUBDIRS += jsoncpp
CONFIG(arm64){
    SUBDIRS -= mhook
}

CONFIG(c++11){

}