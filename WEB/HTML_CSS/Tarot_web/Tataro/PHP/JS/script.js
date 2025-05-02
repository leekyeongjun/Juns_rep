// script.js 파일
let tarotData = { "tarotdata": [] }; // 초기화

window.onload = function() {
    fetchTarotData();
};

function fetchTarotData() {
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
            Initdictionary();
        })
        .catch(error => {
            console.error('There has been a problem with your fetch operation:', error);
        });
};

function displayCardNameAndImage(id) {
    const card = tarotData.Deck.find(card => card.Id === id);
    const imagePath = `Deck/${card.Id}.jpg`; // 이미지 경로 동적 생성
    if (card) {
        document.getElementById('cardDisplay').innerHTML += 
            //<a class = "CardContent" href = "cardDetails.html?arg=${id}"></a>
            `<div class = "CardBtn">
                <img class = "CardContent" src="${imagePath}" alt="${card.Name}">
                <a class = "CardContent" href = "https://leekyeongjun.github.io/Tataro/PHP/cardDetails.html?arg=${id}"></a>
                
            </div>`;
    }
     else {
        console.log('Card not found');
    }
  }

function displayCardByName(name) {
    const card = tarotData.Deck.find(card => card.Name === name);
    const display = document.getElementById('cardDisplay');
    if (card) {
        const imagePath = `Deck/${card.Id}.jpg`; // 이미지 경로 동적 생성
        display.innerHTML = `<div>${JSON.stringify(card, null, 2)}</div><img src="${imagePath}" alt="${card.Name}">`;
        
    } else {
        console.log('Card not found');
    }
}

function displayCardById(id) {
    const card = tarotData.Deck.find(card => card.Id === id);
    const display = document.getElementById('cardDisplay');
    if (card) {
        const imagePath = `Deck/${card.Id}.jpg`; // 이미지 경로 동적 생성
        display.innerHTML = `<div>${JSON.stringify(card, null, 2)}</div><img src="${imagePath}" alt="${card.Name}">`;
        
    } else {
        console.log('Card not found');
    }
}
function Initdictionary(){
    document.getElementById('cardDisplay').innerHTML = '';
    for (let id = 0; id <= 77; id++) {
        displayCardNameAndImage(id);
    }
}

  // 카테고리별 카드 출력 함수
function displayCardsByCategory(category) {
    console.log("Changed!")
    document.getElementById('cardDisplay').innerHTML = ''; // 카드 표시 영역 초기화
    var Major= document.getElementById("Major");
    var Sword= document.getElementById("Sword");
    var Cup= document.getElementById("Cup");
    var Pentacle= document.getElementById("Pentacle");
    var Wand= document.getElementById("Wand");

    if(Major.checked){
        for (let id = 0; id <= 21; id++) {
            displayCardNameAndImage(id);
        }
    }
    if(Cup.checked){
        for (let id = 22; id <= 35; id++) {
            displayCardNameAndImage(id);
        }      
    }
    if(Pentacle.checked){
        for (let id = 36; id <= 49; id++) {
            displayCardNameAndImage(id);
        } 
    }
    if(Sword.checked){
        for (let id = 50; id <= 63; id++) {
            displayCardNameAndImage(id);
        } 
    }
    if(Wand.checked){
        for (let id = 64; id <= 77; id++) {
            displayCardNameAndImage(id);
        } 
    }
    if(!Major.checked && !Cup.checked && !Pentacle.checked && !Sword.checked && !Wand.checked){
        for (let id = 0; id <= 77; id++) {
            displayCardNameAndImage(id);
        }
    }


}
  