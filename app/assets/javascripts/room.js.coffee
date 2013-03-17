# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

update = ->
  $.getJSON("/room/index", (data) ->
    debugger
    $("#chat").html("");
    data.forEach((element)->
      if element["message"]=="joined"
        post = $("<p>").addClass("join").text(element["created"] + " " + element["username"] + " joined " + element["roomname"])
      else if element["message"] == "left"
        post = $("<p>").addClass("leave").text(element["created"] + " " + element["username"] + " left " + element["roomname"])
      else
        post = $("<p>").text(element["created"] + " " + element["username"] + ": " + element["message"])
      $("#chat").append(post))
    )
    
$(document).ready(
  update();
  setInterval(update, 5000);
  $("#chattextbtn").click(()->
    $.get("/room/event/say/"+encodeURIComponent($("#chattextbox").val()))
    $("#chattextbox").val("");
    update()
  )
);

