using UnityEngine;
using System.Runtime.InteropServices;

public class AdMobManager : MonoBehaviour
{
    public enum Position
    {
        TOP,
        BOTTOM
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
#elif UNITY_ANDROID
    private AndroidJavaObject adViewController = null;
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

#if UNITY_IPHONE
        if (mInstance == this)
        {
            releaseAdMobIOS_();
        }
#endif
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
            if (ipad)
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
#endif
        }
        else
        {
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
#if UNITY_IPHONE
        refreshAdIOS_();
#elif UNITY_ANDROID
        adViewController.Call("refreshAd");
#endif
    }

    public void hide()
    {
#if UNITY_IPHONE
        hideAdIOS_();
#elif UNITY_ANDROID
        adViewController.Call("hideAd");
#endif
    }

    public void show()
    {
#if UNITY_IPHONE
        showAdIOS_();
#elif UNITY_ANDROID
        adViewController.Call("showAd");
#endif
    }
}
