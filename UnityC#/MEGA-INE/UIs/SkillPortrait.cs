using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class SkillPortrait : MonoBehaviour
{
    public int Id;
    public GameObject Lock;
    public string SkillName;
    public Sprite port;

    public bool Locked = true;

    
    public void ChangeWeapon(){
        if(!Locked){
            Player.player.playerAttack.SkillId = Id;
            GameManager.GM.EquippedWeaponID = Id;
            Debug.Log("Weapon Changed, cur SkillId is " + Player.player.playerAttack.SkillId.ToString());
            Debug.Log("Weapon Changed, Equipped SkillId is " + GameManager.GM.EquippedWeaponID.ToString());
        }
    }

    public void UnlockWeapon(){
        Lock.SetActive(false);
        Locked = false;
    }

}
