## source("/IACS1/home/sseth/projects/AnnaiUtil/R/cgDownload.R")

#' @title gt.cgDownload
#' @description gt.cgDownload
#' @param uuids
#' @param path
#' @param gtdownload_exe
#' @param cores
#' @param key
#' @param params Additional parameters to be supplied
#' @export
gt.cgDownload <- function(uuids,
													path="~/cgdump", 
													gtdownload_exe="gtdownload",
													cores=2,
                          key="mykey.pem",
													params=""){
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
        file.rename(uuid,file.path(path,"done",uuid))
        return(list.files(file.path(done, uuid),"bam$",full.name=TRUE))
    },mc.cores=cores)
    return(files)
}

gt.moveBAMtoRunFolder <- function(path,outPath,mat,uuidvarname=bamfileuuid,outvarname){
    files <- list.files(path,pattern="bam$",recursive=TRUE)
}


gt.indexBam <- function(bam){
    require(Rsamtools)
    baiFile <- paste(bam,".bai",sep="")
    if(!file.exists(baiFile)){cat(bam,"\tIndexing...\n"); indexBam(bam)}
    return(baiFile)
}

gt.checksum <- function(bam){
    md5File <- paste(bam,".md5",sep="")
    if(!file.exists(md5File)){cat(bam,"\tCheckSum...\n"); indexBam(bam)}
    return(baiFile)
}

