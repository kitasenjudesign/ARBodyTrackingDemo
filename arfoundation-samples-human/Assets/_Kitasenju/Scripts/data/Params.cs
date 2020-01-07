using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO;

public class Params : MonoBehaviour
{
    public static Params Instance;
    //public static float speedMultiMultiplier = 1f;
    public static bool isMouseMode = false;
    public bool isMovieMode = true;//false;//動画キャプチャ〜をするモード

    public static bool head = true;
    public static bool handL = true;
    public static bool handR = true;
    public static bool footL = true;
    public static bool footR = true;
    public static bool racket = true;

    [SerializeField] public int catmullResolution = 0;
    [SerializeField] public float zMultiplier = 0;
    [SerializeField] public bool isNejireFix = false;
    [SerializeField] public int captureFrame = 0;
    [SerializeField] public bool randomResolution = false;
    
    [SerializeField,Space(10)] public float brushMasatsuRandomness = 0;
    [SerializeField] public float brushSpeedRandomness = 0;

    public static  string GetConfigFile(){
        return isMouseMode ? "configMouse.json" : "config.json";
    }


    public static float GetTimeRatio(){
        //例えば2bai, 
        return (1f/30f) / Time.deltaTime;
    }

    public static void ToggleEnableParts(int idx){
        switch(idx){
            case 0:
                head = !head;
                break;
            case 1:
                handL = !handL;
                break;
            case 2:
                handR = !handR;
                break;
            case 3:
                footL = !footL;
                break;
            case 4:
                footR = !footR;
                break;
            case 5:
                racket = !racket; 
                break;           
        }
    }

    public static bool GetEnabled(int idx){
        switch(idx){
            case 0:
                return head;
            case 1:
                return handL;
            case 2:
                return handR;
            case 3:
                return footL;
            case 4:
                return footR;
            case 5:
                return racket;

        }

        return false;
    }

    public static void SetEnabled(int idx, bool b){
        switch(idx){
            case 0:
                head = b;
                break;
            case 1:
                handL = b;
                break;
            case 2:
                handR = b;
                break;
            case 3:
                footL = b;
                break;
            case 4:
                footR = b;
                break;
            case 5:
                racket = b;
                break;
        }

    }


    void Awake(){
        Instance=this;
    }
    void Start(){
        Invoke("_onStart",0.5f);
    }

    private void _onStart(){
        
        catmullResolution = Config.GetCatmullResolution();
        zMultiplier = Config.GetZMultiplier();
        isNejireFix = Config.GetIsNejireFix();
        captureFrame = Config.GetCaptureFrame();
        randomResolution = Config.GetRandomResolution();

        //
        brushMasatsuRandomness = Config.brushMasatsuRandomness;
        brushSpeedRandomness = Config.brushSpeedRandomness;
    }

    void Update(){

    }


}
