\l simplex.q

{x set get .Q.dd[`:perf_data]x}each`a`b`c`con2

\ts X:.simplex.Optimize
        x:.simplex.Eq[con2 0;0f]
            {[x;y;a;b].simplex.LessEq[a y;b y] x}[;;a;b]/[.simplex.Maximize[c;0];til count b]

\ts P:.simplex.Optimize
        p:{[a;b;c;con]
            r:first[count each a];
            if[sum 0>r#b;'"some entries in ",string[r],"#b is negative!"];
            Q:{.simplex.LessEq . y,enlist x}/[;r _flip(a;b)]
                .simplex.Maximize[c;0];
            .simplex.Eq[con 0;0f]
                @[ ;`A;,  ;1.*(r#a),'((count[Q`c]-r)#0),/:.simplex.matrixI r]
                @[ ;`A;,\:;r#0.]
                @[ ;`b;,  ;1.*r#b]
                @[Q;`c;,  ;r#0.]
            }[a;b;c;con2]

\ts O:.simplex.Optimize
        o:.simplex.Eq[con2 0;0f]
            {[x;y;a;b].simplex.LessEq[a y;b y] x}[;;a;b]/[                      ;first[count each a]#til count b]
            {[x;y;a;b].simplex.LessEq[a y;b y] x}[;;a;b]/[.simplex.Maximize[c;0];first[count each a]_til count b]

o~p
O~P