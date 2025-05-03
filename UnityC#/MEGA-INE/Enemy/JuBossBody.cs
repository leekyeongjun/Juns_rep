using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class JuBossBody : MonoBehaviour
{
    public bool canPattern = false;

    public float patternCoolTime;
    public int patternID;

    
    private Rigidbody2D rigid2D;
    private Animator anim;
    private BattleBehaviour battleBehaviour;
    private IneBossAttack bossattack;
    private Movement2D movement2D;
    private BoxCollider2D col;

    public BattleBehaviour HeartBehaviour;
    [Space(3f)]
    [Header("적의 피격 범위")]
    
    public Vector2 boxSize;
    public Vector2 Offset;

    public Vector2 CurOffset;

    public float dir;

    void Awake()
    {
        anim = GetComponent<Animator>();    
        rigid2D = GetComponent<Rigidbody2D>();
        battleBehaviour = GetComponent<BattleBehaviour>();
        bossattack = GetComponent<IneBossAttack>();
        movement2D = GetComponent<Movement2D>();
        col = GetComponent<BoxCollider2D>();
    }
    
    void FixedUpdate()
    {
        
        if(bossattack.Onpattern == false){
            autotilt();
            dir = (transform.position.x - Player.player.transform.position.x <= 0) ? -1:1;
        }

        Collider2D[] collider2Ds = Physics2D.OverlapBoxAll(new Vector2(transform.position.x + (dir * Offset.x ), transform.position.y + Offset.y), boxSize ,0);
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
            StartCoroutine(bossattack.JuBossMove(3));
        }
        if(patternID == 2){
            StartCoroutine(bossattack.JuBossShrinkPunch());
        }
        if(patternID == 3){
            StartCoroutine(bossattack.JuBossCast(0, 10));
        }
        if(patternID == 4){
            StartCoroutine(bossattack.JuBossFireCast());
            StartCoroutine(bossattack.JuBossMove(3));
        }
    }

    void PatternOn(){
        canPattern = true;
    }

    private void OnDrawGizmos() {
        Gizmos.color = Color.blue;
        Gizmos.DrawWireCube(new Vector2(transform.position.x + (dir*Offset.x) , transform.position.y + Offset.y), boxSize);
    }

    private void autotilt(){
        float d = transform.position.x - Player.player.transform.position.x;
        if(d > 0) 
        {
            transform.localScale = new Vector2(2,2);
        }
        else{ 
            transform.localScale = new Vector2(-2,2);
        }
    }

    private void autoHitpointSet(){

    }
}
