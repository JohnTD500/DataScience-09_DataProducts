# Functions:

# Calculate the fraction of bankroll to bet (Kelly Criterion):
# Reference: http://en.wikipedia.org/wiki/Kelly_criterion
#   p:      probability of winning
#   b:      fractional odds _against_
#   return: fraction to bet
f.star <- function(p, b) {
    return((p*(b+1)-1) / b)
}

# Convert 'odds against' into 'probability on':
#   odds.string: character string representing odds against ratio
#     (FORMAT: odds.against-odds.favor)
#   return:      probability for event
odds2prob <- function(odds.string) {
    odds <- as.numeric(unlist(strsplit(odds.string, "-", perl=TRUE)))
    return(odds[2] / (odds[1] + odds[2]))
}
# Calculate odds against:
#   odds.string: character string representing odds against ratio
#     (FORMAT: odds.against-odds.favor)
#   return:      frequency against / frequency for
odds.against <- function(odds.string) {
    odds <- as.numeric(unlist(strsplit(odds.string, "-", perl=TRUE)))
    return(odds[1] / odds[2])
}
# Resolve a bet if result is ...
#     -1: You lose your original wager
#     +1: You get your original wager back + Payoff*(original wager)
# Inputs
#   result:        +1 for win, -1 for loss
#   KellyBet:      Kelly bet (percentage of bankroll wagered)
#   KellyFraction: Fraction Kelly bet
#   Payoff:        bet paid for winning
# Return
#   bankroll multiplier for gain/loss of bet
resolveBet <- function(result, KellyBet, KellyFraction, Payoff) {
    if(result < 0) {  ## loss: you lose your bet
        1 - KellyBet*KellyFraction
    } else {  ## win: you win your bet PLUS the payoff
        1 + KellyBet*KellyFraction * Payoff
    }
}
# Testing for 'resolveBet()'
# resolveBet(-1, 0.07, 1.0, 1)  # Expect: 0.93
# resolveBet(-1, 0.07, 1.0, 2)  # Expect: 0.93
# resolveBet( 1, 0.07, 1.0, 1)  # Expect: 1.14
# resolveBet( 1, 0.07, 1.0, 2)  # Expect: 1.21
# resolveBet( 1, 0.07, 0.5, 2)  # Expect: 1.105
# resolveBet( 1, 0.07, 1.0, 3)  # Expect: 1.28

# Simulation constants:
Sim.Options <- data.frame(bankroll=1000,
                          sims=1000,
                          steps=500)

# Name: kelly.simulation
# Purpose:
#   This function performs the Monte Carlo simulation of a Kelly bet
#   made at every simulation step.
# Inputs:
#   InitialBankroll:  Starting money position
#   SimulationNumber: Number to steps in simulation
#   SimulationSteps:  Number of Simulations
#   WinProb:          Probability with inside information
#   KellyBet:         Fraction of bankroll to bet
#   KellyFraction:    Fraction of Kelly bet to take
# Outputs:
#   Bankroll.Matrix:  Bankroll for every simulation at every simulation step
kelly.simulation <- function(InitialBankroll,
                             SimulationNumber,
                             SimulationSteps,
                             Payoff,
                             WinProb,
                             KellyBet,
                             KellyFraction) {
    # Generate a matrix of random numbers and compare to the prob of winning:
    #   (1 means you won the bet; -1 means you lost)
    sim.uniform <- matrix(runif(SimulationSteps*SimulationNumber, 0, 1),
                          nrow = SimulationSteps,
                          ncol = SimulationNumber)
    sim.results <- ifelse(WinProb >= sim.uniform, 1, -1)
    
    # Determine the payout using sim.results:
    sim.multiplier <- matrix(1, nrow = SimulationSteps, ncol = SimulationNumber)
    for (sim in seq(1,SimulationNumber)) {
        for (step in seq(1,SimulationSteps)) {
            sim.multiplier[step,sim] <- resolveBet(sim.results[step,sim], KellyBet, KellyFraction, Payoff)
        }
    }
    
    # Create the bankroll simulation over each simulation step
    Bankroll.Vector <- rep(InitialBankroll, SimulationNumber)
    Bankroll.Matrix <- apply(rbind(Bankroll.Vector, sim.multiplier), 2, cumprod)
    row.names(Bankroll.Matrix) <- NULL
    
    # Return the variation of bankroll over each step for the defined number of simulations
    #  (Rows = Each Bet Decision Point / Column = Each simulation)
    return(Bankroll.Matrix)
}
