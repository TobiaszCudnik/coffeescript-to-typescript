
SRC=$(wildcard src/*.*coffee)
LIB=$(SRC:src/%.coffee=lib/%.js) $(SRC:src/%.litcoffee=lib/%.js) lib/parser.js

bin/coffee : $(LIB)
	touch bin/coffee

lib/%.js : src/%.*coffee
	node_modules/.bin/coffee -cm -o lib $<

lib/parser.js : lib/grammar.js lib/helpers.js
	node -e "console.log(require('./lib/grammar').parser.generate())" > lib/parser.js
	
build:
	coffee -cmo lib --watch src/*.coffee
	
debug:
	node --harmony --debug-brk bin/coffee -cma test.coffee
	
test:
	./bin/coffee -cma test.coffee

browser-debugger/transpiler.js : browser-debugger/browser-debugger.js $(LIB)
	node_modules/.bin/cjsify browser-debugger/browser-debugger.js --ignore-missing 							\
				 -s browser-debugger/transpiler.map -o browser-debugger/transpiler.js

.PHONY : clean test
clean :
	rm -rf lib/* browser-debugger/transpiler.*
