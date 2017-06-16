%test():-X is 2.

maxlist([],0).

maxlist([Head|Tail],Max) :-
    maxlist(Tail,TailMax),
    Head > TailMax,
    Max is Head.

maxlist([Head|Tail],Max) :-
    maxlist(Tail,TailMax),
    Head =< TailMax,
    Max is TailMax.


get_Ypos([_,Y,_,_],Y).

concat([],L,L).
concat([T|Q],L,[T|R]):- concat(Q,L,R).

get_Ypos_list([], []).
get_Ypos_list([TList|QList], PosList):-get_Ypos(TList,Y),concat([Y],ListIntermediaire,PosList), get_Ypos_list(QList,ListIntermediaire).


max_list(L, M, I) :- nth0(I, L, M), \+ (member(E, L), E > M).
 %get_Y_pos_list([[1,2,l,m],[0,3,p,l],[0,6,p,l],[0,2,p,l],[0,3,p,l]], P).


rabbit_silver_win([0,7,rabbit,silver]). %bas gauche
rabbit_silver_win([1,7,rabbit,silver]).
rabbit_silver_win([2,7,rabbit,silver]).
rabbit_silver_win([3,7,rabbit,silver]).
rabbit_silver_win([4,7,rabbit,silver]).
rabbit_silver_win([5,7,rabbit,silver]).
rabbit_silver_win([6,7,rabbit,silver]).
rabbit_silver_win([7,7,rabbit,silver]). %bas droite

board([[1,2,l,m],[0,3,p,l],[7,0,rabbit,silver],[0,2,p,l],[0,3,p,l]]).

element2([X,Y,Z,C],[[X,Y,Z,C]|Q]).
element2(X,[T|Q]):- element2(X,Q).

has_won_silver() :- board(Board), element2([_,7,rabbit,silver],Board).


%has_won_silver([[1,2,l,m],[0,3,p,l],[0,6,p,l],[0,2,p,l],[0,3,p,l]]).