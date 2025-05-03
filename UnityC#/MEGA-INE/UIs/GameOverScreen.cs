using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameOverScreen : MonoBehaviour
{
    public bool GameOverAnimationEnded = false;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        GameOverActs();
    }

    void OnEnable(){
        StartCoroutine(WaitTillAnimation());
    }


    public void GameOverActs(){
        if(GameOverAnimationEnded == false) return;
        if(Input.GetKeyDown(KeyCode.Space)){
            UserInterFace.ui.CloseGameOverTab();
            GameManager.GM.ResetPlayer();
            GameManager.GM.ResetMaxlife();
            GameManager.GM.LoadtoScene("StageSelectScene");
        }
    }

    public IEnumerator WaitTillAnimation(){
        yield return new WaitForSeconds(1f);
        GameOverAnimationEnded = true;
    }
}
