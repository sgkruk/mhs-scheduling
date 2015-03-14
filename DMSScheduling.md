# Introduction #

This is rostering of a very different flavour: given a course schedule and a list of instructors with preferences, can we assign instructors to courses maximizing satisfaction. I am not certain this fits the original paradigm.  Just trying it on for size.


# Details #

## Sets ##
```
set Instructors;  /* The set of all instructors */
set Mathematicians; /* subset of the above */
set Statisticians; /* idem */
```
Maybe we should have subsets of the type: all instructor qualified to teach Calculus, or MOR45, or MOR**?**

```
set Times := {MWF8, MWF9, TR8 ...}; /* All possible class starting times */
set MTH154 := {MWF8, MWF9, TR17}; /* These are the 3 different sections of MTH154 */
set Courses; {All sections of all courses}
```

## Constraints ##
  * We must have one instructor for each section of MTH154
```
c(Instructor,MTH154,exactly(1))
Semantics:
for{ s in MTH154} sum{i in Instructor} work(i,s) = 1
```
  * Instructor must teach at most 3 courses
```
c(Courses, Instructors, atMost(3))
Semantics:
for{i in instructor}: sum{c in Courses} work(i,c) <= 3
```