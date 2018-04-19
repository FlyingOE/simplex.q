/ Helpers to format complex matrices into real matrices.
/ <p>
/ Note that a complex number of the format a+bi can be reformatted into an
/ augmented real matrix: (a b;-b a).
/ <p>
/ Performing ordinary matrix operations on the augmented matrix is equivalent 
/ to the same on the original complex number. Furthermore, complex matrices can
/ be reformatted to augmented real matrices in a similar fashion.
/ @see http://www.sosmath.com/matrix/complex/complex.html
///////////////////////////////////////////////////////////////////////////////
/ This version uses COIN-OR CLP library as the underlying implementation.
\d .cplx

/ Get only the real component from a complex matrix.
/ @param d (Long) Number of dimensions of the complex matrix
/ @param m () Source matrix
/q) .cplx.getReal[0]10f                    /==> 10f
/q) .cplx.getReal[0]10 3f                  /==> 10f
/q) .cplx.getReal[1]10 3f                  /==> 10 3f
/q) .cplx.getReal[1](10f;3 4f)             /==> 10 3f
/q) .cplx.getReal[2](1 2f;3 4f)            /==> (1 2f;3 4f)
/q) .cplx.getReal[2]((1f;3 4f);(5 6f;7f))  /==> (1 3f;5 7f)
getReal:{[d;m] {[d;m] $[0>=d;m 0;.z.s/:[d-1;m]] }[d]norm[d;m] };

/ Normalize a mixed real/complex matrix into a complex matrix.
/ @param d (Long) Number of dimensions of the mixed matrix
/ @param m () Source matrix
/q) .cplx.norm[0]10f                    /==> 10 0f
/q) .cplx.norm[0]10 3f                  /==> 10 3f
/q) .cplx.norm[1]10 3f                  /==> (10 0f;3 0f)
/q) .cplx.norm[1](10f;3 4f)             /==> (10 0f;3 4f)
/q) .cplx.norm[2](1 2f;3 4f)            /==> ((1 0f;2 0f);(3 0f;4 0f))
/q) .cplx.norm[2]((1f;3 4f);(5 6f;7f))  /==> ((1 0f;3 4f);(5 6f;7 0f))
norm:{[d;m] $[0>=d;$[1=count m;m,0.;m];.z.s/:[d-1;m]] };

/ Denormalize a complex matrix into a mixed real/complex matrix.
/ @param d (Long) Number of dimensions of the complex matrix
/ @param m () Source matrix
/q) .cplx.denorm[0]10 0f                      /==> 10f
/q) .cplx.denorm[0]10 3f                      /==> 10 3f
/q) .cplx.denorm[1](10 0f;3 0f)               /==> 10 3f
/q) .cplx.denorm[1](10 0f;3 4f)               /==> (10f;3 4f)
/q) .cplx.denorm[2]((1 0f;2 0f);(3 0f;4 0f))  /==> (1 2f;3 4f)
/q) .cplx.denorm[2]((1 0f;3 4f);(5 6f;7 0f))  /==> ((1f;3 4f);(5 6f;7f))
denorm:{[d;m] $[0>=d;$[0=m 1;m 0;m];.z.s/:[d-1;m]] };

/ Flatten a complex matrix into an augmented real matrix.
/ @param d (Long) Number of dimensions of the complex matrix
/ @param d () Source matrix
/ @see .cplx.augment2
augment:{[d;m] $[0>=d;(m;-1 1*m 1 0);$[1=d;{(,/')(x[;0];x[;1])};,/].z.s/:[d-1;m]] };

/ @see .cplx.augment
/q) .cplx.augment2[0]10f                    /==> (10 0f;0 10f)
/q) .cplx.augment2[0]10 3f                  /==> (10 3f;-3 10f)
/q) .cplx.augment2[1]10 3f                  /==> (10 0 3 0f;0 10 0 3f)
/q) .cplx.augment2[1](10f;3 4f)             /==> (10 0 3 4f;0 10 -4 3f)
/q) .cplx.augment2[2](1 2f;3 4f)            /==> (1 0 2 0f;0 1 0 2f;3 0 4 0f;0 3 0 4f)
/q) .cplx.augment2[2]((1f;3 4f);(5 6f;7f))  /==> (1 0 3 4f;0 1 -4 3f;5 6 7 0f;-6 5 0 7f)
augment2:{[d;m] augment[d]norm[d]m };

/ Degrade an augmented real matrix into a complex matrix.
/ @param d (Long) Number of dimensions of the augmented matrix
/ @param m () Augmented matrix
/ @see .cplx.degrade2
degrade:{[d;m] $[0>=d;m 0;$[1=d;0N 2#m 0;.z.s/:[d-1;0N 2#m]]] };

/ @see .cplx.degrade
/q) .cplx.degrade2[0](10 0f;0 10f)                            /==> 10f
/q) .cplx.degrade2[0](10 3f;-3 10f)                           /==> 10 3f
/q) .cplx.degrade2[1](10 0 3 0f;0 10 0 3f)                    /==> 10 3f
/q) .cplx.degrade2[1](10 0 3 4f;0 10 -4 3f)                   /==> (10f;3 4f)
/q) .cplx.degrade2[2](1 0 2 0f;0 1 0 2f;3 0 4 0f;0 3 0 4f)    /==> (1 2f;3 4f)
/q) .cplx.degrade2[2](1 0 3 4f;0 1 -4 3f;5 6 7 0f;-6 5 0 7f)  /==> ((1f;3 4f);(5 6f;7f))
degrade2:{[d;m] denorm[d]degrade[d]m };

\
===============================================================================