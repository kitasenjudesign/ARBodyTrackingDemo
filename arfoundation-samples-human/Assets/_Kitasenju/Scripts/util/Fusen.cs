using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Fusen : MonoBehaviour {
	
	#if UNITY_EDITOR
	[SerializeField, MultilineAttribute (2)]
    string message;
	#endif

}