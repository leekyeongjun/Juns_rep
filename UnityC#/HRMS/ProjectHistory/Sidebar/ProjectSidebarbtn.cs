using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ProjectSidebarbtn : MonoBehaviour
{
    public int pid;
    public int tid;

    ProjectHistoryMain projectHistoryMain;

    void Start() {
        projectHistoryMain = GameObject.FindGameObjectWithTag("ProjectHistoryMain").GetComponent<ProjectHistoryMain>();
    }
    public void Getpidandtid(int _pid, int _tid){
        pid = _pid;
        tid = _tid;
    }
    
    public void Setpidandtid(){
        projectHistoryMain.Settargettask(pid,tid);
    }
}
