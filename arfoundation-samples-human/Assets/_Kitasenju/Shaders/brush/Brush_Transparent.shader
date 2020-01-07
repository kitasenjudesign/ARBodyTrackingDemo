Shader "brush/Brush_Transparent" {

    Properties {
        _Color ("Color", Color) = (1,1,1,1)        
        _MainTex ("Base (RGB)", 2D) = "white" {}
    }
    SubShader {
        Tags {
            "Queue" = "Transparent"
            "RenderType" = "Transparent"
        }
        CGPROGRAM
        #pragma surface surf Lambert alpha

        fixed4 _Color;
        sampler2D _MainTex;

        struct Input {
        float2 uv_MainTex;
        };

        void surf(Input IN, inout SurfaceOutput o) {
            half4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;

            o.Albedo = fixed3(0,0,0);

            //o.Albedo = c.rgb * (1-_Emission);
            o.Emission = c.rgb;//c.rgb * _Emission;

            o.Alpha  = 0.5;
        }
        ENDCG
    }

}
