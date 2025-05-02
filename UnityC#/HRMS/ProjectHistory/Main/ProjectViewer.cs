using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class ProjectViewer : MonoBehaviour
{
    public GameObject ProjectBtnArea;
    public GameObject ProjectBtnPrefab;
    public GameObject ProjectAddBtnPrefab;

    public GameObject MainLayer;


    public ActivityList activityList;
    public ActivityDetails activityDetails;
    public GameObject activityDetailsScrollview;
    public CommentViewer commentViewer;
    public NewProjectHistorySideBar projectHistorySideBar;

    public GameObject sortlayer;
    public GameObject WarningPanel;

    int myDepartment;

    public NothingImage nothingImage;
    public NothingImage nothingImage_Activity;

    void Start(){
        MainLayer.SetActive(false);
        if(AccountManager.am.mydata.myemployeedata.Department == 0){
            string w = "소속된 팀이 없습니다. 팀을 만들거나, 팀에 참여하세요!";
            GameObject warningmsg = Instantiate(WarningPanel, sortlayer.transform, false);
            GameObject warnmsg = GameObject.FindGameObjectWithTag("WarningMsg");
            warnmsg.GetComponent<TextMeshProUGUI>().text = w; 
            return;
        } /* no department data */
        else{
            
            SetProjectGrid();
        }
        if(AccountManager.am.LastviewedActivityHistoryExists){
            ActivityHistory ah = AccountManager.am.LastviewedActivityHistory;

            if (ah.status == ActivityHistory.Status.task){
                OpenActivityList(ah.pid, ah.tid);
            }
            else if(ah.status == ActivityHistory.Status.activity){
                OpenActivityDetails(ah.pid, ah.tid, ah.aid);
            }
            else if(ah.status == ActivityHistory.Status.comment){
                OpenActivityDetails(ah.pid, ah.tid, ah.aid);

            }
            AccountManager.am.LastviewedActivityHistoryExists = false;
        }
    }
    public void SetProjectGrid(){
        myDepartment = AccountManager.am.mydata.myemployeedata.Department;
        ProjectDBSelector.pdb.SetCurrentProject(myDepartment);
        
        foreach(Transform child in ProjectBtnArea.transform){
            Destroy(child.gameObject);
        }
        //if(DBManager.db.projects.Count == 0 ) nothingImage.ImageOn(true);
        //else nothingImage.ImageOn(false);

        foreach(Project p in DBManager.db.projects){
            int pid = DBManager.db.projects.IndexOf(p);
            GameObject pbtn = Instantiate(ProjectBtnPrefab, ProjectBtnArea.transform, false);
            pbtn.GetComponent<ProjectHistoryBtn>().SetProjectBtnInfo(pid);
        }
        GameObject pabtn = Instantiate(ProjectAddBtnPrefab, ProjectBtnArea.transform, false);
        //pabtn.GetComponent<ProjectCreateBtn>().SetDepartment(AccountManager.am.mydata.myemployeedata.Department);
    }

    public void OpenTasksPanel(int pid){
        myDepartment = AccountManager.am.mydata.myemployeedata.Department;
        ProjectDBSelector.pdb.SetCurrentProject(myDepartment);

        MainLayer.SetActive(true);
        
        projectHistorySideBar.gameObject.SetActive(true);
        projectHistorySideBar.SetTaskArea(pid);
        activityList.gameObject.SetActive(false);
        activityDetails.gameObject.SetActive(false);
        commentViewer.gameObject.SetActive(false);
        
        if(DBManager.db.projects[pid].tasks.Count == 0){nothingImage.ImageOn(true);}
        else{nothingImage.ImageOn(false);}

    }

    public void OpenActivityList(int pid, int tid){
        myDepartment = AccountManager.am.mydata.myemployeedata.Department;
        ProjectDBSelector.pdb.SetCurrentProject(myDepartment);

        MainLayer.SetActive(true);

        projectHistorySideBar.gameObject.SetActive(true);
        projectHistorySideBar.SetTaskArea(pid);

        activityList.gameObject.SetActive(true);
        activityList.SetActivityList(pid,tid);

        activityDetails.gameObject.SetActive(true);

        activityDetailsScrollview.SetActive(false);
        commentViewer.gameObject.SetActive(false);

        if(DBManager.db.projects[pid].tasks[tid].activities.Count == 0){nothingImage_Activity.ImageOn(true);}
        else{nothingImage_Activity.ImageOn(false);}

    }

    public void OpenActivityDetails(int pid, int tid, int aid){
        myDepartment = AccountManager.am.mydata.myemployeedata.Department;
        ProjectDBSelector.pdb.SetCurrentProject(myDepartment);
        
        MainLayer.SetActive(true);

        projectHistorySideBar.gameObject.SetActive(true);
        projectHistorySideBar.SetTaskArea(pid);

        activityList.gameObject.SetActive(true);
        activityList.SetActivityList(pid,tid);

        activityDetails.gameObject.SetActive(true);
        activityDetailsScrollview.SetActive(true);
        activityDetails.SetActivityData(pid,tid,aid);

        commentViewer.gameObject.SetActive(true);
        commentViewer.SetCommentView(pid,tid,aid);

        Debug.Log("OpenActivityDetails!");
    }
}
