options(width = 80)

datasets <- get_datasets()

ameco_static <- get_static(dataset = 'ECB_AME1')
ameco_data <- get_data(dataset = 'AME')

ameco_data

save(ameco_static, ameco_data,
     file = '~/Data/ECB Data/ameco.RData')


ivf_static <- get_static(dataset = 'ECB_IVF1')
ivf_data <- get_data(dataset = 'IVF')

save(ivf_static, ivf_data,
     file = '~/Data/ECB Data/ivf.RData')


rtd_static <- get_static(dataset = 'ECB_RTD1')
rtd_data <- get_data(dataset = 'RTD')

save(rtd_static, rtd_data,
     file = '~/Data/ECB Data/rtd.RData')



mir_static <- get_static(dataset = 'ECB_MIR1')
mir_data <- get_data(dataset = 'MIR')

save(mir_static, mir_data,
     file = '~/Data/ECB Data/mir.RData')

stp_static <- get_static(dataset = 'ECB_STP1')
stp_data <- get_data(dataset = 'STP')

save(stp_static, stp_data,
     file = '~/Data/ECB Data/stp.RData')

sts_static <- get_static(dataset = 'ECB_STS1')
sts_data <- get_data(dataset = 'STS')

save(sts_static, sts_data,
     file = '~/Data/ECB Data/sts.RData')


trd_static <- get_static(dataset = 'ECB_TRD1')
trd_data <- get_data(dataset = 'TRD')

save(trd_static, trd_data,
     file = '~/Data/ECB Data/trd.RData')

wts_static <- get_static(dataset = 'ECB_WTS1')
wts_data <- get_data(dataset = 'WTS')

save(wts_static, wts_data,
     file = '~/Data/ECB Data/wts.RData')


ssi_static <- get_static(dataset = 'ECB_SSI1')
ssi_data <- get_data(dataset = 'SSI')

save(ssi_static, ssi_data,
     file = '~/Data/ECB Data/ssi.RData')

safe_static <- get_static(dataset = 'ECB_SAFE')
safe_data <- get_data(dataset = 'SAFE')

save(safe_static, safe_data,
     file = '~/Data/ECB Data/safe.RData')


fvc_static <- get_static(dataset = 'ECB_FVC1')
fvc_data <- get_data(dataset = 'FVC')

save(fvc_static, fvc_data,
     file = '~/Data/ECB Data/fvc.RData')

fmd_static <- get_static(dataset = 'ECB_FMD2')
fmd_data <- get_data(dataset = 'FMD2')

save(fmd_static, fmd_data,
     file = '~/Data/ECB Data/fmd.RData')


eon_static <- get_static(dataset = 'ECB_EON1')
eon_data <- get_data(dataset = 'EON')

save(eon_static, eon_data,
     file = '~/Data/ECB Data/eon.RData')


dd_static <- get_static(dataset = 'ECB_DD1')
dd_data <- get_data(dataset = 'DD')

save(dd_static, dd_data,
     file = '~/Data/ECB Data/dd.RData')


ccp_static <- get_static(dataset = 'ECB_CCP1')
ccp_data <- get_data(dataset = 'CCP')

save(ccp_static, ccp_data,
     file = '~/Data/ECB Data/ccp.RData')


cbd_static <- get_static(dataset = 'ECB_CBD1')
cbd_data <- get_data(dataset = 'CBD')

save(cbd_static, cbd_data,
     file = '~/Data/ECB Data/cbd.RData')


dd_static <- get_static(dataset = 'ECB_DD1')
dd_data <- get_data(dataset = 'dd')

save(dd_static, dd_data,
     file = '~/Data/ECB Data/dd.RData')
