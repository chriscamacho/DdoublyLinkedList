
list-test: list-test.o
	dmd list-test.o -of=list-test

list-test.o: list-test.d
	dmd -g -c list-test.d

doc: list.html

list.html: list.d
	dmd -D -o- list.d

clean:
	rm -f *.o
	rm -f list-test
	rm -f list.html
	

