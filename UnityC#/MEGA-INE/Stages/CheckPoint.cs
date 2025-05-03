using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CheckPoint : MonoBehaviour
{
    public int id;
    public GameObject CheckPointFX;
    private SpriteRenderer spriterenderer;

    public bool ischecked = false;


    private void Awake() {
        spriterenderer = GetComponent<SpriteRenderer>();
    }
    private void OnTriggerEnter2D(Collider2D collision) {
        if(id != 0){
            if(collision.tag == "Player"){
                if(Player.player.Died) return;
                if(ischecked == false){
                    GameManager.GM.startpoint.index = id;
                    Instantiate(CheckPointFX, transform.position, transform.rotation);
                    transform.GetComponent<Animator>().SetTrigger("OnSave");
                    ischecked = true;
                }

            }
        }

        
    }
}
