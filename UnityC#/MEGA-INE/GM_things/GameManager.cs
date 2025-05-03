using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class GameManager : MonoBehaviour
{
    public static GameManager GM;

    public GameObject MainCharacter;

    public GameObject[] Characters;
    public GameObject CurPlayer;
    public StartPoint startpoint;

    public int MAXLIFE;
    public int curLife;

    public int CHP;
    public int CSP;

    
    public int DCount = 0;

    public int MainCharacter_HP;
    public bool[] UnlockedWeapon;
    public int EquippedWeaponID = 0;
    public GameObject[] WeaponData;

    public GameObject CurrentBoss;
    public BossSpawnTrigger CurrentBossTrigger;
    public bool[] ClearedBoss;

    public bool InventoryOn = false;
    public bool Pausing = false;
    public bool GameOver = false;
    public bool OnGame = false;
    public bool Pause_able = true;
    public bool HardMode = false;
    

    // Start is called before the first frame update
    void Awake()
    {
        if(GM == null){
            DontDestroyOnLoad(gameObject);
            GM = this;
        }
        else{
            Destroy(gameObject);
        }

        curLife = MAXLIFE;
    }


   

    void Update()
    {

        if(SceneManager.GetActiveScene().name == "StartScene" || SceneManager.GetActiveScene().name == "StageSelectScene" || SceneManager.GetActiveScene().name == "LoadingScene" ) OnGame = false;
        if(!OnGame) return;
        
        if(CurrentBoss == null) UserInterFace.ui.BossArea.SetActive(false);

        if(Input.GetKeyDown(KeyCode.E)){
            if(!GameOver){
                if(Pause_able){
                    if(UserInterFace.ui.PauseScreen.activeSelf == true){
                        UserInterFace.ui.ClosePauseTab();
                    }
                    
                    if(UserInterFace.ui.Inventory.activeSelf == false) {
                        FXManager.fx.PlaySelectSound();
                        UserInterFace.ui.OpenInventoryTab();
                    }
                    else {
                        FXManager.fx.PlayDenySound();
                        UserInterFace.ui.CloseInventoryTab();
                    }
                }
            }

        }
        if(Input.GetKeyDown(KeyCode.Escape)){
            if(!GameOver){
                if(Pause_able){
                    if(UserInterFace.ui.Inventory.activeSelf == true) {
                        FXManager.fx.PlayDenySound();
                        UserInterFace.ui.CloseInventoryTab();
                        return;
                    }
                    if(UserInterFace.ui.PauseScreen.activeSelf == false) {
                        FXManager.fx.PlaySelectSound();
                        Pausing = true;
                        UserInterFace.ui.OpenPauseTab();
                    }
                    else {
                        FXManager.fx.PlayDenySound();
                        Pausing = false;
                        UserInterFace.ui.ClosePauseTab();
                    }  
                }
            }
        }
    }

    public static IEnumerator SlowTime(float duration, float amount){
        float elapsed = 0.0f;
        while(elapsed < duration){
            Time.timeScale = amount;
            elapsed += Time.deltaTime;
            yield return null;
        }
        Time.timeScale = 1;
    }

    public static void StopTime(){
        Time.timeScale = 0;
    }

    public static void RestartTime(){
        Time.timeScale = 1;
    }

    public void TryUP(){
        curLife ++;
        DCount ++;
    }

    public void StageEnter(bool isFlying, bool isFixedDirection, bool chasingmc, float size, Vector2 mb, Vector2 Mb){
        ResetMaxlife();
        OnGame = true;
        GameOver = false;

        CameraController.cam.CamReset(chasingmc, size, mb, Mb);

        startpoint = GameObject.FindGameObjectWithTag("Startpoint").GetComponent<StartPoint>();

        if(GameObject.FindGameObjectWithTag("BossSpawnTrigger")) CurrentBossTrigger = GameObject.FindGameObjectWithTag("BossSpawnTrigger").GetComponent<BossSpawnTrigger>();

        CurPlayer = Instantiate(MainCharacter, startpoint.CheckPoints[startpoint.index].transform.position, startpoint.CheckPoints[startpoint.index].transform.rotation);

        Player.player.battleBehavior.HP = MainCharacter_HP;
        Player.player.battleBehavior.curHP = MainCharacter_HP;

        Player.player.playerAttack.SkillId = EquippedWeaponID;

        Player.player.IsFlying = isFlying;

        Player.player.DoFlipCheck = !isFixedDirection;
    }

    public void StageContinue(bool isFlying, bool isFixedDirection, bool chasingmc, float size, Vector2 mb, Vector2 Mb){
        OnGame = true;
        GameOver = false;
        CameraController.cam.CamReset(chasingmc, size, mb, Mb);

        startpoint = GameObject.FindGameObjectWithTag("Startpoint").GetComponent<StartPoint>();

        if(GameObject.FindGameObjectWithTag("BossSpawnTrigger")) CurrentBossTrigger = GameObject.FindGameObjectWithTag("BossSpawnTrigger").GetComponent<BossSpawnTrigger>();

        CurPlayer = Instantiate(MainCharacter, startpoint.CheckPoints[startpoint.index].transform.position, startpoint.CheckPoints[startpoint.index].transform.rotation);
        
        Player.player.battleBehavior.HP = MainCharacter_HP;
        Player.player.battleBehavior.curHP = CHP;
        Player.player.playerAttack.curSkillCount = CSP;


        Player.player.playerAttack.SkillId = EquippedWeaponID;

        Player.player.IsFlying = isFlying;

        Player.player.DoFlipCheck = !isFixedDirection;
    }

    public void ResetPlayer(){
        
        if(CurPlayer != null){
            SoundManager.SM.SoundOFF();
            CHP = Player.player.battleBehavior.curHP;
            CSP = Player.player.playerAttack.curSkillCount;
            Destroy(CurPlayer);
            CurPlayer = null;
            Debug.Log("Initiate Player to null");
        }
        if(startpoint != null){
            startpoint = null;
            Debug.Log("Initiate Startpoint to null");
        }
    }

    public void UnlockWeapon(int id){
        UserInterFace.ui.OpenWeaponUnlockedTab(id);
    }

    public void BossDieCutScene(){
        if(CurrentBoss != null){
            int mob_id = CurrentBoss.GetComponent<Mob_identification>().mob_id;
            ClearedBoss[mob_id] = true;
            CurrentBoss.GetComponent<Animator>().enabled = true;
            CurrentBoss.GetComponent<Animator>().SetBool("BossDissapear", true);
            Invoke("ResetBoss", 1f);
            StartCoroutine(UserInterFace.ui.OpenBossClearPanel(mob_id));
        }

    }

    public void ResetMaxlife(){
        GameOver = false;
        curLife = MAXLIFE;
    }

    public void ClearGame(){
        ResetPlayer();
        CameraController.cam.CamReset(false, 7f, new Vector2(0,0), new Vector2(0,0));
        LoadtoScene("ClearScene");
    }

    public void ResetBoss(){
        if(CurrentBoss != null){
            StartCoroutine(BGMManager.bgmManager.StopBGM());
            UserInterFace.ui.BossArea.GetComponent<Animator>().SetBool("BossAreaDisable", true);
            Destroy(CurrentBoss.gameObject);
            CurrentBoss = null;
        }
    }

    public void SetPlayer(int id){
        MainCharacter = Characters[id];
        UnlockedWeapon[id] = true;
        EquippedWeaponID = id;
    }
    
    public void LoadtoScene(string destination){
        StartCoroutine(Load(destination));
    }

    public void SceneMoveWithOutLoad(string destination){
        SceneManager.LoadScene(destination);
    }

    public IEnumerator Load(string destination){
        StartCoroutine(BGMManager.bgmManager.StopBGM());
        UserInterFace.ui.OpenLoadingPanel();
        yield return new WaitForSeconds(.5f);
        SoundManager.SM.SoundOFF();
        Loader.loader.SetNextScene(destination);
        SceneManager.LoadScene("LoadingScene");
    }



}