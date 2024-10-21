for (i = 0; i < 5; i++) {
    document.querySelectorAll(".rating-btn")[i].addEventListener("click", function () {

        var thisButton = parseInt(this.textContent);
        buttonIDIndex = [];
        var buttonID = ["one", "two", "three", "four", "five"];
        var submitReady = "false";

        switch (thisButton) {
            case 1: modifyButton(); break;
            case 2: modifyButton(); break;
            case 3: modifyButton(); break;
            case 4: modifyButton(); break;
            case 5: modifyButton(); break;
            default: return -1;
        }

        function modifyButton() {
            document.getElementById(buttonID[thisButton - 1]).classList.add("onClick");
            document.querySelector(".submit-btn").classList.add("superSubmit");
            buttonIDIndex = buttonID.indexOf(buttonID[thisButton - 1]);
            buttonID.splice(buttonIDIndex, 1);
            resetOnClick(buttonID);
            submitReady = "true";
            submit(submitReady);
            document.getElementById("scoreNumber").innerHTML = thisButton;
        }

        function resetOnClick(buttonID) {
            for (i = 0; i < 4; i++) {
                document.getElementById(buttonID[i]).classList.remove("onClick");
            }
        }
        
        function submit(submitReady) {
            document.querySelector(".submit-btn").addEventListener("click", function () {
                if (submitReady == "true") {
                    document.getElementById("card-front").classList.add("hide");
                    document.getElementById("card-back").classList.remove("hide");
                } else { console.log("submit if failed") };
            })
        }
    })
}