using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class menu_configure : MonoBehaviour
{

    
    public List<string> menus = new List<string>();
    string product;
    string temperture = " 뜨겁게 ";
    string shots= " 샷 : 1개 ";
    public int _num = 1;
    numcontrol N;

    public Text objtext;
    public ScrollRect scroll_rect;
    
    void Start()
    {
        N = GameObject.Find("number").GetComponent<numcontrol>();
    }

    public void ame_click()
    {
        product = "아메리카노";
    }

    public void latte_click()
    {
        product = "카페라떼";
    }
    public void icetea_click()
    {
        product = "아이스티";
    }
    public void icechoco_click()
    {
        product = "아이스초코";
    }


    public void appendhottemp(Toggle hot)
    {
        if(hot.isOn)
        {
            temperture = " 뜨겁게 ";
        }

        else
        {
            temperture = " 아이스 ";
        }
    }

    public void appendicetemp(Toggle ice)
    {
        if(ice.isOn)
        {
            temperture = " 아이스 ";
        }

        else
        {
            temperture = " 뜨겁게 ";
        }
    }

    public void appendshot(Toggle shot)
    {
        if(shot.isOn)
        {
            shots = " 샷 : 1개 ";
        }

        else
        {
            shots = " 샷 : 2개 ";
        }
    }
    public void appendshot2(Toggle shot2)
    {
        if(shot2.isOn)
        {
            shots = " 샷 : 2개 ";
        }

        else
        {
            shots = " 샷 : 1개 ";
        }
    }


    public void appendmenu()
    {
        string f_product;
        if (product == "아이스티"||product == "아이스초코")
        {
            f_product = " " + product + " / " + N.num.ToString() + "잔 "; 
        }
        else
        {
            f_product = " " + product + temperture + ", "+ shots + " / " + N.num.ToString() + "잔 ";
        }

        menus.Add(f_product);
        objtext.text += menus[menus.Count-1]+"\n";
        scroll_rect.verticalNormalizedPosition = 0.0f;
    }

    public void deleteall()
    {
        objtext.text = "";
        menus.Clear(); 
    }

}
