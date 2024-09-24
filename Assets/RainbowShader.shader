Shader "Unlit/NewUnlitShader"
{
    Properties
    {
        _Frequency("Frequency", float) = 1
        [PerRendererData] _MainTex("Sprite Texture", 2D) = "white" {}
    }
        SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
            "Queue" = "Transparent"
        }
        LOD 200
        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata_t
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
                float4 color : COLOR;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float4 color : COLOR;
            };

            sampler2D _MainTex;
            float _Frequency;

            v2f vert(appdata_t v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;
                o.color = v.color;
                return o;
            }

            // Convert HSV to RGB
            float3 HSVToRGB(float h, float s, float v)
            {
                float3 rgb = float3(0.0, 0.0, 0.0);

                float c = v * s;
                float x = c * (1 - abs(fmod(h * 6.0, 2.0) - 1.0));
                float m = v - c;

                if (h < 1.0 / 6.0) rgb = float3(c, x, 0);
                else if (h < 2.0 / 6.0) rgb = float3(x, c, 0);
                else if (h < 3.0 / 6.0) rgb = float3(0, c, x);
                else if (h < 4.0 / 6.0) rgb = float3(0, x, c);
                else if (h < 5.0 / 6.0) rgb = float3(x, 0, c);
                else rgb = float3(c, 0, x);

                return rgb + m;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // Sample the sprite texture
                fixed4 texColor = tex2D(_MainTex, i.uv) * i.color;

            // Get the time and adjust with frequency
            float time = _Time.y * _Frequency;

            // Use a sine wave to cycle the hue between 0 and 1
            float hue = fmod(time * 0.1, 1.0);  // Slow down time for smooth transition

            // Convert HSV to RGB (with full saturation and brightness for a vivid rainbow effect)
            float3 rainbowColor = HSVToRGB(hue, 1.0, 1.0);

            // Combine the rainbow color with the texture color
            return texColor * float4(rainbowColor, 1.0);
        }
        ENDCG
    }
    }
        FallBack "Sprites/Default"
}
