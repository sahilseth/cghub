
cghub: An interface for chatting with (cghub.ucsc.edu)
========================================================




## Installing the package

```r
install.packages("devtools")
devtools::install_github("sahilseth/cghub")
```

## Query
For more on querying the database, please look at: 
[https://cghub.ucsc.edu/docs/user/query.html](https://cghub.ucsc.edu/docs/user/query.html)

### Get hits for a tumor type
Query is based on:
- Get all *WGS* bams which are *live* for tumor *CESC*, and provide the number available


```r
library(cghub)
tumor = "CESC";library_strategy = "WGS"
search=sprintf("study=phs000178&library_strategy=%s&state=live&disease_abbr=%s", 
                                 library_strategy, tumor)
out <- gt.cgquery(search = search, count.only = TRUE)
```

### Query and parse hits into a table


```r
out <- gt.cgquery(search=sprintf("study=phs000178&library_strategy=WGS&state=live&disease_abbr=%s", tumor), 
                  count.only = FALSE)
names(out)
```

[1] "tab"   "query" "hits" 

```r
out$query
```

[1] "study:phs000178 library_strategy:WGS disease_abbr:CESC state:live"

```r
out$hits
```

[1] 142


study       disease   platform   centerName   barcode                        aliquotID                              reflib               filename                                                                    filesize      state   uuid                                   checksum                           modificationDt         reason   libraryStrategy 
----------  --------  ---------  -----------  -----------------------------  -------------------------------------  -------------------  --------------------------------------------------------------------------  ------------  ------  -------------------------------------  ---------------------------------  ---------------------  -------  ----------------
phs000178   CESC      ILLUMINA   HMS-RK       TCGA-HG-A2PA-01A-11D-A20X-26   ECE06317-01F9-4EF2-ACE0-E9B18C7F4DE1   HG19_Broad_variant   TCGA-HG-A2PA-01A-11D-A20X_140106_SN590_0244_BC384EACXX_s_4_rg.sorted.bam    17463115455   live    03ad648b-e0e2-4d73-a1a7-1004a4cf6c6d   52fbc3079d348d0f3e0b400e7be185e2   2014-06-10T05:21:37Z   NA       WGS             
phs000178   CESC      ILLUMINA   HMS-RK       TCGA-FU-A3TQ-01A-11D-A232-26   7018744f-49ff-4f47-aee5-07f0dea5d7d3   HG19_Broad_variant   TCGA-FU-A3TQ-01A-11D-A232_140124_SN1120_0291_AC2PHAACXX_s_3_rg.sorted.bam   26168324162   live    03f34fcc-2af0-41f5-9784-3de867b1aac3   f951fb705fc93a9848d630df633c0580   2014-06-10T07:16:47Z   NA       WGS             
phs000178   CESC      ILLUMINA   HMS-RK       TCGA-JX-A3Q0-10A-01D-A245-26   3494d848-1830-49a0-b144-22550b8a0428   HG19_Broad_variant   TCGA-JX-A3Q0-10A-01D-A245_140206_SN1222_0239_BC2RAKACXX_s_2_rg.sorted.bam   19341942149   live    10e36cd3-f435-4e63-83f9-57613bb50b90   7a0905a27831dff3537a6ce443397a00   2014-06-10T18:50:50Z   NA       WGS             
phs000178   CESC      ILLUMINA   HMS-RK       TCGA-JX-A3Q8-10A-01D-A245-26   dfede0ba-0e85-4d22-9a70-88e798cd267a   HG19_Broad_variant   TCGA-JX-A3Q8-10A-01D-A245_140206_SN1222_0239_BC2RAKACXX_s_4_rg.sorted.bam   20895427729   live    0fbd6804-e8d6-47b5-95f7-aa3f107d2c7e   43e830a660e342ce7251032caa436ff8   2014-06-10T18:57:02Z   NA       WGS             
phs000178   CESC      ILLUMINA   HMS-RK       TCGA-C5-A2LZ-01A-11D-A20X-26   837B293C-0843-4002-A8AB-3A945E040C75   HG19_Broad_variant   TCGA-C5-A2LZ-01A-11D-A20X_140106_SN590_0244_BC384EACXX_s_2_rg.sorted.bam    16607119021   live    0a7b3c97-5fcf-493b-811f-2eb9734bae1a   ba54f79d49539a64373e831b9a98804a   2014-06-11T01:53:18Z   NA       WGS             
phs000178   CESC      ILLUMINA   HMS-RK       TCGA-EA-A3HU-10B-01D-A20X-26   4B33B319-40C6-4C3C-B259-5518A1B55410   HG19_Broad_variant   TCGA-EA-A3HU-10B-01D-A20X_140106_SN590_0244_BC384EACXX_s_7_rg.sorted.bam    18612972742   live    03dd6beb-53b9-4bfe-8843-9e2fe621913a   5158447a4b01a7e5ef91bafa3f2a81c2   2014-06-12T00:59:54Z   NA       WGS             


### Based on a list of TCGA barcodes

```r
require(parallel)
ids <- c("TCGA-BJ-A0Z5-01","TCGA-DJ-A1QG-01","TCGA-EM-A1YC-01",
         "TCGA-ET-A25J-01", "TCGA-H2-A26U-01","TCGA-H2-A3RI-01")

tab <- mclapply(ids,function(id){
  out <- gt.cgquery(search=sprintf("legacy_sample_id=%s*&state=live",id), count.only=FALSE)
  return(out$tab)
  },mc.cores=1)
tab=do.call(rbind,tab)
knitr::kable(head(out$tab))
```


### Load BAM using GTFuse

```r
## This contains all the uuids: out$tab$uuid
path=gt.loadBamFile(uuid='056a5a41-1be5-48f1-8ae5-bd8125e5b0c2', key="mykey.pem", force=TRUE)
```

### Download BAM using gtdownload
- this supports providing multiple UUIDs

```r
outBam <- gt.cgDownload(uuids=uuids, path="/scratch/gt", GT="GeneTorrent", cores=1,
                          key="mykey.pem",params="")
```



