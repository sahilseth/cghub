# path='/scratch/gtfuse';gtfuse='/usr/bin/gtfuse';key='/axis1/keys/cghubpvt.pem';cache='/scratch/gtfuseCache';
# url='https://cghub.ucsc.edu/cghub/data/analysis/download/'
#' @export
gt.loadBamFile <- function(uuid,path='gtfuse',gtfuse='gtfuse',key='mykey.pem',
                           cache='~/gtfuseCache',url='https://cghub.ucsc.edu/cghub/data/analysis/download',force=FALSE){
  cmd <- sprintf("%s -c %s --inactivity-timeout=30 --cache-dir=%s -l syslog:standard %s/%s %s/%s",gtfuse,key,cache,url,uuid,
                 path,uuid)
  if(force){
    gt.unloadBamFile(uuid,path=path,cache=cache)
  }
  dir.create(file.path(path,uuid),showWarnings=FALSE,recursive=TRUE);dir.create(cache,showWarnings=FALSE,recursive=TRUE)
  cat(cmd,"\n");system(cmd)
  return(list.files(file.path(path,uuid,uuid),"bam",full.name=TRUE))
}

#' @export
gt.unloadBamFile <- function(uuid, path='gtfuse', cache='gtfuseCache'){
  try(system(sprintf("rm -rf %s/%s*",cache,uuid)))
  try(system(sprintf("fusermount -u %s/%s",path,uuid)))
  try(system(sprintf("rm -rf %s/%s",path,uuid)))
}
