Shader "CustomRP/DeferredLighting"
{
    Properties
    {
    }
    SubShader
    {
        // Cull Off ZWrite Off
        // No culling or depth
        Cull Off ZWrite Off ZTest Always
        Pass
        {
            CGPROGRAM
            #pragma target 5.0
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "UnityDeferredLibrary.cginc"
            #include "UnityPBSLighting.cginc"
            #include "UnityStandardUtils.cginc"
            #include "UnityGBuffer.cginc"
            #include "UnityStandardBRDF.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex: SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float4x4 _InvVP;
            float3 _CurrentLightDir;
            float3 _LightFinalColor;
            Texture2D _GBuffer0;
            SamplerState sampler_GBuffer0;
            Texture2D _GBuffer1;
            SamplerState sampler_GBuffer1;
            Texture2D _GBuffer2;
            SamplerState sampler_GBuffer2;
            Texture2D _GBuffer3;
            SamplerState sampler_GBuffer3;
            Texture2D _DepthTexture;
            SamplerState sampler_DepthTexture;
            
            float4 frag(v2f i) : SV_Target
            {
                UnityLight light;
                light.dir = _CurrentLightDir;
                light.color = _LightFinalColor;
                float4 gbuffer0 = _GBuffer0.Sample(sampler_GBuffer0, i.uv);
                float4 gbuffer1 = _GBuffer1.Sample(sampler_GBuffer1, i.uv);
                float4 gbuffer2 = _GBuffer2.Sample(sampler_GBuffer2, i.uv);
                float4 gbuffer3 = _GBuffer3.Sample(sampler_GBuffer3, i.uv);
                float depth = _DepthTexture.Sample(sampler_DepthTexture, i.uv).x;
                float4 worldPos = mul(_InvVP, float4(i.uv*2-1, depth, 1));
                worldPos /= worldPos.w;
                UnityStandardData data = UnityStandardDataFromGbuffer(gbuffer0, gbuffer1, gbuffer2);
                float3 eyeVec = normalize(worldPos.xyz - _WorldSpaceCameraPos);
                float oneMinusReflectivity = 1 - SpecularStrength(data.specularColor.rgb);
                UnityIndirect ind;
                UNITY_INITIALIZE_OUTPUT(UnityIndirect, ind);
                float4 res = UNITY_BRDF_PBS(data.diffuseColor, data.specularColor, oneMinusReflectivity, data.smoothness, data.normalWorld, -eyeVec, light, ind);
                res.rgb += gbuffer3.rgb;
                return res;
            }

            ENDCG
        }
    }
}
