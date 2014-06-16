#/bin/sh
PLUGIN_DIR=./unity-admob/Assets/Plugins
GOOGLE_PLAY_SERVICES_DIR=$ANDROID_SDK_ROOT/extras/google/google_play_services/libproject/google-play-services_lib

# iOS
rm -f $PLUGIN_DIR/iOS/*.m
rm -f $PLUGIN_DIR/iOS/*.h
cp ./ios/* $PLUGIN_DIR/iOS/

# Android
cp ./android/AndroidManifest.xml $PLUGIN_DIR/Android/
cp $GOOGLE_PLAY_SERVICES_DIR/libs/google-play-services.jar $PLUGIN_DIR/Android/
mkdir -p $PLUGIN_DIR/Android/res/values/
cp $GOOGLE_PLAY_SERVICES_DIR/res/values/version.xml $PLUGIN_DIR/Android/res/values/
cp ./android/bin/unity-admob-plugin.jar $PLUGIN_DIR/Android/

