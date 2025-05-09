all: output/hello.pdf output/mla_example.pdf output/s.pdf output/history.pdf
     
clean:
	rm output -r

output/%.pdf: %.tex
	mkdir -p output
	./shell pdflatex -output-directory=output $<

shell: default.nix
	nix-build -o shell
