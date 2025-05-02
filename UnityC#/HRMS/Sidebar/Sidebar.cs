using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class Sidebar : MonoBehaviour
{
    public GameObject SidebarProfileblock;

    public Image profileImage;
    public TextMeshProUGUI WelcomeText;
    public TextMeshProUGUI SubText;


    void Start(){
        if(AccountManager.am.loggedIn){
            SidebarProfileblock.SetActive(true);
            Employee e = DBManager.db.Employees[AccountManager.am.mydata.myemployeedata.Id];

            profileImage.sprite = DBManager.db.FaceImageList[e.Facetype];
            WelcomeText.text = "Welcome, " + e.Employee_Name + " (" + DBManager.db.Departments[e.Department].DepartmentName + ", " + e.Rank + ")";
            SubText.text = e.PhoneNo + " | " + e.EmailAddress;
        }
        else{
            SidebarProfileblock.SetActive(false);
        }
    }
}
