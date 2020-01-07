using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DelayTest : MonoBehaviour
{
    [SerializeField] GameObject tgt;
    // Start is called before the first frame update
    void Start()
    {
        Invoke("_onStart",5f);
    }

    private void _onStart(){
        tgt.gameObject.SetActive(true);
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
