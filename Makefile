functionals:
	rake test TEST=test/functional/room_controller_test.rb

tests:
	rake db:test:prepare
	rake db:test:load
	rake test:units
	rake test:functionals

clear:
	rake tmp:clear
	rake db:test:purge
	rake db:test:prepare
