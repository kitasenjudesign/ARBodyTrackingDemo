using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using JPBotelho;

public class MouseUtil //: MonoBehaviour
{
    const int NUM = 110;
    public Vector3 position;
    private Vector3 oldPosition;
    private Vector3 oldTargetPos;
    public float rotation;
    public List<Vector3> positions;
    public List<Vector3> cpositions;//catmull
    public Vector3[] tangents;
    public List<float> rotations;
    private Bane _bane;
    public Vector3 velocity;
    private Transform _tgtTransform;
    private float _oldTime = 0;
    private bool _isLimit = false;
    private bool _isCatmull = true;
    private CatmullRom _catmull; 
    private int _catmullResolution=3;

    public MouseUtil(float speed, float masatsu, int catmullResolution,Transform tgtTransform = null)
    {
        _isLimit = false; //tgtTransform ? true : false;
        _catmullResolution = catmullResolution;
        if(_catmullResolution<=2) _isCatmull=false;


        //Debug.Log("isLimit " + _isLimit + " " + (tgtTransform==null) );

        _bane = new Bane(
            new Vector3( 
                speed + 0.1f * speed * (Random.value - 0.5f), 
                speed + 0.1f * speed * (Random.value - 0.5f), 
                speed + 0.1f * speed * (Random.value - 0.5f) 
            ),
            new Vector3( 
                masatsu + 0.1f * masatsu * (Random.value - 0.5f), 
                masatsu + 0.1f * masatsu * (Random.value - 0.5f), 
                masatsu + 0.1f * masatsu * (Random.value - 0.5f)
            )
        );

        velocity = Vector3.zero;
        position = Vector3.zero;
        
        positions = new List<Vector3>();
        for(int i=0;i<NUM;i++){
            positions.Add(Vector3.zero);
        }

        if(_isCatmull)_catmull = new CatmullRom(positions.ToArray(),_catmullResolution,false);
        

        tangents = new Vector3[NUM];
        
        rotations = new List<float>();
        oldPosition = Vector3.zero;
        oldTargetPos = Vector3.zero;
        _tgtTransform = tgtTransform;
    }

    public void SetTgt(Transform tgtTransform){
        _tgtTransform = tgtTransform;
    }

    public void SetSpeed(float speed, float masatsu){
        //_bane.speed = speed;
        //_bane.masatsu = masatsu;
    }

    public void Reset(){
        
    }

    // Update is called once per frame
    public void Update()
    {
        //Debug.Log("update!!! " + positions.Count);
        //最小のインターバルを設定する
        //if(Time.realtimeSinceStartup - _oldTime < 0.03f) return;
        _oldTime = Time.realtimeSinceStartup;

        //if( Input.GetKeyDown( KeyCode.B ) ){  
        //boost2
        //left btn click
        if( Input.GetMouseButtonDown(1) && !Input.GetKey(KeyCode.LeftShift) ){
            Vector3 kake = new Vector3(
                0.5f + 8f * ( Random.value - 0.5f ),
                0.5f + 8f * ( Random.value - 0.5f ),
                0.5f + 8f * ( Random.value - 0.5f )
            );

            if(_bane.v.magnitude<0.5f){
                _bane.addV.x = _bane.v.x * kake.x;
                _bane.addV.y = _bane.v.y * kake.y;
                _bane.addV.z = _bane.v.z * kake.z;
            }
        }

        if( Input.GetMouseButtonDown(0) && !Input.GetKey(KeyCode.LeftShift) ){

            if(_bane.v.magnitude<0.5f){
                float nn = 1.5f + 0.5f * Random.value;
                _bane.addV.x = _bane.v.x * nn;
                _bane.addV.y = _bane.v.y * nn;
                _bane.addV.z = _bane.v.z * nn;
            }

        }




        // Vector3でマウス位置座標を取得する
		var mousePos = Input.mousePosition;
        //Debug.Log("mousePos!!! " + mousePos);
       
		// Z軸修正
		mousePos.z = 0f;



		// マウス位置座標をスクリーン座標からワールド座標に変換する
		var screenToWorldPointPosition 
            = _tgtTransform!=null ? _tgtTransform.position : Camera.main.ScreenToWorldPoint(mousePos);


		// ワールド座標に変換されたマウス座標を代入
        //if(_tgtTransform==null){
            screenToWorldPointPosition.z *= Params.Instance.zMultiplier;//mouse:0 body:1
        //}


		position = _bane.Update( screenToWorldPointPosition );
       // Debug.Log("pos!!! " + screenToWorldPointPosition);
       


        //if(position == oldPosition) return;
        //if(screenToWorldPointPosition == oldTargetPos) return;
        
        oldTargetPos = screenToWorldPointPosition;
        

        //positionsをためている。
        rotation = Mathf.Atan2(
            position.y - oldPosition.y,
            position.x - oldPosition.x
        );

        velocity.x = position.x - oldPosition.x;
        velocity.y = position.y - oldPosition.y;
        
        if(_tgtTransform!=null) velocity.z = position.z - oldPosition.z;

        //Debug.Log(positions.Count);

        //どっちがいい？
        if( (velocity.magnitude > 0.1f && _isLimit) || !_isLimit){

            if(positions.Count>=NUM)positions.RemoveAt(positions.Count-1);
            positions.Insert(0,position);

            if(rotations.Count>=NUM)rotations.RemoveAt(rotations.Count-1);
            rotations.Insert(0,rotation);

        }

        if(_isCatmull){

            _catmull.Update( positions );
            //_catmull.Update( _catmullResolution, false );

        }
        
        oldPosition.x = position.x;
        oldPosition.y = position.y;
        oldPosition.z = position.z;

    }

    public Vector3 GetPoint(int idx){

        if(_isCatmull){
            return _catmull.GetPoints()[idx].position;
        }

        return positions[idx];
    }

    public int GetLength(){

         if(_isCatmull){
             return _catmull.GetPoints().Length;
         }

        return positions.Count;
    }


    //vectorが同じだと
    public void UpdateTangents(){

        for(int i=0;i<positions.Count-1;i++){
            
            var v = positions[i] - positions[i+1];
            tangents[i] = v;

        }

    }




}


