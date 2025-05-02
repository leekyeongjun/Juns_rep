using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
public class SingleRandomCard : MonoBehaviour
{

    Material rend;
    float progressSpeed = 0.4f;
    float pval = 1f;
    bool activated = false;
    public GameObject glow;
    public GameObject TodaysCard;

    // Start is called before the first frame update
    void Start()
    {
        rend = GetComponent<Image>().material;
        rend.SetFloat("_Progress", pval);
    }

    // Update is called once per frame
    void Update()
    {
        if(activated == true && pval > 0){
            rend.SetFloat("_Progress", pval);
            pval -= progressSpeed*Time.deltaTime;
        }
        else if(activated == true && pval <0){
            this.gameObject.SetActive(false);
            glow.SetActive(false);
        }
    }

    public void StartDissolving(){
        activated = true;
        
        TodaysCard.GetComponent<TodaysCard>().SetRandomCard();
    }
}
