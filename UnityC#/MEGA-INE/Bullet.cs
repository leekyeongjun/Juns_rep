using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Bullet : MonoBehaviour
{

    public bool StrightType = true;
    public bool GuidedType = false;
    public bool VectorType = false;
    public bool ImpulseType = false;
    public Rigidbody2D rigid2D;

    public bool IgnoreFloor = false;
    public bool IgnoreEverything = false;

    public bool Explosive = false;
    public GameObject CircularWarningEffect;
    public GameObject Explosion;

    public bool Separative = false;
    public GameObject SeparationBullet;
    public int SeparateCount;
    public float SeparateOffset;

    public bool BulletActive = true;
    public Color BulletInactiveColor;

    public GameObject[] SubComponents;
 
    public bool Enemy = false;
    private string target;
    public float dir = -1;
    public float speed;
    public int damage;
    public float knockbackPower;
    public float DestroyTime = 3f;

    public GameObject FireFX;
    public GameObject DestroyFX;
    public GameObject ExplosiveBulletDestroyFX;

    private Vector3 destination;
    

    [SerializeField]
    public float radius;

    private void Awake() {
        target = (Enemy) ? "Player" : "Enemy";
        if(!Enemy){
            if(StrightType) dir = (transform.GetComponentInParent<Player>().Flipped) ? -1 : 1;
        } 
        if(Enemy){
            if(StrightType){
                if(transform.parent != null) dir = (transform.parent.localScale.x < 0) ? 1 : -1;
            }
        } 
        
        if(GuidedType){
            if(Enemy){
                if(transform.GetComponentInParent<EnemyAttack>()) destination = transform.GetComponentInParent<EnemyAttack>().target;
                else if(transform.GetComponentInParent<IneBossAttack>())destination = transform.GetComponentInParent<IneBossAttack>().target;
                else if(transform.GetComponentInParent<DhamBossAttack>())destination = transform.GetComponentInParent<DhamBossAttack>().target;
            } 
        }
    }

    void Start()
    {
        if(FireFX != null) Instantiate(FireFX, transform.position,FireFX.transform.rotation);
        transform.parent = null;
        Invoke("Destroythis",DestroyTime);
    }

    // Update is called once per frame
    void Update()
    {
        
        if(BulletActive){
            if(!IgnoreEverything){
                Collider2D[] collider2Ds = Physics2D.OverlapCircleAll(transform.position,radius);
                foreach (Collider2D collider in collider2Ds){
                    if(collider.tag == target){
                        collider.GetComponent<BattleBehaviour>().GetDamaged(damage, knockbackPower ,transform, true, Enemy, true, Enemy);
                        Destroythis();
                    }
                    if(collider.tag == "Ground") if(IgnoreFloor == false) Destroythis();
                    
                }
            }
            if(StrightType) GoStraight();
            else if(GuidedType) GoGuided();
            else if(VectorType){
                if(!(destination == null)) GoVector();
            }
            else if(ImpulseType){
                if(!(destination == null)) GoVectorImpulse();
            }
        }
        else{
            gameObject.GetComponent<SpriteRenderer>().color = BulletInactiveColor;
            foreach(GameObject SubComponent in SubComponents){
                SubComponent.SetActive(false);
            }
        }
    }


    void GoStraight(){
        transform.Translate(transform.right * dir *speed*Time.deltaTime);
    }
    void GoGuided(){
        transform.Translate(destination*speed*Time.deltaTime);
    }

    void GoVector(){
        transform.Translate(destination*speed*Time.deltaTime);
    }

    void GoVectorImpulse(){
        rigid2D.AddForce(destination*speed*Time.deltaTime, ForceMode2D.Impulse);
    }

    void Destroythis(){
        if(Explosive){
            StartCoroutine(Explode());
        }
        else if(Separative){
            StartCoroutine(Separate(SeparateOffset, SeparateCount));
        }
        else{
            if(DestroyFX!= null){
                Instantiate(DestroyFX, transform.position, transform.rotation);
            }
            Destroy(gameObject);
        }

    }

    public IEnumerator Explode(){
        if(BulletActive){
            BulletActive = false;
            if(ExplosiveBulletDestroyFX != null) Instantiate(ExplosiveBulletDestroyFX, transform.position, ExplosiveBulletDestroyFX.transform.rotation);
            GameObject W = Instantiate(CircularWarningEffect, transform.position, CircularWarningEffect.transform.rotation);
            float rad = Explosion.GetComponent<Bullet>().radius;
            W.transform.localScale =new Vector2(rad*1.5f, rad*1.5f);
            
            yield return new WaitForSeconds(0.5f);
            
            Instantiate(Explosion, W.transform.position, Explosion.transform.rotation);
            Destroy(W);
            Destroy(gameObject);
            
        }
        
    }

    public IEnumerator Separate(float offset, int count){
        if(BulletActive){
            BulletActive = false;
            if(ExplosiveBulletDestroyFX != null) Instantiate(ExplosiveBulletDestroyFX, transform.position, ExplosiveBulletDestroyFX.transform.rotation);
            float weightangle = 0;
            float intervalangle = 180/count;
            for(int i = 0; i<count; i++){
                GameObject b = Instantiate(SeparationBullet, new Vector2(transform.position.x, transform.position.y+0.2f), transform.rotation);
                float angle = offset + weightangle + intervalangle * i;
                float x = Mathf.Cos(angle * Mathf.PI/180f);
                float y = Mathf.Sin(angle * Mathf.PI/180f);
                b.GetComponent<Bullet>().GetVector2(new Vector2(x,y));
            }
            yield return new WaitForSeconds(.5f);
            Destroy(gameObject);
        }
    }


    public void GetVector2(Vector2 vec){
        destination = vec;
    }
    private void OnDrawGizmos() {
        Gizmos.color = Color.blue;
        Gizmos.DrawWireSphere(transform.position,radius);
    }

}
