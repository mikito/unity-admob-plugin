using UnityEngine;
using System.Runtime.InteropServices;
using System;

public class AdMobManager : MonoBehaviour
{
    public enum Position
    {
        TOP,
        BOTTOM,
        TOP_LEFT,
        TOP_RIGHT,
        BOTTOM_LEFT,
        BOTTOM_RIGHT
    }

    private static AdMobManager mInstance = null;

    [SerializeField]
    private string iPhoneAdmobID;
    [SerializeField]
    private string iPadAdmobID;
    [SerializeField]
    private string androidAdmobID;
    [SerializeField]
    private Position position;
    [SerializeField]
    private string[] iosTestDeviceIDs;
    [SerializeField]
    private string[] androidTestDeviceIDs;
    [SerializeField]
    private string iosInterstitialUnitID;
    [SerializeField]
    private string androidInterstitialUnitID;


#if UNITY_IPHONE
    [DllImport("__Internal")]
    private static extern void installAdMobIOS_(string admobID, Position position);
    [DllImport("__Internal")]
    private static extern void addTestDeviceIDIOS_(string testDeviceID);
    [DllImport("__Internal")]
    private static extern void hideAdIOS_();
    [DllImport("__Internal")]
    private static extern void showAdIOS_();
    [DllImport("__Internal")]
    private static extern void refreshAdIOS_();
    [DllImport("__Internal")]
    private static extern void releaseAdMobIOS_();
    [DllImport("__Internal")]
    private static extern bool isIpadAdMob_();

    [DllImport("__Internal")]
    private static extern IntPtr adMobInterstitialInit(string managerName);
    [DllImport("__Internal")]
    private static extern void adMobInterstitialAddTestDevice(IntPtr instance, string deviceID);
    [DllImport("__Internal")]
    private static extern void adMobInterstitialShow(IntPtr instance, string unitID);
    [DllImport("__Internal")]
    private static extern void adMobInterstitialRelease(IntPtr instance);

    IntPtr interstitialBanner; 
#elif UNITY_ANDROID
    private AndroidJavaObject adViewController = null;
    private AndroidJavaObject interstitialBanner = null;
#endif

    public static AdMobManager instance
    {
        get
        {
            return mInstance;
        }
    }

    public void Awake()
    {
        if (mInstance == null)
        {
            mInstance = this;
            DontDestroyOnLoad(gameObject);
        }
        else
        {
            Destroy(gameObject);
        }
    }

    public void OnDestroy()
    {
        if (Application.isEditor) return;

        if (mInstance == this)
        {
#if UNITY_IPHONE
            releaseAdMobIOS_();
            if (interstitialBanner != IntPtr.Zero) adMobInterstitialRelease(interstitialBanner);
#elif UNITY_ANDROID
            adViewController.Call("onDestroy");
#endif
        }
    }

    public void Start()
    {
        if (Application.isEditor) return;

        if (Application.platform == RuntimePlatform.IPhonePlayer)
        {

            bool ipad = false;
#if UNITY_IPHONE
            ipad = isIpadAdMob_();
#endif
            if (ipad && iPadAdmobID != "")
            {
                install(iPadAdmobID, position);
            }
            else
            {
                install(iPhoneAdmobID, position);
            }

        }
        else if (Application.platform == RuntimePlatform.Android)
        {
            install(androidAdmobID, position);
        }
    }

    public void OnApplicationPause(bool pause)
    {
        if (Application.isEditor) return;
        if (pause)
        {
#if UNITY_ANDROID
            adViewController.Call("cancelRefreshTimer");
            adViewController.Call("onPause");
#endif
        }
        else
        {
#if UNITY_ANDROID
            adViewController.Call("onResume");
#endif
            refresh();
        }
    }

    private void install(string admobID, Position position)
    {
#if UNITY_IPHONE
        installAdMobIOS_(admobID, position);
        foreach (string device_id in iosTestDeviceIDs)
        {
            addTestDeviceIDIOS_(device_id);
        }
        refreshAdIOS_();
#elif UNITY_ANDROID
        adViewController = new AndroidJavaObject("net.mikinya.admob.AdViewController");
        foreach (string device_id in androidTestDeviceIDs)
        {
            adViewController.Call("addTestDevice", device_id);
        }
        adViewController.Call("installAdMobForAndroid", admobID, (int)position);
        adViewController.Call("refreshAd");
#endif
    }

    public void refresh()
    {
        if (Application.isEditor) return;

#if UNITY_IPHONE
        refreshAdIOS_();
#elif UNITY_ANDROID
        adViewController.Call("refreshAd");
#endif
    }

    public void hide()
    {
        if (Application.isEditor) return;

#if UNITY_IPHONE
        hideAdIOS_();
#elif UNITY_ANDROID
        adViewController.Call("hideAd");
#endif
    }

    public void show()
    {
        if (Application.isEditor) return;

#if UNITY_IPHONE
        showAdIOS_();
#elif UNITY_ANDROID
        adViewController.Call("showAd");
#endif
    }

    public void showInterstitial()
    {
        if (Application.isEditor) return;

#if UNITY_IPHONE
        if (interstitialBanner != IntPtr.Zero) return;

        interstitialBanner = adMobInterstitialInit(gameObject.name);
        foreach (string deviceID in iosTestDeviceIDs)
        {
            adMobInterstitialAddTestDevice(interstitialBanner, deviceID);
        }
        adMobInterstitialShow(interstitialBanner, iosInterstitialUnitID);

#elif UNITY_ANDROID
        if (interstitialBanner != null) return;

        interstitialBanner = new AndroidJavaObject("net.mikinya.admob.AdInterstitialViewController", gameObject.name);
        foreach (string deviceID in androidTestDeviceIDs)
        {
            interstitialBanner.Call("addTestDevice", deviceID);
        }
        interstitialBanner.Call("show", androidInterstitialUnitID);
#endif
    }

    // Message from AdInterstitialViewController
    void DidInterstitialFinish()
    {
        Debug.Log("on finish");
#if UNITY_IPHONE
        adMobInterstitialRelease(interstitialBanner);
        interstitialBanner = IntPtr.Zero;
#elif UNITY_ANDROID
        interstitialBanner.Dispose();
        interstitialBanner = null;
#endif        
    }
}
