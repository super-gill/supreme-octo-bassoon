


      var diceOutcomes = ["dice1.png","dice2.png","dice3.png","dice4.png","dice5.png","dice6.png"];

      var diceRollOne = Math.floor(Math.random()*6);
      var diceRollTwo = Math.floor(Math.random()*6);
    
      var playerOneSolution = diceOutcomes[diceRollOne];
      var playerTwoSolution = diceOutcomes[diceRollTwo];

      document.getElementsByClassName("img1")[0].setAttribute("src", playerOneSolution);
      document.getElementsByClassName("img2")[0].setAttribute("src", playerTwoSolution);

      if(diceRollOne>diceRollTwo) {
        document.querySelector("h1").innerHTML="Player One Wins!"
      } else if (diceRollOne<diceRollTwo) {
        document.querySelector("h1").innerHTML="Player Two Wins!"
      } else {
        document.querySelector("h1").innerHTML="Its a Draw!"
      }



