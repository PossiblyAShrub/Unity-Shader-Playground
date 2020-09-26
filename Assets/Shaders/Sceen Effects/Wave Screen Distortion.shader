Shader "Custom/Screen Effects/Wave Screen Distortion"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Strength ("Wobble Strength", Float) = 1 
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
			float1 _Strength;

			struct offset {
				float1 x;
				float1 y;
			};

            fixed4 frag (v2f IN) : SV_Target
			{
				offset o;
				o.x = sin(IN.vertex.x * 0.01 + _Time[1]) / 100;
				o.y = sin(IN.vertex.x * 0.01 + _Time[1]) / 500;

				fixed4 col = tex2D(_MainTex, IN.uv + float2(o.x, o.x) * _Strength);
                return col;
            }
            ENDCG
        }
    }
}