using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class TalkManager : MonoBehaviour
{
    public string npcName;
    public string[] dialogs;
    public Sprite npcPort;

    public static TalkManager talkmanager;

    public GameObject[] NPC;


    void Awake() 
    {
        if (talkmanager == null)
            talkmanager = this;
 
        else if (talkmanager != this)
            Destroy(gameObject);
 
        DontDestroyOnLoad(gameObject);
    }


    public void GetNPCData(int id){
        if(NPC[id] != null){
            npcName = NPC[id].GetComponent<Npc>().Npcname;
            dialogs = NPC[id].GetComponent<Npc>().dialogs;
            npcPort = NPC[id].GetComponent<Npc>().NpcPort;
        }
    }

    public string GetDialog(int dialogIndex){
        if(dialogIndex == dialogs.Length) return null;
        else return dialogs[dialogIndex];
    }

    
}
