var buttonColours = ["red", "blue", "green", "yellow"];
var gamePattern = [];



nextSequence() {
    var randomNumber = Math.floor(Math.random() * 3);
    var randomChosenColour = nextSequence();
    gamePattern.push(randomChosenColour);
};
