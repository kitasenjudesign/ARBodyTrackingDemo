using System.Collections;
using System.Collections.Generic;
using UnityEngine;



public class FPSCounter : MonoBehaviour{

    private int _count = 0;
    private int _total = 0;
    private GUIStyle _style;

    private bool _isActive = false;

    void Start(){
        _StartTimer();
    }

    void _StartTimer(){
        _total=_count;
        _count=0;
        Invoke("_StartTimer", 1f);
    }

    private void OnGUI()
    {

        if(!_isActive)return;

        if(_style==null){
            _style = new GUIStyle();
            _style.fontSize = 24;
            _style.alignment = TextAnchor.UpperRight;
            _style.normal.textColor = Color.blue;                
        }

        GUI.Label(new Rect(Screen.width-205, 0, 200, 100), "FPS "+_total + "/" + Application.targetFrameRate, _style);

    }


    void Update(){

        _count++;

        if( Input.GetKeyDown( KeyCode.M )){
            _isActive = !_isActive;
        }

    }


}