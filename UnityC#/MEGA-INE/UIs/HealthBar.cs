using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class HealthBar : MonoBehaviour
{

    public Image[] hearts;
    public Sprite fullheartsbody;
    public Sprite fullheartHead;
    public Sprite fullheartTail;
    public Sprite emptyhearts;
    // Start is called before the first frame update

    void Start(){
        
    }
    
    // Update is called once per frame
    void Update()
    {
        if(!(Player.player == null)){
            for(int i = 0; i<hearts.Length; i++){
                if(i<Player.player.battleBehavior.curHP){
                    if(i == 0) hearts[i].sprite = fullheartTail;
                    else if(i == hearts.Length-1) hearts[i].sprite = fullheartHead;
                    else hearts[i].sprite = fullheartsbody;
                }
                else{
                    hearts[i].sprite = emptyhearts;
                }
        
                if(i<Player.player.battleBehavior.HP){
                    hearts[i].enabled = true;
                }
                else {
                    hearts[i].enabled = false;
                }
            }
        }
    }
}
