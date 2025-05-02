using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class Mypage : MonoBehaviour
{
    public Employee TargetEmployee;
    
    public Image profileImage;
    public TextMeshProUGUI NameText;
    public TextMeshProUGUI RankText;
    public TextMeshProUGUI DepartmentText;
    public TextMeshProUGUI PhoneNoText;
    public TextMeshProUGUI EmailText;

    public GameObject BadgeArea;
    public GameObject BadgePrefab;

    public GameObject AwardArea;
    public GameObject AwardPrefab;


    /*
    public GameObject WorkStyleContent;
    public GameObject CommunicationStyleContent;
    public GameObject BestPracticeStyleContent;
    public GameObject WorkingStyleBadgePrefab;
    public GameObject CommuStyleBadgePrefab;
    public GameObject BestPStyleBadgePrefab;

    */
    public GameObject CareerHistoryContent;
    public GameObject ActivityHistoryContent;
    
    public NothingImage nothingImage;
    public GameObject ActivityHistoryBtnPrefab;
    public GameObject ActivityCommentBtnPrefab;   
    public Button Editbtn;
    public GameObject EditPanel;

    public GameObject sortlayer;

    void Start(){
        ProjectDBSelector.pdb.SetEmployeeDB();
    }

    public void SetMyPage(Employee e){
        ClearScrollview();
        
        profileImage.sprite = DBManager.db.FaceImageList[e.Facetype];
        TargetEmployee = e;
        NameText.text = e.Employee_Name;
        RankText.text= e.Rank;
        if(DBManager.db.Departments[e.Department] != null) DepartmentText.text = DBManager.db.Departments[e.Department].DepartmentName;
        PhoneNoText.text = e.PhoneNo;
        EmailText.text = e.EmailAddress;

        


        foreach(ActivityHistory a in e.PersonalActivityHistories){
            if(a.status == ActivityHistory.Status.comment){
                GameObject ahbtn = Instantiate(ActivityCommentBtnPrefab, ActivityHistoryContent.transform, false);
                ahbtn.GetComponent<ActivityHistoryBtn>().SetActivityHistoryLabel(a);
            }
            else{
                GameObject ahbtn = Instantiate(ActivityHistoryBtnPrefab, ActivityHistoryContent.transform, false);
                ahbtn.GetComponent<ActivityHistoryBtn>().SetActivityHistoryLabel(a);
            }
        }
        
        if(ActivityHistoryContent.transform.childCount == 0){
            nothingImage.ImageOn(true);
        }else nothingImage.ImageOn(false);

        foreach(int a in e.BadgestoShow){
            GameObject B = Instantiate(BadgePrefab, BadgeArea.transform, false);
            B.GetComponent<Badge>().SetBadgeImage(a);
        }

        if(e.AwardstoShow != 0) {
            GameObject A = Instantiate(AwardPrefab, AwardArea.transform, false);
            A.GetComponent<Award>().SetAwardImage(e.AwardstoShow);
        }
    /*
        foreach(string s in e.WorkingStyle){
            GameObject g = Instantiate(WorkingStyleBadgePrefab, WorkStyleContent.transform, false);
            g.transform.GetChild(0).GetComponent<TextMeshProUGUI>().text = "#"+s;
        }

        foreach(string s in e.CommunicationStyle){
            GameObject g = Instantiate(CommuStyleBadgePrefab, CommunicationStyleContent.transform, false);
            g.transform.GetChild(0).GetComponent<TextMeshProUGUI>().text = "#"+s;
        }
        foreach(string s in e.BestPerformance){
            GameObject g = Instantiate(BestPStyleBadgePrefab, BestPracticeStyleContent.transform, false);
            g.transform.GetChild(0).GetComponent<TextMeshProUGUI>().text ="#"+ s;
        }
        
        foreach(string s in e.CustomWorkingStyle){
            GameObject g = Instantiate(WorkingStyleBadgePrefab, WorkStyleContent.transform, false);
            g.transform.GetChild(0).GetComponent<TextMeshProUGUI>().text = "#"+s;
        }
        foreach(string s in e.CustomCommunicationStyle){
            GameObject g = Instantiate(CommuStyleBadgePrefab, CommunicationStyleContent.transform, false);
            g.transform.GetChild(0).GetComponent<TextMeshProUGUI>().text = "#"+s;
        }
        foreach(string s in e.CustomBestPerformancee){
            GameObject g = Instantiate(BestPStyleBadgePrefab, BestPracticeStyleContent.transform, false);
            g.transform.GetChild(0).GetComponent<TextMeshProUGUI>().text ="#"+ s;
        }
    */
    }

    void ClearScrollview(){
        foreach(Transform child in BadgeArea.transform){
            Destroy(child.gameObject);
        }
        foreach(Transform child in ActivityHistoryContent.transform){
            Destroy(child.gameObject);
        }
        /*
        foreach(Transform child in WorkStyleContent.transform){
            Destroy(child.gameObject);
        }
        foreach(Transform child in CommunicationStyleContent.transform){
            Destroy(child.gameObject);
        }
        foreach(Transform child in BestPracticeStyleContent.transform){
            Destroy(child.gameObject);
        }
        */
        foreach(Transform child in AwardArea.transform){
            Destroy(child.gameObject);
        }
    }

    public void OpenEditpage(){
        GameObject editpanel = Instantiate(EditPanel, sortlayer.transform, false);
        editpanel.GetComponent<MypageEditor>().SetInputfields(AccountManager.am.mydata.myemployeedata.Id);
    }
}
