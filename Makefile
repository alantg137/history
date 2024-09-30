all: output/hello.pdf output/mla_example.pdf

output/%.pdf: %.tex
	pdflatex -output-directory=output $<
