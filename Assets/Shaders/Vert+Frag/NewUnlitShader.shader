Shader "Custom/NewUnlitShader"
{
    SubShader
    {
		Tags { "Queue" = "Transparent" }
        LOD 100

		GrabPass
		{
			"_BackgroundTexture"
		}
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

			struct v2f
			{
				float4 uv : TEXCOORD0;
				float4 pos : SV_POSITION;
			};

			sampler2D _BackgroundTexture;

			v2f vert(appdata_base v) {
				v2f o;
				// use UnityObjectToClipPos from UnityCG.cginc to calculate
				// the clip-space of the vertex
				o.pos = UnityObjectToClipPos(v.vertex);
				// use ComputeGrabScreenPos function from UnityCG.cginc
				// to get the correct texture coordinate
				o.uv = ComputeGrabScreenPos(o.pos);
				return o;
			}

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_BackgroundTexture, i.uv);
                return col;
            }
            ENDCG
        }
    }
}
