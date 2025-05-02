using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class TeamStructurePage : MonoBehaviour
{
    public TextMeshProUGUI TeamName;
    public TextMeshProUGUI TeamTel;
    public TextMeshProUGUI TeamFax;
    public TextMeshProUGUI TeamIntro;

    public GameObject TeamMateBtnPrefab;
    public GameObject TeamBuildWarningPanel;
    public GameObject contentArea;

    public GameObject sortlayer;
    public GameObject TeamEditor;

    int mydepartmentID;

    void Start() {
        mydepartmentID = AccountManager.am.mydata.myemployeedata.Department;
        SetTeamMateStructure();
    }
    public void SetTeamMateStructure(){
        ClearScrollview();
        if(mydepartmentID == 0){
            string w = "소속된 팀이 없습니다. 팀을 만들거나 팀에 참여하세요!";
            GameObject warning = Instantiate(TeamBuildWarningPanel,sortlayer.transform, false);
            GameObject warnmsg = GameObject.FindGameObjectWithTag("WarningMsg");
            warnmsg.GetComponent<TextMeshProUGUI>().text = w;
            return;
        }

        TeamName.text = DBManager.db.Departments[mydepartmentID].DepartmentName;
        TeamTel.text = "TEL: "+ DBManager.db.Departments[mydepartmentID].DepartmentTel;
        TeamFax.text = "FAX: "+DBManager.db.Departments[mydepartmentID].DepartmentFax;
        TeamIntro.text = DBManager.db.Departments[mydepartmentID].DepartmentIntroduction;

        foreach(int eid in DBManager.db.Departments[mydepartmentID].TeammateIDs){
            GameObject t = Instantiate(TeamMateBtnPrefab, contentArea.transform, false);
            t.GetComponent<ParticipantBtn>().SetParticipantBtndata(eid);
        }

    }

    public void ClearScrollview(){
        foreach(Transform child in contentArea.transform){
            Destroy(child.gameObject);
        }
    }

    public void TeamEditPanelOn(){
        GameObject tedit = Instantiate(TeamEditor, sortlayer.transform, false);
        tedit.GetComponent<TeamBuilder>().SetCurrentDepartment(mydepartmentID);
    }
}
