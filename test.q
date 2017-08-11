/   delete from`.simplex
\l simplex.q

round:{x*floor .5+y%x};
assertAnswer:{(~). round/:[x;(y;z)]};
assertFullAnswer:{assertAnswer[x;y;@[z;`X;count[y`X]#]]};

///////////////////////////////////////////////////////////////////////////////
.simplex.answer .simplex.solveStd[(2 1;1 2);4 3;1 1;0]
.simplex.answer .simplex.solveStd[(2 1;1 2);4 3;1 .5;0]
.simplex.answer .simplex.solveStd[(2 1;2 3);8 12;3 1;0]
.simplex.answer .simplex.solveStd[(1 0 3;3 1 3);6 9;4 1 -1;0]
.simplex.answer .simplex.solveStd[(2 1 1;1 2 1;0 0 1);4 7 5;2 3 2;0]
.simplex.answer .simplex.solveStd[(3 1;1 -1;0 1);6 2 3;2 1;0]
@[.simplex.answer .simplex.solveStd .;((-1 1;1 -2);1 2;2 1;0);::]   /unbounded

.simplex.Optimize
    .simplex.LessEq  [5 3 6;15]
    .simplex.LessEq  [1 1 1; 6]
    .simplex.Maximize[5 3 1; 0]

// Maximize 2x + 3y + 2z
// Such that x,y,z >= 0
//  2x +  y + z <= 4
//   x + 2y + z <= 7
//            z <= 5
X:
 .simplex.Optimize
    .simplex.LessEq  [0 0 1;5]
    .simplex.LessEq  [1 2 1;7]
    .simplex.LessEq  [2 1 1;4]
    .simplex.Maximize[2 3 2;0]
;assertAnswer[1e-15;X;`obj`X!(11.;0 3 1.)]

///////////////////////////////////////////////////////////////////////////////
//@see https://www.math.ucla.edu/~tom/LP.pdf
X:
 .simplex.Optimize
    .simplex.LessEq  [-1 1; 1]
    .simplex.LessEq  [ 4 2;12]
    .simplex.LessEq  [ 1 2; 4]
    .simplex.Maximize[ 1 1; 0]
;assertAnswer[1e-15;X;`obj`X!(10;8 2)%3]

///////////////////////////////////////////////////////////////////////////////
//@see https://ocw.mit.edu/courses/sloan-school-of-management/15-053-optimization-methods-in-management-science-spring-2013/tutorials/MIT15_053S13_tut06.pdf
.simplex.Optimize
    .simplex.Eq       [ 1  1  0;10]
    .simplex.GreaterEq[-1 -1  1; 2]
    .simplex.LessEq   [ 1 -2 -1; 3]
    .simplex.Minimize [ 1  1  1; 0]

.simplex.Optimize
    .simplex.GreaterEq[2 1;5]
    .simplex.GreaterEq[1 2;3]
    .simplex.Minimize [1 1;0]

///////////////////////////////////////////////////////////////////////////////
//@see https://jeremykun.com/2014/12/01/linear-programming-and-the-simplex-algorithm/
X:
 .simplex.Optimize
    .simplex.LessEq  [1 -1;1]
    .simplex.LessEq  [1  2;4]
    .simplex.Maximize[3  2;0]
;assertAnswer[1e-15;X;`obj`X!(8.;2 1.)]

///////////////////////////////////////////////////////////////////////////////
//@see http://12000.org/my_notes/simplex/index.htm
X:
 .simplex.Optimize
    .simplex.LessEq  [1 2;9]    /silver (oz.)
    .simplex.LessEq  [3 1;8]    /gold (oz.)
    .simplex.Maximize[4 5;0]    /profit
;assertAnswer[1e-15;X;`obj`X!(24.6;1.4 3.8)]

X:
 .simplex.Optimize
    .simplex.GreaterEq[ -1.5 1; 0]
    .simplex.GreaterEq[  2   2; 4]
    .simplex.LessEq   [  2   2;10]
    .simplex.Maximize [1%30 15; 0]
;assertAnswer[1e-12;X;`obj`X!(1%3.;0 5.)]

.simplex.Optimize
    .simplex.GreaterEq[1 4; 6]
    .simplex.GreaterEq[4 2;12]
    .simplex.Minimize [2 3; 0]

///////////////////////////////////////////////////////////////////////////////
//@see https://sourceforge.net/projects/phpsimplexsolve/files/
X:
 .simplex.Optimize
    .simplex.GreaterEq[3 2;3]
    .simplex.GreaterEq[1 2;4]
    .simplex.Minimize [2 5;0]
;assertAnswer[1e-11;X;`obj`X!(8.;4 0.)]

///////////////////////////////////////////////////////////////////////////////
//@see http://college.cengage.com/mathematics/larson/elementary_linear/4e/shared/downloads/c09s2.pdf
X:
 .simplex.Optimize
    .simplex.LessEq  [ 2 5;90]
    .simplex.LessEq  [ 1 1;27]
    .simplex.LessEq  [-1 1;11]
    .simplex.Maximize[ 4 6; 0]
;assertAnswer[1e-15;X;`obj`X!(132.;15 12.)]

X:
 .simplex.Optimize
    .simplex.LessEq   [ 2  5;27]
    .simplex.LessEq   [-1  1; 4]
    .simplex.LessEq   [ 3 -1;15]
    .simplex.GreaterEq[ 2  3; 6]
    .simplex.Minimize [ 5  7; 0]
;assertAnswer[1e-15;X;`obj`X!(14.;0 2.)]

.simplex.Optimize
    .simplex.LessEq  [4 1;16]
    .simplex.LessEq  [1 3;15]
    .simplex.Minimize[3 2; 0]
;
.simplex.Optimize
    .simplex.LessEq  [4 1;16]
    .simplex.LessEq  [1 3;15]
    .simplex.Maximize[3 2; 0]

.simplex.Optimize
    .simplex.LessEq   [1  5;20]
    .simplex.LessEq   [3 -2; 9]
    .simplex.GreaterEq[2  3; 6]
    .simplex.Minimize [4  3; 0]
;
.simplex.Optimize
    .simplex.LessEq   [1  5;20]
    .simplex.LessEq   [3 -2; 9]
    .simplex.GreaterEq[2  3; 6]
    .simplex.Maximize [4  3; 0]

X:
 .simplex.Optimize
    .simplex.LessEq  [250 400;70000]    /total investment
    .simplex.LessEq  [  1   1;  250]    /total demand
    .simplex.Maximize[ 45  50;    0]    /profit
;assertAnswer[1e-15;X;`obj`X!(11500.;200 50.)]

X:
 .simplex.Optimize
    .simplex.LessEq  [  .3  .1; 30]     /days for picking
    .simplex.LessEq  [  1   2 ;240]     /days for trimming
    .simplex.LessEq  [  1   1 ;150]     /land area
    .simplex.Maximize[140 235 ;  0]     /profit
;assertAnswer[1e-15;X;`obj`X!(29550.;60 90.)]

X:
 .simplex.Optimize
    .simplex.GreaterEq[ 2  3;24]       /nutrition C
    .simplex.GreaterEq[ 2  9;36]       /nutrition B
    .simplex.GreaterEq[ 2  1;12]       /nutrition A
    .simplex.Minimize [25 20; 0]       /cost
;assertAnswer[1e-15;X;`obj`X!(195.;3 6.)]

X:
 .simplex.Optimize
    .simplex.Eq       [ 1   1  ; 1]     /proportion
    .simplex.GreaterEq[80  92  ;90]     /octane rating
    .simplex.Minimize [ .83 .98; 0]     /cost
;assertAnswer[1e-10;X;`obj`X!(.955;1 5%6.)]

///////////////////////////////////////////////////////////////////////////////
//@see http://college.cengage.com/mathematics/larson/elementary_linear/4e/shared/downloads/c09s3.pdf
X:
 .simplex.Optimize
    .simplex.LessEq  [0  0  2; 5]
    .simplex.LessEq  [1  2 -2;20]
    .simplex.LessEq  [2  1  0;10]
    .simplex.Maximize[2 -1  2; 0]
;assertAnswer[1e-15;X;`obj`X!(15.;5 0 2.5)]

X:
 .simplex.Optimize
    .simplex.LessEq  [1 2 3;40]
    .simplex.LessEq  [2 3 1;60]
    .simplex.Eq      [4 1 1;30]
    .simplex.Maximize[3 2 1; 0]
;assertAnswer[1e-15;X;`obj`X!(45.;3 18 0.)]

X:
 .simplex.Optimize
    .simplex.LessEq  [1%2  3  2  ; 2400]   /packaging
    .simplex.LessEq  [  2  2  3%3; 4600]   /trimming
    .simplex.LessEq  [  2  4  3%2;12000]   /molding
    .simplex.Maximize[ 11 16 15  ;    0]   /profit
;assertAnswer[1e-15;X;`obj`X!(100200.;600 5100 800.)]

X:
 .simplex.Optimize
    .simplex.LessEq   [  -9   1   1    ;    0]  /TV ads priority
    .simplex.GreaterEq[   1   1  -1    ;    0]  /radio ads balance
    .simplex.LessEq   [   0   1   0    ;   10]  /newspaper ads limit
    .simplex.LessEq   [2000 600 300    ;18200]  /total budget
    .simplex.Maximize [ 100  40  18*1e3;    0]  /viewership
;assertAnswer[1e-15;X;`obj`X!(1052*1e3;4 10 14.)]

@[.simplex.Optimize;;::]
    .simplex.LessEq  [-1  2;4]
    .simplex.LessEq  [ 1 -3;1]
    .simplex.Maximize[ 1  2;0]
 
@[.simplex.Optimize;;::]
    .simplex.LessEq  [-2 1;50]
    .simplex.LessEq  [-1 1;20]
    .simplex.Maximize[ 1 3; 0]

X:
 .simplex.Optimize
    .simplex.LessEq  [5   2;10]
    .simplex.LessEq  [3   5;15]
    .simplex.Maximize[2.5 1; 0]
;assertAnswer[1e-15;X;`obj`X!(5.;2 0.)]

X:
 .simplex.Optimize
    .simplex.LessEq  [1 3 ;35]
    .simplex.LessEq  [2 1 ;20]
    .simplex.Maximize[1 .5; 0]
;assertAnswer[1e-15;X;`obj`X!(10.;10 0.)]

.simplex.Optimize
    .simplex.LessEq  [ .5  .7 1.2   .4;80]
    .simplex.LessEq  [1.2 1   1    1.2;96]
    .simplex.LessEq  [1   1    .83  .5;65]
    .simplex.Maximize[2   7   6    4  ; 0]

.simplex.Optimize
    .simplex.LessEq  [ .5  .7 1.2   .4;80]
    .simplex.LessEq  [1.2 1   1    1.2;96]
    .simplex.LessEq  [1   1    .83  .5;65]
    .simplex.Maximize[1.2 1   1    1  ; 0]

///////////////////////////////////////////////////////////////////////////////
//@see http://college.cengage.com/mathematics/larson/elementary_linear/4e/shared/downloads/c09s4.pdf
X:
 .simplex.Optimize
    .simplex.GreaterEq[10  30  ; 90]    /vitamin C
    .simplex.GreaterEq[12   6  ; 36]    /vitamin A
    .simplex.GreaterEq[60  60  ;300]    /calories
    .simplex.Minimize [ .12 .15;  0]    /cost
;assertAnswer[1e-9;X;`obj`X!(.66;3 2.)]

///////////////////////////////////////////////////////////////////////////////
//@see http://college.cengage.com/mathematics/larson/elementary_linear/4e/shared/downloads/c09s5.pdf
X:
 .simplex.Optimize
    .simplex.GreaterEq[1 0 1;10]
    .simplex.GreaterEq[2 1 0;36]
    .simplex.LessEq   [2 1 1;50]
    .simplex.Maximize [1 1 2; 0]
;assertAnswer[1e-15;X;`obj`X!(64.;0 36 14.)]

X:
 .simplex.Optimize
    .simplex.GreaterEq[2 1 1; 4]
    .simplex.LessEq   [4 2 3;16]
    .simplex.LessEq   [3 2 5;18]
    .simplex.Maximize [3 2 4; 0]
;assertAnswer[1e-15;X;`obj`X!(17.;0 6.5 1)]

X:
 .simplex.Optimize
    .simplex.GreaterEq[1 4 3; 6]
    .simplex.GreaterEq[3 1 5; 4]
    .simplex.LessEq   [2 3 4;14]
    .simplex.Minimize [4 2 1; 0]
;assertAnswer[1e-11;X;`obj`X!(2.;0 0 2.)]

X:
 .simplex.Optimize
    .simplex.LessEq   [ 0  1;  300] /customer 2
    .simplex.LessEq   [ 1  0;  200] /customer 1
    .simplex.GreaterEq[ 1  1;  200] /factory 2 (derived)
    .simplex.LessEq   [ 1  1;  400] /factory 1
    .simplex.Minimize [-6 -5;16200] /shipment cost
;assertAnswer[1e-15;X;`obj`X!(14000.;200 200.)]

X:
 .simplex.Optimize
    .simplex.GreaterEq[ 0  1  0  1;300] /customer 2
    .simplex.GreaterEq[ 1  0  1  0;200] /customer 1
    .simplex.LessEq   [ 0  0  1  1;300] /factory 2
    .simplex.LessEq   [ 1  1  0  0;400] /factory 1
    .simplex.Minimize [30 25 36 30;  0] /shipment cost
;assertAnswer[1e-15;X;`obj`X!(14000.;200 200 0 100.)]

.simplex.Optimize
    .simplex.GreaterEq[ 0  1  0  1;300] /customer 2
    .simplex.GreaterEq[ 1  0  1  0;200] /customer 1
    .simplex.LessEq   [ 0  0  1  1;300] /factory 2
    .simplex.LessEq   [ 1  1  0  0;400] /factory 1
    .simplex.Minimize [36 30 30 25;  0] /shipment cost

.simplex.Optimize
    .simplex.GreaterEq[ 0  1  0  1;300] /customer 2
    .simplex.GreaterEq[ 1  0  1  0;200] /customer 1
    .simplex.LessEq   [ 0  0  1  1;300] /factory 2
    .simplex.LessEq   [ 1  1  0  0;400] /factory 1
    .simplex.Minimize [25 30 35 30;  0] /shipment cost

.simplex.Optimize
    .simplex.GreaterEq[ 0  1    ;  4    ]   /newspaper ads
    .simplex.GreaterEq[ 1  0    ;  6    ]   /TV ads
    .simplex.LessEq   [60 15*1e3;600*1e3]   /budget
    .simplex.Maximize [15  3*1e6;  0    ]   /viewership

.simplex.Optimize
    .simplex.GreaterEq[ 0  1    ;  4    ]   /newspaper ads
    .simplex.GreaterEq[ 1  0    ;  6    ]   /TV ads
    .simplex.LessEq   [60 30*1e3;600*1e3]   /budget
    .simplex.Maximize [15  3*1e6;  0    ]   /viewership

///////////////////////////////////////////////////////////////////////////////
//@see https://www.utdallas.edu/~scniu/OPRE-6201/documents/LP10-Special-Situations.pdf
X:
 .simplex.Optimize
    .simplex.LessEq  [4 2; 8]
    .simplex.LessEq  [4 1; 8]
    .simplex.LessEq  [4 3;12]
    .simplex.Maximize[2 1; 0]
;assertAnswer[1e-15;X;`obj`X!(4.;2 0.)]

@[.simplex.Optimize;;::]
    .simplex.LessEq  [2 -1;40]
    .simplex.LessEq  [1 -1;10]
    .simplex.Maximize[2  1; 0]

X:
 .simplex.Optimize
    .simplex.LessEq  [7  2;21]
    .simplex.LessEq  [2  7;21]
    .simplex.Maximize[4 14; 0]
;assertAnswer[1e-15;X;`obj`X!(42.;0 3.)]

///////////////////////////////////////////////////////////////////////////////
//@see https://www.youtube.com/watch?v=bAlFmzqWLl8
X:
 .simplex.Optimize
    .simplex.LessEq   [ 1  1;41]
    .simplex.GreaterEq[ 1  4;22]
    .simplex.Maximize [12 10; 0]
;assertAnswer[1e-15;X;`obj`X!(492.;41 0.)]

///////////////////////////////////////////////////////////////////////////////
//@see https://www.youtube.com/watch?v=upgpVkAkFkQ
X:
 .simplex.Optimize
    .simplex.GreaterEq[0  1 1;10]
    .simplex.Eq       [1  0 1; 5]
    .simplex.LessEq   [1  1 0;20]
    .simplex.Maximize [1 -1 3; 0]
;assertAnswer[1e-15;X;`obj`X!(10.;0 5 5.)]

Y:
 .simplex.Optimize
    .simplex.GreaterEq[ 0  1 1; 10]
    .simplex.Eq       [ 1  0 1;  5]
    .simplex.GreaterEq[-1 -1 0;-20]
    .simplex.Maximize [ 1 -1 3;  0]
;assertFullAnswer[1e-15;Y;X]

///////////////////////////////////////////////////////////////////////////////
//@see https://www.youtube.com/watch?v=MZ843Vvia0A
X:
 .simplex.Optimize
    .simplex.GreaterEq[3  9  6;30]
    .simplex.GreaterEq[2  4  6;24]
    .simplex.Minimize [7 15 20; 0]
;assertAnswer[1e-15;X;`obj`X!(82.;6 0 2.)]

///////////////////////////////////////////////////////////////////////////////
//@see https://stackoverflow.com/questions/3956950/c-c-implementation-of-simplex-method
X:
 .simplex.Optimize
    .simplex.LessEq  [ 0  1 0 -1;10]
    .simplex.LessEq  [-2 -1 1  1;10]
    .simplex.LessEq  [ 1  1 1  1;40]
    .simplex.Maximize[ .5 3 1  4; 0]
;assertAnswer[1e-15;X;`obj`X!(145.;0 15 0 25.)]

Y:
 .simplex.answer .simplex.solveStd[
    (1 1 1 1;-2 -1 1 1;0 1 0 -1);
    40 10 10;
    .5 3 1 4;
    0]
;assertFullAnswer[1e-15;X;Y]

///////////////////////////////////////////////////////////////////////////////
//@see http://www.purplemath.com/modules/linprog.htm
X:
 .simplex.Optimize
    .simplex.LessEq   [1 -1; 2]
    .simplex.GreaterEq[3 -1; 0]
    .simplex.LessEq   [1  2;14]
    .simplex.Maximize [3  4; 0]
;assertAnswer[1e-15;X;`obj`X!(34.;6 4.)]

X:
 .simplex.Optimize
    .simplex.LessEq   [1 -1; 2]
    .simplex.GreaterEq[3 -1; 0]
    .simplex.LessEq   [1  2;14]
    .simplex.Minimize [3  4; 0]
;assertAnswer[1e-15;X;`obj`X!(0.;0 0.)]

///////////////////////////////////////////////////////////////////////////////
//@see http://www.purplemath.com/modules/linprog2.htm
X:
 .simplex.Optimize
    .simplex.LessEq   [ 1  0  ;5]
    .simplex.LessEq   [-1  1  ;5]
    .simplex.GreaterEq[ 1  2  ;4]
    .simplex.LessEq   [ 1  1  ;7]
    .simplex.Maximize [-.4 3.2;0]
;assertAnswer[1e-15;X;`obj`X!(18.8;1 6.)]

X:
 .simplex.Optimize
    .simplex.LessEq   [ 1  0  ;5]
    .simplex.LessEq   [-1  1  ;5]
    .simplex.GreaterEq[ 1  2  ;4]
    .simplex.LessEq   [ 1  1  ;7]
    .simplex.Minimize [-.4 3.2;0]
;assertAnswer[1e-15;X;`obj`X!(-2.;5 0.)]

X:
 .simplex.Optimize
    .simplex.LessEq   [ 1   0  ;6.4e6]  /gallons of gasoline
    .simplex.GreaterEq[ 0   1  ;3e6  ]  /gallons of fuel oil
    .simplex.GreaterEq[ 1  -2  ;0    ]
    .simplex.Maximize [ 1.9 1.5;0    ]
;assertAnswer[1e-15;X;`obj`X!(16.96e6;6.4e6 3.2e6)]

///////////////////////////////////////////////////////////////////////////////
//@see http://www.purplemath.com/modules/linprog3.htm
X:
 .simplex.Optimize
    .simplex.GreaterEq[ 1 1;200]
    .simplex.LessEq   [ 0 1;170]
    .simplex.GreaterEq[ 0 1; 80]    /# graphing calculators
    .simplex.LessEq   [ 1 0;200]
    .simplex.GreaterEq[ 1 0;100]    /# scientific calculators
    .simplex.Maximize [-2 5;  0]
;assertAnswer[1e-15;X;`obj`X!(650.;100 170.)]

X:
 .simplex.Optimize
    .simplex.LessEq  [ 6  8; 72]    /space
    .simplex.LessEq  [10 20;140]    /cost
    .simplex.Maximize[ 8 12;  0]    /storage
;assertAnswer[1e-15;X;`obj`X!(100.;8 3.)]

Y:
 .simplex.answer .simplex.solveStd[
    (10 20;6 8);
    140 72;
    8 12;
    0]
;assertFullAnswer[1e-15;X;Y]

///////////////////////////////////////////////////////////////////////////////
//@see http://www.purplemath.com/modules/linprog4.htm
X:
 .simplex.Optimize
    .simplex.LessEq   [ 1  1 ; 5]   /total weight
    .simplex.GreaterEq[ 2  1 ; 4]   /protein
    .simplex.GreaterEq[12 12 ;36]   /carbohydrates
    .simplex.GreaterEq[ 8 12 ;24]   /fat
    .simplex.Minimize [ .2 .3; 0]
;assertAnswer[1e-11;X;`obj`X!(.6;3 0.)]

X:
 .simplex.Optimize
    .simplex.GreaterEq[1  -3   0  ;    0]   /municipal bond / bank CD
    .simplex.LessEq   [0   0   1  ; 2000]   /high-risk account
    .simplex.LessEq   [1   1   1  ;12000]   /basis
    .simplex.Maximize [.07 .08 .12;    0]
;assertAnswer[1e-8;X;`obj`X!(965.;7500 2500 2000.)]

///////////////////////////////////////////////////////////////////////////////
//@see http://www.purplemath.com/modules/linprog5.htm
X:
 .simplex.Optimize
    .simplex.LessEq  [0  1  0  1  ;45]  /west-side warehouse
    .simplex.LessEq  [1  0  1  0  ;80]  /east-side warehouse
    .simplex.Eq      [0  0  1  1  ;70]  /customer B
    .simplex.Eq      [1  1  0  0  ;50]  /customer A
    .simplex.Minimize[.5 .4 .6 .55; 0]
;assertAnswer[1e-15;X;`obj`X!(62.5;5 45 70 0.)]

///////////////////////////////////////////////////////////////////////////////
//@see https://www.zweigmedia.com/RealWorld/simplex.html
//     (interactive solver)
X:
 .simplex.Optimize
    .simplex.GreaterEq[3 1;4]
    .simplex.LessEq   [1 1;2]
    .simplex.Maximize [1 1;0]
;assertAnswer[1e-15;X;`obj`X!(2.;1 1.)]

///////////////////////////////////////////////////////////////////////////////
// Portfolio optimization test
pw_index:0 55 77 204 525 687 1062 1593 1764 1909;
a:raze{con:(2305)#0f;(con pw_index x):1f;(con x+2295):-1f;enlist con}each til count pw_index;
a:((neg a),enlist (2295#1f),10#-1f);
b:0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0;
c:get`:data/c;
LG:11#1f;
s:`A`b`c`LG!(a;b;c;LG);

S1:.simplex.answer .simplex.solveStd[a;b;neg c;0]
S2:.simplex.Optimize{[x;y;a;b].simplex.LessEq[a y;b y] x}[;;a;b]/[.simplex.Minimize[c;0];til count b]
(count[c]#S1[`X])~S2[`X]