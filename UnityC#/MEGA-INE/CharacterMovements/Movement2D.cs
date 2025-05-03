using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Movement2D : MonoBehaviour
{
    
    [Header("필수 컴포넌트들")]
    private Rigidbody2D rigid2D;
    public Animator anim;
    
    [Space(3f)]
    [Header("이동 옵션 켜고 끄기")]
    public bool canMove = true;
    public bool canKnockback = true;

    [Space(3f)]
    [Header("점프")]
    public GameObject JumpFX;
    public float jumpforce = 8f;
    public int maxJumpCount = 2;
    public int currentJumpCount = 0;

    [Space(3f)]
    [Header("착지 확인 컴포넌트")]
    public LayerMask groundLayer;
    private BoxCollider2D boxCollider2D;
    public bool isGrounded;
    private Vector3 footPosition;
    public Vector2 footSize;

    public float raycastoffset_x;
    public float raycastoffset_y;

    [Space(3f)]
    [Header("이동 속도")]
    public float speed = 5f;
    
    [Space(3f)]
    [Header("대시")]
    public GameObject DashFX;
    public float dashforce = 8f;
    
    [Space(3f)]
    [Header("대시 설정")]
    public bool canDash = true;
    public bool isDashing = false;
    public float dashingTime = 0.5f;
    public float dashingCoolTime = 0.5f;
    
    [Space(3f)]
    [Header("사다리 타기")]
    public float Ladderspeed = 3f;
    public bool inLadder = false;
    
    [Space(3f)]
    [Header("왕복 정찰 (Enemy Only!)")]
    public float curMovingtime;
    public Transform PatrolDestination;
    public Vector3 destPos;
    private Vector3 initiatedPos;
    public float movingCooltime;

    [Space(3f)]
    [Header("임펄스 점프 (Enemy Only!)")]
    public bool CanImpulseJump = true;
    public float ImpulseJumptime;
    public float ImpulseJumpPower;
    public float ImpulseJumpCool;

    public Bounds bounds;
    [Space(3f)]
    [Header("추격 (Enemy Only!)")]

    public bool OnChase = false;
    public bool OnHold = false;

    private void Awake() {
        rigid2D = GetComponent<Rigidbody2D>();
        boxCollider2D = GetComponent<BoxCollider2D>();
        anim = GetComponent<Animator>();
    }

    private void FixedUpdate() {

        bounds = boxCollider2D.bounds;
        footPosition = new Vector2(bounds.center.x, bounds.min.y);
        isGrounded = Physics2D.OverlapBox(footPosition, footSize, 0, groundLayer);

        anim.SetBool("IsJumping", !isGrounded);
        anim.SetBool("IsDashing", isDashing);
        

        if(isGrounded == true && rigid2D.velocity.y <= 0){
            currentJumpCount = maxJumpCount;
        }
        if(transform.GetComponent<Player>() != null){
            if(isDashing) rigid2D.gravityScale = 0f;
            if(anim.GetBool("IsLaddering")) rigid2D.gravityScale = 0f;
        }

    }

    public void Move(float x){
        if(!canMove) {return;}
        if(x != 0) anim.SetBool("IsWalking", true);
        else anim.SetBool("IsWalking", false);
        rigid2D.velocity = new Vector2(x*speed, rigid2D.velocity.y);
    }

    public void FlyMove(float x, float y){
        if(!canMove) {return;}
        if(x != 0) anim.SetBool("IsWalking", true);
        else anim.SetBool("IsWalking", false);
        rigid2D.velocity = new Vector2(x*(speed+2f), y*(speed+2f));
    }

    public void Jump(){
        if(!canMove) {return;}
        if(currentJumpCount > 0){
            Instantiate(JumpFX, new Vector3(transform.position.x, transform.position.y-0.5f, transform.position.z), Quaternion.Euler(-80,0,0));
            rigid2D.velocity = Vector2.up*jumpforce;
            currentJumpCount --;
            if(Player.player.playerAttack.RuruJumpOn){
                Player.player.playerAttack.ShootRuruTornado();
            }
        }
    }

    public IEnumerator ImpulseJump(Vector3 vec){
        if(CanImpulseJump){
            rigid2D.AddForce(vec * ImpulseJumpPower, ForceMode2D.Impulse);
            Debug.Log("Jump!");
            CanImpulseJump = false;
            yield return new WaitForSeconds(ImpulseJumptime);
            rigid2D.velocity = new Vector2(0,rigid2D.velocity.y);
            Debug.Log("Stop!");
            yield return new WaitForSeconds(ImpulseJumpCool);
            CanImpulseJump = true;
        }

    }

    public IEnumerator Dash(float x){
        if(!canMove) {yield return null;}
        if(canDash){
            isDashing = true;
            canDash = false;
            anim.SetBool("IsLaddering", false);

            float originalgravity = 1f;
            
            if(x != 0) {
                rigid2D.velocity = new Vector2(x * dashforce, 0f);
                Instantiate(DashFX, transform.position, Quaternion.Euler(-180,x*90,0));
            }
            
            else{
                float _x = (transform.localScale.x > 0) ? 1 : -1;
                rigid2D.velocity = new Vector2(_x * dashforce, 0f);
                Instantiate(DashFX,transform.position, Quaternion.Euler(-180,_x*90,0));
            }

            if(isGrounded) anim.SetTrigger("IsSliding");
            transform.GetComponent<BattleBehaviour>().isInvincible = true;
            yield return new WaitForSeconds(dashingTime);
            if(!Player.player.playerAttack.bodySheildOn){
                transform.GetComponent<BattleBehaviour>().isInvincible = false;
            }
            isDashing = false;
            rigid2D.velocity = new Vector2(0,0);
            rigid2D.gravityScale = originalgravity;

            yield return new WaitForSeconds(dashingCoolTime);
            canDash = true;
        }
    }

    public void Ladder(){
        if(Player.player.IsFlying) return;
        if(inLadder){
            float y = Input.GetAxis("Vertical");
            
            if(y != 0){
                rigid2D.velocity = new Vector2(rigid2D.velocity.x, y*Ladderspeed);
                anim.SetBool("IsLaddering", true);
            }

        }
        else{
            anim.SetBool("IsLaddering", false);
        }
    }

    public void Patrol(bool rotating){
        if(!canMove || OnChase || OnHold) return;
        if(destPos == null && initiatedPos == null) return;
        if(curMovingtime <= 0){
            transform.position = Vector3.MoveTowards(transform.position, destPos, Time.deltaTime*speed);
            if(transform.position == destPos){
                curMovingtime = movingCooltime;
                Vector3 tmp = transform.position;
                destPos = initiatedPos;
                initiatedPos = tmp;
            }
        }
        else{
            curMovingtime -= Time.deltaTime;
        }
        if(rotating) transform.GetComponent<Enemy>().nextMove = (transform.position.x - destPos.x >= 0) ? -1 : 1;
    }

    public void Chase(){
        if(!canMove) return;
        OnChase = true;
        Vector3 t = Player.player.transform.position;
        transform.position = Vector3.MoveTowards(transform.position , t , Time.deltaTime*speed);
        transform.GetComponent<Enemy>().nextMove = (transform.position.x - t.x>= 0) ? -1 : 1;
    }

    public void Hold(){
        if(!canMove) return;
        OnHold = true;
    }


    public IEnumerator Knockback(float dir, float knockbackPower){
        if(canKnockback){
            canMove = false;
            float ctime = 0f;
            rigid2D.velocity = new Vector2(0f, rigid2D.velocity.y);
            while(ctime < 0.2f){
                rigid2D.velocity = new Vector2(dir*knockbackPower, rigid2D.velocity.y);
                ctime+= Time.deltaTime;
                yield return null;
            }   
            rigid2D.velocity = new Vector2(0f, rigid2D.velocity.y);  
            canMove = true;
        }
    }

    public IEnumerator Y_Knockback(float dir, float knockbackPower){
        canMove = false;
        float ctime = 0f;
        rigid2D.velocity = new Vector2(rigid2D.velocity.x, 0f);  
        while(ctime < 0.2f){
            rigid2D.velocity = new Vector2(rigid2D.velocity.x, dir*knockbackPower);
            ctime+= Time.deltaTime;
            yield return null;
        }   
        rigid2D.velocity = new Vector2(rigid2D.velocity.x, 0f);  
        canMove = true;
    }
    
    public IEnumerator XY_Knockback(float dir_X, float dir_Y, float knockbackPower){
        canMove = false;
        float ctime = 0f;
        rigid2D.velocity = new Vector2(0f, 0f);  
        while(ctime < 0.2f){
            rigid2D.velocity = new Vector2(dir_X*knockbackPower, dir_Y*knockbackPower);
            ctime+= Time.deltaTime;
            yield return null;
        }   
        rigid2D.velocity = new Vector2(0f, 0f);  
        canMove = true;
    }

    public float PlatformCheck(float nextMove){
        Vector2 frontVec = new Vector2(rigid2D.position.x+(nextMove*raycastoffset_x), rigid2D.position.y - raycastoffset_y);
        Debug.DrawRay(frontVec, Vector3.down, new Color(0,1,0));
        RaycastHit2D rayHit = Physics2D.Raycast(frontVec, Vector3.down, 1, LayerMask.GetMask("Ground"));
        if(rayHit.collider == null){
            nextMove *= -1;
        }
        return nextMove;
    }


    public void MoveEightway(float x, float y){
        if(!canMove) return;
        if(rigid2D.gravityScale != 0) rigid2D.gravityScale = 0;
        rigid2D.velocity = new Vector2(x*speed, y*speed);
    }

    public void Stop(){
        canMove = false;
        rigid2D.velocity= new Vector2(0,0); 
    }

    public void ReStartMove(){
        canMove = true;
    }
    public void Nongravitate(){
        rigid2D.gravityScale = 0f;
    }
    public void Gravitate(){
        rigid2D.gravityScale = 1f;
    }

    public void SetPatrol(){
        destPos = PatrolDestination.position;
        initiatedPos = transform.position;
    }
    private void OnDrawGizmos() {
        Gizmos.color = Color.yellow;
        Vector2 center = bounds.center;
        Gizmos.DrawWireCube(new Vector2(bounds.center.x, bounds.min.y), footSize);
       
    }
}
