# Introduction #

There are a number of metrics about builds that can be stored and used to compare different milestones and child workspaces (CWS). This page is to detail all the metrics that will be stored and shown.

As there is 2 build dirs: source and build. The real build work is done on the build dir, thus the stats can be run on the source dir once the build has started.

# Details #

The different types of metrics are listed below

# Source type metrics #

## Size of source ##
This metric will show how the size of the source code changes over time.

### How to collect ###
```
du -h
```

### Reports this metric is used in ###
This metric is used in the following reports:


## Number of files in source ##

### How to collect ###
```
find -name *  | wc -l
```

## Number of Source Lines of Code ##

### How to collect ###
```
sloccount * |grep "Total Physical Source Lines of Code (SLOC)" | cut -d= -f2
```

## Cut and Pasted Lines ##
This measures incidences of cut and pasted lines.  This is collected with pmd (pmd.sf.net).  See CPDMetric

# Metrics about the completion of each build #
These metrics can only be sent after each build or module is complete.
## Time to complete full build ##

## Time to complete the build of each module ##

## The number of error and/or warnings ##
# Runtime Metrics #
These are more difficult to do
## Start Time ##
## Cold-Start Time ##
Note, must be repeated and averaged (takes about 24 hours).  Probably takes two machines.
## Profile ##
Over some activity, such as loading a set of documents