reset
set term pdfcairo color dashed enhanced size 15 cm, 10 cm

set output "gnuplot.pdf"

set key noauto bottom
set xlabel "x"
set ylabel "f(x)"

f(x) = x/(1 + x)

plot f(x) w l lw 2

set output
