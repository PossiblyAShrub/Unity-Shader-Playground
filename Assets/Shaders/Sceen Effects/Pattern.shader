Shader "Custom/Screen Effects/Pattern"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_Strength("Wobble Strength", Float) = 1
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

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

			float Hash21(float2 p) {
				p = frac(p * float2(234.34, 435.345));
				p += dot(p, p + 34.23);
				return frac(p.x * p.y);
			}

			sampler2D _MainTex;
			float _Strength;

			fixed4 frag(v2f IN) : SV_Target
			{
				float2 uv = IN.uv;

				float2 o;
				o.x = sin(IN.vertex.x * 0.01 + _Time[1]) / 100;
				o.y = sin(IN.vertex.x * 0.01 + _Time[1] * Hash21(uv)) / 500;

				fixed4 col = tex2D(_MainTex, uv + float2(o.x, o.x) *_Strength);

                return col;
            }
            ENDCG
        }
    }
}
