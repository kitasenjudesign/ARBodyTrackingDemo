Shader "toon/Toon" {
    Properties {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _RandomTex ("_RandomTex",2D) = "white"{}
        _RampTex ("Ramp", 2D) = "white"{}
    }
    SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 200
        cull off

        CGPROGRAM
        #pragma surface surf ToonRamp
        #pragma target 3.0


        sampler2D _MainTex;
        sampler2D _RampTex;
        sampler2D _RandomTex;

        struct Input {
            float2 uv_MainTex;
        };


        struct SurfaceOutputA {
            half3 Albedo;    // 拡散反射光（＝Diffuse）
            half3 Normal;    // 法線ベクトル
            half3 Emission;  // エミッション
            half Specular;   // スペキュラ
            half Gloss;      // 輝き
            half Alpha;      // 透過度
            float2 uv;
        };

        fixed4 _Color;

        fixed4 LightingToonRamp (SurfaceOutputA s, fixed3 lightDir, fixed atten)
        {
            fixed4 n = tex2D(_RandomTex, s.uv);

            half d = dot(s.Normal, lightDir)*0.5 + 0.5 + ((n.r-0.5)*0.1);//0-1
            d = saturate(d);
            fixed3 ramp = tex2D(_RampTex, fixed2(d, 0.5)).rgb;
            fixed4 c;

            c.rgb = fixed4(1.0,0,0,0);

            c.rgb = s.Albedo * _LightColor0.rgb * ramp;
            c.a = 0;

            return c;
        }

        void surf (Input IN, inout SurfaceOutputA o) {

            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.uv = IN.uv_MainTex;
            o.Albedo = c.rgb;
            o.Alpha = c.a;

        }
        ENDCG
    }
    FallBack "Diffuse"
}