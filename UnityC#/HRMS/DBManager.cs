using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UGS;
using System.Linq;
using Unity.VisualScripting;

public class DBManager : MonoBehaviour
{

    //가변
    public static DBManager db;

    public List<Employee> Employees; 
    public List<Department> Departments;

    public List<ActivityHistory> activityHistories;
    public List<Project> projects;

    //불변
    public List<Gadget> gadgetList;
    public List<Sprite> FaceImageList;
    public List<string> FaceImageExplain;
    public List<string> WorkingStyleList;
    public List<string> CommunicationStyleList;
    public List<string> BestPerformaceList;

    public List<Sprite> ProjectProfiles;
    
    public List<BadgeData> Badges;
    public List<AwardData> Awards;

    public bool isLoadingDB = false;

    void Awake() {
        if(db == null) db = this;
        else if (db != this) Destroy(gameObject);
        DontDestroyOnLoad(gameObject);  
    }



}
