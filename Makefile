compile:
	rake clean
	rake compile
test:
	rake preview > ~/Desktop/rucaptcha-test.gif && open ~/Desktop/rucaptcha-test.gif
