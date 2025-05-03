using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Jumper : MonoBehaviour
{

    public List<Transform> Elements;

    public float JumperCool = .5f;
    public bool JumperReady = true;
    public float force;

    public AudioClip JumperSound;
    public AudioSource audioSource;

    void Awake()
    {
        audioSource = GetComponent<AudioSource>();
        foreach(Transform child in transform){
            Elements.Add(child);
        }
        
    }

    private void OnCollisionEnter2D(Collision2D collision) {
        if(collision.transform.CompareTag("Player")){
            StartCoroutine(JumperActivate(collision.transform));
        }
    }

    public IEnumerator JumperActivate(Transform p){
        if(JumperReady){
            var rigid = p.gameObject.GetComponent<Rigidbody2D>();
            rigid.velocity = Vector2.up * force;
            audioSource.clip = JumperSound;
            audioSource.Play();
            foreach(Transform e in Elements){
                e.gameObject.GetComponent<Animator>().SetTrigger("JumperOn");
            }
            JumperReady = false;
            yield return new WaitForSeconds(JumperCool);
            JumperReady = true;
        }
    }

}
