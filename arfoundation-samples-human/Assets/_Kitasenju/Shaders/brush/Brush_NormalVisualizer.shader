﻿Shader "brush/Brush_NormalVisualizer"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
        cull off
        Pass
        {
            CGPROGRAM
// Upgrade NOTE: excluded shader from DX11; has structs without semantics (struct v2f members normal)
#pragma exclude_renderers d3d11
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;            
    			//fixed facing : VFACE;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

/*
https://gist.github.com/sugi-cho/efd860f4c744d617f54a
#今日のまとめ(7/23) ##オブジェクト空間からワールド空間での各値を求める。

fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);
fixed3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
fixed3 worldBinormal = cross(worldNormal, worldTangent) * v.tangent.w;
*/

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.normal = UnityObjectToWorldNormal( v.normal );
                return o;
            }

            //dispace test
            //(fixed facing : VFACE

            fixed4 frag (v2f i, fixed facing : VFACE) : SV_Target
            {
                // sample the texture
                //fixed4 col = tex2D(_MainTex, i.uv);
                fixed4 col = fixed4( i.normal , 1 );

                col.xyz = normalize(col.xyz);
                col.z *= facing; // flip Z based on facing

                col.x += 0.5 * ( col.x + 1 );
                col.y += 0.5 * ( col.y + 1 );
                col.z += 0.5 * ( col.z + 1 );

                //abs tekina 

                // apply fog
                return col;
            }
            ENDCG
        }
    }
}
