# EPACTS and with SKATOh

This is a fork of the original EPACTS software (https://github.com/statgen/EPACTS).

The fork contains different bug fixs, specifically regarding the statistical analysis of collapsed variants present on different chromosomes.

Additionally, this fork includes an improved SKAT statistical test, as proposed in:
Wu,B., Guan,W., Pankow,J.S. (2016).On efficient and accurate calculation of significance p-values for sequence kernel association test of variant set. AHG, 80(2), 123-135.

The code implemented has been gathered from the article's method repository: https://github.com/baolinwu/SKATR.
The new statistical test is implemented as an option (--skatoh).

Finally, some additional output metrics have been added, such as total minor allele content count (MAC) and separate MAC for cases and controls (only available for binary phenotypes).

## How to install

A dockerfile can be found in the repository to install EPACTS_SKATOh.

---------------------------------------------------------------------

## Original EPACTS Documentation

The latest version of documentation of EPACTS can be found at
http://genome.sph.umich.edu/wiki/EPACTS


