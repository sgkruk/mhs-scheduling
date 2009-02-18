:- lib(ic).
:- lib(ic_global).
:- lib(branch_and_bound).
:- local struct(assignment(employee, sstart, send, startkey, startlicense, endkey, endlicense)).
:- local struct(day(dayofmonth, vettype, day_schedule, dayofweek)). % number,

lastday(7). %Number of days in month

%employee/3 is Employee's Number, Name, Max Hours per Week
employee(1,theresa,49).
employee(2,chris,49).
employee(3,heidi,49).
employee(4,kim,49).
employee(5,eva,49).
employee(6,kristin,49).
employee(7,holly,32).% Part time employee cannot work except on Tue., Thu., Sat.
  % What is the effect of an additional employee? Licensed or unlicensed? full or part time?

licensed(1). % All licensed employees
licensed(2).
licensed(6).
licensed(7).

%keys: not a proper superset of licenses
key(1).
key(6).
key(5).
key(4).

% Vets' schedule fixed for month of 35 days. 
% We only cared if a day has a "fast" or "slow" doctor
% Vets' schedule fixed for month of 35 days. We only cared if a day has a "fast" or "slow" doctor
% vtype(day, fast_or_slow_or_none, first_hour, closing_time)
vtype(1, none,8,12).
vtype(2, slow,8,19).
vtype(3, fast,7,19).
vtype(4, slow,7,19).
vtype(5, slow,7,19).
vtype(6, slow,7,19).
vtype(7, slow,8,17).
vtype(8, none,8,12).
vtype(9, slow,8,20).
vtype(10,slow,7,20).
vtype(11,slow,7,20).
vtype(12,slow,7,20).
vtype(13,slow,7,20).
vtype(14,slow,8,17).
vtype(15,none,8,12).
vtype(16,slow,7,18).
vtype(17,slow,7,19).
vtype(18,slow,7,19).
vtype(19,slow,7,19).
vtype(20,slow,7,20).
vtype(21,slow,8,17).
vtype(22,none,8,12).
vtype(23,slow,8,20).
vtype(24,slow,7,20).
vtype(25,slow,7,20).
vtype(26,slow,7,19).
vtype(27,slow,7,20).
vtype(28,slow,8,17).
vtype(29,none,8,12).
vtype(30,slow,8,19).
vtype(31,slow,7,20).
vtype(32,slow,7,20).
vtype(33,slow,7,20).
vtype(34,slow,7,20).
vtype(35,slow,8,17).

% day of week functor orders the week days, abbreviates their names
dow(1,sun).
dow(2,mon).
dow(3,tue).
dow(4,wed).
dow(5,thu).
dow(6,fri).
dow(0,sat).

weekday(mon).
weekday(tue).
weekday(wed).
weekday(thu).
weekday(fri).

% Staffing level (number of employees working that day) determing by:
%   if(The vettype is 'none') 
%	 0 employees, or 0 <= employees <= 0
%   elseif(The day is a Sunday) 
%	 1 employee, or 1 <= employees <= 1
%   elseif(The day is a Saturday) 
%	 3 employees, or 3 <= employees <= 3
%   elseif(The vettype is 'fast') 
%	 >=5 employees, or 5 <= employees <= 6
%   else (The vettype must be 'slow') 
%	 >=4 employees, or 4 <= employees <= 6
%   endif
% stafflevel(dayofweek, fast_or_slow_or_none, min_employees, max_employees)
stafflevel( _, none, 0, 0 ).
stafflevel( sun, slow, 1, 1 ).
stafflevel( sun, fast, 1, 1 ).
stafflevel( sat, slow, 3, 3 ).
stafflevel( sat, fast, 3, 3 ).
stafflevel(DayOfWeek,slow,4,5) :- 
  weekday(DayOfWeek).
stafflevel(DayOfWeek,fast,4,6) :- 
  weekday(DayOfWeek).

% availshift( start, end, day )
availshift(8,12,sun).
availshift(8,17,sat).

availshift( StartHour, EndHour, DayOfWeek ) :-
  EndHour #=< StartHour + 11,
  EndHour #>= StartHour + 9,
  weekday(DayOfWeek).
  
search(Month) :-
  (foreach(Day,Month) do
      Day = day with[day_schedule:Day_Schedules],
      (foreach(Assignment,Day_Schedules), 
       fromto([],EmployeesIn,EmployeesOut,Employees) 
      ,fromto([],StartsIn,StartsOut,Starts) 
      ,fromto([],EndsIn,EndsOut,Ends)
      do
        Assignment = assignment{employee:Employee, sstart:Start, send:End},
        %EmployeesOut = [Assignment | EmployeesIn],
        EmployeesOut = [Employee | EmployeesIn],
        EndsOut = [End | EndsIn],
        StartsOut = [Start | StartsIn]
      ),
%      labeling(Starts),
      (foreach(S,Starts) do
          indomain(S,random)
      ),
      
%      labeling(Ends),
      (foreach(E,Ends) do
          indomain(E,min) % give preference to shorter shifts
      ),
      %labeling(Employees)
%% use the richer search/6 to pick employees not exceeding max hours in decreasing distance from max hours

%% with line below, use EmployeesOut = [Worker | EmployeesIn], above
%% However, this does _NOT_ pass in all assignments, just current Employee to ground
%search(Employees,1,employee_select_order,indomain_random,complete,[])

%line below can search and label all employees 
      search(Employees,0,input_order,indomain_random,complete,[])
      %(foreach(E,Employees) do
          %indomain(E,random)
    %  )
   ).
   
employee_select_order( E,Criterion) :-
 % compute Criterion from variable E, an employee
 % The variable-selection will then select the variable with the 
 % lowest value of Criterion. If several variables have the same value, the first one is selected.
  writeln(before-E),
  indomain(E,random),
  Criterion is E. 
  %  indomain(E,random),
  %writeln(after-E).

