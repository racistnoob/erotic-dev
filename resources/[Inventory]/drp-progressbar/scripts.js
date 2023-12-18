$(document).ready(function(){
  
  var documentWidth = document.documentElement.clientWidth;
  var documentHeight = document.documentElement.clientHeight;
  var curTask = 0;
  var processed = []
  function openMain() {
    $(".divwrap").fadeIn(250);
  }

  function closeMain() {
    $(".divwrap").fadeOut(250)
  }  

  window.addEventListener('message', function(event){

    var item = event.data;
    if(item.runProgress === true) {
      openMain();

      $('#progress-bar').css("width","0%");
      $(".nicesexytext").html(item.name)
    }

    if(item.runUpdate === true) {

      var percent = "" + item.Length + "%"
      $('#progress-bar').css("width",percent);

      $(".nicesexytext").html(item.name);
    }

    if(item.closeFail === true) {
      closeMain()
      $.post('http://drp-progressbar/taskCancel', JSON.stringify({tasknum: curTask}));
    }

    if(item.closeProgress === true) {
      closeMain();
    }

  });

});
