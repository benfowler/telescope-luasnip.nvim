.PHONY: test_ci, lint stylua

all: test_ci lint

test_ci:
	@nvim --headless -c "PlenaryBustedDirectory lua/tests/ {}"

lint:
	@luacheck lua/telescope

stylua:
	@stylua --color always lua/

