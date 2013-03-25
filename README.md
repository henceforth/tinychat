# SuperTinyChat

#### What is it?
Just some _very_ basic chat app. Users can create rooms, with password or without, chat in it, that is all.

#### Why did you it?
I haven't done any web stuff in quite some time, so this was my approach to check out all the fance stuff 
that is currently around.

#### What' in there?
Server side is running Ruby on Rails, which I, coming from Python (web2py, flask, pyramid, Django) found
supprisingly easy to configure and use. I think I will use it for some more projects.

Client side got some basic JS stuff going on, we got
* Boostrap for the looks
* JQuery for the asnyc requests and JSON parsing
* Handlebars for the templating
* Coffeescript for not typing my fingers bloody
maybe some more stuff, I forgot about.

#### Did you test it?
Yep, wrote unit and functional tests, run them with "rake test", code coverage results are in "/coverage".

#### Any issues?
Yeah, well it's not really finished. You can't delete rooms, or kick users from rooms and there is no private chat.

#### Any plans?
I thought about adding websockets or OAuth, but currently I would rather work on something new.
