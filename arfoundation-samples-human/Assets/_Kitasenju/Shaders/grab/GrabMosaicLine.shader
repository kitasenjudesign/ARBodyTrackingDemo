Shader "grab/GrabMosaicLine" {
    Properties {
        //_blurSizeXY("BlurSizeXY", Range(0, 1)) = 0
        _Color("_Color", color) = (1,1,1,1)
        _NoiseSize("_NoiseSize", Range(1, 50)) = 1
        _RandomSize("_RandomSize", Range(0, 10)) = 1
        _MosaicTex ("_MosaicTex", 2D) = "white" {}
        _MosaicSize("_MosaicSize",float) = 10
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
            float _NoiseSize;
            float _RandomSize;
            float _ColorMoveMode;
            float4 _Color;
            float _MosaicSize;

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

            //

            half4 frag( v2f i ) : COLOR
            {
                float aspct = _ScreenParams.y/_ScreenParams.x;
                float2 aspect2 = float2(1,_ScreenParams.y/_ScreenParams.x );
                float2 screenPos = i.screenPos.xy / i.screenPos.w;
                

                //half4 mosaic = tex2D( _MosaicTex, screenPos );
                

                //float size = frac( _Time.x ) * 3;
                float nn = pow(2,floor(_MosaicSize));//6,7,8
                
                half4 col = tex2D( _BackgroundTexture, 
                    float2(
                        //floor(screenPos.x*nn)/nn,
                        screenPos.x,
                        floor(screenPos.y*nn*aspct)/(nn*aspct)
                    )
                );
                
                
                _Color.a=1;

                col = lerp( 
                    _Color,//元の色
                    col,//mosaicした色
                    step(0.5, col.a)
                );

                return col;//fixed4(r,r,r,1.0);
            }
            ENDCG
        }


    }
}