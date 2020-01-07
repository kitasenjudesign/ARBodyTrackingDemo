Shader "Hidden/AddEffect"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Pow ("Pow", Float) = 2
        
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always
        Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}

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
            sampler2D _InputTex;
            sampler2D _BaseTex;
            float _Ratio;
            float _Pow;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 colA = tex2D(_InputTex, i.uv);
                fixed4 colB = tex2D(_BaseTex, i.uv);

                


                //fixed3 rgb = ( colA.rgb * colA.a + colB.rgb * colB.a ) / ( colA.a + colB.a );
                fixed3 rgb = lerp(colB.rgb, colA.rgb, colA.a );

                
                fixed a = colA.a + colB.a;
                a = saturate( a );

                fixed4 col = fixed4(rgb,a);

                //fixed4 col = lerp(colB, colA, pow( colA.a,_Pow) );
                //col.rgb = lerp(col.rgb,float3(1,1,1),0.1 );

                return col;// * _Ratio;
            }
            ENDCG
        }
    }
}
