Shader "grab/GrabMosaic" {
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
                /*
                //アニメーションさせるために動かす値
                float2 offset = float2( 0, floor( _Time.x * _NoiseSize ) );
                
                //float split = _Size;// + mosaic.x*_Size;// * abs( snoise( float3(screenPos.xy,0)  ) );
                
                //グリッドに対して乱数を発生させる
                float r = rand( round( screenPos * aspect2 * _NoiseSize + offset ) / _NoiseSize );

                //その乱数でモザイクを作る、noiseSizeを単位に、さらに細かくするので掛け算。
                float size = _NoiseSize * pow(2,floor(r*_RandomSize+1));//floor( abs(r) * 10 + 2 );
                */

                //float size = frac( _Time.x ) * 3;
                float nn = pow(2,floor(_MosaicSize));//6,7,8
                half4 col = tex2D( _BackgroundTexture, 
                    float2(
                        floor(screenPos.x*nn)/nn,
                        floor(screenPos.y*nn*aspct)/(nn*aspct)
                    )
                );
                
                //col.rgb = lerp(float3(1,0,0),col.rgb,0.3);

                //元の色を取得
                //fixed4 cc = tex2D ( 
                //    _MainTex, 
                //    float2( frac(_Time.x) ,0.5 ) 
                //);
                //float4 col0 = lerp( _Color,cc,_ColorMoveMode);
                //col0.a = 1;
                
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