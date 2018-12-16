Shader "Custom/OverdrawShader"
{
    SubShader
    {
        Tags
        {
            "Queue"="Transparent"
        }

        ZTest Always
        ZWrite Off
        Blend One One
    
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                half4 vertex : POSITION;
            };

            struct v2f
            {
                half4 vertex : SV_POSITION;
                half depth : DEPTH;
            };
            
            
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 _OverDrawColor;
            
            fixed4 frag (v2f i) : SV_Target
            {
                return _OverDrawColor;
            }
            ENDCG
        }
    }
}
