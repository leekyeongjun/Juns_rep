using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Gadgetbtn : MonoBehaviour
{
    Image btnimage;
    public int id;


    void Awake(){
        btnimage = GetComponent<Image>();
    }
    public void Setid(int _id){
        id = _id;
        btnimage.sprite = DBManager.db.gadgetList[_id].ImageSource;

    }


}
