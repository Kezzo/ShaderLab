using UnityEngine;

[ExecuteInEditMode]
public class RenderImageIterated : MonoBehaviour
{
    [SerializeField]
    private Material imageEffectMaterial;

    [Range(0, 50)]
    [SerializeField]
    private int iterations = 0;

    [Range(0,4)]
    [SerializeField]
    private int downResolution;

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        int width = source.width >> downResolution;
        int height = source.height >> downResolution;

        RenderTexture renderTexture = RenderTexture.GetTemporary(width, height);
        Graphics.Blit(source, renderTexture);

        for (int i = 0; i < iterations; i++)
        {
            RenderTexture renderTexture2 = RenderTexture.GetTemporary(renderTexture.width, renderTexture.height);
            Graphics.Blit(renderTexture, renderTexture2, imageEffectMaterial);
            RenderTexture.ReleaseTemporary(renderTexture);
            renderTexture = renderTexture2;
        }

        Graphics.Blit(renderTexture, destination);
        RenderTexture.ReleaseTemporary(renderTexture);
    }
}
