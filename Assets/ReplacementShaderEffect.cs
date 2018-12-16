using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class ReplacementShaderEffect : MonoBehaviour
{
    [SerializeField]
    private Shader replacementShader;

    [SerializeField]
    private Color overdrawColor;

    private void OnValidate()
    {
        Shader.SetGlobalColor("_OverDrawColor", overdrawColor);
    }

    private void OnEnable()
    {
        if(replacementShader != null)
        {
            this.GetComponent<Camera>().SetReplacementShader(replacementShader, "");
        }
    }

    private void OnDisable()
    {
        this.GetComponent<Camera>().ResetReplacementShader();
    }
}
