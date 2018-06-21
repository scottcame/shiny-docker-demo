library(shiny)
library(xml2)
library(lubridate)
library(tidyverse)

parseAssertion <- function(assertionUrl) {

  # ignoring SSL errors is ok.  In a Docker context, there is no way to get a spoofed url
  a <- read_xml(httr::GET(assertionUrl, config = httr::config(ssl_verifyhost = FALSE, ssl_verifypeer=FALSE)))

  ret <- list()

  ret$IssuedDateTime <- a %>% xml_find_first('/saml2:Assertion/@IssueInstant') %>% xml_text() %>% as_datetime()
  ret$Issuer <- a %>% xml_find_first('/saml2:Assertion/saml2:Issuer') %>% xml_text()
  ret$ExpirationDateTime <- a %>% xml_find_first('/saml2:Assertion/saml2:Conditions/@NotOnOrAfter') %>% xml_text() %>% as_datetime()
  ret$AuthenticationDateTime <- a %>% xml_find_first('/saml2:Assertion/saml2:AuthnStatement/@AuthnInstant') %>% xml_text() %>% as_datetime()
  ret$AuthenticationContextClass <- a %>% xml_find_first('/saml2:Assertion/saml2:AuthnStatement/saml2:AuthnContext/saml2:AuthnContextClassRef') %>% xml_text()

  ret$Attributes <- map_df(xml_find_all(a, '//saml2:Attribute'), function(node) {
    tibble(Attribute=xml_attr(node, 'Name'), Value=xml_text(xml_find_first(node, 'saml2:AttributeValue')))
  })

  ret

}

ui <- fluidPage(
  h5('Server Info: '), verbatimTextOutput("info"),
  # h5('Shib url: '), verbatimTextOutput("shib"),
  h5('SAML Authentication Information: '), uiOutput('bList'),
  h5('Assertion Attributes:'), tableOutput('assertionAttributes')
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

  #output$shib <- renderText({
  #    session$request$HTTP_SHIB_ASSERTION_01
  #})

  assertion <- session$request$HTTP_SHIB_ASSERTION_01

  if (is.null(assertion)) {

    output$bList <- renderUI({tags$p(tags$span('No authentication info:  shiny is not running in a SAML context.', style='font-family: italic'))})
    output$assertionAttributes <- renderUI({tags$p(tags$span('No assertion attributes:  shiny is not running in a SAML context.', style='font-family: italic'))})

  } else {

    assertionList <- parseAssertion(assertion)

    output$bList <- renderUI({
      tags$ul(
        tags$li(paste0('Assertion Issued At: ', assertionList$IssuedDateTime)),
        tags$li(paste0('Assertion Issued By: ', assertionList$Issuer)),
        tags$li(paste0('Assertion Expires At: ', assertionList$ExpirationDateTime)),
        tags$li(paste0('Authentication Occurred At: ', assertionList$AuthenticationDateTime)),
        tags$li(paste0('Authentication Class: ', assertionList$AuthenticationContextClass))
      )
    })

    output$assertionAttributes <- renderTable(assertionList$Attributes)

  }

}

shinyApp(ui, server)
