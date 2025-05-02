using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;
using Unity.VisualScripting;






public class ProjectHistorySidebar : MonoBehaviour
{

    public GameObject ScrollArea;
    public GameObject ProjectNameBtnPrefab;
    public GameObject TaskBlockPrefab;
    public GameObject TaskNameBtnPrefab;
    public GameObject ProjectCreateBtn;
    public GameObject separateline;
    NothingImage nothingImage;


    void Start() {
        nothingImage = GameObject.FindGameObjectWithTag("NothingImage").GetComponent<NothingImage>();
        if(AccountManager.am.loggedIn) StartCoroutine(SetProjectHistorySideBar(AccountManager.am.mydata.myemployeedata.Department));
        
    }
    public IEnumerator SetProjectHistorySideBar(int Department){


        //DBManager.db.GetProjectDB(projectManager, Department);
        //yield return new WaitUntil(()=> DBManager.db.isLoadingDB == false);

        ProjectDBSelector.pdb.SetCurrentProject(Department);

        
        foreach(Transform child in ScrollArea.transform){
            Destroy(child.gameObject);
        }
        if(DBManager.db.projects == null){
            Instantiate(ProjectCreateBtn, ScrollArea.transform, false);
            yield return null;
        } 
        else{
            if(DBManager.db.projects.Count == 0 ) nothingImage.ImageOn(true);
            else nothingImage.ImageOn(false);

            foreach(Project p in DBManager.db.projects){
                float tblksize = 0f;
                int pid = DBManager.db.projects.IndexOf(p);
                GameObject pbtn = Instantiate(ProjectNameBtnPrefab, ScrollArea.transform, false);
                pbtn.GetComponentInChildren<TextMeshProUGUI>().text = p.ProjectName;
                pbtn.GetComponentInChildren<TaskCreator>().setpid(pid);
                if(p.tasks.Count != 0){
                    GameObject tblk = Instantiate(TaskBlockPrefab, ScrollArea.transform, false);
                    foreach(Task t in p.tasks){
                        int tid = p.tasks.IndexOf(t);
                        GameObject tbtn = Instantiate(TaskNameBtnPrefab, tblk.transform, false);
                        tbtn.GetComponentInChildren<TextMeshProUGUI>().text = t.TaskName;
                        tbtn.GetComponent<ProjectSidebarbtn>().Getpidandtid(pid,tid);
                        tblksize += tbtn.GetComponent<RectTransform>().sizeDelta.y + 5;
                    }
                    tblk.GetComponent<RectTransform>().sizeDelta = new Vector2(1,tblksize);
                }
                Instantiate(separateline, ScrollArea.transform,false);
            }
            Instantiate(ProjectCreateBtn, ScrollArea.transform, false);
        }
        yield return null;
    }
}
