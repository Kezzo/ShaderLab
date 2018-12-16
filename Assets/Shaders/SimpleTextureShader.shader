// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/SimpleTextureShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex("Texture", 2D) = "white" {}
        _SecondTex("Second Texture", 2D) = "white" {}
        _Tween("Tween", Range(0, 1)) = 0.0
        _GrayScale("GrayScale", Range(0, 1)) = 0.0
    }

    SubShader
    {
        Tags
        {
            "Queue" = "Transparent"
        }
    
        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha
        
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
            sampler2D _SecondTex;
            fixed4 _Color;
            half _Tween;
            half _GrayScale;
            
            fixed4 frag (v2f i) : SV_Target
            {
                float4 mainTextColor = tex2D(_MainTex, i.uv * 2);
                float4 secondTextColor = tex2D(_SecondTex, i.uv * 2);
                
                float4 color = float4(i.uv.r * ((mainTextColor.r *  (1 - _Tween)) + (secondTextColor.r * _Tween)),
                    i.uv.g * ((mainTextColor.g *  (1 - _Tween)) + (secondTextColor.g * _Tween)),
                    (mainTextColor.b *  (1 - _Tween)) + (secondTextColor.b * _Tween),
                    mainTextColor.a);
                    
                half luminance = 0.3 * color.r + 0.59 * color.g + 0.11 * color.b;
                
                color = float4((color.r * (1 - _GrayScale)) + (luminance * _GrayScale),
                (color.g * (1 - _GrayScale)) + (luminance * _GrayScale),
                (color.b * (1 - _GrayScale)) + (luminance * _GrayScale),
                color.a);
                
                //color = float4(color.r * _Color.r * i.uv.r,
                //    color.g * _Color.g * i.uv.g, 
                //    color.b * _Color.b, 
                //    color.a);
                return color;
            }
            ENDCG
        }
    }
}
