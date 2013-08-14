#/bin/sh
PLUGIN_DIR=./unity-admob/Assets/Plugins
rm -f $PLUGIN_DIR/iOS/*.m
rm -f $PLUGIN_DIR/iOS/*.h
cp ./ios/* $PLUGIN_DIR/iOS/
cp ./android/AndroidManifest.xml $PLUGIN_DIR/Android/
cp ./android/libs/GoogleAdMobAdsSdk*.jar $PLUGIN_DIR/Android/
cp ./android/bin/unity-admob-plugin.jar $PLUGIN_DIR/Android/

