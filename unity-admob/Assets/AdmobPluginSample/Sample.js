#pragma strict

var admob : AdMobManager;

function OnGUI(){
	var current : int = 0;
	if(GUI.Button(Rect(0, (current++) * 100, Screen.width, 100), "Hide Ad")){
		admob.hide();
	}
	if(GUI.Button(Rect(0, (current++) * 100, Screen.width, 100), "Show Ad")){
		admob.show();
	}
	if(GUI.Button(Rect(0, (current++) * 100, Screen.width, 100), "Refresh Ad")){
		admob.refresh();
	}
}