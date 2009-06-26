% This file represent an instance of the multi-level timeslots cover
% constraints.  This is a very simple structure to test
% functionalities of the inter-layer constraints
	   

% MHS March 2009 schedule

:- local struct(employees(all,licenses,keys)).
	   
:- local struct(level1(all,openinghours,closinghours,
                           mar2, mar3, mar4, mar5, mar6, mar7,
                           mar9, mar10,mar11,mar12,mar13,mar14,
                           mar16,mar17,mar18,mar19,mar20,mar21,
                           mar23,mar24,mar25,mar26,mar27,mar28,
                       hoursOfWeek1,hoursOfWeek2,hoursOfWeek3,hoursOfWeek4)).
:- local struct(level2(alll1,weekdays,weekenddays,week1,week2,week3,week4)).

:- local struct(level3(alll2,month)).
	   
:- local struct(timeslots(hourlevel:level1, 
	   
                          daylevel:level2,
	   
                          weeklevel:level3)).
	   
	   
getEmployees(E) :-
  %all:[             dawn,heidi,kim,eva,kristin,chris,teresa,holly],
  E = employees{all:[1,   2,    3,  4,  5,      6,    7,     8],
	   
                licenses:[1,5,6,7,8],
	   
                keys:[1,3,4,5,7]
	   
                }.
	   
	   
getTimes(T) :-
	   
  T = timeslots{all:[1, 2, 3, 4, 5, 6, 7, 8, 9, 10,11,12,13,
                     14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,
                     29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,
                     44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,
                     59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,
                     74,75,76,77,78,79,80,81,82,83,

                     84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,
                     99, 100,101,102,103,104,105,106,107,108,109,110,111,112,113,
                     114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,
                     129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,
                     144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,
                     159,160,161,162,163,164,165,166,167,168,169,

                     170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,
                     185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,
                     200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,
                     215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,
                     230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,
                     245,246,247,248,249,250,251,252,253,254,

                     255,256,257,258,259,260,261,262,263,264,265,266,267,268,269,
                     270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,
                     285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,
                     300,301,302,303,304,305,306,307,308,309,310,311,312,313,314,
                     315,316,317,318,319,320,321,322,323,324,325,326,327,328,329,
                     330,331,332,333,334,335,336,337,338,339],
                     
                openinghours: [1,14,29,44,59,74,84,99,114,129,144,159,170,185,200,215,230,245,
                               255,270,285,301,316,331],
                closinghours: [13,28,43,58,73,83,98,113,128,143,158,169,184,199,214,229,244,269,
                               284,299,314,329,339],
                
                mar2: [1,2,3,4,5,6,7,8,9,10,12,13],
                mar3: [14,15,16,17,18,19,20,21,22,23,24,25,26,27,28],
                mar4: [29,30,31,32,33,34,35,36,37,38,39,40,41,42,43],
                mar5: [44,45,46,47,48,49,50,51,52,53,54,55,56,57,58],
                mar6: [59,60,61,62,63,64,65,66,67,68,69,70,71,72,73],
                mar7: [74,75,76,77,78,79,80,81,82,83],

                mar9: [84,85,86,87,88,89,90,91,92,93,94,95,96,97,98],
                mar10:[99, 100,101,102,103,104,105,106,107,108,109,110,111,112,113],
                mar11:[114,115,116,117,118,119,120,121,122,123,124,125,126,127,128],
                mar12:[129,130,131,132,133,134,135,136,137,138,139,140,141,142,143],
                mar13:[144,145,146,147,148,149,150,151,152,153,154,155,156,157,158],
                mar14:[159,160,161,162,163,164,166,165,167,168,169],

                mar16:[170,171,172,173,174,175,176,177,178,179,180,181,182,183,184],
                mar17:[185,186,187,188,189,190,191,192,193,194,195,196,197,198,199],
                mar18:[200,201,202,203,204,205,206,207,208,209,210,211,212,213,214],
                mar19:[215,216,217,218,219,220,221,222,223,224,225,226,227,228,229],
                mar20:[230,231,232,233,234,235,236,237,238,239,240,241,242,243,244],
                mar21:[245,246,247,248,249,250,251,252,253,254],

                mar23:[255,256,257,258,259,260,261,262,263,264,265,266,267,268,269],
                mar24:[270,271,272,273,274,275,276,277,278,279,280,281,282,283,284],
                mar25:[285,286,287,288,289,290,291,292,293,294,295,296,297,298,299],
                mar26:[300,301,302,303,304,305,306,307,308,309,310,311,312,313,314],
                mar27:[315,316,317,318,319,320,321,322,323,324,325,326,327,328,329],
                mar28:[330,331,332,333,334,335,336,337,338,339],

                hoursOfWeek1:[1, 2, 3, 4, 5, 6, 7, 8, 9, 10,11,12,13,
                     14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,
                     29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,
                     44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,
                     59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,
                     74,75,76,77,78,79,80,81,82,83
                             ],
                hoursOfWeek2:[84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,
                     99, 100,101,102,103,104,105,106,107,108,109,110,111,112,113,
                     114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,
                     129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,
                     144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,
                     159,160,161,162,163,164,165,166,167,168,169
                             ],
                hoursOfWeek3:[170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,
                     185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,
                     200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,
                     215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,
                     230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,
                     245,246,247,248,249,250,251,252,253,254
                             ],
                hoursOfWeek4:[255,256,257,258,259,260,261,262,263,264,265,266,267,268,269,
                     270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,
                     285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,
                     300,301,302,303,304,305,306,307,308,309,310,311,312,313,314,
                     315,316,317,318,319,320,321,322,323,324,325,326,327,328,329,
                     330,331,332,333,334,335,336,337,338,339
                             ],
                
                alll1:[all of level1,
                       openinghours of level1,
                       closinghours of level1,
                       mar2 of level1,
                       mar3 of level1,
                       mar4 of level1,
                       mar5 of level1,
                       mar6 of level1,
                       mar7 of level1,
                       
                       mar9 of level1,
                       mar10 of level1,
                       mar11 of level1,
                       mar12 of level1,
                       mar13 of level1,
                       mar14 of level1,
                       
                       mar16 of level1,
                       mar17 of level1,
                       mar18 of level1,
                       mar19 of level1,
                       mar20 of level1,
                       mar21 of level1,
                       
                       mar23 of level1,
                       mar24 of level1,
                       mar25 of level1,
                       mar26 of level1,
                       mar27 of level1,
                       mar28 of level1,
                       hoursOfWeek1 of level1,
                       hoursOfWeek2 of level1,
                       hoursOfWeek3 of level1,
                       hoursOfWeek4 of level1
                       ],
                weekdays:[
                             mar2 of level1,
                             mar3 of level1,
                             mar4 of level1,
                             mar5 of level1,
                             mar6 of level1,
                             mar9 of level1,
                             mar10 of level1,
                             mar11 of level1,
                             mar12 of level1,
                             mar13 of level1,
                             mar16 of level1,
                             mar17 of level1,
                             mar18 of level1,
                             mar19 of level1,
                             mar20 of level1,
                             mar23 of level1,
                             mar24 of level1,
                             mar25 of level1,
                             mar26 of level1,
                             mar27 of level1
                         ],
                
                weekenddays:[
                                mar7 of level1,
                                mar14 of level1,
                                mar21 of level1,
                                mar28 of level1	   
                            ],
                week1:[mar2 of level1, 
                       mar3 of level1, 
                       mar4 of level1, 
                       mar5 of level1, 
                       mar6 of level1, 
                       mar7 of level1],
                week2:[mar9 of level1, 
                       mar10 of level1,
                       mar11 of level1,
                       mar12 of level1,
                       mar13 of level1,
                       mar14 of level1],
                week3:[mar16 of level1,
                       mar17 of level1,
                       mar18 of level1,
                       mar19 of level1,
                       mar20 of level1,
                       mar21 of level1],
                week4:[mar23 of level1,
                       mar24 of level1,
                       mar25 of level1,
                       mar26 of level1,
                       mar27 of level1,
                       mar28 of level1],
                
	   
                alll2:[alll1 of level2,
                       
                       weekdays of level2,
                       
                       weekenddays of level2,
                       week1 of level2,
                       week2 of level2,
                       week3 of level2,
                       week4 of level2
                      ],
                month:[
                       week1 of level2,
                       week2 of level2,
                       week3 of level2,
                       week4 of level2
                      ]                
	   
               }.
	   
	   
