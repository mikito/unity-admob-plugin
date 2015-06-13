Unity AdMob Plugin
===============

概要
---------------
 * Unity5にてiPhone, iPad, AndroidでAdMobを表示

使い方
-------
 * 広告の表示
   * AdMobManagerプレファブをシーンに追加
   * プレファブにAdMobのIDや表示位置などを設定

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
 * 旧AdMobSDKを使用している場合はGoogleAdMobAdsSdk-x.x.x.jarを削除してください
 * 広告取得に失敗したら一定間隔後に自動で再取得を試みる
 * Auto Rotation対応
 * AdMob SDK Version
   * iOS : 7.3.1
   * Android (Google Play Services) : 4.4 (4452000)
