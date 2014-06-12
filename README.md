Unity AdMob Plugin
===============

概要
---------------
 * UnityのiPhone, iPad, AndroidでAdMobを表示

使い方
-------
 * 広告の表示
   * AdMobManagerプレファブをシーンに追加
   * プレファブにAdMobのIDや表示位置などを設定
 * [iOSのみ] Xcodeにフレームワークの追加
   * MessageUI.framework
   * StoreKit.framework
   * AdSupport.framework
   * CoreTelephony.framework
 * [iOSのみ] Linker Flag追加
   * Build SettingsのOther Linker Flagsに「-ObjC」を追加

Xcode/フレームワーク自動追加
----------------
 * PostprocessBuildPlayerによりUnityビルド後に自動的にXcodeの設定を行う
 * 準備
   * xcodeproj gemをインストールする(0.14.0で動作)
     * sudo gem install xcodeproj
 * rvmを使用している場合はrvm use systemしてからインストールしてください...

AdMobManager
------------------
 * AdMob ID
   * 広告ユニットIDを入れる
   * いちおうUniversalなアプリでiPhoneとiPadのIDを切り分けられる
   * iPad切り分ける必要なかったらiPhoneのみ設定
 * Position
   * 広告表示位置
   * TOP, BOTTOM, TOP_LEFT, TOP_RIGHT, BOTTOM_LEFT, BOTTOM_RIGHT
 * ios / Android Test Device IDs
   * テスト端末IDリスト
   * Device IDはXcodeやadb logcat等で起動時に確認できるはず
     * <Google> To get test ads on this device, call: request.testDevices = [NSArray arrayWithObjects:@"XXXXXXX", nil];
     * To get test ads on this device, call adRequest.addTestDevice("XXXXXXXXX");
 * 広告表示きりかえ
   * AdMobManager.instance.show();
   * AdMobManager.instance.hide();
 * 広告再リクエスト
   * AdMobManager.instance.refresh()

備考
-----
 * 広告取得に失敗したら一定間隔後に自動で再取得を試みる
 * Auto Rotation対応
 * AdMob SDK Version
   * iOS : 6.9.2
   * Android : 6.4.1
