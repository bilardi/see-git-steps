
BIN ?= see-git-steps
PREFIX ?= /usr/local
MANPREFIX ?= $(PREFIX)/share/man/man1

$(BIN): test man

test:
	bash test.sh --functional-tests

install:
	cp $(BIN).sh $(PREFIX)/bin/$(BIN)
	cp $(BIN).1 $(MANPREFIX)/$(BIN).1

uninstall:
	rm -f $(PREFIX)/bin/$(BIN)
	rm -f $(MANPREFIX)/$(BIN).1

man:
	bash $(BIN).sh -h > $(BIN).1.md; test true
	@curl -# -F page=@$(BIN).1.md -o $(BIN).1 http://mantastic.herokuapp.com
	@echo "$(BIN).1"

.PHONY: test man
