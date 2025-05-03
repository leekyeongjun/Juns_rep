using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class CharacterSelection : MonoBehaviour
{
    public bool CursorMovable = true;

    public GameObject[] Characters;
    public RuntimeAnimatorController[] CharacterAnims;
    [Multiline]
    public string[] AbilityTexts;


    public GameObject Cursor;
    private int c_s = 0;
    private int c_g = 0;
    int[,] CharacterId = new int[3,2]{{0,1},{2,3},{4,5}};

    public Text OnCursorName;
    public Text OnCursorWeapon;
    public Text OnCursorWeaponAbility;

    public GameObject OnCursorCharacter;
    private void Start() {
        SoundManager.SM.SoundOn();
    }
    void Update()
    {
        if(CursorMovable) CursorMove();

        if(Input.GetKeyDown(KeyCode.Space)){
            FXManager.fx.PlaySelectSound();
            StartCoroutine(SetCharacter());
        }
    }
    private void FixedUpdate() {
        ScreenUpdate();
    }
    public void CursorMove(){
        if(Input.GetKeyDown(KeyCode.UpArrow)){
            FXManager.fx.PlayClickSound();
            c_g -= 1;
            if(c_g < 0) c_g = 2;
        }

        else if(Input.GetKeyDown(KeyCode.DownArrow)){
            FXManager.fx.PlayClickSound();
            c_g += 1;
            if(c_g > 2) c_g = 0;
        }

        else if(Input.GetKeyDown(KeyCode.LeftArrow)){
            FXManager.fx.PlayClickSound();
            c_s -= 1;
            if(c_s < 0) c_s = 1;
        }

        else if(Input.GetKeyDown(KeyCode.RightArrow)){
            FXManager.fx.PlayClickSound();
            c_s += 1;
            if(c_s > 1) c_s = 0;
        }
        Cursor.transform.position = Characters[CharacterId[c_g,c_s]].transform.position;
        Cursor.transform.localScale = Characters[CharacterId[c_g,c_s]].transform.localScale;
    }

    public void ScreenUpdate(){
        OnCursorName.text = GameManager.GM.Characters[CharacterId[c_g,c_s]].name;
        OnCursorWeapon.text = GameManager.GM.WeaponData[CharacterId[c_g,c_s]].name;
        OnCursorWeaponAbility.text = AbilityTexts[CharacterId[c_g,c_s]].ToString();

        OnCursorCharacter.GetComponent<Animator>().runtimeAnimatorController = CharacterAnims[CharacterId[c_g,c_s]];
    }
    public IEnumerator SetCharacter(){
        GameManager.GM.SetPlayer(CharacterId[c_g,c_s]);

        CursorMovable = false;
        Cursor.GetComponent<Animator>().SetTrigger("Selected");
        yield return new WaitForSeconds(1f);
        GameManager.GM.LoadtoScene("TutorialScene");
    }
}
