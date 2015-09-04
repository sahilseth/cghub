## source("/IACS1/home/sseth/projects/AnnaiUtil/R/cgDownload.R")

#' @title Download files from CGHub - a wrapper around gtdownload
#' @description gt.cgDownload
#' @param uuids
#' @param path
#' @param gtdownload_exe
#' @param cores
#' @param key
#' @param params Additional parameters to be supplied
#' @export
#' 
#' @examples \dontrun{
#' 
#' download("89324e86-5b7a-4f69-92c1-3b67293f8748")
#' 
#' }
#' 
download <- function(uuids,
                     path = getwd(), 
                     gtdownload_exe = "gtdownload",
                     cores = 2,
                     key = get_opts("cghub_key_file"),
                     params = ""){
  
  ## make sure none of the arguments are NULL
  check_args()
  
  require(parallel)
  setwd(path)
  dir.create("working",showWarnings=FALSE,recursive=TRUE);dir.create("done",showWarnings=FALSE,recursive=TRUE)
  setwd("working")
  ## uuids <- mat[,uuidvarname]
  if(length(list.files(file.path(path,"done")))==0){
    done <- 0
  }else{done <- list.files(file.path(path, "done"))}
  ## uuids2 <- uuids[!uuids==done] #remove the ones which are done
  
  files <- mclapply(uuids,function(uuid){
    ## if download has completed
    if(uuid %in% done) return(list.files(file.path(done, uuid),"bam$",full.name=TRUE))
    cmd=sprintf("%s %s -c %s -d %s -v",gtdownload_exe,params,key,uuid)
    cat(cmd,"\n")
    system(cmd)
    if(file.exists(uuid)){
      message("download complete, moving to done folder")
      file.rename(uuid, file.path(path,"done", uuid))
    }
    return(list.files(file.path(done, uuid),"bam$",full.name=TRUE))
  }, mc.cores = cores)
  return(files)
}
gt.cgDownload = download



index_bam <- function(bam){
  require(Rsamtools)
  baiFile <- paste(bam,".bai",sep="")
  if(!file.exists(baiFile)){cat(bam,"\tIndexing...\n"); indexBam(bam)}
  return(baiFile)
}
gt.indexBam = index_bam

checksum <- function(bam){
  md5File <- paste(bam,".md5",sep="")
  if(!file.exists(md5File)){cat(bam,"\tCheckSum...\n"); indexBam(bam)}
  return(baiFile)
}
gt.checksum = checksum

