Shader "brush/Brush2_Boxel" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}

        _MainTex2 ("_MainTex2", 2D) = "white" {}		
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_Amount ("_Amount", Range(0,5)) = 0.0
        _Boxel ("_Boxel", float) = 1.0
        _VertOffset ("_VertOffset", float) = 0.01
		_Emission ("_Emission", Range(0,1)) = 0.5

        _ClipTh("_ClipTh",float) = 1		
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		//cull off

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		//#pragma surface surf Standard fullforwardshadows
		#pragma surface surf Standard addshadow vertex:vert

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _MainTex2;

		struct Input {
			float2 uv_MainTex;
			fixed facing : VFACE;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;
		float _Amount;
        float _Boxel;
		float _VertOffset;
		float _Emission;
        float _ClipTh;

		float rand(float2 co){
			return frac(sin(dot(co.xy ,float2(12.9898,78.233))) * 43758.5453);
		}

		float4 getNewVertPosition( float4 v, float4 uv )
		{
			if(uv.y>0.5){
				v.xyz = floor( v.xyz * _Boxel ) / _Boxel;
			}else{
				v.xyz = ceil( v.xyz * _Boxel ) / _Boxel;
			}
			return v;
		}

		/**
			struct appdata_full {
				float4 vertex : POSITION;
				float4 tangent : TANGENT;
				float3 normal : NORMAL;
				float4 texcoord : TEXCOORD0;
		**/

        void vert(inout appdata_full v, out Input o )
        {
            UNITY_INITIALIZE_OUTPUT(Input, o);
			
			//v.vertex.x += step(0.5,v.texcoord.y) / _Boxel * 0.1;
			//v.vertex.y += step(0.5,v.texcoord.y) / _Boxel * 0.1;
			//v.vertex.z += step(0.5,v.texcoord.y) / _Boxel * 0.1;

			float4 vertPosition = getNewVertPosition( v.vertex, v.texcoord );

			// calculate the bitangent (sometimes called binormal) from the cross product of the normal and the tangent
			float4 bitangent = float4( cross( v.normal, v.tangent ), 0 );

			// how far we want to offset our vert position to calculate the new normal
			float vertOffset = _VertOffset;

			float4 v1 = getNewVertPosition( v.vertex + v.tangent, v.texcoord  );// vertOffset );
			float4 v2 = getNewVertPosition( v.vertex + bitangent, v.texcoord  );// vertOffset );

			// now we can create new tangents and bitangents based on the deformed positions
			float4 newTangent = v1 - vertPosition;
			float4 newBitangent = v2 - vertPosition;

			// recalculate the normal based on the new tangent & bitangent
            v.normal = cross( newTangent, newBitangent );
            
			v.vertex = vertPosition;

		}

/*
https://gist.github.com/sugi-cho/efd860f4c744d617f54a
#今日のまとめ(7/23) ##オブジェクト空間からワールド空間での各値を求める。

fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);
fixed3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
fixed3 worldBinormal = cross(worldNormal, worldTangent) * v.tangent.w;
*/

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;

            fixed4 c2 = tex2D (_MainTex2, IN.uv_MainTex);

            //かすれを表現
            //clip(  Luminance(c2.xyz) - _ClipTh );

            o.Albedo = c.rgb * (1-_Emission);
            o.Emission = c.rgb * _Emission;
			
			//ここのあれ
			
			// Metallic and smoothness come from slider variables
			//o.Normal = 
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;

		}
		ENDCG
	}
	FallBack "Diffuse"
}