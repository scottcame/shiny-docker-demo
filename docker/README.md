### Docker Images

This directory contains the Dockerfiles and associated contexts for building images that are part of the demonstration.  The images are:

* *demo-mariadb:* A small [MariaDB](https://mariadb.org/) database pre-loaded with some simple demo data used in Shiny apps
* *shiny-apache-shib-sp:* An [Apache web/proxy server](https://httpd.apache.org/) configured with the [Shibboleth Service Provider](https://wiki.shibboleth.net/confluence/display/SHIB2/NativeSPGettingStarted) to gate access to services and proxy http traffic
* *shiny-idp:* A [Shibboleth Identity Provider](https://wiki.shibboleth.net/confluence/display/IDP30/Home) to respond to SAML authentication requests and form/share assertions with the Service Provider (and, indirectly, with backend apps)
* *shiny-openldap:* An [Open LDAP server](https://www.openldap.org/) to store and manage user authentication credentials and user attributes, which form the basis of assertions made by the Identity Provider and relied upon (and trusted) by the Service Provider and backend apps
* *shiny-tomcat8-proxied:* A [Tomcat J2EE Servlet Container](http://tomcat.apache.org/) used to host the Identity Provider (and is available for easily hosting any other Java Web Application)
* *shiny:* A [Shiny Server](https://shiny.rstudio.com/) instance, tweaked to pass through http headers added by Shibboleth, that will host Shiny apps for the demonstration
* *tidyverse-mariadb:* A derived image from the [Rocker project's](https://github.com/rocker-org/rocker) [tidyverse](https://hub.docker.com/r/rocker/tidyverse/) image, extended to include the [RMariaDB package](https://cran.r-project.org/web/packages/RMariaDB/index.html) and system libraries on which the package depends

Note that all of these images are maintained in Docker Hub on my [site](https://hub.docker.com/u/scottcame/).

This directory also contains two [Docker Compose](https://docs.docker.com/compose/) files: one that orchestrates the Shiny demo, and the other that runs an instance of RStudio Server in a container along with the demo MariaDB.
