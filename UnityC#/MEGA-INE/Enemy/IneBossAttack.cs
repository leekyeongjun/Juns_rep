using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class IneBossAttack : MonoBehaviour
{
//아이네 보스 요소들=============================================================================
    [Header("메카 뚤기 =======================================================================")]
    public GameObject InebossBullet;
    public GameObject InebossBullet_2;
    public GameObject InebossBullet_3;

    public Transform LaserPosition;
    public Transform[] LaserPillarPositions;
    public List<GameObject> Wlists = new List<GameObject>();
    public List<GameObject> LaserPillarlists = new List<GameObject>();

    public bool movable = false;
    
    public Transform destination;
    private Vector3 destpos;
    private Vector3 initpos;
    private float speed;


    public GameObject spinningDulgi;
    public GameObject Dulgi;
    public GameObject hpbox;
    public GameObject spbox;
    public GameObject laser;
    public GameObject laserPillar;


    public GameObject BulletShootingFX;
    public GameObject LaserShootingFX;
    public GameObject LaserEmittingFX;
    public GameObject LaserPillarEmittingFX;
    public GameObject SummoningDulgiFX;
    public GameObject SummoningHPFX;

    [Space(7f)]
    

// 비챤 보스 요소들 =============================================================================
    [Header("메카 망냥라니 =======================================================================")]
    public GameObject ViiBoomerang;
    public Transform[] ViiPositions;

    public GameObject ViibossBulletTypeVector;
    public GameObject ViibossSwordWaveTypeVector;

    public Transform[] ViiSwordTeleportPosition;

    public GameObject ViiSwordSlash;

    public GameObject ViiBossThunder;
    public Transform ThunderPosition;

    public GameObject ViiSwordSlashFX;
    public GameObject ViiShootBoomerangFX;
    public GameObject ViiBossTeleportFX;
    public GameObject ViiBulletShootingFX;
    public GameObject ViiBossCastingFX;
    [Space(7f)]
// 세구 보스 요소들 =============================================================================
    [Header("균냥단 제조기_MK2 =======================================================================")]
    public Transform[] SeguChainSawPositions;
    public GameObject SeguChainSawLow;
    public GameObject SeguChainSawHigh;
    public GameObject SeguChainSawLowReversed;
    public GameObject SeguChainSawHighReversed;

    private GameObject Saw;

    public Transform SeguLaserPositions;
    public GameObject SeguLaser;

    private int spawnid;
    private int shooterid;

    [Header("0 UD 1 DU 2 UDR 3 DUR")]
    public Transform[] SeguShooterPositions;
    public Transform[] SeguShooterSpawnPositions; 
    [SerializeField]
    private GameObject[] SeguShooterVacancy = new GameObject[4];

    [Header("1 RUD 2 RDU 3 RUDR 4 RDUR 5 BUD 6 BDU 7 BUDR 8 BDUR")]
    public GameObject[] SeguShooters;

    public GameObject SeguLaserShootFX;
    public GameObject SeguSummoningSawFX;
    public GameObject SeguSummoningShooterFX;


// 릴파 보스 요소들 =============================================================================
    [Header("메카 박쥐백작 =======================================================================")]
    public Transform[] LilPositions;
    public Transform[] LilRushPositions;
    public Transform[] LilRushDestPositions;
    public GameObject LilDetector;
    public GameObject LilShooter;
    public GameObject LilHellFire;

    public GameObject LilbossBulletTypeVector;
    public GameObject LilBulletShootingFX;
    public GameObject LilTeleportingFX;
    public GameObject SummoningLilDetectorFX;

    public bool LilCanMove = true;
    public IEnumerator movecoroutine;
    public AudioSource WindSound;
    
// 버거 보스 요소들 =============================================================================
    [Header("징토템 =======================================================================")]
    public Vector2 OriginalJingBoxSize;
    public float JingBoxSizeOffset_y;
    public Transform[] JingPositions;
    public Transform[] LandAnchors;

    public Transform JingSidePosition;
    public Transform JingSidePreparePosition;

    public GameObject JingbossBulletImpulse;
    public GameObject JingBossBulletVector;
    public GameObject JingBossFireBall;

    public int CurPositionIndex = 4;

    public Transform BigFirePosition;

    public bool Down = false;
    public bool Idle = true;
    public bool HighUp = false;
    public bool Side = false;
    public bool SideFire = false;
    public bool Whole = false;

    public GameObject JingBiGBulletShootingFX;
    public GameObject JingBulletShootingFX;
    public GameObject JingBossUpFX;
    public GameObject JingBossDownFX;
    public GameObject JingBossFireBallShootingFX;

// 르르 보스 요소들 =============================================================================
    [Header("르르앰프의 요정=======================================================================")]
    public Transform[] JuPositions;
    public Transform[] JuPunchPositions;

    public Transform JuBossCastedFirePosition;
    public Transform FireBallChaser;
    public Vector2 JuBossPunchArea;
    public Vector2 JuBossIdleAttackArea;

    public GameObject JuBossTeleportFX;
    public GameObject JuBulletShootingFX;
    public GameObject JuSummonFX;

    public GameObject[] JuBossCastedFires;
    public GameObject JuBossBulletVector;


// 공통 요소들===================================================================================
    [Header("공통 =======================================================================")]   
    public bool Onpattern = false;
    public Transform FirePosition;
    public float Range;
    public Vector3 target;
    private Animator anim;
    public BattleBehaviour HeartBehaviour;
    public GameObject WarningEffect;
    public GameObject CircularWarningEffect;

    void Awake()
    {
        anim = GetComponent<Animator>();  
        if(movable){ // 아이네 only
            destpos = destination.position;
            initpos = transform.position;
        }
    }

    void Start(){
        movecoroutine = LilBossMove(); // 릴파 only
    }
    void Update()
    {
        if(HeartBehaviour.curHP <= 0){
            StopAllCoroutines();
        }
    }

//아이네 보스 패턴들 =======================================================================

    public IEnumerator ShootBulletRadial(int count){
        if(!Onpattern){
            Onpattern = true;
            float weightangle = Random.Range(0,15);
            float intervalangle = 360/count;

            anim.SetBool("ShootBullet", true);
            Instantiate(BulletShootingFX, FirePosition.position, FirePosition.rotation);
            for(int i = 0; i<count; i++){
                GameObject b = Instantiate(InebossBullet, FirePosition.position, FirePosition.rotation);
                float angle = weightangle + intervalangle * i;
                float x = Mathf.Cos(angle * Mathf.PI/180f);
                float y = Mathf.Sin(angle * Mathf.PI/180f);
                b.GetComponent<Bullet>().GetVector2(new Vector2(x,y));
            }

            yield return new WaitForSeconds(0.5f);
            anim.SetBool("ShootBullet", false);
            Onpattern = false;
        }
        
    }

    public IEnumerator ShootBulletDirectional(int count){
        if(!Onpattern){
            Onpattern = true;
            anim.SetBool("ShootBullet", true);
            Instantiate(BulletShootingFX, FirePosition.position, FirePosition.rotation);
            for(int i = 0 ; i< count; i++){
                GameObject b = Instantiate(InebossBullet_2, FirePosition.position, FirePosition.rotation);
                
                yield return new WaitForSeconds(0.25f);
            }

            anim.SetBool("ShootBullet", false);
            Onpattern = false;
        }

    }
    public IEnumerator ShootGreenBulletDirectional(int count){
        if(!Onpattern){
            Onpattern = true;
            anim.SetBool("ShootLaser", true);

            if(Player.player != null){
                float Dist = Vector3.Distance(transform.position, Player.player.transform.position);
                if(Dist <= Range){
                    target = Player.player.transform.position - transform.position;
                    Instantiate(BulletShootingFX, FirePosition.position, FirePosition.rotation);
                    for(int i = 0; i<count; i++){
                        GameObject b = Instantiate(InebossBullet_3, FirePosition.position, FirePosition.rotation, transform);
                        yield return new WaitForSeconds(1f);
                    }
                }else yield return null;
            }else yield return null;
        

            anim.SetBool("ShootLaser", false);
            Onpattern = false;
        }

    }

    public IEnumerator SpinMoveActivate(float duration){
        Debug.Log("Moving!!");
        if(!Onpattern){
            
            //float t = 0f;
            Onpattern = true;
            while(Vector2.Distance(transform.position,destpos)>0){
                //t += Time.deltaTime/duration;
                transform.position = Vector3.MoveTowards(transform.position, destpos, Time.deltaTime*3f);
                yield return null;
            }

            Vector3 tmp = transform.position;
            destpos = initpos;
            initpos = tmp;
            //t = 0;
            yield return new WaitForSeconds(2f);

            while(Vector2.Distance(transform.position,destpos)>0){
                //t += Time.deltaTime/duration;
                transform.position = Vector3.MoveTowards(transform.position, destpos, Time.deltaTime*3f);
                yield return null;
            }

            tmp = transform.position;
            destpos = initpos;
            initpos = tmp;

            
            yield return null;
            Onpattern = false;
        }
       
    }

    public IEnumerator SummonspinningDulgi(){
        if(!Onpattern){
            Onpattern = true;
            anim.SetBool("Summon", true);
            Instantiate(SummoningDulgiFX, FirePosition.position, FirePosition.rotation);
            GameObject s = Instantiate(spinningDulgi, FirePosition.position,  FirePosition.rotation);
            s.transform.SetParent(GameManager.GM.CurrentBoss.transform);
            yield return new WaitForSeconds(1f);
            anim.SetBool("Summon", false);
            Onpattern = false;
        }

    }
    public IEnumerator SummonDulgi(){
        if(!Onpattern){
            Onpattern = true;
            anim.SetBool("Summon", true);
            Instantiate(SummoningDulgiFX, FirePosition.position, FirePosition.rotation);
            GameObject s = Instantiate(Dulgi, FirePosition.position,  FirePosition.rotation);
            s.transform.SetParent(GameManager.GM.CurrentBoss.transform);
            yield return new WaitForSeconds(1f);
            anim.SetBool("Summon", false);
            Onpattern = false;
        }
    }

    public IEnumerator SummonHpbox(){
        if(!Onpattern){
            Onpattern = true;
            anim.SetBool("Summon", true);
            Instantiate(SummoningHPFX, FirePosition.position, FirePosition.rotation);
            GameObject s = Instantiate(hpbox, FirePosition.position,  FirePosition.rotation);
            yield return new WaitForSeconds(1f);
            anim.SetBool("Summon", false);
            Onpattern = false;
        }
    }

    public IEnumerator SummonSpbox(){
        if(!Onpattern){
            Onpattern = true;
            anim.SetBool("Summon", true);
            Instantiate(SummoningHPFX, FirePosition.position, FirePosition.rotation);
            GameObject s = Instantiate(spbox, FirePosition.position,  FirePosition.rotation);
            yield return new WaitForSeconds(1f);
            anim.SetBool("Summon", false);
            Onpattern = false;
        }
    }

    public IEnumerator LaserShoot(){
        if(!Onpattern){
            Onpattern = true;
            GameObject W = Instantiate(WarningEffect, LaserPosition.position, LaserPosition.rotation);
            Instantiate(LaserShootingFX, FirePosition.position, FirePosition.rotation);
            W.transform.localScale = new Vector2(laser.GetComponent<LaserAttack>().boxSize.x, laser.GetComponent<LaserAttack>().boxSize.y);
            yield return new WaitForSeconds(1f);
            Destroy(W);
            anim.SetBool("ShootLaser", true);
            GameObject L = Instantiate(laser, LaserPosition.position, LaserPosition.rotation);
            L.transform.SetParent(transform, true);
            GameObject Lfx = Instantiate(LaserEmittingFX, FirePosition.position, FirePosition.rotation);
            yield return new WaitForSeconds(1f);
            Destroy(L);
            Destroy(Lfx);
            anim.SetBool("ShootLaser", false);
            Onpattern = false;
        }
    }
    public IEnumerator LaserPillarBurst(float offset){
        if(!Onpattern){
            Onpattern = true;
            foreach(Transform LaserPillarPosition in LaserPillarPositions){
                GameObject W = Instantiate(WarningEffect, new Vector2(LaserPillarPosition.position.x + offset, LaserPillarPosition.position.y), transform.rotation);
                Instantiate(LaserShootingFX, FirePosition.position, FirePosition.rotation);
                W.transform.localScale = new Vector2(laserPillar.GetComponent<LaserAttack>().boxSize.x, laserPillar.GetComponent<LaserAttack>().boxSize.y);
                Wlists.Add(W);
                yield return new WaitForSeconds(0.3f);
            }

            yield return new WaitForSeconds(1f);

            foreach(GameObject W in Wlists){Destroy(W);}

            anim.SetBool("ShootLaser", true);
            GameObject Lfx = Instantiate(LaserPillarEmittingFX, FirePosition.position, FirePosition.rotation);

            foreach(Transform LaserPillarPosition in LaserPillarPositions){    
                GameObject L = Instantiate(laserPillar, new Vector2(LaserPillarPosition.position.x + offset, LaserPillarPosition.position.y), laserPillar.transform.rotation);
                L.transform.SetParent(transform, true);
                LaserPillarlists.Add(L);
                yield return new WaitForSeconds(0.3f);
            }
            yield return new WaitForSeconds(0.3f);

            foreach(GameObject L in LaserPillarlists){ Destroy(L);}
            anim.SetBool("ShootLaser", false);
            Destroy(Lfx);
            Onpattern = false;
        }
    }

    public IEnumerator DrillPush(){
        if(!Onpattern){
            Onpattern = true;
            GameObject W = Instantiate(WarningEffect, new Vector2(transform.position.x -2.8f, transform.position.y), transform.rotation);
            W.transform.localScale = new Vector2(transform.GetComponent<IneBossBody>().boxSize.x, transform.GetComponent<IneBossBody>().boxSize.y);
            yield return new WaitForSeconds(1f);
            Destroy(W); 
            Vector3 tmp = transform.position;
            transform.position = new Vector2(transform.position.x - 1.4f , transform.position.y);
            anim.SetBool("DrillAttack", true);
            yield return new WaitForSeconds(1f);
            anim.SetBool("DrillAttack", false);
            transform.position = tmp;
            Onpattern = false;
        }
        
    }

//비챤 보스 패턴들 =======================================================================
    
    public IEnumerator ShootBoomerang(){
        if(!Onpattern){
            Onpattern = true;
            anim.SetBool("ShootBullet", true);
            Instantiate(ViiShootBoomerangFX, FirePosition.position, ViiShootBoomerangFX.transform.rotation);
            GameObject s = Instantiate(ViiBoomerang, FirePosition.position,  FirePosition.rotation);
            s.transform.SetParent(GameManager.GM.CurrentBoss.transform);
            yield return new WaitForSeconds(1f);
            anim.SetBool("ShootBullet", false);
            Onpattern = false;
        }
    }
    

    public IEnumerator ShootBulletRadial180(int count, float offset){
        if(!Onpattern){
            Onpattern = true;
            float weightangle = Random.Range(0,15);
            float intervalangle = 180/count;

            anim.SetBool("ShootBullet", true);
            Instantiate(ViiBulletShootingFX, FirePosition.position, FirePosition.rotation);
            for(int i = 0; i<count; i++){
                GameObject b = Instantiate(ViibossBulletTypeVector, FirePosition.position, FirePosition.rotation);
                float angle = offset + weightangle + intervalangle * i;
                float x = Mathf.Cos(angle * Mathf.PI/180f);
                float y = Mathf.Sin(angle * Mathf.PI/180f);
                b.GetComponent<Bullet>().GetVector2(new Vector2(x,y));
            }

            yield return new WaitForSeconds(0.5f);
            anim.SetBool("ShootBullet", false);
            Onpattern = false;
        }  
    }

    public IEnumerator ShootSwordWaveRadial360(int count, int times){
        if(!Onpattern){
            Onpattern = true;
            anim.SetBool("Spinattack", true);
            yield return new WaitForSeconds(0.5f);
            for(int j = 0; j<times; j++){
                float weightangle = Random.Range(0,15);
                float intervalangle = 360/count;
                //Instantiate(BulletShootingFX, FirePosition.position, FirePosition.rotation);
                for(int i = 0; i<count; i++){
                    GameObject b = Instantiate(ViibossSwordWaveTypeVector, FirePosition.position, FirePosition.rotation);
                    float angle = weightangle + intervalangle * i;
                    float x = Mathf.Cos(angle * Mathf.PI/180f);
                    float y = Mathf.Sin(angle * Mathf.PI/180f);
                    b.GetComponent<Bullet>().GetVector2(new Vector2(x,y));
                }
                yield return new WaitForSeconds(0.5f);
            }
            anim.SetBool("Spinattack", false);
            Onpattern = false;
        }  
    }
    public IEnumerator ViiBossMove(float duration){
        
        if(!Onpattern){
            Debug.Log("Moving!!");
            //float t = 0f;
            Onpattern = true;
            Transform Destination = ViiPositions[Random.Range(0,ViiPositions.Length)];
            if(!(transform.position == Destination.position)){
                while(Vector2.Distance(transform.position,Destination.position) > 0){
                    //t += Time.deltaTime/duration;
                    transform.position = Vector3.MoveTowards(transform.position, Destination.position, 2f * Time.deltaTime);
                    yield return null;
                }
            }
            yield return null;
            Onpattern = false;
        }
    }

    public IEnumerator ViiSwordTeleportSwordWave(){
        if(!Onpattern){
            Transform Destination = ViiSwordTeleportPosition[Random.Range(0,ViiSwordTeleportPosition.Length)];
            if(!(transform.position == Destination.position)){
                Debug.Log("Teleporting!!");
                Onpattern = true;
                anim.SetBool("OnDesolve", true);
                yield return new WaitForSeconds(0.6f);
                transform.position = Destination.position;
                anim.SetBool("OnDesolve", false);
                anim.SetBool("OnGenerate", true);
                yield return new WaitForSeconds(0.6f);
                anim.SetBool("OnGenerate", false);
                anim.SetBool("OnSwordSlash", true);
                Instantiate(ViiSwordSlashFX, FirePosition.position, ViiSwordSlashFX.transform.rotation);
                Instantiate(ViiSwordSlash, FirePosition.position, ViiSwordSlash.transform.rotation);
                yield return new WaitForSeconds(1f);
                anim.SetBool("OnSwordSlash", false);
            }
            Onpattern = false;
        }

    }

    public IEnumerator ViiSwordTeleport(){
        if(!Onpattern){
            Transform Destination = ViiPositions[Random.Range(0,ViiPositions.Length)];
            if(!(transform.position == Destination.position)){
                Debug.Log("Teleporting!!");
                Onpattern = true;
                anim.SetBool("OnDesolve", true);
                yield return new WaitForSeconds(0.6f);
                transform.position = Destination.position;
                anim.SetBool("OnDesolve", false);
                anim.SetBool("OnGenerate", true);
                yield return new WaitForSeconds(0.6f);
                anim.SetBool("OnGenerate", false);
            }
            Onpattern = false;
        }
    }
    public IEnumerator ViiBossTeleport(){
        if(!Onpattern){
            Debug.Log("Teleporting!!");
            Onpattern = true;
            Transform Destination = ViiPositions[Random.Range(0,ViiPositions.Length)];
            if(!(transform.position == Destination.position)){
                GameObject GoFX = Instantiate(ViiBossTeleportFX, transform.position, transform.rotation);
                transform.position = Destination.position;
                GameObject EndFX = Instantiate(ViiBossTeleportFX, transform.position, transform.rotation);
                GoFX.transform.SetParent(GameManager.GM.CurrentBoss.transform);
                EndFX.transform.SetParent(GameManager.GM.CurrentBoss.transform);
                yield return new WaitForSeconds(1f);
                
                Destroy(GoFX);
                Destroy(EndFX);
            }
            Onpattern = false;
        }

    }
    

    public IEnumerator ViiSummonLaser(){
        if(!Onpattern){
            Onpattern = true;
            GameObject W = Instantiate(WarningEffect, ThunderPosition.position,ThunderPosition.rotation);
            W.transform.localScale = new Vector2(ViiBossThunder.GetComponent<Enemy>().boxSize.x, ViiBossThunder.GetComponent<Enemy>().boxSize.y);
            yield return new WaitForSeconds(1f);
            Destroy(W);
            anim.SetBool("IsCasting", true);
            GameObject Lfx = Instantiate(ViiBossCastingFX, transform.position, ViiBossCastingFX.transform.rotation);
            GameObject L = Instantiate(ViiBossThunder, ThunderPosition.position, ThunderPosition.rotation);
            Lfx.transform.SetParent(GameManager.GM.CurrentBoss.transform);
            L.transform.SetParent(GameManager.GM.CurrentBoss.transform);
            yield return new WaitForSeconds(3f);
            L.GetComponent<Animator>().SetBool("IsDesolve", true);
            yield return new WaitForSeconds(1f);
            Destroy(Lfx);
            Destroy(L);
            Onpattern = false;
        }
    }
//릴파 보스 패턴들 =======================================================================
    public IEnumerator LilBossMove(){
        if(LilCanMove){
            if(!Onpattern){
                Debug.Log("Moving!!");
                //float t = 0f;
                //Onpattern = true;
                Transform Destination = LilPositions[Random.Range(0,LilPositions.Length)];
                if(!(transform.position == Destination.position)){
                    while(Vector2.Distance(transform.position,Destination.position) > 0){
                        if(LilCanMove){
                            //t += Time.deltaTime/duration;
                            transform.position = Vector3.MoveTowards(transform.position, Destination.position, 4f * Time.deltaTime);
                            yield return null;
                        }
                        else{
                            break;
                        }
                    }
                }
                yield return null;
                //Onpattern = false;
            }
        }
    }

    public IEnumerator LilShootBulletRadial(int times, int count, float interval, float offset){
        if(!Onpattern){
            Onpattern = true;
            float weightangle = Random.Range(0,15);
            float intervalangle = interval/count;

            Instantiate(LilBulletShootingFX, FirePosition.position, FirePosition.rotation);
            for(int j =0; j<times; j++){
                for(int i = 0; i<count; i++){
                    GameObject b = Instantiate(LilbossBulletTypeVector, FirePosition.position, FirePosition.rotation);
                    float angle = offset + weightangle + intervalangle * i;
                    float x = Mathf.Cos(angle * Mathf.PI/180f);
                    float y = Mathf.Sin(angle * Mathf.PI/180f);
                    b.GetComponent<Bullet>().GetVector2(new Vector2(x,y));
                }
                yield return new WaitForSeconds(0.5f);

            }
            Onpattern = false;
        }  
    }

    public IEnumerator LilBossRush(float duration){
        if(!Onpattern){
            Onpattern = true;
            LilCanMove = false;
            StopCoroutine(movecoroutine);
            Debug.Log("Rush Ready");
            
            int DestId = Random.Range(0,LilRushPositions.Length);
            Transform Destination = LilRushPositions[DestId];
            Instantiate(LilTeleportingFX, transform.position, LilTeleportingFX.transform.rotation);
            anim.SetBool("Teleport", true);
            yield return new WaitForSeconds(0.7f);

            transform.position = Destination.position;
            Debug.Log("Rush TP");

            anim.SetBool("Appear", true);
            anim.SetBool("Teleport", false);
            yield return new WaitForSeconds(0.7f);
            anim.SetBool("Appear", false);

            GameObject W = Instantiate(WarningEffect, Destination.position, Destination.rotation);
            W.transform.localScale = new Vector2(100, transform.GetComponent<Enemy>().boxSize.y);

            yield return new WaitForSeconds(1f);
            Destroy(W);
            
            anim.SetBool("OnRush", true);

            Debug.Log("Rush!");
            WindSound.Play();
            Transform RushDest = LilRushDestPositions[DestId];
            while(Vector2.Distance(transform.position, RushDest.position) > 0.5){
                //t += Time.deltaTime/duration;
                Debug.Log(Vector2.Distance(transform.position, RushDest.position).ToString());
                transform.position = Vector3.MoveTowards(transform.position, RushDest.position, 100f * Time.deltaTime);
                yield return null;
            }

            anim.SetBool("OnRush", false);
            Transform EndDest = LilPositions[Random.Range(0,LilPositions.Length)];
            GameObject W2 = Instantiate(WarningEffect, EndDest.position, EndDest.rotation);
            W2.transform.localScale = new Vector2(transform.GetComponent<Enemy>().boxSize.x,transform.GetComponent<Enemy>().boxSize.y);
            yield return new WaitForSeconds(1f);
            Destroy(W2);
            
            anim.SetBool("Teleport", true);
            yield return new WaitForSeconds(0.7f);

            transform.position = EndDest.position;
            Instantiate(LilTeleportingFX, transform.position, LilTeleportingFX.transform.rotation);
            anim.SetBool("Appear", true);
            anim.SetBool("Teleport", false);
            yield return new WaitForSeconds(0.7f);
            anim.SetBool("Appear", false);
            yield return new WaitForSeconds(0.7f);
            Onpattern = false;
            LilCanMove = true;
        }

    }

    public IEnumerator LilSpawnDetector(){
        if(!Onpattern){
            Onpattern = true;
            anim.SetBool("Summon", true);
            Instantiate(SummoningLilDetectorFX, FirePosition.position, FirePosition.rotation);
            GameObject s = Instantiate(LilDetector, FirePosition.position,  FirePosition.rotation);
            //s.transform.SetParent(GameManager.GM.CurrentBoss.transform);
            yield return new WaitForSeconds(1f);
            anim.SetBool("Summon", false);
            Onpattern = false;
        }

    }
    public IEnumerator LilSpawnShooter(){
        if(!Onpattern){
            Onpattern = true;
            anim.SetBool("Summon", true);
            Instantiate(SummoningLilDetectorFX, FirePosition.position, FirePosition.rotation);
            GameObject s = Instantiate(LilShooter, FirePosition.position,  FirePosition.rotation);
            //s.transform.SetParent(GameManager.GM.CurrentBoss.transform);
            yield return new WaitForSeconds(1f);
            anim.SetBool("Summon", false);
            Onpattern = false;
        }

    }
    public IEnumerator LilShootHellFire(){
        if(!Onpattern){
            Onpattern = true;
            if(Player.player != null){
                Transform Target = Player.player.transform;
                GameObject W = Instantiate(CircularWarningEffect, Target.position, CircularWarningEffect.transform.rotation, transform);
                float rad = LilHellFire.GetComponent<Bullet>().radius;
                W.transform.localScale =new Vector2(rad*1.5f, rad*1.5f);
                yield return new WaitForSeconds(1f);
                

                Instantiate(LilHellFire, W.transform.position, LilHellFire.transform.rotation);
                Destroy(W);
                Onpattern = false;
                yield return null;
            }
            
        }
    }

//징버거 보스패턴들 =================================================================
    public IEnumerator JingBossDown(){
        if(!Onpattern){
            if(Idle) {
                Debug.Log("JingBossDown!");
                Onpattern = true;
                anim.SetBool("Down", true);
                Idle = false;
                Down = true;
                Instantiate(JingBossDownFX, LandAnchors[CurPositionIndex].position, JingBossDownFX.transform.rotation);
                yield return new WaitForSeconds(1f);
                Onpattern = false;
            }
        }
    }

    public IEnumerator JingBossDownMove(){
        if(!Onpattern){
            if(Down){
                Debug.Log("JingBossDownMove!");
                Onpattern = true;
                CurPositionIndex = Random.Range(0,JingPositions.Length);
                Transform Destination = JingPositions[CurPositionIndex];
                if(!(transform.position == Destination.position)){
                    Debug.Log("yay");
                    transform.position = Destination.position;
                    Onpattern = false;
                }
                else{
                    Debug.Log("nay");
                    Onpattern = false;
                }
                yield return null;
            }
            yield return null;
        }
        yield return null;
    }

    public IEnumerator JingBossUp(float offset, int count){
        if(!Onpattern){
            if(Down){
                Onpattern = true;
                GameObject W = Instantiate(WarningEffect, new Vector3(transform.position.x, transform.position.y+JingBoxSizeOffset_y, transform.position.z) ,transform.rotation);
                W.transform.localScale = OriginalJingBoxSize;
                yield return new WaitForSeconds(1f);
                Destroy(W);
                Instantiate(JingBossUpFX, LandAnchors[CurPositionIndex].position, JingBossUpFX.transform.rotation);
                Debug.Log("JingBossUp!");
                anim.SetBool("Down",false);
                anim.SetBool("Up", true);
                Idle = true;
                Down = false;
                yield return new WaitForSeconds(0.2f);
                anim.SetBool("Up", false);
                float weightangle = 0;
                float intervalangle = 180/count;
                Instantiate(JingBulletShootingFX, FirePosition.position, FirePosition.rotation);
                for(int i = 0; i<count; i++){
                    GameObject b = Instantiate(JingbossBulletImpulse, FirePosition.position, FirePosition.rotation);
                    float angle = offset + weightangle + intervalangle * i;
                    float x = Mathf.Cos(angle * Mathf.PI/180f);
                    float y = Mathf.Sin(angle * Mathf.PI/180f);
                    b.GetComponent<Bullet>().GetVector2(new Vector2(x,y));
                }
                Onpattern = false;
            }
        }
    }

    public IEnumerator JingBossHighUp(float offset, int count){
        if(!Onpattern){
            if(Idle){
                Onpattern = true;
                anim.SetBool("HighUp", true);
                float weightangle = Random.Range(0,15);
                float intervalangle = 360/count;
                Instantiate(JingBiGBulletShootingFX, BigFirePosition.position, BigFirePosition.rotation);
                for(int i = 0; i<count; i++){
                    
                    GameObject b = Instantiate(JingBossBulletVector, BigFirePosition.position, BigFirePosition.rotation);
                    float angle = offset + weightangle + intervalangle * i;
                    float x = Mathf.Cos(angle * Mathf.PI/360f);
                    float y = Mathf.Sin(angle * Mathf.PI/360f);
                    b.GetComponent<Bullet>().GetVector2(new Vector2(x,y));
                    b.transform.SetParent(GameManager.GM.CurrentBoss.transform);
                    yield return new WaitForSeconds(0.1f);
                }
                yield return new WaitForSeconds(1.5f);
                anim.SetBool("HighUp", false);
                Onpattern = false;
            }
        }
    }

    public IEnumerator JingBossSide(float duration, float offset, int count){
        if(!Onpattern){
            if(Down){
                Onpattern = true;
                Down = false;
                Side = true;
                transform.position = JingSidePreparePosition.position;
                anim.SetBool("Side", true);
                yield return new WaitForSeconds(0.5f);
                Vector2 off = transform.GetComponent<JingBossBody>().Offset;
                GameObject W = Instantiate(WarningEffect, new Vector2(JingSidePosition.position.x+off.x, JingSidePosition.position.y+off.y), transform.rotation);
                W.transform.localScale = transform.GetComponent<JingBossBody>().boxSize;
                yield return new WaitForSeconds(1f);
                Destroy(W);

                
                while(Vector2.Distance(transform.position,JingSidePosition.position) > 0){
                    transform.position = Vector3.MoveTowards(transform.position, JingSidePosition.position, 10f * Time.deltaTime);
                    yield return null;
                }

                anim.SetBool("SideFire", true);
                GameObject F = Instantiate(JingBossFireBallShootingFX, FirePosition.position, FirePosition.rotation);
                F.transform.SetParent(GameManager.GM.CurrentBoss.transform);
                float weightangle = Random.Range(0,15);
                float intervalangle = 360/count;

                for(int i = 0; i<count; i++){
                    GameObject b = Instantiate(JingBossFireBall, FirePosition.position, FirePosition.rotation);
                    float angle = offset + weightangle + intervalangle * i;
                    float x = Mathf.Cos(angle * Mathf.PI/360f);
                    float y = Mathf.Sin(angle * Mathf.PI/360f);
                    b.GetComponent<Bullet>().GetVector2(new Vector2(x,y));
                    yield return new WaitForSeconds(0.1f);
                }
                Destroy(F);
                yield return new WaitForSeconds(0.5f);
                Debug.Log("Shoot!");
                anim.SetBool("SideFire", false);

                while(Vector2.Distance(transform.position,JingSidePreparePosition.position) > 0){
                    transform.position = Vector3.MoveTowards(transform.position, JingSidePreparePosition.position, 10f*Time.deltaTime);
                    yield return null;
                }

                anim.SetBool("Side", false);
                yield return new WaitForSeconds(0.3f);

                transform.position = JingPositions[CurPositionIndex].position;
                Down = true;
                Side = false;
                Onpattern = false;
            }
        }
    }



//고세구 보스 패턴들 ========================================================================
    public IEnumerator SpawnChainSaw(int id){
        if(!Onpattern){
            Onpattern = true;
            Instantiate(SeguSummoningSawFX, transform.position, SeguSummoningSawFX.transform.rotation);
            if(id == 0 || id == 1){
                GameObject W = Instantiate(WarningEffect,SeguChainSawPositions[id].position, WarningEffect.transform.rotation);
                W.transform.localScale = new Vector2(100f, SeguChainSawLow.GetComponent<Enemy>().boxSize.y);
                yield return new WaitForSeconds(1f);
                Destroy(W);
                Saw = Instantiate(SeguChainSawLow, SeguChainSawPositions[id].position, SeguChainSawLow.transform.rotation);
            }
            else if(id == 2){
                GameObject W = Instantiate(WarningEffect,SeguChainSawPositions[id].position, WarningEffect.transform.rotation);
                W.transform.localScale = new Vector2(100f,SeguChainSawHigh.GetComponent<Enemy>().boxSize.y);
                yield return new WaitForSeconds(1f);
                Destroy(W);
                Saw = Instantiate(SeguChainSawHigh, SeguChainSawPositions[id].position, SeguChainSawHigh.transform.rotation);
            }
            else if(id == 3 || id == 4){
                GameObject W = Instantiate(WarningEffect,SeguChainSawPositions[id].position, WarningEffect.transform.rotation);
                W.transform.localScale = new Vector2(100f,SeguChainSawLowReversed.GetComponent<Enemy>().boxSize.y);
                yield return new WaitForSeconds(1f);
                Destroy(W);
                Saw = Instantiate(SeguChainSawLowReversed, SeguChainSawPositions[id].position, SeguChainSawHigh.transform.rotation);
            }
            else if(id == 5){
                GameObject W = Instantiate(WarningEffect,SeguChainSawPositions[id].position, WarningEffect.transform.rotation);
                W.transform.localScale = new Vector2(100f,SeguChainSawHighReversed.GetComponent<Enemy>().boxSize.y);
                yield return new WaitForSeconds(1f);
                Destroy(W);
                Saw = Instantiate(SeguChainSawHighReversed, SeguChainSawPositions[id].position, SeguChainSawHigh.transform.rotation);

            }
            Saw.transform.SetParent(GameManager.GM.CurrentBoss.transform);
            Onpattern = false;
            yield return null;
        }

    }

    public IEnumerator SpawnShooter(int colorid, int UD, int direction){
        if(!Onpattern){
            Onpattern = true;
            Instantiate(SeguSummoningShooterFX, transform.position, SeguSummoningShooterFX.transform.rotation);
            if(colorid == 0){
                if(UD == 0){
                    if(direction == 0) {
                        spawnid = 0;
                        shooterid = 0;
                        // RUD 0,0 
                    }
                    else if(direction == 1) {
                        spawnid = 2;
                        shooterid = 2;
                    }// RUDR 2,2
                }
                else if(UD == 1){
                    if(direction == 0){
                        spawnid = 1;
                        shooterid = 1;
                    } // RDU 1,1
                    else if(direction == 1){
                        spawnid = 3;
                        shooterid = 3;
                    } // RDUR 3,3
                }
            }
            else if(colorid == 1){
                if(UD == 0){
                    if(direction == 0) {
                        spawnid = 0;
                        shooterid = 4;
                    }// BUD 4,0
                    else if(direction == 1){
                        spawnid = 2;
                        shooterid = 6;
                    } // BUDR 6,2
                }
                else if(UD == 1){
                    if(direction == 0){
                        spawnid = 1;
                        shooterid = 5;
                    } // BDU 5,1
                    else if(direction == 1){
                        spawnid = 3;
                        shooterid = 7;
                    } // BDUR 7,3
                }
            }

            if(SeguShooterVacancy[spawnid] == null){

                GameObject S = Instantiate(SeguShooters[shooterid], SeguShooterSpawnPositions[spawnid].position, SeguShooterSpawnPositions[spawnid].rotation);
                SeguShooterVacancy[spawnid] = S;
                S.transform.SetParent(GameManager.GM.CurrentBoss.transform);

                Transform Destination = SeguShooterPositions[spawnid];
                if(!(S.transform.position == Destination.position)){
                    while(Vector2.Distance(S.transform.position,Destination.position) > 0){
                        S.transform.position = Vector3.MoveTowards(S.transform.position, Destination.position, 5f * Time.deltaTime);
                        yield return null;
                    }
                }

                if(colorid == 0) StartCoroutine(S.GetComponent<EnemyAttack>().SeguRedShooterShoot(5, 15, shooterid));
                if(colorid == 1) StartCoroutine(S.GetComponent<EnemyAttack>().SeguBlueShooterShoot(5));

                
                yield return new WaitForSeconds(3f);

                Transform Destination2 = SeguShooterSpawnPositions[spawnid];
                if(!(S.transform.position == Destination2.position)){
                    while(Vector2.Distance(S.transform.position,Destination2.position) > 0){   
                        S.transform.position = Vector3.MoveTowards(S.transform.position, Destination2.position, 5f * Time.deltaTime);
                        yield return null;
                    }
                }

                SeguShooterVacancy[spawnid] = null;
                Destroy(S);
                Onpattern = false;
            }
            else{
                Onpattern = false;
            }
        }
    }

    public IEnumerator SeguLaserShoot(){
        if(!Onpattern){
            Onpattern = true;
            Instantiate(SeguLaserShootFX, transform.position, SeguLaserShootFX.transform.rotation);
            foreach(Transform Laserpos in SeguLaserPositions){
                GameObject L = Instantiate(SeguLaser, Laserpos.position, SeguLaser.transform.rotation);
                L.transform.SetParent(GameManager.GM.CurrentBoss.transform);
                yield return new WaitForSeconds(.2f);
                Destroy(L);
            }
            Onpattern = false;
        }
    }
//르르 보스패턴들=======================================================================
    public IEnumerator JuBossMove(float duration){
        //if(!Onpattern){
            Debug.Log("Moving!!");
            //Onpattern = true;
            Transform Destination = JuPositions[Random.Range(0,JuPositions.Length)];
            
            while(Vector2.Distance(transform.position, Destination.position) > 0.2){
                transform.position = Vector3.MoveTowards(transform.position, Destination.position, 3f * Time.deltaTime);
                yield return null;
            }
            
            yield return null;
            //Onpattern = false;
        //}
    }

    public IEnumerator JuBossShrinkPunch(){
        if(!Onpattern){
            Onpattern = true;
            anim.SetBool("Shrink", true);
            yield return new WaitForSeconds(0.5f);
            Transform Destination = JuPunchPositions[Random.Range(0, JuPunchPositions.Length)];
            Instantiate(JuBossTeleportFX, transform.position, JuBossTeleportFX.transform.rotation);
            if(!(transform.position == Destination.position)){
                GameObject W = Instantiate(WarningEffect, Destination.position, WarningEffect.transform.rotation);
                W.transform.localScale = JuBossPunchArea;
                yield return new WaitForSeconds(1f);
                Destroy(W);
                transform.position = Destination.position;
                Instantiate(JuBossTeleportFX, transform.position, JuBossTeleportFX.transform.rotation);
                anim.SetTrigger("Punch");
                yield return new WaitForSeconds(2f);
            }


 
            Transform Destination2 = JuPositions[Random.Range(0,JuPositions.Length)];
            GameObject W2 = Instantiate(WarningEffect, Destination2.position, WarningEffect.transform.rotation);        
            W2.transform.localScale = JuBossIdleAttackArea;
            yield return new WaitForSeconds(1f);
            Destroy(W2);
            //Instantiate(JuBossTeleportFX, transform.position, JuBossTeleportFX.transform.rotation);
            transform.position = Destination2.position;
            Instantiate(JuBossTeleportFX, transform.position, JuBossTeleportFX.transform.rotation);

           
            anim.SetBool("Shrink", false);
            yield return new WaitForSeconds(1f);
            Onpattern = false;
        }
    }
    public IEnumerator JuBossCast(float offset, int count){
        if(!Onpattern){
            Onpattern = true;
            anim.SetTrigger("Cast");
            float weightangle = Random.Range(0,15);
            float intervalangle = 360/count;
            Instantiate(JuBulletShootingFX,FirePosition.position, FirePosition.rotation);
            for(int i = 0; i<count; i++){
                GameObject b = Instantiate(JuBossBulletVector, FirePosition.position, FirePosition.rotation);
                float angle = offset + weightangle + intervalangle * i;
                float x = Mathf.Cos(angle * Mathf.PI/360f);
                float y = Mathf.Sin(angle * Mathf.PI/360f);
                b.GetComponent<Bullet>().GetVector2(new Vector2(x,y));
                yield return new WaitForSeconds(0.1f);
            }
            yield return new WaitForSeconds(1f);
            Onpattern = false;
        }
    }

    public IEnumerator JuBossFireCast(){
        if(!Onpattern){
            Onpattern = true;
            GameObject W = Instantiate(WarningEffect, transform.position, transform.rotation);
            W.transform.localScale = new Vector2(100f,100f);
            yield return new WaitForSeconds(1f);
            Destroy(W);

            anim.SetTrigger("FireCast");
            Instantiate(JuSummonFX,FirePosition.position, FirePosition.rotation);
            GameObject F = Instantiate(JuBossCastedFires[Random.Range(0,JuBossCastedFires.Length)], JuBossCastedFirePosition.position, JuBossCastedFires[Random.Range(0,JuBossCastedFires.Length)].transform.rotation);
            F.transform.SetParent(FireBallChaser);
            //F.transform.SetParent(GameObject.GM.CurrentBoss);
            yield return new WaitForSeconds(5f);
            F.GetComponent<JuBossCastedFireController>().DisableFireBalls();
            yield return new WaitForSeconds(.5f);
            Destroy(F);
            Onpattern = false;

        }
    }


//기즈모스    
    private void OnDrawGizmos() {
        Gizmos.color = Color.red;
        Gizmos.DrawWireSphere(transform.position,Range);
        
        Gizmos.color = Color.green;
        Gizmos.DrawWireCube(transform.position, JuBossPunchArea);
    }



}
