using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO;

public class AnimationData
{
    public string name = "";
    public float duration = 0;
    public Vector3 tgtPos = Vector3.zero;

    public float startTime = 0;
    public float endTime = 3f;
    public float speed = 1f;
    public bool isRacket = false;
    public AnimationData(JSONObject j){


         var duration    = j.GetField("duration").n;
            name          = j.GetField("name").str;
            
            var tgtPosAry      = j.GetField("tgtPos");
            tgtPos = new Vector3(
                tgtPosAry[0].n,
                tgtPosAry[1].n,
                tgtPosAry[2].n
            );
            
        speed = j.GetField("speed").n;
        startTime = j.GetField("startTime").n;
        endTime = j.GetField("endTime").n;

    }

}