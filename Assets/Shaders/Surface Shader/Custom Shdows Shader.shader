Shader "Custom/Surface/Custom Shdows Shader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Custom
			
		half4 LightingCustom(SurfaceOutput IN) {
			half4 OUT;
			OUT.rgb = float3(0, 0, 0);// IN.Albedo * _LightColor0.rgb;
			//float cutOff = 1;
			//if (OUT.r <= cutOff || OUT.g <= cutOff || OUT.b <= cutOff) {
				//OUT.rgb = float3(0, 0, 0);
			//}/
			OUT.a = IN.Alpha;
			return OUT;
		}
		
		/*
		  half4 LightingSimpleLambert(SurfaceOutput s, half3 lightDir, half atten) {
			  half NdotL = dot(s.Normal, lightDir);
			  half4 c;
			  c.rgb = s.Albedo * float3(1, 0, 0) * (NdotL * atten); //_LightColor0.rgb
			  c.a = s.Alpha;
			  return c;
		  }*/

		struct Input {
			float2 uv_MainTex;
		};

		sampler2D _MainTex;

		void surf(Input IN, inout SurfaceOutput o) {
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
		}
		ENDCG
    }
    FallBack "Diffuse"
}
