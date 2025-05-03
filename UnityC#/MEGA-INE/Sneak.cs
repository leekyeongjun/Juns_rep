using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Sneak : MonoBehaviour
{
    public Color IdleColor;

    private void OnTriggerStay2D(Collider2D collision) {
        if(collision.transform.CompareTag("Player")){
            Player.player.IsSneaking = true;
            collision.transform.gameObject.tag = "SneakedPlayer";

        }
    }

    private void OnTriggerExit2D(Collider2D collision) {
        if(collision.transform.CompareTag("SneakedPlayer")){
            Player.player.IsSneaking = false;
            collision.transform.gameObject.tag = "Player";
            collision.transform.GetComponent<SpriteRenderer>().color = IdleColor;
        }
        
    }
}
