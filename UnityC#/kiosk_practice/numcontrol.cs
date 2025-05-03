using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class numcontrol : MonoBehaviour
{
    public Text numtext;
    public int num = 1;
    
    public void addnum()
    {
        num = num+1;
        numtext.text = num.ToString();
    }

    public void minnum()
    {
        if(num ==1)
        {
            num = 1;
        }
        else
        {
            num = num-1;
        }
        
        numtext.text = num.ToString();
    }
}
