using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;


public class NewProjectHistorySideBar : MonoBehaviour
{

    public TextMeshProUGUI ProjectNameText;
    public TextMeshProUGUI ProjectDurationText;

    public Image ProjectProfile;
    public GameObject TaskBtnArea;

    public GameObject TaskNameBtnPrefab;
    public GameObject TaskAddBtnPrefab;

    public void SetTaskArea(int pid){
        Project p = DBManager.db.projects[pid];
        ProjectNameText.text = p.ProjectName;
        ProjectDurationText.text = "프로젝트 기간 | " + p.ProjectDuration;
        ProjectProfile.sprite = DBManager.db.ProjectProfiles[p.ProfileImageID];

        foreach(Transform child in TaskBtnArea.transform){
            Destroy(child.gameObject);
        }

        foreach(Task t in p.tasks){
            int tid = p.tasks.IndexOf(t);
            GameObject tbtn = Instantiate(TaskNameBtnPrefab, TaskBtnArea.transform, false);
            tbtn.GetComponent<TaskBtn>().SetTaskBtn(pid, tid);
        }
        GameObject tabtn = Instantiate(TaskAddBtnPrefab, TaskBtnArea.transform, false);
        tabtn.GetComponent<TaskCreateBtn>().setpid(pid);
    }

}
