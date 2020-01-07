using UnityEngine;
using System.Collections;
using System;
using System.Text;
using System.IO;

//streamingAsset内のデータを読み込む

public class JSONLoader
{

    //private string text;
    //public JSONObject Json;
    //public bool isComplete {get; private set;}

    // Use this for initialization
    public static JSONObject GetJson(string dir, string filename)
    {
        //Debug.Log("[ConfigLoader] awake");
        //Json = _LoadJSON(_GetPath(filename));//ここで読んでいる。
        //isComplete = true;
        return _LoadJSON( dir + filename );
    }

    //protected static string _GetPath(string filename)
    //{
    //    return Application.streamingAssetsPath + "/" + filename;
        //return new System.IO.FileInfo(Application.streamingAssetsPath + "/" + filename).FullName;
    //}
    //
    protected static JSONObject _LoadJSON(string path)
    {

        var text = "";
            
        FileInfo fi = new FileInfo(path);
        try
        {
            // 一行毎読み込み
            using (StreamReader sr = new StreamReader(fi.OpenRead(), Encoding.UTF8))
            {
                text = sr.ReadToEnd();
            }
        }
        catch (Exception e)
        {
            // 改行コード
            text += "エラーです";
            throw new Exception("JSON読み込みエラー " + path);
        }
        JSONObject json = new JSONObject(text);

        //Debug.Log(path);
        //Debug.Log("jsonloader onload >>>  " + json.ToString());

        return json;
    }


}
