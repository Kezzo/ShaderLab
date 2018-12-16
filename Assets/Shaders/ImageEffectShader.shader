Shader "Custom/ImageEffectShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _DisplaceTex ("Displacement Texture", 2D) = "white" {}
        _Magnitude ("Magnitute", Range(0, 0.1)) = 0
        _TimeInfluence ("TimeInfluence", Range(0, 4)) = 0
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
            sampler2D _DisplaceTex;
            half _Magnitude;
            half _TimeInfluence;
            
            fixed4 frag (v2f i) : SV_Target
            {
                float2 distuv = float2(i.uv.x + _Time.x * _TimeInfluence,i.uv.y + _Time.x * _TimeInfluence);
                float2 disp = tex2D(_DisplaceTex, distuv).xy;
                disp = ((disp * 2) - 1) * _Magnitude;
            
                float4 color = tex2D(_MainTex, i.uv + disp);
                return float4(i.uv.r * color.r, i.uv.g * color.g, color.b * 0, 1);
            }
            ENDCG
        }
    }
}
