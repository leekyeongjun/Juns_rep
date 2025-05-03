using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BlinkingPlatform : MonoBehaviour
{

    public GameObject platform;
    public float maintainCooltime;
    public float CreationCooltime;
    private bool creatable = true;

    private void Update() {
        StartCoroutine(BlinkPlatform());

    }

    public IEnumerator BlinkPlatform(){
        if(creatable){
            GameObject p = Instantiate(platform, transform.position, platform.transform.rotation);
            creatable = false;
            yield return new WaitForSeconds(maintainCooltime);
            Destroy(p);
            yield return new WaitForSeconds(CreationCooltime);
            creatable = true;
        }

    }

    private void OnDrawGizmos(){
        Gizmos.color = Color.blue;
        if(platform.GetComponent<BoxCollider2D>()) Gizmos.DrawWireCube(new Vector2(transform.position.x+ platform.transform.GetComponent<BoxCollider2D>().offset.x, transform.position.y +platform.transform.GetComponent<BoxCollider2D>().offset.y ),platform.transform.GetComponent<BoxCollider2D>().size);
        else if(platform.GetComponent<LaserAttack>()) Gizmos.DrawWireCube(new Vector2(transform.position.x, transform.position.y), platform.GetComponent<LaserAttack>().boxSize);
    }
    
}