construct(Month) :-
  lastday(LastDay),
  printf(output,"Constructing a Month with %w days%n",[LastDay]),
  findall(Employee,employee(Employee,_,_),EmployeeList),
  ic:max(EmployeeList,MaxEmployee),
  (count(DayIndex,1,LastDay), 
  foreach(Day,Month), param(Month,MaxEmployee) 
  do
     vtype(DayIndex,VetType,OpenHour,CloseHour),
     dayofweek(DayIndex,DayOfWeek),
     stafflevel(DayOfWeek,VetType,_,MaxEmployeesThatCanBeScheduled),
     length(Day_Schedules,MaxEmployeesThatCanBeScheduled),
     Day = day with[dayofmonth:DayIndex, vettype:VetType, day_schedule:Day_Schedules, dayofweek:DayOfWeek],
     (foreach(Assignment,Day_Schedules), 
      fromto([],In,Out,AllEmployees),
      param(OpenHour,CloseHour,MaxEmployee,Month,DayIndex) 
      do
         Assignment = assignment{employee:Employee, sstart:Start, send:End}
         ,Employee::1..MaxEmployee
         ,Out=[Employee|In]
         ,Start::OpenHour..CloseHour
         ,End::OpenHour..CloseHour
         ,full_time(Assignment,DayIndex,Month)
     )
     ,(MaxEmployee > 1 -> ic:alldifferent(AllEmployees) ; true)
   ).

show_schedule(Month, Cost, _, _) :- %This predicate exists to output solutions found while searching
  writeln(cost:Cost),
  writeln(''),
  show_schedule(Month).
  
show_schedule(Target_Employee,Current_Week,Value,_,_) :- 
  writeln('Final Schedule'),writeln(value:Value),
 (foreach(Day,Current_Week), param(Target_Employee) 
  do
  Day = day with[dayofmonth: DayOfMonth, day_schedule:Day_Schedules],
  vtype(DayOfMonth,_,OpenHour,CloseHour),
  formatTime(OpenHour,StartHourString,StartDayPart),
  formatTime(CloseHour,EndHourString,EndDayPart),
  printf(output,"Day %w: Clinic open %w %w to %w %w%n",[DayOfMonth,StartHourString,StartDayPart,EndHourString,EndDayPart]),
  (foreach(Day_Schedule,Day_Schedules), param(Target_Employee)
   do
   Day_Schedule = assignment{employee:Employee, sstart:Start, send:End},
(Target_Employee=:=Employee ->
   employee(Employee,Name,_),
   formatTime(Start,StartHourString,StartDayPart),
   formatTime(End,EndHourString,EndDayPart),
   Duration is End-Start,
   (licensed(Employee) -> Licensed = ' licensed';Licensed = ''),
   (key(Employee) -> Key = ' with key';Key = ''), 
   printf(output,"%w: %w%w to %w%w (%w hours) %w %w%n",[Name,StartHourString,StartDayPart,EndHourString,EndDayPart,Duration,Licensed,Key])
;true)
  )),
writeln('end of week'),
employee_Hours_In_Week(Target_Employee,Current_Week,HoursWorkedInWeek),
writeln(HoursWorkedInWeek).
 
show_schedule(Month) :- %writeln(M).
 (foreach(Day,Month), param(Month) 
  do
  Day = day with[dayofmonth: DayOfMonth, day_schedule:Day_Schedules],
  vtype(DayOfMonth,VetType,OpenHour,CloseHour),
  (VetType = none ->
  printf(output,"%*nDay %w: Clinic closed%n",[2,DayOfMonth])
  ;
  formatTime(OpenHour,StartHourString,StartDayPart),
  formatTime(CloseHour,EndHourString,EndDayPart),
  printf(output,"%*nDay %w: Clinic open %w %w to %w %w%n",[2,DayOfMonth,StartHourString,StartDayPart,EndHourString,EndDayPart]),
  (foreach(Day_Schedule,Day_Schedules)
   do
   Day_Schedule = assignment{employee:Employee, sstart:Start, send:End},
   employee(Employee,Name,_),
   formatTime(Start,StartHourString,StartDayPart),
   formatTime(End,EndHourString,EndDayPart),
   Duration is End-Start,
   (licensed(Employee) -> Licensed = ' licensed';Licensed = ''),
   (key(Employee) -> Key = ' with key';Key = ''), 
   printf(output,"%w: %w%w to %w%w (%w hours) %w %w%n",[Name,StartHourString,StartDayPart,EndHourString,EndDayPart,Duration,Licensed,Key])
  )
  )
%At the end of each full week, output a summary of each employee, to better validate and compare output schedules
  ,mod(DayOfMonth,7,Mod)
  ,(Mod =:= 0 -> show_week_summary(DayOfMonth,Month); true)
 ).
 
show_week_summary(LastDayOfweek,Month) :-
  writeln(''),
  findall(Employee,employee(Employee,_,_),AllEmployees),
  (foreach(Employee,AllEmployees), param(LastDayOfweek,Month)
    do
     show_week_summary(Employee,LastDayOfweek,Month)
  ),
  writeln('').
 
show_week_summary(Employee,LastDayOfweek,Month) :-
  full_time(Employee,LastDayOfweek,Month,HoursWorkedInWeek),
  employee(Employee,Name,_),
  printf(output,"%n%d-%w: works %w hours this week",[Employee,Name,HoursWorkedInWeek]).
 
full_time(Current_Employee,LastDayOfweek,Month,HoursWorkedInWeek) :-
  FirstDayOfweek is LastDayOfweek - 7,

  sublist(Month,FirstDayOfweek,7,Current_Week),
  turn_Month_into_a_list_of_assignments(Current_Week,Day_Schedules_Of_Week),
		
 % (
  %  foreach(Day,Current_Week),
   % fromto([],In,Out,Day_Schedules_Of_Week) 
 %   do
  %    Day = day{day_schedule:Day_Schedules},
  %    append(Day_Schedules, In, Out)
 % ),
