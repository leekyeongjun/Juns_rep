using System.Collections;
using System.Collections.Generic;
using JetBrains.Annotations;
using UnityEngine;
using UnityEngine.UI;
using TMPro;
using System.Numerics;
using System.Linq;
using Unity.VisualScripting;

public class TripleCardDiary : MonoBehaviour
{
    public List<int> selected;
    public GameObject CardSelectPanel;
    public GameObject CardScrollViewContent;
    public GameObject cardButtonPrefab;
    public List<Image> SelectedCards;
    public List<TextMeshProUGUI> KeywordTexts;

    public Sprite defaultImage;

    public int cardpos = 0;


    // Start is called before the first frame update
    void Start()
    {
        selected = Enumerable.Repeat(-1,78).ToList();
        SetCardList();
        CardSelectPanel.SetActive(false);

    }

    // Update is called once per frame
    void Update()
    {
        
    }
    void SetCardList(){
        foreach(CardInfo info in CardManager.CM.cardInfos){
            GameObject t = Instantiate(cardButtonPrefab, CardScrollViewContent.transform);
            t.GetComponent<CardButton>().SetCardInfo(info);
        }
    }
    public void CardInfoRenewal(CardInfo info){
        int selectedpos = -1;
        for(int i = 0; i<78; i++){
            if(selected[info.Id] != -1){
                // 이미 선택됨
                selectedpos = selected[info.Id];
            }
        }

        if(selectedpos == -1){
            SelectedCards[cardpos].sprite = info.Image;
            string keywords = "";
            foreach(string keyword in info.Keyword){
                keywords += keyword + " ";
            }
            KeywordTexts[cardpos].text = keywords;
            selected[info.Id] = cardpos;
            Debug.Log("겹치는 카드 없음.");
        }
        else{
            if(selectedpos == cardpos){
                Debug.Log("겹치는 카드 있음. 같은 위치임");
                SelectedCards[cardpos].sprite = defaultImage;
                KeywordTexts[cardpos].text = "";
                selected[info.Id] = -1;
            }
            else{
                Debug.Log("겹치는 카드 있음. 다른 위치임");
                SelectedCards[selectedpos].sprite = defaultImage;
                KeywordTexts[selectedpos].text = "";

                SelectedCards[cardpos].sprite = info.Image;
                string keywords = "";
                foreach(string keyword in info.Keyword){
                    keywords += keyword + " ";
                }
                KeywordTexts[cardpos].text = keywords;
                selected[info.Id] = cardpos;
            }
        }
        CardSelectPanel.SetActive(false);
         
    }

    public void OpenCardList(int pos){
        cardpos = pos;
        CardSelectPanel.SetActive(true);
    }
}
