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
    p_template = "<p class=\"{{class}}\">{{{icon}}}{{username}}{{message}}</p>"
    c_template = Handlebars.compile(p_template)
    posts = data["postlist"]
    posts.forEach((element)->
      post = {class: "", icon: "", username: "", message: "", roomname: ""}
      post.username = element["username"]
      post.create = element["created"]
      post.roomname = element["roomname"]

      if element["message"]=="joined"
        post.icon = "<i class=\"icon-chevron-right\"></i> "
        post.class="join"
        post.message = " joined " + post.roomname
      else if element["message"] == "left"
        post.icon = "<i class=\"icon-chevron-left\"></i> "
        post.class="leave"
        post.message = " left " + post.roomname
      else
        post.message = ": "+ element["message"]
      $("#chat").append(c_template(post))
    )
  )


window.update = update
