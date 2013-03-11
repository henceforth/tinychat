tests:
	rake db:test:prepare
	rake db:test:load
	ruby -Itest test/unit/post_test.rb
	ruby -Itest test/unit/user_test.rb
	ruby -Itest test/unit/room_test.rb
