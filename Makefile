compile:
	rake clean
	rake compile
preview:
	rake compile
	bundle exec rake preview > ~/Desktop/rucaptcha-test.png && open ~/Desktop/rucaptcha-test.png
