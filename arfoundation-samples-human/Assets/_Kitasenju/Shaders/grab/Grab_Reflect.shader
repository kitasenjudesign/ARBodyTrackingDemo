Shader "grab/Refraction"
{
    Properties
    {
        _RefractionIndex("Refraction Index", Range(1.0, 3.0)) = 1.33
        _Distance("Distance", Float) = 10.0
        _Tint("Tint", Color) = (0.8, 0.5, 0.5)
        _SpecularColor ("Specular Color", Color) = (1, 1, 1)
        _Shiness ("Shiness", Float) = 10.0
    }
    SubShader
    {
        Tags {
            "RenderType" = "Transparent"
            "Queue" = "Transparent"
        }

        GrabPass
        {
            "_BackgroundTexture"
        }

        Pass
        {
            Tags {"LightMode" = "ForwardBase"}

            ZWrite Off
            cull off

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            struct appdata
            {
                float4 pos : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 worldPos : TEXCOORD0;
                float3 normal : TEXCOORD1;
            };

            float _RefractionIndex;
            float _Distance;
            float3 _Tint;
            float3 _SpecularColor;
            float _Shiness;
            sampler2D _BackgroundTexture;

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.pos);
                o.worldPos = mul(unity_ObjectToWorld, v.pos).xyz;
                o.normal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            float schlickFresnel(float cosine) {
                float r0 = (1 - _RefractionIndex) / (1 + _RefractionIndex);
                r0 = r0 * r0;
                return r0 + (1 - r0) * pow(1 - cosine, 5);
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 normal = normalize(i.normal);
                float3 viewDir = normalize(i.worldPos - _WorldSpaceCameraPos.xyz);

                float3 reflectDir = reflect(viewDir, normal);
                float3 reflectCol = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, reflectDir);

                float3 refractDir = refract(viewDir, normal, 1.0 / _RefractionIndex);
                float3 refractPos = i.worldPos + refractDir * _Distance;
                float4 refractScreenPos = mul(UNITY_MATRIX_VP, float4(refractPos, 1.0));
                float2 screenUv = (refractScreenPos.xy / refractScreenPos.w) * 0.5 + 0.5;
                #if UNITY_UV_STARTS_AT_TOP
                screenUv.y = 1.0 - screenUv.y;
                #endif

                float3 refractCol = tex2D(_BackgroundTexture, screenUv).xyz;
                float3 spec = pow(max(0.0, dot(normalize(_WorldSpaceLightPos0.xyz), reflectDir)), _Shiness) * _SpecularColor * _LightColor0;

                float f = schlickFresnel(max(0.0, dot(-viewDir, normal)));

                float3 c = (1.0 - f) * refractCol * _Tint + f * (reflectCol + spec);

                return float4(c, 1.0);
            }
            ENDCG
        }
    }
}