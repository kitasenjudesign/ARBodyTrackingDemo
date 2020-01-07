using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO;
using UnityEngine.Experimental.Rendering;

public class TextureLoader
{

    //http://rikoubou.hatenablog.com/entry/2016/02/01/212504

    public TextureLoader(){

        //仮に３種類

    }

    public Texture2D loadTexture( string dir, string file, System.Action callback=null){
        

        var t = readByBinary( readPngFile(dir + file) );
        return t;

    }


    public byte[] readPngFile(string path) {
        

        using (FileStream fileStream = new FileStream (path, FileMode.Open, FileAccess.Read)) {
            BinaryReader bin = new BinaryReader (fileStream);
            byte[] values = bin.ReadBytes ((int)bin.BaseStream.Length);
            bin.Close ();
            return values;
        }

    }

    public Texture2D readByBinary(byte[] bytes) {
        Texture2D texture = new Texture2D (
            1024, 
            1024//, 
            //GraphicsFormat.R8G8B8A8_SRGB
        );
        texture.filterMode = FilterMode.Point;

        //Debug.Log( texture.format );//rgba32
        //texture.format
        texture.LoadImage (bytes);
        //texture.isReadable

        return texture;
    }

}