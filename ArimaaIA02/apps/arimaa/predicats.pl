%terminer push et pull
%compteur de mouvements par tour
%fonction pour  compter le nb de lapins
%impl�menter le getMove

:- dynamic board/1.

board([[0,0,rabbit,silver],[0,1,rabbit,silver],[0,2,horse,silver],[0,3,rabbit,silver],[0,4,elephant,silver],[0,5,rabbit,silver],[0,6,rabbit,silver],[0,7,rabbit,silver],[1,0,camel,silver],[1,1,cat,silver],[1,2,rabbit,silver],[1,3,dog,silver],[1,4,rabbit,silver],[4,5,horse,silver],[4,6,dog,gold],
[1,7,cat,silver],[2,7,rabbit,gold],[6,1,horse,gold],[6,2,camel,silver],[6,3,elephant,gold],[6,4,rabbit,gold],[6,5,dog,gold],[6,6,rabbit,gold],[7,0,rabbit,gold],[7,1,rabbit,gold],[7,2,rabbit,gold],[7,3,cat,gold],[7,4,dog,gold],[7,5,rabbit,gold],[7,6,horse,gold],[7,7,rabbit,gold]]).

% pr�dicats pour la comparaison de la force des pi�ces

strength([_,_,elephant,_],6).
strength([_,_,camel,_],5).
strength([_,_,horse,_],4).
strength([_,_,dog,_],3).
strength([_,_,cat,_],2).
strength([_,_,rabbit,_],1).

is_stronger(Piece1,Piece2):- strength(Piece1,X),strength(Piece2,Y), X>Y.



% pr�dicat de capture d'une pi�ce

trap([3,3,_,_]).
trap([6,6,_,_]).
trap([3,6,_,_]).
trap([6,3,_,_]).

element(X,[X|Q]).
element(X,[T|Q]):- element(X,Q).

friend([U,V,_,X]):- W is V+1,element([U,w,_,Y]).
friend([U,V,_,X]):- W is V-1,element([U,w,_,Y]).
friend([U,V,_,X]):- W is U+1,element([W,V,_,Y]).
friend([U,V,_,X]):- W is U-1,element([W,V,_,Y]).

capture(Piece):- \+ friend(Piece), trap(Piece).



% pr�dicat de gel d'une pi�ce

element2([X,Y,Z,C],[[X,Y,Z,C]|Q]).
element2(X,[T|Q]):- element2(X,Q).


enemy([U,V,_,X],Z):- W is V+1,element2([U,w,Z,Y]),X\=Y. %unifie Z avec l'animal adversaire en pr�sence s'il existe
enemy([U,V,_,X],Z):- W is V-1,element2([U,w,Z,Y]),X\=Y.
enemy([U,V,_,X],Z):- W is U+1,element2([W,V,Z,Y]),X\=Y.
enemy([U,V,_,X],Z):- W is U-1,element2([W,V,Z,Y]),X\=Y.

is_frozen(Piece):- enemy(Piece,Z), is_stronger([_,_,Z,_],Piece),\+ friend(Piece).


% pr�dicat pour d�loger les pi�ces adverses

is_enemy([_,_,_,D],[_,_,_,Z]):- D\=Z. %unification si les deux pi�ces sont adverses

is_free([A,B,_,_]):-  board(Board), \+ element2([A,B,_,_], Board). %savoir si une case est libre

ajout_tete(X,L,[X|L]).


supprimer(X,[],[]).
supprimer(X,[X|L1],L1). 
supprimer(X,[Y|L1],L2):-X\==Y , ajout_tete(Y,L3,L2), supprimer(X,L1,L3). 

concat([],L,L).
concat([T|Q],L,[T|R]):- concat(Q,L,R).

%modification de la base de faits (modification de Board)
%un push et un pull pour chaque direction

push([A,B,C,D],[W,X,Y,Z]):- board(Board),is_enemy([A,B,C,D],[W,X,Y,Z]), is_stronger([A,B,C,D],[W,X,Y,Z]), H is W+1, is_free([H,X,Y,Z]), I is A+1, supprimer([A,B,C,D],Board,Board2), concat([[I,B,C,D]],Board2,Board3),supprimer([W,X,Y,Z],Board3,Board4), concat([[H,X,Y,Z]],Board4,Board5), retractall(board(_)), asserta(board(Board5)). 

push([A,B,C,D],[W,X,Y,Z]):- board(Board),is_enemy([A,B,C,D],[W,X,Y,Z]), is_stronger([A,B,C,D],[W,X,Y,Z]), H is W-1, is_free([H,X,Y,Z]), I is A-1, supprimer([A,B,C,D],Board,Board2), concat([[I,B,C,D]],Board2,Board3),supprimer([W,X,Y,Z],Board3,Board4), concat([[H,X,Y,Z]],Board4,Board5), retractall(board(_)), asserta(board(Board5)). 

push([A,B,C,D],[W,X,Y,Z]):- board(Board),is_enemy([A,B,C,D],[W,X,Y,Z]), is_stronger([A,B,C,D],[W,X,Y,Z]), H is X+1, is_free([H,X,Y,Z]), I is B+1, supprimer([A,B,C,D],Board,Board2), concat([[I,B,C,D]],Board2,Board3),supprimer([W,X,Y,Z],Board3,Board4), concat([[H,X,Y,Z]],Board4,Board5), retractall(board(_)), asserta(board(Board5)). 

push([A,B,C,D],[W,X,Y,Z]):- board(Board),is_enemy([A,B,C,D],[W,X,Y,Z]), is_stronger([A,B,C,D],[W,X,Y,Z]), H is X-1, is_free([H,X,Y,Z]), I is B-1, supprimer([A,B,C,D],Board,Board2), concat([[I,B,C,D]],Board2,Board3),supprimer([W,X,Y,Z],Board3,Board4), concat([[H,X,Y,Z]],Board4,Board5), retractall(board(_)), asserta(board(Board5)). 

reculer([A,B,C,D], [X,B,_,_]):- X is A-1, is_free([X,B,C,D]).
reculer([A,B,C,D], [X,B,_,_]):- X is A+1, is_free([X,B,C,D]).
reculer([A,B,C,D], [A,X,_,_]):- X is B+1, is_free([A,X,C,D]).
reculer([A,B,C,D], [A,X,_,_]):- X is B-1, is_free([A,X,C,D]).

pull([A,B,C,D],[W,X,Y,Z]):- board(Board),is_enemy([A,B,C,D],[W,X,Y,Z]), is_stronger([A,B,C,D],[W,X,Y,Z]), reculer([A,B,C,D],[M,N,_,_]), supprimer([W,X,Y,Z],Board,Board2), concat([[A,B,Y,Z]],Board2,Board3), supprimer([A,B,C,D],Board3,Board4), concat([M,N,C,D],Board4,Board5), retractall(board(_)), asserta(board(Board5)).




%get_moves(Moves, Gamestate, Board):-

