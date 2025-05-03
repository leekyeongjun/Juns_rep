using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DhamBossAttack : MonoBehaviour
{

// main
    public Transform RipleShootPosition;
    public Transform LaserShooterPostion;
    public Transform[] LaserShootPosition;
    public Transform SummonPosition;

    public GameObject DLaser;
    public GameObject DhamBullet;

    public Transform[] DhamPositions;

    public GameObject[] randomMobs;

    public GameObject LaserShootFX;
    public GameObject SummonFX;
    public GameObject SummoningFX;
    public GameObject RipleShootFX;




// ine 
    [Header("아이네 봇 =======================================================================")]   
    
    public GameObject IneBulletShootingFX;
    public GameObject IneBullet;
    public float Range;
    public Vector3 target;

    public IEnumerator ShootGreenBulletDirectional(int count){
        if(!Onpattern){
            Onpattern = true;
            if(Player.player != null){
                float Dist = Vector3.Distance(transform.position, Player.player.transform.position);
                if(Dist <= Range){
                    transform.GetComponent<Animator>().SetBool("IneAttack", true);
                    for(int i = 0; i<count; i++){
                        target = Player.player.transform.position - transform.position;
                        Instantiate(IneBulletShootingFX, FirePosition.position, FirePosition.rotation);
                        GameObject b = Instantiate(IneBullet, FirePosition.position, FirePosition.rotation, transform);
                        yield return new WaitForSeconds(1f);
                    }
                    transform.GetComponent<Animator>().SetBool("IneAttack", false);
                }else yield return null;
            }else yield return null;
            Onpattern = false;
        }
    }

// lil
    [Header("릴봇 =======================================================================")]   
    
    public GameObject LilHellFire;


    public IEnumerator LilShootHellFire(){
        if(!Onpattern){
            Onpattern = true;
            if(Player.player != null){
                Transform Target = Player.player.transform;
                GameObject W = Instantiate(CircularWarning, Target.position, CircularWarning.transform.rotation, transform);
                float rad = LilHellFire.GetComponent<Bullet>().radius;
                W.transform.localScale =new Vector2(rad*1.5f, rad*1.5f);
                yield return new WaitForSeconds(1f);
                
                transform.GetComponent<Animator>().SetBool("LilAttack", true);
                Instantiate(LilHellFire, W.transform.position, LilHellFire.transform.rotation);
                Destroy(W);
                Onpattern = false;
                yield return null;
            }
        }
    }
// vii
[Header("비봇 =======================================================================")]
    public GameObject Viimerang;
    public GameObject ViimerangShootFX;

    public IEnumerator ShootViimerang(){
        if(!Onpattern){
            Onpattern = true;
            transform.GetComponent<Animator>().SetBool("ViiAttack", true);
            Instantiate(ViimerangShootFX, FirePosition.position, FirePosition.rotation);
            Instantiate(Viimerang, FirePosition.position, FirePosition.rotation);
            yield return null;
        }
    }

// segu
[Header("세구봇 =======================================================================")]   
    public Transform[] SPUD;
    public Transform[] SPDU;
    public Transform[] SPRL;

    public GameObject SeguSawRL;
    public GameObject SeguSawUD;
    public GameObject SeguSawDU;

    public IEnumerator SeguSummonSaws(){
        if(!Onpattern){
            List<GameObject> Wlist = new List<GameObject>();
            int pNum = Random.Range(0,3);
            if(pNum == 0){
                GameObject W = Instantiate(Warning,  SPUD[0].position, SPUD[0].rotation);
                W.transform.SetParent(GameManager.GM.CurrentBoss.transform);
                Wlist.Add(W);
                W.transform.localScale = new Vector2(SeguSawUD.GetComponent<Enemy>().boxSize.x, 50f);

                GameObject W2 = Instantiate(Warning,  SPUD[2].position, SPUD[2].rotation);
                W2.transform.SetParent(GameManager.GM.CurrentBoss.transform);
                Wlist.Add(W2);
                W2.transform.localScale = new Vector2(SeguSawUD.GetComponent<Enemy>().boxSize.x, 50f);

                GameObject W3 = Instantiate(Warning,  SPRL[1].position, SPRL[1].rotation);
                W3.transform.SetParent(GameManager.GM.CurrentBoss.transform);
                Wlist.Add(W3);
                W3.transform.localScale = new Vector2( 100f, SeguSawRL.GetComponent<Enemy>().boxSize.y);

                yield return new WaitForSeconds(1f);
                transform.GetComponent<Animator>().SetBool("SeguAttack", true);
                foreach(GameObject w in Wlist){
                    Destroy(w);
                }

                GameObject S = Instantiate(SeguSawUD,  SPUD[0].position, SPUD[0].rotation);
                S.transform.SetParent(GameManager.GM.CurrentBoss.transform);
                GameObject S2 = Instantiate(SeguSawUD,  SPUD[2].position, SPUD[2].rotation);
                S2.transform.SetParent(GameManager.GM.CurrentBoss.transform);
                GameObject S3 = Instantiate(SeguSawRL,  SPRL[1].position, SPRL[1].rotation);
                S3.transform.SetParent(GameManager.GM.CurrentBoss.transform);
            }
            else if(pNum == 1){
                GameObject W = Instantiate(Warning,  SPUD[1].position, SPUD[1].rotation);
                W.transform.SetParent(GameManager.GM.CurrentBoss.transform);
                Wlist.Add(W);
                W.transform.localScale = new Vector2(SeguSawUD.GetComponent<Enemy>().boxSize.x, 50f);

                GameObject W2 = Instantiate(Warning,  SPDU[2].position, SPDU[2].rotation);
                W2.transform.SetParent(GameManager.GM.CurrentBoss.transform);
                Wlist.Add(W2);
                W2.transform.localScale = new Vector2(SeguSawUD.GetComponent<Enemy>().boxSize.x, 50f);

                GameObject W3 = Instantiate(Warning,  SPRL[1].position, SPRL[1].rotation);
                W3.transform.SetParent(GameManager.GM.CurrentBoss.transform);
                Wlist.Add(W3);
                W3.transform.localScale = new Vector2( 100f, SeguSawRL.GetComponent<Enemy>().boxSize.y);

                yield return new WaitForSeconds(1f);
                transform.GetComponent<Animator>().SetBool("SeguAttack", true);
                foreach(GameObject w in Wlist){
                    Destroy(w);
                }

                GameObject S = Instantiate(SeguSawUD,  SPUD[1].position, SPUD[1].rotation);
                S.transform.SetParent(GameManager.GM.CurrentBoss.transform);
                GameObject S2 = Instantiate(SeguSawDU,  SPDU[2].position, SPDU[2].rotation);
                S2.transform.SetParent(GameManager.GM.CurrentBoss.transform);
                GameObject S3 = Instantiate(SeguSawRL,  SPRL[1].position, SPRL[1].rotation);
                S3.transform.SetParent(GameManager.GM.CurrentBoss.transform);
            }

            else if(pNum == 2){
                GameObject W = Instantiate(Warning,  SPUD[2].position, SPUD[2].rotation);
                W.transform.SetParent(GameManager.GM.CurrentBoss.transform);
                Wlist.Add(W);
                W.transform.localScale = new Vector2(SeguSawUD.GetComponent<Enemy>().boxSize.x, 50f);

                GameObject W2 = Instantiate(Warning,  SPDU[0].position, SPDU[0].rotation);
                W2.transform.SetParent(GameManager.GM.CurrentBoss.transform);
                Wlist.Add(W2);
                W2.transform.localScale = new Vector2(SeguSawUD.GetComponent<Enemy>().boxSize.x, 50f);

                GameObject W3 = Instantiate(Warning,  SPRL[0].position, SPRL[0].rotation);
                W3.transform.SetParent(GameManager.GM.CurrentBoss.transform);
                Wlist.Add(W3);
                W3.transform.localScale = new Vector2( 100f, SeguSawRL.GetComponent<Enemy>().boxSize.y);

                yield return new WaitForSeconds(1f);
                transform.GetComponent<Animator>().SetBool("SeguAttack", true);
                foreach(GameObject w in Wlist){
                    Destroy(w);
                }

                GameObject S = Instantiate(SeguSawUD,  SPUD[2].position, SPUD[2].rotation);
                S.transform.SetParent(GameManager.GM.CurrentBoss.transform);
                GameObject S2 = Instantiate(SeguSawDU,  SPDU[0].position, SPDU[0].rotation);
                S2.transform.SetParent(GameManager.GM.CurrentBoss.transform);
                GameObject S3 = Instantiate(SeguSawRL,  SPRL[0].position, SPRL[0].rotation);
                S3.transform.SetParent(GameManager.GM.CurrentBoss.transform);
            }
        }

    }
// jing
[Header("징봇 =======================================================================")]   
    public GameObject JingBotBullet;
    public Transform[] JingBotBulletPositions;

    public IEnumerator JingBotSummonBullet(){
        if(!Onpattern){
            List<GameObject> Wlist = new List<GameObject>();
            Onpattern = true;
            foreach(Transform pos in JingBotBulletPositions){
                GameObject W = Instantiate(Warning, pos.position, pos.rotation);
                W.transform.SetParent(GameManager.GM.CurrentBoss.transform);
                Wlist.Add(W);
                W.transform.localScale = new Vector2(JingBotBullet.GetComponent<Bullet>().radius*2, 50f);
            }

            yield return new WaitForSeconds(1f);
            transform.GetComponent<Animator>().SetBool("JingAttack", true);
            foreach(GameObject w in Wlist){
                Destroy(w);
            }

            foreach(Transform pos in JingBotBulletPositions){
                Instantiate(JingBotBullet, pos.position, pos.rotation);
            }  

        }
    }
// ruru
[Header("르르봇 =======================================================================")]   
    public GameObject RuruBotBullet;
    public GameObject RuruBotShootFX;

    public IEnumerator RuruBotSummonBullet(){
        if(!Onpattern){
            transform.GetComponent<Animator>().SetBool("RuruAttack", true);
            for(int i = 0 ; i< 3; i++){
                Instantiate(RuruBotShootFX, FirePosition.position, FirePosition.rotation);
                Instantiate(RuruBotBullet, FirePosition.position, FirePosition.rotation);
                yield return new WaitForSeconds(.5f);
            }
            
        }

    }
// For all
[Header("공통 =======================================================================")]   
    public Transform FirePosition;
    public GameObject Warning;
    public GameObject CircularWarning;
    public bool Onpattern = false;

    public GameObject DiedBot;
    public Transform DiedPos;
    public GameObject DiedBotFX;
    public GameObject GangSangFX;

    public void Bot_Died_GangSang(){
        Instantiate(DiedBotFX, transform.position, transform.rotation);
        Instantiate(GangSangFX, DiedPos.position, DiedPos.rotation);
        GameObject D = Instantiate(DiedBot, DiedPos.position, DiedPos.rotation);
        D.transform.SetParent(GameManager.GM.CurrentBoss.transform);
    } 


    public void MainBot_LaserShoot(){
        if(!Onpattern){
            Debug.Log("Pattern Start.");
            Onpattern = true;
            transform.GetComponent<Animator>().SetBool("LaserShoot", true);
        }
    }
    public void MainBot_RipleShoot(){
        if(!Onpattern){
            Debug.Log("Pattern Start.");
            Onpattern = true;
            transform.GetComponent<Animator>().SetBool("RipleShoot", true);
        }
    }

    public void MainBot_Summon(){
        if(!Onpattern){
            Debug.Log("Pattern Start.");
            Onpattern = true;
            transform.GetComponent<Animator>().SetBool("Summon", true);
        }
    }

    public IEnumerator MainBot_Summon_Summon(){
        
        int rand = Random.Range(0, randomMobs.Length-1);
        Instantiate(SummonFX, SummonPosition.position, SummonPosition.rotation);
        GameObject FX = Instantiate(SummoningFX,SummonPosition.position, SummonPosition.rotation);
        FX.transform.SetParent(GameManager.GM.CurrentBoss.transform);
        GameObject M = Instantiate(randomMobs[rand], SummonPosition.position, SummonPosition.rotation);
        M.transform.SetParent(GameManager.GM.CurrentBoss.transform);

        yield return new WaitForSeconds(1f);
        Destroy(FX);
    }

    public IEnumerator MainBot_LaserShoot_Warning(){
        List<GameObject> Wlist = new List<GameObject>();
        for(int i = 0; i<4; i++){
            GameObject W = Instantiate(Warning, LaserShootPosition[i].transform.position, LaserShootPosition[i].transform.rotation);
            W.transform.localScale = new Vector2(20f, .5f);
            Wlist.Add(W);
            W.transform.SetParent(GameManager.GM.CurrentBoss.transform);
        }

        yield return new WaitForSeconds(1f);
        foreach(GameObject Ws in Wlist){
            Destroy(Ws);
        }
    }

    public IEnumerator MainBot_LaserShoot_Shoot(){
        Instantiate(LaserShootFX, LaserShooterPostion.position, LaserShootFX.transform.rotation);
        List<GameObject> Llist = new List<GameObject>();
        for(int i = 0; i<4; i++){
            GameObject L = Instantiate(DLaser, LaserShootPosition[i].transform.position, LaserShootPosition[i].transform.rotation);
            L.transform.SetParent(GameManager.GM.CurrentBoss.transform);
            Llist.Add(L);
        }

        yield return new WaitForSeconds(1f);
        foreach(GameObject Ls in Llist){
            Destroy(Ls);
        }
    }

    public IEnumerator MainBot_RipleShoot_Shoot(int count){
        float weightangle = Random.Range(0,15);
        float intervalangle = 360/count;

        Instantiate(RipleShootFX, RipleShootPosition.position, RipleShootPosition.rotation);
        for(int i = 0; i<count; i++){
            GameObject b = Instantiate(DhamBullet, RipleShootPosition.position, RipleShootPosition.rotation);
            float angle = weightangle + intervalangle * i;
            float x = Mathf.Cos(angle * Mathf.PI/180f);
            float y = Mathf.Sin(angle * Mathf.PI/180f);
            b.GetComponent<Bullet>().GetVector2(new Vector2(x,y));
            yield return new WaitForSeconds(0.1f);
        }
    }



    public IEnumerator SpinRadUp(){
        for(int i = 0; i<20; i++){
            transform.GetComponent<DhamBossBody>().radius += i * .01f;
            yield return new WaitForSeconds(.01f);
        }
    }

    public IEnumerator SpinRadDown(){
        for(int i = 0; i<20; i++){
            transform.GetComponent<DhamBossBody>().radius -= i * 0.01f;
            yield return new WaitForSeconds(.01f);
        }
    }

    public IEnumerator DhamBossMove(float duration){
        
        if(!Onpattern){
            Debug.Log("Moving!!");
            //Onpattern = true;
            Transform Destination = DhamPositions[Random.Range(0,DhamPositions.Length)];
            if(!(transform.position == Destination.position)){
                while(Vector2.Distance(transform.position,Destination.position) > 0){
                    transform.position = Vector3.MoveTowards(transform.position, Destination.position, 5f * Time.deltaTime);
                    yield return null;
                }
            }
            yield return null;
            //Onpattern = false;
        }
    }
    public void PatternEnd(string endlabel)
    {
        transform.GetComponent<Animator>().SetBool(endlabel, false);
        Debug.Log("Pattern End.");
        Onpattern = false;
    }
    public void AnimEnd(string endlabel)
    {
        transform.GetComponent<Animator>().SetBool(endlabel, false);
    }

    private void OnDrawGizmos() {
        Gizmos.color = Color.red;
        Gizmos.DrawWireSphere(transform.position,Range);
    }
}
