using System.Collections;
using System.Collections.Generic;

using TMPro;
using UnityEngine;
using UnityEngine.UI;


public class ActivityHistoryBtn : MonoBehaviour
{
    ActivityHistory TargetAH;

    public TextMeshProUGUI ActivityHistoryLabelText;
    public TextMeshProUGUI CommentText;
    public TextMeshProUGUI DateText;

    public ParticipantBtn participantBtn;

    public void SetActivityHistoryLabel(ActivityHistory AH){
        TargetAH = AH;
        ActivityHistoryLabelText.text = TargetAH.activityHistoryLabel;
        DateText.text = TimeManager.tm.GetTimeComparedtoNow(TargetAH.WrittenTime.ToDateTime());
        if(TargetAH.status == ActivityHistory.Status.comment){
           CommentText.text = TargetAH.CommentData;
        }
        if(participantBtn){
            participantBtn.SetParticipantBtndata(TargetAH.Writer);
        }
    }

    public void OnButtonClick(){
        AccountManager.am.LastviewedActivityHistory = TargetAH;
        AccountManager.am.LastviewedActivityHistoryExists = true;
        LoadManager.lm.MoveScene("ProjectHistoryScene");
    }
}
