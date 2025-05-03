using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class DifficultySelection : MonoBehaviour
{
    public GameObject Cursor;
    public GameObject[] MenuAnchors;
    int[] TitleThingsID = new int[1];

    private int c_id = 0;

    public Text DifText;
    public Text DifText2;
    public GameObject DifficultySelectPanel;
    public GameObject Titlemenu;
    private bool Controllable = true;
    [Multiline]
    public string EasyText;
    [Multiline]
    public string EasyTextDetailed;
    [Multiline]
    public string HardText;
    [Multiline]
    public string HardTextDetailed;



    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        CursorMove();
        DifActs();
        DifTextChanger();
    }

    public void CursorMove(){
        
        if(Input.GetKeyDown(KeyCode.UpArrow)){
            FXManager.fx.PlayClickSound();
            c_id -= 1;
            if(c_id < 0) c_id = 1;
        }
        else if(Input.GetKeyDown(KeyCode.DownArrow)){
            FXManager.fx.PlayClickSound();
            c_id += 1;
            if(c_id > 1) c_id = 0;
            
        }
        Cursor.transform.position = MenuAnchors[c_id].transform.position;
    }

    public void DifActs(){
        if(Input.GetKeyDown(KeyCode.Space)){
            if(Controllable){
                FXManager.fx.PlaySelectSound();
                if(c_id == 0){ 
                    Controllable = false;
                    GameManager.GM.MainCharacter_HP = 10;
                    GameManager.GM.LoadtoScene("CutScene");
                }
                else if(c_id == 1){
                    Controllable = false;
                    GameManager.GM.MainCharacter_HP = 1;
                    GameManager.GM.HardMode = true;
                    GameManager.GM.LoadtoScene("CutScene");
                }
            }

        }
        if(Input.GetKeyDown(KeyCode.Escape)){
            Titlemenu.SetActive(true);
            DifficultySelectPanel.SetActive(false);
        }
    }

    public void DifTextChanger(){
        if(c_id == 0){
            DifText.text = EasyText;
            DifText2.text = EasyTextDetailed;
        }
        else if(c_id == 1){
            DifText.text = HardText;
            DifText2.text = HardTextDetailed;
        }
    }
}
