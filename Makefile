
list-test: list-test.o list.o
	dmd list-test.o list.o -of=list-test

list-test.o: list-test.d
	dmd -c list-test.d

list.o: list.d
	dmd -c list.d

doc: list.html

list.html: list.d
	dmd -D -o- list.d

clean:
	rm -f *.o
	rm -f list-test
	rm -f list.html
	

