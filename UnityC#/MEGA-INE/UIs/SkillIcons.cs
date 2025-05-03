using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class SkillIcons : MonoBehaviour
{
    public static SkillIcons skillicons;

    public Image SkillIcon;
    public GameObject SkillCoolIcon;
    public GameObject ReadyText;

    private void Awake(){
        skillicons = this;
    }

    void FixedUpdate()
    {
        SkillIcon.sprite = GameManager.GM.WeaponData[GameManager.GM.EquippedWeaponID].GetComponent<SkillPortrait>().port;
    }

    void Update(){
        if(Player.player != null){
            if(Player.player.playerAttack.canSkill){
                SkillCoolIcon.SetActive(false);
            }
            else{
                SkillCoolIcon.SetActive(true);
            }
        }
    }

    public void ShowReadyText(){
        ReadyText.GetComponent<Animator>().SetTrigger("Ready");
    }
}
