using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FloorMove : MonoBehaviour
{
    public bool isMoving = false;
    public bool isTriggerMoving = false;
    
    public bool DestroyAfterMove = false;

    public bool isSpike = false;

    public int AtkPower;
    public float knockbackPower;

    public Transform destination;
    public float movingCooltime;
    private float curMovingtime;
    public float movingSpeed;
    private Vector3 initiatedPos;
    private Vector3 destPos;


    

    // Start is called before the first frame update
    void Awake()
    {
        if(isMoving || isTriggerMoving){
            if(destination == null) return;
            destPos =  destination.position;
            initiatedPos = transform.position;
        }

    }
 
    private void OnCollisionEnter2D(Collision2D collision) {
        if(isSpike){

            if(collision.transform.CompareTag("Player")){
                collision.transform.GetComponent<BattleBehaviour>().GetSpikeDamaged(AtkPower, knockbackPower, transform, true, true,true,false);
            }
        }
        if(isMoving){
            if(collision.transform.CompareTag("Player")){
                collision.transform.SetParent(transform);
            }           
        }
        else if(isTriggerMoving){
            if(collision.transform.CompareTag("Player")){
                isMoving = true;
                collision.transform.SetParent(transform);
            }           
        } 
    }

    private void OnCollisionExit2D(Collision2D collision) {
        if(isMoving){
            if(collision.transform.CompareTag("Player")){
                collision.transform.SetParent(null);
            }      
        }
    }

    private void OnCollisionStay2D(Collision2D collision) {
        if(isSpike){
            if(collision.transform.CompareTag("Player")){
                collision.transform.GetComponent<BattleBehaviour>().GetSpikeDamaged(AtkPower, knockbackPower, transform, true, true,true,false);
            }
        }        
    }

    // Update is called once per frame
    void Update()
    {

        if(isMoving){
            if(destPos == null) return;
            if(curMovingtime <= 0){
                transform.position = Vector3.MoveTowards(transform.position, destPos, Time.deltaTime*movingSpeed);
                if(transform.position == destPos){
                    if(DestroyAfterMove){
                        Destroy(transform.gameObject);
                        return;
                    }
                    curMovingtime = movingCooltime;
                    Vector3 tmp = transform.position;
                    destPos = initiatedPos;
                    initiatedPos = tmp;
                }
            }
            else{
                curMovingtime -= Time.deltaTime;
            }
        }
    }

    public void StopMoveFloor(){
        isMoving = false;
    }
}
