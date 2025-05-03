using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FlyTrigger : MonoBehaviour
{

    public bool Flyer = false;
    public bool Deflyer = false;
    public GameObject FlyingOnFX;

    private void OnTriggerEnter2D(Collider2D collision) {
        if(collision.transform.CompareTag("Player")){
            
            if(Flyer) 
                if(Player.player.IsFlying == false){
                    Instantiate(FlyingOnFX, Player.player.transform.position, FlyingOnFX.transform.rotation);
                    Player.player.IsFlying = true;
                    Player.player.movement2D.currentJumpCount = 2;
                }
            
            if(Deflyer){
                if(Player.player.IsFlying == true){
                    Instantiate(FlyingOnFX, Player.player.transform.position, FlyingOnFX.transform.rotation);
                    Player.player.IsFlying = false;
                    Player.player.movement2D.currentJumpCount = 2;
                }
            } 
        }

    }
}
