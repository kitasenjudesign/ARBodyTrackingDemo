using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class VelocityCalc{

    private Transform _tgt;
    private Vector3 _pastPos;
    public Vector3 velocity;

    public void Init(Transform t){
        
        velocity = Vector3.zero;
        _pastPos = Vector3.zero;

        _tgt = t;

    }

    public void AddVelocity(Vector3 v){
        
    }

    public void Update(){

        velocity = _tgt.position - _pastPos;
        _pastPos = _tgt.position;

    }


}