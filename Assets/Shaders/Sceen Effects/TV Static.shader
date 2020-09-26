Shader "Custom/Screen Effects/TV Static"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
		_NoiseTex("Noise Texture", 2D) = "white" {}
		_MotionTex("Upward Motion Texture", 2D) = "white" {}
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

            sampler2D _MainTex;
			sampler2D _NoiseTex;
			sampler2D _MotionTex;

			float1 random(float1 seed) {
				float1 randNum;
				randNum = tex2D(_NoiseTex, float2(seed, 0)).r;
				return randNum;
			}

            fixed4 frag (v2f i) : SV_Target
			{
				float4 motion = tex2D(_MotionTex, float2(i.uv.x, i.uv.y - (_Time[1] / 2) + 10)) / (random(i.uv.y) * 50 - 25);
				
				fixed4 col = tex2D(_MainTex, i.uv + float2(0, (tex2D(_NoiseTex, float2(i.uv.x - motion.y, _Time[1])).r * 2 - 1) * 0.0012) + float2(0, (motion.x / 25)));
				
				float1 add = tex2D(_NoiseTex, i.uv + float2(_Time[0]/20, _Time[0])).r / 20;
				col.rgb += float3(add, add, add);

				col += motion;
				
                return col;
            }
            ENDCG
        }
    }
}
