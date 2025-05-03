using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Inventory : MonoBehaviour
{

    public static Inventory inv;

    public GameObject Cursor;
    public GameObject Equipped;
    public GameObject[] Skills;

    public int EquippedId = 0;

    int[,] SkillId = new int[2,3]{{0,1,2},{3,4,5}};
    private int c_s = 0;
    private int c_g = 0;

    // Start is called before the first frame update
    void Awake()
    {
        if(inv != null){
            inv = this;
        }
    }
    private void OnEnable() {
        GetUnlockedData();
    }

    // Update is called once per frame
    void Update()
    {
        CursorMove();
        EquippedId = Player.player.playerAttack.SkillId;
        Equipped.transform.position = Skills[EquippedId].transform.position;

        if(Input.GetKeyDown(KeyCode.Space)){
            FXManager.fx.PlaySelectSound();
            Skills[SkillId[c_g,c_s]].GetComponent<SkillPortrait>().ChangeWeapon();
        }
    }

    public void CursorMove(){


        if(Input.GetKeyDown(KeyCode.UpArrow)){
            FXManager.fx.PlayClickSound();
            c_g -= 1;
            if(c_g < 0) c_g = 1;
            Cursor.transform.position = Skills[SkillId[c_g,c_s]].transform.position;
        }

        else if(Input.GetKeyDown(KeyCode.DownArrow)){
            FXManager.fx.PlayClickSound();
            c_g += 1;
            if(c_g > 1) c_g = 0;
            Cursor.transform.position = Skills[SkillId[c_g,c_s]].transform.position;
        }

        else if(Input.GetKeyDown(KeyCode.LeftArrow)){
            FXManager.fx.PlayClickSound();
            c_s -= 1;
            if(c_s < 0) c_s = 2;
            Cursor.transform.position = Skills[SkillId[c_g,c_s]].transform.position;
        }

        else if(Input.GetKeyDown(KeyCode.RightArrow)){
            FXManager.fx.PlayClickSound();
            c_s += 1;
            if(c_s > 2) c_s = 0;
            Cursor.transform.position = Skills[SkillId[c_g,c_s]].transform.position;
        }
    }

    public void GetUnlockedData(){
        for(int i = 0 ; i<6; i++){
            if(GameManager.GM.UnlockedWeapon[i] == true) Skills[i].GetComponent<SkillPortrait>().UnlockWeapon();
        }

    }
}
