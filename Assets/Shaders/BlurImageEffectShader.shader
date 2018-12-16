﻿Shader "Custom/BlurImageEffectShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }

    SubShader
    {
        // no culling or depth
        Cull Off ZWrite Off ZTest Always
        
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }
            
            sampler2D _MainTex;
            float4 _MainTex_TexelSize;
            
            float4 box(sampler2D text, float2 uv, float4 size)
            {
                float4 color = tex2D(text, uv + float2(-size.x, size.y)) +
                               tex2D(text, uv + float2(0, size.y)) +
                               tex2D(text, uv + float2(size.x, size.y)) +
                               
                               tex2D(text, uv + float2(size.x, 0)) +
                               tex2D(text, uv + float2(size.x, -size.y)) +
                               tex2D(text, uv + float2(0, -size.y)) +
                               
                               tex2D(text, uv + float2(-size.x, -size.y)) +
                               tex2D(text, uv + float2(-size.x, 0)) +
                               tex2D(text, uv + float2(0, 0));
                               
                return color / 9;
            }
            
            fixed4 frag (v2f i) : SV_Target
            {
                return box(_MainTex, i.uv, _MainTex_TexelSize);
            }
            ENDCG
        }
    }
}
