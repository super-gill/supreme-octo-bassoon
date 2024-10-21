let userSelection;
let computerSelection;
let randomNumber = Math.floor(Math.random * 2) + 1;
let history = [];
let level;
let pauseGame = true;

const title = document.querySelector("h1");
const redBTN = document.querySelector(".red");
const blueBTN = document.querySelector(".blue");
const redBTNValue = document.querySelector(".red").value;
const BlueBTNValue = document.querySelector(".blue").value;


pause();


function pause() {
  title.innerHTML = ("Game paused, click HERE to continue");
  if (pauseGame) {
    title.addEventListener("click", function () {
      title.innerHTML = ("Wait for the computer to go!");
      computerClick();
    })
  } return -1;
}

function computerClick() {
  if (pauseGame == true) {
    if (randomNumber == 1) {
      setTimeout(() => {
        redBTN.classList.add("pressed");
      }, 500);
      setTimeout(() => {
        redBTN.classList.remove("pressed");
      }, 600);
      computerSelection = 1;
      console.log("The computer chose the RED button");
      userClick();

    } else {
      setTimeout(() => {
        blueBTN.classList.add("pressed");
      }, 500);
      setTimeout(() => {
        blueBTN.classList.remove("pressed");
      }, 600);
      computerSelection = 2;
      console.log("The computer chose the BLUE button");
      userClick();
    }
  }
}

function userClick() {

  for (var i = 1; i <= 2; i++) {
    document.querySelectorAll(".btn")[i].addEventListener("click", function () {

      userSelection = this;

      if (userSelection.classList.contains("red")) {
        buttonClicked.classList.add("pressed");
        setTimeout(() => {
          userSelection.classList.remove("pressed");
        }, 100);
      } else {
        userSelection.classList.add("pressed");
        setTimeout(() => {
          userSelection.classList.remove("pressed");
        }, 100);
      }
    })
  }
}