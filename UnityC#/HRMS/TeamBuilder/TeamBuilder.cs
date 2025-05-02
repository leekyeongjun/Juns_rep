using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class TeamBuilder : MonoBehaviour
{

    int curTeamId;
    Department curTeam;

    public TMP_InputField TeamNameInputfield;
    public TMP_InputField TeamTelInputfield;
    public TMP_InputField TeamFaxInputfield;
    public TMP_InputField TeamIntroInputfield;

    public GameObject ErrorPanel;
    GameObject sortlayer;

    void Start(){
        ProjectDBSelector.pdb.SetEmployeeDB();
        sortlayer = GameObject.FindGameObjectWithTag("MiniPanelSortLayer");
    }
    public void AddDepartment(){
        if(TeamNameInputfield.text != ""){
            Department d = new(){
                TeammateIDs = new List<int>(),
                DepartmentName= TeamNameInputfield.text,
                DepartmentTel = TeamTelInputfield.text,
                DepartmentFax = TeamFaxInputfield.text,
                DepartmentIntroduction = TeamIntroInputfield.text 
            };

            d.TeammateIDs.Add(AccountManager.am.mydata.myemployeedata.Id);
            
            ServerProjects s = new();
            ProjectDBSelector.pdb.TotalProject.Add(s);
            DBManager.db.Departments.Add(d);
            AccountManager.am.mydata.myemployeedata.Department = DBManager.db.Departments.IndexOf(d);
            ProjectDBSelector.pdb.GetEmployeeDifference();
            LoadManager.lm.MoveScene("HomeScene");
        }
        else{
            GameObject err = Instantiate(ErrorPanel, sortlayer.transform, false);
            GameObject errmsg = GameObject.FindGameObjectWithTag("ErrorMsg");
            errmsg.GetComponent<TextMeshProUGUI>().text = "팀 이름은 공백이 될 수 없습니다.";
        }
    }

    public void SetCurrentDepartment(int TeamId){
        curTeamId = TeamId;
        curTeam = DBManager.db.Departments[curTeamId];

        TeamNameInputfield.text = curTeam.DepartmentName;
        TeamTelInputfield.text = curTeam.DepartmentTel;
        TeamFaxInputfield.text = curTeam.DepartmentFax;
        TeamIntroInputfield.text = curTeam.DepartmentIntroduction;
    }

    public void EditDepartmentData(){
        if(curTeamId != 0){
            if(TeamNameInputfield.text != ""){
                DBManager.db.Departments[curTeamId].DepartmentName = TeamNameInputfield.text;
                DBManager.db.Departments[curTeamId].DepartmentFax =TeamFaxInputfield.text;
                DBManager.db.Departments[curTeamId].DepartmentTel =TeamTelInputfield.text;
                DBManager.db.Departments[curTeamId].DepartmentIntroduction = TeamIntroInputfield.text;
                GameObject.FindGameObjectWithTag("TeamStructure").GetComponent<TeamStructurePage>().SetTeamMateStructure();
                Destroy(this.gameObject);
            }
            else{
                GameObject err = Instantiate(ErrorPanel, sortlayer.transform, false);
                GameObject errmsg = GameObject.FindGameObjectWithTag("ErrorMsg");
                errmsg.GetComponent<TextMeshProUGUI>().text = "팀 이름은 공백이 될 수 없습니다.";
            }
        }
        
    }
}
