tests:
	rake db:test:prepare
	rake db:test:load
	rake test:units
	rake test:functionals
