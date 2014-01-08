
Thread pool Project
===================

This repository contains the code necessary to
implement a basic thread pool.  The interesting
code is located in threadpool.c and threadpool.h.
The files list.c, list.h, quicksort.c, and 
quicksort\_test.c were given as part of a class
project, and may or may not be useful to you.  


Building
--------

The project can be built using the standard
GNU `make` program.  Just type 

`$ make`

or

`$ make all`

in a command line to build the entire project with 
tests.  

To clean, type

`$ make clean`

You can also combine these by typing

`$ make clean all`


Running
-------

Since this was created for a class, the primary purpose
for running is testing.  To pass the tests for the 
given project specs, compile everything using the 
Makefile, then run `check.py`.  This program will 
take care of everything testingwise.

Part 2 of the project was taken care of using the 
`run_quicksort.sh` program.  This script cleans
and builds the project again, determines the optimum 
recursive depth for each number of threads in quicksort,
runs quicksort at that depth, saves the results in a 
.txt report, and creates plots in .png and .eps files.  
The shell script comes with its own warnings and 
descriptions at the top of it.  For clarity's sake, 
I'll include it here so as to save you reading:

> Quicksort!
> This script brute-forces the quicksort algorithm at 1/10th of the      
> numbers to sort to find the optimal depth.  It then runs the quicksort 
> program with the correct amount of numbers, three times so that it can 
> get a reasonably good average.  It also computes the speedup factor for
> each optimal depth.  All of this information is saved in speedup.txt,  
> and plots of the speedup vs. operating cores are produced in plot.png  
> and plot.eps.  For those unfamiliar, .eps files are normally included  
> in LaTeX documents, in case that is the document preparation system of 
> choice. The whole script takes roughly 45 minutes to run with a low    
> system load.  Be careful--this script was made to run on the 
> rlogin cluster.  It's not at all guaranteed to work anywhere else.
> Have fun waiting for your work to be done for you, and good luck!  
