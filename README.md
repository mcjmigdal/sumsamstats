Parser and tools for summarising outputs of samtools stats, with ATAC-seq in mind.
It's greatest feature will be the possiblility to fit the distribution of
exponential and gaussians into IS distribution (never happend still usefull for parsing samtools stats output :). And it will present all this
with userfriendly shiny interface.

## ATAC-seq quality control checks for multiple libraries

Standards from [encodeproject](https://www.encodeproject.org/atac-seq/)

+ two or more biological replicates
+ at least 25 million fragments
+ aligment rate greater than 95%
+ replicate concordance measuredby calculating IDR values
+ library complexity measured using Non-Redundant Fraction and PCR Bottlenecking Coefficients 1 and 2. NRF > 0.9, PBC1 > 0.9, PBC2 > 3
+ mononucleosome peak must be present in the fragment length distribution
+ FRiP > 0.3
+ TSS enrichment
