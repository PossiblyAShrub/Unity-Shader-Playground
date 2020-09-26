using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class SceenEffectApplier : MonoBehaviour
{
    public Material screenEffectMat;

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, screenEffectMat);
    }
}