employees_hours_in_assignments(Current_Employee,Day_Schedules_Of_Week,HoursWorkedInWeek).	
%  (
%    foreach(Day_Schedule,Day_Schedules_Of_Week), 
%    fromto([],In,Out,Durations), % what if someone works none in the week? Maybe initialize with [0]
%    param(Current_Employee)
%    do
%      Day_Schedule = assignment{employee:Scheduled_Employee, sstart:Start, send:End},
%      (
%        Scheduled_Employee =:= Current_Employee ->
%          Duration is End-Start,
%          Out=[Duration | In]
%        ;
%          Out=In
%      )
%  ),
%  sumlist(Durations,HoursWorkedInWeek).

employees_hours_in_assignments(Current_Employee,Day_Schedules_Of_Week,HoursWorkedInWeek) :-
  (
    foreach(Day_Schedule,Day_Schedules_Of_Week), 
    fromto([],In,Out,Durations), % what if someone works none in the week? Maybe initialize with [0]
    param(Current_Employee)
    do
      Day_Schedule = assignment{employee:Scheduled_Employee, sstart:Start, send:End},
      (
          (ground(Scheduled_Employee),Scheduled_Employee =:= Current_Employee) ->
					((ground(End),ground(Start)) -> Duration is End-Start; Duration is 0),
          Out=[Duration | In]
        ;
          Out=In
      )
  ),
  ground(Durations) -> sumlist(Durations,HoursWorkedInWeek) ;
                       HoursWorkedInWeek is 0.

%  (
%    foreach(Day_Schedule,Day_Schedules_Of_Week), 
%    fromto([],In,Out,Durations), % what if someone works none in the week? Maybe initialize with [0]
%    param(Current_Employee)
%    do
%      Day_Schedule = assignment{employee:Scheduled_Employee, sstart:Start, send:End},
%      (
%        Scheduled_Employee =:= Current_Employee ->
%          Duration is End-Start,
%          Out=[Duration | In]
%        ;
%          Out=In
%      )
%%  ),
%  sumlist(Durations,HoursWorkedInWeek).
  
formatTime(MilitaryHour,HourString,DayPart) :-
  (MilitaryHour > 12
   ->
     HourString is MilitaryHour - 12, DayPart = 'pm';
     HourString is MilitaryHour, DayPart = 'am'
   ).
 
objective(Month,Value) :-
  findall(Employee,employee(Employee,_,_),EmployeeList),
  (foreach(Employee,EmployeeList),
   foreach(EmployeeValueForMonth,AllEmployeeValuesForMonth),
   param(Month) 
   do
     objective_employee(Employee,Month,EmployeeValueForMonth)
  ),
  sumlist(AllEmployeeValuesForMonth,Value).

objective_employee(TargetEmployee,Month,EmployeeValueForMonth) :-
  (foreach(Day,Month),
     fromto([],In,Out,StartHours),
     param(TargetEmployee) 
     do
       Day = day{day_schedule:Day_Schedules},      
       (foreach(CurrentEmployeeSchedule,Day_Schedules), 
          param(TargetEmployee,StartHour) 
          do
            CurrentEmployeeSchedule = assignment{employee:Employee, sstart:Start},
           (Employee =:= TargetEmployee -> StartHour is Start; true)
        ),
       (ground(StartHour) -> Out=[StartHour|In] ; Out=[0|In])
   ),
   objective_cost(StartHours,EmployeeValueForMonth).

  %two_days_off(), % Each employee gets two consecutive days off in each seven-day week
	%consistent_schedule().%, % For each block of 5 days worked, an employees start time is the same
objective_cost(StartHours,EmployeeValueForMonth) :- 
% Possessed of a list of all start times, we can quantify the schedule's cost  
  pd(StartHours,VEn),
  %First, quantify the difference in starting times
  snake_eyes(StartHours,VEs),
  EmployeeValueForMonth is 500+45*5+VEn-VEs.
  
