using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Ladders : MonoBehaviour
{

    private void OnTriggerStay2D(Collider2D collision) {
        if(collision.CompareTag("Player")){
            if(Player.player.movement2D.isDashing != true) Player.player.movement2D.inLadder = true;
            
        }
    }

    private void OnTriggerExit2D(Collider2D collision) {
        if(collision.CompareTag("Player")){
            Player.player.movement2D.inLadder = false;
        }        
    }
}
