:- module(bot,
      [  get_moves/3
      ]).
  
% declaration des predicats dynamiques
 
:- dynamic moves/1.

moves([]).

% predicats generaux

element(X,[X|Q]).
element(X,[T|Q]):- element(X,Q).

element2([X,Y,Z,C],[[X,Y,Z,C]|Q]).
element2(X,[T|Q]):- element2(X,Q).

concat([],L,L).
concat([T|Q],L,[T|R]):- concat(Q,L,R).

ajout_tete(X,L,[X|L]).

supprimer(X,[],[]).
supprimer(X,[X|L1],L1). 
supprimer(X,[Y|L1],L2):-X\==Y , ajout_tete(Y,L3,L2), supprimer(X,L1,L3). 

reverse([],[]).
reverse([X|L1],L2) :- reverse(L1,L3),append(L3,[X],L2).

% predicats pour la gestion dynamique de Board, Moves et Gamestate

change_board(OldPosition, NewPosition,Board,NewBoard):- supprimer(OldPosition,Board,Board2), concat([NewPosition],Board2,Board3), NewBoard = Board3. 

add_move(NewMove) :- moves(M), retract(moves(M)), asserta(moves([NewMove|M])).

% predicats pour la comparaison de la force des pieces

strength([_,_,elephant,_],6).
strength([_,_,camel,_],5).
strength([_,_,horse,_],4).
strength([_,_,dog,_],3).
strength([_,_,cat,_],2).
strength([_,_,rabbit,_],1).

is_stronger(Piece1,Piece2):- strength(Piece1,X),strength(Piece2,Y), X>Y.

% predicat pour savoir s'il existe une piece alliee adjacente a la piece passee en argument

friend([U,V,_,X],Board):- W is V+1,element([U,W,_,Y],Board).
friend([U,V,_,X],Board):- W is V-1,element([U,W,_,Y],Board).
friend([U,V,_,X],Board):- W is U+1,element([W,V,_,Y],Board).
friend([U,V,_,X],Board):- W is U-1,element([W,V,_,Y]Board).

% position des pieges sur la plateau

trap([2,2,_,_]).
trap([5,5,_,_]).
trap([2,5,_,_]).
trap([5,2,_,_]).

% predicat de capture d'une piece

capture(Piece):- \+ friend(Piece), trap(Piece).

% savoir si une piece ennemie se trouve a proximite, et si oui, laquelle

enemy([U,V,W,X],[M,K,O,P],Board):- K is V+1,element2([U,K,O,P],Board),X\=P. 
enemy([U,V,W,X],[M,K,O,P],Board):- K is V-1,element2([U,K,O,P],Board),X\=P.
enemy([U,V,W,X],[K,N,O,P],Board):- K is U+1,element2([K,V,O,P],Board),X\=P.
enemy([U,V,W,X],[K,N,O,P],Board):- K is U-1,element2([K,V,O,P],Board),X\=P.

is_enemy([_,_,_,D],[_,_,_,Z]):- D\=Z. 

% predicat de gel d'une piece

is_frozen(Piece,Board):- enemy(Piece,Piece2,Board), is_stronger(Piece2,Piece),\+ friend(Piece,Board).

% savoir si une case est libre

is_free([A,B,_,_],Board):- \+ element2([A,B,_,_], Board). 

% verifier qu'une position n'est pas hors limites de plateau

board_limit(X):- X=<7, X>=0.

% les positions que l'on chercher à atteindre avec les lapins :

gold_border(X,Y):- X==7, Y>=0, Y=<7 .

reach_gold_border([A,B,C,D],Board,NewBoard):- K is A+1, gold_border(K,B), add_move([[A,B],[K,B]]), change_board([A,B,C,D],[K,B,C,D],Board,NewBoard).

% push doit chercher s'il existe une pièce adverse que l'on peut repousser. Màj de Moves avec add_move.

push([A,B,C,D],Board,NewBoard2):- moves(Moves) enemy([A,B,C,D],[W,X,Y,Z],Board), is_stronger([A,B,C,D],[W,X,Y,Z]), H is W+1, board_limit(H), is_free([H,X,Y,Z],Board), I is A+1, board_limit(I),add_move([[A,B],[I,B]]),add_move([[W,X],[H,X]]), change_board([A,B,C,D],[I,B,C,D],Board,NewBoard), change_board([W,X,Y,Z],[H,X,Y,Z],NewBoard,NewBoard2).

push([A,B,C,D],Board,NewBoard2):- moves(Moves), enemy([A,B,C,D],[W,X,Y,Z],Board), is_stronger([A,B,C,D],[W,X,Y,Z]), H is W-1, board_limit(H), is_free([H,X,Y,Z],Board), I is A-1, board_limit(I),add_move([[A,B],[I,B]]),add_move([[W,X],[H,X]]), change_board([A,B,C,D],[I,B,C,D],Board,NewBoard), change_board([W,X,Y,Z],[H,X,Y,Z],NewBoard,NewBoard2).

push([A,B,C,D],Board,NewBoard2):- moves(Moves), enemy([A,B,C,D],[W,X,Y,Z],Board), is_stronger([A,B,C,D],[W,X,Y,Z]), H is X+1, board_limit(H), is_free([H,X,Y,Z],Board), I is B+1, board_limit(I),add_move([[A,B],[A,I]]),add_move([[W,X],[W,H]]), change_board([A,B,C,D],[A,I,C,D],Board,NewBoard), change_board([W,X,Y,Z],[W,H,Y,Z],NewBoard,NewBoard2).

