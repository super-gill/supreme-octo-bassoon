const gameBoard = document.getElementById("game-board");
const squares = document.querySelectorAll(".square");
const message = document.getElementById("game-message");
const resetButton = document.getElementById("reset-button");
let currentPlayer = "X";

squares.forEach((square) => {
  square.addEventListener("click", () => {
    if (square.textContent !== "") return;
    square.textContent = currentPlayer;
    console.log("check for win");
    checkForWin();
    currentPlayer = currentPlayer === "X" ? "O" : "X";
  });
});

function checkForWin() {
  const rows = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
  ];
  const cols = [
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
  ];
  const diagonals = [
    [0, 4, 8],
    [2, 4, 6],
  ];
  const lines = [...rows, ...cols, ...diagonals];
  for (let line of lines) {
    const [a, b, c] = line;
    if (
      squares[a].textContent === squares[b].textContent &&
      squares[b].textContent === squares[c].textContent &&
      squares[a].textContent !== ""
    ) {
      console.log("win detected");
      message.textContent = `Player ${currentPlayer} wins!`;
      squares.forEach((square) => {
        square.removeEventListener("click", handleClick);
      });
      return;
    }
  }
}

function computerMove() {
  if (gameBoard[4] === "" ) {
    gameBoard[4] = aiPlayer;
    squares[4].textContent = aiPlayer;
    return;
  }

  const corners = [0, 2, 6, 8];
  const emptyCorners = corners.filter((i) => gameBoard[i] === "");
  if (emptyCorners.length > 0) {
    const randomIndex = Math.floor(Math.random() * emptyCorners.lenth);
    const cornerIndex = emptyCorners[randomIndex];
    gameBoard[cornerIndex] = aiPlayer;
    squares[cornerIndex].textContent = aiPlayer;
    return;
  }

  while (true) {
    const randomIndex = Math.floor(Math.random() * 9);
    if (gameBoard[randomIndex] === "") {
      gameBoard[randomIndex] = aiPlayer; 
      squares[randomIndex] = aiPlayer;
      return;
    }
  }
}