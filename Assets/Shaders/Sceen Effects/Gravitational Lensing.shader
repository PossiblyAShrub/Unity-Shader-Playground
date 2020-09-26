Shader "Custom/Gravitational Lensing"
{
	Properties
	{
		_Mass("Mass", float) = 1
		_G("Gravitational Constant", float) = 0.0000000000067
		_Dls("D ls", float) = 0
		_Dl("D l", float) = 0
		_Ds("D s", float) = 0
	}
		SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		GrabPass { "_MainTex" }

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			float _Mass;
			float _G;
			float _C = 299792458;

			float _Dls;
			float _Dl;
			float _Ds;

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

            fixed4 frag (v2f i) : SV_Target
            {
				float d = sqrt(((4 * _G * _Mass) / pow(_C, 2)) * (_Dls / (_Dl * _Ds)));
				fixed4 col = tex2D(_MainTex, i.uv + d* 345);
                // just invert the colors
                return col;
            }
            ENDCG
        }
    }
}
