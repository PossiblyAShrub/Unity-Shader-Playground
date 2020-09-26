using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class ComputShaderPreviewer : MonoBehaviour
{
    public ComputeShader computeShader;

    public int size = 512;
    public RenderTexture result;
    private int kernel;

    private void Start()
    {
        kernel = computeShader.FindKernel("CSMain");

        result = new RenderTexture(size, size, 24);
        result.enableRandomWrite = true;
        result.Create();
    }

    private void Update()
    {
        computeShader.SetTexture(kernel, "Result", result);
        computeShader.Dispatch(kernel, size / 8, size / 8, 1);
    }
}
