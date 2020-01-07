Shader "grab/GrabDisplace2" {
    Properties {
        //_blurSizeXY("BlurSizeXY", Range(0, 1)) = 0
        _Color ("_Color", color ) = (1,1,1,1)
        _MainTex ("Base (RGB)", 2D) = "white" {}          
        _MosaicTex ("_MosaicTex", 2D) = "white" {}
        _Detail("_Detail", vector) = (1,1,0,0)
        _Strength("_Strength", Range(0, 0.1)) =0.05
        _Speed("_Speed", vector) = (0,0,0,0)
        _Mosaic("_Mosaic", Range(10, 500)) = 500
        [Toggle] _ColorMoveMode("_ColorMoveMode", float) = 0
    }
    SubShader {

        // 不透明オブジェクトを描画した後に実行する
        //Tags { "Queue" = "Transparent" }
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
            sampler2D _MainTex;      
            float _Strength;
            float4 _Detail;
            float4 _Speed;
            float _Mosaic;
            float4 _Color;
            float _ColorMoveMode;

            struct v2f
            {
                float4 position : POSITION;
                float4 screenPos : TEXCOORD0;
                float4 uv : TEXCOORD1;
            };

            v2f vert(appdata_base i) {
                v2f o;
                
                o.uv = i.texcoord;
                o.position = UnityObjectToClipPos(i.vertex);
                o.screenPos = ComputeGrabScreenPos(o.position);

                return o;
            }

            half4 frag( v2f i ) : COLOR
            {

                //clip( snoise(float3(i.uv.x,i.uv.y*_Detail.y*10, _Time.z*10.0)) );
                float2 screenPos = i.screenPos.xy / i.screenPos.w;
                float aspct = _ScreenParams.y/_ScreenParams.x;
                float2 aspct2 = float2(1,aspct);

                //screenPos = floor( screenPos * aspct2 * _Mosaic ) / _Mosaic;


                //float depth = _blurSizeXY * 0.01;
                //half4 sum = half4(0.0h, 0.0h, 0.0h, 0.0h);
                //float count = 0.0;
                /*
                for (float x = -1.0; x <= 1.0; x += 0.25) {
                    for (float y = -1.0; y <= 1.0; y += 0.25) {
                        sum += tex2D( _BackgroundTexture, float2(screenPos.x + x * depth, screenPos.y + y * depth));
                        count += 1.0;
                    }
                }*/
                
                //fixed4 c = tex2D (_MainTex, i.uv );// * _Color;

                half4 mosaic = tex2D( _MosaicTex, screenPos );

                
                //float split = _Size;// + mosaic.x*_Size;// * abs( snoise( float3(screenPos.xy,0)  ) );

                half4 c = tex2D( 
                    _BackgroundTexture, 
                    screenPos.xy
                );


                float2 ss = _Strength * float2(1, _ScreenParams.x/_ScreenParams.y);


                float2 offsetR = float2(
                    snoise( float3(screenPos.xy*_Detail.x,_Time.x*_Speed.x) ) * ss.x,
                    snoise( float3(screenPos.yx*_Detail.y,_Time.x*_Speed.x) ) * ss.y
                );
                float2 offsetG = float2(
                    snoise( float3(screenPos.xy*_Detail.x,_Time.x*_Speed.y) ) * ss.x,
                    snoise( float3(screenPos.yx*_Detail.y,_Time.x*_Speed.y) ) * ss.y
                );
                float2 offsetB = float2(
                    snoise( float3(screenPos.xy*_Detail.x,_Time.x*_Speed.z) ) * ss.x,
                    snoise( float3(screenPos.yx*_Detail.y,_Time.x*_Speed.z) ) * ss.y
                );
                float2 offsetA = float2(
                    snoise( float3(screenPos.xy*_Detail.x,_Time.x*_Speed.w) ) * ss.x,
                    snoise( float3(screenPos.yx*_Detail.y,_Time.x*_Speed.w) ) * ss.y
                );

                half4 colR = tex2D( _BackgroundTexture, 
                    float2(
                        screenPos.x + offsetR.x,
                        screenPos.y + offsetR.y
                    )
                );
                half4 colG = tex2D( _BackgroundTexture, 
                    float2(
                        screenPos.x + offsetG.x,
                        screenPos.y + offsetG.y
                    )
                );  
                half4 colB = tex2D( _BackgroundTexture, 
                    float2(
                        screenPos.x + offsetB.x,
                        screenPos.y + offsetB.y
                    )
                );   
                half4 colA = tex2D( _BackgroundTexture, 
                    float2(
                        screenPos.x + offsetA.x,
                        screenPos.y + offsetA.y
                    )
                );   

                half4 col = half4(
                    colR.r,
                    colG.g,
                    colB.b,
                    //c.a
                    colA.a
                ); //lerp(float3(1,0,0),col.rgb,0.3);

                //元の色
                fixed4 cc = tex2D ( 
                    _MainTex, 
                    float2( frac(_Time.x) ,0.5 ) 
                );
                float4 col0 = lerp( _Color,cc,_ColorMoveMode);
                col0.a = 1;

                col = lerp( 
                    col0,//元の色
                    col,//displaceした色
                    step(0.5, c.a)
                );

                
                //clip( screenPos.x - 0.5 );


                return col;
            }
            ENDCG
        }
    }
}