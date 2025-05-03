using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerAttack : MonoBehaviour
{

    [Header("위치들")]
    public Transform FirePosition;
    public Transform BurgurPosition;
    public Transform SupportBotPosition;
    public GameObject bullet;
    [Space(3f)]
    [Header("징버거 스킬")]
    public GameObject burgur;
    public GameObject burgurFX;
    [Space(3f)]
    [Header("아이네 스킬")]
    public GameObject bigBullet;
    [Space(3f)]
    [Header("비챤 스킬")]
    public GameObject bodySheild;
    public bool bodySheildOn = false;
    public float bodySheildTime = 0f;
    public float SheildSize = 0f;
    public int bodySheildDamage = 0;
    public float bodySheildKnockbackPower = 0f;
    [Space(3f)]
    [Header("릴파 스킬")]
    public GameObject SupportBot;
    public GameObject SupportBotFX;
    public float Lasertime;
    [Space(3f)]
    [Header("세구 스킬")]
    public GameObject SeguBeamOnFX;
    public GameObject SeguBeam;
    private GameObject TmpBullet;
    public float SeguBeamTime;
    public float SeguBeamFirecooltime = 0.1f;
    private float TmpfireCoolTime;
    [Space(3f)]
    [Header("르르 스킬")]
    public bool RuruJumpOn = false;
    public float RuruJumpTime;
    public GameObject RuruBuffOnFX;
    public GameObject RuruTornado;
    [Space(3f)]
    [Header("기본공격 쿨타임, 기본 공격 가능 여부")]
    public float fireCoolTime;
    public bool canShoot = true;
    [Space(3f)]
    [Header("스킬 정보 및 스킬 쿨타임, 스킬 사용 가능 여부")]
    public int SkillId = 0;
    public int SkillCount = 0;
    public int curSkillCount = 0;

    public float Skillcooltime;
    public bool canSkill = true;

    private void Awake() {
        curSkillCount = SkillCount;
        bodySheild.GetComponent<ParticleSystem>().Stop();
    }

    private void Update() {
        if(bodySheildOn){
            Collider2D[] collider2Ds = Physics2D.OverlapCircleAll(transform.position,SheildSize);
            foreach (Collider2D collider in collider2Ds)
            {
                if(collider.tag == "Enemy"){
                collider.GetComponent<BattleBehaviour>().GetDamaged(bodySheildDamage, bodySheildKnockbackPower, transform, true,true,true,true);
                }
            }
        }
    }

    public IEnumerator Shoot(){
        if(canShoot){
            canShoot = false;
            GameObject b = Instantiate(bullet, FirePosition.position, FirePosition.rotation, transform);
            yield return new WaitForSeconds(fireCoolTime);
            canShoot = true;
        }
    }

    public void UseSkill(){
        if(SkillId == 0) StartCoroutine(BigBullet());
        if(SkillId == 1) StartCoroutine(BodySheild());
        if(SkillId == 2) StartCoroutine(LilLaser());
        if(SkillId == 3) StartCoroutine(SummonBurgur());
        if(SkillId == 4) StartCoroutine(SeguBeamSaber());
        if(SkillId == 5) StartCoroutine(RuruJump());
    }

    public IEnumerator BigBullet(){
        if(canSkill){
            if(curSkillCount > 0){
                canSkill = false;
                curSkillCount --;
                GameObject b = Instantiate(bigBullet, FirePosition.position, FirePosition.rotation, transform);
                yield return new WaitForSeconds(Skillcooltime);
                SkillIcons.skillicons.ShowReadyText();
                canSkill = true;
            }
        }
    }

    public IEnumerator BodySheild(){
        if(canSkill){
            if(curSkillCount > 0){
                FXManager.fx.PlaySheildOnSound();
                canSkill = false;
                curSkillCount --;
                transform.GetComponent<BattleBehaviour>().isInvincible = true;
                bodySheild.GetComponent<ParticleSystem>().Play();
                bodySheildOn = true;

                
                yield return new WaitForSeconds(bodySheildTime);
                bodySheildOn = false;
                bodySheild.GetComponent<ParticleSystem>().Stop();
                transform.GetComponent<BattleBehaviour>().isInvincible = false;

                yield return new WaitForSeconds(Skillcooltime);
                SkillIcons.skillicons.ShowReadyText();
                canSkill = true;
            }

        }
    }

    public IEnumerator SummonBurgur(){
        if(canSkill){
            if(curSkillCount > 0){    
                canSkill = false;
                curSkillCount --;
                Instantiate(burgurFX, BurgurPosition.position, BurgurPosition.rotation);
                Instantiate(burgur, BurgurPosition.position, BurgurPosition.rotation);
                yield return new WaitForSeconds(Skillcooltime);
                SkillIcons.skillicons.ShowReadyText();
                canSkill = true;
            }
        }
    }
    public IEnumerator LilLaser(){
        if(canSkill){
            if(curSkillCount > 0){  
                canSkill = false;
                curSkillCount --;
                Instantiate(SupportBotFX, SupportBotPosition.position, SupportBotPosition.rotation);
                GameObject s = Instantiate(SupportBot, SupportBotPosition.position, SupportBotPosition.rotation);
                s.transform.localScale = (Player.player.transform.localScale.x < 0) ? new Vector3(-2,2,2) :new Vector3(2,2,2);
                yield return new WaitForSeconds(0.3f);
                s.GetComponent<SupportBot>().LaserShoot();
                yield return new WaitForSeconds(Lasertime);
                s.GetComponent<SupportBot>().LaserOffTriggerOn();
                yield return new WaitForSeconds(0.5f);
                s.GetComponent<SupportBot>().LaserDestroy();
                Destroy(s);
                yield return new WaitForSeconds(Skillcooltime);
                SkillIcons.skillicons.ShowReadyText();
                canSkill = true;
            }
        }
    }

    public IEnumerator SeguBeamSaber(){
        if(canSkill){
            if(curSkillCount > 0){ 
                canSkill = false;
                curSkillCount --;
                GameObject fx = Instantiate(SeguBeamOnFX, transform.position, SeguBeamOnFX.transform.rotation, transform);
                fx.transform.localScale = new Vector2(0.2f,0.2f);
                TmpBullet = bullet;
                bullet = SeguBeam;
                TmpfireCoolTime = fireCoolTime;
                fireCoolTime = SeguBeamFirecooltime;

                yield return new WaitForSeconds(SeguBeamTime);
                bullet = TmpBullet;
                TmpBullet = null;
                fireCoolTime = TmpfireCoolTime;

                Destroy(fx);
                yield return new WaitForSeconds(Skillcooltime);
                SkillIcons.skillicons.ShowReadyText();
                canSkill = true;
            }
        }
    }

    public IEnumerator RuruJump(){
        if(canSkill){
            if(curSkillCount > 0){ 
                canSkill = false;
                curSkillCount --;
                GameObject fx = Instantiate(RuruBuffOnFX, transform.position, RuruBuffOnFX.transform.rotation, transform);
                RuruJumpOn = true;
                fx.transform.localScale = new Vector2(0.2f, 0.2f);
                if(!Player.player.movement2D.isGrounded) Player.player.movement2D.currentJumpCount ++;
                Player.player.movement2D.maxJumpCount = 3;

                yield return new WaitForSeconds(RuruJumpTime);
                Destroy(fx);
                RuruJumpOn = false;
                Player.player.movement2D.maxJumpCount = 2;

                yield return new WaitForSeconds(Skillcooltime);
                SkillIcons.skillicons.ShowReadyText();
                canSkill = true;
            }
        }
    }

    public void ShootRuruTornado(){
        Instantiate(RuruTornado, transform.position, transform.rotation, transform);
    }

    public void SPup(int amount){
        if(curSkillCount + amount > SkillCount) curSkillCount = SkillCount;
        else curSkillCount += amount;
    }


    private void OnDrawGizmos() {
        Gizmos.DrawWireSphere(transform.position, SheildSize);
    }
}