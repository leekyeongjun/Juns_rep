using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;
using System.Linq;

public class ParticipantBtn : MonoBehaviour
{
    public TextMeshProUGUI participantName;
    public Image participantImage;
    public TextMeshProUGUI participantRank;
    public TextMeshProUGUI ParticipantWork;
    public TextMeshProUGUI participantCommu;
    public GameObject TeamLeaderTag;

    public Employee participant;
    public GameObject ParticipantMypagepanelPrefab;
    public GameObject sortlayer;

    void Start(){
        sortlayer = GameObject.FindWithTag("MiniPanelSortLayer");
    }
    public void SetParticipantBtndata(int id){
        participant = DBManager.db.Employees[id];
        if(participantName != null) participantName.text = participant.Employee_Name;
        if(participantImage != null)participantImage.sprite = DBManager.db.FaceImageList[participant.Facetype];
        if(participantRank != null)participantRank.text = participant.Rank;
        if(ParticipantWork != null)ParticipantWork.text = participant.WorkArea;
        /*
        if(participantCommu!= null && participant.CommunicationStyle != null ){
            if(participant.CommunicationStyle.Count > 0) participantCommu.text = "# " + participant.CommunicationStyle.First();
            else if(participant.CustomCommunicationStyle.Count>0) participantCommu.text = "# " + participant.CustomCommunicationStyle.First();
        }
        */
        if(TeamLeaderTag != null){
            if(DBManager.db.Departments[participant.Department].TeammateIDs.IndexOf(participant.Id) == 0){
                TeamLeaderTag.SetActive(true);
            }
            else{
                TeamLeaderTag.SetActive(false);
            }
        }

    }

    public void OnbuttonClick(){
        GameObject p = Instantiate(ParticipantMypagepanelPrefab, sortlayer.transform, false);
        p.GetComponent<MypagePanel>().SetMypagePanel(participant);
    }
    
}
