%terminer push et pull
%compteur de mouvements par tour
%fonction pour  compter le nb de lapins
%implémenter le getMove

:- dynamic board/1.

board([[0,0,rabbit,silver],[0,1,rabbit,silver],[0,2,horse,silver],[0,3,rabbit,silver],[0,4,elephant,silver],[0,5,rabbit,silver],[0,6,rabbit,silver],[0,7,rabbit,silver],[1,0,camel,silver],[1,1,cat,silver],[1,2,rabbit,silver],[1,3,dog,silver],[1,4,rabbit,silver],[1,5,horse,silver],[1,6,dog,silver],
[1,7,cat,silver],[2,7,rabbit,gold],[6,0,cat,gold],[6,1,horse,gold],[6,2,camel,gold],[6,3,elephant,gold],[6,4,rabbit,gold],[6,5,dog,gold],[6,6,rabbit,gold],[7,0,rabbit,gold],[7,1,rabbit,gold],[7,2,rabbit,gold],[7,3,cat,gold],[7,4,dog,gold],[7,5,rabbit,gold],[7,6,horse,gold],[7,7,rabbit,gold]]).

% prédicats pour la comparaison de la force des pièces

strength([_,_,elephant,_],6).
strength([_,_,camel,_],5).
strength([_,_,horse,_],4).
strength([_,_,dog,_],3).
strength([_,_,cat,_],2).
strength([_,_,rabbit,_],1).

is_stronger(Piece1,Piece2):- strength(Piece1,X),strength(Piece2,Y), X>Y.



% prédicat de capture d'une pièce

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



% prédicat de gel d'une pièce

element2([X,Y,Z,C],[[X,Y,Z,C]|Q]).
element2(X,[T|Q]):- element2(X,Q).


enemy([U,V,_,X],Z):- W is V+1,element2([U,w,Z,Y]),X\=Y. %unifie Z avec l'animal adversaire en présence s'il existe
enemy([U,V,_,X],Z):- W is V-1,element2([U,w,Z,Y]),X\=Y.
enemy([U,V,_,X],Z):- W is U+1,element2([W,V,Z,Y]),X\=Y.
enemy([U,V,_,X],Z):- W is U-1,element2([W,V,Z,Y]),X\=Y.

is_frozen(Piece):- enemy(Piece,Z), is_stronger([_,_,Z,_],Piece),\+ friend(Piece).


% prédicat pour déloger les pièces adverses

is_enemy([_,_,_,D],[_,_,_,Z]):- D\=Z. %unification si les deux pièces sont adverses

is_free([A,B,_,_]):-  board(Board), \+ element2([A,B,_,_], Board). %savoir si une case est libre

ajout_tete(X,L,[X|L]).


supprimer(X,[],[]).
supprimer(X,[X|L1],L1). 
supprimer(X,[Y|L1],L2):-X\==Y , ajout_tete(Y,L3,L2), supprimer(X,L1,L3). 

concat([],L,L).
concat([T|Q],L,[T|R]):- concat(Q,L,R).

push([A,B,C,D],[W,X,Y,Z]):- board(Board),is_enemy([A,B,C,D],[W,X,Y,Z]), is_stronger([A,B,C,D],[W,X,Y,Z]), H is W+1, is_free([H,X,Y,Z],Board), I is A+1, supprimer([A,B,C,D],Board,Board2), concat([[I,B,C,D]],Board2,Board3),supprimer([W,X,Y,Z],Board3,Board4), concat([[H,X,Y,Z]],Board4,Board5), retractall(board(_)), asserta(board(Board5)). %modification de la base de faits (modification de Board)

%push([A,B,C,D],[W,X,Y,Z]):-
%push([A,B,C,D],[W,X,Y,Z]):-
%push([A,B,C,D],[W,X,Y,Z]):-

%un push pour chaque direction

%pull


%get_moves(Moves, Gamestate, Board):-

