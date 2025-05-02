using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using UnityEngine.UI;
using System;

public class ProjectHistoryCreator : MonoBehaviour
{

    //ProjectHistorySidebar projectHistorySidebar;
    ProjectViewer projectViewer;

    public TMP_InputField ProjectInputfield;

    public TMP_InputField ProjectDurationFirst;
    public TMP_InputField ProjectDurationLast;

    public TMP_Dropdown ProfileDropdown;

    public Image ProfileExample;


    public GameObject ErrorPanel;
    bool valid = false;

    List<string> dropdownvalues;

    GameObject sortlayer;


    void Start(){
        //projectHistorySidebar = GameObject.FindWithTag("ProjectHistorySidebar").GetComponent<ProjectHistorySidebar>();
        ProjectDBSelector.pdb.SetEmployeeDB();
        projectViewer = GameObject.FindWithTag("ProjectViewer").GetComponent<ProjectViewer>();
        sortlayer = GameObject.FindGameObjectWithTag("MiniPanelSortLayer");
        SetInputfields();
        SetDropdownValues();
        SetProfileImage();
    }

    public void AddProject(){
        string e = CheckValidity();

        if(valid){
            Project newProject = new(){   
                ProjectID = (DBManager.db.projects == null) ? 0: DBManager.db.projects.Count+1,
                ProjectName = ProjectInputfield.text,
                ProjectDuration = ProjectDurationFirst.text + " - " + ProjectDurationLast.text,
                tasks = new List<Task>(),
                ProfileImageID = ProfileDropdown.value,
                WrittenTime = new MTime(DateTime.Now)
            };
           
            DBManager.db.projects.Add(newProject);
            
            ActivityHistory a = new();
            a.SetProjectActivityHistory(DBManager.db.projects.IndexOf(newProject), AccountManager.am.mydata.myemployeedata, new MTime(DateTime.Now));
            DBManager.db.Employees[AccountManager.am.mydata.myemployeedata.Id].PersonalActivityHistories.Add(a);
            DBManager.db.activityHistories.Add(a);

            ProjectDBSelector.pdb.GetDBDifference(AccountManager.am.mydata.myemployeedata.Department);
            ProjectDBSelector.pdb.GetEmployeeDifference();
            projectViewer.SetProjectGrid();
            Destroy(gameObject);
        }
        else{
            GameObject err = Instantiate(ErrorPanel, sortlayer.transform, false);
            GameObject errmsg = GameObject.FindGameObjectWithTag("ErrorMsg");
            errmsg.GetComponent<TextMeshProUGUI>().text = e;
        }
        
    }


    public string CheckValidity(){
        string e;
        if(ProjectInputfield.text == ""){
            valid = false;
            e = "프로젝트 이름이 설정되지 않았습니다.";
            return e;
        }
        else if(ProjectDurationFirst.text == "" || ProjectDurationLast.text == ""){
            valid = false;
            e = "프로젝트 기간의 형식이 잘못되었습니다.";
            return e;
        }
        else{
            valid = true;
            return "";
        }
    }

    public void SetInputfields(){
        ProjectInputfield.text = "";
        ProjectDurationFirst.text = "";
        ProjectDurationLast.text = "";

    }

    public void SetDropdownValues(){
        dropdownvalues = new List<string>();
        foreach(Sprite i in DBManager.db.ProjectProfiles){
            dropdownvalues.Add("이미지" + DBManager.db.ProjectProfiles.IndexOf(i)+1);
        }

        ProfileDropdown.AddOptions(dropdownvalues);

    }
    public void SetProfileImage(){
        ProfileExample.sprite = DBManager.db.ProjectProfiles[ProfileDropdown.value];
    }
    
}
