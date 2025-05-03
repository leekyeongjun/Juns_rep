using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class BossHealthBar : MonoBehaviour
{
    public static BossHealthBar bosshpbar;
    public BossSpawner bossspawner;
    public BattleBehaviour battleBehavior;
    public Slider Hpbar;
    public Text BossNameText;
    public Image BossPortrait;

    // Start is called before the first frame update

    void Awake(){
        bosshpbar = this;
    }

    void Start(){

    }
    
    // Update is called once per frame
    void Update()
    {
        if(battleBehavior){
            Hpbar.value = (float)battleBehavior.curHP/(float)battleBehavior.HP;
        }
        
        

    }

    public void GetBossBB(BattleBehaviour b){
        battleBehavior = b;
        BossNameText.text = GameManager.GM.CurrentBossTrigger.BossName;
        BossPortrait.sprite = GameManager.GM.CurrentBossTrigger.BossPort;
    }
}
