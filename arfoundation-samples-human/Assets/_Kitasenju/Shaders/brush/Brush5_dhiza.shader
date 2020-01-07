Shader "brush/Brush5_dhiza"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _ColorTex("ColorTexture", 2D) = "white" {}
        _Split("_Split",range(1,10)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            sampler2D _ColorTex;

            float _Split;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }


            float rand(float2 co) {
                float a = frac(dot(co, float2(2.067390879775102, 12.451168662908249))) - 0.5;
                float s = a * (6.182785114200511 + a * a * (-38.026512460676566 + a * a * 53.392573080032137));
                float t = frac(s * 43758.5453);
                return t;
            }


            fixed4 frag (v2f i) : SV_Target
            {
                //２のべき乗にする
                float split = pow( 2, floor( _Split ) );

                //アニメーションさせるために動かす値
                float2 offset = float2( 0, floor( _Time.z * split ) );

                //グリッドに対して乱数を発生させる
                float r = rand( floor( i.uv * split + offset ) / split );

                //その乱数をつかって分割数を決める
                float size = split * floor( abs(r) * 25 + 2 );

                //分割された
                float2 uvv = floor( i.uv * size ) / size;

                // sample the texture
                fixed4 col = tex2D(_MainTex, uvv);
                
                col.x = step( rand( uvv ), col.x );
                col.y = step( rand( uvv ), col.y );
                col.z = step( rand( uvv ), col.z );

                return col;
            }
            ENDCG
        }
    }
}
