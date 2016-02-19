.onLoad <- function(libname = find.package('ecbapi'),
                    pkgname = 'ecbapi'){
    options(sdw.loc = 'external')
    options(sdw.roots = list(
                internal = 'https://sdw-ecb-wsrest.ecb.de',
                external = 'https://sdw-wsrest.ecb.europa.eu'
            ))

    getOption('sdw.roots')[[getOption('sdw.loc')]] ->
        sdw.default

    message(sprintf('Default ECB SDW access point (%s):\n\n%s',
                    getOption('sdw.loc'),
                    sdw.default))
}
