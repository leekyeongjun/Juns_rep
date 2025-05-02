using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

[Serializable]
public class EtcData{
    public string Title;
    public string Content;
}
[Serializable]
public class CardInfo
{
  
    public int Id;
    public Sprite Image;
    public string Name;
    public List<string> Keyword;
    public string Description;

    public List<string> Love;
    public List<string> Relationship;
    public List<string> Money;
    public List<string> Work;
    public List<string> ReMeet;
    
    public List<string> Place;
    public List<string> Mood;
    public List<string> Contact;
    public List<string> Travel;
    public List<string> MoveJob;
    public List<string> Health;
    public string Numerlogy;
    public List<EtcData> Etc;
    public List<string> Advice;

    public List<string> Warning;

}
