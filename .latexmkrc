# mathpaper: pdfLaTeX by default (amsart). Override with latexmk -xelatex or make ENGINE=xe.
$pdf_mode = 1;
$dvi_mode = 0;
$postscript_mode = 0;
$recorder = 1;
$dependents_list = 1;
$show_time = 1;

$pdflatex = 'pdflatex -synctex=1 -interaction=nonstopmode %O %S';
$xelatex  = 'xelatex -synctex=1 -interaction=nonstopmode %O %S';
$clean_ext = 'bbl brf synctex.gz';

# make watch (-pvc): open/refresh a PDF viewer when available
if ($^O eq 'darwin') {
  $pdf_previewer = (-d '/Applications/Skim.app')
    ? 'open -a Skim.app %S'
    : 'open %S';
} elsif ($^O eq 'MSWin32') {
  $pdf_previewer = 'start %S';
}
