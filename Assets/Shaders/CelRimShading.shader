Shader "Custom/CelRimShading"
{
    Properties
    {
        _Texture ("Texture", 2D) = "white" {}
        _ShadingLUT ("ShadingLUT", 2D) = "white" {}
        _RimColor ("RimColor", Color) = (1,1,1,1)
        _RimPower("RimPower", Range(0, 1)) = 0.0
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
            #pragma multi_compile_fwdbase

            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "Lighting.cginc"

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
                float3 normal : TEXCOORD1;
                float3 viewDir : TEXCOORD2;
            };

            sampler2D _ShadingLUT;
            sampler2D _Texture;
            fixed4 _RimColor;
            float _RimPower;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                // calculate normals into worldspace
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.uv = v.uv;
                o.viewDir = normalize(UnityWorldSpaceViewDir(mul(unity_ObjectToWorld, v.vertex)));
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 normal = normalize(i.normal);
                float ndot = dot(normal, _WorldSpaceLightPos0);
                float sndot = saturate(dot(normal, i.viewDir));
                
                float3 lighting = tex2D(_ShadingLUT, float2(ndot, 0));
                float3 rim = _RimColor * pow(sndot, _RimPower) * ndot;
                
                float3 directDiffuse = lighting * _LightColor0;
                float indirectDiffuse = unity_AmbientSky;
                
                // sample the texture
                fixed4 textureColor = tex2D(_Texture, i.uv);
                textureColor.rgb *= directDiffuse + indirectDiffuse;
                textureColor.rgb *= lighting;
                textureColor.rgb *= rim;
                textureColor.a = 1.0;
                
                return textureColor;
            }
            ENDCG
        }
    }
}
