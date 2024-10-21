document.addEventListener('DOMContentLoaded', function () {
  let result = document.getElementById('result');
  let buttons = document.querySelectorAll('button');

  buttons.forEach(button => {
    button.addEventListener('click', () => {
      let value = button.textContent;
      if (value === '=') {
        calculateInput();
      } else if (value === 'CA') {
        clearAll();
      } else {
        add(value);
      }
    });
  });

  function add(value) {
    result.value += value;
  }

  function calculateInput() {
    result.value = eval(result.value);
  }


  function clearAll() {
    result.value = '';
  }

});