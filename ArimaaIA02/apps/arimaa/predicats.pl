terminer push et pull
compteur de mouvements par tour
fonction pour  compter le nb de lapins
impl�menter le getMove




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


enemy([U,V,_,X],Z):- W is V+1,element2([U,w,Z,Y]),X\=Y.
enemy([U,V,_,X],Z):- W is V-1,element2([U,w,Z,Y]),X\=Y.
enemy([U,V,_,X],Z):- W is U+1,element2([W,V,Z,Y]),X\=Y.
enemy([U,V,_,X],Z):- W is U-1,element2([W,V,Z,Y]),X\=Y.

is_frozen(Piece):- enemy(Piece,Z), is_stronger([_,_,Z,_],Piece),\+ friend(Piece).



% pr�dicat pour d�loger les pi�ces adverses

push([A,B,C,D],[W,X,Y,Z]):- is_enemy([A,B,C,D],[W,X,Y,Z]), is_stronger(C,Y), is_free([W+1,X,_,_])
push([A,B,C,D],[W,X,Y,Z]):-
push([A,B,C,D],[W,X,Y,Z]):-
push([A,B,C,D],[W,X,Y,Z]):-

%un push pour chaque direction

pull




get_moves(Moves, Gamestate, Board):-

