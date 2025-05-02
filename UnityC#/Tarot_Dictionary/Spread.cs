using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class Spread : MonoBehaviour
{
    public GameObject CardSelectPanel;
    public GameObject CardScrollViewContent;
    public GameObject cardButtonPrefab;
    public List<SelectedCard> selectedCards;
    int targetid;
    public List<GameObject> Offsets;

    public GameObject TypeSelectionPanel;
    
    void Start(){
        SetCardList();
        CardSelectPanel.SetActive(false);
        TypeSelectionPanel.SetActive(true);
    }


    void SetCardList(){
        foreach(CardInfo info in CardManager.CM.cardInfos){
            GameObject t = Instantiate(cardButtonPrefab, CardScrollViewContent.transform);
            t.GetComponent<CardButton>().SetCardInfo(info);
        }
    }

    public void CardInfoRenewal(CardInfo info){
        CardSelectPanel.SetActive(false);
        selectedCards[targetid].SetCardInfo(info);
    }

    public void SetOffset(int id){
        foreach(GameObject offset in Offsets){
            offset.SetActive(false);
        }
        Offsets[id].SetActive(true);
        selectedCards = Offsets[id].GetComponent<SpreadOffset>().CardLists;
        TypeSelectionPanel.SetActive(false);
    }

    public void OpenCardList(){
        CardSelectPanel.SetActive(true);
    }

    public void SetSelectedCardId(int id){
        targetid = id;
    }
}
