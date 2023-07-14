#pragma once
#include "./Data.hlsl"
#include "./FunctionCore.hlsl"

//前向渲染
Varyings ToonPassVertex(Attributes input)
{
    Varyings output = (Varyings)0;
    output.color = input.color;
    output.positionCS = TransformObjectToHClip(input.positionOS);
    output.uv.xy = TRANSFORM_TEX(input.texcoord, _BaseMap);
    return output;
}
half4 ToonPassFragment(Varyings input): COLOR
{
    half4 baseColor = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, input.uv.xy);
    return  _BaseColor;
}

//miaobian
Varyings OutlinePassVertex(Attributes input)
{
    Varyings output = (Varyings)0;
    output.color = input.color;

    VertexNormalInputs vertexNormalInput = GetVertexNormalInputs(input.normalOS, input.tangentOS);
    output.normalWS = vertexNormalInput.normalWS;

    half3 smoothedNormalTS = half3(input.smoothedNormalTS.x, input.smoothedNormalTS.y, 0);
    smoothedNormalTS *= 2;
    smoothedNormalTS -= 1;
    smoothedNormalTS.z = sqrt(1-dot(smoothedNormalTS.xy,smoothedNormalTS.xy));
    half3 smoothedNormalWS = normalize(TransformTangentToWorld(smoothedNormalTS, half3x3(vertexNormalInput.tangentWS, vertexNormalInput.bitangentWS, vertexNormalInput.normalWS)));

    output.positionWS = TransformObjectToWorld(input.positionOS);
    float3 positionVS = TransformWorldToView(output.positionWS);

    output.positionWS = TransformPositionWSToOutlinePositionWS(input.color.a, output.positionWS, positionVS.z, smoothedNormalWS);
    output.positionCS = TransformWorldToHClip(output.positionWS);

    output.uv.xy = TRANSFORM_TEX(input.texcoord, _BaseMap);
    return output;
    }
    half4 FragmentAlphaClip(Varyings input): SV_TARGET
    {
    UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input);
    #if ENABLE_ALPHA_CLIPPING
        clip(SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, input.uv).b - _Cutoff);
    #endif
    return 0;
}
float4 OutlinePassFragment(Varyings input): COLOR
{
    half4 baseColor = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, input.uv.xy);
    half4 FinalColor = _OutlineColor;
    return FinalColor;
}