using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using UnityEngine.UI;
using System;

public class ActivityDetails : MonoBehaviour
{

    public GameObject ActivitydetailsPanel;
    public CommentViewer commentViewer;
    public Slider ProgressRatioSlider;
    public TextMeshProUGUI ProgressValueText;

    public GameObject Scrolltextprefab;
    public GameObject DetailScrollviewContent;
    
    public TextMeshProUGUI ActivityNametext;
    public TextMeshProUGUI Writtentimetext;
    public TextMeshProUGUI Durationtext;

    public GameObject GadgetGrid;
    public GameObject GadgetBtnprefab;

    public GameObject ResultScrollviewContent;

    public GameObject FutureplanScrollviewContent;
    public GameObject NoteScrollviewContent;
    
    public GameObject ParticipantScrollviewContent;

    public GameObject Participantbtnprefab;

    public Scrollbar DetailScrollviewSlider;

    public GameObject CommentsArea;

    void Start(){
        commentViewer = CommentsArea.GetComponent<CommentViewer>();
    }
    public void SetActivityData(int pid, int tid, int aid){
        Activites a = DBManager.db.projects[pid].tasks[tid].activities[aid];
        if(a != null){
            DetailScrollviewSlider.value = 1;
            ClearEveryDetails();
            CommentsArea.SetActive(true);
            ActivityNametext.text = a.ActivityName;
            Writtentimetext.text = TimeManager.tm.GetTimeComparedtoNow(a.WrittenTime.ToDateTime());
            ActivitydetailsPanel.SetActive(true);
            ProgressRatioSlider.value = (float)a.ProgressRatio/100;
            ProgressValueText.text = (a.ProgressRatio + " %");
            SetString(a.ActivityDetails, DetailScrollviewContent);
            Durationtext.text = SetDuration(a.Duration);
            foreach(int gadgetid in a.Gadgetids){
                GameObject gadgetbtn = Instantiate(GadgetBtnprefab, GadgetGrid.transform, false);
                gadgetbtn.GetComponent<Gadgetbtn>().Setid(gadgetid);
            }
            SetString(a.Result, ResultScrollviewContent);
            SetString(a.FuturePlan, FutureplanScrollviewContent);
            SetString(a.Note, NoteScrollviewContent);
            foreach(int participantid in a.Participants){
                GameObject participantbtn = Instantiate(Participantbtnprefab, ParticipantScrollviewContent.transform, false);
                participantbtn.GetComponent<ParticipantBtn>().SetParticipantBtndata(participantid);
            }
            commentViewer = CommentsArea.GetComponent<CommentViewer>();
            commentViewer.SetCommentView(pid,tid,aid);
        }
    }

    public void SetString(string a, GameObject parent){
        GameObject curtext = Instantiate(Scrolltextprefab, parent.transform, false);
        TextMeshProUGUI curtextTMP = curtext.GetComponent<TextMeshProUGUI>();
        RectTransform curtextRect = curtext.GetComponent<RectTransform>();
        RectTransform parentRect = parent.GetComponent<RectTransform>();

        Vector2 defaultsize = curtextRect.sizeDelta;
        float targetHeight = defaultsize.y;

        curtextTMP.text = a;
        Vector2 preferredsize =  curtextTMP.GetPreferredValues(a);
        int heightenhancetime = (int)(preferredsize.x/defaultsize.x);

        for(int i = 0; i<heightenhancetime; i++){
            targetHeight += defaultsize.y;
        }

        if(targetHeight < preferredsize.y) targetHeight = preferredsize.y;

        //Debug.Log(a + " - preferredsize : " + preferredsize);
        curtextRect.sizeDelta = new Vector2(curtextRect.sizeDelta.x, targetHeight);
        parentRect.sizeDelta = new Vector2(parentRect.sizeDelta.x, targetHeight);
    }

    public string SetDuration(int a){
        string time;
        if((int)(a/60) != 0  && (int)(a%60) != 0) {
            time = ((int)(a/60)).ToString() + " 시간 " + ((int)(a%60)).ToString() + " 분";
            return time;
        }
        else if((int)(a/60) == 0  && (int)(a%60) != 0){
            time = ((int)(a%60)).ToString() + " 분";
            return time;
        }
        else if((int)(a/60) != 0  && (int)(a%60) == 0){
            time = ((int)(a/60)).ToString() + " 시간 ";
            return time;
        }
        else return "";
    }

    void ClearEveryDetails(){
        foreach(Transform child in DetailScrollviewContent.transform){
            Destroy(child.gameObject);
        }
        foreach(Transform child in ResultScrollviewContent.transform){
            Destroy(child.gameObject);
        }
        foreach(Transform child in FutureplanScrollviewContent.transform){
            Destroy(child.gameObject);
        }
        foreach(Transform child in NoteScrollviewContent.transform){
            Destroy(child.gameObject);
        }
        foreach(Transform child in GadgetGrid.transform){
            Destroy(child.gameObject);
        }
        foreach(Transform child in ParticipantScrollviewContent.transform){
            Destroy(child.gameObject);
        }
    }

}
