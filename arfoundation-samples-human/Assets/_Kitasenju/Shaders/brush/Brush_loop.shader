// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "brush/brush_loop" {  
    Properties {  

        _Color( "_Color", color) = (1,1,1,1)
        //_Color1( "_Color1", color) = (1,1,1,1)
        //_Color2( "_Color2", color) = (1,1,1,1)
        _MainTex ("Base (RGB)", 2D) = "white" {}  
        _ColorTex ("Base (RGB)", 2D) = "white" {}  

        _Loop ("_Loop", float) = 4  
        

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
        float _Loop;


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
            
            half4 c = _Color;// tex2D (_MainTex, IN.uv_MainTex);  
            o.Albedo = c.rgb;  
            o.Alpha = c.a;  

        }  
   
        //テクスチャから色を持ってくる！

        void mycolor (Input IN, SurfaceOutput o, inout fixed4 color) {  

            color.rgb = frac( color.rgb * _Loop );

        }  
        ENDCG  
    }  
    FallBack "Diffuse"  
}  