using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

[System.Serializable]
public class Activites
{

    public string ActivityName;
    public List<int> Participants;
    public int Duration;
    [TextArea]
    public string ActivityDetails;
    public List<int> Gadgetids;
    [TextArea]
    public string Result;
    public string ExtraMaterial;
    public int ProgressRatio;
    [TextArea]
    public string Note;
    public string FuturePlan;
    public List<Comment> Comments;
    
    public int WriterID;
    
    public MTime WrittenTime;
}
