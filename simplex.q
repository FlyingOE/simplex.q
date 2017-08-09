/ Universal assumptions for all LP problems:
/ <ul>
/ <li>All variables X >= 0
/       <ul>
/       <li>If x<=0, substitute with y = -x >= 0
/       <li>If x is unconstraint, substitute with y1 - y2 = x, where y1 >= 0 and y2 >= 0
/       </ul>
/ </ul>
/ @see http://college.cengage.com/mathematics/larson/elementary_linear/4e/shared/downloads/c09s1.pdf
\d .simplex

/ Construct a zero matrix or order {@code x}
matrix0:{x#enlist x#0f};
/ Construct an identity matrix of order {@code x}
matrixI:{"f"$x=/:x:til x};
/ Construct a diagonal matrix whose diagonal is vector {@code x}
matrixDiag:{x*'matrixI count x};

/ Construct a Simplex tableau using standard form ({@code A * x <= b})
/ @see .simplex.solveStd
/ @see .simplex.solveExt
/ @see .simplex.SetObjective
tableau:{[A;b;c;LG;Max]
    if[count[A]<>count[b]        ;'"Dim(A) <> Dim(b)"    ];
    if[any 0<>1_deltas count'[A] ;'"Dim'(A) inconsistent"];
    if[count[c]<>1+count[first A];'"Dim'(A)+1 <> Dim(c)" ];
    if[any b<0                   ;'"b < 0"               ];
    ("f"$A,'matrixDiag[LG],'b),enlist$[Max;-1.;1.]*(-1_c),(count[A]#0.),neg[-1#c] };
/ Check if a Simplex solution is optimal
canImprove:{any 0>-1_last x};
/ Identify the pivot column (assuming {@code canImprove[T] = 1b})
pivotCol:{first iasc -1_last x};
/ Identify the pivot row (Bland's rule)
pivotRow:{[T;pc]first iasc?[$[any b:c>=0;b;'"unbounded"];last'[-1_T]%c:-1_T[;pc];0w]};
/ Pivot the tableau
pivot:{[T;pr;pc]?[pr=til count T;T%T[;pc];T-T[;pc]*\:T[pr]%T[pr;pc]]};
/ Identify basic variables and their corresponding row indices
basicVarRows:{?[1=sum'[k];(first where@)each 1=k:(1 0 1 2)@-1 0 1.?/:flip -1_/:-1_x;0N]};
/ Identify basic variable that violates non-negative constraint
infeasibleCol:{first where 0<x b first where 0>0.^(-1_flip x)@'b:basicVarRows x}
notFeasible:not null infeasibleCol@;
/ Retrieve answer from a solution matrix
/ @see .simplex.solveStd
/ @see .simplex.solveExt
answer:{[T]`obj`X!(last/[T];0.^last'[T][b]*(-1_flip T)@'b:basicVarRows[T])};

/ Solve an LP with Simplex method.<p>
/ Maximize {@code c}{@literal X}, given {@code A}{@literal X} <= {@code b} and {@literal X} >= 0.
/ @param A ()  Constraint coefficients (size = {@literal m * n})
/ @param b ()  Constraint value (length = {@literal m}, {@code b >= 0})
/ @param c ()  Objective function (length = {@literal n + 1})
/ @param LG () {@literal 0} if the corresponding constraint is an equality; {@literal 1} if is a less-than-or-equal-to; {@literal -1} otherwise.
/ @param Max (Bool) If this is a maximization problem
solveExt:{[A;b;c;LG;maxi]
    {pivot[x;pivotRow[x;p];p:pivotCol      x]}/[canImprove ;]
    {pivot[x;pivotRow[x;p];p:infeasibleCol x]}/[notFeasible;]
        tableau[A;b;c;LG;maxi]
    };

/ Solve an LP (in standard form) with Simplex method.
/ @see .simplex.solveExt
solveStd:{[A;b;c]solveExt[A;b;c,0.;count[A]#1.;1b]};

/////////////////////////////////////////////////////////////////////////////
// Helpers to allow setting up LP parameters step by step.
/////////////////////////////////////////////////////////////////////////////

/ Set optimization objective
/ @param obj ()  Coefficients in the objective function
/ @param const (Float) Constant coefficient in the objective function 
/ @param maxi (Bool) If the objective is to be maximized
SetObjective:{[obj;const;maxi]
    `A`b`c`LG`Max!(();0#0n;1.*obj,const;0#0n;maxi)  };
/ Linear maximization problem
Maximize:SetObjective[;;1b];
/ Linear minimization problem
Minimize:SetObjective[;;0b];

/ Add a constraint
AddConstraint:{[coeff;rhs;solver;LG]
    if[count[coeff]<>-1+count[solver`c];'"length: coeff"];
    sign:$[rhs<0;-1.;1.];
    :@[;`A;,;enlist sign*coeff]@[;`b;,;sign*rhs]@[;`LG;,;sign*LG]solver;
    };
/ Add an equality condition
Eq       :AddConstraint[;;; 0];
/ Add a less-than-or-equal-to condition
LessEq   :AddConstraint[;;; 1];
/ add a greater-than-or-equal-to condition
GreaterEq:AddConstraint[;;;-1];

/ Solve the LP problem
Optimize:{[solver]
    @[;`obj;$[solver`Max;1.;-1.]*]
    @[;`X;count[-1_solver`c]#]
        answer solveExt . solver`A`b`c`LG`Max
    };

\
__EOD__