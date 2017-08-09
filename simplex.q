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

/ Large constant {@literal M} in the Big M extension of Simplex method
M:1e9;

/ Set optimization objective
/ @param coeff (FloatList) Coefficients in the objective function
/ @param const (Float)     Constant coefficient in the objective function 
/ @param maxi (Bool)       {@literal True} if this is a maximization problem; {@literal false} if minimization
Objective:{[coeff;const;maxi]
    `A`b`c`r`n`max!(();0#0n;-1.*coeff;-1.*const;count coeff;maxi)   };

/ Linear maximization problem
/ @see .simplex.Objective
Maximize:Objective[;;1b];

/ Linear maximization problem
/ @see .simplex.Objective
Minimize:Objective[;;0b];

/ Add a less-than-or-equal-to constraint
LessEq:{[coeff;rhs;Q]
    if[rhs<0;:GreaterEq[neg coeff;neg rhs;Q]];
    @[ ;`A;,  ;enlist 1.*coeff,((count[Q`c]-count[coeff])#0),1]
    @[ ;`A;,\:;0.]
    @[ ;`b;,  ;1.*rhs]
    @[Q;`c;,  ;0.]
    };
    
/ Add a greater-than-or-equal-to constraint
GreaterEq:{[coeff;rhs;Q]
    if[rhs<0;:LessEq[neg coeff;neg rhs;Q]];
    @[ ;`A;,  ;enlist 1.*coeff,((count[Q`c]-count[coeff])#0),-1 1]
    @[ ;`A;,\:;0 0.]
    @[ ;`b;,  ;1.*rhs]
    @[Q;`c;,  ;0.,M*$[Q`max;1.;-1.]]
    };
    
/ Add an equality constraint
Eq:{[coeff;rhs;Q]
    if[rhs<0;:Eq[neg coeff;neg rhs;Q]];
    @[ ;`A;,  ;enlist 1.*coeff,((count[Q`c]-count[coeff])#0),1]
    @[ ;`A;,\:;0.]
    @[ ;`b;,  ;1.*rhs]
    @[Q;`c;,  ;M*$[Q`max;1.;-1.]]
    };
    
/ Solve the LP problem using Simplex (Big M) method
Optimize:{[Q]
    @[;`obj;*;$[Q`max;1.;-1]]
    @[;`X;Q[`n]#]
        answer solve MakeTableau Q
    };

/ Convert an LP problem representation into a Simplex tableau
/ @see .simplex.Objective
MakeTableau:{[Q]tableau .@[Q;`c;*;$[Q`max;1.;-1.]]`A`b`c`r};

/ Construct a Simplex tableau using standard form ({@literal A * x <= b})
/ @see .simplex.MakeTableau
tableau:{[A;b;c;r](A,'b),enlist c,r};

/ Remove {@literal M} from the bottom row of a Simplex tableau (Big M method)
removeM:{[T](-1_T),enlist sum each flip enlist[last T],neg M*T(first where@)each 1=flip T[;k:where last[T]=M]};

/ Identify basic variables from the current Simplex tableau
//basicVar:{[T] -1+sum each k where 1=sum each 0<k:((1+til count t 0)*/:(0<>t))*\:(1=sum each flip 0<>t:-1_/:T)};
basicVar:{[T] where 1=sum each flip 0<>t:-1_/:T};

/ Identify entering variable (Simplex method)
enterVar:{[T]first iasc -1_last T};

/ Identify leaving variable (Simplex method)
/ @param pc (Long) The entering variable
leaveVar:{[T;pc]first iasc?[$[any b:c>=0;b;'"unbounded"];last'[-1_T]%c:-1_T[;pc];0w]};

/ Pivot a Simplex tableau (Simplex method)
/ @param pr (Long) The leaving variable
/ @param pc (Long) The entering variable
pivot:{[T;pr;pc]?[pr=til count T;T%T[;pc];T-T[;pc]*\:T[pr]%T[pr;pc]]};

/ Retrieve the solution from a Simplex tableau
answer:{[T]`obj`X!(
    last/[T];
    //@[(-1+count T 0)#0.;b;:;last'[-1_T]%(-1_T)@'b:basicVar T])
    @[(-1+count T 0)#0.;b;:;]sum each flip(k<>0)*last'[T]%'k:T[;b:.simplex.basicVar T]
    )};

/ Check if a Simplex tableau is feasible (Simplex method)
isFeasible:{[T]all 0<=answer[T]`X};

/ Check if a Simplex tableau's solution can be further improved
canImprove:{[T]any 0>-1_last T};

/ Solve a Simplex tableau using Big M method
solve:{pivot[x;leaveVar[x;pc];pc:enterVar x]}/[canImprove;]removeM@;

/ Solve an LP in maximization standard form ({@literal A * X <= b | maximize C * X})
solveStd:{[A;b;c;r]solve tableau[1.*A,'matrixDiag[n#1];1.*b;-1.*c,(n:count A)#0;-1.*r]};

\
__EOD__