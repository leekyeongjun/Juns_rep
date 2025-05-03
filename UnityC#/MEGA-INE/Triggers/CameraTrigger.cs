using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraTrigger : MonoBehaviour
{
    private void OnTriggerEnter2D(Collider2D collision) {
        if(collision.transform.CompareTag("Player")){
            StartCoroutine(CameraController.cam.ZoomOut(10f, 0.8f));
        }
    }
}
