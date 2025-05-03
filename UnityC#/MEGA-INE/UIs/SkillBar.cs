using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class SkillBar : MonoBehaviour
{

    public Image[] Skillpellets;
    public Sprite Skillps;
    public Sprite emptySkillps;
    // Start is called before the first frame update

    void Awake(){
    }
    // Update is called once per frame
    void Update()
    {
        if(!(Player.player == null)){
            for(int i = 0; i<Skillpellets.Length; i++){
                if(i<Player.player.playerAttack.curSkillCount){
                    Skillpellets[i].sprite = Skillps;
                }
                else{
                    Skillpellets[i].sprite = emptySkillps;
                }

                if(i<Player.player.playerAttack.SkillCount){
                    Skillpellets[i].enabled = true;
                }
                else {
                    Skillpellets[i].enabled = false;
                }
            }
        }

    }
}
