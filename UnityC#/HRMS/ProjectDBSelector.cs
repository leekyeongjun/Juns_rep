using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO;

[System.Serializable]
public class ServerProjects{
    public List<Project> ServerProject = new List<Project>();
    public List<Project> GetServerProjectDB(){
        return ServerProject;
    }

    public void SetServerProjectDB(List<Project> db){
        ServerProject = db;
    }

}

[System.Serializable]
public class ServerActivityHistories{
    public List<ActivityHistory> ServerActivity = new List<ActivityHistory>();

    public List<ActivityHistory> GetActivityHistoryDB(){
        return ServerActivity;
    }
    public void SetServerActivity(List<ActivityHistory> adb){
        ServerActivity = adb;
    }
}

[System.Serializable]
public class ServerEmployees{
    public List<Employee> TotalEmployees = new List<Employee>();

    public List<Employee> GetEmployeeDB(){
        return TotalEmployees;
    }
    public void SetServerEmployee(List<Employee> edb){
        TotalEmployees = edb;
    }
}

[System.Serializable]
public class ServerDepartments{
    public List<Department> TotalDepartment = new List<Department>();

    public List<Department> GetEmployeeDB(){
        return TotalDepartment;
    }
    public void SetServerEmployee(List<Department> ddb){
        TotalDepartment = ddb;
    }
}


public class ProjectDBSelector : MonoBehaviour
{

    public static ProjectDBSelector pdb;

    public List<ServerProjects> TotalProject;
    public List<ServerActivityHistories> TotalActivityHistory;

    public ServerEmployees TotalEmployeeDB;

    public ServerDepartments TotalDepartmentDB;


    public bool isLoadingDB;


    void Awake() {
        if(pdb == null) pdb = this;
        else if (pdb != this) Destroy(gameObject);
        DontDestroyOnLoad(gameObject);  
    }

    public void SetCurrentProject(int DepartmentID){
        LoadProjectbyJson(DepartmentID);
        LoadActivitybyJson(DepartmentID);

        DBManager.db.projects = TotalProject[DepartmentID].GetServerProjectDB();
        DBManager.db.activityHistories = TotalActivityHistory[DepartmentID].GetActivityHistoryDB();
    }

    public void GetDBDifference(int DepartmentID){
        TotalProject[DepartmentID].SetServerProjectDB(DBManager.db.projects);
        TotalActivityHistory[DepartmentID].SetServerActivity(DBManager.db.activityHistories);

        SaveProjecttoJson(DepartmentID);
        SaveActivitytoJson(DepartmentID);
    }

    public void SetEmployeeDB(){
        LoadEmployeebyJson();
        LoadDepartmentbyJson();

        DBManager.db.Employees = TotalEmployeeDB.TotalEmployees;
        DBManager.db.Departments = TotalDepartmentDB.TotalDepartment;
    }

    public void GetEmployeeDifference(){

        TotalEmployeeDB.TotalEmployees = DBManager.db.Employees;
        TotalDepartmentDB.TotalDepartment = DBManager.db.Departments;
        SaveEmployeetoJson();
        SaveDepartmenttoJson();
    }



    //Saves
    void SaveProjecttoJson(int i){
        isLoadingDB = true;
        string jsonData = JsonUtility.ToJson(TotalProject[i], true);
        string path = Path.Combine(Application.persistentDataPath+"/Database/Projects", "Project"+"_"+i.ToString()+".json");
        File.WriteAllText(path,jsonData);
        isLoadingDB = false;
    }

    void SaveActivitytoJson(int i){
        isLoadingDB = true;
        string jsonData = JsonUtility.ToJson(TotalActivityHistory[i], true);
        string path = Path.Combine(Application.persistentDataPath+"/Database/ActivityHistories", "ActivityHistory"+"_"+i.ToString()+".json");
        File.WriteAllText(path,jsonData);
        isLoadingDB = false;
    }

    void SaveEmployeetoJson(){
        isLoadingDB = true;
        string jsonData = JsonUtility.ToJson(TotalEmployeeDB, true);
        string path = Path.Combine(Application.persistentDataPath+"/Database/Employees", "EmployeeData.json");
        File.WriteAllText(path,jsonData);
        isLoadingDB = false;
    }

    void SaveDepartmenttoJson(){
        isLoadingDB = true;
        string jsonData = JsonUtility.ToJson(TotalDepartmentDB, true);
        string path = Path.Combine(Application.persistentDataPath+"/Database/Departments", "DepartmentData.json");
        File.WriteAllText(path,jsonData);
        isLoadingDB = false;
    }

    //Loads
    void LoadProjectbyJson(int i){
        isLoadingDB = true;
        string path = Path.Combine(Application.persistentDataPath+"/Database/Projects",  "Project"+"_"+i.ToString()+".json");
        string jsonData = File.ReadAllText(path);
        TotalProject[i] = JsonUtility.FromJson<ServerProjects>(jsonData);
        isLoadingDB = false;
    }

    void LoadActivitybyJson(int i){
        isLoadingDB = true;
        string path = Path.Combine(Application.persistentDataPath+"/Database/ActivityHistories",  "ActivityHistory"+"_"+i.ToString()+".json");
        string jsonData = File.ReadAllText(path);
        TotalActivityHistory[i] = JsonUtility.FromJson<ServerActivityHistories>(jsonData);
        isLoadingDB = false;
    }

    void LoadEmployeebyJson(){
        isLoadingDB = true;
        string path = Path.Combine(Application.persistentDataPath+"/Database/Employees",  "EmployeeData.json");
        string jsonData = File.ReadAllText(path);
        TotalEmployeeDB = JsonUtility.FromJson<ServerEmployees>(jsonData);
        isLoadingDB = false;
    }
    void LoadDepartmentbyJson(){
        isLoadingDB = true;
        string path = Path.Combine(Application.persistentDataPath+"/Database/Departments",  "DepartmentData.json");
        string jsonData = File.ReadAllText(path);
        TotalDepartmentDB = JsonUtility.FromJson<ServerDepartments>(jsonData);
        isLoadingDB = false;
    }


    [ContextMenu("Json Load")]
    public void TestLoading(){
        LoadEmployeebyJson();
        LoadDepartmentbyJson();
        LoadProjectbyJson(0);
        LoadProjectbyJson(1);

        LoadActivitybyJson(0);
        LoadActivitybyJson(1);
    }

    [ContextMenu("Json Save")]
    public void TestSaving(){
        SaveEmployeetoJson();
        SaveDepartmenttoJson();
        SaveProjecttoJson(0);
        SaveProjecttoJson(1);

        SaveActivitytoJson(0);
        SaveActivitytoJson(1);
    }
}
