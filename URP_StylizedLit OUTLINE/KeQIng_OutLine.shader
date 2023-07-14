Shader "TOON/KeQIng_OutLine"
{
    Properties
    {
        [Header(BASE)]
        [HDR][MainColor]_BaseColor ("_BaseColor", Color) = (1, 1, 1, 1)
        [MainTexture]_BaseMap ("_BaseMap (Albedo)", 2D) = "black" { }
        
        [Header(OUTLINE)]
        _OutlineWidth ("_OutlineWidth (World Space)", Range(0, 4)) = 1
        _OutlineColor ("Outline Color", color) = (0.5, 0.5, 0.5, 1)
        [HideInInspector]_OutlineZOffset ("_OutlineZOffset (View Space) (increase it if is face!)", Range(0, 1)) = 0.0001
    }

    SubShader
    {
        Tags { "RenderPipeline" = "UniversalPipeline" "RenderType" = "Opaque" "UniversalMaterialType" = "Lit" "Queue" = "Geometry" }
        HLSLINCLUDE
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        ENDHLSL

        Pass
        {
            NAME "BASE"
            Tags { "LightMode" = "UniversalForward" }
            Cull Back
            ZTest LEqual
            ZWrite On
            Blend One Zero

            HLSLPROGRAM
            #pragma vertex ToonPassVertex
            #pragma fragment ToonPassFragment
            #include "./Base.hlsl"
            ENDHLSL
        }

        Pass
        {
            Name "OUTLINE"
            Tags {}
            Cull Front

            HLSLPROGRAM
            #pragma shader_feature_local_fragment ENABLE_ALPHA_CLIPPING
            #pragma vertex OutlinePassVertex
            #pragma fragment OutlinePassFragment
            #include "./Base.hlsl"
            ENDHLSL
        }

        Pass
        {
            Name "SHADOW"
            Tags {"LightMode" = "ShadowCaster"}
            Cull Front

            HLSLPROGRAM
            #pragma shader_feature_local_fragment ENABLE_ALPHA_CLIPPING
            #pragma vertex ToonPassVertex
            #pragma fragment ToonPassFragment
            #include "./Base.hlsl"
            ENDHLSL
        }
    }
}
