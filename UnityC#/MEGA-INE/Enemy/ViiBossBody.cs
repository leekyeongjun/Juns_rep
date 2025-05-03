using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ViiBossBody : MonoBehaviour
{

    public bool White = false;
    public bool Dark = false;
    public bool Sword = false;

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
            int patternID = Random.Range(1,5);
            Pattern(patternID);
            float cool = patternCoolTime;
            yield return new WaitForSeconds(cool);
            canPattern = true;
        }
    }

    public void Pattern(int patternID){

        if(patternID == 1){
            if(White) StartCoroutine(bossattack.ViiBossMove(2f));
            if(Sword) StartCoroutine(bossattack.ViiBossMove(2f));
            if(Dark) StartCoroutine(bossattack.ViiBossMove(2f));
        }
        if(patternID == 2){
            if(White) StartCoroutine(bossattack.ShootBoomerang());
            if(Sword) StartCoroutine(bossattack.ShootSwordWaveRadial360(10, 5));
            if(Dark) StartCoroutine(bossattack.ViiSummonLaser());
        }
        if(patternID == 3){
            if(White) StartCoroutine(bossattack.ShootBulletRadial180(5, 90f));
            if(Sword) StartCoroutine(bossattack.ViiSwordTeleportSwordWave());
            if(Dark) StartCoroutine(bossattack.ViiBossTeleport());
        }
        if(patternID == 4){
            if(White) StartCoroutine(bossattack.ViiBossMove(2f));
            if(Sword) StartCoroutine(bossattack.ViiSwordTeleport());
            if(Dark) StartCoroutine(bossattack.ShootBulletRadial180(5, -90f));
        }
    }

    void PatternOn(){
        canPattern = true;
    }

}
