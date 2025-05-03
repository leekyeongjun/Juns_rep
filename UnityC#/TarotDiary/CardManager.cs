using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


public class CardInfoArray{
    public CardInfo[] Deck;
}
public class CardManager : MonoBehaviour
{
    public static CardManager CM;

    public List<CardInfo> cardInfos = new List<CardInfo>();

    private void Awake()
    {
        if (CM == null)
        {
            CM = this;
            DontDestroyOnLoad(gameObject);
        }
        else
        {
            Destroy(gameObject);
        }
        LoadCardInfos();
    }

    private void Start()
    {
        
    }

    private void LoadCardInfos()
    {
        TextAsset textAsset = Resources.Load<TextAsset>("TarotInfo");
        string jsonData = textAsset.text;

        CardInfoArray cardInfoArray = JsonUtility.FromJson<CardInfoArray>(jsonData);

        foreach (CardInfo cardInfo in cardInfoArray.Deck)
        {
            cardInfo.Image = Resources.Load<Sprite>("Deck/" + cardInfo.Id);
            cardInfos.Add(cardInfo);
        }
        Debug.Log("Load Complete");
    }
}