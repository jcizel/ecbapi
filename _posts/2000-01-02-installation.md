---
title: ""
bg: lightred
color: white
fa-icon: check-square-o
---

# Installation #

{% highlight r linenos=table %}
install.packages('devtools') ## Only if you don't have it installed yet..
devtools::install_github("jcizel/ecbapi")
require(ecbapi)
{% raw %}
{% endraw %}
## THIS RETURNS THE FOLLOWING:
## **********************************************************************
## ECB SDW Downloader
## By Janko Cizel, 2016. All rights reserved.
## www.jankocizel.com
## **********************************************************************
## Default ECB SDW access point (external):
## https://sdw-wsrest.ecb.europa.eu
## **********************************************************************
## To view all available datasets, use the following query:
## ecbAvailability()
## To download entire dataset, use the following query:
## ecbDataset(datasetId = '[Input datasetId]')
## To download only matching series from a dataset, use the following query:
## ecbSeries(datasetId = '[Input datasetId]',pattern = '[series pattern]')
## **********************************************************************
## Thank you for using the package.
## In case of errors or suggestions do not hesitate to contact me via:
## www.jankocizel.com
## **********************************************************************
{% raw %}
END
{% endraw %}
{% endhighlight %}

