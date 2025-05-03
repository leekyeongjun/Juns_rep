using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LilBossBody : MonoBehaviour
{

    public bool canPattern = false;

    public float patternCoolTime;
    public int patternID;
    
    private Rigidbody2D rigid2D;
    private Animator anim;
    private BattleBehaviour battleBehaviour;
    private IneBossAttack bossattack;
    private Movement2D movement2D;

    public BattleBehaviour HeartBehaviour;

    private void Awake() {
        anim = GetComponent<Animator>();    
        rigid2D = GetComponent<Rigidbody2D>();
        battleBehaviour = GetComponent<BattleBehaviour>();
        bossattack = GetComponent<IneBossAttack>();
        movement2D = GetComponent<Movement2D>();
    }


    void Start()
    {
        Invoke("PatternOn", 2f);
    }

    void Update()
    {
        if(HeartBehaviour.curHP > 0){
            StartCoroutine(UsePattern());
        }
        else{
            anim.SetBool("IsDying", true);
            StopAllCoroutines();
        }
        
    }
    public IEnumerator UsePattern(){
        if(canPattern){
            canPattern = false;
            int patternID = Random.Range(1,9);
            Pattern(patternID);
            float cool = patternCoolTime;
            yield return new WaitForSeconds(cool);
            canPattern = true;
        }
    }

    public void Pattern(int patternID){

        if(patternID == 1){
            StartCoroutine(bossattack.LilBossMove());
        }
        if(patternID == 2){
            StartCoroutine(bossattack.LilBossMove());
            StartCoroutine(bossattack.LilShootBulletRadial(3, 8, 180, 90));
        }
        if(patternID == 3){
            StartCoroutine(bossattack.LilBossMove());
            StartCoroutine(bossattack.LilShootBulletRadial(5, 32, 360, 0));
        }
        if(patternID == 4){
            StartCoroutine(bossattack.LilBossRush(2f));
        }
        if(patternID == 5){
            StartCoroutine(bossattack.LilSpawnDetector());
        }
        if(patternID == 6){
            StartCoroutine(bossattack.LilShootHellFire());
        }
        if(patternID == 7){StartCoroutine(bossattack.LilShootHellFire());}
        if(patternID == 8){StartCoroutine(bossattack.LilSpawnShooter());}
    }

    void PatternOn(){
        canPattern = true;
    }
}
