.PHONY: lint stylua


lint:
	luacheck lua/telescope

stylua:
	stylua --color always lua/


