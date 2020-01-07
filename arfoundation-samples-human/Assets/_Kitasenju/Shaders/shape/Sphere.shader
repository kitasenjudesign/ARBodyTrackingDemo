// Upgrade NOTE: upgraded instancing buffer 'Props' to new syntax.

Shader "shape/Sphere" {
    Properties {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _Emission ("Emission",Range(0,1)) = 0.0
    }
    SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 200
        cull off
        ZWrite On

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard addshadow vertex:vert

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input {
            float2 uv_MainTex;
            float4 sPos;
            float isClip;
        };

        half _Glossiness;
        half _Metallic;
        //fixed4 _Color;
        float _Emission;

        //float _params[16];

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            UNITY_DEFINE_INSTANCED_PROP(fixed4, _Color) // Make _Color an instanced property (i.e. an array)
#define _Color_arr Props
        UNITY_INSTANCING_BUFFER_END(Props)

    
        void vert(inout appdata_full v, out Input o )
        {
            UNITY_INITIALIZE_OUTPUT(Input, o);
            
            UNITY_SETUP_INSTANCE_ID (v);

           
            o.sPos = ComputeScreenPos(
                UnityObjectToClipPos( float3(0,0,0) )
                //UnityObjectToClipPos(v.vertex)
                //mul( ,float3(0,0,0))
            );

			//v.vertex = vertPosition;
            //float4 vertPosition = getNewVertPosition( v.vertex );
            //v.vertex = vertPosition;
            //v.vertex.xyz += snoise( v.vertex.xyz*_Detail + _Time.y ) * _Amount;
        }

        void surf (Input IN, inout SurfaceOutputStandard o) {

            // Albedo comes from a texture tinted by color
            float2 uv = IN.sPos.xy;//IN.screenPos.w;
            //clip (frac((IN.worldPos.y*_Clip+IN.worldPos.x*_Clip+IN.worldPos.z*_Clip) * 5 + _Time.y) - 0.5 + _IsClip);
            //clip (frac((IN.worldPos.y*_Clip) * 5) - 0.5 + _IsClip);
            fixed4 col = UNITY_ACCESS_INSTANCED_PROP(_Color_arr, _Color);
            //fixed4 c = tex2D( _MainTex, uv);
            fixed4 c = col;
            /*tex2D ( 
                _MainTex, 
                float2( frac(_Time.x) ,0.5 ) 
            );*/

            //fixed4 c = tex2Dproj( _MainTex, IN.screenPos);
            
            o.Albedo = c.rgb * (1-_Emission);
            o.Emission = c.rgb * _Emission;

            //c.r *= 2;
            //o.Albedo = c.rgb;
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}