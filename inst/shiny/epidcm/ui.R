##
## UI File for epidcm Shiny Application
##
## Run local: epiweb(class = "dcm")
## Run online: http://statnet.shinyapps.io/epidcm/
##

library(shiny)
library(EpiModel)

shinyUI(pageWithSidebar(

  # Header
  headerPanel("EpiModel: Deterministic Compartmental Models"),

  # Sidebar
  sidebarPanel(

    h4("Instructions"),
    helpText("Click Run Model after changing model parameters",
             "or conditions."),
    actionButton(inputId = "runMod", "Run Model"),
    br(), br(),

    h4("Model Type"),
    selectInput(inputId = "modtype",
                label = "",
                choices = c("SI", "SIR", "SIS")),
    br(),

    h4("Initial Conditions"),
    numericInput(inputId = "s.num",
                 label = "Number Susceptible",
                 value = 1000,
                 min = 0),
    numericInput(inputId = "i.num",
                 label = "Number Infected",
                 value = 1,
                 min = 0),
    conditionalPanel("input.modtype == 'SIR'",
                     numericInput(inputId = "r.num",
                                  label = "Number Recovered",
                                  value = 0,
                                  min = 0)
    ),
    p(),


    h4("Time"),
    numericInput(inputId = "nsteps",
                 label = "Time Steps",
                 value = 500,
                 min = 0),
    numericInput(inputId = "dt",
                 label = "dt (Step Size)",
                 value = 1,
                 min = 0),
    br(), br(),

    h4("Parameters"),
    numericInput(inputId = "inf.prob",
                 label = "Transmission Probability per Act",
                 min = 0,
                 max = 1,
                 value = 0.1),
    br(),
    numericInput(inputId = "act.rate",
                 label = "Act Rate",
                 min = 0,
                 value = 0.5),
    br(),
    conditionalPanel("input.modtype != 'SI'",
                     numericInput(inputId = "rec.rate",
                                  label = "Recovery Rate",
                                  min = 0,
                                  value = 0), br()
    ),
    numericInput(inputId = "b.rate",
                 label = "Birth Rate",
                 min = 0,
                 value = 0.0),
    br(),
    numericInput(inputId = "ds.rate",
                 label = "Death Rate (Sus.)",
                 min = 0,
                 value = 0.0),
    br(),
    numericInput(inputId = "di.rate",
                 label = "Death Rate (Inf.)",
                 min = 0,
                 value = 0.0),
    br(),
    conditionalPanel("input.modtype == 'SIR'",
                     numericInput(inputId = "dr.rate",
                                  label = "Death Rate (Rec.)",
                                  min = 0,
                                  value = 0.0)
    )

  ), # End sidebarPanel

  mainPanel(
    tabsetPanel(

      tabPanel("Plot",
               h4("Plot of Model Results"),
               plotOutput(outputId = "MainPlot"),
               br(),
               wellPanel(
                 fluidRow(
                   column(5,
                          selectInput(inputId = "compsel",
                                      label = strong("Plot Selection"),
                                      choices = c("Compartment Prevalence",
                                                  "Compartment Size",
                                                  "Disease Incidence")),
                          p()
                   )
                 ),
                 fluidRow(
                   h5("Display Options"),
                   column(2,
                          checkboxInput(inputId = "showleg",
                                        label = "Legend",
                                        value = TRUE)
                   ),
                   column(5,
                          sliderInput(inputId = "alpha",
                                      label = "Line Transparency",
                                      min = 0.1,
                                      max = 1,
                                      value = 0.8,
                                      step = 0.1),
                          br()
                   )
                 ),
                 fluidRow(
                   h5("Download PDF"),
                   column(5,
                          downloadButton(outputId = "dlMainPlot",
                                         label = "Download")
                   )
                 )
               )
      ), # End tabPanel Plot


      tabPanel("Summary",
               h4("Time-Specific Model Summary"),
               helpText("Select the time step of interest and the number of
                        significant digits to output in the table and compartment
                        plot below."),
               p(),
               fluidRow(
                 column(5,
                        numericInput(inputId = "summTs",
                                     label = strong("Time Step"),
                                     value = 1,
                                     min = 1,
                                     max = 500)
                 ),
                 column(5,
                        numericInput(inputId = "summDig",
                                     label = strong("Significant Digits"),
                                     value = 3,
                                     min = 0,
                                     max = 8)
                 ),
                 p()
               ),
               fluidRow(
                 verbatimTextOutput(outputId = "outSummary"),
                 br()
               ),
               fluidRow(
                 h4("Compartment Plot"),
                 plotOutput(outputId = "CompPlot"),
                 downloadButton(outputId = "dlCompPlot",
                                label = "Download Plot"),
                 br(),br()
               )
               ), # End tabPanel Summary


      tabPanel("Data",
               h4("Model Data"),
               dataTableOutput("outData"),
               br(),br(),
               downloadButton(outputId = "dlData",
                              label = "Download Data")
      ), # End tabPanel Data


      tabPanel("About",
               p("This application solves and plots a deterministic, compartmental
                 epidemic models (DCMs). The model simulations are driven by the",
                 a("EpiModel", href = "http://cran.r-project.org/web/packages/EpiModel/index.html"),
                 "package in R."),
               p("Models here are limited to basic one-group homogenous mixing models with
                 a limited set of parameters, initial conditions, and control settings. More
                 complex models are available in the command-line version of EpiModel. For
                 further details, including more background on the mathematics and theory behind
                 these DCMs, please consult the documentation, tutorials, and workshop materials
                 at the main", a("EpiModel website.", href = "http://statnet.github.io/EpiModel")),
               p("This web application, built with",
                 a("Shiny", href="http://shiny.rstudio.com/"), "may be lauched via an R session with
                 EpiModel and Shiny installed (see the epiweb function), or directly on any web
                 browser (no R needed)", a("here.", href = "http://statnet.shinyapps.io/epidcm/")),
               br(),
               strong("Authors"), p("Samuel M. Jenness, Department of Epidemiology,
                                    University of Washington"),
               p("Steven M. Goodreau, Department of Anthropology,
                 University of Washington"),
               p("Martina Morris, Departments of Statistics and Sociology,
                 University of Washington")
               ) # End tabPanel About
               )
         )
))
