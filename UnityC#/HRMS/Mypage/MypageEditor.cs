using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using UnityEngine.UI;

public class MypageEditor : MonoBehaviour
{

    int id;
    Employee curEmployee;

    //public TMP_InputField NameInputfield;
    //public TMP_InputField AgeInputfield;
    //public TMP_Dropdown GenderDropdown;
    public TMP_InputField PhoneNo_1;
    public TMP_InputField PhoneNo_2;
    public TMP_InputField PhoneNo_3;

    public GameObject BadgeArea;
    public GameObject BadgeSelectTogglePrefab;

    public GameObject AwardArea;
    public GameObject AwardSelectTogglePrefab;

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

    //public TMP_Dropdown TeamDropdown;
    //List<string> TeamList;

    GameObject sortlayer;
    public GameObject ErrorPanel;
    public GameObject WarningPanel;


    bool valid = false;
    bool desirable = false;
    // Start is called before the first frame update
    void Start()
    {
        sortlayer = GameObject.FindGameObjectWithTag("MiniPanelSortLayer");
        ProjectDBSelector.pdb.SetEmployeeDB();
    }

    public void SetInputfields(int _id){
        id = _id;
        curEmployee = DBManager.db.Employees[_id];

        //NameInputfield.text = curEmployee.Employee_Name;
        //AgeInputfield.text = curEmployee.Employee_Age.ToString();
        //GenderDropdown.value = curEmployee.Employee_Gender;

        string[] Phonenos = curEmployee.PhoneNo.Split("-");
        if(Phonenos.Length == 3){
            PhoneNo_1.text = Phonenos[0];
            PhoneNo_2.text = Phonenos[1];
            PhoneNo_3.text = Phonenos[2];
        }
        else{
            PhoneNo_1.text = "";
            PhoneNo_2.text = "";
            PhoneNo_3.text = "";
        }

        string[] Email = curEmployee.EmailAddress.Split("@");
        if(Email.Length == 2){
            EmailFront.text = Email[0];
            GetEmailBack(Email[1]);
        }
        else{
            EmailFront.text = "";
            EmailDropdown.value = 4;
            SetEmailBack();
        }

        ProfileTypeDropdown.value = curEmployee.Facetype;
        ProfileExample.sprite = DBManager.db.FaceImageList[curEmployee.Facetype];

        //SetTeamDropDown();
        //TeamDropdown.value = curEmployee.Department;



        SysId.text = curEmployee.SysID;
        SysPw.text = curEmployee.SysPw;
    
        SetCheckboxes();
        SetProfileDropdown();
        SetProfileImage();
    }
    // Update is called once per frame

    public void GetEmailBack(string emailback){
        if(emailback == "hanyang.ac.kr"){

            EmailDropdown.value = 0;
            EmailBehind.interactable = false;
        }
        else if(emailback == "naver.com"){        
            EmailDropdown.value = 1;
            EmailBehind.interactable = false;
        }
        else if(emailback == "gmail.com"){         
            EmailDropdown.value = 2;
            EmailBehind.interactable = false;
        }
        else if(emailback == "hanmail.net"){      
            EmailDropdown.value = 3;
            EmailBehind.interactable = false;
        }
        else{
            Debug.Log(emailback);    
            EmailDropdown.value = 4;
            EmailBehind.interactable = true;
        }
        EmailBehind.text = emailback;
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
    /*
    public void SetTeamDropDown(){
        TeamList = new List<string>();
        foreach(Department d in DBManager.db.Departments){
            TeamList.Add(d.DepartmentName);
        }
        TeamDropdown.AddOptions(TeamList);
    }
    */
    
    public void SetCheckboxes(){
    
        foreach(int badgeid in curEmployee.Badges){
            GameObject b = Instantiate(BadgeSelectTogglePrefab, BadgeArea.transform, false);
            b.GetComponent<Badge>().SetBadgeImage(badgeid);
            foreach(int showingbadgeid in curEmployee.BadgestoShow){
                if(badgeid == showingbadgeid){
                    b.GetComponent<Toggle>().isOn = true;
                }
            }
        }

        foreach(int awardid in curEmployee.Awards){
            GameObject a = Instantiate(AwardSelectTogglePrefab, AwardArea.transform, false);
            a.GetComponent<Award>().SetAwardImage(awardid);
            if(awardid == curEmployee.AwardstoShow){
                a.GetComponent<Toggle>().isOn = true;
            }
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
    public void GetCheckboxes(){
        curEmployee.BadgestoShow.Clear();

        foreach(Transform child in BadgeArea.transform){
            if(child.gameObject.GetComponent<Toggle>().isOn){
                curEmployee.BadgestoShow.Add(child.GetComponent<Badge>().Bid);
            }
        }
        foreach(Transform child in AwardArea.transform){
            if(child.gameObject.GetComponent<Toggle>().isOn){
                curEmployee.AwardstoShow = child.GetComponent<Award>().Aid;
            }
        }
    }
    public string CheckValidity(){
        string Errmsg = "";
        /*if(NameInputfield.text == ""){
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
        */
        if(SysId.text == ""){
            Errmsg = "시스템 아이디는 공백이 허용되지 않습니다.";
            return Errmsg;
        }
        if(SysPw.text == ""){
            Errmsg = "시스템 비밀번호는 공백이 허용되지 않습니다.";
            return Errmsg;
        }
        foreach(Employee a in DBManager.db.Employees){
            if(SysId.text == a.SysID && a != curEmployee){
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

    public void EditMyPage(){
        GetCheckboxes();
        string err = CheckValidity();
        if(valid){
            string w = CheckDesirability();

            //DBManager.db.Employees[id].Employee_Name = NameInputfield.text;
            //DBManager.db.Employees[id].Employee_Age = int.Parse(AgeInputfield.text);
            //DBManager.db.Employees[id].Employee_Gender = GenderDropdown.value;
            //DBManager.db.Employees[id].Department = TeamDropdown.value;
            DBManager.db.Employees[id].PhoneNo = PhoneNo_1.text+"-"+PhoneNo_2.text+"-"+PhoneNo_3.text;
            DBManager.db.Employees[id].EmailAddress = EmailFront.text +"@" + EmailBehind.text;
            DBManager.db.Employees[id].Facetype = ProfileTypeDropdown.value;
            DBManager.db.Employees[id].SysID = SysId.text;
            DBManager.db.Employees[id].SysPw = SysPw.text;

            ProjectDBSelector.pdb.GetEmployeeDifference();

            if(desirable){
                
                GameObject.FindGameObjectWithTag("Mypage").GetComponent<Mypage>().SetMyPage(DBManager.db.Employees[id]);
                Destroy(this.gameObject);
                
            } 
            else{
                GameObject warning = Instantiate(WarningPanel,sortlayer.transform, false);
                GameObject warnmsg = GameObject.FindGameObjectWithTag("WarningMsg");
                warnmsg.GetComponent<TextMeshProUGUI>().text = w;
                GameObject.FindGameObjectWithTag("Mypage").GetComponent<Mypage>().SetMyPage(DBManager.db.Employees[id]);

            }
        }
    
        else{
            GameObject er = Instantiate(ErrorPanel, sortlayer.transform, false);
            GameObject errmsg = GameObject.FindGameObjectWithTag("ErrorMsg");
            errmsg.GetComponent<TextMeshProUGUI>().text = err;
        }
    }
}
