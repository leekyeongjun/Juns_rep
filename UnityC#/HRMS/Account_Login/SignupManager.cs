using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using UnityEngine.UI;
using System;

public class SignupManager : MonoBehaviour
{
    public TMP_InputField NameInputfield;
    public TMP_InputField AgeInputfield;
    public TMP_Dropdown GenderDropdown;
    public TMP_InputField PhoneNo_1;
    public TMP_InputField PhoneNo_2;
    public TMP_InputField PhoneNo_3;

    public TMP_InputField EmailFront;
    public TMP_Dropdown EmailDropdown;
    public TMP_InputField EmailBehind;

/*
    public GameObject WorkingStyleArea;
    public GameObject CommunicationStyleArea;
    public GameObject BestPerformanceArea;

    public List<string> CurWorkingStyle;
    public List<string> CurCommunicationStyle;
    public List<string> CurBestPerformanceStyle;
    public List<string> CustomCurWorkingStyle;
    public List<string> CustomCurCommunicationStyle;
    public List<string> CustomCurBestPerformanceStyle;

    public GameObject WorkingStyleToggle;
    public GameObject CustomWorkingStyleToggle;
*/
    public TMP_Dropdown ProfileTypeDropdown;
    public List<string> PTDoptions;
    public Image ProfileExample;
    public TMP_InputField SysId;
    public TMP_InputField SysPw;

    GameObject sortlayer;
    public GameObject ErrorPanel;
    public GameObject WarningPanel;

    public GameObject WelcomePanel;

    bool valid = false;
    bool desirable = false;
    
    void Start() {
        ProjectDBSelector.pdb.SetEmployeeDB();
        SetInputfields();
        SetProfileDropdown();
        sortlayer = GameObject.FindGameObjectWithTag("MiniPanelSortLayer");
    }

    public void SetInputfields(){
        NameInputfield.text = "";
        AgeInputfield.text = "";
        GenderDropdown.value = 0;
        PhoneNo_1.text = "";
        PhoneNo_2.text = "";
        PhoneNo_3.text = "";

        EmailFront.text = "";
        EmailDropdown.value = 0;
        SetEmailBack();

        ProfileTypeDropdown.value = 0;
        ProfileExample.sprite = DBManager.db.FaceImageList[0];
        
        SysId.text = "";
        SysPw.text = "";
    }


    public string CheckValidity(){
        string Errmsg = "";
        if(NameInputfield.text == ""){
            Errmsg = "이름은 필수 입력 사항입니다.";
            return Errmsg;
        }
        if(AgeInputfield.text == ""){
            Errmsg = "연령은 필수 입력 사항입니다.";
            return Errmsg;
        }
        if(int.Parse(AgeInputfield.text) <= 0){
            Errmsg = "연령이 잘못 입력되었습니다.";
            return Errmsg;
        }
        if(SysId.text == ""){
            Errmsg = "시스템 아이디는 공백이 허용되지 않습니다.";
            return Errmsg;
        }
        if(SysPw.text == ""){
            Errmsg = "시스템 비밀번호는 공백이 허용되지 않습니다.";
            return Errmsg;
        }
        /*
        if(CurWorkingStyle.Count == 0 && CustomCurWorkingStyle.Count == 0){
            Errmsg = "업무성향은 \n적어도 1개 선택해야 합니다.";
            return Errmsg;
        }
        if(CurCommunicationStyle.Count == 0 && CustomCurCommunicationStyle.Count == 0){
            Errmsg = "커뮤니케이션스타일은 \n적어도 1개 선택해야 합니다.";
            return Errmsg;
        }
        if( CurBestPerformanceStyle.Count == 0 && CustomCurBestPerformanceStyle.Count == 0){
            Errmsg = "최고의 성과상황은 \n적어도 1개 선택해야 합니다.";
            return Errmsg;
        }
        */
        foreach(Employee a in DBManager.db.Employees){
            if(SysId.text == a.SysID){
                Errmsg = "중복 아이디는 허용되지 않습니다.";
                return Errmsg;
            }
        }
        valid = true;
        return Errmsg;
    }

