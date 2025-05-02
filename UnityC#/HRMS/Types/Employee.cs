using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public class Employee 
{

    public int Id ;
    public string Employee_Name ;
    public int Employee_Age ;
    public int Employee_Gender ;
    [NonSerialized]
    public int Relocation_times ;
    [NonSerialized]
    public int Service_years ;
    public int Department ;
    public string PhoneNo;
    public string EmailAddress;
    public string Rank;
    public int Facetype;

    public List<ActivityHistory> PersonalActivityHistories;

    public string WorkArea;

    public List<string> CareerHistory;

    public List<int> Badges;
    public List<int> BadgestoShow;

    public List<int> Awards;
    public int AwardstoShow;


    public ReflectionList ReboardingReflectionList;

    public string SysID;

    public string SysPw;



}
