# Introduction #

He purpose of this Wiki article is to consider the MHS scheduling project as continuum to this point and to suggest ideas for a new approach. Post-Mortem or Re-Assessment?

# Details #

1.The current state represents hundreds of hours of work for complex, hard to follow solution that even if given many hours of computing time can yield only unacceptable solutions that are too far from what a human can do in less time.

2.The current structure of a list of nested structures is unwieldy. A better structure there must be. In my heart, I'd like to see matrices of integers. What comes to mind is 7 columns (one for each day of the week) and a row for each week considered. Each entry could be a tuple representing each employee's state for that day, or a matrix for each employee could next within a set of employee-matrices. Sets of row and column vectors can be considered and analyzed for such constraints as max/min number of employees per day and/or per day type (weekday vs. weekend) as well as employee time-off constraints (5 days/wk., a pair of consecutive days off, etc.). Perhaps specialized ECLiPSe libraries would be developed to effect this.

3.Shift scheduling has an inherent week-basis and this is a sounder approach than our current day-basis. Ideally, we should draw on a store or factory that produces week templates.

4.We started out trying to meet and model all known constraints of a real system. We should have started less ambitiously and grown incrementally a generalized, flexible solution from the get-go.

5.A truly general solution needs an extensibility into areas unique to each scheduling scenario. Our own problem example with its needs for “keys” and “licenses” doesn't generalize well.

6.Initial solutions should be run and tried through calendars and possibilities so small and cardinality that all solutions can be done reasonable by hand to guarantee a sound approach.

7.An accurate, abstract mathematical description should be kept as an inviolable document along the way so that the theoretical description never varies from the applied solution.