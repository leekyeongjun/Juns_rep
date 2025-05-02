using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Dict_ContentManager : MonoBehaviour
{
    public List<Dict_contentSize> Boxes;
    RectTransform rect;
    VerticalLayoutGroup LayoutGroup;
    float contentSize = 0f;

    int Top_padding;
    float Spacing;

    void Start(){
        rect = GetComponent<RectTransform>();
        LayoutGroup = GetComponent<VerticalLayoutGroup>();
        Top_padding = LayoutGroup.padding.top;
        Spacing = LayoutGroup.spacing;
        
        foreach(Transform child in transform){
            Dict_contentSize dict = child.gameObject.GetComponent<Dict_contentSize>();
            Boxes.Add(dict);
        }
        
        SetContentSize();
    }

    public void SetContentSize(){
        contentSize = 0f;
        foreach(Dict_contentSize box in Boxes){
            contentSize += box.ApplyChangedHeights() + Spacing;
        }
        rect.sizeDelta = new Vector2(rect.sizeDelta.x, contentSize + Top_padding);
    }

}
