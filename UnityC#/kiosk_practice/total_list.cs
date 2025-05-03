using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class total_list : MonoBehaviour
{
    menu_configure my_M;
    public Text f_txt;
    public ScrollRect listscroll;

    void Start()
    {
        my_M = GameObject.Find("메뉴들").GetComponent<menu_configure>();
    }

    public void show_list()
    {
        for(int i =0; i<my_M.menus.Count; i++)
        {
            f_txt.text += my_M.menus[i] + "\n";
        }
    }

    public void delete_list()
    {
        f_txt.text = "";
        listscroll.verticalNormalizedPosition = 0.0f;
    }
}
