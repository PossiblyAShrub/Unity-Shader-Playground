
Shader "Custom/Vert + Frag/[OLD] Blackhole" 
{
	Properties
	{
		_DistortionStrength("Distortion Strength", Range(0, 10)) = 1.16
		_HoleSize("Black Hole Size", Range(0, 1)) = 0.48
		_HoleEdgeSmoothness("Black Hole Edge Smoothness", Range(0.001, 0.05)) = 0.0499
	}
	SubShader
	{
		Tags {
			"IgnoreProjector" = "True"
			"Queue" = "Transparent"
			"RenderType" = "Transparent"
		}
		GrabPass
		{ 
			"_GrabTex"
		}
		Pass 
		{

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"
				
			struct VertexInput {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};
				
			struct VertexOutput {
				float4 pos : SV_POSITION;
				float4 posWorld : TEXCOORD0;
				float3 normalDir : TEXCOORD1;
				float4 projPos : TEXCOORD2;
			};

			uniform sampler2D _GrabTex;
			uniform float _DistortionStrength;
			uniform float _HoleSize;
			uniform float _HoleEdgeSmoothness;

			VertexOutput vert(VertexInput v) {
				VertexOutput o = (VertexOutput)0;
				o.normalDir = UnityObjectToWorldNormal(v.normal);
				o.posWorld = mul(unity_ObjectToWorld, v.vertex);
				o.pos = UnityObjectToClipPos(v.vertex);
				o.projPos = ComputeScreenPos(o.pos);
				COMPUTE_EYEDEPTH(o.projPos.z);
				return o;
			}

			float4 frag(VertexOutput i) : COLOR {
				i.normalDir = normalize(i.normalDir);

				float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
				float3 normalDirection = i.normalDir;

				float2 sceneUVs = (i.projPos.xy / i.projPos.w);
				float4 sceneColor = tex2D(_GrabTex, sceneUVs);
					
				float holeMask = smoothstep(
					(_HoleSize + _HoleEdgeSmoothness), 
					(_HoleSize - _HoleEdgeSmoothness), 
					(1.0 - pow(1.0 - dot(normalDirection, viewDirection),0.15))
					);
				
				float distorion = 1 - pow(1 - max(0, dot(normalDirection, viewDirection)), _DistortionStrength);
				
				float3 OUT = (holeMask*tex2D(_GrabTex, ((pow(distorion,6.0)*(sceneUVs.rg*-2.0 + 1.0)) + sceneUVs.rg)).rgb);
				return fixed4(OUT,0.5);
			}
			ENDCG
		}
	}
	FallBack "Diffuse"			
	CustomEditor "ShaderForgeMaterialInspector"
}