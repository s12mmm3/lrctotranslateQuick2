QT += quick

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
    main.cpp \
    operatemgr.cpp
        
HEADERS += \
    operatemgr.h \
    
RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

#程序版本
VERSION = 1.0.0.0
DEFINES += APP_VERSION=\\\"$$VERSION\\\"
#程序图标
RC_ICONS = app.ico
#公司名称
QMAKE_TARGET_COMPANY = "Ruirui"
#程序说明
QMAKE_TARGET_DESCRIPTION = "lrctotranslateQuick2"
#版权信息
QMAKE_TARGET_COPYRIGHT = "Copyright(C) 2022"
#程序名称
QMAKE_TARGET_PRODUCT = "lrctotranslateQuick2"
#程序语言
#0x0800代表和系统当前语言一致
RC_LANG = 0x0800

DISTFILES += \
    android/AndroidManifest.xml \
    android/build.gradle \
    android/gradle.properties \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew \
    android/gradlew.bat \
    android/res/values/libs.xml \
    app.ico \
    app.png

contains(ANDROID_TARGET_ARCH,arm64-v8a) {
    ANDROID_PACKAGE_SOURCE_DIR = \
        $$PWD/android
}
