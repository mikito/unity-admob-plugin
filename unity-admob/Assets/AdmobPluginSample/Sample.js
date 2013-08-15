#pragma strict

function OnGUI(){
	var current : int = 0;
	if(GUI.Button(Rect(0, (current++) * 100, Screen.width, 100), "Hide Ad")){
		AdMobManager.instance.hide();
	}
	if(GUI.Button(Rect(0, (current++) * 100, Screen.width, 100), "Show Ad")){
		AdMobManager.instance.show();
	}
	if(GUI.Button(Rect(0, (current++) * 100, Screen.width, 100), "Refresh Ad")){
		AdMobManager.instance.refresh();
	}
}