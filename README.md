### Shiny Docker Demo

This repository contains a demonstration of how to host a [Shiny](https://shiny.rstudio.com/) app in [Docker](https://www.docker.com/).

The `docker` directory contains Dockerfiles and contexts for a set of images necessary for the demonstration.  There are also
compose files for a couple of demonstration scenarios.

The `shiny-app` directory contains an RStudio project and several Shiny apps to demonstrate various features.

The `australia-elex-2016` directory contains an RStudio project that performs some basic analysis on data from the 2016 Federal election in Australia.  It serves
as a demo of using Docker to support [reproducible research](http://ropensci.github.io/reproducibility-guide/sections/introduction/).

The original setting for this demonstration was a tutorial at the [useR! 2018 Conference](https://user2018.r-project.org/).  I will continue
evolving the demonstration as new Docker features become available, and based on feedback/PRs from tutorial attendees and others.
