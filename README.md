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
 * [iOSのみ] XCodeにフレームワークの追加
   * MessageUI.framework
   * StoreKit.framework
   * AdSupport.framework

XCode/フレームワーク自動追加
----------------
 * Macrubyをインストールする
   * http://macruby.org/
 * xcodeproj gemをインストールする(0.3.2で動作)
   * macgem install xcodeproj
 * PostprocessBuildPlayerによりUnityビルド後に自動的に追加される
 * これを使うとXCodeプロジェクトにAppendできなくなる弊害がある

AdMobManager
------------------
 * AdMob ID
   * いちおうiPhoneとiPadのIDを切り分けられる。iPad切り分ける必要なかったらiPhoneのみ設定
 * Position
   * 広告表示位置
   * TOP or BOTTOM
* ios / Android Test Device IDs
   * Device IDはXCodeやadb logcat等で起動時に確認できるはず
     * <Google> To get test ads on this device, call: request.testDevices = [NSArray arrayWithObjects:@"XXXXXXX", nil];
     * To get test ads on this device, call adRequest.addTestDevice("XXXXXXXXX");
 * 広告表示きりかえ
   * AdMobManager.show();
   * AdMobManager.hide();

備考
-----
 * 広告取得に失敗したら一定間隔後に自動で再取得を試みる
 * AdMob SDK Version
   * iOS : 6.4.1
   * Android : 6.4.1


