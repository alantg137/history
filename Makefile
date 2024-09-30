all: output/hello.pdf output/mla_example.pdf

output/%.pdf: %.tex
	mkdir -p output
	pdflatex -output-directory=output $<
