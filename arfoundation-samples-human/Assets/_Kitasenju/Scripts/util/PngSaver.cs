using UnityEngine;
using System.Collections;
using System.IO;
using System;
//using UnityEngine.Object;

public class PngSaver  {
 
    private static Texture2D _tex;

    /**
        PngSaver
     */
    public static void SavePng(RenderTexture RenderTextureRef,string savePath)
    {
 
        if(_tex == null){
            _tex = new Texture2D(
                RenderTextureRef.width,
                RenderTextureRef.height,
                TextureFormat.RGBA32,
                false
            );
        }

        Texture2D tex = _tex;

        RenderTexture.active = RenderTextureRef;
        //tex.ReadPixels(new Rect(0, 0, RenderTextureRef.width, RenderTextureRef.height), 0, 0);

        tex.ReadPixels(
            new Rect(0, 0, RenderTextureRef.width, RenderTextureRef.height), 0, 0
        );


        tex.Apply();
 
        // Encode texture into PNG
        byte[] bytes = tex.EncodeToPNG();
        //UnityEngine.Object.Destroy(tex);
 
        //yyyy/MM/dd HH:mm:ss

        //var d = DateTime.Now.ToString("MMdd_HHmmss");
        
        
        Debug.Log("SAVE " + savePath);

        //Write to a file in the project folder
        //File.WriteAllBytes(dir + "/" + filename +"_"+ d + ".png", bytes);
        File.WriteAllBytes(savePath, bytes);
 
    }
 
}