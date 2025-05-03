using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FireBallChaser : MonoBehaviour
{
    public Transform ChasePos;

    // Update is called once per frame
    void Update()
    {
        transform.position = ChasePos.position;
    }
}
