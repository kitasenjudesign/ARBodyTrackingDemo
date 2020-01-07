using UnityEngine;

[ExecuteInEditMode]
public class NormalHelper : MonoBehaviour {

    public float length = 1;
    [SerializeField] private bool _isNormal = false;
    [SerializeField] private bool _isTangent = false;
   // [SerializeField] private bool _isBiNormal = false;

    public Vector3 bias;

    void Update() {


        var meshFilt = GetComponent<MeshFilter>();
        if (meshFilt == null) return;

        var mesh = meshFilt.sharedMesh;

        Vector3[] vertices = mesh.vertices;
        Vector3[] normals = mesh.normals;
        Vector4[] tangent = mesh.tangents;

        for (var i = 0; i < normals.Length; i++)
        {

            Vector3 pos = vertices[i];
            pos.x *= transform.localScale.x;
            pos.y *= transform.localScale.y;
            pos.z *= transform.localScale.z;
            pos += transform.position + bias;

            //normal
            if(_isNormal){
                Debug.DrawLine
                (
                    pos,
                    pos + normals[i] * length, 
                    Color.red
                );
            }

            //ついでにtangentも可視化
            if(_isTangent){
                var tan = new Vector3( 
                    tangent[i].x,
                    tangent[i].y,
                    tangent[i].z
                );

                Debug.DrawLine
                (
                    pos,
                    pos + tan * length, 
                    Color.blue
                );
            
                var binormal = Vector3.Cross(normals[i],tan).normalized;
                Debug.DrawLine
                (
                    pos,
                    pos + binormal * length, 
                    Color.green
                );
            }



        }

    }
}