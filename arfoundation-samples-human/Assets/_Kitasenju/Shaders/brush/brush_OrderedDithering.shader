// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "brush/brush_OrderedDithering" {  
    Properties {  

        _Color( "_Color", color) = (1,1,1,1)
        //_Color1( "_Color1", color) = (1,1,1,1)
        //_Color2( "_Color2", color) = (1,1,1,1)
        _MainTex ("Base (RGB)", 2D) = "white" {}  
        _ColorTex ("Base (RGB)", 2D) = "white" {}  

        _MatrixWidth ("Dither Matrix Width/Height", int) = 4  
        _MatrixTex ("Dither Matrix", 2D) = "black" {}  

    }  
    SubShader {  
        Tags { "RenderType"="Opaque" }  
        LOD 200  
           
        CGPROGRAM  
        #pragma surface surf Lambert vertex:vert finalcolor:mycolor  
           
        sampler2D _MainTex;  
        sampler2D _ColorTex;        
        
        int _MatrixWidth;  
        sampler2D _MatrixTex;  
        
        float4 _Color;
        float4 _Color1;
        float4 _Color2;


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

            float4 col1 = tex2D(_ColorTex, float2(frac( 0.25+_Time.y ), 0.5) );// _Color1;
            float4 col2 = tex2D(_ColorTex, float2(frac( 0.75+_Time.y ), 0.5) );// _Color2;

//            float4 col1 =  
//            float4 col2 =

            // RGB -> HSV 変換  
            float value = max(color.r, max(color.g, color.b));
            //value = frac( value * 10 );  
               
            // スクリーン平面に対してマトリックステクスチャを敷き詰める  
            float2 uv_MatrixTex = IN.scrPos.xy / IN.scrPos.w * _ScreenParams.xy / _MatrixWidth;  
               

            float threshold = tex2D(_MatrixTex, uv_MatrixTex).r;  
            fixed3 binary = ceil(value - threshold);  
            
            //color.rgb = lerp(_Color, float3(1,1,0),binary);// * _Color;
            //color.rgb = lerp(color, float3(1,1,0),binary);
            color.rgb = lerp(col1, col2, binary);


            color.a = 1.0f;  
        }  
        ENDCG  
    }  
    FallBack "Diffuse"  
}  