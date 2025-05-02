using System.Collections;
using System.Collections.Generic;
using UnityEngine.EventSystems;
using UnityEngine;
using UnityEngine.UI;
using TMPro;
using System;

public class TaskCreator : MonoBehaviour 
{
    // Start is called before the first frame update
    int pid;
    public GameObject TaskInputfield;
    ProjectViewer projectViewer;


    public void Start(){
        ProjectDBSelector.pdb.SetEmployeeDB();
        projectViewer = GameObject.FindGameObjectWithTag("ProjectViewer").GetComponent<ProjectViewer>();
    }

    public void setpid(int _pid){
        pid = _pid;
    }



    public void AddTask(){
        if(pid!= -1 && TaskInputfield.GetComponent<TMP_InputField>().text != ""){
            Task newtask = new(){
                TaskID = DBManager.db.projects[pid].tasks.Count+1,
                TaskName = TaskInputfield.GetComponent<TMP_InputField>().text,
                activities = new List<Activites>(),
            };
            DBManager.db.projects[pid].tasks.Add(newtask);

            ActivityHistory a = new();
            a.SetTaskActivityHistory(pid, DBManager.db.projects[pid].tasks.IndexOf(newtask), AccountManager.am.mydata.myemployeedata, new MTime(DateTime.Now));
            DBManager.db.Employees[AccountManager.am.mydata.myemployeedata.Id].PersonalActivityHistories.Add(a);
            DBManager.db.activityHistories.Add(a);
            
            ProjectDBSelector.pdb.GetDBDifference(AccountManager.am.mydata.myemployeedata.Department);
            ProjectDBSelector.pdb.GetEmployeeDifference();
            projectViewer.OpenTasksPanel(pid);

            Destroy(gameObject);
        }
    }
}
