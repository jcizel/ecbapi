.onLoad <- function(libname = find.package('ecbapi'),
                    pkgname = 'ecbapi'){
    options(sdw.loc = 'external')
    options(sdw.roots = list(
                internal = 'https://sdw-ecb-wsrest.ecb.de',
                external = 'https://sdw-wsrest.ecb.europa.eu'
            ))

    getOption('sdw.roots')[[getOption('sdw.loc')]] ->
        sdw.default

    message(rep("*",70))
    message("ECB SDW Downloader")
    message("By Janko Cizel, 2016. All rights reserved.")
    message("www.jankocizel.com")
    message(rep("*",70))
    
    message(sprintf('Default ECB SDW access point (%s):\n\n%s',
                    getOption('sdw.loc'),
                    sdw.default))

    message(rep("*",70))

    message("To view all available datasets, use the following query:\n")
    message(sprintf("ecbAvailability()\n"))
    
    message("To download entire dataset, use the following query:\n")
    message(sprintf("ecbDataset(datasetId = '[Input datasetId]')\n"))

    message("To download only matching series from a dataset, use the following query:\n")
    message(sprintf("ecbSeries(datasetId = '[Input datasetId]',pattern = '[series pattern]')\n"))

    message(rep("*",70))
    message("Thank you for using the package.")
    message("In case of errors or suggestions do not hesitate to contact me via:\n")
    message('www.jankocizel.com')
    message(rep("*",70))
}
