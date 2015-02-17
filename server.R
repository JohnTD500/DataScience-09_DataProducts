# file: server.R
# purpose: This is the 'shiny' server file for an application that simulates
#   a series of bets where the bet size is determined by the Kelly criterion.

source("helpers.R")

# Define server
shinyServer(function(input, output) {
    # Create an environment for storing data
    symbol_env <- new.env()

    # Update variables:
    Odds           <- reactive({input$radio.1})
    failures       <- reactive({as.numeric(odds.against(Odds()))})
    Implied.Prob   <- reactive({odds2prob(Odds())})
    Win.Prob       <- reactive({input$Win.Prob/100})
    Edge           <- reactive({round((Win.Prob() - Implied.Prob()), 2)*100})
    Kelly.Bet      <- reactive({f.star(Win.Prob(), failures())})
    Kelly.Fraction <- reactive({input$Kelly.Fraction/100})

    # Simulation Conditions:
    output$text.odds <- renderText({paste0("Bookmaker's odds: ", Odds())})
    output$text.implied.prob <- renderText({paste0("Bookmaker's implied probability: ",
                                                   round(Implied.Prob()*100, 0), "%")})
    output$text.win.prob <- renderText({paste0("Probability with inside information : ",
                                               round(input$Win.Prob,0),"%")})
    output$text.edge <- renderText({paste0("Edge: ", Edge(),"%")})
    output$text.kelly.bet <- renderText({paste0("Kelly bet (percentage of bankroll to bet): ",
                                                round(Kelly.Bet()*100,1),'%')})
    output$text.sim.bankroll <- renderText({paste0("Starting bankroll: $",
                                                   Sim.Options$bankroll)})
    output$text.sim.n <- renderText({paste0("Number of simulations run: ",
                                            Sim.Options$sims)})
    output$text.sim.steps <- renderText({paste0("Simulation steps (a bet occurs at each step): ",
                                                Sim.Options$steps)})
    output$text.sim.kelly.fraction <- renderText({paste0("Kelly fraction: ",
                                                         Kelly.Fraction())})

    # Simulation:
    kelly.sim <- reactive({
        kelly.simulation(InitialBankroll = Sim.Options$bankroll,
                         SimulationNumber = Sim.Options$sims,
                         SimulationSteps = Sim.Options$steps,
                         Payoff = failures(),
                         WinProb = Win.Prob(),
                         KellyBet = Kelly.Bet(),
                         KellyFraction = Kelly.Fraction())
    })

    # Get median of all runs for each simulation step:
    sim.median.series <- reactive({apply(kelly.sim(), 1, median)})

    # Plot first 100 world lines:
    output$World.Lines <- renderPlot({
        mycolors <- colors()

        plot(x=seq(1:(Sim.Options$steps+1)), y=sim.median.series(),
             ylim = c(0,100000),
             type = "l", lwd = 5, col = "red",
             xlab = "Trials",
             ylab = "Bankroll ($)",
             main = "Kelly Criterion Simulation")

        for (i in 1:50) points(kelly.sim()[,i], type = "l", col = mycolors[i])
    })

    # Simulation Statistics:
    output$text.sim.max <- renderText({paste0("Maximum Bankroll: $",
                          round(max(kelly.sim()[Sim.Options$steps+1,]),0))})
    output$text.sim.mean <- renderText({paste0("Average Bankroll: $",
                          round(mean(kelly.sim()[Sim.Options$steps+1,]),0))})
    output$text.sim.median <- renderText({paste0("Median Bankroll: $",
                          round(median(kelly.sim()[Sim.Options$steps+1,]),0))})
    output$text.sim.min <- renderText({paste0("Minimum Bankroll: $",
                          round(min(kelly.sim()[Sim.Options$steps+1,]),0))})

    # Update status message:
    output$status <- renderUI({
    if( Edge() <= 0 ) {
        HTML(paste0("<b>Status</b>: <b><font color='red'>Warning: </font></b>",
                    "Your edge is ", Edge(), "%"))
    } else if( Kelly.Fraction() > 1 ) {
        HTML(paste0("<b>Status</b>: <b><font color='red'>Warning: </font></b>",
                    "Your Kelly fraction is ", Kelly.Fraction()))
    } else {
        HTML("<b>Status</b>: <b><font color='green'>Ok</font></b>")}
    })
})
