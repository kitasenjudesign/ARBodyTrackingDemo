using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO;

public class Paths
{
    public static string imgOutputPath = "";//親のディレクトリ
    public static string texturePath = "";
    public static string brushPath = "";//ブラシ用のテクスチャ
    public static string currentImgOutPath = "";//今日画像を保存するパス
    public static string configPath = "";
    public static string currentDirName = "test";

    public static void Init(){

        //ディレクトリのパス
            
            
           /*
            #if UNITY_EDITOR
                imgOutputPath   = Application.dataPath + "/../output/";
            #else
                imgOutputPath   = Application.streamingAssetsPath + "/output/";
            #endif

            texturePath     = Application.streamingAssetsPath + "/textures/color/";
            configPath      = Application.streamingAssetsPath + "/config/";
            brushPath       = Application.streamingAssetsPath + "/textures/brush/";

            currentImgOutPath = imgOutputPath;
            */

            #if UNITY_EDITOR
                imgOutputPath   = Application.dataPath + "/../output/";
                texturePath     = Application.dataPath + "/../textures/color/";
                configPath      = Application.dataPath + "/../config/";
                brushPath       = Application.dataPath + "/../textures/brush/";
            #else
                imgOutputPath   = Application.dataPath + "/../../output/";
                texturePath     = Application.dataPath + "/../../textures/color/";
                configPath      = Application.dataPath + "/../../config/";
                brushPath       = Application.dataPath + "/../../textures/brush/";
            #endif
        
        
        if(currentImgOutPath=="")currentImgOutPath = imgOutputPath;


    }

    //今日の新しいディレクトリをつくりましょう。
    public static string SetNewDir(string newDirName){
        
        var newPath = imgOutputPath + "/" + newDirName;

        currentImgOutPath = newPath;
        return currentImgOutPath;
    }

    public static void MakeNewDir(string newPath){
        
        if ( Directory.Exists( newPath )) {
            // フォルダが存在する.
            Debug.Log("既に存在しているのでディレクトリつくらない " + newPath);
        }else{
            Directory.CreateDirectory( newPath );
            Debug.Log("ディレクトリを新しく作る" + newPath);
        }

    }
}