using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BossSpawner : MonoBehaviour
{

    public GameObject Boss;
    public GameObject HardBoss;
    public GameObject BossDieFx;
    


    public Transform SpawnPosition;

    public IEnumerator BossSpawnCutScene(){
        
        Player.player.canControl = false;
        GameManager.GM.Pause_able = false;
        CameraController.cam.ShakeOn();
        FXManager.fx.PlayBossSiren();
        Player.player.GetComponent<Movement2D>().Stop();
        yield return new WaitForSeconds(0.5f);
        UserInterFace.ui.BossIncounterPanel.SetActive(true);
        yield return new WaitForSeconds(4f);
        CameraController.cam.ShakeOff();
        UserInterFace.ui.BossIncounterPanel.GetComponent<Animator>().SetBool("IsDissapear", true);
        yield return new WaitForSeconds(1.2f);
        UserInterFace.ui.BossIncounterPanel.SetActive(false);

        StartCoroutine(BGMManager.bgmManager.StartBGM());
        GameObject b;
        if(GameManager.GM.HardMode){
            b = Instantiate(HardBoss, SpawnPosition.position, SpawnPosition.rotation);
        }
        else{
            b = Instantiate(Boss, SpawnPosition.position, SpawnPosition.rotation);
        }
        
        b.GetComponent<Animator>().SetBool("BossAppear", true);
        GameManager.GM.CurrentBoss = b;
        yield return new WaitForSeconds(1f);
        UserInterFace.ui.BossArea.SetActive(true);
        b.GetComponent<Animator>().SetBool("BossAppear", false);
        b.GetComponent<Animator>().enabled = false;

        SetBossBB(b);
        UserInterFace.ui.SetNPCID(b.GetComponent<Mob_identification>().mob_id);
        UserInterFace.ui.Talk();

        
        Player.player.canControl = true;
        yield return null;
    }

    

    public void SetBossBB(GameObject b){
        if(b.GetComponent<BattleBehaviour>()) BossHealthBar.bosshpbar.GetBossBB(b.GetComponent<BattleBehaviour>());
        else BossHealthBar.bosshpbar.GetBossBB(b.GetComponent<Mob_identification>().battleBehavior);
    }

    private void OnDrawGizmos() {
        Gizmos.DrawWireCube(SpawnPosition.position, Boss.GetComponent<Mob_identification>().size);
    }

}
