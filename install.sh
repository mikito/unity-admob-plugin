#/bin/sh
PLUGIN_DIR=./unity-admob/Assets/Plugins
cp ./ios/* $PLUGIN_DIR/iOS/
cp ./android/AndroidManifest.xml $PLUGIN_DIR/Android/
cp ./android/libs/GoogleAdMobAdsSdk*.jar $PLUGIN_DIR/Android/
cp ./android/bin/unity-admob-plugin.jar $PLUGIN_DIR/Android/

