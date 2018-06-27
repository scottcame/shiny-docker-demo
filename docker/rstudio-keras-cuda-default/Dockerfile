ARG tftype=default

FROM scottcame/r-keras-cuda-${tftype}

RUN curl -O https://download2.rstudio.org/rstudio-server-1.1.453-amd64.deb

# borrowed bits and pieces of the install from rocker rstudio image at
# https://github.com/rocker-org/rocker-versioned/blob/master/rstudio/3.5.0/Dockerfile

#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License along
#    with this program; if not, write to the Free Software Foundation, Inc.,
#    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

RUN apt-get update && \
  apt-get install -y gdebi-core git && \
  gdebi -n rstudio-server-1.1.453-amd64.deb && \
  echo 'server-app-armor-enabled=0' > /etc/rstudio/rserver.conf && \
  useradd rstudio && echo "rstudio:rstudio" | chpasswd && mkdir /home/rstudio && chown rstudio:rstudio /home/rstudio && addgroup rstudio staff && \
  cp -r /root/.virtualenvs/ /home/rstudio/.virtualenvs && \
  ln -s /usr/lib/rstudio-server/bin/pandoc/pandoc /usr/local/bin && \
  ln -s /usr/lib/rstudio-server/bin/pandoc/pandoc-citeproc /usr/local/bin && \
  git clone https://github.com/jgm/pandoc-templates && \
  mkdir -p /opt/pandoc/templates && \
  cp -r pandoc-templates*/* /opt/pandoc/templates && rm -rf pandoc-templates* && \
  mkdir /root/.pandoc && ln -s /opt/pandoc/templates /root/.pandoc/templates && \
  apt remove -y gdebi-core && apt autoremove -y && \
  echo 'rsession-which-r=/usr/local/bin/R' >> /etc/rstudio/rserver.conf && \
  echo 'lock-type=advisory' >> /etc/rstudio/file-locks && \
  git config --system credential.helper 'cache --timeout=3600' && \
  git config --system push.default simple && \
  echo '\n\
    \n# Configure httr to perform out-of-band authentication if HTTR_LOCALHOST \
    \n# is not set since a redirect to localhost may not work depending upon \
    \n# where this Docker container is running. \
    \nif(is.na(Sys.getenv("HTTR_LOCALHOST", unset=NA))) { \
    \n  options(httr_oob_default = TRUE) \
    \n}' >> /usr/local/lib/R/etc/Rprofile.site && \
  echo "PATH=${PATH}" >> /usr/local/lib/R/etc/Renviron

CMD ["/usr/lib/rstudio-server/bin/rserver", "--server-daemonize", "0"]
