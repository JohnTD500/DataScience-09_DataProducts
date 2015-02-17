---
title       : A Kelly Criterion Monte Carlo Simulation Application
subtitle    : Data Science - Data Products Project
author      : John Tiede
job         : 
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : [mathjax]     # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
---

<!-- Limit image width and height -->
<style type='text/css'>
img {
    max-height: 560px;
    max-width: 964px;
}
</style>

<!-- Center image on slide -->
<script src="http://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.7.min.js"></script>
<script type='text/javascript'>
$(function() {
    $("p:has(img)").addClass('centered');
});
</script>

## What is the Kelly Criterion?

* A formula used to determine the optimal sizes of a series of wagers
* Depends on given odds and your edge
* Developed by [John L. Kelly, Jr.](http://en.wikipedia.org/wiki/John_Larry_Kelly,_Jr.) at [Bell Laboratories](http://en.wikipedia.org/wiki/Bell_Labs) in 1956 using [Information Theory](http://en.wikipedia.org/wiki/Information_theory)
<img class=center src=./assets/img/JohnLKellyJr.png height=200>
* Kelly Criterion Rules (Long betting runs are assumed):
    + Only bet if you have a known edge over the house odds, otherwise never bet
    + Bet a proportion of your bankroll (NOT a [martingale](http://en.wikipedia.org/wiki/Martingale_%28betting_system%29) betting scheme)
    + Volatility can be reduced by betting a fraction of the recommended Kelly bet, but fractional Kelly bets sacrifice performance (growth of bankroll)

--- .class #id 

## Example Calculation of a Kelly Bet

* When gambling, odds are expressed as 'odds against'
* Example: "3 to 1" against is interpreted as...
    + 3 times you lose & 1 time you win; probability "for" is $1/(1+3)=0.25$
    + If you win, you get your wager back **plus** 3 times your wager
    + If you lose, you lose your wager
* Kelly Criterion is this equation where 'p' is the probability with inside information and 'b' is the times you lose the bet ("3" in the example above):

$$f^*=\frac{p*(b+1)-1}{b}$$

* Example: Let p be 32% (0.32), odds against be "3 to 1", then the proportion of your bankroll you should wager is...

$$f^*=\frac{0.32*(3+1)}{3}=0.093$$

--- .class #id 

## Kelly Criterion Monte Carlo Simulation Application

* Purpose is to give an intuition of the exponential growth of a bankroll using optimum bet sizing
* Application runs a series of 1000 simulations of 500 steps ("bets") each, given...
    + Odds against
    + Probability with inside information
    + Fraction of Kelly bet to wager
* It produces...
    + Statistics for 1000 simulations after the final bet (median, mean, minimum, maximum)
    + Graph of the first 50 simulations and the median of all simulations

--- .class #id 

## Kelly Criterion Bet Size Calculation


```r
# Calculate the fraction of bankroll to bet (Kelly Criterion):
#   p:      probability of winning
#   b:      fractional odds _against_
#   return: fraction to bet
f.star <- function(p, b) {
    return((p*(b+1)-1) / b)
}

# p=0.57, b=1
f.star(0.57, 1)
```

```
## [1] 0.14
```

```r
# p=0.38, b=2
f.star(0.38, 2)
```

```
## [1] 0.07
```



