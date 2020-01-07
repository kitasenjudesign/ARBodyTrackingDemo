﻿Shader "brush/Brush_ScreenPos" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_Amount ("_Amount", Range(0,5)) = 0.0
        _Size ("_Size", float) = 1.0
        
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		//#pragma surface surf Standard fullforwardshadows
		#pragma surface surf Standard addshadow vertex:vert

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
			float4 sPos;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;
		float _Amount;
        float _Naname;
        float _Size;

        void vert(inout appdata_full v, out Input o )
        {
            UNITY_INITIALIZE_OUTPUT(Input, o);
			
			//頂点をてきとうに、ごちゃごちゃする、ここではノーマル方向に値を足してる
			//v.vertex.xyz = floor( v.vertex.xyz * _Boxel ) / _Boxel;  //v.normal.xyz * _Amount;
            o.sPos = ComputeScreenPos(
                UnityObjectToClipPos(v.vertex)
			);
		}

		void surf (Input IN, inout SurfaceOutputStandard o) {

			
			//float2 uv = IN.sPos.xy/IN.sPos.w;
			//float aa = frac( _Naname*IN.sPos.x*2*1.6 ) - 0.5;
			//float bb = frac( _Naname*IN.sPos.y*2*0.9 ) - 0.5;

			//clip( aa * bb );

			//clip


			// Albedo comes from a texture tinted by color
            float2 uv = IN.sPos.xy/IN.sPos.w;

            fixed4 c1 = tex2D (_MainTex, uv) * _Color;

			fixed4 cA = tex2D (_MainTex, uv+c1.rg) * _Color;
			fixed4 cB = tex2D (_MainTex, uv+c1.gb) * _Color;
			fixed4 cC = tex2D (_MainTex, uv+c1.br) * _Color;

            fixed4 c = fixed4(cA.r,cB.g,cC.b,1);

			o.Albedo = c.rgb;
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}