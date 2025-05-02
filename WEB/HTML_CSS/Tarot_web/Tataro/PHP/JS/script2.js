let tarotData = { "tarotdata": [] }; // 초기화
let item;

window.onload = function() {
    fetchSingleTarotData();
};

function getQueryStringParam(param) {
    const queryString = window.location.search.substring(1);
    const vars = queryString.split('&');
    for (let i = 0; i < vars.length; i++) {
        const pair = vars[i].split('=');
        if (decodeURIComponent(pair[0]) === param) {
            return decodeURIComponent(pair[1]);
        }
    }
    return null;
}

function fetchSingleTarotData(){
    fetch('https://leekyeongjun.github.io/Tataro/Json/TarotInfo.json')
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then(data => {
            tarotData = data;
            console.log('Tarot data loaded successfully');
        })
        .then(data => {
            let curid = getQueryStringParam('arg');
            return curid;
        })
        .then(curid => {
            console.log(curid);
            GetSingleCardById(curid);
        })
        .catch(error => {
            console.error('There has been a problem with your fetch operation:', error);
        });
}

function GetSingleCardById(id) {
    const card = tarotData.Deck[id];
    console.log(card);
    if (card) {
        const imagePath = `Deck/${card.Id}.jpg`; // 이미지 경로 동적 생성
        document.getElementById('cardDisplay').innerHTML +=
            `<img class = "Imageblock" src="${imagePath}" alt="${card.Name}">
            <div class = "Nameblock"> ${card.Name} </div>
            
            ${GetCardSingleValue(card, "Description")}
            ${GetCardArrayValues(card, "Keyword")}
            ${GetCardArrayValues(card, "Love")}
            ${GetCardArrayValues(card, "Relationship")}
            ${GetCardArrayValues(card, "Money")}
            ${GetCardArrayValues(card, "Work")}
            ${GetCardArrayValues(card, "ReMeet")}
            ${GetCardArrayValues(card, "Contact")}
            ${GetCardArrayValues(card, "Travel")}
            ${GetCardArrayValues(card, "MoveJob")}
            ${GetCardArrayValues(card, "Health")}
            ${GetCardArrayValues(card, "Place")}
            ${GetCardArrayValues(card, "Mood")}
            ${GetCardSingleValue(card, "Numerlogy")}
            ${GetCardArrayValues(card, "Advice", "<br>")}
            ${GetCardArrayValues(card, "Warning", "<br>")}
            ${GetCardTupleValues(card, "Etc", "<br>")}
            `
            
    } else {
        console.log('Card not found');
    }
}
function GetCardSingleValue(card, keyword){
    let value = `
        <div class = "ContentBlock" id = "${keyword}">
        <div class = "ContentTitle">
            ${GetIcon(keyword)}
            ${GetKeywordInKorean(keyword)}
        </div>
        <div class = "Content">
            ${
                card[keyword]
            }
        </div>
    `
    return value;
}
function GetCardArrayValues(card, keyword, delimeter = ' / '){
    let value = `
        <div class = "ContentBlock" id = "${keyword}">
            <div class = "ContentTitle">
                ${GetIcon(keyword)}
                ${GetKeywordInKorean(keyword)}
            </div>
            <div class = "Content">
                ${
                    card[keyword].map((kw, index, array) => 
                    `${kw}${index === array.length - 1 ? '' : delimeter}`
                    ).join('')
                }
            </div>
    `
    return value;
}
function GetCardTupleValues(card, keyword){
    let value = `
        <div class = "ContentBlock" id = "${keyword}">
            <div class = "ContentTitle">
                ${GetIcon(keyword)}
                ${GetKeywordInKorean(keyword)}
            </div>
            <div class = "Content">
                ${
                    card[keyword].map((kw, array) => 
                    `<br><div class = "bold-text">${kw.Title}</div><br>
                    ${kw.Content}<br><br>
                    `).join('')
                }
        </div>
    `;
    return value;
}

function GetKeywordInKorean(keyword){
    let krKeyword;
    if(keyword === "Description"){
        krKeyword = "카드 설명";
    }else if(keyword === "Keyword"){
        krKeyword = "키워드";
    }else if(keyword === "Love"){
        krKeyword = "애정운";
    }else if(keyword === "Relationship"){
        krKeyword = "관계운";
    }else if(keyword === "Money"){
        krKeyword = "금전운";
    }else if(keyword === "Work"){
        krKeyword = "학업/사업운";
    }else if(keyword === "ReMeet"){
        krKeyword = "재회운";
    }else if(keyword === "Contact"){
        krKeyword = "계약운";
    }else if(keyword === "Travel"){
        krKeyword = "이동/여행운";
    }else if(keyword === "MoveJob"){
        krKeyword = "이직운";
    }else if(keyword === "Health"){
        krKeyword = "건강운";
    }else if(keyword === "Place"){
        krKeyword = "장소";
    }else if(keyword === "Mood"){
        krKeyword = "기분";
    }else if(keyword === "Numerlogy"){
        krKeyword = "수비학적 의미";
    }else if(keyword === "Advice"){
        krKeyword = "조언의 의미로 해석할 때";
    }else if(keyword === "Warning"){
        krKeyword = "경고의 의미로 해석할 때";
    }else if(keyword === "Etc"){
        krKeyword = "상징과 의미";
    }else{
        krKeyword = "에러";
    } return krKeyword;
}

function GetIcon(keyword){
    let krKeyword;
    if(keyword === "Description"){
        krKeyword = `<i class="fi fi-br-square-quote"></i>`;
    }else if(keyword === "Keyword"){
        krKeyword = `<i class="fi fi-br-key"></i>`;
    }else if(keyword === "Love"){
        krKeyword = `<i class="fi fi-br-square-heart"></i>`;
    }else if(keyword === "Relationship"){
        krKeyword = `<i class="fi fi-br-link-alt"></i>`;
    }else if(keyword === "Money"){
        krKeyword = `<i class="fi fi-br-coins"></i>`;
    }else if(keyword === "Work"){
        krKeyword = `<i class="fi fi-br-attribution-pencil"></i>`;
    }else if(keyword === "ReMeet"){
        krKeyword = `<i class="fi fi-br-sad-tear"></i>`;
    }else if(keyword === "Contact"){
        krKeyword = `<i class="fi fi-br-budget-alt"></i>`;
    }else if(keyword === "Travel"){
        krKeyword = `<i class="fi fi-br-suitcase-alt"></i>`;
    }else if(keyword === "MoveJob"){
        krKeyword = `<i class="fi fi-br-building"></i>`;
    }else if(keyword === "Health"){
        krKeyword = `<i class="fi fi-br-doctor"></i>`;
    }else if(keyword === "Place"){
        krKeyword = `<i class="fi fi-br-trees"></i>`;
    }else if(keyword === "Mood"){
        krKeyword = `<i class="fi fi-br-grin-squint-tears"></i>`;
    }else if(keyword === "Numerlogy"){
        krKeyword = `<i class="fi fi-br-calculator-simple"></i>`;
    }else if(keyword === "Advice"){
        krKeyword = `<i class="fi fi-br-hand-back-point-ribbon"></i>`;
    }else if(keyword === "Warning"){
        krKeyword = `<i class="fi fi-br-triangle-warning"></i>`;
    }else if(keyword === "Etc"){
        krKeyword = `<i class="fi fi-br-asterik"></i>`;
    }else{
        krKeyword = `<i class="fi fi-br-seal-exclamation"></i>`;
    } return krKeyword;
}