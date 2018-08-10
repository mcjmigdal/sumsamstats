# ATAC-seq QC functions
# Question is what kind of file I start with? Best would be bam's but that takes lots of time...

readBam <- function(file, what=NULL, firstOnly = FALSE, ...){
  if (is.null(what)) {
    what = scanBamWhat()
  }
  if (firstOnly) {
    flag = scanBamFlag(isFirstMateRead = TRUE)
  } else {
    flag = scanBamFlag()
  }
  param = ScanBamParam(flag=flag, what=what)
  if (length(file) > 1) {
    return(do.call(c, lapply(file, readBam)))
  }else{
    return(scanBam(file=file, index=file, param=param, ...))
  }
}


