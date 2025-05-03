using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


[System.Serializable]

public class Dialog{
    public int CutSceneID;
    public int CharacterID;
    [Multiline]
    public string DialogText;
}

public class CutSceneManager : MonoBehaviour
{
    public int counter = 0;
    public string Destination = "CharacterSelectionScene";
    
    public GameObject DialogWithoutCharacter;
    public GameObject DialogWithCharacter;
    public Image CutScene;
    public List<Sprite> CutSceneImages;
    public List<Sprite> CharacterImages;
    
    public Dialog[] D;

    public bool CutSceneEnded = false;

    private void Start() {
        SoundManager.SM.SoundOn();
    }
    
    public void SetCutScene(Dialog d){
        CutScene.sprite = CutSceneImages[d.CutSceneID];

        if(d.CharacterID == -1){ // withoutCharacter
            DialogWithCharacter.SetActive(false);
            DialogWithoutCharacter.SetActive(true);

            DialogWithoutCharacter.GetComponent<DialogWithCharacter>().dialog.text = d.DialogText;
        }

        else{
            DialogWithCharacter.SetActive(true);
            DialogWithoutCharacter.SetActive(false);

            DialogWithCharacter.GetComponent<DialogWithCharacter>().TalkerPort.sprite = CharacterImages[d.CharacterID];
            DialogWithCharacter.GetComponent<DialogWithCharacter>().dialog.text = d.DialogText;
        }
    }

    public void Update(){
        if(counter < D.Length){
            SetCutScene(D[counter]);
        }
        else{
            if(CutSceneEnded == false){
                Debug.Log("CutSceneEnd!!");
                CutSceneEnded = true;
                SceneEndandLoad();
            }
        }
        if(Input.GetKeyDown(KeyCode.Space)){
            FXManager.fx.PlayClickSound();
            counter++;
        }

    }

    public void SceneEndandLoad(){
        GameManager.GM.LoadtoScene(Destination);
    }

}
