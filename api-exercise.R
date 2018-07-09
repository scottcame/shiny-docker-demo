# docker run -it --rm --mount "type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock" -e COLUMNS=250 rocker/tidyverse:3.5.0 R

options(width=Sys.getenv('COLUMNS'))

library(jsonlite)
library(httr)
library(tidyverse)

GET('http://localhost/images/json', config(unix_socket_path='/var/run/docker.sock')) %>%
  .$content %>%
  rawToChar() %>%
  fromJSON() %>%
  select(-Labels) %>%
  as_tibble() %>%
  unnest(RepoTags) %>%
  filter(grepl(x=RepoTags, pattern='shiny'))
