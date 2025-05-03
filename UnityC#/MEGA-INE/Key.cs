using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Key : MonoBehaviour
{
    public Puzzle targetpuzzle;
    public GameObject GetKeyFX;

    private void Awake(){
        targetpuzzle = transform.parent.GetComponent<Puzzle>();
    }
    private void OnTriggerEnter2D(Collider2D collision) {
        if(collision.transform.CompareTag("Player")){
            targetpuzzle.active = true;
            DestroyThis();
        }
    }

    private void DestroyThis(){
        if(GetKeyFX != null){
            Instantiate(GetKeyFX, transform.position, GetKeyFX.transform.rotation);
        }
        Destroy(gameObject);
    }
}
