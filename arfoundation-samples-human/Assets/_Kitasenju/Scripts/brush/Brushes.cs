using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Brushes : MonoBehaviour
{

    [SerializeField] private Brush _src;
    [SerializeField,Range(0,250)] private int _num;
    [SerializeField,Range(0,1f)] public float _widthRatio = 1f;
    [SerializeField] private Texture2D _colorTexture;
    [SerializeField] private Transform[] _tgtTransforms;
    //[SerializeField] private Material[] _materials;
    private int _colorTexIndex = 0;
    private int _matIndex = 0;

    [SerializeField,Range(0,10f)] private float _speed;
    [SerializeField,Range(0,1f)] private float _masatsu;

    private List<Brush> _brushes;
    // Start is called before the first frame update
    private bool _isInit = false;
    public static Brushes Instance;
    [SerializeField] private bool _autoPlay = false;
    [SerializeField] private bool _isNejireFix = false;
    private float _numRatio=0;
    private KeyCode[] _keys;
    [SerializeField] private List<Material> _materials;

    void Start()
    {

        _keys = new KeyCode[]{
            KeyCode.F1,
            KeyCode.F2,
            KeyCode.F3,
            KeyCode.F4,
            KeyCode.F5,
            KeyCode.F6,
            KeyCode.F12
        };

        //奥行きをどうするか
        Instance = this;
        if(_autoPlay) Init();
        
    }

    //任意の場所をリピートとか
    public void Init(Transform[] tgtTransforms = null ){

        Debug.Log("Brushes.Init " + _isInit);
        Instance = this;
        
        if(_isInit)return;
        _isInit=true;

        if(tgtTransforms!=null){
            _tgtTransforms = tgtTransforms;
        }

        //_isNejireFix = Params.Instance.isNejireFix;
        
        _brushes = new List<Brush>();
        for(int i=0;i<_num;i++){
            var n = Instantiate(_src,transform,false);
            var t = _tgtTransforms.Length==0 ? null : _tgtTransforms[i%_tgtTransforms.Length];

            float ratio = (float)i/(float)(_num-1);

            n.Init(t);
            n.transform.position　= new Vector3(
                0,
                (ratio-0.5f) * 0.3f,
                _tgtTransforms.Length==0 ? ratio : (ratio-0.5f) * 0.5f
            );

            n.SetMaterial(_materials[Mathf.FloorToInt(Random.value*_materials.Count)],null);

            _brushes.Add( n );
        }
        _src.gameObject.SetActive(false);

    }


    public void SetColorTexture(Texture2D colorTexture){
        _colorTexture = colorTexture;
    }

    public void SetTgtTransform(Transform[] tgtTransforms){

        Debug.Log("SetTgtTransform");
        Init();
        
        _tgtTransforms = tgtTransforms;
        
        for(int i=0;i<_num;i++){

            int idx = i%tgtTransforms.Length;
            
            _brushes[i].tgtTransformIdx = idx;
            _brushes[i].SetTgtTransfrom( tgtTransforms[idx] );
            _brushes[i].transform.position = new Vector3(0,0,0);

        }
        
    }


    public void SetNum(float ratio){

        //paramsのフラグをチェックし、表示非表示をあれする
        _numRatio = ratio;
        var showingNum = ratio * (float)_num;
        if( _brushes != null ){
            for(int i=0;i<_num;i++){
                if( i <= showingNum){
                    
                    var isShowing = Params.GetEnabled( _brushes[i].tgtTransformIdx );

                    if(isShowing) _brushes[i].gameObject.SetActive(true);
                    else _brushes[i].gameObject.SetActive(false);

                }else{
                    _brushes[i].gameObject.SetActive(false);
                }
            }
        }

    }


    public void SetLength(float ratio){

        for(int i=0;i<_num;i++){
            
            _brushes[i].brushLengthRatio = ratio;
            
        }

    }





    //ここを調整！！
    public void SetRandom( List<Material> materials, Texture2D mainTex){
        
        //Debug.Log("SetRandom!!");

        for(int i=0;i<_brushes.Count;i++){
  
            var randomMat = materials[ Mathf.FloorToInt( Random.value * materials.Count ) ];
            Debug.Log( randomMat.name );
            _brushes[i].SetMaterial( randomMat, mainTex );
            _brushes[i].SetConstantWidth(Random.value<0.5f);// = Random.value<0.5f;

        }

    }

    public void SetMaterial(Material mat, Texture2D mainTex){
        for(int i=0;i<_brushes.Count;i++){
            if(_brushes[i])_brushes[i].SetMaterial( mat, mainTex );
        }
    }

    public void SetConstantWidth(bool b){
        for(int i=0;i<_brushes.Count;i++){
            _brushes[i].SetConstantWidth(b);
        }
    }


    //ここ調整
    public void SetBoxel(bool b){
        
        for(int i=0;i<_brushes.Count;i++){
            if(b){
                _brushes[i].isBoxel = b;//(Random.value<0.3f) ? true : false;
            }else{
                _brushes[i].isBoxel = b;
            }
        }

    }


    // Update is called once per frame
    void Update()
    {
        if(!_isInit) return;

        //_isNejireFix = Params.Instance.isNejireFix;

        for(int i=0;i<_brushes.Count;i++){
            
            _brushes[i].SetNejireFix( _isNejireFix );
            _brushes[i].SetSpeed( _speed, _masatsu );
            _brushes[i].colorTex = _colorTexture;
            _brushes[i].brushWidthRatio = _widthRatio;

        }

        for(int i=0;i<_keys.Length;i++){

            if( Input.GetKeyDown( _keys[i] ) ){
                //Debug.Log("function!!!");
                //Params.ToggleEnableParts( i );
                //_UpdateVisible();
                
                Debug.Log("UPDATE num");
                Invoke("_updateNum",0.1f );
                
            }

        }

    }

    public void _updateNum(){
        SetNum(_numRatio);
    }

}
