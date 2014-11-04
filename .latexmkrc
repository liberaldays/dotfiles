#!/usr/bin/perl

$latex = 'platex -kanji=utf8';
$bibtex = 'pbibtex -kanji=utf8 %O %B';
$dvipdf = 'dvipdfmx %O -o %D %S';
$pdf_mode = 3; #use dvipdf
#$pdf_previewer = 'open %S';
@default_files = ("main");
