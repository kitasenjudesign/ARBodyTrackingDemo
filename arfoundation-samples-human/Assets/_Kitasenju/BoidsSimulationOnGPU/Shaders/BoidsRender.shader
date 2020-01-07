Shader "boids" 
{
    Properties 
    {
        _RelativeRefractionIndex("Relative Refraction Index", Range(0.0, 1.0)) = 0.67
        [PowerSlider(5)]_Distance("Distance", Range(0.0, 100.0)) = 10.0
    }
    
    SubShader 
    {
        Tags {"Queue"="Transparent" "RenderType"="Transparent" }
        

        // { "_GrabPassTexture" }

        

            CGPROGRAM
        	#pragma vertex vert
        	#pragma fragment frag
        	//#pragma multi_compile_instancing // 追加
			#pragma instancing_options procedural:setup

           #include "UnityCG.cginc"

			// Boidの構造体
			struct BoidData
			{
				float3 velocity; // 速度
				float3 position; // 位置
			};

			#ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
			// Boidデータの構造体バッファ
			StructuredBuffer<BoidData> _BoidDataBuffer;
			#endif

            struct appdata {
                half4 vertex                : POSITION;
                half4 texcoord              : TEXCOORD0;
                half3 normal                : NORMAL;
            };
                
            struct v2f {
                half4 vertex                : SV_POSITION;
                half2 samplingViewportPos   : TEXCOORD0;
            };
            
            sampler2D _GrabPassTexture;
            float _RelativeRefractionIndex;
            float _Distance;
			float3 _ObjectScale; // Boidオブジェクトのスケール

			// オイラー角（ラジアン）を回転行列に変換
			float4x4 eulerAnglesToRotationMatrix(float3 angles)
			{
				float ch = cos(angles.y); float sh = sin(angles.y); // heading
				float ca = cos(angles.z); float sa = sin(angles.z); // attitude
				float cb = cos(angles.x); float sb = sin(angles.x); // bank

				// Ry-Rx-Rz (Yaw Pitch Roll)
				return float4x4(
					ch * ca + sh * sb * sa, -ch * sa + sh * sb * ca, sh * cb, 0,
					cb * sa, cb * ca, -sb, 0,
					-sh * ca + ch * sb * sa, sh * sa + ch * sb * ca, ch * cb, 0,
					0, 0, 0, 1
				);
			}



            v2f vert (appdata v)
            {
                v2f o                   = (v2f)0;

				#ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED

					// インスタンスIDからBoidのデータを取得
					BoidData boidData = _BoidDataBuffer[unity_InstanceID]; 

					float3 pos = boidData.position.xyz; // Boidの位置を取得
					float3 scl = _ObjectScale;          // Boidのスケールを取得

					// オブジェクト座標からワールド座標に変換する行列を定義
					float4x4 object2world = (float4x4)0; 
					// スケール値を代入
					object2world._11_22_33_44 = float4(scl.xyz, 1.0);
					// 速度からY軸についての回転を算出
					float rotY = 
						atan2(boidData.velocity.x, boidData.velocity.z);
					// 速度からX軸についての回転を算出
					float rotX = 
						-asin(boidData.velocity.y / (length(boidData.velocity.xyz) + 1e-8));
					// オイラー角（ラジアン）から回転行列を求める
					float4x4 rotMatrix = eulerAnglesToRotationMatrix(float3(rotX, rotY, 0));
					// 行列に回転を適用
					object2world = mul(rotMatrix, object2world);
					// 行列に位置（平行移動）を適用
					object2world._14_24_34 += pos.xyz;

					// 頂点を座標変換
					o.vertex = mul(object2world, v.vertex);
					// 法線を座標変換
					o.normal = normalize(mul(object2world, v.normal));
					
				#endif

				/*
                o.vertex                = UnityObjectToClipPos(v.vertex);
                float3 worldPos         = mul(unity_ObjectToWorld, v.vertex);
                half3 worldNormal       = UnityObjectToWorldNormal(v.normal);

                half3 viewDir           = normalize(worldPos - _WorldSpaceCameraPos.xyz);
                // 屈折方向を求める
                half3 refractDir        = refract(viewDir, worldNormal, _RelativeRefractionIndex);
                // 屈折方向の先にある位置をサンプリング位置とする
                half3 samplingPos       = worldPos + refractDir * _Distance;
                // サンプリング位置をプロジェクション変換
                half4 samplingScreenPos = mul(UNITY_MATRIX_VP, half4(samplingPos, 1.0));
                // ビューポート座標系に変換
                o.samplingViewportPos   = (samplingScreenPos.xy / samplingScreenPos.w) * 0.5 + 0.5;
               #if UNITY_UV_STARTS_AT_TOP
                    o.samplingViewportPos.y     = 1.0 - o.samplingViewportPos.y;
               #endif
			   */

                return o;
            }
            
			void setup()
			{
			}

            fixed4 frag (v2f i) : SV_Target
            {
                return fixed4(1,0,0,1);//tex2D(_GrabPassTexture, i.samplingViewportPos);
            }
            ENDCG
        }
    
}