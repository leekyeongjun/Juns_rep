using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyAttack : MonoBehaviour
{
    public Transform FirePosition;

    public GameObject bullet;
    public GameObject Vbullet;
    public GameObject PlayerPositionCircularMagic;
    public GameObject CurrentPositionCircularMagic;

    public float Range;
    public float fireCoolTime;
    private bool canShoot = true;

    public GameObject BulletShootingFX;

    private bool canRush = true;
    public float RushCoolTime;
    public Vector3 target;

    private bool canShell = true;
    public float Shelltime;
    public float ShellCooltime;

    public bool IsInSight = false;
    
    public int KamikazeDamage;
    public int KamikazeKnockbackDamage;

    public GameObject CircularWarningEffect;


    private float _offset;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public IEnumerator Shoot(){
        if(Player.player != null){
            float Dist = Vector3.Distance(transform.position, Player.player.transform.position);
            if(canShoot){
                if(Dist <= Range){
                    canShoot = false;
                    target = Player.player.transform.position - transform.position;
                    transform.GetComponent<Animator>().SetTrigger("IsShoot");
                    GameObject b = Instantiate(bullet, FirePosition.position, FirePosition.rotation,transform);
                    yield return new WaitForSeconds(fireCoolTime);
                    
                    canShoot = true;

                }else yield return null;
            }else yield return null;
        }else yield return null;
    }

    public IEnumerator ShootBulletRadial(int count){
        if(Player.player != null){
            float Dist = Vector3.Distance(transform.position, Player.player.transform.position);
            if(canShoot){
                if(Dist <= Range){
                    canShoot = false;
                    float weightangle = Random.Range(0,15);
                    float intervalangle = 360/count;

                    transform.GetComponent<Animator>().SetTrigger("IsShoot");
                    Instantiate(BulletShootingFX, FirePosition.position, FirePosition.rotation);
                    for(int i = 0; i<count; i++){
                        float angle = weightangle + intervalangle * i;
                        float x = Mathf.Cos(angle * Mathf.PI/180f);
                        float y = Mathf.Sin(angle * Mathf.PI/180f);

                        GameObject b = Instantiate(Vbullet, FirePosition.position, FirePosition.rotation);
                        b.GetComponent<Bullet>().GetVector2(new Vector2(x,y));
                    }
                    yield return new WaitForSeconds(fireCoolTime);
                    canShoot = true;
                }
            }
        }
    }
    public IEnumerator ShootBulletRadial180(int count, float offset){
        if(Player.player != null){
            float Dist = Vector3.Distance(transform.position, Player.player.transform.position);
            if(canShoot){
                if(Dist <= Range){
                    canShoot = false;
                    float weightangle = Random.Range(0,15);
                    float intervalangle = 180/count;
                    transform.GetComponent<Animator>().SetTrigger("IsShoot");
                    Instantiate(BulletShootingFX, FirePosition.position, FirePosition.rotation);
                    for(int i=0; i<count; i++){
                        GameObject b = Instantiate(Vbullet, FirePosition.position, FirePosition.rotation);
                        float angle = offset + weightangle + intervalangle * i;
                        float x = Mathf.Cos(angle * Mathf.PI/180f);
                        float y = Mathf.Sin(angle * Mathf.PI/180f);
                        b.GetComponent<Bullet>().GetVector2(new Vector2(x,y));
                    }
                
                    yield return new WaitForSeconds(fireCoolTime);
                    canShoot = true;
                }
            }  
        }
    }
    
    public IEnumerator ShootInPatrol(){
        if(Player.player != null){
            float Dist = Vector3.Distance(transform.position, Player.player.transform.position);
            if(canShoot){
                if(Dist <= Range){
                    if(IsInSight){
                        canShoot = false;
                        target = Player.player.transform.position - transform.position;
                        transform.GetComponent<Animator>().SetTrigger("IsShoot");
                        GameObject b = Instantiate(bullet, FirePosition.position, FirePosition.rotation, transform);
                        yield return new WaitForSeconds(fireCoolTime);
                        canShoot = true;
                    }
                }else yield return null;
            }else yield return null;
        }else yield return null;
    }

    public IEnumerator Rush(){
        if(Player.player != null){
            float Dist = Vector3.Distance(transform.position, Player.player.transform.position);
            if(canRush){
                if(Dist <= Range){
                    canRush = false;
                    float t = ((transform.position - Player.player.transform.position).x > 0) ? -1 : 1;
                    transform.GetComponent<Enemy>().OnRush = true;
                    transform.GetComponent<Enemy>().nextMove = t;
                    float temp = transform.GetComponent<Movement2D>().speed;
                    transform.GetComponent<Movement2D>().speed += 1.2f;
                    yield return new WaitForSeconds(RushCoolTime);
                    transform.GetComponent<Movement2D>().speed = temp;
                    canRush = true;
                }else yield return null;
            }else yield return null;
        }else yield return null;
    }

    public IEnumerator ChaseInPatrol(){
        if(Player.player != null){
            float Dist = Vector3.Distance(transform.position, Player.player.transform.position);
            if(Dist <= Range){
                if(IsInSight) transform.GetComponent<Enemy>().OnChaseMod = true;
                else {
                    transform.GetComponent<Enemy>().OnChaseMod = false;
                    transform.GetComponent<Movement2D>().OnChase = false;
                }
            }
                
        }else yield return null;
    }
    public IEnumerator HoldInPatrol(){
        if(Player.player != null){
            float Dist = Vector3.Distance(transform.position, Player.player.transform.position);
            if(Dist <= Range){
                if(transform.position.x - Player.player.transform.position.x > 0 )transform.GetComponent<Enemy>().OnHoldMod = true;
                else{
                    transform.GetComponent<Enemy>().OnHoldMod = false;
                    transform.GetComponent<Movement2D>().OnHold = false;
                }  
            }
            else{
                transform.GetComponent<Enemy>().OnHoldMod = false;
                transform.GetComponent<Movement2D>().OnHold = false;
            }
                
        }else yield return null;
    }


    public IEnumerator Kamikaze(Collider2D collider){
        collider.GetComponent<BattleBehaviour>().GetDamaged(KamikazeDamage, KamikazeKnockbackDamage, transform, true,true,true,true);
        transform.GetComponent<BattleBehaviour>().SelfDestruct();
        yield return null;
    }

    public IEnumerator ShootPlayerPositionCircularMagic(){
        if(Player.player != null){
            if(canShoot){
                float Dist = Vector3.Distance(transform.position, Player.player.transform.position);
                if(Dist <= Range){
                    canShoot = false;
                    transform.GetComponent<Enemy>().nextMove = 0;
                    Transform Target = Player.player.transform;
                    GameObject W = Instantiate(CircularWarningEffect, Target.position, CircularWarningEffect.transform.rotation, transform);
                    float rad = PlayerPositionCircularMagic.GetComponent<Bullet>().radius;
                    W.transform.localScale =new Vector2(rad*1.5f, rad*1.5f);
                    yield return new WaitForSeconds(1f);
                    transform.GetComponent<Animator>().SetTrigger("IsShoot");
                    Instantiate(PlayerPositionCircularMagic, W.transform.position, PlayerPositionCircularMagic.transform.rotation);
                    Destroy(W);
                    yield return new WaitForSeconds(fireCoolTime);
                    canShoot = true;
                }
            }
        }
        yield return null;
    }

    public IEnumerator ShootCurrentPositionCircularMagic(){
        if(Player.player != null){
            if(canShoot){
                canShoot = false;
                transform.GetComponent<Enemy>().nextMove = 0;
                GameObject W = Instantiate(CircularWarningEffect, transform.position, CircularWarningEffect.transform.rotation, transform);
                float rad = CurrentPositionCircularMagic.GetComponent<Bullet>().radius;
                W.transform.localScale =new Vector2(rad*1.5f, rad*1.5f);
                yield return new WaitForSeconds(1f);
                transform.GetComponent<Animator>().SetTrigger("IsShoot");
                Instantiate(CurrentPositionCircularMagic, transform.position, CurrentPositionCircularMagic.transform.rotation);
                Destroy(W);
                yield return new WaitForSeconds(fireCoolTime);
                canShoot = true;
            }
        }
        yield return null;
    }
    public IEnumerator ShellOn(){
        if(canShell){
            canShell = false;
            transform.GetComponent<BattleBehaviour>().isInvincible = true;
            transform.GetComponent<Animator>().SetBool("OnShell", true);
            yield return new WaitForSeconds(Shelltime);
            transform.GetComponent<BattleBehaviour>().isInvincible = false;
            transform.GetComponent<Animator>().SetBool("OnShell", false);
            yield return new WaitForSeconds(ShellCooltime);
            canShell = true;
        }
    }


    public IEnumerator SeguRedShooterShoot(int times, int count, int type){
        float weightangle = Random.Range(0,15);
        float intervalangle = 180/count;
        
        if(type == 0) _offset = -135 ;
        else if(type == 1) _offset = -45;
        else if(type == 2) _offset = 135;
        else if(type == 3) _offset = 45;
        //transform.GetComponent<Animator>().SetTrigger("IsShoot");
        
        for(int j=0; j<times; j++){
            if(BulletShootingFX != null) Instantiate(BulletShootingFX, FirePosition.position, FirePosition.rotation);
            for(int i=0; i<count; i++){
                
                GameObject b = Instantiate(Vbullet, FirePosition.position, FirePosition.rotation);
                float angle = _offset + weightangle + intervalangle * i;
                float x = Mathf.Cos(angle * Mathf.PI/180f);
                float y = Mathf.Sin(angle * Mathf.PI/180f);
                b.GetComponent<Bullet>().GetVector2(new Vector2(x,y));
            }
            yield return new WaitForSeconds(.5f);
        }
        yield return null;
    }


    public IEnumerator SeguBlueShooterShoot(int times){
        //transform.GetComponent<Animator>().SetTrigger("IsShoot");
        for(int i=0; i<times; i++){
            target = Player.player.transform.position - transform.position;
            if(BulletShootingFX != null) Instantiate(BulletShootingFX, FirePosition.position, FirePosition.rotation);
            GameObject b = Instantiate(bullet, FirePosition.position, FirePosition.rotation,transform);

            yield return new WaitForSeconds(.5f);
        }
        yield return null;

    }

    private void OnDrawGizmos() {
        Gizmos.color = Color.red;
        Gizmos.DrawWireSphere(transform.position,Range);
    }
}
