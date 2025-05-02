using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;
using UnityEditor.Animations;
using System;
using System.Threading;

public class ProjectHistoryMain : MonoBehaviour
{
    public int targetPid;
    public int targetTid;

    public GameObject panel;

    public float TaskbarTopmargin;
    public float TaskbarBotmargin;
    public float Taskbarspacing;
    
    public TextMeshProUGUI Titletext;

    public GameObject Taskbar; // not prefab
    VerticalLayoutGroup Taskbar_Layoutgroup;

    float Taskbarheight;


    public GameObject Node; // prefab
    float nodeheight;

    public GameObject ActivityCreateNode;
    float ACnodeheight;


    public GameObject Timedata; // not prefab
    VerticalLayoutGroup Timedata_Layoutgroup;

    public GameObject Date; // prefab
    float datetextheight;

    public GameObject DetailsScrollview;
    public GameObject CommentsArea;

    public GameObject sortlayer;
    public GameObject WarningPanel;


    void Start() {

        ProjectDBSelector.pdb.SetCurrentProject(AccountManager.am.mydata.myemployeedata.Department);

        nodeheight = Node.GetComponent<RectTransform>().sizeDelta.y;
        datetextheight = nodeheight;
        ACnodeheight = ActivityCreateNode.GetComponent<RectTransform>().sizeDelta.y;
        Taskbar_Layoutgroup = Taskbar.GetComponent<VerticalLayoutGroup>();
        Timedata_Layoutgroup = Timedata.GetComponent<VerticalLayoutGroup>();
        
        if(AccountManager.am.LastviewedActivityHistoryExists){
            ActivityHistory ah = AccountManager.am.LastviewedActivityHistory;

            if (ah.status == ActivityHistory.Status.task){
                Settargettask(ah.pid, ah.tid);
            }
            else if(ah.status == ActivityHistory.Status.activity){
                Settargettask(ah.pid, ah.tid);
                DetailsScrollview.SetActive(true);
                DetailsScrollview.GetComponentInParent<ActivityDetails>().SetActivityData(ah.pid, ah.tid, ah.aid);
            }
            else if(ah.status == ActivityHistory.Status.comment){
                Settargettask(ah.pid, ah.tid);
                DetailsScrollview.SetActive(true);
                DetailsScrollview.GetComponentInParent<ActivityDetails>().SetActivityData(ah.pid, ah.tid, ah.aid);
            }
            AccountManager.am.LastviewedActivityHistoryExists = false;
        }
    }
    public void Settargettask(int _pid, int _tid){
        panel.SetActive(true);
        DetailsScrollview.SetActive(false);
        CommentsArea.SetActive(false);
        targetPid = _pid;
        targetTid = _tid;
        Task currentTask = DBManager.db.projects[targetPid].tasks[targetTid];
        foreach(Transform child in Taskbar.transform){
            Destroy(child.gameObject);
        }

        foreach(Transform child in Timedata.transform){
            Destroy(child.gameObject);
        }
        Titletext.text = currentTask.TaskName;
        if(currentTask.activities != null){
            Taskbarheight = TaskbarTopmargin + TaskbarBotmargin + ACnodeheight + (currentTask.activities.Count * (nodeheight+Taskbarspacing));
            Taskbar.GetComponent<RectTransform>().sizeDelta = new Vector2(100, Taskbarheight);
            Taskbar_Layoutgroup.padding.top = (int)TaskbarTopmargin;
            Taskbar_Layoutgroup.padding.bottom = (int)TaskbarBotmargin;
            Taskbar_Layoutgroup.spacing = (int) Taskbarspacing;
            
            Timedata.GetComponent<RectTransform>().sizeDelta = new Vector2(170, Taskbarheight);
            Timedata_Layoutgroup.padding.top = (int)TaskbarTopmargin;
            Timedata_Layoutgroup.padding.bottom = (int)TaskbarBotmargin;
            Timedata_Layoutgroup.spacing = (int) Taskbarspacing;
            


            //instantiate
            foreach(Activites a in currentTask.activities){
                GameObject newNode = Instantiate(Node, Taskbar.transform, false);
                newNode.GetComponent<Node>().Setids(targetPid, targetTid, currentTask.activities.IndexOf(a));
                GameObject newDate = Instantiate(Date, Timedata.transform, false);
                newDate.GetComponent<TextMeshProUGUI>().text = TimeManager.tm.GetTimeComparedtoNow(a.WrittenTime.ToDateTime());
            }

            GameObject ActivityCreateBtn = Instantiate(ActivityCreateNode, Taskbar.transform, false);
            ActivityCreateBtn.GetComponent<ActivityCreateBtn>().Setids(targetPid, targetTid);
        }
    }






}
