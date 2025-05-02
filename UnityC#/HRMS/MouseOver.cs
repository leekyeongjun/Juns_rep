using System.Collections;
using System.Collections.Generic;
using UnityEngine.EventSystems;
using UnityEngine;
using UnityEngine.UI;
using TMPro;
using System;

public class MouseOver : MonoBehaviour
    , IPointerEnterHandler
    , IPointerExitHandler

{

    Image target;
    public Sprite MouseExitedImage;
    public Sprite MouseOveredImage;

    void Start(){
        target = GetComponent<Image>();
    }
    public void OnPointerEnter(PointerEventData eventData){
        target.sprite = MouseOveredImage;
    }
    public void OnPointerExit(PointerEventData eventData){
        target.sprite = MouseExitedImage;
    }
}
