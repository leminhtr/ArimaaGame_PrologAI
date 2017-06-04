terminer push et pull
compteur de mouvements par tour
fonction pour  compter le nb de lapins
implémenter le getMove




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


enemy([U,V,_,X],Z):- W is V+1,element2([U,w,Z,Y]),X\=Y.
enemy([U,V,_,X],Z):- W is V-1,element2([U,w,Z,Y]),X\=Y.
enemy([U,V,_,X],Z):- W is U+1,element2([W,V,Z,Y]),X\=Y.
enemy([U,V,_,X],Z):- W is U-1,element2([W,V,Z,Y]),X\=Y.

is_frozen(Piece):- enemy(Piece,Z), is_stronger([_,_,Z,_],Piece),\+ friend(Piece).



% prédicat pour déloger les pièces adverses

push([A,B,C,D],[W,X,Y,Z]):- is_enemy([A,B,C,D],[W,X,Y,Z]), is_stronger(C,Y), is_free([W+1,X,_,_])
push([A,B,C,D],[W,X,Y,Z]):-
push([A,B,C,D],[W,X,Y,Z]):-
push([A,B,C,D],[W,X,Y,Z]):-

%un push pour chaque direction

pull




get_moves(Moves, Gamestate, Board):-

