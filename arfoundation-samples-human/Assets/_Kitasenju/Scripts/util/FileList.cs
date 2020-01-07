using UnityEngine;
using System.Collections;
using System.IO;

public class FileList
{
    public static string[] GetFiles(string path, string extension="*.png"){
        
        DirectoryInfo dir = new DirectoryInfo(path);
        FileInfo[] info = dir.GetFiles(extension);

        string[] files = new string[info.Length];
        int idx = 0;
        foreach(FileInfo f in info)
        {
            //Debug.Log(f.Name);
            files[idx] = f.Name;
            idx++;
        }
        return files;

    }
}