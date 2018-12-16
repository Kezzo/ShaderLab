Shader "Custom/CelShading"
{
    Properties
    {
        _Texture ("Texture", 2D) = "white" {}
        _ShadingLUT ("ShadingLUT", 2D) = "white" {}
    }
    SubShader
    {
        Tags
        {
            "LightMode" = "ForwardBase"
        }
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
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
            };

            sampler2D _ShadingLUT;
            sampler2D _Texture;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                // calculate normals into worldspace
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 normal = normalize(i.normal);
                float ndot = dot(normal, _WorldSpaceLightPos0);
                float sndot = saturate(ndot);
                
                fixed4 lighting = tex2D(_ShadingLUT, float2(ndot, 0));
                // sample the texture
                fixed4 textureData = tex2D(_Texture, i.uv);
                return textureData * lighting;
            }
            ENDCG
        }
    }
}
