# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

update = ->
  $.getJSON("/room/index", (data) ->
    #clear chatbox
    $("#chat").html("");

    #create userlist
    users = data["userlist"]
    source = "<p>{{name}}</p>"
    template = Handlebars.compile(source)
    userPanelHtml = ""
    users.forEach((user)->
      userPanelHtml += template(user)
    )
    $("#userlist").html(userPanelHtml);

    #create message window
    posts = data["postlist"]
    posts.forEach((element)->
      if element["message"]=="joined"
        post = $("<p>").addClass("join").text(element["created"] + " " + element["username"] + " joined " + element["roomname"])
      else if element["message"] == "left"
        post = $("<p>").addClass("leave").text(element["created"] + " " + element["username"] + " left " + element["roomname"])
      else
        post = $("<p>").text(element["created"] + " " + element["username"] + ": " + element["message"])
      $("#chat").append(post))
    )

window.update = update
