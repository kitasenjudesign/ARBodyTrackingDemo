// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "grab/Grab_Tangent" {
    Properties {
        //_blurSizeXY("BlurSizeXY", Range(0, 1)) = 0
        _Color("_Color", color) = (1,1,1,1)
        _NoiseSize("_NoiseSize", Range(1, 50)) = 1
        _RandomSize("_RandomSize", Range(0, 10)) = 1
        _MosaicTex ("_MosaicTex", 2D) = "white" {}
        _MosaicSize("_MosaicSize",float) = 10
        _StrengthTex ("_StrengthTex", 2D) = "white" {}
        [Toggle] _ColorMoveMode("_ColorMoveMode", float) = 0        

    }
    SubShader {

        // 不透明オブジェクトを描画した後に実行する
        //Tags { "Queue" = "Transparent" }
        Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
        LOD 100

        // オブジェクトの背景テクスチャーを _BackgroundTexture に取得する。
        GrabPass { "_BackgroundTexture" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag 
            #include "UnityCG.cginc"
            #include "../noise/SimplexNoise3D.hlsl"
            sampler2D _BackgroundTexture;
            sampler2D _MosaicTex;
            sampler2D _StrengthTex;
            float _NoiseSize;
            float _RandomSize;
            float _ColorMoveMode;
            float4 _Color;
            float _MosaicSize;

            struct v2f
            {
                float4 position : POSITION;
                float4 screenPos : TEXCOORD0;
                float4 uv : TEXCOORD1;
                float4 tangent : TANGENT;
            };

            v2f vert(appdata_full i) {
                v2f o;
                
                //https://docs.unity3d.com/ja/current/Manual/SL-BuiltinFunctions.html


                //mul(UNITY_MATRIX_MVP, float4(pos, 1.0))と同等
                o.position = UnityObjectToClipPos(i.vertex);

                float4 t = UnityObjectToClipPos(float4(i.tangent.xyz, 1.0));
                t.xyz = normalize(t.xyz);
                //float3 WorldSpaceViewDir (float4 v)
                //UnityObjectToWorldDir

                float4 p = ComputeScreenPos(float4(t.xyz, 1.0));
                o.tangent = p;
                o.uv = i.texcoord;
                o.screenPos = ComputeGrabScreenPos(o.position);
                return o;
            }


            float rand(float2 co) {
                float a = frac(dot(co, float2(2.067390879775102, 12.451168662908249))) - 0.5;
                float s = a * (6.182785114200511 + a * a * (-38.026512460676566 + a * a * 53.392573080032137));
                float t = frac(s * 43758.5453);
                return t;
            }

            //

            half4 frag( v2f i ) : COLOR
            {
                float aspct = _ScreenParams.y/_ScreenParams.x;
                float2 aspect2 = float2(1,_ScreenParams.y/_ScreenParams.x );
                float2 screenPos = i.screenPos.xy / i.screenPos.w;
                
                float4 ss = tex2D( _StrengthTex, i.uv.xy );


                float2 t = float2(i.tangent.x,i.tangent.y);
                t = t / i.tangent.w - float2(0.5,0.5);
                t = t * 0.1;
                t *= pow(ss.x,0.2 + 0.2 * rand(screenPos) );
                //col.x = t.x;
                //col.y = t.y;

                half4 col = tex2D( _BackgroundTexture, 
                    float2(
                        screenPos.x + t.x,
                        screenPos.y + t.y
                    )
                );
                
                

                return col;//fixed4(r,r,r,1.0);
            }
            ENDCG
        }


    }
}