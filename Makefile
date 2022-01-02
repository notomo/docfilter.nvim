test:
	vusted --shuffle
.PHONY: test

PLUGIN_NAME:=$(basename $(notdir $(abspath .)))
doc:
	rm -f ./doc/${PLUGIN_NAME}.nvim.txt ./README.md
	nvim --headless -i NONE -n +"lua dofile('./spec/lua/${PLUGIN_NAME}/doc.lua')" +"quitall!"
	cat ./doc/${PLUGIN_NAME}.nvim.txt ./README.md
.PHONY: doc
