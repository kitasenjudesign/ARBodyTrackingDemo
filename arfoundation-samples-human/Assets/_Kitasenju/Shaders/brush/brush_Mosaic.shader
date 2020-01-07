// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "brush/brush_Mosaic" {  
    Properties {  
        _Color( "_Color", color) = (1,1,1,1)
        _MainTex ("Base (RGB)", 2D) = "white" {}  
        _MatrixWidth ("Dither Matrix Width/Height", int) = 4  
        _MatrixTex ("Dither Matrix", 2D) = "black" {}  
    }  
    SubShader {  
        Tags { "RenderType"="Opaque" }  
        LOD 200  
           
        CGPROGRAM  
        #pragma surface surf Lambert vertex:vert finalcolor:mycolor  
           
        sampler2D _MainTex;  
        int _MatrixWidth;  
        sampler2D _MatrixTex;  
        float4 _Color;

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
            half4 c = tex2D (_MainTex, IN.uv_MainTex);  
            o.Albedo = c.rgb;  
            o.Alpha = c.a;  
        }  
   
        void mycolor (Input IN, SurfaceOutput o, inout fixed4 color) {  
            // RGB -> HSV 変換  
            float value = max(color.r, max(color.g, color.b));  
               
            // スクリーン平面に対してマトリックステクスチャを敷き詰める  
            float2 uv_MatrixTex = IN.scrPos.xy / IN.scrPos.w * _ScreenParams.xy / _MatrixWidth;  
               
            //uv_MatrixTex = floor(uv_MatrixTex*50)/50;

            float threshold = tex2D(_MatrixTex, uv_MatrixTex).r;  
            fixed3 binary = ceil(value - threshold);  
            
            color.rgb = lerp(_Color, float3(1,1,0),binary);// * _Color;

            color.a = 1.0f;  
        }  
        ENDCG  
    }  
    FallBack "Diffuse"  
}  