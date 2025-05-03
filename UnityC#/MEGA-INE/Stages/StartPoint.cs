using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StartPoint : MonoBehaviour
{

    public GameObject[] CheckPoints;
    public int index = 0;

    public Transform CheckPointPosition(){
        return CheckPoints[index].transform;
    }
}
