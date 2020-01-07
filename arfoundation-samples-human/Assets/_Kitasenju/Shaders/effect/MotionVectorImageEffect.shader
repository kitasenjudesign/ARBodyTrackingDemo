Shader "effect/MotionVectorImageEffect"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Dist("_Dist",float) = 0.004
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
            sampler2D _CameraMotionVectorsTexture;
            float4 _CameraMotionVectorsTexture_TexelSize;            
            float _Dist;
            float _Strength;

            
            float4 GetColor(sampler2D tex, float2 pos){
                int u, v;
                half4 col;
                matrix mtx = matrix(
                    1,1,1,     0,
                    1,1,1,    0,
                    1,1,1,     0,
                    0,0,0,0
                );
                for (u = -1; u <= 1; ++u){
                    for (v = -1; v <= 1; ++v){

                        float x = pos.x + u * _Dist;
                        float y = pos.y + v * _Dist;

                        col += tex2D(
                            tex, 
                            float2(x, y)
                        )*mtx[u + 1][v + 1];

                    }
                }
                return col / 9;
            }

            half4 frag (v2f i) : SV_Target
            {
                
                //最終
                float2 v = GetColor(_CameraMotionVectorsTexture, i.uv).rg;

                //仮
                //float2 v = tex2D(_CameraMotionVectorsTexture, i.uv).rg;
                v *= _CameraMotionVectorsTexture_TexelSize.zw;
                
                half4 col = fixed4(v.x, v.y, 0, 1);

                // just invert the colors
                //col.rgb = 1 - col.rgb;
                return col;
            }
            ENDCG
        }
    }
}
