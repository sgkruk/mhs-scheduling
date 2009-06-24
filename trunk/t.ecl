:-lib(ic).
:-lib(arrays).
top :-
  NbE=4,
  NbLayers=3,
  Layers=[8,4,2],
  (for(_,1,NbLayers),foreach(L,Layers), foreach(R,RR), param(NbE) do
      dim(R,[NbE,L]),
      R::0..1
  ),
  Roster=[](RR),dim(Roster,[D0,D1,D2]),writeln([D0,D1,D2]),
  subscript(Roster,[1,2,2],E),writeln(E).
