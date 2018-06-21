library(shiny)
library(tidyverse)

ui <- fluidPage(
   h5('Server Info: '), verbatimTextOutput("info")
)

server <- function(input, output, session) {
   
   hostname <- Sys.info()['nodename']
   ip <- 'Unknown'
   
   os <- Sys.info()['sysname']
   
   interface <- 'eth0'
   command <- '/sbin/ifconfig'
   
   if (os == 'Darwin') {
      interface <- 'en0'
      command <- 'ifconfig'
   }
   
   ifconfigOutput <- trimws(system(paste0(command, ' ', interface), intern=TRUE))
   s <- ifconfigOutput[grepl(x=ifconfigOutput, pattern='^inet ')]
   ip <- gsub(x=s, pattern='inet [^0-9]*((?:[0-9]{1,3}\\.){3}(?:[0-9]{1,3})).+', replacement='\\1', perl=TRUE)
   
   output$info <- renderText({
      paste0('Hostname: ', hostname, ", IP address: ", ip)
   })
   
}

shinyApp(ui, server)
