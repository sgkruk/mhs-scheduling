:-use_module(structures).
:-lib(ic).
:-lib(ic_global).

roster :-
  getEmployees(E),
  validateEmployees(E,NbE),
  getTimes(T),
  validateTimes(T,NbT),
  setup(Roster,[NbE,NbT]),
  getCoverConstraints(CC),
  coverConstrain(CC,Roster,E,T),
  getResourceConstraints(RC),
  resourceConstrain(RC,Roster,E,T),
  flatten_array(Roster,R),
  labeling(R),
  displaySolution(NbE,NbT,Roster).

displaySolution(NbE,NbT,Roster):-
  (for(E,1,NbE), param(NbT,Roster) do
      (for(T,1,NbT), param(E,Roster) do
          subscript(Roster,[E,T],YN),
          (YN=1 -> write('Y') ; write('_'))
      ),
      writeln(' ')
  ).

resourceConstrain(RC,Roster,E,T) :-
  (foreach(Resource,RC), param(Roster,E,T) do
      Resource=resource(EmployeesField,Rel,N,TimeslotsField),
      writeln(Resource),
      arg(EmployeesField, E, EmployeeSet),
      arg(TimeslotsField, T, TimeslotSet),
      (foreach(Employee,EmployeeSet), param(Rel,N,TimeslotSet,Roster) do
          (foreach(Timeslot, TimeslotSet), foreach(Elem,AllElem), param(Employee,Roster) do
              subscript(Roster,[Employee,Timeslot],Elem)
          ),
          (Rel='>' -> #>(sumlist(AllElem),  N); true),
          (Rel='>=' -> #>=(sumlist(AllElem),  N); true),
          (Rel='=' -> #=(sumlist(AllElem),  N); true),
          (Rel='=<' -> #=<(sumlist(AllElem),  N); true),
          (Rel='<' -> #<(sumlist(AllElem),  N); true)
      )
  ).
  
  
coverConstrain(CC,Roster,E,T) :-
  (foreach(Cover,CC), param(Roster,E,T) do
      Cover=cover(TimeslotsField,Rel,N,EmployeesField),
      writeln(Cover),
      arg(EmployeesField, E, EmployeeSet),
      arg(TimeslotsField, T, TimeslotSet),
      (foreach(Timeslot, TimeslotSet), param(Rel,N,EmployeeSet,Roster) do
          (foreach(Employee,EmployeeSet), foreach(Elem,AllElem), param(Timeslot,Roster) do
              subscript(Roster,[Employee,Timeslot],Elem)
          ),
          (Rel='>' -> #>(sumlist(AllElem),  N); true),
          (Rel='>=' -> #>=(sumlist(AllElem),  N); true),
          (Rel='=' -> #=(sumlist(AllElem),  N); true),
          (Rel='=<' -> #=<(sumlist(AllElem),  N); true),
          (Rel='<' -> #<(sumlist(AllElem),  N); true)
      )
  ).
setup(Roster,[NbE,NbT]) :-
  dim(Roster,[NbE,NbT]),
  Roster::[0..1].
  
validateTimes(Times,NbT) :-
  arg(hours of timeslots, Times, Hours), 
  length(Hours,NbT),
  (NbT>0 -> true; writeln('Error on timeslots'),fail).
  

validateEmployees(E,NbE) :-
  arg(all of employees, E, All),
  length(All,NbE),
  arg(managers of employees, E, Managers),
  arg(juniors of employees, E, Juniors),
  arg(seniors of employees, E, Seniors),
  flatten([Managers, Seniors, Juniors], Combine),
  sort(All,AllSorted),
  sort(Combine,CombineSorted),
  (foreach(X,AllSorted),
   foreach(Y,CombineSorted) do
      (X =\= Y -> writeln('Error on all'),fail ; true)
  ).

  