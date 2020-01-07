using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rotater : MonoBehaviour
{
    [SerializeField] public Vector3 _spd;
    private Vector3 _rot = Vector3.zero;
    // Start is called before the first frame update
    public float spdScale = 1f;
    private float _random;
    void Start()
    {
        _random = 1f + 3f * Random.value;
    }

    // Update is called once per frame
    void Update()
    {
        var tgt = _rot + _spd * 3f * spdScale;
        _rot += _spd * 3f;//(tgt - _rot) / 10f;
        transform.rotation = Quaternion.Euler( _rot.x, _rot.y, _rot.z );
        
        /*
        var p = transform.localPosition;
        p.y = 0.2f * _spd.x * Mathf.Sin(Time.realtimeSinceStartup * _random * 0.1f);
        p.z = 0.1f * _spd.z * Mathf.Cos(Time.realtimeSinceStartup * _random * 0.1f);
        transform.localPosition = p;*/
    }
}