using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SeguBossBody : MonoBehaviour
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
    [Space(3f)]
    [Header("적의 피격 범위")]
    
    public GameObject CBelt;

    public Vector2 boxSize;
    public Vector2 Offset;

    
    void Awake()
    {
        anim = GetComponent<Animator>();    
        rigid2D = GetComponent<Rigidbody2D>();
        battleBehaviour = GetComponent<BattleBehaviour>();
        bossattack = GetComponent<IneBossAttack>();
        movement2D = GetComponent<Movement2D>();
    }
    
    void FixedUpdate()
    {
        Collider2D[] collider2Ds = Physics2D.OverlapBoxAll(new Vector2(transform.position.x + Offset.x , transform.position.y + Offset.y), boxSize ,0);
        foreach (Collider2D collider in collider2Ds)
        {
            if(collider.tag == "Player"){
                collider.GetComponent<BattleBehaviour>().GetDamaged(battleBehaviour.meleeDamage, battleBehaviour.meleeknockbackPower, transform, true,true,true,true);
            }
        }
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
            CBelt.GetComponent<ConveyorBelt>().TargetDriveSpeed = 0f;
            StopAllCoroutines();
        }
        
    }
    public IEnumerator UsePattern(){
        if(canPattern){
            canPattern = false;
            int patternID = Random.Range(1,23);
            Pattern(patternID);
            float cool = patternCoolTime;
            yield return new WaitForSeconds(cool);
            canPattern = true;
        }
    }

    public void Pattern(int patternID){

        if(patternID == 1){
            StartCoroutine(bossattack.SpawnChainSaw(2));
        }
        if(patternID == 2){
            StartCoroutine(bossattack.SpawnChainSaw(1));
        }
        if(patternID == 3){
            StartCoroutine(bossattack.SpawnChainSaw(0));
        }
        if(patternID == 4){
            StartCoroutine(bossattack.SpawnShooter(0,0,0));
        }
        if(patternID == 5){
            StartCoroutine(bossattack.SpawnShooter(0,0,1));
        }
        if(patternID == 6){
            StartCoroutine(bossattack.SpawnShooter(0,1,0));
        }
        if(patternID == 7){
            StartCoroutine(bossattack.SpawnShooter(0,1,1));
        }
        if(patternID == 8){
            StartCoroutine(bossattack.SpawnShooter(1,0,0));
        }
        if(patternID == 9){
            StartCoroutine(bossattack.SpawnShooter(1,0,1));
        }
        if(patternID == 10){
            StartCoroutine(bossattack.SpawnShooter(1,1,0));
        }
        if(patternID == 11){
            StartCoroutine(bossattack.SpawnShooter(1,1,1));
        }
        if(patternID == 12){
            StartCoroutine(bossattack.SpawnChainSaw(3));
        }
        if(patternID == 13){
            StartCoroutine(bossattack.SpawnChainSaw(4));
        }
        if(patternID == 14){
            StartCoroutine(bossattack.SpawnChainSaw(5));
        }
        if(patternID == 15){
            StartCoroutine(bossattack.SeguLaserShoot());
        }
        if(patternID == 16){
            StartCoroutine(bossattack.SeguLaserShoot());
        }
        if(patternID == 17){
            StartCoroutine(bossattack.SeguLaserShoot());
        }
        if(patternID == 18){
            StartCoroutine(bossattack.SpawnChainSaw(0));

        }
        if(patternID == 19){

            StartCoroutine(bossattack.SpawnChainSaw(5));
        }
        if(patternID == 20){
            StartCoroutine(bossattack.SpawnChainSaw(1));

        }
        if(patternID == 21){

            StartCoroutine(bossattack.SpawnChainSaw(4));
        }
        if(patternID == 22){

            StartCoroutine(bossattack.SpawnChainSaw(3));
        }

    }

    void PatternOn(){
        canPattern = true;
    }

    private void OnDrawGizmos() {
        Gizmos.color = Color.blue;
        Gizmos.DrawWireCube(new Vector2(transform.position.x + Offset.x , transform.position.y + Offset.y), boxSize);
    }
}
