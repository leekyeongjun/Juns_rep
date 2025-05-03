using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerTrigger : MonoBehaviour
{
    private void OnTriggerEnter2D(Collider2D collision) {
        if(collision.transform.CompareTag("Player")){
            Player.player.GetComponent<Movement2D>().Stop();
            Player.player.canControl = false;
        }
    }
}
