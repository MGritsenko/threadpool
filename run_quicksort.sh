#!/bin/bash

#	Authored by Pat Lewis (patl1), 2013
#	Feel free to use, reuse, distribute, and modify the script in 
# 	whatever way you deem necessary.  Just make sure you give credit
# 	to the original authors and subsequent contributors.  

TIME=0
MINTIME=1000

make clean all			# Make sure everything is built
if [ $? -ne 0 ]; then		# If the compilaiton fails, throw error and exit
    echo -e "\033[0;31mSomething went to shit in the compilation.  Get that sorted out.\033[00m"
    exit 0
fi

echo "======================================================================="
echo "Quicksort!"
echo "This script brute-forces the quicksort algorithm at 1/10th of the      "
echo "numbers to sort to find the optimal depth.  It then runs the quicksort "
echo "program with the correct amount of numbers, three times so that it can "
echo "get a reasonably good average.  It also computes the speedup factor for"
echo "each optimal depth.  All of this information is saved in speedup.txt,  "
echo "and plots of the speedup vs. operating cores are produced in plot.png  "
echo "and plot.eps.  For those unfamiliar, .eps files are normally included  "
echo "in LaTeX documents, in case that is the document preparation system of "
echo "choice. The whole script takes roughly 45 minutes to run with a low    "
echo -e "system load.  \033[1;31mBe careful--this script was made to run on the "
echo -e "rlogin cluster.  It's not at all guaranteed to work anywhere else.\033[00m"
echo "Have fun waiting for your work to be done for you, and good luck!	     "  
echo "======================================================================="

# Begin writing the summary report
printf "nthreads\tmaxdepth\tparallel\tserial\t\tspeedup\n" > speedup.txt

for nthreads in 1 2 4 6 8 12 16
do	
    #============================ Find the optimal depth by brute force======================================#
    echo "For n = $nthreads:"
    printf "Finding optimal depth...                                           %3.0f%%" $(echo "scale = 2; 0/25*100" | bc)
    for j in {1..25}
    do
        TIME=$(./quicksort -s 42 -n $nthreads -d $j 30000000 | awk '/qsort parallel/ {print $4}')
        if [ $(echo "$TIME<$MINTIME" | bc) -ne 0 ]; then	# The math logic: if this time is the new mintime
            MAXDEPTH=$(expr $j )
            MINTIME=$TIME
        fi
        printf "\rFinding optimal depth...                                           %3.0f%%" $(echo "scale=2; $j / 25 * 100" | bc)
    done
    echo		

    echo "Max depth = $MAXDEPTH"

    #============================ Now take actual timings ===================================================#
    echo 
    printf "Running quicksort for reals, getting good averages...                0%%"

    PARAVG=0	#parallel average
    SERAVG=0	#serial average
    SPEEDUP=0	#speedup factor
	
    for i in 1 2 3
    do
        ./quicksort -s 42 -n $nthreads -d $MAXDEPTH 300000000 | grep "qsort" > tmp
      	PARAVG=$(echo "scale=3; $PARAVG + $(awk '/parallel/ {print $4}' tmp)" | bc)
    	SERAVG=$(echo "scale=3; $SERAVG + $(awk '/serial/ {print $4}' tmp)" | bc)
    	printf "\rRunning quicksort for reals, getting good averages...              %3.0f%%" $(echo "scale=2; $i / 3 * 100" | bc)
    done
    echo
    PARAVG=$(echo "scale=3; $PARAVG / 3" | bc)
    SERAVG=$(echo "scale=3; $SERAVG / 3" | bc)
    SPEEDUP=$(echo "scale=3; $SERAVG / $PARAVG" | bc)
    printf "Serial average: %5.3f\t Parallel average: %5.3f\t Speedup: %5.3f\n" $SERAVG $PARAVG $SPEEDUP
    echo "======================================================================="
    #============================== Write everything out to a file ==========================================#
    printf "%d\t\t%d\t\t%5.3f\t\t%5.3f\t\t%5.3f\n" $nthreads $MAXDEPTH $PARAVG $SERAVG $SPEEDUP >> speedup.txt
done
rm -rf tmp	# Get rid of the temporary crap
echo
echo "Use 'cat speedup.txt' to view a condensed, columnized result of the above"
echo "data. It doesn't format well in some text editors."
echo

#================================ Run the script that plots all this fancy data =============================#
cat << __EOF | gnuplot
set term png size 800,600 font "/usr/share/fonts/dejavu/DejaVuSans-Bold.ttf" 
set output "plot.png"
set title "Speedup vs. Operating Cores"
set xlabel "Operating Cores"
set ylabel "Speedup Factor"
set autoscale
plot "speedup.txt" using 1:5 title "Speedup" with linespoints pointtype 6 lw 5

set term postscript eps size 8,6 font "/usr/share/fonts/dejavu/DejaVuSans-Bold.ttf, 30" enhanced color
set output "plot.eps"
plot "speedup.txt" using 1:5 title "Speedup" with linespoints pointtype 6 lw 10
__EOF
