#pragma once

struct Attributes
{
    float3 positionOS: POSITION;
    half4 color: COLOR0;
    half3 normalOS: NORMAL;
    half4 tangentOS: TANGENT;
    float2 texcoord: TEXCOORD0;
    float3 smoothedNormalTS: TEXCOORD1;
};

struct Varyings
{
    float4 positionCS: POSITION;
    float4 color: COLOR0;
    float2 uv: TEXCOORD0;
    float3 positionWS: TEXCOORD1;
    float3 normalWS: TEXCOORD2;
    float2 matCapUV: TEXCOORD3;
    float lambert: TEXCOORD4;
};

TEXTURE2D(_BaseMap);        
SAMPLER(sampler_BaseMap);

CBUFFER_START(UnityPerMaterial)
float4 _BaseMap_ST;
float4 _BaseColor;
float _OutlineWidth;
half4 _OutlineColor;
//float _OutlineZOffset;
CBUFFER_END