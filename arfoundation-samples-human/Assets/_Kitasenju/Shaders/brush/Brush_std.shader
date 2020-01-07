Shader "brush/Brush_std"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)

        _MainTex ("_MainTex", 2D) = "white" {}
        _MainTex2 ("_MainTex2", 2D) = "white" {}
        _NormalTex ("_NormalTex", 2D) = "white" {}
        _NormalTex2 ("_NormalTex2", 2D) = "black" {}

        _ClipTh("_ClipTh",float) = 1
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _Normal("_Normal", Range(0,1)) = 1
        _MixNormal("_MixNormal",Range(0,1)) = 0.5

        _Emission("_Emission", float) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200
        cull off
        //ZWrite Off//test

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _MainTex2;
        sampler2D _NormalTex;
        sampler2D _NormalTex2;


        struct Input
        {
            float2 uv_MainTex;
            fixed facing : VFACE;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
        float _ClipTh;
        float _Normal;
        float _MixNormal;
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
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            fixed4 c2 = tex2D (_MainTex2, IN.uv_MainTex);

            //かすれを表現
            //clip(  Luminance(c2.rgb) - _ClipTh );

            float3 normalA = UnpackNormal (tex2D (_NormalTex, IN.uv_MainTex));
            float3 normalB = UnpackNormal (tex2D (_NormalTex2, IN.uv_MainTex));


            float3 normal = lerp( normalA, normalB, _MixNormal );
            normal.z *= IN.facing; // flip Z based on facing
            //normal = dot(IN.viewDir, float3(0, 0, 1)) > 0 ? normal : -normal;


            //o.Albedo = c.rgb;
            o.Albedo = c.rgb * (1-_Emission);
            o.Emission = c.rgb * _Emission;


            o.Normal = lerp( float3(1,1,1), normal, _Normal);//normal 1to aida 
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
