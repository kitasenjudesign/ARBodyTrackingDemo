// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "brush/brush_randDhiza" {  
    Properties {  

        _Color( "_Color", color) = (1,1,1,1)
        //_Color1( "_Color1", color) = (1,1,1,1)
        //_Color2( "_Color2", color) = (1,1,1,1)
        _MainTex ("Base (RGB)", 2D) = "white" {}  
        _ColorTex ("Base (RGB)", 2D) = "white" {}  

        _Size ("_Size", float) = 4  
        

    }  
    SubShader {  
        Tags { "RenderType"="Opaque" }  
        LOD 200  
        cull off
           
        CGPROGRAM  
        #pragma surface surf Lambert vertex:vert finalcolor:mycolor  
           
        sampler2D _MainTex;  
        sampler2D _ColorTex;        
        
        int _MatrixWidth;  
        sampler2D _MatrixTex;  
        
        float4 _Color;
        float _Size;


        struct Input {  
            float2 uv_MainTex;  
            float4 scrPos;  
        };  
   
        void vert (inout appdata_full v, out Input o) {  
            UNITY_INITIALIZE_OUTPUT(Input,o);  
            float4 pos = UnityObjectToClipPos (v.vertex);  
            o.scrPos = ComputeScreenPos(pos);  
        }  
   
        void surf (Input IN, inout SurfaceOutput o) {  
            
            half4 c = _Color * tex2D (_MainTex, IN.uv_MainTex);  
            o.Albedo = c.rgb;  
            o.Alpha = c.a;  

        }  
   
		float rand(float2 co){
			return frac(sin(dot(co.xy ,float2(12.9898,78.233))) * 43758.5453);
		}   
        //テクスチャから色を持ってくる！

        void mycolor (Input IN, SurfaceOutput o, inout fixed4 color) {  


            //float2 uvv = floor( IN.uv_MainTex * _Size ) / _Size;

           

            float2 uvv = floor(  IN.scrPos.xy / IN.scrPos.w * _ScreenParams.xy * _Size ) / _Size;


            color.r = step(rand(uvv),color.r);
            color.g = step(rand(uvv),color.g);
            color.b = step(rand(uvv),color.b);

            if( length(color.rgb) == 0 ){
                clip(-1);
            }

        }  
        ENDCG  
    }  
    FallBack "Diffuse"  
}  