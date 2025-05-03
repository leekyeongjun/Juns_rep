using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Portal : MonoBehaviour
{
    public string Destination;

    private void OnTriggerEnter2D(Collider2D collision) {
        if(collision.transform.CompareTag("Player")) StartCoroutine(PortalMove());
    }

    public IEnumerator PortalMove(){
        SoundManager.SM.SoundOFF();
        yield return new WaitForSeconds(.3f);
        GameManager.GM.ResetPlayer();
        GameManager.GM.LoadtoScene(Destination);
    }
}
