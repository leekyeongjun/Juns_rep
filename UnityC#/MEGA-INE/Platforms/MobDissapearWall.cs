using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MobDissapearWall : MonoBehaviour
{
    private void OnTriggerEnter2D(Collider2D collision) {
        if(collision.transform.CompareTag("Enemy")){
            Destroy(collision.transform.gameObject);
        }
    }
}
