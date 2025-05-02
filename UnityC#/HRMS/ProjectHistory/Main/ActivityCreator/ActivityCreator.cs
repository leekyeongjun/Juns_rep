using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using UnityEngine.UI;
using Unity.VisualScripting;
using System;

public class ActivityCreator : MonoBehaviour
{

    ProjectViewer projectViewer;

    int pid,tid;
    Employee m;
    public GameObject confirmBtn;

    public TMP_InputField ActivityNameInputfield;
    public TMP_InputField ActivityDetailsInputfield;

    public TMP_Dropdown HourDropdown;
    public TMP_Dropdown MinuteDropdown;

    public GameObject ParticipantContentview;
    public GameObject ParticipantTogglePrefab;

    List<ParticipantToggle> participantToggles;
    List<int> JoinedParticipantsIDList;

    public Slider ProgressRateSlider;
    public TextMeshProUGUI ProgressRateValue;
    public TMP_InputField ResultInputfield;
    public GameObject GadgetselectArea;

    public GameObject GadgetTogglePrefab;
    public GameObject GadgetAddBtn;

    List<GadgetToggle> GadgetToggles;
    List<int> UsedGadgetidList;

    public TMP_InputField FuturePlanInputfield;
    public TMP_InputField NoteInputfield;
    public bool valid = false;
    public bool desirable = false;

    GameObject sortlayer;
    public GameObject ErrorPanel;
    public GameObject WarningPanel;

    void Start(){
        ProjectDBSelector.pdb.SetEmployeeDB();
        sortlayer = GameObject.FindWithTag("MiniPanelSortLayer");
        projectViewer = GameObject.FindWithTag("ProjectViewer").GetComponent<ProjectViewer>();
    }

    public void SetIds(int _pid, int _tid, Employee _m){
        pid = _pid;
        tid = _tid;
        m = _m;
    }
    public void SetToggles(){
        foreach(int e in DBManager.db.Departments[m.Department].TeammateIDs){
            GameObject ptoggle = Instantiate(ParticipantTogglePrefab, ParticipantContentview.transform, false);
            ParticipantToggle pt = ptoggle.GetComponent<ParticipantToggle>();
            pt.employeeId = e;
            pt.Toggletext.text = DBManager.db.Employees[e].Employee_Name;
            participantToggles.Add(pt);
        }

        foreach(Gadget g in DBManager.db.gadgetList){
            GameObject gtoggle = Instantiate(GadgetTogglePrefab, GadgetselectArea.transform, false);
            GadgetToggle gt = gtoggle.GetComponent<GadgetToggle>();
            gt.toggleimage.sprite = g.ImageSource;
            GadgetToggles.Add(gt);
        }
    }

    public void PanelOff(){
        projectViewer.OpenActivityList(pid,tid);
        Destroy(gameObject);
    }

    public void StartActivityCreator(int _pid, int _tid, Employee _m){
        SetIds(_pid, _tid, _m);

        ActivityNameInputfield.text = "";
        ActivityDetailsInputfield.text = "";
        HourDropdown.value = 0;
        MinuteDropdown.value = 0;

        foreach(Transform child in ParticipantContentview.transform){
            Destroy(child.gameObject);
        }
        foreach(Transform child in GadgetselectArea.transform){
            Destroy(child.gameObject);
        }
        ProgressRateSlider.value = 0;
        participantToggles = new List<ParticipantToggle>();
        JoinedParticipantsIDList = new List<int>();
        GadgetToggles = new List<GadgetToggle>();
        UsedGadgetidList = new List<int>();
        FuturePlanInputfield.text = "";
        NoteInputfield.text = "";

        SetToggles();
    }
    public void ProgressRateTextChange(){
        ProgressRateValue.text = ((int)(ProgressRateSlider.value*100)).ToString() + " %";
    }
    public void CheckToggles(){
        foreach(ParticipantToggle pt in participantToggles){
            if(pt.toggle.isOn) JoinedParticipantsIDList.Add(pt.employeeId);
        }
        UsedGadgetidList.Clear();
        
        foreach(GadgetToggle gt in GadgetToggles){
            if(gt.toggle.isOn) UsedGadgetidList.Add(GadgetToggles.IndexOf(gt));
        }
    }

