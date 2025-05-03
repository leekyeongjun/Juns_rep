using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class UserInterFace : MonoBehaviour
{
    public static UserInterFace ui;
    public GameObject LoadingPanel;

    public Image dialogArea;
    public Image NameArea;
    public GameObject Portrait;
    public Text dialogText;
    public Text nameText;

    public GameObject TalkArea;

    public GameObject BossClearPanel;

    public GameObject PauseScreen;
    public GameObject GameOverScreen;


    public GameObject UnlockedWeaponPanel;
    public GameObject UnlockedWeaponport;
    public Text UnlockedWeaponText;

    public GameObject SkillBar;
    public GameObject HPBar;

    public GameObject BossArea;
    public GameObject Inventory;
    public GameObject SkillIcon;

    public GameObject LifeStat;

    public GameObject BossIncounterPanel;

    public GameObject StageStartPanel;
    public Text StageName;
    public Text ISDName;

    public int dialogIndex = 0;
    public int NPCID = 0;

    public bool isTalking = false;

    void Awake(){
        DontDestroyOnLoad(gameObject);
        ui = this;
    }
   
    void Start()
    {
    }

    void Update()
    {
        if(!GameManager.GM.OnGame) {
            TalkArea.SetActive(false);
            BossClearPanel.SetActive(false);
            PauseScreen.SetActive(false);
            GameOverScreen.SetActive(false);
            UnlockedWeaponPanel.SetActive(false);
            SkillIcon.SetActive(false);
            SkillBar.SetActive(false);
            HPBar.SetActive(false);
            BossArea.SetActive(false);
            Inventory.SetActive(false);
            LifeStat.SetActive(false);
        }

        if(Player.player == null){
            
            HPBar.SetActive(false);
            SkillBar.SetActive(false);
            
            LifeStat.SetActive(false);
            SkillIcon.SetActive(false);
        }
        else{
            if(!GameManager.GM.HardMode) HPBar.SetActive(true);
            SkillBar.SetActive(true);
            LifeStat.SetActive(true);
            SkillIcon.SetActive(true);
        }

        if(isTalking){
            if(Input.GetKeyDown(KeyCode.Space)){
                FXManager.fx.PlayClickSound();
                Talk();
            }
        }
        else{
            GameManager.RestartTime();
            TalkArea.SetActive(false);
            dialogIndex = 0;
        }
        
    }

    public void Talk(){

        isTalking = true;
        GameManager.GM.Pause_able = false;
        Player.player.movement2D.Stop();
        Player.player.movement2D.canMove = false;

        GameManager.StopTime();
        TalkArea.SetActive(true);
        BossArea.SetActive(false);

        TalkManager.talkmanager.GetNPCData(NPCID);
        Portrait.GetComponent<Image>().sprite = TalkManager.talkmanager.npcPort;
        dialogText.text = TalkManager.talkmanager.GetDialog(dialogIndex);
        nameText.text = TalkManager.talkmanager.npcName;

        if(TalkManager.talkmanager.GetDialog(dialogIndex) == null){
            isTalking = false;
            GameManager.GM.Pause_able = true;
            Invoke("EndTalk", 0.5f);
            GameManager.RestartTime();
            TalkArea.SetActive(false);
            BossArea.SetActive(true);
        }
        dialogIndex++;
    }

    public void SetNPCID(int id){
        NPCID = id;
    }

    void EndTalk(){
        Player.player.movement2D.canMove = true;
    }


    public void OpenInventoryTab(){
        GameManager.StopTime();
        Inventory.SetActive(true);
        Player.player.movement2D.Stop();
        Player.player.canControl = false;
    }

    public void CloseInventoryTab(){
        GameManager.RestartTime();
        Inventory.SetActive(false);
        Player.player.canControl = true;
        Player.player.movement2D.canMove = true;
    }

    public void OpenPauseTab(){
        GameManager.StopTime();
        PauseScreen.SetActive(true);
        Player.player.movement2D.Stop();
        Player.player.canControl = false;
    }

    public void ClosePauseTab(){
        GameManager.RestartTime();
        PauseScreen.SetActive(false);
        Player.player.canControl = true;
        Player.player.movement2D.canMove = true;
    }

    public void OpenGameOverTab(){
        BGMManager.bgmManager.StopBGMDirectly();
        FXManager.fx.PlayGameOverSound();
        GameManager.StopTime();
        GameOverScreen.SetActive(true);
        Player.player.movement2D.Stop();
        Player.player.canControl = false;
    }

    public void CloseGameOverTab(){
        GameManager.RestartTime();
        GameOverScreen.SetActive(false);
        if(Player.player != null){
            Player.player.canControl = true;
            Player.player.movement2D.canMove = true;
        }
    }

    public void OpenLoadingPanel(){
        //Debug.Log("로딩패널 켜짐");
        LoadingPanel.SetActive(true);
    }

    public IEnumerator CloseLoadingPanel(){
        LoadingPanel.GetComponent<Animator>().SetTrigger("CloseLoading");
        yield return new WaitForSeconds(.5f);
    }

    public IEnumerator OpenWeaponUnlockedTab(int id){
        if(GameManager.GM.UnlockedWeapon[id] == false){
            FXManager.fx.PlayWeaponUnlockSound();
            UnlockedWeaponPanel.SetActive(true);
            UnlockedWeaponport.GetComponent<Image>().sprite = GameManager.GM.WeaponData[id].GetComponent<SkillPortrait>().port;
            UnlockedWeaponText.text = GameManager.GM.WeaponData[id].GetComponent<SkillPortrait>().SkillName;
            Player.player.movement2D.Stop();
            Player.player.canControl = false;
            GameManager.GM.UnlockedWeapon[id] = true;
            yield return new WaitForSeconds(3f);
            DiffuseUnlockedTab();
            yield return new WaitForSeconds(1f);
            CloseWeaponUnlockedTab();
        }
        GameManager.GM.ResetPlayer();
        GameManager.GM.LoadtoScene("StageSelectScene");

    }

    public void DiffuseUnlockedTab(){
        UnlockedWeaponPanel.GetComponent<Animator>().SetTrigger("IsDisable");
    }

    public void CloseWeaponUnlockedTab(){
        GameManager.RestartTime();
        UnlockedWeaponPanel.SetActive(false);
        Player.player.canControl = true;
        Player.player.movement2D.canMove = true;
    }

    public IEnumerator OpenBossClearPanel(int mob_id){
        yield return new WaitForSeconds(4f);
        FXManager.fx.PlayClearSound();
        BossClearPanel.SetActive(true);
        yield return new WaitForSeconds(2f);
        BossClearPanel.GetComponent<Animator>().SetTrigger("BossPanelDisable");
        yield return new WaitForSeconds(1f);
        BossClearPanel.SetActive(false);
        yield return new WaitForSeconds(1f);
        StartCoroutine(OpenWeaponUnlockedTab(mob_id));
    }
}
