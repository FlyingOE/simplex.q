/ Universal assumptions for all LP problems:
/ <ul>
/ <li>All variables X >= 0
/       <ul>
/       <li>If x<=0, substitute with y = -x >= 0
/       <li>If x is unconstraint, substitute with y1 - y2 = x, where y1 >= 0 and y2 >= 0
/       </ul>
/ </ul>
/ @see http://college.cengage.com/mathematics/larson/elementary_linear/4e/shared/downloads/c09s1.pdf
///////////////////////////////////////////////////////////////////////////////
/ This version uses COIN-OR CLP library as the underlying implementation.
\d .simplex2

DLL:.Q.dd[hsym`$system"cd"]`simplex.q;

/ Set optimization objective
/ @param coeff (FloatList) Coefficients in the objective function
/ @param const (Float)     Constant coefficient in the objective function 
/ @param maxi (Bool)       {@literal True} if this is a maximization problem; {@literal false} if minimization
Objective:{[coeff;const;maxi]
    `objective`constant`maximize`constraints!(coeff;const;maxi;([]coeffs:();lb:0n;ub:0n))   };

/ Linear maximization problem
/ @see .simplex.Objective
Maximize:Objective[;;1b];

/ Linear maximization problem
/ @see .simplex.Objective
Minimize:Objective[;;0b];

/ Add a generic constraint
Constraint:{[coeff;lb;ub;Q]
    @[Q;`constraints;,;`coeffs`lb`ub!(coeff;lb;ub)] };

/ Add a less-than-or-equal-to constraint
/ @see .simplex.Constraint
LessEq:Constraint[;-0wf;;];
    
/ Add a greater-than-or-equal-to constraint
GreaterEq:Constraint[;;0wf;];
    
/ Add an equality constraint
Eq:{[coeff;rhs;Q] Constraint[coeff;rhs;rhs;Q] };
    
/ Solve the LP problem using Simplex (Big M) method
Optimize:{[f;Q]
    @[;`obj;+;Q`constant]`obj`X!f .(Q,(1#`bounds)!1#(::))`maximize`objective`bounds`constraints
    }DLL 2:(`solveCpp;4)

\
__EOD__