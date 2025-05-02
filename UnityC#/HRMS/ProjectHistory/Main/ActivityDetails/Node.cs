using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class Node : MonoBehaviour
{
    
    ActivityDetails activityDetails;
    int pid;
    int tid;
    int aid;

    public TextMeshProUGUI ActivityNameText;
    public TextMeshProUGUI ActivityTimeStampText;

    void Start(){
        activityDetails = GameObject.FindGameObjectWithTag("ActivityDetails").GetComponent<ActivityDetails>();
    }

    public void Setids(int _pid, int _tid, int _aid){
        pid = _pid;
        tid = _tid;
        aid = _aid;

        ActivityNameText.text = DBManager.db.projects[pid].tasks[tid].activities[aid].ActivityName;
        ActivityTimeStampText.text = TimeManager.tm.GetTimeComparedtoNow(DBManager.db.projects[pid].tasks[tid].activities[aid].WrittenTime.ToDateTime());
    }

    public void nodeclicked(){
        activityDetails.SetActivityData(pid,tid,aid);
    }
}
