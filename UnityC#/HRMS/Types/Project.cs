using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public class Project
{
    public int ProjectID;
    public string ProjectName;
    public int ProfileImageID;

    public string ProjectDuration;
    public MTime WrittenTime;
    public List<Task> tasks;
}
