using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class IneBossBody : MonoBehaviour
{

    public bool headpart = false;
    public bool heartpart = false;
    public bool cannonpart = false;
    public bool spikepart = false;
    

    public float offset_x;
    public float offset_y;

    public Vector2 boxSize;

    public bool canPattern = false;

    public float patternCoolTime;
    public int patternID;

    private Rigidbody2D rigid2D;
    private Animator anim;
    private BattleBehaviour battleBehaviour;
    private IneBossAttack bossattack;

    public BattleBehaviour HeartBehaviour;
    
    private void Awake() {
        anim = GetComponent<Animator>();    
        rigid2D = GetComponent<Rigidbody2D>();
        battleBehaviour = GetComponent<BattleBehaviour>();
        bossattack = GetComponent<IneBossAttack>();

    }
    // Start is called before the first frame update
    void Start()
    {
        Invoke("PatternOn", 3f);
    }

    // Update is called once per frame
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

    private void FixedUpdate() {
        Collider2D[] collider2Ds = Physics2D.OverlapBoxAll(new Vector3(transform.position.x + offset_x, transform.position.y + offset_y, transform.position.z),boxSize,0);
        foreach (Collider2D collider in collider2Ds)
        {
            if(collider.tag == "Player"){
                collider.GetComponent<BattleBehaviour>().GetDamaged(battleBehaviour.meleeDamage, battleBehaviour.meleeknockbackPower, transform, true,true,true,true);
            }
        }
    }

    public IEnumerator UsePattern(){
        if(canPattern){
            canPattern = false;
            int patternID = Random.Range(1,5);
            Pattern(patternID);
            float cool = Random.Range(patternCoolTime - 2f, patternCoolTime + 2f);
            yield return new WaitForSeconds(cool);
            canPattern = true;
        }
    }

    public void Pattern(int patternID){

        if((patternID) == 1){
            if(headpart) ShootLaser();
            if(cannonpart) ShootBullet_1();
            if(spikepart) SpinMove();
            if(heartpart) SummonSpinning();
        }
        if((patternID) == 2){
            if(headpart) ShootBullet_3();
            if(heartpart) SummonHP();
            if(cannonpart) ShootBullet_2();
            if(spikepart) DrillPush();
        }
        if(patternID == 3){
            if(headpart) ShootLaserPillar();
            if(heartpart) SummonSP();
            if(spikepart) SpinMove();
            if(cannonpart) ShootBullet_4();
        }
        if(patternID == 4){
            if(headpart) ShootLaserPillar_2();
            if(heartpart) SummonDulgi();
            if(cannonpart) ShootBullet_2();
            if(spikepart) DrillPush();
        }
    }

    public void ShootLaser(){ StartCoroutine(bossattack.LaserShoot());}
    public void ShootLaserPillar(){ StartCoroutine(bossattack.LaserPillarBurst(0));}
    public void ShootLaserPillar_2(){ StartCoroutine(bossattack.LaserPillarBurst(-1));}
    public void ShootBullet_1(){StartCoroutine(bossattack.ShootBulletRadial(15));}
    public void ShootBullet_2(){ StartCoroutine(bossattack.ShootBulletDirectional(3));}
    public void ShootBullet_3(){ StartCoroutine(bossattack.ShootGreenBulletDirectional(1));}
    public void ShootBullet_4(){StartCoroutine(bossattack.ShootBulletRadial(10));}

    public void SpinMove(){       
        StartCoroutine(bossattack.SpinMoveActivate(2));
    }

    public void DrillPush(){
       StartCoroutine(bossattack.DrillPush());
    }

    public void SummonSpinning(){ StartCoroutine(bossattack.SummonspinningDulgi());}
    public void SummonHP(){ StartCoroutine(bossattack.SummonHpbox());}
    public void SummonSP(){ StartCoroutine(bossattack.SummonSpbox());}
    public void SummonDulgi(){StartCoroutine(bossattack.SummonDulgi());}


    private void OnDrawGizmos() {
        Gizmos.color = Color.blue;
        Gizmos.DrawWireCube(new Vector3(transform.position.x + offset_x, transform.position.y + offset_y, transform.position.z), boxSize);
    }

    void PatternOn(){
        canPattern = true;
    }

}
