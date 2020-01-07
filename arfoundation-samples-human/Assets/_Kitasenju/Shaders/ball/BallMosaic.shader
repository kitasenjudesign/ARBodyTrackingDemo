Shader "ball/BallMosaic"
{
  Properties
  {
    _MainTex ("Texture", 2D) = "white" {}
    _Size ("Size",float) = 1
  }
  SubShader
  {
    Pass
    {
      Tags { "RenderType"="Opaque" "LightMode"="ForwardBase"}

      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag

      #include "UnityCG.cginc"
      #include "Lighting.cginc"

      struct appdata
      {
        float4 vertex : POSITION;
        float3 normal : NORMAL;
        float2 uv : TEXCOORD0;
      };

      struct v2f
      {
        float4 vertex : SV_POSITION;
        float2 uv : TEXCOORD0;
        float3 worldNormal : TEXCOORD1;
      };

      sampler2D _MainTex;
      float4 _MainTex_ST;
      float _Size;

      void vert (in appdata v, out v2f o)
      {
        
        o.vertex = UnityObjectToClipPos(v.vertex);
        
        float r = (o.vertex.z+1)/2;
        float s = _Size;
        o.vertex = floor( o.vertex * s ) / s;

        o.worldNormal = UnityObjectToWorldNormal(v.normal);
        o.uv = TRANSFORM_TEX(v.uv, _MainTex);

      }

      void frag (in v2f i, out fixed4 col : SV_Target)
      {
        float3 lightDir = _WorldSpaceLightPos0.xyz;
        float3 normal = normalize(i.worldNormal);
        float NL = dot(normal, lightDir);

        float3 baseColor = tex2D(_MainTex, i.uv);
        float3 lightColor = _LightColor0;

        col = fixed4(baseColor * lightColor * max(NL, 0), 0);
      }
      ENDCG
    }
  }
}