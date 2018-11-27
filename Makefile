all: report.html 

clean:
	rm -f histogram.tsv histogram.png a.png b.png c.png words_count.csv first_letter.tsv first_letter.png report.md report.html README.md

report.md: report.rmd histogram.tsv histogram.png first_letter.png first_letter.tsv a.png b.png c.png words_count.csv
	Rscript -e 'rmarkdown::render("$<")'
	rm -f Rplots.pdf

histogram.png: histogram.tsv
	Rscript -e 'library(ggplot2); qplot(Length, Freq, data=read.delim("$<")); ggsave("$@")'
	rm Rplots.pdf

histogram.tsv: histogram.r words.txt
	Rscript $<
	
first_letter.png: first_letter.tsv
	Rscript -e 'library(ggplot2); library(tidyverse); ggplot(top_n(read.delim("first_letter.tsv"),50)) + geom_point(aes(reorder(letter, -count), count)) + theme(text = element_text(size=10), axis.text.x = element_text(hjust=1)); ggsave("first_letter.png")' 
#	Rscript -e 'library(ggplot2); qplot(letter, count, data=read.delim("$<")); ggsave("$@")'
	rm Rplots.pdf
	

first_letter.tsv: first_letter.r words.txt
	Rscript $<

words_count.csv: words.txt words_count.py
	python words_count.py words.txt words_count.csv

a.png: words_count.csv plot.py
	python plot.py words_count.csv a.png
	
b.png: words_count.csv plot.py
	python plot.py words_count.csv b.png

c.png: words_count.csv plot.py
	python plot.py words_count.csv c.png

words.txt:
Rscript -e 'download.file("http://svnweb.freebsd.org/base/head/share/dict/web2?view=co", destfile = "words.txt", quiet = TRUE)'
