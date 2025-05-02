using System.Collections;
using System.Collections.Generic;
using UnityEngine.UI;
using UnityEngine;
using TMPro;

public class CardButton : MonoBehaviour
{
    
    SingleCardDiary singleCardDiary;
    Spread spread;
    public CardInfo cardinfo;
    public Image cardimage;

    void Start(){
        if(GameObject.FindWithTag("SingleCardDiary")) {
            singleCardDiary = GameObject.FindWithTag("SingleCardDiary").GetComponent<SingleCardDiary>();
            Debug.Log("SCD found");   
        }
        if(GameObject.FindWithTag("Spread")){
            spread =  GameObject.FindWithTag("Spread").GetComponent<Spread>();
            Debug.Log(spread);
        } 
    }
    public void SetCardInfo(CardInfo info){
        cardinfo = info;
        cardimage.sprite = info.Image;
    }
    public void SelectCard(){
        singleCardDiary.CardInfoRenewal(cardinfo);
    }

    public void SelectCardforSpread(){
        spread.CardInfoRenewal(cardinfo);
    }
    public void OpenCardList(int id){
        if(GameObject.FindWithTag("Spread")){
            spread =  GameObject.FindWithTag("Spread").GetComponent<Spread>();
            Debug.Log(spread);
        } 
        if(spread){
            spread.OpenCardList();
            spread.SetSelectedCardId(id); 
        }

    }
}
