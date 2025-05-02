using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

[SerializeField]
public class Badge : MonoBehaviour
{

    public int Bid;
    public Image BadgeImage;
    public string BadgeExplain;


    public void SetBadgeImage(int id){
        Bid = id;
        BadgeImage.sprite = DBManager.db.Badges[id].BadgeSprite;
        BadgeExplain = DBManager.db.Badges[id].BadgeExplain; 
    }
}
