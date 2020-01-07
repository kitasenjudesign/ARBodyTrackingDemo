using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO;

//全部のテクスチャを管理します

public class TextureManager : MonoBehaviour
{

    [SerializeField] private string[] _colors;
    [SerializeField] private Texture2D[] _textures;

    void Start(){
        Init();
    }

    //load suru
    public void Init(){
        
        //_loadFiles();

    }

    private void OnGUI()
    {
        //load simasu
        for(int i=0;i<_textures.Length;i++){

            GUI.DrawTexture(
                new Rect(0, 200f * (float)i, 200, 200), 
                _textures[i], 
                ScaleMode.StretchToFill,
                true
            ); 

        }
    }

    //一個戻る

    //load suruka
    private void _loadFiles(){

        _textures = new Texture2D[_colors.Length];
        for( int i=0; i<_colors.Length;i ++){
            var textureLoader = new TextureLoader();
            var filename = _colors[i];
            //Debug.Log(filename);
            var t = textureLoader.loadTexture(Paths.texturePath,filename);
            _textures[i] = t;
        }

        //loadし終わったら、ブラシに登録する
        //var brushes = Brushes.Instance;
        //brushes.SetTexture( _textures );

    }

}