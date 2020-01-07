using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using JPBotelho;

public class CatmullTest : MonoBehaviour
{

    [SerializeField] private GameObject[] _gameObjects;
    [SerializeField] private Vector3[] _points;
    private CatmullRom _catmull;
    private int resolution = 3;


    // Start is called before the first frame update
    void Start()
    {
        _points = new Vector3[_gameObjects.Length];
        for(int i=0;i<_gameObjects.Length;i++){
            _points[i] = _gameObjects[i].transform.position;
        }
        _catmull = new CatmullRom(_points,resolution,false);
        Debug.Log( _catmull.GetPoints().Length );
    }

    void Update(){

        if(_catmull != null)
        {
            
            //_catmull.Update(_points);
            _catmull.Update(resolution, false);
            //Debug.Log( _catmull.GetPoints().Length );
            _catmull.DrawSpline(Color.white);

        }

    }
}
