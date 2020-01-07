using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BrushBase : MonoBehaviour
{


    public virtual void Init(Transform tgtTransform=null){

    }

    public virtual void SetTgtTransfrom(Transform tgtTransform=null){

    }

    public virtual void SetSpeed(float spd, float masatsu){
        //_mouse.SetSpeed(spd, masatsu);
    }

    public virtual void SetMaterial(Material mat, Texture mainTex){
      
    }

}