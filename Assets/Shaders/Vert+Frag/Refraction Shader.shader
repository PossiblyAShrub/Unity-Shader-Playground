Shader "Custom/Vert + Frag/Refraction Shader"
{
	Properties{
		_NoiseTex("Noise Texture", 2D) = "black" {}
		_Transparancy("Transparancy", Range(0, 1)) = 1
	}
		SubShader
	{
		// Draw ourselves after all opaque geometry
		Tags { "Queue" = "Transparent" }

		// Grab the screen behind the object into _BackgroundTexture
		GrabPass
		{
			"_BackgroundTexture"
		}

		// Render the object with the texture generated above, and invert the colors
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct v2f
			{
				float4 grabPos : TEXCOORD0;
				float4 pos : SV_POSITION;
				float fresnelValue : VALUE;
			};

			v2f vert(appdata_base v) {
				v2f o;
				// use UnityObjectToClipPos from UnityCG.cginc to calculate 
				// the clip-space of the vertex
				o.pos = UnityObjectToClipPos(v.vertex);
				// use ComputeGrabScreenPos function from UnityCG.cginc
				// to get the correct texture coordinate
				o.grabPos = ComputeGrabScreenPos(o.pos);
				float3 viewDir = ObjSpaceViewDir(v.vertex);
				o.fresnelValue = 1 - saturate(dot(v.normal, viewDir));
				return o;
			}

			sampler2D _BackgroundTexture;
			sampler2D _NoiseTex;
			float _Transparancy;

			half4 frag(v2f IN) : SV_Target
			{
				half4 OUT;
				float4 grabPos = IN.grabPos + (tex2D(_NoiseTex, IN.grabPos) / 50) + (IN.fresnelValue / 2);
				half4 bgcolor = tex2Dproj(_BackgroundTexture, grabPos); //map bg colors from texture

				//Add refraction
				OUT = bgcolor;

				return OUT; // _Transparancy;
			}
			ENDCG
		}

	}
}
