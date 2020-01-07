Shader "grab/Grab_MotionVector" {
    Properties {
        //_blurSizeXY("BlurSizeXY", Range(0, 1)) = 0
        _Dist ("_Dist", Float) = 1
        _Strength( "_Strength", float) = 1
        _MainTex ("_MainTex", 2D) = "white" {}        
        //_Div("_Div",float)=1
    }

    SubShader {

        // 不透明オブジェクトを描画した後に実行する
        //Tags { "RenderType"="Opaque" }
        Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
        LOD 100
        cull off
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
            float _blurSizeXY;
            float _Size;
            sampler2D _CameraMotionVectorsTexture;
            float4 _CameraMotionVectorsTexture_TexelSize;
            float _Strength;

            struct v2f
            {
                float4 position : POSITION;
                float4 screenPos : TEXCOORD0;
            };

            v2f vert(appdata_base i) {
                v2f o;
                o.position = UnityObjectToClipPos(i.vertex);
                o.screenPos = ComputeGrabScreenPos(o.position);
                return o;
            }


            float rand(float2 co) {
                float a = frac(dot(co, float2(2.067390879775102, 12.451168662908249))) - 0.5;
                float s = a * (6.182785114200511 + a * a * (-38.026512460676566 + a * a * 53.392573080032137));
                float t = frac(s * 43758.5453);
                return t;
            }


            half4 frag( v2f i ) : COLOR
            {
                float2 screenPos = i.screenPos.xy / i.screenPos.w;

                float2 v = tex2D(_CameraMotionVectorsTexture, screenPos).rg;
                v *= _CameraMotionVectorsTexture_TexelSize.zw;
                
                half4 col = tex2D( 
                    _BackgroundTexture, screenPos + v * _Strength
                );

                return col;
            }
            ENDCG



        }

    }

}