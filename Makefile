EBIN_DIR=ebin
SOURCE_DIR=src
INCLUDE_DIR=include
ERL_INC_DIR=/opt/local/lib/erlang/lib
ERLC_FLAGS=-W0
LOAD_PATH=deps/*/ebin

compile:
	mkdir -p $(EBIN_DIR)
	erlc -Ddebug +debug_info -I $(INCLUDE_DIR) -I $(ERL_INC_DIR) -o $(EBIN_DIR) $(ERLC_FLAGS) $(SOURCE_DIR)/*.erl

all: compile

clean:
	rm $(EBIN_DIR)/*.beam
	rm erabbit*.tar.gz
	rm erl_crash.*

dist:
	mkdir -p erabbit
	cp -r Makefile README include src erabbit/ 
	tar cfvz erabbit-erlang.tar.gz erabbit/
	rm -rf erabbit/

