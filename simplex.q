\d .simplex

// Construct a zero matrix or order {@code x}
matrix0:{x#enlist x#0f};
// Construct an identity matrix of order {@code x}
matrixI:{"f"$x=/:x:til x};
// Construct a diagonal matrix whose diagonal is vector {@code x}
matrixDiag:{x*'matrixI count x};

// Construct a simplex tableau using standard form ({@code A}, {@code b}, {@code c}) parameters
tableau:{[A;b;c](A,'matrixI[n],'b),enlist[c,(1+n:count A)#0f]};
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
solve:{[A;b;c]{pivot[x;pivotRow[x;p];p:pivotCol x]}/[(not optimal@);tableau[A;b;c]]};

\
__EOD__

.simplex.solve[(2 1.;1 2.);4 3.;-1 -1.]
.simplex.solve[(2 1.;1 2.);4 3.;-1 -.5]
.simplex.solve[(2 1.;2 3.);8 12.;-3 -1.]
.simplex.solve[(1 0 3.;3 1 3.);6 9.;-4 -1 1.]
.simplex.solve[(2 1 1.;1 2 1.;0 0 1.);4 7 5.;-2 -3 -2.]
.simplex.solve[(3 1.;1 -1.;0 1.);6 2 3.;-2 -1.]
.simplex.solve[(-1 1.;1 -2.);1 2.;-2 -1.]   /unbounded
