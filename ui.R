# file: ui.R
# purpose: This is the 'shiny' ui file for an application that simulates
#   a series of bets where the bet size is determined by the Kelly criterion.

# Define UI for an application that plots a collection of curves representing a series of bets.
shinyUI(pageWithSidebar(
    headerPanel("Kelly Criterion: An Optimal Betting Strategy"),

    # Sidebar with a slider input for number of observations
    sidebarPanel(
        radioButtons("radio.1", "Odds Against",
                     choices=c("1-1",
                     "3-2",
                     "2-1",
                     "5-2",
                     "3-1",
                     "7-2",
                     "4-1",
                     "5-1",
                     "9-2",
                     "6-1")),

        sliderInput("Win.Prob", "Probability (%) with Inside Information",
                    value=57, min=0, max=100, step=1),

        sliderInput("Kelly.Fraction", "Kelly Fraction (%)", value=100,
                    min=0, max=100, step=1),

        p("Press the Run button for a new simulation."),
        submitButton("Run"),
        htmlOutput("status"),
        hr(),

        strong("Directions"),
        p("Set the odds you are given from your bookie using the 'Odds Against' radiobuttons."),
        p("For example, if the bookie thinks your probability of success (plus his
          cut) is 0.25 (25%), then he sets the gambling odds at 3 to 1."),
        hr(),
        p("Use the 'Probability with Inside Information' slider to set the probability
          you believe to be actually the case for the bet."),
        p("If you do not have an edge over the odds given to you by the bookie,
          you should't bet. This is a decision rule of the Kelly criterion."),
        p("If you do not have an edge, you will be warned in the 'Status' message."),
        hr(),
        p("Use the 'Kelly Fraction' slider to set the Kelly fraction."),
        p("The Kelly fraction is the fraction of a full Kelly bet that you are
          comfortable making. It is possible to bet more than the Kelly bet, but
          that is the difference between aggression and insanity.")
    ),

    # Show a plot of the generated distribution
    mainPanel(
        tabsetPanel(
            tabPanel("Main",
                     strong("Simulation Conditions:"),
                     textOutput("text.odds"),
                     textOutput("text.implied.prob"),
                     textOutput("text.win.prob"),
                     textOutput("text.edge"),
                     textOutput("text.kelly.bet"),
                     textOutput("text.sim.bankroll"),
                     textOutput("text.sim.n"),
                     textOutput("text.sim.steps"),
                     textOutput("text.sim.kelly.fraction"),
                     hr(),

                     p("First 50 Simulations Plus the Median of All 1000 Simulations
                       (Thick Red Line)"),
                     plotOutput("World.Lines"),
                     hr(),

                     strong("Simulation Statistics:"),
                     textOutput("text.sim.min"),
                     textOutput("text.sim.mean"),
                     textOutput("text.sim.median"),
                     textOutput("text.sim.max"),
                     hr()),

            tabPanel("About",
                     p("This application demonstrates a simple Monte Carlo simulation
                       of the Kelly criterion using the ",
                       a("Shiny", href="http://www.rstudio.com/shiny/"),
                       "framework. The Kelly criterion is a formula used to
                       determine the optimal size for a series of bets where the bettor
                       has a known edge over house odds."),
                     hr(),

                     strong("Author"), p("John Tiede"),
                     br(),

                     strong("Code"), p("Source code for this application at",
                                       a("GitHub", href="https://github.com/JohnTD500XXX")),
                     br(),

                     strong("References"),
                     p(HTML("<ul>"),
                       HTML("<li>"),p(a("Teach yourself Shiny", href="http://shiny.rstudio.com/tutorial/")),HTML("</li>"),
                       HTML("<li>"),p(a("On-Line Kelly Criterion Calculator", href="http://www.albionresearch.com/kelly/")),HTML("</li>"),
                       HTML("<li>"),p("Wikipedia: ",a("Kelly Criterion", href="http://en.wikipedia.org/wiki/Kelly_criterion")),HTML("</li>"),
                       HTML("<li>"),p("Wikipedia: ",a("Odds", href="http://en.wikipedia.org/wiki/Odds")),HTML("</li>"),
                       HTML("<li>"),p("Quantative Finance:",a("Kelly Capital Growth Investment Strategy (Example in R)", href="http://quant.stackexchange.com/questions/12868/kelly-capital-growth-investment-strategy-example-in-r")),HTML("</li>"),
                       HTML("<li>"),p(a("Fortune's Formula: The Untold Story of the Scientific Betting System That Beat the Casinos and Wall Street",href="http://www.amazon.com/Fortunes-Formula-Scientific-Betting-Casinos/dp/0809045990/ref=sr_1_3?s=books&ie=UTF8&qid=1423622694&sr=1-3&keywords=william+poundstone"),", William Poundstone, Hill and Wang, 2006, ISBN 978-0809045990."),HTML("</li>"),
                       HTML("</ul>")))
        )
    )
))
