CC = clang
CFLAGS = -Ofast -march=native -Wall -std=c99 -fPIC

sod: ext/sod.c
	$(CC) -c ext/sod.c -o ext/sod.o -I. $(CFLAGS)