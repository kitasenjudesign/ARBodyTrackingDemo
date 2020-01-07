using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BubbleGen : MonoBehaviour
{

    [SerializeField] private Bubble _prefab;
    private List<Bubble> _list;
    public Transform[] targets;
    private List<VelocityCalc> _velocities;
    // Start is called before the first frame update
    void Start()
    {
    
        _list = new List<Bubble>();
        //_Gen();

    }

    /*
    void OnGUI()
    {
        if (GUI.Button(new Rect(10, 10, 150, 100), "" + Camera.main.fieldOfView))
        {
            //print("You clicked the button!");
        }
    }*/

    private void _Gen(Vector3 tgt){
            
        var n = Instantiate( _prefab,transform,false );
        n.gameObject.SetActive(true);
        n.transform.localRotation = Quaternion.Euler(
            360f * Random.value,
            360f * Random.value,
            360f * Random.value
        );
        var p = transform.position;
        var ss = Random.value * 0.5f + 0.05f;
        n.transform.localScale = new Vector3(ss,ss,ss);
        n.transform.position = tgt;

        _list.Add(n);

        if(_list.Count>100){
            //destroy
            _list[0].Destroy();
            _list.RemoveAt(0);

        }

        //Invoke("_Gen",0.1f);

    }

    void Update(){

        if(targets!=null && targets.Length>0){
            if(_velocities==null){
                _velocities = new List<VelocityCalc>();
                for(int i=0;i<targets.Length;i++){
                    
                    var n = new VelocityCalc();
                    n.Init( targets[i] );
                    _velocities.Add(n);

                }
            }
        }

        //
        if(_velocities!=null){

            for(int i=0;i<_velocities.Count;i++){
                
                _velocities[i].Update();
                if( _velocities[i].velocity.magnitude > 0.04f ){
                    _Gen( targets[i].position );
                }

                for(int j=0;j<_list.Count;j++){

                    var d = 
                    _list[j].transform.position - targets[i].position;
                    var d1 = d.normalized;

                    var d2 = _velocities[i].velocity.normalized;

                    var d3 = d1 * 2 + d2;

                    //とおいほど
                    var ff = 1f - d.magnitude / 1.5f;
                    if(ff<0)ff = 0;


                    d3 *= _velocities[i].velocity.magnitude * 4f * ff;

                    _list[j].AddVelocity( d3 );

                }

            }


        }

    }

}
