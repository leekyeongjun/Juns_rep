using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Item : MonoBehaviour
{
    public bool HealthUp;
    public bool SkillUp;
    public bool MaxUp;

    public bool isSelfDestruct = false;
    public GameObject DestroyFX;
    public GameObject GetFx;
    public bool isMoving = false;
    public bool left = false;
    public float speed;
    public float Dtime = 5f;


    public int amount;

    private void Start() {
        if(isSelfDestruct){
            Invoke("SelfDestruct", Dtime);
        }
    }
    private void Update() {
        if(isMoving){
            ItemMove();
        }
    }

    private void OnTriggerEnter2D(Collider2D collision) {
        if(collision.transform.CompareTag("Player")){
            if(HealthUp) collision.transform.GetComponent<BattleBehaviour>().HealUp(amount);
            if(SkillUp) collision.transform.GetComponent<PlayerAttack>().SPup(amount);
            if(MaxUp){
                collision.transform.GetComponent<PlayerAttack>().SPup(99);
                collision.transform.GetComponent<BattleBehaviour>().HealUp(99);
            }
            Instantiate(GetFx, transform.position, Quaternion.identity);
            Destroy(gameObject);
        }
    }
    private void OnCollisionEnter2D(Collision2D collision) {
        if(collision.transform.CompareTag("Player")){
            if(HealthUp) collision.transform.GetComponent<BattleBehaviour>().HealUp(amount);
            if(SkillUp) collision.transform.GetComponent<PlayerAttack>().SPup(amount);
            if(MaxUp){
                collision.transform.GetComponent<PlayerAttack>().SPup(99);
                collision.transform.GetComponent<BattleBehaviour>().HealUp(99);
            }
            Instantiate(GetFx, transform.position, Quaternion.identity);
            Destroy(gameObject);
        }
    }

    public void ItemMove(){
        if(left) transform.Translate(transform.right *-1 *speed*Time.deltaTime);
        else transform.Translate(transform.right *speed*Time.deltaTime);
    }

    public void SelfDestruct(){
        Instantiate(DestroyFX, transform.position, Quaternion.identity);
        Destroy(gameObject);
    }


}
