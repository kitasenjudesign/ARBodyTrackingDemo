using System.Collections;
using System.Collections.Generic;
using UnityEngine;



public class MeshUtil {

    public static Mesh CloneMesh(Mesh m, string name ){
        
        var mesh = new Mesh();
        mesh.name = name;
        mesh.vertices = m.vertices;
        mesh.uv = m.uv;
        mesh.SetIndices(m.triangles, MeshTopology.Triangles,0 );
        return mesh;

    }



	public static Mesh GetNewMesh(Mesh m, MeshTopology topo) {
        
        var mesh = new Mesh();
        mesh.vertices = m.vertices;
        mesh.SetIndices(MakeIndices(m.triangles), topo, 0);
		mesh.name = "test";
		return mesh;

	}

	private static int[] MakeIndices(int[] triangles)
	{
		int[] indices = new int[2 * triangles.Length];
		int i = 0;
		for( int t = 0; t < triangles.Length; t+=3 )
		{
			indices[i++] = triangles[t];		//start
			indices[i++] = triangles[t + 1];	//end
			indices[i++] = triangles[t + 1];	//start
			indices[i++] = triangles[t + 2];	//end
			indices[i++] = triangles[t + 2];	//start
			indices[i++] = triangles[t];		//end
		}
		return indices;
	}



}
