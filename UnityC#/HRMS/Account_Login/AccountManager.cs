using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AccountManager : MonoBehaviour
{
    public static AccountManager am;
    public Mydata mydata;
    public ActivityHistory LastviewedActivityHistory;
    public bool loggedIn = false;
    public bool LastviewedActivityHistoryExists = false;

    void Awake() {
        if(am == null) am = this;
        else if (am != this) Destroy(gameObject);
        DontDestroyOnLoad(gameObject);  
    }

    public void SetMyData(Employee m){
        mydata.myemployeedata = m;
        loggedIn = true;
    }

    public void DisposalMydata(){
        mydata.myemployeedata = null;
        loggedIn = false;
    }
}
