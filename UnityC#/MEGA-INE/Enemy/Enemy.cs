using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Enemy : MonoBehaviour
{
    [Header("적의 움직임 켜고 끄기")]
    public bool Movable = true;

    [Space(3f)]
    [Header("적의 이동타입")]
    public bool Fly = false;
    public bool Patroller = false;
    public bool ImpulseJumper = false;
    public bool RotatingWhilePatrolling = true;
    
    public bool NoThinker = false;
    public bool NoFlipChecker = false;
    

    [Space(3f)]
    [Header("적의 공격타입")]
    public bool Minion = false;
    public bool DShooter = false;
    [Space(3f)]
    public bool VShooter = false;
    public bool V_180Shooter = false;
    public int bulletnums;
    public float VectorOffset = 90f;
    [Space(3f)]
    public bool PShooter = false;
    public bool Chaser = false;
    public bool Kamikaze = false;
    public bool Holder = false;
    public bool PlayerPositionCircularMagicCaster = false;
    public bool CurrentPositionCircularMagicCaster = false;
    public bool Sheller = false;

    public bool Rusher = false;

    [Header("적의 움직임변수")]
    public bool OnRush = false;
    public bool OnChaseMod = false;
    public bool OnHoldMod = false;
    public float nextMove;
    public float nextMove_x;
    public float nextMove_y;
    [Space(3f)]
    [Header("적의 이동 간격")]
    public float moveCooltime;
    [Space(3f)]
    [Header("적의 피격 범위")]
    public Vector2 boxSize;
    
    [Space(3f)]
    [Header("필수 컴포넌트들")]
    private Movement2D movement2D;
    private BattleBehaviour battleBehaviour;
    private EnemyAttack enemyAttack;
    private Vector3 originalLocalScale;

    // Start is called before the first frame update
    void Awake()
    {
        movement2D = GetComponent<Movement2D>();
        battleBehaviour = GetComponent<BattleBehaviour>();
        enemyAttack = GetComponent<EnemyAttack>();
        originalLocalScale = transform.localScale;
    }

    private void Start() {
        if(Minion){
            transform.parent = null;
            return;
        }
        if(Patroller) {
            movement2D.SetPatrol();
            return;    
        }
        if(NoThinker) return;
        Invoke("Think", moveCooltime);
    }
    
    private void Update() {
        if(Movable){
            if(Patroller) {
                if(OnChaseMod){
                    movement2D.Chase();
                }
                if(OnHoldMod){
                    movement2D.Hold();
                }
                else{
                    movement2D.Patrol(RotatingWhilePatrolling);
                }
            }
            if(ImpulseJumper){
                Vector3 vec = new Vector3(nextMove, transform.localScale.y, transform.localScale.z);
                StartCoroutine(movement2D.ImpulseJump(vec));
            }
            else MOB_MOVE(); 
            if(!NoFlipChecker) FlipCheck();
        }

        if(DShooter) StartCoroutine(enemyAttack.Shoot());
        if(VShooter) StartCoroutine(enemyAttack.ShootBulletRadial(bulletnums));
        if(PShooter) StartCoroutine(enemyAttack.ShootInPatrol());
        if(Rusher) StartCoroutine(enemyAttack.Rush());
        if(Chaser) StartCoroutine(enemyAttack.ChaseInPatrol());
        if(Holder) StartCoroutine(enemyAttack.HoldInPatrol());
        if(V_180Shooter) StartCoroutine(enemyAttack.ShootBulletRadial180(bulletnums, VectorOffset));
        if(PlayerPositionCircularMagicCaster) StartCoroutine(enemyAttack.ShootPlayerPositionCircularMagic());
        if(CurrentPositionCircularMagicCaster) StartCoroutine(enemyAttack.ShootCurrentPositionCircularMagic());
        if(Sheller) StartCoroutine(enemyAttack.ShellOn());
    }

    void FixedUpdate()
    {
        Collider2D[] collider2Ds = Physics2D.OverlapBoxAll(transform.position,boxSize,0);
        foreach (Collider2D collider in collider2Ds)
        {
            if(collider.tag == "Player"){
                if(Kamikaze){
                    StartCoroutine(enemyAttack.Kamikaze(collider));
                }
                collider.GetComponent<BattleBehaviour>().GetDamaged(battleBehaviour.meleeDamage, battleBehaviour.meleeknockbackPower, transform, true,true,true,true);
            }
        }
        if(Fly){return;}
        if(OnRush){return;}
        if(ImpulseJumper) {return;}
        else{ nextMove = movement2D.PlatformCheck(nextMove); }


    }

    void Think()
    {
        if(!Fly){
            nextMove = Random.Range(-1, 2);
            Invoke("Think", moveCooltime);
        }
        else{
            nextMove_x = Random.Range(-1, 2);
            nextMove_y = Random.Range(-1, 2);
            Invoke("Think", moveCooltime);
        }

    }

    void MOB_MOVE(){
        if(Fly) movement2D.MoveEightway(nextMove_x, nextMove_y);
        else movement2D.Move(nextMove);
    }

    private void OnDrawGizmos() {
        Gizmos.color = Color.blue;
        Gizmos.DrawWireCube(transform.position, boxSize);
    }

    void FlipCheck(){
        if(nextMove > 0 || nextMove_x > 0){
            transform.localScale = new Vector3(-1*originalLocalScale.x, originalLocalScale.y, originalLocalScale.z);
        }
        else if(nextMove < 0 || nextMove_x < 0){
            transform.localScale = new Vector3(originalLocalScale.x, originalLocalScale.y, originalLocalScale.z);
        }
    }

    void SetPatrol(){
        movement2D.SetPatrol();
    }

}
