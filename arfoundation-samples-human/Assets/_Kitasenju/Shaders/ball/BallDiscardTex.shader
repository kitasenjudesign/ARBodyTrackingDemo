﻿Shader "ball/BallDiscardTex"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _DiscardTex ("_DiscardTex", 2D) = "white" {}
        _NormalTex ("_NormalTex", 2D) = "black" {}

        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _Emission ("_Emission",float) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        #include "../noise/SimplexNoise3D.hlsl"

        sampler2D _MainTex;
        sampler2D _NormalTex;

        sampler2D _DiscardTex;
        struct Input
        {
            float2 uv_MainTex;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
        float _Emission;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D ( 
                _MainTex, 
                float2( frac(_Time.x) ,0.5 ) 
            );
            fixed4 d = tex2D ( 
                _DiscardTex, 
                frac( IN.uv_MainTex + _Time.z*10 )
            );
            clip( 0.5 - d.x );
            
            o.Albedo = c.rgb * (1-_Emission);
            o.Emission = c.rgb * _Emission;

            // Metallic and smoothness come from slider variables
            //o.Normal = d * 0.1;

            float3 normalA = UnpackNormal (tex2D (_NormalTex, IN.uv_MainTex));
            o.Normal = normalA*3;

            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
