using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Bane //: MonoBehaviour
{

    private Vector3 position;
    public Vector3 v;

    public Vector3 speed = new Vector3( 0.1f, 0.1f, 0.1f );
    public Vector3 masatsu = new Vector3(0.9f,0.9f,0.9f);
    public Vector3 addV = Vector3.zero;

    public Bane(Vector3 spd,Vector3 mst)
    {
        position    = Vector3.zero;
        v           = Vector3.zero;
        speed = spd;
        masatsu = mst;
    }

    public Vector3 Update(Vector3 tgt){

        
        //ターゲットと現状の位置の差分をか速度に
        var a = tgt - position;

        //差分の何割をか加速度にするか
        a.x *= speed.x;
        a.y *= speed.y;
        a.z *= speed.z;

        
        //追加でブーストさせるか
        a += addV;
        addV *= 0;

        v.x *= masatsu.x;//摩擦、抗力、無限に増えるのを冴える
        v.y *= masatsu.y;//摩擦、抗力、無限に増えるのを冴える
        v.z *= masatsu.z;//摩擦、抗力、無限に増えるのを冴える

        //か速度を、速度に足す
        v += a;

        position += v;

        return position;
        

    }


}