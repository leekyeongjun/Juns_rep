using System.Collections;
using System.Collections.Generic;

using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class ProjectHistoryBtn : MonoBehaviour
{
    // Start is called before the first frame update
    
    public TextMeshProUGUI ProjectNameText;
    public TextMeshProUGUI ProjectDurationText;

    public Image ProjectProfile;
    public int pid;

    ProjectViewer projectViewer;

    void Start(){
        projectViewer = GameObject.FindGameObjectWithTag("ProjectViewer").GetComponent<ProjectViewer>();
    }
    public void OnProjectHistoryBtnClick(){
        projectViewer.OpenTasksPanel(pid);

    }

    public void SetProjectBtnInfo(int _pid){
        pid = _pid;
        ProjectNameText.text = DBManager.db.projects[pid].ProjectName;
        ProjectProfile.sprite = DBManager.db.ProjectProfiles[DBManager.db.projects[pid].ProfileImageID];
        ProjectDurationText.text = "프로젝트 기간 | " + DBManager.db.projects[pid].ProjectDuration;
    }
}