getCoverConstraints(CC) :-
	   
  CC=[
	   
         cover(all of timeslots,>=,1,licenses of employees),
         cover(weekdays of timeslots,>=,6,all of employees),	   
%         cover(weekenddays of timeslots,=<,5,all of employees),	   
         cover(openinghours of timeslots,=,2,all of employees),
         cover(openinghours of timeslots,>=,1,keys of employees),
         cover(closinghours of timeslots,=,1,all of employees)
     ].
	   

	   
getResourceConstraints(RC) :-
	   
  RC = [
	   
           resource(all of employees, =<, 45, hoursOfWeek1 of timeslots),
           resource(all of employees, =<, 45, hoursOfWeek2 of timeslots),
           resource(all of employees, =<, 45, hoursOfWeek3 of timeslots),
           resource(all of employees, =<, 45, hoursOfWeek4 of timeslots),
           	   
           resource(all of employees, >=, 35, hoursOfWeek1 of timeslots),           
           resource(all of employees, >=, 35, hoursOfWeek2 of timeslots),           
           resource(all of employees, >=, 35, hoursOfWeek3 of timeslots),           
           resource(all of employees, >=, 35, hoursOfWeek4 of timeslots)

	   
       % Also, an employee assigned to any weekday must be assigned to 9..13 contiguous blocks
       % Also, an employee assigned to any weekendday must be assigned to all available hours
       % (Not clear how to implement those two, right now.)
	   
       ].