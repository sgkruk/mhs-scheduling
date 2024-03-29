% This file represent an instance of the multi-level timeslots cover
% constraints

:- local struct(employees(all,managers,seniors,juniors,fred,mary)).

:- local struct(level1(all,monday,tuesday,wednesday,thursday,friday)).
:- local struct(level2(alll1,days,odddays,evendays)).
:- local struct(level3(alll2,week)).
:- local struct(timeslots(hourlevel:level1, 
                          daylevel:level2,
                          weeklevel:level3)).

getEmployees(E) :-
  E = employees{all:[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17],
                managers:[1,2,11,15],
                seniors:[3,4,5,12,13,16],
                juniors:[6,7,8,9,10,14,17],
                fred:[13],
                mary:[14]
                }.


getTimes(T) :-
  T = timeslots{all:[1,2,3,4,5,6,7,8,9,10,11,12,
                       13,14,15,16,17,18,19,20,21,22,23,24,
                       25,26,27,28,29,30,31,32,33,34,35,36,
                       37,38,39,40,41,42,43,44,45,46,47,48,
                       49,50,51,52,53,54,55,56,57,58,59,60],
                monday:[1,2,3,4,5,6,7,8,9,10,11,12],
                tuesday:[13,14,15,16,17,18,19,20,21,22,23,24],
                wednesday:[25,26,27,28,29,30,31,32,33,34,35,36],
                thursday:[37,38,39,40,41,42,43,44,45,46,47,48],
                friday:[49,50,51,52,53,54,55,56,57,58,59,60],
                alll1:[all of level1,
                        monday of level1,
                        tuesday of level1,
                        wednesday of level1,
                        thursday of level1,
                        friday of level1],
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
                          thursday of level1
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
      cover(tuesday of timeslots,>=,2,seniors of employees),
      cover(wednesday of timeslots,>=,3,seniors of employees),
      cover(thursday of timeslots,>=,3,seniors of employees),
      cover(friday of timeslots,>=,3,seniors of employees),
      cover(monday of timeslots,=<,3,juniors of employees),
      cover(tuesday of timeslots,=<,4,juniors of employees),
      cover(wednesday of timeslots,=<,5,juniors of employees),
      cover(thursday of timeslots,=<,6,juniors of employees),
      cover(friday of timeslots,=<,6,juniors of employees),
      cover(monday of timeslots,>=,1,juniors of employees),
      cover(tuesday of timeslots,>=,2,juniors of employees),
      cover(wednesday of timeslots,>=,2,juniors of employees),
      cover(thursday of timeslots,>=,3,juniors of employees),
      cover(friday of timeslots,>=,4,juniors of employees),
      
      cover(evendays of timeslots, >=, 1, managers of employees),
      cover(odddays of timeslots, >=, 4, managers of employees)
     ].

getResourceConstraints(RC) :-
  RC = [
           resource(all of employees, =<, 40, all of timeslots),
           resource(all of employees, >=, 24, all of timeslots),
           resource(juniors of employees, =<, 4, days of timeslots),
           resource(fred of employees, = , 0, tuesday of timeslots),
           resource(mary of employees, >= , 4, thursday of timeslots)
       ].
