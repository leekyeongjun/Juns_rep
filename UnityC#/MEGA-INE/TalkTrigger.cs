using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TalkTrigger : MonoBehaviour
{
    public int TriggerID;
    public bool activated = false;

    private void OnTriggerEnter2D(Collider2D collision) {
        if(activated == false){
            if(collision.transform.CompareTag("Player")){
                activated = true;
                UserInterFace.ui.SetNPCID(TriggerID);
                UserInterFace.ui.Talk();
            }
        }
    }
}
