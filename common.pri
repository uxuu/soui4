CONFIG -= qt
CONFIG += stl_off  
INCLUDEPATH += $$dir/config

DESTDIR = $$dir/bin

CONFIG(arm64){
	TARGET = $$TARGET"_arm64"
	DESTDIR = $$DESTDIR"_arm64"
}

CONFIG(x64){
	TARGET = $$TARGET"_x64"
	DESTDIR = $$DESTDIR"_x64"
}

!CONFIG(MBCS){
	CharacterSet = 1
}
else{
	CharacterSet = 2
	DEFINES -= UNICODE
}

CONFIG(debug, debug|release) {
	OBJECTS_DIR =   $$dir/obj/debug/$$TARGET
}
else {
	OBJECTS_DIR =   $$dir/obj/release/$$TARGET
}
QMAKE_LIBDIR += $$DESTDIR
#<--������δ���Ϊdebug��release���ɲ�ͬ���ļ���
defineReplace(souiLibraryTarget) {
  unset(LIBRARY_NAME)
   LIBRARY_NAME = $$1  
      !debug_and_release|build_pass {
	LIBRARY_NAME~= s,_x64,,
	LIBRARY_NAME~= s,_arm64,,
	RET = $$LIBRARY_NAME
      }
 
   isEmpty(RET):RET = $$LIBRARY_NAME
   return($$RET)
}

SAVE_TEMPLATE = $$TEMPLATE
TEMPLATE = fakelib
TARGET = $$qtLibraryTarget($$souiLibraryTarget($$TARGET))
TEMPLATE = $$SAVE_TEMPLATE
#-->

DEFINES += _CRT_SECURE_NO_WARNINGS
#DEFINES += _WIN32_WINNT=0x0502 #�ᵼ��vs2013����skiaʧ�ܣ�����ɾ���ɡ�

#��˱���
QMAKE_CXXFLAGS += /MP

CONFIG(x64){
	QMAKE_LFLAGS += /MACHINE:X64
	DEFINES -= WIN32
	DEFINES += _WIN64
}
else{
	CONFIG(arm64){
		QMAKE_LFLAGS += /MACHINE:ARM64
		DEFINES -= WIN32
		DEFINES += _WIN64
	}
	QMAKE_LFLAGS += /MACHINE:X86
}

!CONFIG(USING_CLR){
	#�ر�RTTI
	QMAKE_CXXFLAGS_RTTI_ON += /GR-
}
else{
	QMAKE_CXXFLAGS += /clr
	CONFIG += exceptions_off
	#�ر��쳣
	QMAKE_CXXFLAGS -= -EHsc
}

QMAKE_CXXFLAGS += -Fd$(IntDir)

!CONFIG(DISABLE_WCHAR){
	#��wchar_tΪ��������
	QMAKE_CXXFLAGS += /Zc:wchar_t
}

QMAKE_CXXFLAGS_RELEASE += /O1
QMAKE_CXXFLAGS_RELEASE += /Zi

CONFIG(CAN_DEBUG){
	#Release�汾�����������Է���
	QMAKE_LFLAGS_RELEASE += /DEBUG
	QMAKE_LFLAGS_RELEASE += /OPT:REF /OPT:ICF
}

CONFIG(USING_MT){
	#ʹ��MT����CRT
	QMAKE_CXXFLAGS_RELEASE += /MT
	QMAKE_CXXFLAGS_DEBUG += /MTd
}

CONFIG(USING_CLR){
	#ʹ��MD����CRT
	QMAKE_CXXFLAGS_RELEASE -= /MT
	QMAKE_CXXFLAGS_DEBUG -= /MTd

	QMAKE_CXXFLAGS_RELEASE += /MD
	QMAKE_CXXFLAGS_DEBUG += /MDd
}

CONFIG(TOOLSET_XP){
	QMAKE_TARGET_OS=xp
}
QMAKE_CXXFLAGS += /wd4100 /wd4101 /wd4102 /wd4189 /wd4996

CONFIG(SPECTRE){
	SpectreMitigation=Spectre
}