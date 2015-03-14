CPD stands for copy and paste detector.  It is part of the PMD tools from pmd.sf.net.  I finds instances of copy and pasted code in your codebase.  This is a useful quality metric.

It presents somewhat of a challenge for us in reporting, though.  The output of CPD is like the following:
```
[snip..snip]
=====================================================================
Found a 23 line (109 tokens) duplication in the following files:
Starting at line 199 of /home/ike/cpd/tar-1.16/lib/printf-parse.c
Starting at line 256 of /home/ike/cpd/tar-1.16/lib/printf-parse.c

                    max_precision_length = 2;

                  /* Test for positional argument.  */
                  if (*cp >= '0' && *cp <= '9')
                    {
                      const CHAR_T *np;

                      for (np = cp; *np >= '0' && *np <= '9'; np++)
                        ;
                      if (*np == '$')
                        {
                          size_t n = 0;

                          for (np = cp; *np >= '0' && *np <= '9'; np++)
                            n = xsum (xtimes (n, 10), *np - '0');
                          if (n == 0)
                            /* Positional argument 0.  */
                            goto error;
                          if (size_overflow_p (n))
                            /* n too large, would lead to out of memory
                               later.  */
                            goto error;
                          dp->precision_arg_index = n - 1;
=====================================================================
Found a 21 line (107 tokens) duplication in the following files:
Starting at line 129 of /home/ike/cpd/tar-1.16/lib/printf-parse.c
Starting at line 199 of /home/ike/cpd/tar-1.16/lib/printf-parse.c
[snip..snip]
```

The output is not sorted (the biggest copy and pasted segment is not first).  What is the best way to display this metric?  There are essentially two ways to use this metric:
  1. QA -- will not want to see an increase in this number vs the milestone
  1. Developer -- will want to use output to target changes

So, the sum of all of the counts is useful to 1.  But for 2, a different presentation is required.  What is the representation for 2?  How should this influence the encoding of data for the report.