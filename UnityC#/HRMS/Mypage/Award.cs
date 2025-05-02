using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Award : MonoBehaviour
{
    public int Aid;
    public Image AwardImage;
    public string BadgeExplain;


    public void SetAwardImage(int id){
        Aid = id;
        if(DBManager.db.Awards[id].AwardSprite != null){
            AwardImage.sprite = DBManager.db.Awards[id].AwardSprite;
        }
        
        BadgeExplain = DBManager.db.Awards[id].AwardExplain; 
    }
}