push([A,B,C,D],Board,NewBoard2):- moves(Moves), enemy([A,B,C,D],[W,X,Y,Z],Board), is_stronger([A,B,C,D],[W,X,Y,Z]), H is X-1, board_limit(H), is_free([H,X,Y,Z],Board), I is B-1, board_limit(I),add_move([[A,B],[A,I]]),add_move([[W,X],[W,H]]), change_board([A,B,C,D],[A,I,C,D],Board,NewBoard), change_board([W,X,Y,Z],[W,H,Y,Z],NewBoard,NewBoard2).

% predicat pull :

reculer([A,B,C,D], [X,B,_,_],Board):- X is A-1, board_limit(X), is_free([X,B,C,D],Board).
reculer([A,B,C,D], [X,B,_,_],Board):- X is A+1, board_limit(X), is_free([X,B,C,D],Board).
reculer([A,B,C,D], [A,X,_,_],Board):- X is B+1, board_limit(X), is_free([A,X,C,D],Board).
reculer([A,B,C,D], [A,X,_,_],Board):- X is B-1, board_limit(X), is_free([A,X,C,D],Board).

pull([A,B,C,D],Board,NewBoard2):- moves(Moves),enemy([A,B,C,D],[W,X,Y,Z],Board), is_stronger([A,B,C,D],[W,X,Y,Z]), reculer([A,B,C,D],[M,N,_,_],Board), add_move([[A,B],[M,N]]),add_move([[W,X],[A,B]]), change_board([A,B,C,D],[M,N,C,D],Board,NewBoard), change_board([W,X,Y,Z],[A,B,Y,Z],NewBoard,NewBoard2).

% deplacer une piece d'une case (4 directions de mouvement):

move_up([A,B,C,D],Board,NewBoard):- moves(Moves), X is A+1, board_limit(X), is_free([X,B,C,D],Board), \+ trap([X,B,C,D]), \+ is_frozen([X,B,C,D],Board), add_move([[A,B],[X,B]]), change_board([A,B,C,D],[X,B,C,D],Board,NewBoard).

move_down([A,B,C,D],Board,NewBoard):- \+ C==rabbit, moves(Moves), X is A-1, board_limit(X), is_free([X,B,C,D],Board), \+ trap([X,B,C,D]), \+ is_frozen([X,B,C,D],Board), add_move([[A,B],[X,B]]), change_board([A,B,C,D],[X,B,C,D],Board,NewBoard).

move_right([A,B,C,D],Board,NewBoard):- moves(Moves), X is B+1, board_limit(X), is_free([A,X,C,D],Board), \+ trap([A,X,C,D]), \+ is_frozen([A,X,C,D],Board), add_move([[A,B],[A,X]]), change_board([A,B,C,D],[A,X,C,D],Board,NewBoard). 

move_left([A,B,C,D],Board,NewBoard):- moves(Moves), X is B-1, board_limit(X), is_free([A,X,C,D],Board), \+ trap([A,X,C,D]), \+ is_frozen([A,X,C,D],Board),  add_move([[A,B],[A,X]]), change_board([A,B,C,D],[A,X,C,D],Board,NewBoard). 

% move cherche un mouvement unitaire. En priorite on cherche à avancer vers l'autre cote du plateau, sinon a gener l'adversaire en perturbant ses mouvements

move([A,B,C,D],Board,NewBoard):- reach_gold_border([A,B,C,D],Board,NewBoard).
move([A,B,C,D],Board,NewBoard):- move_up([A,B,C,D],Board,NewBoard).
move([A,B,C,D],Board,NewBoard):- push([A,B,C,D],Board,NewBoard).
move([A,B,C,D],Board,NewBoard):- pull([A,B,C,D],Board,NewBoard).
move([A,B,C,D],Board,NewBoard):- move_right([A,B,C,D],Board,NewBoard).
move([A,B,C,D],Board,NewBoard):- move_left([A,B,C,D],Board,NewBoard).
move([A,B,C,D],Board,NewBoard):- move_down([A,B,C,D],Board,NewBoard).

% recupere le lapin le plus pres du camp gold : 

closest_rabbit_to_gold([7,Y,rabbit,silver],Board):- element2([7,Y,rabbit,silver],Board),!.

closest_rabbit_to_gold([6,Y,rabbit,silver],Board):- element2([6,Y,rabbit,silver],Board),!.

closest_rabbit_to_gold([5,Y,rabbit,silver],Board):- element2([5,Y,rabbit,silver],Board),!.

closest_rabbit_to_gold([4,Y,rabbit,silver],Board):- element2([4,Y,rabbit,silver],Board),!.

closest_rabbit_to_gold([3,Y,rabbit,silver],Board):- element2([3,Y,rabbit,silver],Board),!.

closest_rabbit_to_gold([2,Y,rabbit,silver],Board):- element2([2,Y,rabbit,silver],Board),!.

closest_rabbit_to_gold([1,Y,rabbit,silver],Board):- element2([1,Y,rabbit,silver],Board),!.

closest_rabbit_to_gold([0,Y,rabbit,silver],Board):- element2([0,Y,rabbit,silver],Board),!.

% mettre le compteur des mouvements à 0 quand le jeu est gagné (un lapin atteint la ligne adverse) :

stop_if_won(Board, Count, NewCount) :- element2([_,7,rabbit,silver],Board),NewCount = 0,!.
stop_if_won(Board, Count, NewCount) :- NewCount is Count-1.

find_move(0,Board).
find_move(Count,Board):- 
	element2([_,_,rabbit,silver],Board),
	closest_rabbit_to_gold(Rabbit,Board), 
	move(Rabbit,Board,NewBoard),
	%stop_if_won(Board,Count,NewCount),
	NewCount is Count-1,
	find_move(NewCount,NewBoard).	

get_moves(Moves, Gamestate, Board):-  
	asserta(moves([])),
	find_move(4,Board),
	reverse(M,Moves).
	%retractall(moves(_)).





