    public string CheckDesirability(){
        string warnmsg = "";
        if(PhoneNo_1.text == "" || PhoneNo_2.text == "" || PhoneNo_3.text == ""){
            warnmsg += "\n전화번호가 제대로 입력되지 않았습니다. \n이후 마이페이지에서 확인하세요.";
        }
        if(EmailFront.text == "" || EmailBehind.text == ""){
            warnmsg += "\n이메일이 제대로 입력되지 않았습니다. \n이후 마이페이지에서 확인하세요.";
        }
        if(warnmsg == "") desirable = true;
        return warnmsg;

    }

    public void SetEmailBack(){
        if(EmailDropdown.value == 0){
            EmailBehind.text = "hanyang.ac.kr";
            EmailBehind.interactable = false;
        }
        if(EmailDropdown.value == 1){
            EmailBehind.text = "naver.com";
            EmailBehind.interactable = false;
        }
        if(EmailDropdown.value == 2){
            EmailBehind.text = "gmail.com";
            EmailBehind.interactable = false;
        }
        if(EmailDropdown.value == 3){
            EmailBehind.text = "hanmail.net";
            EmailBehind.interactable = false;
        }
        if(EmailDropdown.value == 4){
            EmailBehind.interactable = true;
        }
    }

    public void SetProfileDropdown(){
        foreach(Sprite s in DBManager.db.FaceImageList){
            PTDoptions.Add(DBManager.db.FaceImageExplain[DBManager.db.FaceImageList.IndexOf(s)]);
        }
        ProfileTypeDropdown.AddOptions(PTDoptions);
    }

    public void SetProfileImage(){
        ProfileExample.sprite = DBManager.db.FaceImageList[ProfileTypeDropdown.value];
    }


    public void SignIn(){
        string err = CheckValidity();
        if(valid){
            string w = CheckDesirability();
            Employee e = new(){
                Id = DBManager.db.Employees.Count,
                Employee_Name = NameInputfield.text,
                Employee_Age = int.Parse(AgeInputfield.text),
                Employee_Gender = GenderDropdown.value,
                Relocation_times = 0,
                Service_years = 0,
                Department = 0,
                PhoneNo = PhoneNo_1.text+"-"+PhoneNo_2.text+"-"+PhoneNo_3.text,
                EmailAddress = EmailFront.text +"@" + EmailBehind.text,
                Rank = "팀원",
                Facetype = ProfileTypeDropdown.value,
                PersonalActivityHistories = new List<ActivityHistory>(),
                WorkArea = "",
                CareerHistory = new List<string>(),
                ReboardingReflectionList = new ReflectionList(),
                Badges = new List<int>(){0,1,2,3,4,5,6,7,8,9},
                BadgestoShow = new List<int>(),
                Awards = new List<int>(){1},
                AwardstoShow = 0,
                
                SysID = SysId.text,
                SysPw = SysPw.text
            };
            DBManager.db.Employees.Add(e);
            ProjectDBSelector.pdb.GetEmployeeDifference();

            if(desirable){
                //LoadManager.lm.MoveScene("WelcomeScene");
                Instantiate(WelcomePanel, sortlayer.transform, false);
            } 
            else{
                GameObject warning = Instantiate(WarningPanel,sortlayer.transform, false);
                GameObject warnmsg = GameObject.FindGameObjectWithTag("WarningMsg");
                warnmsg.GetComponent<TextMeshProUGUI>().text = w;
            }
        }
    
        else{
            GameObject er = Instantiate(ErrorPanel, sortlayer.transform, false);
            GameObject errmsg = GameObject.FindGameObjectWithTag("ErrorMsg");
            errmsg.GetComponent<TextMeshProUGUI>().text = err;
        }
    }
}
