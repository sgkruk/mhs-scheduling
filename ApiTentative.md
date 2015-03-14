# Introduction #

Trying to abstract what are the necessary calls to model all the scheduling situations we have in mind.  The idea is not to be tied down to a particular language but rather to develop an abstract language to model scheduling problems.

The second step will be to try various implementations of these calls.

The goal, then, is to describe an API for "Resources-Intervals" schedules where a finite set of discrete _resources_ (employees, jobs, vehicles, etc.) are to be scheduled over a finite set of finite time _intervals_ (shifts, microseconds, calendar days, etc.) from a short list of varied resource versus interval _request_ relationships that are exactly satisfiable and optimizable against an objective function. After completing the API model with an exact description, implementation in will ECLiPSe serve as an example implementation of a model that can be set up in other, suitable languages.

# Details #

At first glance we have two types, _requests_ and _resources_.  A _request_ is a set of constraints relating resources attributes and time intervals.  A resource is an element with a specific set of attributes and time availabilities.

For example, a request is "Need 3 managers Monday from 9 to 12" or "5 vehicles on weekdays".  A resource is "Paul Edouard, Manager, 10 years seniority, available M-F 0900h-1600h" or "Truck, large, available W-Sa".

## Request examples ##

We need to be able to state requests of the form:

  * Need 12 trucks delivering goods M - Sa
    * 'trucks' are resources
    * 'delivering' is a type of schedule ('maintenance' is another one)
    * 'M - Sa' is a time interval
  * Need 3 managers at work Monday from 9 to 12
    * 'managers' are resources
    * 'work' is a type of schedule ('on call' is another one)
    * 'Monday from 9 to 12' is a time interval
  * Need 8 machines with rated for heavy-duty forming morning shifts M - F
    * 'machines' are resources
    * 'work' is a type of schedule ('on call' is another one)
    * 'morning shifts M - F' is a time interval ('afternoon shifts M - Sa' is another one)
    * 'rated for heavy-duty forming' is a verifiable attribute of resource 'machine'

We need also to state requests that affect sets of resources:

  * All employees work at most 20 hours per week.
    * 'employee' is a set of resources;
    * 'work' is a type of schedule;
    * 20 hours per week is a time interval descriptor
  * All trucks are assigned at most 12 hours per day
    * A different time descriptor of the same structure
  * All machines are working at most 20 consecutive hours
    * The time interval descriptor has a different structure
  * The Maitre'd is not available for breakfast shifts
    * 'Maitre'd' is a resource
    * 'not available' is dangerous.  Should we insist (or translate) all requests into a positive form?  'Maitres'd' are available all lunch and dinner shifts'.

(We should add to this list all statements we intend to support).

## Request examples abstracted ##

The idea here is to abstract the above into a small problem specific language.

Roughly in BNF...

  * Request: Count Comparator ResourceDescriptor EventType TimeDescriptor
  * ResourceDescriptor : Resource.Attribute (e.g. employee.interns ; database dependent)
  * EventType : 'atWork' | 'onCall' ... (database dependent?)
  * Comparator : AtMost | AtLeast, | Exactly (?)
  * TimeDescriptor : CalendarSpecific | CalendarRepeatable | SlidingWindow | xOutOfy

CalendarSpecific is a given interval, e.g. Monday June 14th 0900-1600h

CalendarRepeatable is a time interval that repeats e.g. Monday or First of the month

SlidingWindow is for 20 consecutive hours or 3 consecutive days

xOutOfy is to allow stuff like 2 days out of 5