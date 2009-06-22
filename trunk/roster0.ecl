% This file ddescribes all resources and constraints of a roster.  
% It is parsed by the solver which will output a valid roster from it. 
% This version only implements one level of timeslots and only 
% sum inequalities (no regex, no contiguous)
% 
:-local struct(employees(all,managers,seniors,juniors,fred,mary)).
:-local struct(timeslots(hours,monday,tuesday,wednesday,thursday,friday,days)).

getEmployees(E) :-
  E = employees{all:[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17],
                managers:[1,2,11,15],
                seniors:[3,4,5,12,13,16],
                juniors:[6,7,8,9,10,14,17],
                fred:[13],
                mary:[14]}.

getTimes(T) :-
  T = timeslots{hours:[1,2,3,4,5,6,7,8,9,10,11,12,
                       13,14,15,16,17,18,19,20,21,22,23,24,
                       25,26,27,28,29,30,31,32,33,34,35,36,
                       37,38,39,40,41,42,43,44,45,46,47,48,
                       49,50,51,52,53,54,55,56,57,58,59,60],
                monday:[1,2,3,4,5,6,7,8,9,10,11,12],
                tuesday:[13,14,15,16,17,18,19,20,21,22,23,24],
                wednesday:[25,26,27,28,29,30,31,32,33,34,35,36],
                thursday:[37,38,39,40,41,42,43,44,45,46,47,48],
                friday:[49,50,51,52,53,54,55,56,57,58,59,60]
               }.

getCoverConstraints(CC) :-
  CC=[cover(monday of timeslots,>=,1,managers of employees),
      cover(tuesday of timeslots,>=,1,managers of employees),
      cover(wednesday of timeslots,>=,2,managers of employees),
      cover(thursday of timeslots,>=,2,managers of employees),
      cover(friday of timeslots,>=,2,managers of employees),
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
      cover(friday of timeslots,>=,4,juniors of employees)
     ].

getResourceConstraints(RC) :-
  RC = [
           resource(all of employees, =<, 40, hours of timeslots),
           resource(all of employees, >=, 24, hours of timeslots),
           resource(fred of employees, = , 0, tuesday of timeslots),
           resource(mary of employees, >= , 6, thursday of timeslots)
       ].