    public string CheckValidity(){
        string Errmsg = "";
        if(ActivityNameInputfield.text == ""){
            Errmsg = "액티비티 이름은 필수 기입 사항입니다.";
            return Errmsg;
        }
        if(ActivityDetailsInputfield.text == "") {
            Errmsg = "액티비티 내용은 필수 기입 사항입니다.";
            return Errmsg;
        }
        if(JoinedParticipantsIDList.Count == 0) {
            Errmsg = "참여 인원은 필수 기입 사항입니다.";
            return Errmsg;
        }   
        if(HourDropdown.value == 0 && MinuteDropdown.value == 0){
            Errmsg = "진행 시간은 필수 기입 사항입니다.";
            return Errmsg;
        }
        if(ResultInputfield.text == ""){
            Errmsg = "액티비티 결과는 필수 기입 사항입니다.";
            return Errmsg;
        }
        valid = true;
        return Errmsg;
    }

    public string CheckDesirability(){
        string Warningmsg = "";
        if(UsedGadgetidList.Count == 0){
            Warningmsg += "\n 사용 툴이 없습니다. 이후 확인시 \n사용 툴에는 아무것도 표기되지 않습니다.";
        }
        if(FuturePlanInputfield.text == ""){
            Warningmsg += "\n 추후 계획이 없습니다. 이후 확인시 \n추후 계획에는 아무것도 표기되지 않습니다." ;
        }
        if(ProgressRateSlider.value == 0){
            Warningmsg += "\n 업무 진행도가 0%입니다. 이후 확인시 \n업무 진행도는 0%로 표기됩니다.";
        }
        if(Warningmsg == "") desirable = true;

        return Warningmsg;
    }

    public void CheckCreateActivity(){
        CheckToggles();
        string e = CheckValidity();
        
        if(valid){
            string w = CheckDesirability();
            CreateActivity();
            if(desirable){
                PanelOff();
            }
            else{
                Debug.Log("Warning!");
                GameObject warning = Instantiate(WarningPanel,sortlayer.transform, false);
                GameObject warnmsg = GameObject.FindGameObjectWithTag("WarningMsg");
                warnmsg.GetComponent<TextMeshProUGUI>().text = w;
                PanelOff();
            }
        }
        else{
            GameObject err = Instantiate(ErrorPanel, sortlayer.transform, false);
            GameObject errmsg = GameObject.FindGameObjectWithTag("ErrorMsg");
            errmsg.GetComponent<TextMeshProUGUI>().text = e;
        }


    }

    public void CreateActivity(){
        if(valid == true){
            Activites a = new(){
                ActivityName = ActivityNameInputfield.text,
                ActivityDetails = ActivityDetailsInputfield.text,
                Duration = HourDropdown.value * 60 + MinuteDropdown.value,
                Participants = JoinedParticipantsIDList,
                Gadgetids = UsedGadgetidList,
                Result = ResultInputfield.text,
                ProgressRatio = (int)(ProgressRateSlider.value*100),
                Note = NoteInputfield.text,
                FuturePlan = FuturePlanInputfield.text,
                Comments = new List<Comment>(),

                WriterID = m.Id,
                WrittenTime = new MTime(DateTime.Now)
                
            };
            DBManager.db.projects[pid].tasks[tid].activities.Add(a);
            Debug.Log(a.WrittenTime.ToString());
            ActivityHistory ah = new();
            ah.SetActivitiesActivityHistory(pid, tid, DBManager.db.projects[pid].tasks[tid].activities.IndexOf(a), AccountManager.am.mydata.myemployeedata, new MTime(DateTime.Now));
            DBManager.db.Employees[AccountManager.am.mydata.myemployeedata.Id].PersonalActivityHistories.Add(ah);
            DBManager.db.activityHistories.Add(ah);
            ProjectDBSelector.pdb.GetDBDifference(AccountManager.am.mydata.myemployeedata.Department);
            ProjectDBSelector.pdb.GetEmployeeDifference();
        }
    }
}