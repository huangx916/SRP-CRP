Shader "CustomRP/Deferred/Specular"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
        
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            void frag (v2f i,
                        out half4 outGBuffer0 : SV_Target0,
                        out half4 outGBuffer1 : SV_Target1,
                        out half4 outGBuffer2 : SV_Target2,
                        out half4 outEmission : SV_Target3)
            {
                LightingStandardSpecular_GI(o, giInput, gi);
                outEmission = LightingStandardSpecular_Deferred (o, worldViewDir, gi, outGBuffer0, outGBuffer1, outGBuffer2);
            }
            ENDCG
        }
        




        Pass {
CGPROGRAM
// compile directives
#pragma vertex tessvert_surf
#pragma fragment frag_surf
#pragma hull hs_surf
#pragma domain ds_surf
#pragma target 5.0

#pragma exclude_renderers nomrt
#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
#pragma multi_compile_prepassfinal
#define UNITY_PASS_DEFERRED

// -------- variant for: <when no other keywords are defined>
#if !defined(INSTANCING_ON)
// Surface shader code generated based on:
// vertex modifier: 'disp'
// writes to per-pixel normal: YES
// writes to emission: YES
// writes to occlusion: YES
// needs world space reflection vector: no
// needs world space normal vector: no
// needs screen space position: no
// needs world space position: no
// needs view direction: no
// needs world space view direction: no
// needs world space position for lighting: YES
// needs world space view direction for lighting: YES
// needs world space view direction for lightmaps: no
// needs vertex color: no
// needs VFACE: no
// passes tangent-to-world matrix to pixel shader: YES
// reads from normal: no
// 1 texcoords actually used
//   float2 _MainTex

#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
#define WorldNormalVector(data,normal) float3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))

// Original surface shader snippet:
#line 22 ""
#ifdef DUMMY_PREPROCESSOR_TO_WORK_AROUND_HLSL_COMPILER_LINE_HANDLING
#endif

// vertex-to-fragment interpolation data
struct v2f_surf {
UNITY_POSITION(pos);
float2 pack0 : TEXCOORD0; // _MainTex
float4 tSpace0 : TEXCOORD1;
float4 tSpace1 : TEXCOORD2;
float4 tSpace2 : TEXCOORD3;
#ifndef DIRLIGHTMAP_OFF
half3 viewDir : TEXCOORD4;
#endif
float4 lmap : TEXCOORD5;
#ifndef LIGHTMAP_ON
#if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
half3 sh : TEXCOORD6; // SH
#endif
#else
#ifdef DIRLIGHTMAP_OFF
float4 lmapFadePos : TEXCOORD6;
#endif
#endif

#if USE_DETAILALBEDO
float2 pack1 : TEXCOORD7;
#endif

#if USE_DETAILNORMAL
float2 pack2 : TEXCOORD8;
#endif
float3 worldViewDir : TEXCOORD9;
};
float4 _MainTex_ST;

// vertex shader
inline v2f_surf vert_surf (appdata_tess v) {
UNITY_SETUP_INSTANCE_ID(v);
v2f_surf o;
o.pos = UnityObjectToClipPos(v.vertex);
o.pack0.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
#if USE_DETAILALBEDO
o.pack1 = TRANSFORM_TEX(v.texcoord,_DetailAlbedo);
#endif
#if USE_DETAILNORMAL
o.pack2 = TRANSFORM_TEX(v.texcoord, _DetailBump);
#endif
float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
float3 worldNormal = UnityObjectToWorldNormal(v.normal);
float3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
float tangentSign = v.tangent.w * unity_WorldTransformParams.w;
float3 worldBinormal = cross(worldNormal, worldTangent) * tangentSign;
o.tSpace0 = (float4(worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x));
o.tSpace1 = (float4(worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y));
o.tSpace2 = (float4(worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z));

float3 viewDirForLight = (UnityWorldSpaceViewDir(worldPos));
#ifndef DIRLIGHTMAP_OFF
o.viewDir.x = dot(viewDirForLight, worldTangent);
o.viewDir.y = dot(viewDirForLight, worldBinormal);
o.viewDir.z = dot(viewDirForLight, worldNormal);
#endif
#ifdef DYNAMICLIGHTMAP_ON
o.lmap.zw = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
#else
o.lmap.zw = 0;
#endif
#ifdef LIGHTMAP_ON
o.lmap.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
#ifdef DIRLIGHTMAP_OFF
o.lmapFadePos.xyz = (mul(unity_ObjectToWorld, v.vertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w;
o.lmapFadePos.w = (-UnityObjectToViewPos(v.vertex).z) * (1.0 - unity_ShadowFadeCenterAndType.w);
#endif
#else
o.lmap.xy = 0;
#if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
o.sh = 0;
o.sh = ShadeSHPerVertex (worldNormal, o.sh);
#endif
#endif
o.worldViewDir = viewDirForLight;
return o;
}

// tessellation domain shader
[UNITY_domain("tri")]
inline v2f_surf ds_surf (UnityTessellationFactors tessFactors, const OutputPatch<InternalTessInterp_appdata_full,3> vi, float3 bary : SV_DomainLocation) {
appdata_tess v;
v.vertex = vi[0].vertex*bary.x + vi[1].vertex*bary.y + vi[2].vertex*bary.z;
#if USE_PHONG
float3 pp[3];
pp[0] = v.vertex.xyz - vi[0].normal * (dot(v.vertex.xyz, vi[0].normal) - dot(vi[0].vertex.xyz, vi[0].normal));
pp[1] = v.vertex.xyz - vi[1].normal * (dot(v.vertex.xyz, vi[1].normal) - dot(vi[1].vertex.xyz, vi[1].normal));
pp[2] = v.vertex.xyz - vi[2].normal * (dot(v.vertex.xyz, vi[2].normal) - dot(vi[2].vertex.xyz, vi[2].normal));
v.vertex.xyz = _Phong * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-_Phong) * v.vertex.xyz;
#endif
v.tangent = vi[0].tangent*bary.x + vi[1].tangent*bary.y + vi[2].tangent*bary.z;
v.normal = vi[0].normal*bary.x + vi[1].normal*bary.y + vi[2].normal*bary.z;
v.texcoord = vi[0].texcoord*bary.x + vi[1].texcoord*bary.y + vi[2].texcoord*bary.z;
v.texcoord1 = vi[0].texcoord1*bary.x + vi[1].texcoord1*bary.y + vi[2].texcoord1*bary.z;
v.texcoord2 = vi[0].texcoord2*bary.x + vi[1].texcoord2*bary.y + vi[2].texcoord2*bary.z;

#if USE_VERTEX
vert(v);
#endif
v2f_surf o = vert_surf (v);
return o;
}

#ifdef LIGHTMAP_ON
float4 unity_LightmapFade;
#endif
float4 unity_Ambient;

// fragment shader
void frag_surf (v2f_surf IN,
out half4 outGBuffer0 : SV_Target0,
out half4 outGBuffer1 : SV_Target1,
out half4 outGBuffer2 : SV_Target2,
out half4 outEmission : SV_Target3
) {
UNITY_SETUP_INSTANCE_ID(IN);
// prepare and unpack data
Input surfIN;
UNITY_INITIALIZE_OUTPUT(Input,surfIN);
surfIN.uv_MainTex.x = 1.0;

surfIN.uv_MainTex = IN.pack0.xy;
#if USE_DETAILALBEDO
surfIN.uv_DetailAlbedo = IN.pack1;
#endif

#if USE_DETAILNORMAL
surfIN.uv_DetailNormal = IN.pack2;
#endif
float3 worldPos = float3(IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w);
float3 worldViewDir = normalize(IN.worldViewDir);
#ifdef UNITY_COMPILER_HLSL
SurfaceOutputStandardSpecular o = (SurfaceOutputStandardSpecular)0;
#else
SurfaceOutputStandardSpecular o;
#endif



float3x3 wdMatrix= float3x3(  normalize(IN.tSpace0.xyz),  normalize(IN.tSpace1.xyz),  normalize(IN.tSpace2.xyz));
// call surface function
surf (surfIN, o);

o.Normal = normalize(mul(wdMatrix, o.Normal));

// Setup lighting environment
UnityGI gi;
UNITY_INITIALIZE_OUTPUT(UnityGI, gi);

gi.indirect.diffuse = 0;
gi.indirect.specular = 0;
gi.light.color = 0;
gi.light.dir = half3(0,1,0);
// Call GI (lightmaps/SH/reflections) lighting function
UnityGIInput giInput;
UNITY_INITIALIZE_OUTPUT(UnityGIInput, giInput);
giInput.light = gi.light;
giInput.worldPos = worldPos;
giInput.worldViewDir = worldViewDir;
giInput.atten = 1;
#if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON)
giInput.lightmapUV = IN.lmap;
#else
giInput.lightmapUV = 0.0;
#endif
#if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
giInput.ambient = IN.sh;
#else
giInput.ambient.rgb = 0.0;
#endif

LightingStandardSpecular_GI(o, giInput, gi);

// call lighting function to output g-buffer
outEmission = LightingStandardSpecular_Deferred (o, worldViewDir, gi, outGBuffer0, outGBuffer1, outGBuffer2);
}

#endif

ENDCG

}




    }
}
