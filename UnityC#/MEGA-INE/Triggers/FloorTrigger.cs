using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FloorTrigger : MonoBehaviour
{
    public FloorMove floor;

    private void OnTriggerEnter2D(Collider2D collision) {
        if(collision.transform.CompareTag("Player")){
            floor.StopMoveFloor();
        }
    }    
}
