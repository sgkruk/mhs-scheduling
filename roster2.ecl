% This file represent an instance of the multi-level timeslots cover
% constraints.  This is a very simple structure to test
% functionalities of the inter-layer constraints

:- local struct(employees(all,managers,seniors)).

:- local struct(level1(all,monday,tuesday,wednesday,thursday,friday,saturday)).
:- local struct(level2(alll1,days,odddays,evendays)).
:- local struct(level3(alll2,week)).
:- local struct(timeslots(hourlevel:level1, 
                          daylevel:level2,
                          weeklevel:level3)).

getEmployees(E) :-
  E = employees{all:[1,2,3,4,5],
                managers:[1,2,3],
                seniors:[4,5]
                }.


getTimes(T) :-
  T = timeslots{all:[1,2,3,4,5,6,7,8,9,10,11,12],
                monday:[1,2],
                tuesday:[3,4],
                wednesday:[5,6],
                thursday:[7,8],
                friday:[9,10],
                saturday:[11,12],
                alll1:[all of level1,
                       monday of level1,
                       tuesday of level1,
                       wednesday of level1,
                       thursday of level1,
                       friday of level1,
                       saturday of level1],
                days:[monday of level1, 
                      tuesday of level1,
                      wednesday of level1,
                      thursday of level1,
                      friday of level1
                     ],
                odddays:[monday of level1,
                         wednesday of level1,
                         friday of level1
                        ],
                evendays:[tuesday of level1,
                          thursday of level1,
                          saturday of level1
                         ],
                alll2:[alll1 of level2,
                       days of level2,
                       odddays of level2,
                       evendays of level2],
                week:[days of level2]
               }.

getCoverConstraints(CC) :-
  CC=[
         cover(monday of timeslots,>=,2,seniors of employees),
         cover(wednesday of timeslots,>=,2,seniors of employees),
         cover(evendays of timeslots,>=,1,managers of employees),
         cover(odddays of timeslots,>=,1,managers of employees)
     ].

getResourceConstraints(RC) :-
  RC = [
           resource(managers of employees, =<, 4, all of timeslots),
           resource(seniors of employees, =<, 4, all of timeslots)
       
       ].
