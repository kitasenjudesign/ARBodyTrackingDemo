using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO;

public class Config
{
    private static bool _isInit = false;
    public static List<AnimationData> animationDataList;
    public static List<AnimationData> asicsAnimationDataList;
    public static JSONObject camera;


    private static int catmullResolution = 3;
    private static float zMultiplier = 1f;
    private static bool isNejireFix = false;
    private static int captureFrame = 1;
    private static bool randomResolution = false;
    public static float brushSpeedRandomness = 0.2f;
    public static float brushMasatsuRandomness = 0.8f;
    public static float jointScale = 0.05f;
    public static Color bgColor;
        //"brushSpeedRandomness":0.2,
        //"brushMasatsuRandomness":0.8

    //    "catmullResolution":3,
    //    "zMultiplier":1

    public static void Init(){

        if(_isInit) return;
        _isInit = true;
        
        string filename = Params.GetConfigFile();

        Debug.Log(filename);

        Paths.Init();
        JSONObject j = JSONLoader.GetJson(Paths.configPath, filename);//"config.json"); 

        bgColor = new Color(
            j.GetField("params").GetField("bgcolor")[0].f,
            j.GetField("params").GetField("bgcolor")[1].f,
            j.GetField("params").GetField("bgcolor")[2].f,
            0
        );
        Debug.Log(bgColor);

        brushSpeedRandomness = j.GetField("params").GetField("brushSpeedRandomness").f;
        brushMasatsuRandomness = j.GetField("params").GetField("brushMasatsuRandomness").f;

        zMultiplier = j.GetField("params").GetField("zMultiplier").f;
        catmullResolution = (int)j.GetField("params").GetField("catmullResolution").f;
        isNejireFix = j.GetField("params").GetField("nejireFix").b;
        captureFrame = (int) j.GetField("params").GetField("captureFrame").f;

        randomResolution = j.GetField("params").GetField("randomResolution").b;

        jointScale = j.GetField("params").GetField("jointScale").f;

        camera = j.GetField("camera");

        animationDataList = new List<AnimationData>();
        var ary = j.GetField("animation");
        for(int i=0; i<ary.Count; i++){
            var data = new AnimationData(ary[i]);
            animationDataList.Add(data);
        }

        asicsAnimationDataList = new List<AnimationData>();
        ary = j.GetField("animationAsics");
        for(int i=0; i<ary.Count; i++){
            var data = new AnimationData(ary[i]);
            asicsAnimationDataList.Add(data);
            
            Debug.Log(i + " " + data.name);

        }
    }

    public static int GetCatmullResolution(){
        return catmullResolution;
    }

    public static float GetZMultiplier(){
        return zMultiplier;
    }

    public static bool GetIsNejireFix(){
        return isNejireFix;
    }

    public static int GetCaptureFrame(){
        return captureFrame;
    }

    public static bool GetRandomResolution(){
        return randomResolution;
    }

}