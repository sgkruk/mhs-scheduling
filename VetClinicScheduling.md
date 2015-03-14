# Introduction #

This is a real-world example drawn from the Michigan Humane Society.

# Details #

Example: Vet Clinic Scheduling

_E_ := A Set of Employees
_E_ := { e<sub>1</sub>, e<sub>2</sub>, e<sub>3</sub>, ..., e<sub>n</sub> }

_T_ := A Set of ordered time units. In our case, this represents the entire month's worth of calendar work days' hours in an uninterrupted, ordered list.
_T_ := { h<sub>1</sub>, h<sub>2</sub>, h<sub>3</sub>, ..., h<sub>m</sub> }
Each h<sub>i</sub> represents the hours the clinic is open each day.
Cardinality of _E_ not necessarily equal to cardinality of _T_.

The fundamental sets _E_, _T_ can give rise to any number of required subsets for defining constraints and the eventual objective functions. Initially, when considering calendars or other natural time grouping and _T_ as the set of smallest time atoms of the system, it will be natural to partition _T_ into natural subsets. For us:

_D_<sub>i</sub> := { h in _T_ | h belongs to the _i\_th day of the month }_W_<sub>i</sub> := {_D_in {_D_<sub>1</sub>,_D_<sub>2</sub>, ..._D_<sub>j</sub> } |_D_<sub>i</sub> belongs to the_i\_th week of the month }
_D_ := { _D_<sub>1</sub>, _D_<sub>2</sub>, ... _D_<sub>j</sub> }
etc.

Some Initial Example Constraints:

_F_ < _D_ is a subset of _D_ which is days on which at least 5 employees must be scheduled
_S_ < _D_ is a subset of _D_ which is days on which at least 4 employees must be scheduled
At all days in T, no more than 6 employees can be scheduled

These constraints are entered into the API this way:

constraint(_E_,_D_,Max(6)); //Means each day in T can have no more than 6 e from E.
constraint(_E_,_F_,Min(5));
constraint(_E_,_S_,Min(4));

_K_ < _E_ is a subset of employees that have keys
_L_ < _E_ is a subset of employees that have licenses
_Starts_ < _T_ is the extracted subset of initial hours, opening clinic hours
_Ends_ < _T_ is the extracted subset of final hours, closing clinic hours

Each scheduled day must have a keyed employee and a licensed employee (not necessarily the same person on the first and last hour. Also, there must be two scheduled employees at the first and last hour.

constraint(_E_,_Starts_,Min(2));
constraint(_E_,_Ends_,  Min(2));
constraint(_K_,_Starts_,Min(1));
constraint(_K_,_Ends_,  Min(1));
constraint(_L_,_Starts_,Min(1));
constraint(_L_,_Ends_,  Min(1));

Ordered subsets of T represent weeks, there are five of them.

_W_<sub>1</sub> < _D_ < _T_
_W_<sub>2</sub> < _D_ < _T_
.
.
.
_W_<sub>5</sub> < _D_ < _T_

There are full- and part-time employees. They each have maximum and minimum number of hours (assignments) to be made.

_PTE_ < _E_ is the set of part-time employees
_FTE_ < _E_ is the set of full-time employees

constraint(_PTE_,_W_<sub>1</sub>,Max(35)); //Each e of _PTE_ associates with no more than 35 time units (hours) in week _W_<sub>1</sub>)
constraint(_PTE_,_W_<sub>2</sub>,Max(35));
...
constraint(_PTE_,_W_<sub>5</sub>,Max(35));

constraint(_PTE_,_W_<sub>1</sub>,Min(20)); //Each e of _PTE_ associates with no less than 20 time units (hours) in week W1)
constraint(_PTE_,_W_<sub>2</sub>,Min(20));
...
constraint(_PTE_,_W_<sub>5</sub>,Min(20));

constraint(_FTE_,_W_<sub>1</sub>,Max(45)); //Each e of _FTE_ associates with no more than 45 time units (hours) in week _W_<sub>1</sub>)
constraint(_FTE_,_W_<sub>2</sub>,Max(45));
...
constraint(_FTE_,_W_<sub>5</sub>,Max(45));

constraint(_FTE_,_W_<sub>1</sub>,Min(35)); //Each e of _FTE_ associates with no less than 35 time units (hours) in week _W_<sub>1</sub>)
constraint(_FTE_,_W_<sub>2</sub>,Min(35));
…
constraint(_FTE_,_W_<sub>5</sub>,Min(35));

Employees have at least two contiguous days off for any week that they are assigned. Here we indicate another set days of _T_, _OD_ as the Days Off. Of these two partitions of _T_, each employee e of _E_ assigns to exactly one representation of a _D_ (day) of _T_ (month). We group the days off into weeks _OW_<sub>1</sub>, _OW_<sub>2</sub>, ..., _OW_<sub>5</sub> for convenience of setting up the constraints

constraint(_E_,_OW_<sub>1</sub>,Contiguous(2));
constraint(_E_,_OW_<sub>2</sub>,Contiguous(2));
...
constraint(_E_,_OW_<sub>5</sub>,Contiguous(2));

Some employees for the month have vacation or paid-time-off representing days (_D_<sub>i</sub> of _D_) they cannot be scheduled or hours (h of _T_) for which they cannot be scheduled.

e<sub>1</sub> < _E_
_VacationWeek_ < _D_ < _T_
constraint(e<sub>1</sub>,_VacationWeek_,Max(0)); //e<sub>1</sub> has no assignments to _VacationWeek_.

e<sub>3</sub> < _E_
_Errand_ = { h<sub>j</sub>, h<sub>j+1</sub>, h<sub>j+2</sub> } < _T_
constraint(e<sub>3</sub>,_Errand_,Max(0)); //Employee e<sub>3</sub> has no assignments to hours of set _Errand_.

The API when implemented the sets _E_ and _T_ as nodes of a bipartite graph (_E_,_T_). The program execution attempts to produce a schedule by connecting nodes between _E_ and _T_ according to rules set up by the constraints
constraint(_A_,_B_,Max(n)); //Means no more than n nodes in A are adjacent to node-set B. This is an upper bound on the degree to node-set B.
constraint(A,B,Min(n)); //Means at least n nodes in A are adjacent to node-set B.
> Here each B represents a grouping of nodes on the time-side T (in our case groups of “hours” representing a "day")

constraint(A,B,Contiguous(n)); Means that in node-set B, for each a in A there exists some b<sub>i in B such that a is adjacent to the ordered vertex set {b</sub>i,...,b,,i+n}, In practical application, this 'contiguous' constraint it is not satisfiable since time-off constraints that must be satisfied make the contiguous constraint impossible to meet. Instead, distance to universal contiguousness is minimized as part of the objective function. Since the Contiguous constraint is relaxed in this fashion, it is not expected that a Contiguous constraint will be implemented in the API. The objective function is defined on node degrees, edge count, etc. that can be maximized or minimized to optimize the schedule.

The final produced schedule is an optimized bipartite graph on an allowed edge set.