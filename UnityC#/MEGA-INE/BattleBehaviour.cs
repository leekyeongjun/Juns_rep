using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BattleBehaviour : MonoBehaviour
{
    [Header("체력")]
    public int HP;
    public int curHP;

    [Space(3f)]
    [Header("주인공 캐릭터")]

    public bool MC = false;
    public bool isDied = false;
    [Space(3f)]
    [Header("보스 캐릭터")]
    public bool BOSS = false;
    public bool isBossDiying = false;
    [Header("DHam보스 캐릭터")]
    public bool Dham = false;
    public bool DhamDying = false;
    public GameObject WhitePanel;

    public bool DHAMMINION = false;
    public bool DhamMinionDied = false;

    [Space(3f)]  
    [Header("캐릭터 공격력, 넉백파워")]
    public int meleeDamage;
    public int meleeknockbackPower;

    [Space(3f)]
    [Header("피격 무적 시간")]
    public float invincibleTime;
    [Space(3f)]
    [Header("피격 및 사망 이펙트")]
    public GameObject HitFX;
    public GameObject DieFX;

    [Space(3f)]
    [Header("전투 상태 - (적, 주인공, 보스 공통)")]
    public bool isHurt = false;
    public bool isInvincible = false;
    public bool isSelfDestruct = false;
    public float Dtime;

    [Header("필수 컴포넌트들")]
    private SpriteRenderer spriteRenderer;
    private Movement2D movement2D;

    // Start is called before the first frame update
    void Awake()
    {
        curHP = HP;
        spriteRenderer = transform.GetComponent<SpriteRenderer>();
        movement2D = transform.GetComponent<Movement2D>();
    }
    private void Start() {
        if(isSelfDestruct){
            Invoke("SelfDestruct", Dtime);
        }
    }
    // Update is called once per frame
    void Update()
    {
        if(curHP <= 0){
            if(MC){ 
                StartCoroutine(Player.player.Die());
            }
            else if(BOSS){
                if(isBossDiying == false) StartCoroutine(BossDie());
            }
            else if(Dham){
                if(DhamDying == false) StartCoroutine(DhamDie());
            }
            else if(DHAMMINION){
                DhamMinionDie();
            }
            else{
                Instantiate(DieFX, transform.position, transform.rotation);
                Destroy(gameObject);
            }
            
            
        }
    }

    public void GetDamaged(int damage, float knockbackPower, Transform dmgpos, bool invincible, bool shake, bool knockback, bool timeStop){
        if(isDied == true) return;
        if(isInvincible == true) return;
        if(isHurt == false){
            
            isHurt = true;
            curHP -= damage;
            //Debug.Log(curHP.ToString());
            float x = (transform.position.x - dmgpos.position.x < 0) ? -1 : 1;
            Instantiate(HitFX, transform.position, transform.rotation);
            
            if(knockback) StartCoroutine(movement2D.Knockback(x, knockbackPower));
            if(shake) StartCoroutine(CameraController.cam.Shake(0.1f, 0.2f));
            if(invincible) StartCoroutine(HurtRoutine());
            if(timeStop) StartCoroutine(GameManager.SlowTime(0.2f , 0.5f));
            StartCoroutine(Alphablink());
        }
    }

    public void GetSpikeDamaged(int damage, float knockbackPower, Transform dmgpos, bool invincible, bool shake, bool knockback, bool timeStop){
        if(isDied == true) return;
        if(isInvincible == true) return;
        if(isHurt == false){
            Debug.Log("SDamaged.");
            isHurt = true;
            curHP -= damage;
            float x = (transform.position.x - dmgpos.position.x < 0) ? -1 : 1;
            float y = (transform.position.y - dmgpos.position.y < 0) ? 1 : -1;
            Instantiate(HitFX, transform.position, transform.rotation);
            
            if(knockback) StartCoroutine(movement2D.XY_Knockback(x, y, knockbackPower));
            if(shake) StartCoroutine(CameraController.cam.Shake(0.1f, 0.2f));
            if(invincible) StartCoroutine(HurtRoutine());
            if(timeStop) StartCoroutine(GameManager.SlowTime(0.2f , 0.5f));
            StartCoroutine(Alphablink());
        }
    }

    public void SelfDestruct(){
        Instantiate(DieFX, transform.position, transform.rotation);
        Destroy(gameObject);
    }

    IEnumerator HurtRoutine(){
        yield return new WaitForSeconds(invincibleTime);
        isHurt = false;
    }

    IEnumerator Alphablink(){
        while(isHurt){
            spriteRenderer.color = Color.red;
            yield return new WaitForSeconds(0.1f);
            spriteRenderer.color = Color.white;
        }
    }

    public void HealUp(int amount){
        if(curHP+amount > HP) curHP = HP;
        else curHP += amount;
    }

    public IEnumerator BossDie(){
        isBossDiying = true;
        CameraController.cam.ShakeOn();
        Player.player.GetComponent<Movement2D>().Stop();
        Player.player.GetComponent<BattleBehaviour>().isInvincible = true;
        Player.player.canControl = false;
        for(int i = 0; i<5; i++){
            float x = transform.position.x + Random.Range(-1f, 1f);
            float y = transform.position.y + Random.Range(-1f, 1f);
            Instantiate(DieFX, new Vector2(x,y), transform.rotation);
            yield return new WaitForSeconds(1f);
        }

        yield return new WaitForSeconds(1f);
        
        CameraController.cam.ShakeOff();
        Player.player.GetComponent<Movement2D>().ReStartMove();
        Player.player.canControl = true;
        
        GameManager.GM.BossDieCutScene();
        yield return null;
    }

    public IEnumerator DhamDie(){
        DhamDying = true;
        CameraController.cam.ShakeOn();
        Player.player.GetComponent<Movement2D>().Stop();
        Player.player.GetComponent<BattleBehaviour>().isInvincible = true;  
        Player.player.canControl = false; 
        WhitePanel.GetComponent<Animator>().SetTrigger("WhiteOn");
        for(int i = 0; i<10; i++){
            float x = transform.position.x + Random.Range(-1f, 1f);
            float y = transform.position.y + Random.Range(-1f, 1f);
            Instantiate(DieFX, new Vector2(x,y), transform.rotation);
            yield return new WaitForSeconds(.5f);
        }
        CameraController.cam.ShakeOff();
        GameManager.GM.ResetPlayer();
        GameManager.GM.LoadtoScene("EndCutScene");

    }
    
    public void DhamMinionDie(){
        DhamMinionDied = true;
        Instantiate(DieFX, transform.position, transform.rotation);
        transform.GetComponent<DhamBossAttack>().Bot_Died_GangSang();
        transform.gameObject.SetActive(false);
        
    }
}
