Shader "effect/MotionVectorDisplaceEffect"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Strength ("_Strength", float) = 0.01

    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
            sampler2D _GlobalMotionVectorTex;
               
            float _Strength;

            half4 frag (v2f i) : SV_Target
            {
                half4 tex = tex2D(_GlobalMotionVectorTex, i.uv);
                fixed4 col = tex2D(_MainTex, i.uv + tex.rg * _Strength );
                //col.rgb = lerp(col.rgb,float3(0.9,0.9,0.9),0.05);
                //col.a=0.99;

                return col;
            }
            ENDCG
        }
    }
}
