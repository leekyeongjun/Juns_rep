using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class TeamActivityHistory : MonoBehaviour
{

    public GameObject TeamActivityHistoryContent;
    public GameObject ActivityHistoryBtnPrefab;
    public GameObject ActivityCommentBtnPrefab;

    public GameObject Intro;
    public GameObject Topper;
    public GameObject Downer;

    public GameObject WarningPanel;
    public GameObject sortlayer;
    public GameObject nothingImage;

    void Start(){
        if(AccountManager.am.loggedIn) SetTeamActivityHistory();
    }

    public void SetTeamActivityHistory(){
        ProjectDBSelector.pdb.SetCurrentProject(AccountManager.am.mydata.myemployeedata.Department);
        
        if(AccountManager.am.mydata.myemployeedata.Department == 0){
            string w = "소속된 팀이 없습니다. 팀을 만들거나, 팀에 참여하세요!";
            GameObject warningmsg = Instantiate(WarningPanel, sortlayer.transform, false);
            GameObject warnmsg = GameObject.FindGameObjectWithTag("WarningMsg");
            warnmsg.GetComponent<TextMeshProUGUI>().text = w; 
            return;
        }
        
        ClearScrollview();
        if(DBManager.db.activityHistories.Count == 0){
            
            Instantiate(nothingImage, TeamActivityHistoryContent.transform, false);
            Instantiate(Intro,TeamActivityHistoryContent.transform, false);
        }
        else {
            
            Instantiate(Downer, TeamActivityHistoryContent.transform, false);
            foreach(ActivityHistory a in DBManager.db.activityHistories){
                if(a.status == ActivityHistory.Status.comment){
                    GameObject ahbtn = Instantiate(ActivityCommentBtnPrefab, TeamActivityHistoryContent.transform, false);
                    ahbtn.GetComponent<ActivityHistoryBtn>().SetActivityHistoryLabel(a);
                }
                else{
                    GameObject ahbtn = Instantiate(ActivityHistoryBtnPrefab, TeamActivityHistoryContent.transform, false);
                    ahbtn.GetComponent<ActivityHistoryBtn>().SetActivityHistoryLabel(a);
                }
            }
            
            Instantiate(Topper, TeamActivityHistoryContent.transform, false);
            Instantiate(Intro,TeamActivityHistoryContent.transform, false);
        }

        
    }
    void ClearScrollview(){
        foreach(Transform child in TeamActivityHistoryContent.transform){
            Destroy(child.gameObject);
        }
    }
}
