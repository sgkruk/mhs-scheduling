# Introduction #

Comments from reviewing relevant literature.

# Practice and theory of automated timetabling III #
# ISSN 0302-9743 (Print) 1611-3349 (Online) #

## Cyclical Staff Scheduling Using Constraint Logic Programming ##
## Peter Chan and Georges Weil ##
## Pages 159-175 ##

  * The MHS problem is an example of a **non-cyclic timetable**
  * We should include an example of a **cyclic timetable**
  * Constraint programming language CHIP Vx suggests itself as an implemenation of our API

## Solving Rostering Tasks as Constraint Optimization ##
## Harald Meyer auf’m Hofe ##
## Pages 191-212 ##

  * The ORBIS Dientsplan System suggests itself as a comparison tool. For the same input of a nurse rostering problem, our API's output could be compared and measured against.
  * Shift preference suggests itself as soemthing that should be represented in the objective function of at least one of our examples
  * While I an not sure the heriarchical aspect is relevant, I like the section 2.1 overview, but perhaps hierarchical ordering of constraints could help solve difficult cases although I do not feel a need to introduce that into our API or initial implementations at this time.
  * I like the branch-and-bound and interative repair overviews in 3.2

## Modelling Timetabling Problems with STTL ##
## Jeffrey H. Kingston ##
## Pages 309-321 ##

  * It might be worthwhile to find problems solved by STTL that can be compared against inputting the same problem into implemenations of our API.

# Practice and theory of automated timetabling II #
# ISSN 0302-9743 (Print) 1611-3349 (Online) #

## Scheduling, timetabling and rostering — A special relationship? ##
## Anthony Wren ##
## Pages 46-75 ##

  * The Introduction (1) shows that the MHS example and general class of problems being address is **scheduling** and not **timetabling**. However in Defniitions Revisited (3) it would seem **rostering** is the word. (3) Admits to using "more restrictive" definitons.