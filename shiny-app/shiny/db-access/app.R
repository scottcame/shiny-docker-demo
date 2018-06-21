library(shiny)
library(tidyverse)
library(RMariaDB)

DB_HOST = 'mariadb'

ui <- fluidPage(
  h3('Table T1A: '), tableOutput('t1A'),
  h3('Table T1B: '), tableOutput('t1B')
)

server <- function(input, output, session) {
  
  conn <- dbConnect(MariaDB(), host=DB_HOST, dbname='demo1', user='root')
  t1A <- dbReadTable(conn, 't1A')
  output$t1A <- renderTable(t1A)
  t1B <- dbReadTable(conn, 't1B')
  output$t1B <- renderTable(t1B)
  dbDisconnect(conn)
  
}

shinyApp(ui, server)
