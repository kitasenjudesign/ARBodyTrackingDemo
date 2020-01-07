Shader "grab/Grab_Edge" {
    Properties {
        //_blurSizeXY("BlurSizeXY", Range(0, 1)) = 0
        _Dist ("_Dist", Float) = 1
        _Strength( "_Strength", float) = 1
        _MainTex ("_MainTex", 2D) = "white" {}        
        //_Div("_Div",float)=1
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
            sampler2D _MainTex;

            float _Size;
            float _Strength;
            float _Dist;
            //float _Div;
            matrix _Matrix;

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
                float aspct = _ScreenParams.x/_ScreenParams.y;
                float2 screenPos = i.screenPos.xy / i.screenPos.w;// * aspct;
                matrix mtx = matrix(
                    0,-1,0,     0,
                    -1,4,-1,    0,
                    0,-1,0,     0,
                    0,0,0,0
                );

                int u, v;
                half4 col;
                for (u = -1; u <= 1; ++u){
                    for (v = -1; v <= 1; ++v)
                    {
                        float x = screenPos.x + u / _ScreenParams.x * _Dist;
                        float y = screenPos.y + v / _ScreenParams.y * _Dist;// + 1 / _ScreenParams.y * _Dist;
                        col += tex2D(
                            _BackgroundTexture, 
                            float2(x, y)
                        )*mtx[u + 1][v + 1];
                    }
                }

                col = col / 8 * _Strength;

                //col = tex2D( _MainTex, float2( Luminance( col.rgb ),0.5));


                //col.a = 1;

                return col;
            }
            ENDCG
        }
    }
}