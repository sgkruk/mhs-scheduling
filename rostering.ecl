:-lib(ic).
:-lib(ic_global).

roster :-
  getEmployees(E),
  getTimes(T),
  setup(Roster,E,T,NbE,Layers),
  writeln('Inter-Layer constraints'),
  interLayerConstrain(NbE,Roster,T,Layers),
  writeln('Cover constraints'),
  getCoverConstraints(CC),
  coverConstrain(CC,Roster,E,T),
  writeln('Resource constraints'),
  getResourceConstraints(RC),
  resourceConstrain(RC,Roster,E,T),
  flatten_array(Roster,R),
  labeling(R),!,
  displaySolution(Roster,NbE,Layers).

displaySolution(Roster,NbE,Layers):-
  length(Layers,NbLayers),
  (for(L,1,NbLayers), foreach(NbT,Layers), param(NbE,Roster) do
          (for(T,1,NbT) do
              mod(T,10,Ti),
              write(Ti)
          ),writeln(' '),
      (for(E,1,NbE), param(L,Roster,NbT) do
          (for(T,1,NbT), param(E,L,Roster) do
              subscript(Roster,[E,L,T],YN),
              (YN=1 -> write('Y') ; write('_'))
          ),
          writeln(' ')
      ),
      writeln(' ')
  ).

%
% This setups the constraints between layers of the timeslots. For
% example, with a layer on hours and another on days, then 
% Monday=Y <==> (one or more of the hours of Monday is 'Y')
% So one variable in level i is a reified constraint of disjunctions of
% a set of variables of set i-1
interLayerConstrain(NbE,Roster, T, Layers):-
  length(Layers,NbLayers),
  EndLayer is NbLayers-1,
  (for(E,1,NbE), param(Roster,T,Layers,NbLayers,EndLayer) do
      (for(L1,1,EndLayer), for(L2,2,NbLayers), param(E,Roster,T) do
          %writeln(L1-L2),
          arg(L1,T,T1),arg(L2,T,T2),
          arg(1,T2,T2Indices),
          (foreach(T2Index,T2Indices), param(Roster,E,L1,L2,T1) do
              arg(T2Index,T1,T1Indices),
              %writeln(T2Index-T1Indices),
              %writeln([E,L1,T1Indices]),
              (foreach(T1Index,T1Indices), foreach(R1Var,R1Vars),
               param(E,L1,Roster) do
                  %writeln([E,L1,T1Index]),
                  subscript(Roster,[E,L1,T1Index],R1Var)
              ),
              subscript(Roster,[E,L2,T2Index],R2Var),
              iffsumlist(R1Vars,R2Var)
              )
      )
  ).
  
iffsumlist(List,V) :-
  sumlist(List) #> 1 => V#=1,
  V#=1 => sumlist(List) #> 1.

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
  (for(L,1,NbLayers),foreach(LSize,Layers), param(T) do
      arg(L,T,Layer),arg(1,Layer,All),
      length(All,LSize)
  ),
  arg(1,T,Level1),arg(1,Level1,AllT),length(AllT,NbT),
  dim(Roster,[NbE,NbLayers,NbT]),
  Roster::[0..1],
  zapleftover(Roster,Layers).

% This is because I cannot figure out how to have layers of varying
% sizes in Roster (damn Eclipse matrices!)
zapleftover(Roster,Layers) :-
  dim(Roster,[NbE,NbLayers,NbT]),
  (for(E,1,NbE), param(Roster,NbLayers,Layers,NbT) do
      (for(L,1,NbLayers), foreach(LayerSize,Layers), param(E,Roster,NbT) do
          Te is LayerSize+1,
          (for(T,Te,NbT), param(E,L,Roster) do
              subscript(Roster,[E,L,T],V),
              V#=0
              )
          )
      ).


  