% Snake eyes adds 1024, 512, 256, ... for each -00-
% -00- is consecutive days off. High is good.
snake_eyes(L,V) :- snake_eyes(L,0,256,V).
snake_eyes(L,A,_,A) :- length(L,1),!.
snake_eyes([H0 | T], A, N, V) :-
        T = [H1 | _],
        H is H0 + H1,
        (H =:= 0 -> A0 is A+N, N0 is N//2 ; A0 is A, N0 is N),
        snake_eyes(T, A0, N0, V).
        
% Returns a cost for difference in consecutive start times. High is
% bad. 
pd(L,V) :- pd(L,0,V).
pd(L,A,A) :- length(L,1),!.
pd([H0 | T], A, V) :-
        T = [H1 | _],
        H is H0 * H1,
        Hdiff is H0-H1,
        abs(Hdiff,AHdiff),
        (H =:= 0 -> A0 is A ; A0 is A + AHdiff*5),
        pd(T, A0, V).

dayofweek(I,N) :-
  mod(I,7,J),
  dow(J,N).

% 2 diff't approaches, neither of which worked with the suspend in play
current_week(Num,Start_day,End_day) :-
  mod(Num, 7, Mod),
  (Mod = 0 ->
    Start_day is Num - 6; 
    Start_day is Num - Mod + 1),
  End_day is Start_day + 6.

in_range(N,S,E) :- N >= S, N =< E.

full_time(Assignment,Num,Month) :-
  Assignment = assignment{employee:Current_Employee,sstart:Start,send:
                                                                     End},
  ((   ground(Current_Employee),
       ground(Start),
       ground(End)
   ) ->
      current_week(Num,FirstDayOfWeek,End_day),
      Day1 is FirstDayOfWeek-1,
      NbDays is 7-(End_day-Num),
      sublist(Month,Day1,NbDays,Current_Week),
      (
          foreach(Day,Current_Week),
          fromto([],In,Out,Day_Schedules_Of_Week) 
      do
          Day = day{day_schedule:Day_Schedules},
          append(Day_Schedules, In, Out)
      ),
      (
          foreach(Day_Schedule,Day_Schedules_Of_Week), 
          fromto([],In,Out,Durations), 
          param(Current_Employee)
      do
          Day_Schedule = assignment{employee:Scheduled_Employee,sstart:Start,send:End},
          (
              (
                  ground(Scheduled_Employee),
                  ground(Start),
                  ground(End),
                  Scheduled_Employee =:= Current_Employee
              ) ->
              Duration #= End-Start,
              Out=[Duration | In]
          ;
              Out=In
          )
      ),
      
      sumlist(Durations,HoursWorkedInWeek),
      employee(Current_Employee,_,MaxHours),
      HoursWorkedInWeek #=< MaxHours
  ;        
      suspend(full_time(Assignment,Num,Month),2,[Current_Employee,Start,End]->inst)
  ).

%assignment(Ordinal,MaxEmployeesForDay,OpenHour,CloseHour, Employee,StartHour,EndHour)
% Only 1 employee to schedule, must be licensed, keyed and work all day
assignment(1,1,OpenHour,CloseHour,_, Employee,OpenHour,CloseHour) :-
%writeln('solo'),
  findall(E,(licensed(E),key(E)),AllLicensedAndKeyed),
  Employee::AllLicensedAndKeyed.
  
assignment(1,2,OpenHour,CloseHour,_, Employee,OpenHour,CloseHour) :-
%writeln('duo or less (1)'),
  findall(E,(licensed(E),key(E)),AllLicensedAndKeyed),
  Employee::AllLicensedAndKeyed.
  
  % 2 employees to schedule, all must work all day
assignment(2,2,OpenHour,CloseHour,_, Employee,OpenHour,CloseHour) :-
%writeln('duo or less (2)'),
  findall(E,employee(E,_,_),AllLicensedAndKeyed),
  Employee::AllLicensedAndKeyed.
  
  % #1 employee to schedule, must have license or key and work from open
assignment(1,MaxEmployeesForDay,OpenHour,_,DayOfWeek, Employee,OpenHour,EndHour) :-
%writeln('#1'),
  MaxEmployeesForDay > 2,
  findall(E,(licensed(E);key(E)),AllLicensedOrKeyed),
  Employee::AllLicensedOrKeyed,
  availshift( OpenHour, EndHour, DayOfWeek ).
  
  % #2 employee to schedule, mustwork from open
assignment(2,MaxEmployeesForDay,OpenHour,_,DayOfWeek, Employee,OpenHour,EndHour) :-
%writeln('#2'),
  MaxEmployeesForDay > 2,
  findall(E,employee(E,_,_),AllEmployees),
  Employee::AllEmployees,
  availshift( OpenHour, EndHour, DayOfWeek ).
  
  % 3rd employee to schedule, must have license or key and work 'til close
assignment(3,_,_,CloseHour,DayOfWeek, Employee,StartHour,CloseHour) :-
%writeln('Penultimate'),
  findall(E,(licensed(E);key(E)),AllLicensedOrKeyed),
  Employee::AllLicensedOrKeyed,
  availshift( StartHour,CloseHour, DayOfWeek ).
  
  % Final employee to schedule, must work 'til close
assignment(4,_,_,CloseHour,DayOfWeek, Employee,StartHour,CloseHour) :-
%writeln('Final'),
  findall(E,employee(E,_,_),AllEmployees),
  Employee::AllEmployees,
  availshift( StartHour,CloseHour, DayOfWeek ).

  % Default case: an employee working an available shift
assignment(Ordinal,_,_,_,DayOfWeek, Employee,StartHour,EndHour) :-
%writeln('Default'),
  Ordinal > 4,
  findall(E,employee(E,_,_),AllEmployees),
  Employee::AllEmployees,  
  availshift( StartHour, EndHour, DayOfWeek ).

constraints(Month) :-
  writeln("Constraining the Month"),
  (
  foreach(Day,Month) 
  do
    Day = day{dayofmonth:Num, day_schedule:Day_Schedules, vettype:Vet_Type, dayofweek:Day_Of_Week},
    vtype(Num,Vet_Type,Clinic_Start,Clinic_End),
    stafflevel(Day_Of_Week,Vet_Type,_,Max),
    (
      for(Index_Of_Current_Employee,1,Max), 
      fromto([],In,Out,Day_Schedules), 
      fromto([],StartKeysIn,StartKeysOut,StartKeys), 
      fromto([],EndKeysIn,EndKeysOut,EndKeys), 
      fromto([],StartLicensesIn,StartLicensesOut,StartLicenses), 
      fromto([],EndLicensesIn,EndLicensesOut,EndLicenses), 
      param(Day_Of_Week,Clinic_Start,Clinic_End,Max) 
    do        
        Day_Schedule = assignment{employee:Employee, sstart:EmpStart, send:EmpEnd, startkey:Starts_Has_Key, startlicense:Starts_Has_License, endkey:Ends_Has_Key, endlicense:Ends_Has_License},
        Out=[Day_Schedule|In],        
        Starts_Has_Key::[0..1],
        Starts_Has_License::[0..1],
        Ends_Has_Key::[0..1],
        Ends_Has_License::[0..1],
        StartKeysOut=[Starts_Has_Key|StartKeysIn],
        EndKeysOut=[Ends_Has_Key|EndKeysIn], 
        StartLicensesOut=[Starts_Has_License|StartLicensesIn], 
        EndLicensesOut=[Ends_Has_License|EndLicensesIn], 
        assignment(Index_Of_Current_Employee,Max,Clinic_Start,Clinic_End,Day_Of_Week,Employee,EmpStart,EmpEnd),
        assign_Start_Key(Day_Schedule,Clinic_Start),
        assign_Start_License(Day_Schedule,Clinic_Start),
        assign_End_Key(Day_Schedule,Clinic_End),
        assign_End_License(Day_Schedule,Clinic_End)
    ),    
    (Max=:=0 -> % Somebody is working therefore, we require keys, licenese 
      true; 
      sumlist(StartKeys,Number_Of_StartKeys),         Number_Of_StartKeys     #> 0,
      sumlist(EndKeys,Number_Of_EndKeys),             Number_Of_EndKeys       #> 0,
      sumlist(StartLicenses,Number_Of_StartLicenses), Number_Of_StartLicenses #> 0,
      sumlist(EndLicenses,Number_Of_EndLicenses),     Number_Of_EndLicenses   #> 0,    
        (Max=:=1 -> % At least two are working, must be at least two to start/close
          true; 
          Number_Of_StartKeys + Number_Of_StartLicenses #> 1,
          Number_Of_EndKeys + Number_Of_EndLicenses #> 1
         )
     )
  ).

%struct(assignment(employee, sstart, send, startkey, startlicense, endkey, endlicense)).
assign_Start_Key(Day_Schedule,Clinic_Start) :-
        Day_Schedule 
        = assignment{employee:Employee, sstart:EmpStart, startkey:Starts_Has_Key},
        ((ground(EmpStart),ground(Employee)) -> 
            ((Clinic_Start=:=EmpStart,key(Employee)) -> Starts_Has_Key = 1;
                                                        Starts_Has_Key = 0)
        ;
            suspend(assign_Start_Key(Day_Schedule,Clinic_Start),2,
                    [Employee,EmpStart]->inst)).    

assign_Start_License(Day_Schedule,Clinic_Start) :-
        Day_Schedule 
        = assignment{employee:Employee, sstart:EmpStart, startlicense:Starts_Has_License},
        ((ground(EmpStart),ground(Employee)) -> 
            ((Clinic_Start=:=EmpStart,licensed(Employee)) -> Starts_Has_License = 1;
                                                             Starts_Has_License = 0)
        ;
            
            suspend(assign_Start_License(Day_Schedule,Clinic_Start),2,
                    [Employee,EmpStart]->inst)).
assign_End_Key(Day_Schedule,Clinic_End) :-
  
  Day_Schedule 
  = assignment{employee:Employee, send:EmpEnd, endkey:
                                                     Ends_Has_Key},
  ((ground(EmpEnd),ground(Employee)) ->
      ((Clinic_End=:=EmpEnd,key(Employee)) -> Ends_Has_Key = 1;
                                              Ends_Has_Key = 0)
  ;
      suspend(assign_End_Key(Day_Schedule,Clinic_End),2,
              [Employee,EmpEnd]->inst)).      
assign_End_License(Day_Schedule,Clinic_End) :-
        Day_Schedule 
        = assignment{employee:Employee, send:EmpEnd, endlicense:Ends_Has_License},
        ((ground(Employee),ground(EmpEnd)) ->
            ((Clinic_End=:=EmpEnd,licensed(Employee)) -> Ends_Has_License = 1; 
                                                         Ends_Has_License = 0)
        ;
            suspend(assign_End_License(Day_Schedule,Clinic_End),2,
                    [Employee,EmpEnd]->inst)).      

% Sublist from position Start (indexed by 0) of length L
% sublist([a,b,c,d,e],1,2,[b,c]);
sublist(Lin,0,L,Lout) :- 
  !,
  head(Lin,L,[],Lout).
  
sublist([_|Lin],S,L,Lout) :-
  S > 0,
  S1 is S-1,
  sublist(Lin,S1,L,Lout).
  
head(_,0,L,Lout):-
  !,
  reverse(L,Lout).
head([H|Lin],L,A,Lout) :-
  L > 0,
  L1 is L-1,
  A1 = [H|A],
  head(Lin,L1,A1,Lout).
  
schedule(Month,Value,oct) :-
  Month = [
    day{dayofmonth:1, vettype:none, day_schedule:[], dayofweek:sun}, 
    day{dayofmonth:2, vettype:slow, day_schedule:[
      assignment{employee:4, sstart:8, send:17},
      assignment{employee:7, sstart:8, send:17}, 
      assignment{employee:1, sstart:9, send:18}, 
      assignment{employee:3, sstart:10, send:19}, 
      assignment{employee:6, sstart:10, send:19}], dayofweek:mon}, 
   day{dayofmonth:3, vettype:fast, day_schedule:[
      assignment{employee:1, sstart:7, send:16},
      assignment{employee:7, sstart:7, send:16},
      assignment{employee:2, sstart:7, send:18}, 
      assignment{employee:3, sstart:10, send:19}, 
      assignment{employee:6, sstart:10, send:19}], dayofweek:tue}, 
   day{dayofmonth:4, vettype:slow, day_schedule:[
      assignment{employee:4, sstart:7, send:16}, 
      assignment{employee:7, sstart:7, send:16}, 
      assignment{employee:1, sstart:9, send:18}, 
      assignment{employee:3, sstart:10, send:19}, 
      assignment{employee:6, sstart:10, send:19}], dayofweek:wed}, 
   day{dayofmonth:5, vettype:slow, day_schedule:[
      assignment{employee:4, sstart:7, send:16}, 
      assignment{employee:2, sstart:7, send:18}, 
      assignment{employee:1, sstart:9, send:18}, 
      assignment{employee:3, sstart:10, send:19}, 
      assignment{employee:6, sstart:10, send:19}], dayofweek:thu}, 
   day{dayofmonth:6, vettype:slow, day_schedule:[
      assignment{employee:4, sstart:7, send:16}, 
      assignment{employee:7, sstart:7, send:16}, 
      assignment{employee:1, sstart:9, send:18}, 
      assignment{employee:3, sstart:10, send:19}, 
      assignment{employee:6, sstart:10, send:19}], dayofweek:fri}, 
   day{dayofmonth:7, vettype:slow, day_schedule:[
      assignment{employee:2, sstart:8, send:17}, 
      assignment{employee:7, sstart:8, send:17}, 
      assignment{employee:4, sstart:8, send:17}], dayofweek:sat}
          %%, 
%%    day{dayofmonth:8, vettype:none, day_schedule:[], dayofweek:sun}, 
%%    day{dayofmonth:9, vettype:slow, day_schedule:[
%%       assignment{employee:1, sstart:8, send:17}, 
%%       assignment{employee:6, sstart:8, send:17}, 
%%       assignment{employee:5, sstart:9, send:18}, 
%%       assignment{employee:7, sstart:10, send:19}, 
%%       assignment{employee:4, sstart:9, send:20}], dayofweek:mon}, 
%%    day{dayofmonth:10, vettype:slow, day_schedule:[
%%       assignment{employee:1, sstart:7, send:16}, 
%%       assignment{employee:6, sstart:7, send:18}, 
%%       assignment{employee:2, sstart:9, send:18}, 
%%       assignment{employee:7, sstart:10, send:19}, 
%%       assignment{employee:4, sstart:9, send:20}, 
%%       assignment{employee:3, sstart:9, send:20}], dayofweek:tue}, 
%%    day{dayofmonth:11, vettype:slow, day_schedule:[
%%       assignment{employee:1, sstart:7, send:16}, 
%%       assignment{employee:6, sstart:7, send:16}, 
%%       assignment{employee:5, sstart:8, send:17}, 
%%       assignment{employee:4, sstart:9, send:20}, 
%%       assignment{employee:3, sstart:9, send:20}, 
%%       assignment{employee:7, sstart:10, send:19}], dayofweek:wed}, 
%%    day{dayofmonth:12, vettype:slow, day_schedule:[
%%       assignment{employee:6, sstart:7, send:16}, 
%%       assignment{employee:2, sstart:7, send:18}, 
%%       assignment{employee:5, sstart:8, send:17}, 
%%       assignment{employee:4, sstart:9, send:20}, 
%%       assignment{employee:3, sstart:9, send:20}, 
%%       assignment{employee:7, sstart:10, send:19}], dayofweek:thu}, 
%%    day{dayofmonth:13, vettype:slow, day_schedule:[
%%       assignment{employee:6, sstart:7, send:16}, 
%%       assignment{employee:1, sstart:7, send:16}, 
%%       assignment{employee:5, sstart:8, send:17}, 
%%       assignment{employee:7, sstart:10, send:19}, 
%%       assignment{employee:3, sstart:9, send:20}], dayofweek:fri}, 
%%    day{dayofmonth:14, vettype:slow, day_schedule:[
%%       assignment{employee:1, sstart:8, send:17}, 
%%       assignment{employee:5, sstart:8, send:17}, 
%%       assignment{employee:2, sstart:8, send:17}], dayofweek:sat}, 
%%    day{dayofmonth:15, vettype:none, day_schedule:[], dayofweek:sun}, 
%%    day{dayofmonth:16, vettype:slow, day_schedule:[
%%       assignment{employee:1, sstart:7, send:18}, 
%%       assignment{employee:4, sstart:8, send:17}, 
%%       assignment{employee:3, sstart:8, send:17}, 
%%       assignment{employee:5, sstart:9, send:18}, 
%%       assignment{employee:7, sstart:9, send:18}], dayofweek:mon}, 
%%    day{dayofmonth:17, vettype:slow, day_schedule:[
%%       assignment{employee:1, sstart:7, send:18}, 
%%       assignment{employee:2, sstart:8, send:19}, 
%%       assignment{employee:3, sstart:8, send:17}, 
%%       assignment{employee:4, sstart:7, send:16}, 
%%       assignment{employee:5, sstart:9, send:18}, 
%%       assignment{employee:7, sstart:10, send:19}], dayofweek:tue}, 
%%    day{dayofmonth:18, vettype:slow, day_schedule:[
%%       assignment{employee:4, sstart:7, send:16}, 
%%       assignment{employee:3, sstart:8, send:17}, 
%%       assignment{employee:5, sstart:9, send:19}, 
%%       assignment{employee:7, sstart:10, send:19}], dayofweek:wed}, 
%%    day{dayofmonth:19, vettype:slow, day_schedule:[
%%       assignment{employee:2, sstart:7, send:18}, 
%%       assignment{employee:3, sstart:8, send:17}, 
%%       assignment{employee:5, sstart:10, send:19}, 
%%       assignment{employee:6, sstart:7, send:16}, 
%%       assignment{employee:7, sstart:10, send:19}], dayofweek:thu}, 
%%    day{dayofmonth:20, vettype:slow, day_schedule:[
%%       assignment{employee:3, sstart:9, send:18}, 
%%       assignment{employee:4, sstart:7, send:16}, 
%%       assignment{employee:5, sstart:11, send:20}, 
%%       assignment{employee:6, sstart:7, send:16}, 
%%       assignment{employee:7, sstart:11, send:20}], dayofweek:fri}, 
%%    day{dayofmonth:21, vettype:slow, day_schedule:[
%%       assignment{employee:6, sstart:8, send:17}, 
%%       assignment{employee:4, sstart:8, send:17}, 
%%       assignment{employee:2, sstart:8, send:17}], dayofweek:sat}, 
%%    day{dayofmonth:22, vettype:none, day_schedule:[], dayofweek:sun}, 
%%    day{dayofmonth:23, vettype:slow, day_schedule:[
%%       assignment{employee:3, sstart:8, send:17}, 
%%       assignment{employee:4, sstart:8, send:17}, 
%%       assignment{employee:5, sstart:8, send:17}, 
%%       assignment{employee:6, sstart:10, send:19}, 
%%       assignment{employee:7, sstart:9, send:20}], dayofweek:mon}, 
%%    day{dayofmonth:24, vettype:slow, day_schedule:[
%%       assignment{employee:2, sstart:9, send:20}, 
%%       assignment{employee:3, sstart:8, send:17}, 
%%       assignment{employee:4, sstart:7, send:16}, 
%%       assignment{employee:5, sstart:7, send:16}, 
%%       assignment{employee:6, sstart:9, send:18}, 
%%       assignment{employee:7, sstart:9, send:20}], dayofweek:tue}, 
%%    day{dayofmonth:25, vettype:slow, day_schedule:[
%%       assignment{employee:1, sstart:9, send:20}, 
%%       assignment{employee:3, sstart:8, send:17}, 
%%       assignment{employee:4, sstart:7, send:16}, 
%%       assignment{employee:5, sstart: 7, send:16}, 
%%       assignment{employee:6, sstart:9, send:18}, 
%%       assignment{employee:7, sstart:9, send:20}], dayofweek:wed}, 
%%    day{dayofmonth:26, vettype:slow, day_schedule:[
%%       assignment{employee:1, sstart:8, send:19}, 
%%       assignment{employee:2, sstart:7, send:18}, 
%%       assignment{employee:4, sstart:7, send:16}, 
%%       assignment{employee:6, sstart:9, send:18}, 
%%       assignment{employee:7, sstart:8, send:19}], dayofweek:thu}, 
%%    day{dayofmonth:27, vettype:slow, day_schedule:[
%%       assignment{employee:1, sstart:9, send:20}, 
%%       assignment{employee:3, sstart:8, send:17}, 
%%       assignment{employee:4, sstart:9, send:16}, 
%%       assignment{employee:5, sstart:9, send:16}, 
%%       assignment{employee:6, sstart:10, send:19}], dayofweek:fri}, 
%%    day{dayofmonth:28, vettype:slow, day_schedule:[
%%       assignment{employee:5, sstart:8, send:17}, 
%%       assignment{employee:3, sstart:8, send:17}], dayofweek:sat}, 
%%    day{dayofmonth:29, vettype:none, day_schedule:[], dayofweek:sun}, 
%%    day{dayofmonth:30, vettype:slow, day_schedule:[
%%       assignment{employee:1, sstart:8, send:17}, 
%%       assignment{employee:3, sstart:8, send:17}, 
%%       assignment{employee:4, sstart:8, send:17}, 
%%       assignment{employee:6, sstart:11, send:20}, 
%%       assignment{employee:7, sstart:10, send:19}], dayofweek:mon}, 
%%    day{dayofmonth:31, vettype:slow, day_schedule:[
%%       assignment{employee:2, sstart:9, send:20}, 
%%       assignment{employee:3, sstart:8, send:17}, 
%%       assignment{employee:4, sstart:7, send:16},
%%       assignment{employee:6, sstart:11,send:20}, 
%%       assignment{employee:7, sstart:10, send:19}], dayofweek:tue}, 
%%    day{dayofmonth:32, vettype:slow, day_schedule:[
%%       assignment{employee:1, sstart:7, send:16}, 
%%       assignment{employee:3, sstart:8, send:17}, 
%%       assignment{employee:4, sstart:7, send:16}, 
%%       assignment{employee:6, sstart:11,send:20}, 
%%       assignment{employee:7, sstart:10,send:19}], dayofweek:wed}, 
%%    day{dayofmonth:33, vettype:slow, day_schedule:[
%%       assignment{employee:1, sstart:7, send:16}, 
%%       assignment{employee:2, sstart:9, send:20}, 
%%       assignment{employee:3, sstart:8, send:17}, 
%%       assignment{employee:6, sstart:11,send:20}, 
%%       assignment{employee:7, sstart:10, send:19}], dayofweek:thu}, 
%%    day{dayofmonth:34, vettype:slow, day_schedule:[
%%       assignment{employee:1, sstart:7, send:16}, 
%%       assignment{employee:3, sstart:8, send:17}, 
%%       assignment{employee:4, sstart:7, send:16}, 
%%       assignment{employee:6, sstart:11, send:20}, 
%%       assignment{employee:7, sstart:10, send:19}], dayofweek:fri}, 
%%    day{dayofmonth:35, vettype:slow, day_schedule:[
%%       assignment{employee:1, sstart:8, send:17}, 
%%       assignment{employee:4, sstart:8, send:17}, 
%%       assignment{employee:2, sstart:8, send:17}], dayofweek:sat} 
    ],
  objective(Month,Value),

%% Here for testing with a ground Month  
turn_Month_into_a_list_of_assignments(Month,Assignments),
writeln(assignemnts:Assignments),

  
  show_schedule(Month),!.
  
schedule(First_Day_Of_Week,Employee,Current_Week) :-
%%I'd like to send in schedule(1,...) for 1st week, but sublist returns starting day 2...
  mod(First_Day_Of_Week,7,Mod), Mod is 0, %Only valid for first day of a Week
  %Last_Day_Of_Week is First_Day_Of_Week + 6,
  construct(Month),
  sublist(Month,First_Day_Of_Week,7,Current_Week),
  constraints(Current_Week),
  bb_min(
    (search(Current_Week),objective(Current_Week,Value)),
    Value,
    bb_options{
     from:0,
     timeout:2,
     report_success:show_schedule(Employee,Current_Week)}
  ).
  
employee_Hours_In_Week(Current_Employee,Day_Schedules_Of_Week,HoursWorkedInWeek,_,_,_) :-
employee_Hours_In_Week(Current_Employee,Day_Schedules_Of_Week,HoursWorkedInWeek),
 writeln(hours:HoursWorkedInWeek).

employee_Hours_In_Week(Current_Employee,Month,HoursWorkedInWeek) :-
  turn_Month_into_a_list_of_assignments(Month,Day_Schedules_Of_Week), 
%  writeln(Day_Schedules_Of_Week),
employees_hours_in_assignments(Current_Employee,Day_Schedules_Of_Week,HoursWorkedInWeek).
%  (
%    foreach(Day_Schedule,Day_Schedules_Of_Week), 
%    fromto([],In,Out,Durations), % what if someone works none in the week? Maybe initialize with [0]
%%    param(Current_Employee)
%    do
%      Day_Schedule = assignment{employee:Scheduled_Employee, sstart:Start, send:End},
%      (
%          (ground(Scheduled_Employee),Scheduled_Employee =:= Current_Employee) ->
%          Duration is End-Start,
%          Out=[Duration | In]
%        ;
%          Out=In
%      )
%  ),
%  ground(Durations) -> sumlist(Durations,HoursWorkedInWeek) ;
%                       HoursWorkedInWeek is 0.

turn_Month_into_a_list_of_assignments(Month,Assignments) :-
  (foreach(Day,Month),fromto([],In,Out,As) do
      Day = day with[day_schedule:Day_Schedules],
      Out = [In | Day_Schedules]
   ),
  flatten(As,Assignments).

peel([H|T], H, T).
peel([_|T],E,Outlist) :-  peel(T,E,Outlist).

score_employees(Assignments,Employees,Employees_With_Scores):-
  score_employees(Assignments,Employees,[],Employees_With_Scores).
	
score_employees(_Assignments,[],Employees_With_Scores,Employees_With_Scores).

score_employees(Assignments,[H | Tail],Accumulator,Employees_With_Scores) :-
	%writeln(score_employees:[H | Tail]-Accumulator),
	employees_hours_in_assignments(H,Assignments,HoursWorkedInWeek),
  Accumulator_New = [(H,HoursWorkedInWeek) | Accumulator],
  score_employees(Assignments,Tail,Accumulator_New,Employees_With_Scores).

%score_employees([],_Scored_Employees).
%score_employees([H|T],Scored_Employees) :-
%  writeln([(H,4)| Scored_Employees] ),
%  score_employees( T, [(H,4)| Scored_Employees] ).
  
var_choice(_Assignment,Criterion) :-
  Criterion is 1.

% Predicate that is the signature of the first time we get called
% We get the whole month.  We construct a list of (E,S)
% Then we sort/4 according to S and deconstruct the couples into a list
% of E only, called EmployeeList.
val_choice(Assignment,(Assignments-[]),Out) :-
  findall(Employee,employee(Employee,_,_),EmployeeList),
  %writeln('allo'),
	score_employees(Assignments,EmployeeList,ScoredEmployeeList),
	%writeln(scored:ScoredEmployeeList),
	sort(2,=<,ScoredEmployeeList,SortedScoredEmployeeList),
	%writeln(sorted:SortedScoredEmployeeList),
  (foreach((Emp,_),SortedScoredEmployeeList),fromto([],In,Out,SortedEmployeeList) 
		do
      Out = [Emp|In]
   ),
	%writeln(flatsorted:SortedEmployeeList),
	%pause,
  %employees_hours_in_assignments(1,Assignments,HoursWorkedInWeek),
  %employee_Hours_In_Week(1,Month,H),
	%writeln(HoursWorkedInWeek),
% In this pre-alpha implementation we are just naively setting out to the list of Employees	
  grind(SortedEmployeeList,Assignment,OutEmployees),
  Out = (Assignments-OutEmployees).

% If In== Month-V and V==[], then this is the first time we get called and we
% need to do the sort thing-y to order the employees in the order we
% want to try them out for this assignment else we take the head of
% the vector V as the employee to try and Out is the tail of V
% The structure of V could be [(Emp,Start,End)*]
val_choice(Assignment,(Month-L),Out) :-
  grind(L,Assignment,VOut),
  Out = (Month-VOut).

grind(List,Assignment,Out) :-
  Assignment = assignment{employee:Employee, sstart:Start, send: End},
  (ground(Employee) -> true ; peel(List,Employee,Out)),
  (ground(End) -> indomain(Start,max) ; indomain(Start,min)),
  indomain(End).

schedule(Month) :-
  construct(Month),
  constraints(Month),
  turn_Month_into_a_list_of_assignments(Month,Assignments),
  %writeln(assignemnts:Assignments),

  bb_min(
  		(
        	search(
								Assignments,
                0,
                var_choice, % maybe just use "input_order" if we never have var_choice do actual work
                val_choice((Assignments-[]),_),
                complete,
                []
              ),
              objective(Month,Value)
        ),
        Value,
%            bb_options{from:0,timeout:50,report_failure:show_schedule(Month)}),
        bb_options{from:0,timeout:20}),  
  % NOTE: need to use the val_choice to add lower bounds to Value to
  % bound and kill some branches of the search tree.
  
%  bb_min(
%    (search(Month),objective(Month,Value)),
%    Value,
%    %bb_options{from:0,timeout:10}),
%    bb_options{from:0,timeout:10,report_failure:show_schedule(Month)}),
%    %bb_options above limit computation time to one minute
%    %bb_options below print out each found schedule
%    %bb_options{from:0,report_success:show_schedule(Month)}),

  
  show_schedule(Month),
  !.
