using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class TodaysCard : MonoBehaviour
{
    // Start is called before the first frame update
    Image image;
    CardInfo info;

    public TarotDictionary tarotDictionary;


    void Start(){
        image = GetComponent<Image>();
    }

    public void SetRandomCard(){
        int id = Random.Range(0,78);
        info = CardManager.CM.cardInfos[id];
        image.sprite = info.Image;
        
    }

    public void ShowRandomCard(){
        if(info != null) tarotDictionary.ShowCard(info);
    }

}
