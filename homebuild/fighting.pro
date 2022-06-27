# allows to add DEPLOYMENTFOLDERS and links to the Felgo library and QtCreator auto-completion
CONFIG += felgo

# uncomment this line to add the Live Client Module and use live reloading with your custom C++ code
# for the remaining steps to build a custom Live Code Reload app see here: https://felgo.com/custom-code-reload-app/
# CONFIG += felgo-live

# Project identifier and version
# More information: https://felgo.com/doc/felgo-publishing/#project-configuration
PRODUCT_IDENTIFIER = com.yourcompany.wizardEVP.Fighting
PRODUCT_VERSION_NAME = 1.0.0
PRODUCT_VERSION_CODE = 1

# Optionally set a license key that is used instead of the license key from
# main.qml file (App::licenseKey for your app or GameWindow::licenseKey for your game)
# Only used for local builds and Felgo Cloud Builds (https://felgo.com/cloud-builds)
# Not used if using Felgo Live
PRODUCT_LICENSE_KEY = ""

qmlFolder.source = qml
DEPLOYMENTFOLDERS += qmlFolder # comment for publishing

assetsFolder.source = assets
DEPLOYMENTFOLDERS += assetsFolder

# Add more folders to ship with the application here

# RESOURCES += resources.qrc # uncomment for publishing

# NOTE: for PUBLISHING, perform the following steps:
# 1. comment the DEPLOYMENTFOLDERS += qmlFolder line above, to avoid shipping your qml files with the application (instead they get compiled to the app binary)
# 2. uncomment the resources.qrc file inclusion and add any qml subfolders to the .qrc file; this compiles your qml files and js files to the app binary and protects your source code
# 3. change the setMainQmlFile() call in main.cpp to the one starting with "qrc:/" - this loads the qml files from the resources
# for more details see the "Deployment Guides" in the Felgo Documentation

# during development, use the qmlFolder deployment because you then get shorter compilation times (the qml files do not need to be compiled to the binary but are just copied)
# also, for quickest deployment on Desktop disable the "Shadow Build" option in Projects/Builds - you can then select "Run Without Deployment" from the Build menu in Qt Creator if you only changed QML files; this speeds up application start, because your app is not copied & re-compiled but just re-interpreted


# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp


android {
    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
    OTHER_FILES += android/AndroidManifest.xml       android/build.gradle
}

ios {
    QMAKE_INFO_PLIST = ios/Project-Info.plist
    OTHER_FILES += $$QMAKE_INFO_PLIST
}

# set application icons for win and macx
win32 {
    RC_FILE += win/app_icon.rc
}
macx {
    ICON = macx/app_icon.icns
}

DISTFILES += \
    qml/Bottle.qml \
    qml/Box.qml \
    qml/Can.qml \
    qml/Finish.qml \
    qml/Ground.qml \
    qml/GroundBottom.qml \
    qml/GroundLeft.qml \
    qml/GroundMud.qml \
    qml/EditorGrid.qml \
    qml/GroundRight.qml \
    qml/Heart.qml \
    qml/DialogBase.qml \
    qml/EditorGrid.qml \
    qml/EditorOverlay.qml \
    qml/EditorUnderlay.qml \
    qml/Coin.qml \
    qml/EditorGrid.qml \
    qml/EditorOverlay.qml \
    qml/EditorUnderlay.qml \
    qml/Ground.qml \
    qml/GroundDirt.qml \
    qml/GroundGrass.qml \
    qml/HUDIconAndText.qml \
    qml/ItemGroupButton.qml \
    qml/JumpTouchButton.qml \
    qml/LeftSidebar.qml \
    qml/HomeBuildEntityButton.qml \
    qml/HomeEntityBaseDraggable.qml \
    qml/Material.qml \
    qml/MenuScene.qml \
    qml/MoveTouchButton.qml \
    qml/ResetSensor.qml \
    qml/Monster.qml \
    qml/MonsterWalker.qml \
    qml/Player.qml \
    qml/SceneBase.qml \
    qml/Spikes.qml \
    qml/PublishDialog.qml \
    qml/SaveLevelDialog.qml \
    qml/SceneBase.qml \
    qml/GameScene.qml \
    qml/TestScene.qml \
    qml/UndoHandler.qml \
    qml/code-admob.png \
    qml/common/HomeImageButton.qml \
    qml/common/HomeSelectableTextButton.qml \
    qml/common/HomeTextButton.qml \
    qml/common/HomeSelectableImageButton.qml \
    qml/helper/EditorGrid.qml \
    qml/logo-admob.png \
    qml/moveButton.qml
