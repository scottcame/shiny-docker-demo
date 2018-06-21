library(shiny)
library(tidyverse)
library(RMariaDB)
library(xml2)

DB_HOST = 'mariadb'

ui <- fluidPage(
  h3(textOutput('tableName', inline=TRUE), ":"), tableOutput('tt')
)

server <- function(input, output, session) {
  
  assertion <- session$request$HTTP_SHIB_ASSERTION_01
  # ignoring SSL errors is ok.  In a Docker context, there is no way to get a spoofed url
  a <- read_xml(httr::GET(assertion, config = httr::config(ssl_verifyhost = FALSE, ssl_verifypeer=FALSE)))
  org <- a %>% xml_find_first('/saml2:Assertion/saml2:AttributeStatement/saml2:Attribute[@Name="o"]/saml2:AttributeValue') %>% xml_text()
  
  orgType <- gsub(x=org, pattern='.+([A-Z])$', replacement='\\1')
  output$tableName <- renderText(paste0('Table t1', orgType))
  
  conn <- dbConnect(MariaDB(), host=DB_HOST, dbname='demo1', user='root')
  tt <- dbReadTable(conn, paste0('t1', orgType))
  output$tt <- renderTable(tt)
  dbDisconnect(conn)
  
}

shinyApp(ui, server)
