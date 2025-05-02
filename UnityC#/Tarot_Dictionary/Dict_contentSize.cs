using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;
using Unity.VisualScripting;
using System;

public enum BlockType{
    A,B,C
}
public class Dict_contentSize : MonoBehaviour
{
    public BlockType blockType;

    // only for type A / B
    //[SerializeField]
    RectTransform parentRect;
    public float TitleTextHeight;
    public GameObject Textbox;

    //[SerializeField]
    RectTransform TextboxRect;

    //[SerializeField]
    TMP_Text TextboxTMP;
    //[SerializeField]
    public float Textbox_MinHeight;
    public RectTransform TextBGRect;
    public GameObject Title;
    // Fixed values

    //[SerializeField]
    float Textbox_width;

    // changable values;
    //[SerializeField]
    float Preffered_height;
    //[SerializeField]
    float Textbox_height;
    float TextBG_height;
    public float offset;

    void Start(){
        SetComponent();
        //Debug.Log(Textbox_width.ToString()+ "," +Textbox_height.ToString());
    }
    public void SetComponent(){
        
        if(blockType != BlockType.C){
            parentRect = GetComponent<RectTransform>();
            TextboxRect = Textbox.GetComponent<RectTransform>();
            TextboxTMP = Textbox.GetComponent<TMP_Text>();
            Textbox_width = TextboxRect.sizeDelta.x;
            Textbox_height = Textbox_MinHeight;
            if(blockType == BlockType.B){
                TitleTextHeight = Title.GetComponent<RectTransform>().sizeDelta.y;
            }
        }
        else{
            parentRect = GetComponent<RectTransform>();
            Textbox_MinHeight = parentRect.sizeDelta.y;
        }
    }
    public void SetPrefferdHeight(){
        if(blockType != BlockType.C){
            float PreferredTextbox_height = ((TextboxTMP.preferredWidth*(GetLineShift(TextboxTMP)))/Textbox_width)*Textbox_height;
            Debug.Log(GetLineShift(TextboxTMP).ToString() + " , " + PreferredTextbox_height);
            if(Textbox_height < PreferredTextbox_height){
                if(PreferredTextbox_height < Textbox_MinHeight){
                    Textbox_height = Textbox_MinHeight;
                }else Textbox_height = PreferredTextbox_height;
            }
            TextBG_height = Textbox_height+offset;
            TextboxRect.sizeDelta = new Vector2(Textbox_width, Textbox_height);
            TextBGRect.sizeDelta = new Vector2(Textbox_width, TextBG_height);
        }

    }
    public float ApplyChangedHeights(){
        ResetHeights();
        SetComponent();
        SetPrefferdHeight();

        if(blockType == BlockType.A){
            parentRect.sizeDelta = new Vector2(parentRect.sizeDelta.x, TextBG_height);
            
        }
        else if(blockType == BlockType.B){
            parentRect.sizeDelta = new Vector2(parentRect.sizeDelta.x,  TextBG_height + TitleTextHeight);
        }
        return parentRect.sizeDelta.y;
    }

    public void ResetHeights(){
        Textbox_height = Textbox_MinHeight;
        TextBG_height = Textbox_MinHeight;
    }

    public int GetLineShift(TMP_Text CurText){
        int shift = 1;
        foreach(char c in CurText.text){
            if(c == '\n') shift++;
        }
        return shift;
    }

}
