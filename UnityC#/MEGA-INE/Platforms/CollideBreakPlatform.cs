using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CollideBreakPlatform : MonoBehaviour
{
    public float BreakTime;
    public float RegenerationTime;

    public bool Enabled = false;
    public bool Broken = false;
    BoxCollider2D C;
    AudioSource A;

    public List<Transform> Parts;

    void Awake(){
        C = transform.GetComponent<BoxCollider2D>();
        A = transform.GetComponent<AudioSource>();
        foreach(Transform child in transform){
            Parts.Add(child);
        }
    }

    private void OnCollisionEnter2D(Collision2D collision) {
        if(collision.transform.CompareTag("Player")){
            StartCoroutine(PlatformDestroy());
        }
    }
    

    public IEnumerator PlatformDestroy(){
        if(Broken == false){
            
            yield return new WaitForSeconds(BreakTime);
            if(Enabled == false)
            {
                Enabled = true;
                A.Play();
            }
            
            foreach(Transform Part in Parts){
                Part.gameObject.GetComponent<Animator>().SetBool("PlatformRegenerate", false);
                Part.gameObject.GetComponent<Animator>().SetBool("PlatformDestroy", true);
            }
            
            C.enabled = false;
            Broken = true;
            yield return new WaitForSeconds(RegenerationTime);
            foreach(Transform Part in Parts){
                Part.gameObject.GetComponent<Animator>().SetBool("PlatformDestroy", false);
                Part.gameObject.GetComponent<Animator>().SetBool("PlatformRegenerate", true);
            }
            C.enabled = true;
            Broken = false;
            Enabled = false;
        }


    }
}
