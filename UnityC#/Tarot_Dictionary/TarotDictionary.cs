using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine.UI;
using UnityEngine;
using Unity.VisualScripting;
using System;

public class TarotDictionary : MonoBehaviour
{
    // Start is called before the first frame update
    public bool isDict = true;
    public GameObject Major_arcana_deck;
    public GameObject Sword_deck;
    public GameObject Wand_deck;
    public GameObject Tentacle_deck;
    public GameObject Cup_deck;

    public GameObject DetailPanel;
    public TextMeshProUGUI D_NameText;
    public Image D_image;

    public TextMeshProUGUI D_KeywordText;
    public TextMeshProUGUI D_DescriptionText; 
    public TextMeshProUGUI D_LoveText;
    public TextMeshProUGUI D_RelationshipText;
    public TextMeshProUGUI D_MoneyText;
    public TextMeshProUGUI D_WorkText;
    public TextMeshProUGUI D_ReMeetText;
    public TextMeshProUGUI D_PlaceText;
    public TextMeshProUGUI D_MoodText;
    public TextMeshProUGUI D_ContactText;
    public TextMeshProUGUI D_TravelText;
    public TextMeshProUGUI D_MoveJobText;
    public TextMeshProUGUI D_HealthText;
    public TextMeshProUGUI D_NumerlogyText;
    public TextMeshProUGUI D_ETCText;
    public TextMeshProUGUI D_AdviceText;
    public TextMeshProUGUI D_WarningText;

    public Scrollbar scrollbar;
    Dict_ContentManager dict_ContentManager;

    /*
    0~21 m
    22~35 cup
    36~49 tentacle
    50~63 sword
    64~77 wand
    */

    public GameObject CardBtnPrefab;
    void Start()
    {
        dict_ContentManager = GameObject.FindWithTag("Content").GetComponent<Dict_ContentManager>();
        DetailPanel.SetActive(false);
        if(isDict) SetDictionary();
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void SetDictionary(){
        foreach(CardInfo info in CardManager.CM.cardInfos){
            Transform P_t;
            if(info.Id >= 0 && info.Id < 22){
                P_t = Major_arcana_deck.transform; 
            }
            else if(info.Id >= 22 && info.Id < 36){
                P_t = Cup_deck.transform;
            }
            else if(info.Id >= 36 && info.Id < 50){
                P_t = Tentacle_deck.transform;
            }
            else if(info.Id >= 50 && info.Id < 64){
                P_t = Sword_deck.transform;
            }
            else if(info.Id >= 64 && info.Id < 78){
                P_t = Wand_deck.transform;
            }
            else{
                Debug.Log("Error!");
                break;
            }
            GameObject C_g = Instantiate(CardBtnPrefab, P_t);
            C_g.GetComponent<DictionaryCards>().SetCard(info);
        }
    }

    public void ShowCard(CardInfo info){
        D_image.sprite = info.Image;
        D_NameText.text = info.Name;
        SetText_MultipleKeyword(info.Keyword, D_KeywordText, " / ");
        D_DescriptionText.text = info.Description;
        SetText_MultipleKeyword(info.Love, D_LoveText, ". ");
        SetText_MultipleKeyword(info.Relationship, D_RelationshipText, ". ");
        SetText_MultipleKeyword(info.Money, D_MoneyText, ". ");
        SetText_MultipleKeyword(info.Work, D_WorkText, ". ");
        SetText_MultipleKeyword(info.ReMeet, D_ReMeetText, ". ");
        SetText_MultipleKeyword(info.Place, D_PlaceText, ". ");
        SetText_MultipleKeyword(info.Mood, D_MoodText, ". ");
        SetText_MultipleKeyword(info.Contact, D_ContactText, ". ");
        SetText_MultipleKeyword(info.Travel, D_TravelText, ". ");
        SetText_MultipleKeyword(info.MoveJob, D_MoveJobText, ". ");
        SetText_MultipleKeyword(info.Health, D_HealthText, ". ");
        SetText_Tuple(info.Etc, D_ETCText);
        SetText_MultipleKeyword(info.Advice, D_AdviceText, "\n");
        SetText_MultipleKeyword(info.Warning, D_WarningText, "\n");
        D_NumerlogyText.text = info.Numerlogy;


        DetailPanel.SetActive(true);
        dict_ContentManager.SetContentSize();
        scrollbar.value = 1f;
    }

    public void DetailPaneloff(){
        DetailPanel.SetActive(false);
    }

    public void SetText_MultipleKeyword(List<string> strings, TextMeshProUGUI target, string delimiter){
        string result = "";
        foreach(string str in strings){
            result += str+delimiter;
        }
        target.text = result;
    }

    public void SetText_Tuple(List<EtcData> tuples, TextMeshProUGUI target){
        string result = "";
        foreach(EtcData tuple in tuples){
            result += "<b><size=30>"+tuple.Title+"</size></b>" + "\n";
            result += tuple.Content + "\n\n";
        }
        target.text = result;
    }

    
}
