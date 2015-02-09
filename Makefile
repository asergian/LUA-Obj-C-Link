#CC=clang # or gcc (tested with clang 3.2 and gcc 4.7.1)
CC=g++

LIBRARIES:= -lobjc -framework Foundation
HEADERS:= -I ./

SOURCE=test.m

CFLAGS=-Wall -Werror -g -v $(HEADERS) $(SOURCE)
LDFLAGS=$(LIBRARIES)
OUT=-o test

all:
	$(CC) $(CFLAGS) $(LDFLAGS) $(OUT)
