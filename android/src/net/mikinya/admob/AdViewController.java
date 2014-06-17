package net.mikinya.admob;

import java.util.ArrayList;
import java.util.Timer;
import java.util.TimerTask;
import android.app.Activity;
import android.os.Handler;
import android.os.Looper;
import android.widget.LinearLayout;
import android.util.Log;
import android.view.View;
import android.view.Gravity;
import android.view.ViewGroup.LayoutParams;
import com.unity3d.player.UnityPlayer;
import com.google.android.gms.ads.*;

public class AdViewController extends AdListener{
	static private int BANNER_REFRESH_RATE = 1000 * 60 * 5;
	private Handler handler;
	private Activity activity;
	private AdView adView;
	private Timer timer;
	private ArrayList<String> testDevices;
	private LinearLayout layout;
	public String adMobID;
	public int position;
	
	class AdPosition{
		final static int TOP = 0;
		final static int BOTTOM = 1;
		final static int TOP_LEFT = 2;
		final static int TOP_RIGHT = 3;
		final static int BOTTOM_LEFT = 4;
		final static int BOTTOM_RIGHT = 5;
	}
	
	public AdViewController(){
		activity = UnityPlayer.currentActivity;
		handler = new Handler(Looper.getMainLooper());
		testDevices = new ArrayList<String>();
	}
	
	public void installAdMobForAndroid(String adMobID, int position){
		this.adMobID = adMobID;
		this.position = position;

		handler.post(new Runnable(){
	        @Override
	        public void run(){
	        	addAdView();
	        	Log.d("AdViewController","installAd");
	        }
	    });
	}
	
	public void addTestDevice(String testDeviceID){
		testDevices.add(testDeviceID);
	}
	
	private void addAdView(){
		layout = new LinearLayout(activity);
		switch(this.position){
		case AdPosition.TOP:
			layout.setGravity(Gravity.CENTER_HORIZONTAL|Gravity.TOP);
			break;
		case AdPosition.BOTTOM:
			layout.setGravity(Gravity.CENTER_HORIZONTAL|Gravity.BOTTOM);
			break;
		case AdPosition.TOP_LEFT:
			layout.setGravity(Gravity.TOP|Gravity.LEFT);
			break;
		case AdPosition.TOP_RIGHT:
			layout.setGravity(Gravity.TOP|Gravity.RIGHT);
			break;
		case AdPosition.BOTTOM_LEFT:
			layout.setGravity(Gravity.BOTTOM|Gravity.LEFT);
			break;
		case AdPosition.BOTTOM_RIGHT:
			layout.setGravity(Gravity.BOTTOM|Gravity.RIGHT);
			break;
		}
		activity.addContentView(layout, new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT));

	    adView = new AdView(activity);
	    adView.setAdUnitId(adMobID);
	    adView.setAdSize(AdSize.BANNER);
	    adView.setAdListener(this);
		adView.setVisibility(View.GONE);  
	    layout.addView(adView); 
	}
	
	public void hideAd(){
		handler.post(new Runnable(){
	        @Override
	        public void run(){
	        	layout.setVisibility(View.GONE);
	        }
		});
	}
	
	public void showAd(){
		handler.post(new Runnable(){
	        @Override
	        public void run(){
	        	layout.setVisibility(View.VISIBLE);
	        }
		});
	}
	
	public void refreshAd(){
		cancelRefreshTimer();
		handler.post(new Runnable(){
			@Override
			public void run(){
				AdRequest.Builder builder = new AdRequest.Builder();
				
				builder.addTestDevice(AdRequest.DEVICE_ID_EMULATOR);
				for(String device_id : testDevices) {
					builder.addTestDevice(device_id);
				}
			    AdRequest request = builder.build();
				adView.loadAd(request);
				Log.d("AdViewController","refreshAd");
			}
		});
    }
	
	public void cancelRefreshTimer(){
		if(timer != null){
			timer.cancel();
			timer = null;
		}
	}
	
	// Life Cycle
	public void onPause() {
		handler.post(new Runnable(){
			@Override
			public void run(){
				adView.pause();
			}
		});
	}

	public void onResume() {
		handler.post(new Runnable(){
			@Override
			public void run(){
				  adView.resume();
			}
		});
	}

	public void onDestroy() {
		handler.post(new Runnable(){
			@Override
			public void run(){
				  adView.destroy();
			}
		});
	}

	// AdMob Event Listener
    public void onAdClosed() {}
    
    public void onAdFailedToLoad(int errorCode) {
        if(timer != null) return;
        
    	timer = new Timer(true);
        TimerTask mTask = new TimerTask() {
            @Override
            public void run() {
            	refreshAd();
            }                    
        };
        
        timer.schedule(mTask, BANNER_REFRESH_RATE);
    }

	public void onAdLeftApplication() {}
	
	public void onAdOpened() {}
	
	public void onAdLoaded(){
		adView.setVisibility(View.VISIBLE);
	}
}
