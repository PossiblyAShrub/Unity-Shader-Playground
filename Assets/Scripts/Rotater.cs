using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rotater : MonoBehaviour
{
    private void Update()
    {
        this.transform.Rotate(new Vector3(0, Time.deltaTime * 5, 0));
    }
}
