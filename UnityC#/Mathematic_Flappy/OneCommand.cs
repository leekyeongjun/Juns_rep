using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OneCommand : MonoBehaviour
{
    public Rigidbody2D rigid;
    Animator anim;
    public AudioSource BirdSound_1;   
    public AudioSource BirdSound_2;
    public AudioSource BirdSound_3;
    public AudioSource BirdSound_4;


    void Start()
    {
        rigid = GetComponent<Rigidbody2D>();
        anim = GetComponent<Animator>();
    }

    void Update()
    {
        anim.SetFloat("Velocity", rigid.velocity.y);
        anim.SetBool("isDie", !(GameManager.GM.onGame));
        if(GameManager.GM.onGame){
            GetInput();
        }
        LimitMovement();
        Turn();

    }



    void GetInput(){
        if((Input.touchCount == 1 && Input.GetTouch(0).phase == TouchPhase.Began) || Input.GetMouseButtonDown(0)){
            rigid.velocity = Vector3.zero;
            rigid.AddForce(Vector3.up * 270);
            BirdSound_1.Play();
        }
        if(Input.GetKeyDown(KeyCode.Escape)) Application.Quit();
    }

    void Turn(){
        if(rigid.velocity.y > 0) transform.rotation = Quaternion.Euler(0,0,Mathf.Lerp(transform.rotation.z, 30f, rigid.velocity.y / 8f));
        else transform.rotation = Quaternion.Euler(0,0,Mathf.Lerp(transform.rotation.z, -90f, -rigid.velocity.y / 8f));
    }

    void LimitMovement(){
        if(transform.position.y > 4.75f) transform.position = new Vector3(-1.5f, 4.75f, 0f);

    }

    public void pop(){
        rigid.AddForce(Vector3.up * 270);    
    }

    private void OnCollisionEnter2D(Collision2D collision) {
        if(collision.gameObject.CompareTag("Obstacle")){
            BirdSound_3.Play();
            GameManager.GM.GameOver();
        }
    }
    private void OnTriggerEnter2D(Collider2D collision) {
        if(collision.gameObject.CompareTag("Obstacle")){
            BirdSound_3.Play();
            GameManager.GM.GameOver();
        }
        else if(collision.gameObject.CompareTag("Point")){
            BirdSound_2.Play();
            GameManager.GM.GetPoint();
        }
    }

}
