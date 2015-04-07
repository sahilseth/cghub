
## Search using cgquery
##url='https://cghub.ucsc.edu/cghub/metadata/analysisFull'

#' @title gt.cgquery
#' @description gt.cgquery
#' @param search
#' @param url
#' @param count.only
#' @param cores
#' @export
#' @import RCurl
#' @import XML
#' @importFrom parallel mclapply
#' @examples \dontrun{
#' search = 'library_strategy=WXS&state=live&disease_abbr=CESC'
#' gt.cgquery(search = search, count.only = TRUE, cores = 5)
#' }
gt.cgquery <- function(search,
                       url='https://cghub.ucsc.edu/cghub/metadata/analysisFull', 
                       count.only, 
                       cores = 1){
  #require(RCurl); require(XML);require(parallel)
  message("\nFetching query result...")
  xml <- getURL(sprintf("%s?%s", url, search))
  message("\nReading reply...")
  root <- xmlRoot(xmlTreeParse(xml))
  if(FALSE){
    print(lapply(names(root),function(x) xmlValue(root[[x]])))
  }
  query <- xmlValue(root[["Query"]])
  hits <- as.integer(xmlValue(root[["Hits"]]))
  message("We got: ",hits," hits\n")#. Do you want to proceed?\n1: yes\n2: no\n")
  if(count.only){
    what=0##what <- scan("stdin", "character",  n=1, quiet = TRUE)
  }else{ what=1 } ### legacy for interactive
  ## --- can get what from commandline
  if(what %in% c("1","yes","Y","y","Yes","YES")){
    message("Proceeding with tabulation\n")
    ## first two are something else
    tmp <- mclapply(3:(hits+2), function(i){ #extract the data into a matrix
      message(".");res <- root[[i]]
        unlist(parse_res(x = res))
    },mc.cores=cores)
    tab <- as.data.frame(do.call(rbind, tmp), stringsAsFactors = FALSE)
    return(list(tab=tab,query=query,hits=hits))
  }else{
    message("Skipping tabulation\n")
    return(list(query=query,hits=hits))
  }
}


parse_res <- function(x){
  state <- try(xmlValue(x[["state"]])); state <- ifelse(length(state)<1,"NA",state)
  uuid <- try(xmlValue(x[["analysis_id"]])); uuid <- ifelse(length(uuid)<1,"NA",uuid)
  reflib <- try(xmlValue(x[["refassem_short_name"]]))
  reflib <- ifelse(length(reflib)<1,"NA",reflib)
  centerName <- try(xmlValue(x[["center_name"]]));
  centerName <- ifelse(length(centerName)<1,"NA",centerName)
  study <- try(xmlValue(x[["study"]]));
  study <- ifelse(length(study)<1,"NA",study)
  libraryStrategy <- try(xmlValue(x[["library_strategy"]]));
  libraryStrategy <- ifelse(length(libraryStrategy)<1,"NA",libraryStrategy)
  filename <- try(xmlValue(x[["files"]][["file"]][["filename"]]));
  filename <- ifelse(length(filename)<1,"NA",filename)
  filesize <- try(xmlValue(x[["files"]][["file"]][["filesize"]]));
  filesize <- ifelse(length(filesize)<1,"NA",filesize)
  checksum <- try(xmlValue(x[["files"]][["file"]][["checksum"]]));
  checksum <- ifelse(length(checksum)<1,"NA",checksum)
  aliquotID <- try(xmlValue(x[["aliquot_id"]]));
  aliquotID <- ifelse(length(aliquotID)<1,"NA",aliquotID)
  reason <- try(xmlValue(x[["reason"]]));
  reason <- ifelse(length(reason)<1,"NA",reason)
  barcode <- try(xmlValue(x[["legacy_sample_id"]]));
  barcode <- ifelse(length(barcode)<1,"NA",barcode)
  disease <- try(xmlValue(x[["disease_abbr"]]));
  disease <- ifelse(length(disease)<1,"NA",disease)
  platform <- try(xmlValue(x[["platform"]]));
  platform <- ifelse(length(platform)<1,"NA",platform)
  modificationDt <- try(xmlValue(x[["last_modified"]]));
  modificationDt <- ifelse(length(modificationDt)<1,"NA",modificationDt)
  ret <- list(study = study, disease = disease, platform = platform, centerName = centerName,
              barcode=barcode, aliquotID=aliquotID, reflib=reflib,
              filename=filename,filesize=filesize, state=state,uuid=uuid, checksum=checksum,
              modificationDt=modificationDt,
              reason=reason, libraryStrategy=libraryStrategy
  )
  flush.console()
  return(ret)
}