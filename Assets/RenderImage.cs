using UnityEngine;

[ExecuteInEditMode]
public class RenderImage : MonoBehaviour
{
    [SerializeField]
    private Material imageEffectMaterial;

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, imageEffectMaterial);
    }
}
