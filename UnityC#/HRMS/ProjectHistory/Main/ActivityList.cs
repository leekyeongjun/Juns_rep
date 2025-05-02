using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ActivityList : MonoBehaviour
{
    int pid,tid;
    ProjectViewer projectViewer;

    public GameObject ActivityNodePrefab;
    public GameObject ActivityCreateBtnPrefab;

    public GameObject ActivityListArea;

    void Start(){
        projectViewer = projectViewer = GameObject.FindGameObjectWithTag("ProjectViewer").GetComponent<ProjectViewer>();
    }

    public void SetActivityList(int _pid, int _tid){
        pid = _pid;
        tid = _tid;
        Task t = DBManager.db.projects[_pid].tasks[_tid];

        foreach(Transform child in ActivityListArea.transform){
            Destroy(child.gameObject);
        }
        
        foreach(Activites a in t.activities){
            int aid = t.activities.IndexOf(a);
            GameObject abtn = Instantiate(ActivityNodePrefab, ActivityListArea.transform, false);
            abtn.GetComponent<Node>().Setids(pid,tid,aid);
        }
        GameObject aabtn = Instantiate(ActivityCreateBtnPrefab, ActivityListArea.transform, false);
        aabtn.GetComponent<ActivityCreateBtn>().Setids(pid,tid);
    }

}
