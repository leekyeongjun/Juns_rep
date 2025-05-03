using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraPosSetTrigger : MonoBehaviour
{
    public Transform targetPos;
    public bool activated = false;

    private void OnTriggerEnter(Collider collision) {
        if(!activated){
            if(collision.transform.CompareTag("Player")){
                if(CameraController.cam != null){
                    CameraController.cam.SetOriginalPos(targetPos);
                    CameraController.cam.ChasingMC = false;
                }
            }
        }

    }    
}
