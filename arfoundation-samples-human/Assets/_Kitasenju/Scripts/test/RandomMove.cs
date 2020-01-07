using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RandomMove : MonoBehaviour
{

    private Vector3 tgtPos;

    // Start is called before the first frame update
    void Start()
    {
        tgtPos = new Vector3();

    }

    // Update is called once per frame
    void Update()
    {
        
        if( Random.value < 0.05f ){

            tgtPos.x = 10f * (Random.value - 0.5f);
            tgtPos.y = 10f * (Random.value - 0.5f);
            tgtPos.z = 10f * (Random.value - 0.5f);

        }

        var p = transform.position;
        p.x += (tgtPos.x - p.x) / 10f;
        p.y += (tgtPos.y - p.y) / 10f;
        p.z += (tgtPos.z - p.z) / 10f;
        transform.position = p;


    }
}
