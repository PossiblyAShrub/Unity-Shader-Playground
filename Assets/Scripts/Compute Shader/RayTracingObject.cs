using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode()]
[RequireComponent(typeof(MeshRenderer))]
[RequireComponent(typeof(MeshFilter))]
public class RayTracingObject : MonoBehaviour
{
    private void OnEnable()
    {
        RayTracingMaster.RegisterObject(this);
        beforeTransform = this.transform;
    }

    private void OnDisable()
    {
        RayTracingMaster.UnregisterObject(this);
    }

    Transform beforeTransform;

    private void Update()
    {
        if (beforeTransform != this.transform)
        {
            RayTracingMaster.UnregisterObject(this);
            RayTracingMaster.RegisterObject(this);
        }
    }
}