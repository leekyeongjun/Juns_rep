using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;
public class SelectedCard : MonoBehaviour
{
    // Start is called before the first frame update
    Image image;
    TextMeshProUGUI NameText;

    void Start(){
        image = gameObject.transform.GetChild(1).GetComponent<Image>();
        NameText = gameObject.transform.GetChild(2).GetComponentInChildren<TextMeshProUGUI>();
    }
    public void SetCardInfo(CardInfo info){
        image.sprite = info.Image;
        NameText.text = info.Name;
    }
}
