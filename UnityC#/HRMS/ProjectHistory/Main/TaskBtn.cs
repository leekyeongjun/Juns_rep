using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class TaskBtn : MonoBehaviour
{
    int pid;
    int tid;

    ProjectViewer projectViewer;

    public TextMeshProUGUI TaskNameText;

    void Start(){
        projectViewer = GameObject.FindGameObjectWithTag("ProjectViewer").GetComponent<ProjectViewer>();
    }
    public void SetTaskBtn(int _pid, int _tid){
        pid = _pid;
        tid = _tid;
        TaskNameText.text = DBManager.db.projects[pid].tasks[tid].TaskName;
    }

    public void OnTaskBtnClick(){
        projectViewer.OpenActivityList(pid,tid);    
    }
}
