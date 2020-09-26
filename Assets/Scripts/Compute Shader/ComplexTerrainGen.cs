using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ComplexTerrainGen : MonoBehaviour
{
    public ComputeShader ComplexTerrainGenerator;

    [Header("Terrain Settings")]
    public Vector3 size;

    [Header("Debug")]

    public GameObject cubePrefab;

    struct ComplexTerrain
    {
        public Vector3[] cubes;
    }

    void ShowTerrain(ComplexTerrain terrain)
    {
        foreach (Vector3 cube in terrain.cubes)
        {
            Instantiate(cubePrefab, cube, Quaternion.identity);
        }
    }

    int kernel;
    public RenderTexture result;
    public RawImage screen;

    public void Render()
    {
        ComplexTerrainGenerator.SetTexture(kernel, "Result", result);
        ComplexTerrainGenerator.Dispatch(kernel, Screen.width / 8, Screen.height / 8, 1);
    }

    private void Start()
    {
        kernel = ComplexTerrainGenerator.FindKernel("CSMain");

        result = new RenderTexture(Screen.width, Screen.height, 24);
        result.enableRandomWrite = true;
        result.Create();
        screen.texture = result;
    }

    private void Update()
    {
        Render();
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(result, destination);
    }
}