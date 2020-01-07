using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Brush : BrushBase
{

    private MouseUtil _mouse;
    [SerializeField] private Mesh _meshSrc;
    [SerializeField] private Mesh _mesh;
    [SerializeField] private Vector3[] _vertices;
    [SerializeField] private int[] _indices;
    [SerializeField,Range(0,360f)] private float _offsetRot;
    [SerializeField,Range(0,2f)] private float _brushWidth;
    private float _zRad = 0;
    private float _zRadSpd = 0;
    private　MaterialPropertyBlock _property;
    private Renderer _renderer;
    private Vector2 screenPos;
    public Texture2D colorTex;
    [SerializeField] private float _marume = 1f;
    public float brushWidthRatio = 1f;
    public float brushLengthRatio = 1f;
    [SerializeField] private float _alpha=0.3f;
    private bool _isNejireFix = true;
    [SerializeField] private float _boxel = 0.5f;
    public bool isBoxel = false;
    public float _speed = 0;
    public float _masatsu = 0;
    private bool _isConstantWidth = false;
    public int tgtTransformIdx = 0;
    private int _frame = 0;
    [SerializeField] private int _catmullResolution = 0;
    void Start()
    {
        //大きくしてみる
        _frame = Mathf.FloorToInt(Random.value*100f);
        _boxel=20f;//8f+4f*Random.value;
        //_alpha=0.3f;
    }

    public override void Init(Transform tgtTransform=null){

        //_marume = 10f;//Random.value * 3f;
       // if(Random.value<0.5f) _marume = 1000f;
        //Debug.Log("Init");
        _property = new MaterialPropertyBlock();
        _renderer = GetComponent<MeshRenderer>();

        _property.SetFloat("_ClipTh", 0.5f + Random.value * 0.4f );
        _property.SetFloat("_Naname", 30f + Random.value * 20f);


        _zRad = Random.value * Mathf.PI * 2f;
        _zRadSpd = Random.value * 0.3f;

        _mesh = MeshUtil.CloneMesh(_meshSrc,"test");
        //_mesh = MeshUtil.GetNewMesh(_mesh,MeshTopology.Lines);

        _catmullResolution = Mathf.FloorToInt( 3+2*Random.value ); //Params.Instance.catmullResolution;

        if(Random.value<0.2f) _catmullResolution=3;
        

        GetComponent<MeshFilter>().mesh = _mesh;
        
        //あとでやる
        /* 
        if(Params.Instance){
            _speed = 0.05f + Params.Instance.brushSpeedRandomness * Random.value;
            _masatsu = 0.1f + Params.Instance.brushMasatsuRandomness * Random.value;

        }else{
            _speed = 0.05f + 0.2f * Random.value;
            _masatsu = 0.1f + 0.8f * Random.value;
        }*/
        _speed = 0.02f + 0.10f * Random.value;
        _masatsu = 0.5f+0.45f*Random.value;      

        _mouse = new MouseUtil(
            _speed,//speed
            _masatsu,//masatsu
            _catmullResolution,
            tgtTransform
        );
        _brushWidth = 0.03f + 0.10f * Random.value;
        //if(Random.value<0.5f) _brushWidth = 0.02f + 0.07f * Random.value;
        //_vertices = _mesh.vertices;
        //_indices = _mesh.triangles;
        //Debug.Log(_mesh.vertexCount);
    }

    public override void SetTgtTransfrom(Transform tgtTransform=null){
        _mouse.SetTgt(tgtTransform);
    }

    public override void SetSpeed(float spd, float masatsu){
        //_mouse.SetSpeed(spd, masatsu);
    }

    public override void SetMaterial(Material mat, Texture mainTex){
        
        //_property.SetTexture("_MainTex", mainTex);
        _renderer.sharedMaterial = mat;

    }

    public void SetNejireFix(bool b){
        _isNejireFix = b;
    }

    public void SetConstantWidth(bool b){
        _isConstantWidth = b;
    }    

    // Update is called once per frame
    void Update()
    {
        if(_mesh==null)return;

        //仮
        if(Input.GetKeyDown(KeyCode.W)){
            _isConstantWidth=!_isConstantWidth;
        }

        _mouse.Update();

        int num = _mesh.vertexCount/2;//頂点の数、最大数
        //if( _mouse.positions.Count<=num)return;
        if( _mouse.GetLength()<=num)return;

        var forward = Camera.main.transform.forward;


        var v = _mesh.vertices;

        //長さを調整する
        float lenRatio = brushLengthRatio;//0.1f;//0.5f;
        int vertNum = Mathf.FloorToInt( num * lenRatio );

        for(int i=0;i<vertNum;i++){

            var r = 1f - (float)i / (float)(vertNum-1);

            //var rot = _mouse.rotations[i] + _offsetRot*Mathf.Deg2Rad;
            var pos = _mouse.GetPoint(i);//_mouse.positions[i];

            //random値を追加
            //pos.x += 0.3f * (Random.value - 0.5f);
            //pos.y += 0.3f * (Random.value - 0.5f);

            //ブラシの太さ、瞬間の速度で太さが変えている
            var vv = _mouse.velocity.magnitude * 8f;
            if(vv>1f) vv=1f;
            var w = vv * _brushWidth * Mathf.Sin(r*Mathf.PI) * brushWidthRatio;

            //一定かどうか
            if(_isConstantWidth)w = _brushWidth * brushWidthRatio;

            //奇跡の方向
            Vector3 current     = _mouse.GetPoint(i);//_mouse.positions[ i ];
            Vector3 next        = _mouse.GetPoint(i+1);//_mouse.positions[ i+1 ];
            Vector3 dir         = current - next;

            if(_isNejireFix){
                dir.x = Mathf.Abs(dir.x);
                dir.y = Mathf.Abs(dir.y);
                dir.z = Mathf.Abs(dir.z);
            }

            //カメラの正面ベクトルと、方向ベクトルに直行するベクトルを取得
            var dir1 = Vector3.Cross( forward, dir ).normalized;
            var dir2 = -Vector3.Cross( forward, dir ).normalized;
            Vector3 v1 = dir1*w;
            Vector3 v2 = dir2*w;

            //ちょっとねじれないように処理を入れてみるテスト
            //var yy1 = pos.y + v1.y;//,pos.y + v2.y );
            //var yy2 = pos.y + v2.y;

            //if(isNejireFix){
            //    yy1 = Mathf.Min( pos.y + v1.y,pos.y + v2.y );
            //    yy2 = Mathf.Max( pos.y + v1.y,pos.y + v2.y );                
            //}

            //長さを
            
            v[i+0].x = pos.x + v1.x;
            v[i+0].y = pos.y + v1.y;
            v[i+0].z = pos.z + v1.z;

            v[i+num].x = pos.x + v2.x;
            v[i+num].y = pos.y + v2.y;
            v[i+num].z = pos.z + v2.z;
                

        }

        
        if(isBoxel){
            
            for(int i=0;i<num;i++){

                //if( i<num*0.5f ){
                    
                    var boxel = _boxel * (1f-brushWidthRatio);// * (1f+_mouse.velocity.magnitude*30f);//0.5f;
                    var nobasu = _mouse.velocity.magnitude*30f + 1f;

                    v[i+0].x = Mathf.Floor( v[i+0].x * boxel ) / boxel;
                    v[i+0].y = Mathf.Floor( v[i+0].y * boxel ) / boxel;
                    v[i+0].z = Mathf.Floor( v[i+0].z * boxel ) / boxel;

                    v[i+num].x =  (Mathf.Ceil( v[i+num].x * boxel ) ) / boxel;
                    v[i+num].y =  (Mathf.Ceil( v[i+num].y * boxel ) ) / boxel;
                    v[i+num].z =  (Mathf.Ceil( v[i+num].z * boxel ) ) / boxel;
                    //v[i+num].z = v[i+0].z;//(Mathf.Ceil( v[i+num].z * boxel ) ) / boxel;

                //}

            }

        }

        //消す
        var lastPos =_mouse.GetPoint(vertNum-2);// _mouse.positions[vertNum-2];
        for(int i=vertNum-1; i<num; i++){
            
            var pos = lastPos;
            v[i+0].x = pos.x;
            v[i+0].y = pos.y;
            v[i+0].z = pos.z;
            v[i+num].x = pos.x;
            v[i+num].y = pos.y;
            v[i+num].z = pos.z;

        }

        _zRad+=_zRadSpd;
        _mesh.vertices=v;
        if(_frame%2==0 && !isBoxel){
            _mesh.RecalculateNormals();
            _mesh.RecalculateTangents();

        }
        
        int idx = 0;//Mathf.FloorToInt(v.Length/2f);
        screenPos = RectTransformUtility.WorldToScreenPoint (Camera.main, v[ idx ]);
        screenPos.x /= Screen.width;
        screenPos.y /= Screen.height;

        //色の取得
        Color col = Color.red;
        if( colorTex ){
            /*
            var ww = colorTex.width;
            var hh = colorTex.height;
            col = colorTex.GetPixel(
                Mathf.FloorToInt( screenPos.x * ww * 0.999f ),
                Mathf.FloorToInt( screenPos.y * hh * 0.999f )
            );
            col.a = 0.5f;//_alpha;
            */
            _property.SetTexture("_ColorTex", colorTex);
        }

        _property.SetVector("_Color",col);
        
        _property.SetVector("_EmissionColor",col*0.5f);//暗くなりすぎないように
        _renderer.SetPropertyBlock(_property);

        _frame++;

    }


}


