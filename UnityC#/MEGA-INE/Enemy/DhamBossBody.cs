using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DhamBossBody : MonoBehaviour
{
    public bool canPattern = false;

    public float patternCoolTime;
    public int patternID;

    
    private Rigidbody2D rigid2D;
    private Animator anim;
    private BattleBehaviour battleBehaviour;
    private DhamBossAttack bossattack;
    public BattleBehaviour HeartBehaviour;


    public List<GameObject> hamFaces;
    private float degree;
    public float faceSpinSpeed;
    public float radius;
    public float plusrad = 60f;
    public Vector2 radius_offset;


    // 0 ine 1 jing 2 lil 3 vii 4 segu 5 ruru;


    [Space(3f)]
    [Header("적의 피격 범위")]
    
    public Vector2 boxSize;
    public Vector2 Offset;

    
    void Awake()
    {
        anim = GetComponent<Animator>();    
        rigid2D = GetComponent<Rigidbody2D>();
        battleBehaviour = GetComponent<BattleBehaviour>();
        bossattack = GetComponent<DhamBossAttack>();
        //movement2D = GetComponent<Movement2D>();
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
    

    private void Facesmove(){
        Vector3 pos = new Vector3(transform.position.x + radius_offset.x , transform.position.y + radius_offset.y, transform.position.z);
        foreach(GameObject face in hamFaces){
        
            int i = hamFaces.IndexOf(face);
            degree += Time.deltaTime * faceSpinSpeed;
            if(degree < 360){
                var rad = Mathf.Deg2Rad *(degree) + (i*plusrad);
                var x = radius * Mathf.Sin(rad);
                var y = radius * Mathf.Cos(rad);

                face.transform.position = pos + new Vector3(x,y);
            }
            else{
                degree = 0;
            }
        }
    }

    private void FaceCheck(){
        for(int i =0; i<6; i++){
            if(hamFaces[i].activeSelf == true) return;
        }
        battleBehaviour.isInvincible = false;
    }

    void Start()
    {
        Invoke("PatternOn", 2f);
    }

    void Update()
    {
        FaceCheck();

        if(HeartBehaviour.curHP > 0){
            Facesmove();
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
            int patternID = Random.Range(1,15);
            Pattern(patternID);
            float cool = patternCoolTime;
            yield return new WaitForSeconds(cool);
            canPattern = true;
        }
    }

    public void Pattern(int patternID){

        if(patternID == 1){
            bossattack.MainBot_LaserShoot();
        }
        if(patternID == 2){
            bossattack.MainBot_RipleShoot();
        }
        if(patternID == 3){
            bossattack.MainBot_Summon();
        }
        if(patternID == 4){
            if(hamFaces[0].activeSelf != false){
                StartCoroutine(hamFaces[0].GetComponent<DhamBossAttack>().ShootGreenBulletDirectional(3));
            }
            else{
                bossattack.MainBot_RipleShoot();
            }
        }

        if(patternID == 5){
            if(hamFaces[2] .activeSelf != false){
                StartCoroutine(hamFaces[2].GetComponent<DhamBossAttack>().LilShootHellFire());
            }
            else{
                bossattack.MainBot_LaserShoot();
            }
        }
        if(patternID == 6){
            if(hamFaces[1] .activeSelf != false){
                StartCoroutine(hamFaces[1].GetComponent<DhamBossAttack>().JingBotSummonBullet());
            }
            else{
                StartCoroutine(bossattack.DhamBossMove(3f));
            }
        }
        if(patternID == 7){
            if(hamFaces[4] .activeSelf != false){
                StartCoroutine(hamFaces[4].GetComponent<DhamBossAttack>().SeguSummonSaws());
            }
            else{
                bossattack.MainBot_Summon();
            }
        }
        if(patternID == 8){
            if(hamFaces[5] .activeSelf != false){
                StartCoroutine(hamFaces[5].GetComponent<DhamBossAttack>().RuruBotSummonBullet());
            }
            else{
                StartCoroutine(bossattack.DhamBossMove(3f));
            }
        }
        if(patternID == 9){
            if(hamFaces[3].activeSelf != false){
                StartCoroutine(hamFaces[3].GetComponent<DhamBossAttack>().ShootViimerang());
            }
            else{
                bossattack.MainBot_LaserShoot();
            }
        }
        if(patternID == 10){
            StartCoroutine(bossattack.DhamBossMove(3f));
        }
        if(patternID == 11){
            StartCoroutine(bossattack.DhamBossMove(3f));
        }
        if(patternID == 12){
            StartCoroutine(bossattack.DhamBossMove(3f));
        }
        if(patternID == 13){
            StartCoroutine(bossattack.DhamBossMove(3f));
        }
        if(patternID == 14){
            StartCoroutine(bossattack.DhamBossMove(3f));
        }
    }

    void PatternOn(){
        canPattern = true;
    }

    private void OnDrawGizmos() {
        Gizmos.color = Color.blue;
        Gizmos.DrawWireCube(new Vector2(transform.position.x + Offset.x , transform.position.y + Offset.y), boxSize);
        Gizmos.DrawWireSphere(new Vector2(transform.position.x + radius_offset.x , transform.position.y + radius_offset.y), radius);
    }

}
