package net.mikinya.admob;

import java.util.ArrayList;
import android.app.Activity;
import android.os.Handler;
import android.os.Looper;
import android.view.WindowManager;
import com.unity3d.player.UnityPlayer;
import com.google.android.gms.ads.*;

public class AdInterstitialViewController {
	private Handler handler;
	private Activity activity;
	private InterstitialAd interstitial;
	private ArrayList<String> testDevices;
	private String managerName;
	private String unitID;
	
	public AdInterstitialViewController(String managerName){
		activity = UnityPlayer.currentActivity;
		handler = new Handler(Looper.getMainLooper());
		testDevices = new ArrayList<String>();
		addTestDevice(AdRequest.DEVICE_ID_EMULATOR);
		this.managerName = managerName;
	}

	public void addTestDevice(String testDeviceID){
		testDevices.add(testDeviceID);
	}
	
	public void show(final String unitID)
	{
		this.unitID = unitID;
		
		handler.post(new Runnable(){
	        @Override
	        public void run(){
	    	   loadView();
	        }
	    });
	}

	private void loadView(){
		// Disable touch
		activity.getWindow().setFlags(WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE,
				WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE);
			
		// Set InterstitialAd
		interstitial = new InterstitialAd(activity);
 	    interstitial.setAdUnitId(unitID);
 	    interstitial.setAdListener(new AdListener(){
 	    		public void onAdClosed() {
 	    			OnUnloadView();
 	    	    }
 	    	    
 	    	    public void onAdFailedToLoad(int errorCode) {
 	    	    	OnUnloadView();
 	    	    }
 	    		
 	    		public void onAdLoaded(){
 	    			interstitial.show();
 	    		}

 	    		public void onAdLeftApplication() {}
 	    		public void onAdOpened() {}
 	    });
 	    
 	    // Request
	    AdRequest.Builder builder = new AdRequest.Builder();
		for(String deviceID : testDevices) {
			builder.addTestDevice(deviceID);
		}
	    AdRequest request = builder.build();
		interstitial.loadAd(request);
	}
	
	void OnUnloadView()
	{
		activity.getWindow().clearFlags(WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE);
	    UnityPlayer.UnitySendMessage(managerName, "DidInterstitialFinish", "");
	}
}
