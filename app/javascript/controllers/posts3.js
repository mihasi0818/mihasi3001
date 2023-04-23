// JavaScript
function toggleTab(tabNumber) {
    var activeTab = document.querySelector(".tab-content .active");
    if (activeTab) {
      activeTab.classList.remove("active");
    }
    
    var targetTab = document.getElementById("tab" + tabNumber);
    if (targetTab) {
      targetTab.classList.add("active");
    }
  }
  