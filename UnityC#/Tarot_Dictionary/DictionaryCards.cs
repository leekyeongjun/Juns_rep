using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
public class DictionaryCards : MonoBehaviour
{
    CardInfo info;
    public Image image;
    public TextMeshProUGUI CardNameText;
    TarotDictionary dict;
    void Start(){
        dict = GameObject.FindWithTag("TarotDictionary").GetComponent<TarotDictionary>();
    }
    public void SetCard(CardInfo cardInfo){
        info = cardInfo;
        image.sprite = info.Image;
        CardNameText.text = info.Name;
    }
    public void PickCard(){
        dict.ShowCard(info);
    }
}
