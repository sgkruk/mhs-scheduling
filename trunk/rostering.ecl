:-lib(ic).
:-lib(ic_global).

roster :-
  getEmployees(E),
  getTimes(T),
  setup(Roster,E,T,NbE,Layers),writeln([NbE,Layers]),
  getCoverConstraints(CC),
  coverConstrain(CC,Roster,E,T),
  getResourceConstraints(RC),
  resourceConstrain(RC,Roster,E,T),
  flatten_array(Roster,R),
  labeling(R),!,
  displaySolution(Roster).

displaySolution(Roster):-
  dim(Roster,[NbE,NbLayers,_]),!,
  writeln(aaaa-[NbE,NbLayers]),
  (for(L,1,NbLayers), param(NbE,Roster) do
      (for(E,1,NbE), param(L,Roster) do
          subscript(Roster,[E,L],Times),
          arity(Times,NbT),
          (for(T,1,NbT), param(E,L,Roster) do
              subscript(Roster,[E,L,T],YN),
              (YN=1 -> write('Y') ; write('_'))
          ),
          writeln(' ')
      ),
      writeln(' ')
  ).

resourceConstrain(RC,Roster,E,T) :-
  (foreach(Resource,RC), param(Roster,E,T) do
      Resource=resource(EmployeesField,Rel,N,TimeslotsField),
      writeln(Resource),
      arg(EmployeesField, E, EmployeeSet),
      arg(TimeslotsField, T, TimeslotSet),
      arg(1,TimeslotsField,Layer),
      (foreach(Employee,EmployeeSet), param(Rel,N,TimeslotSet,Roster,Layer) do
          (foreach(Timeslot, TimeslotSet), 
           foreach(Elem,AllElem), param(Employee,Roster,Layer) do
              subscript(Roster,[Employee,Layer,Timeslot],Elem)
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
      arg(1,TimeslotsField,Layer),
      (foreach(Timeslot, TimeslotSet), param(Rel,N,EmployeeSet,Roster,Layer) do
          (foreach(Employee,EmployeeSet), 
           foreach(Elem,AllElem), param(Timeslot,Roster,Layer) do
              subscript(Roster,[Employee,Layer,Timeslot],Elem)
          ),
          (Rel='>' -> #>(sumlist(AllElem),  N); true),
          (Rel='>=' -> #>=(sumlist(AllElem),  N); true),
          (Rel='=' -> #=(sumlist(AllElem),  N); true),
          (Rel='=<' -> #=<(sumlist(AllElem),  N); true),
          (Rel='<' -> #<(sumlist(AllElem),  N); true)
      )
  ).
setup(Roster,E,T,NbE,Layers) :-
  arg(1,E,AllE),length(AllE,NbE),
  arity(T,NbLayers),
  (for(L,1,NbLayers),foreach(LSize,Layers), foreach(R,RR), param(T,NbE) do
      arg(L,T,Layer),arg(1,Layer,All),
      length(All,LSize),
      dim(R,[NbE,LSize]),
      R::0..1
  ),
  Roster=[](RR),writeln(allo),
  dim(Roster,[D0,D1,D2]),writeln([D0,D1,D2]).
%  arg(1,T,Level1),arg(1,Level1,AllT),length(AllT,NbT),
%  dim(Roster,[NbE,NbLayers,NbT]),
%  writeln([NbE,NbLayers,NbT]),
%  Roster::[0..1].


  