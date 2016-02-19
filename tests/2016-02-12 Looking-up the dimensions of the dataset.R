load("/Users/jankocizel/Documents/Dropbox/Data/SHS/data/other/2015-12-21 GFS Database.RData")

cbind(
    gfs_long[, tstrsplit(series,"\\.")],
    gfs_long
) ->
    gfs

gfs %>>%
    rename(
        DATASET = V1
    ) %>>%
    setnames(
        old = sprintf("V%s",2:19),
        new = dsd_gfs[[1L]] %>>% (varcode)
    ) ->
    gfs_v2

idref <- (dsd_gfs[[1L]] %>>% (varcode))

for (x in idref){
    dsd_gfs[[2L]][[dsd_gfs[[1L]][varcode == x][['codelist']]]] ->
        lookup
    
(lookup %>>%
 setkey(id))[gfs_v2 %>>%
                 setkeyv(x)] %>>%
    setnames(
        old = c('id','name'),
        new = c(x,sprintf("%s_label",x))
    ) ->
    o
    
    o ->>
        gfs_v2

    gfs_v2[[sprintf("%s_label",x)]] %>>% table %>>% print
}

gfs_v2 %>>%
    setcolorder(
        c(
            idref,
            sprintf("%s_label",idref),
            setdiff(
                names(gfs_v2),
                c(
                    idref,
                    sprintf("%s_label",idref)
                )                
            )
        )
    )


dsd_gfs[[1L]]
dsd_gfs[[2L]]
gfs_v2 %>>% (CONSOLIDATION_label) %>>% table
gfs_v2 %>>% (REF_AREA_label) %>>% table
gfs_v2 %>>% (VALUATION_label) %>>% table
gfs_v2 %>>% (PRICES_label) %>>% table
gfs_v2 %>>% (TRANSFORMATION_label) %>>% table
gfs_v2 %>>% (COUNTERPART_AREA_label) %>>% table
gfs_v2 %>>% (ACCOUNTING_ENTRY_label) %>>% table

gfs_v2 %>>%
    subset(
        grepl(pattern = glob2rx("GFS.A.N.*.*.S13.*.C.L.LE.*.*._Z.XDC._T.F.V.N._T"),
              series)
    ) %>>%
    mutate(
        date = sprintf("%s-%s-%s",date,12,31) %>>% as.Date,
        var = sprintf("GFS_%s_%s_%s_%s",
                      COUNTERPART_AREA,
                      COUNTERPART_SECTOR,
                      INSTR_ASSET,
                      MATURITY),
        label = sprintf("[%s] [%s] [%s] [%s]",
                        COUNTERPART_AREA_label %>>% substr(1,10),
                        COUNTERPART_SECTOR_label %>>% substr(1,10),
                        INSTR_ASSET_label %>>% substr(1,10),
                        MATURITY_label %>>% substr(1,10))
    ) %>>%
    select(
        iso2 = REF_AREA,date,
        var,label,value
    ) ->
    gfs_v3

gfs_v3[iso2 == 'NL' & (var == 'GFS.W0.S1.F3.S')]

gfs_v3 %>>%
    write.csv(
        file = 
            sprintf(
                "%s/%s GFS ECB Dataset.csv",
                DIR.DERIVED,
                Sys.Date()
            )
    )


gfs_v2 %>>%
    subset(
        grepl(pattern = glob2rx("GFS.A.N.*.*.S13.*.C.L.LE.*.*._Z.XDC._T.F.V.N._T"),
              series)
    ) %>>%
    mutate(
        date = sprintf("%s-%s-%s",date,12,31) %>>% as.Date,
        var = sprintf("GFS_%s_%s_%s_%s",
                      COUNTERPART_AREA,
                      COUNTERPART_SECTOR,
                      INSTR_ASSET,
                      MATURITY),
        label = sprintf("[%s] [%s] [%s] [%s]",
                        COUNTERPART_AREA_label %>>% substr(1,10),
                        COUNTERPART_SECTOR_label %>>% substr(1,10),
                        INSTR_ASSET_label %>>% substr(1,10),
                        MATURITY_label %>>% substr(1,10))
    ) ->
    gfs_v4

gfs_v4 %>>%
    write.csv(
        file = 
            sprintf(
                "%s/%s GFS ECB Dataset -- Additional Info.csv",
                DIR.DERIVED,
                Sys.Date()
            )
    )
