\d .simplex

// Construct a zero matrix or order {@code x}
matrix0:{x#enlist x#0f};
// Construct an identity matrix of order {@code x}
matrixI:{"f"$x=/:x:til x};
// Construct a diagonal matrix whose diagonal is vector {@code x}
matrixDiag:{x*'matrixI count x};

// Construct a simplex tableau using standard form ({@code A}, {@code b}, {@code c}) parameters
tableau :{[A;b;c]   tableau1[A;b;c;count[A]#1b]};
tableau1:{[A;b;c;LG](A,'matrixDiag[LG],'b),enlist[c,(1+n:count A)#0f]};
// Check if a simplex solution is optimal
optimal:{[T]all 0<=last T};
// Identify the pivot column
pivotCol:{[T]first iasc last T};
// Identify the pivot row (Bland's rule)
pivotRow:{[T;pc]first iasc?[$[any b:c>0;b;'"unbounded"];last'[-1_T]%c:-1_T[;pc];0w]};
// Pivot the tableau
pivot:{[T;pr;pc]?[pr=til count T;T%T[;pc];T-T[;pc]*\:T[pr]%T[pr;pc]]};
// Solve an LP with simplex method<p>
// Minimize c*X, given that A*X<=b and X>=0.
solve :{[A;b;c]   {pivot[x;pivotRow[x;p];p:pivotCol x]}/[(not optimal@);tableau [A;b;c]   ]};
solve1:{[A;b;c;LG]{pivot[x;pivotRow[x;p];p:pivotCol x]}/[(not optimal@);tableau1[A;b;c;LG]]};

/////////////////////////////////////////////////////////////////////////////

Maximize:{[coeff]`A`b`c`LG!(();0#0n;neg"f"$coeff;0#0n)};
Minimize:{[coeff]`A`b`c`LG!(();0#0n;   "f"$coeff;0#0n)};
AddLessEq   :{[solver;coeff;rhs]
    if[count[coeff]<>count[solver`c];'"length: coeff"];
    @[;`A;,;enlist"f"$coeff]@[;`b;,;"f"$rhs]@[;`LG;,; 1f]solver};
AddGreaterEq:{[solver;coeff;rhs]
    if[count[coeff]<>count[solver`c];'"length: coeff"];
    @[;`A;,;enlist"f"$coeff]@[;`b;,;"f"$rhs]@[;`LG;,;-1f]solver};
Optimize:{[solver]solve1 . solver`A`b`c`LG};

\
__EOD__

.simplex.solve[(2 1.;1 2.);4 3.;-1 -1.]
.simplex.solve[(2 1.;1 2.);4 3.;-1 -.5]
.simplex.solve[(2 1.;2 3.);8 12.;-3 -1.]
.simplex.solve[(1 0 3.;3 1 3.);6 9.;-4 -1 1.]
.simplex.solve[(2 1 1.;1 2 1.;0 0 1.);4 7 5.;-2 -3 -2.]
.simplex.solve[(3 1.;1 -1.;0 1.);6 2 3.;-2 -1.]
.simplex.solve[(-1 1.;1 -2.);1 2.;-2 -1.]   /unbounded

\l C:\Users\freddie.wu\Desktop\simplex.q

// Maximize 2x + 3y + 2z
// Given that          z <= 5
//            x + 2y + z <= 7
//           2x +  y + z <= 4
// Where x >= 0, y >= 0, z >= 0
s:.simplex.Maximize[2 3 2];
s:.simplex.AddLessEq[s;0 0 1;5];
s:.simplex.AddLessEq[s;1 2 1;7];
s:.simplex.AddLessEq[s;2 1 1;4];
.simplex.Optimize s

// Miminize -2x + 3y
// Given that x - 3y + 2z <= 3
//           -x + 2y      >= 2
// Where x is unrestricted, y >= 0, z >= 0
//(Convert x into x = x1 - x2, where x1 >= 0, x2 >= 0)
t:.simplex.Minimize[-2 2 3 0];
t:.simplex.AddLessEq   [t;1 -1 -3 2;3];
t:.simplex.AddGreaterEq[t;-1 1 2 0;2];
.simplex.Optimize t

r:.simplex.Maximize[5 3 1];
r:.simplex.AddLessEq[r;1 1 1;6];
r:.simplex.AddLessEq[r;5 3 6;15];
.simplex.Optimize r
