Shader "grab/GrabBlur" {
    Properties {
        //_blurSizeXY("BlurSizeXY", Range(0, 1)) = 0
        _Size("_Size", Range(1, 500)) = 1
        _MosaicTex ("_MosaicTex", 2D) = "white" {}
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
            float _blurSizeXY;
            float _Size;

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

                //half4 mosaic = tex2D( _MosaicTex, screenPos );

                float aspct = _ScreenParams.y/_ScreenParams.x;
                float split = _Size;// + mosaic.x*_Size;// * abs( snoise( float3(screenPos.xy,0)  ) );
                
                
                half4 col = tex2D( _BackgroundTexture, 
                    float2(
                        round(screenPos.x*split)/split,
                        round(screenPos.y*split*aspct)/(split*aspct)
                    )
                );
                
                //col.rgb = lerp(float3(1,0,0),col.rgb,0.3);

                return col;
            }
            ENDCG
        }
    }
}