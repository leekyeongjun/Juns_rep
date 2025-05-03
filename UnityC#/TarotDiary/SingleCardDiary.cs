using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class SingleCardDiary : MonoBehaviour
{
    public GameObject CardSelectPanel;
    public GameObject CardScrollViewContent;
    public GameObject cardButtonPrefab;
    public Image SelectedCard;
    public TextMeshProUGUI KeywordText;
    void Start(){
        SetCardList();
        CardSelectPanel.SetActive(false);
    }

    void SetCardList(){
        foreach(CardInfo info in CardManager.CM.cardInfos){
            GameObject t = Instantiate(cardButtonPrefab, CardScrollViewContent.transform);
            t.GetComponent<CardButton>().SetCardInfo(info);
        }
    }

    public void CardInfoRenewal(CardInfo info){
        SelectedCard.sprite = info.Image;
        string keywords = "";
        foreach(string keyword in info.Keyword){
            keywords += keyword + " ";
        }
        KeywordText.text = keywords;
        CardSelectPanel.SetActive(false);
    }

    public void OpenCardList(){
        CardSelectPanel.SetActive(true);
    }

}
