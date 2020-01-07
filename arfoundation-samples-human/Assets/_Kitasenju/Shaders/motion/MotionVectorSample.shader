Shader "motion/MotionVectorSample"
{
    Properties{
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Cull Off
        ZTest Always
        ZWrite Off

        Tags { "RenderType"="Opaque" }

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

            sampler2D _MainTex;
            float4 _MainTex_ST;
            
            sampler2D _CameraMotionVectorsTexture;
            float4 _CameraMotionVectorsTexture_TexelSize;
            
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }
            
            fixed4 frag (v2f i) : SV_Target
            {
                // カメラから見たオブジェクトの
                // 右方向へのスピードが大きいほどRの値が大きくなり
                // 上方向へのスピードが大きいほどGの値が大きくなる
                // （1以上の値もとるし逆向きだったら負の値をとる）
                float2 v = tex2D(_CameraMotionVectorsTexture, i.uv).rg;
                v *= _CameraMotionVectorsTexture_TexelSize.zw;
                return half4(v.x, v.y, 0, 1);

            }
            ENDCG
        }
    }
}