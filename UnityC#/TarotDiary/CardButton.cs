using System.Collections;
using System.Collections.Generic;
using UnityEngine.UI;
using UnityEngine;

public class CardButton : MonoBehaviour
{
    SingleCardDiary singleCardDiary;

    public CardInfo cardinfo;
    public Image cardimage;

    void Start(){
        singleCardDiary = GameObject.FindWithTag("SingleCardDiary").GetComponent<SingleCardDiary>();
    }
    public void SetCardInfo(CardInfo info){
        cardinfo = info;
        cardimage.sprite = info.Image;
    }

    public void SelectCard(){
        singleCardDiary.CardInfoRenewal(cardinfo);
    }

}
