using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Player : MonoBehaviour
{

    
    public static Player player;
    public Sprite PlayerPort;
    [HideInInspector]

    public bool Flipped = false;
    public bool canControl = true;
    public bool IsFlying = false;
    public bool IsSneaking = false;
    public bool DoFlipCheck = true;
    public GameObject Wing;

    public Color SneakColor;
    public Color IdleColor;

    public float DieTime = 3f;
    public bool Died = false;

    [HideInInspector]
    public Movement2D movement2D;
    private SpriteRenderer spriteRenderer;
    public PlayerAttack playerAttack;
    private Vector3 originalLocalScale;
    public BattleBehaviour battleBehavior;


    private void Awake() {
        
        if(player != null){
            Destroy(gameObject);
            return;
        }
        player = this;
        DontDestroyOnLoad(gameObject);
        originalLocalScale = transform.localScale;
        movement2D = GetComponent<Movement2D>();
        spriteRenderer = GetComponent<SpriteRenderer>();
        playerAttack = GetComponent<PlayerAttack>();
        battleBehavior = GetComponent<BattleBehaviour>();
    }
    private void Start() {
        if(GameManager.GM.HardMode){
            StartCoroutine(RegenerateSP());
        }
    }
    void Update()
    {
        
        if(!canControl) return;
        if(movement2D.isDashing) return;
        movement2D.Ladder();
        if(!IsFlying){
            Wing.SetActive(false);
            movement2D.Gravitate();
            float x = Input.GetAxisRaw("Horizontal");
            FlipCheck(x);
            if(Input.GetKeyDown(KeyCode.Space)){ movement2D.Jump();}
            movement2D.Move(x);
            if(Input.GetKeyDown(KeyCode.LeftShift)) StartCoroutine(movement2D.Dash(x));
        }
        if(IsFlying){
            Wing.SetActive(true);
            movement2D.Nongravitate();
            float x = Input.GetAxisRaw("Horizontal");
            float y = Input.GetAxisRaw("Vertical");
            FlipCheck(x);
            movement2D.FlyMove(x,y);
        }
        
        if(!(movement2D.anim.GetBool("IsLaddering")) ){
            if(!IsSneaking){
                if(Input.GetKey(KeyCode.Z)) StartCoroutine(playerAttack.Shoot());
                if(Input.GetKeyDown(KeyCode.X)) playerAttack.UseSkill();
            }
        }

        
    }

    private void FixedUpdate() {
        if(IsSneaking) spriteRenderer.color = SneakColor;
    }

    void FlipCheck(float x){
        if(!DoFlipCheck) return;
        if(x<0){
            transform.localScale = new Vector3(-1*originalLocalScale.x, originalLocalScale.y, originalLocalScale.z);
            Flipped = true;
        }
        else if(x>0){
            transform.localScale = new Vector3(originalLocalScale.x, originalLocalScale.y, originalLocalScale.z);
            Flipped = false;
        }
    }


    public IEnumerator Die(){
        if(Died == false){
            canControl = false;
            Died = true;
            battleBehavior.isDied = true;
            Instantiate(battleBehavior.DieFX, transform.position, transform.rotation);
            transform.position = new Vector3(transform.position.x, transform.position.y, -4000f);
            GameManager.GM.TryUP();
            yield return new WaitForSeconds(DieTime);
            Respawn();
            

            yield return null;
        }
    }

    public void Respawn(){
        if(GameManager.GM.CurrentBoss != null){
            GameManager.GM.ResetBoss();
            GameManager.GM.CurrentBossTrigger.ResetTrigger();
        }
        transform.position = GameManager.GM.startpoint.CheckPointPosition().position;
        spriteRenderer.color = new Color(255,255,255,255);
        battleBehavior.HP = GameManager.GM.MainCharacter_HP;
        battleBehavior.curHP = GameManager.GM.MainCharacter_HP;
        playerAttack.curSkillCount = playerAttack.SkillCount;
        battleBehavior.isDied = false;
        canControl = true;
        Died = false;
    }

    public IEnumerator RegenerateSP(){
        while(true){
            yield return new WaitForSeconds(10f);
            playerAttack.SPup(1);
        }
    }
}
