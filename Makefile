Gemfile.lock: Gemfile
	bundle install


.PHONY: test 
test: Gemfile.lock
	@ruby -I ./ $(addprefix -r$(file), $(wildcard test/*_test.rb)) -e 'exit'
