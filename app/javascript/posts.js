function formSwitch0() {
    const selectedRadioGroup = document.getElementsByName('maker0');
    
    if (selectedRadioGroup[0].checked) {
        // 好きな食べ物が選択されたら下記を実行します
        document.getElementById('user_List').style.display = "";
        document.getElementById('user_List2').style.display = "none";
      

    } else if (selectedRadioGroup[1].checked) {
        // 好きな場所が選択されたら下記を実行します
        document.getElementById('user_List').style.display = "none";
        document.getElementById('user_List2').style.display = "";
       
    } else {
        document.getElementById('user_List').style.display = "none";
        document.getElementById('user_List2').style.display = "none";
    }
}

 
window.addEventListener('load',formSwitch0);


