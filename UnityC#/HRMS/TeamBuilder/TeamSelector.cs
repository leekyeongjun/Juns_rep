using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using UnityEngine.UI;

public class TeamSelector : MonoBehaviour
{
    // Start is called before the first frame update
    public TMP_Dropdown TeamDropDown;
    List<string> TeamList;

    GameObject sortlayer;
    public GameObject WarningPanel;

    int myid;
    int curTeamid;

    void Start(){
        ProjectDBSelector.pdb.SetEmployeeDB();
        TeamList = new List<string>();
        sortlayer = GameObject.FindGameObjectWithTag("MiniPanelSortLayer");
        if(AccountManager.am.loggedIn){
            myid = AccountManager.am.mydata.myemployeedata.Id;
            curTeamid =  DBManager.db.Employees[myid].Department;
            SetTeamDropDown();
        }
    }

    public void SetTeamDropDown(){
        TeamList.Clear();
        foreach(Department d in DBManager.db.Departments){
            if(DBManager.db.Departments.IndexOf(d) !=0){
                TeamList.Add(d.DepartmentName);
            }
        }
        TeamDropDown.AddOptions(TeamList);
    }

    public void SetTeam(){
        if(DBManager.db.Departments[TeamDropDown.value] != null){
            if(curTeamid == 0){
                DBManager.db.Employees[myid].Department = TeamDropDown.value+1;
                DBManager.db.Departments[TeamDropDown.value+1].TeammateIDs.Add(AccountManager.am.mydata.myemployeedata.Id);
                foreach(int eId in DBManager.db.Departments[curTeamid].TeammateIDs){
                    if(eId == myid) DBManager.db.Departments[curTeamid].TeammateIDs.Remove(eId);
                }
                string w = DBManager.db.Departments[DBManager.db.Employees[myid].Department].DepartmentName + " 팀에 합류했습니다! \n 팀의 프로젝트 히스토리를 확인하세요!";
                GameObject warning = Instantiate(WarningPanel,sortlayer.transform, false);
                GameObject warnmsg = GameObject.FindGameObjectWithTag("WarningMsg");
                warnmsg.GetComponent<TextMeshProUGUI>().text = w;
            }
            
            else if(curTeamid != TeamDropDown.value){
                DBManager.db.Employees[myid].Department = TeamDropDown.value+1;
                DBManager.db.Departments[TeamDropDown.value+1].TeammateIDs.Add(AccountManager.am.mydata.myemployeedata.Id);
                foreach(int eId in DBManager.db.Departments[curTeamid].TeammateIDs){
                    if(eId == myid) DBManager.db.Departments[curTeamid].TeammateIDs.Remove(eId);
                }
                string w = DBManager.db.Departments[DBManager.db.Employees[myid].Department].DepartmentName + " 팀에 합류했습니다! \n 팀의 프로젝트 히스토리를 확인하세요!";
                GameObject warning = Instantiate(WarningPanel,sortlayer.transform, false);
                GameObject warnmsg = GameObject.FindGameObjectWithTag("WarningMsg");
                warnmsg.GetComponent<TextMeshProUGUI>().text = w;
            }
            else{
                Debug.Log("Error in team setting");
            }
        }
    }
}
