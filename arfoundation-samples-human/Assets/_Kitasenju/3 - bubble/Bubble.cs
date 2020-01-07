using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Bubble : MonoBehaviour
{
    private Material _mat;
    private MaterialPropertyBlock _block;
    private Vector3 _velocity;
    private MeshRenderer _renderer;
    private Vector3 _past;
    private Vector3 _baseScale;
    private Rigidbody _rigidbody;
    private bool _isDestroy = false;
    void Start()
    {
        
        
        _renderer = GetComponent<MeshRenderer>();
        //_velocity = Vector3.zero;

        _block = new MaterialPropertyBlock();
        _block.SetFloat("_Random",Random.value);
        _block.SetFloat("_Amount",0.02f);
        _renderer.SetPropertyBlock(_block);

        _baseScale = transform.localScale;
        transform.localScale = transform.localScale*0.3f;//Vector3.zero;
        transform.localRotation = Quaternion.Euler(
            360f * Random.value,
            360f * Random.value,
            360f * Random.value
        );
        _rigidbody = GetComponent<Rigidbody>();
        _rigidbody.AddForce(
            new Vector3(
                30.5f * (Random.value - 0.5f),
                30.5f * (Random.value - 0.5f),
                30.5f * (Random.value - 0.5f)
            ),ForceMode.Acceleration
        );

        Invoke("Hide",10f);
    }

    private void Hide(){
        gameObject.SetActive(false);
    }

    public void Destroy(){
        
        CancelInvoke("Hide");
        Destroy (gameObject);
        _isDestroy = true;

    }

    public void AddVelocity(Vector3 v){
        _rigidbody.AddForce(v,ForceMode.Force);
    }

    void Update()
    {
        if(_past==null){
            _past = transform.position;//new Vector3();
        }

        var d = transform.position - _past;

        var s = _rigidbody.velocity.magnitude*0.1f;//d.magnitude * 5f;
        if(s>0.2f) s = 0.2f;


        var t = transform.localScale;

        _block.SetFloat("_Amount",0.02f + s);
        _renderer.SetPropertyBlock(_block);
        _past = transform.position;

        
        t += ( _baseScale - t ) / 5f;
        transform.localScale = t;

    }

}
