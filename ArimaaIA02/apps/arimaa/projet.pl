
:- dynamic board/1.

board([[0,0,rabbit,silver],[0,1,rabbit,silver],[0,2,horse,silver],[0,3,rabbit,silver],[0,4,elephant,silver],[0,5,rabbit,silver],[0,6,rabbit,silver],[0,7,rabbit,silver],[1,0,camel,silver],[1,1,cat,silver],[1,2,rabbit,silver],[1,3,dog,silver],[1,4,rabbit,silver],[4,5,horse,silver],[4,6,dog,gold],
[1,7,cat,silver],[2,7,rabbit,gold],[6,1,horse,gold],[6,2,camel,silver],[6,3,elephant,gold],[6,4,rabbit,gold],[6,5,dog,gold],[6,6,rabbit,gold],[7,0,rabbit,gold],[7,1,rabbit,gold],[7,2,rabbit,gold],[7,3,cat,gold],[7,4,dog,gold],[7,5,rabbit,gold],[7,6,horse,gold],[7,7,rabbit,gold]]).

% predicats pour la comparaison de la force des pieces

strength([_,_,elephant,_],6).
strength([_,_,camel,_],5).
strength([_,_,horse,_],4).
strength([_,_,dog,_],3).
strength([_,_,cat,_],2).
strength([_,_,rabbit,_],1).

is_stronger(Piece1,Piece2):- strength(Piece1,X),strength(Piece2,Y), X>Y.

% predicat de capture d'une piece

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

% predicat de gel d'une piece

element2([X,Y,Z,C],[[X,Y,Z,C]|Q]).
element2(X,[T|Q]):- element2(X,Q).

enemy([U,V,W,X],[M,K,O,P]):- board(Board), K is V+1,element2([M,K,O,P],Board),X\=P. 
enemy([U,V,W,X],[M,K,O,P]):- board(Board), K is V-1,element2([M,K,O,P],Board),X\=P.
enemy([U,V,W,X],[K,N,O,P]):- board(Board), K is U+1,element2([K,N,O,P],Board),X\=P.
enemy([U,V,W,X],[K,N,O,P]):- board(Board), K is U-1,element2([K,N,O,P],Board),X\=P.

is_frozen(Piece):- enemy(Piece,Piece2), is_stronger(Piece2,Piece),\+ friend(Piece).

% predicat pour deloger les pieces adverses

is_enemy([_,_,_,D],[_,_,_,Z]):- D\=Z. %unification si les deux pieces sont adverses

is_free([A,B,_,_]):-  board(Board), \+ element2([A,B,_,_], Board). %savoir si une case est libre

ajout_tete(X,L,[X|L]).

supprimer(X,[],[]).
supprimer(X,[X|L1],L1). 
supprimer(X,[Y|L1],L2):-X\==Y , ajout_tete(Y,L3,L2), supprimer(X,L1,L3). 

concat([],L,L).
concat([T|Q],L,[T|R]):- concat(Q,L,R).

board_limit(X):- X=<8.

in_board([X,Y,_,_]):- board_limit(X), board_limit(Y).

%modification de la base de faits (modification de Board)
%un push et un pull pour chaque direction
% push doit chercher s'il existe une pièce adverse que l'on peut repousser

push([A,B,C,D]):- board(Board), enemy([A,B,C,D],[W,X,Y,Z]), is_stronger([A,B,C,D],[W,X,Y,Z]), H is W+1, board_limit(H), is_free([H,X,Y,Z]), I is A+1, board_limit(I), supprimer([A,B,C,D],Board,Board2), concat([[I,B,C,D]],Board2,Board3),supprimer([W,X,Y,Z],Board3,Board4), concat([[H,X,Y,Z]],Board4,Board5), retractall(board(_)), asserta(board(Board5)). 

push([A,B,C,D]):- board(Board),enemy([A,B,C,D],[W,X,Y,Z]), is_stronger([A,B,C,D],[W,X,Y,Z]), H is W-1, board_limit(H), is_free([H,X,Y,Z]), I is A-1, board_limit(I), supprimer([A,B,C,D],Board,Board2), concat([[I,B,C,D]],Board2,Board3),supprimer([W,X,Y,Z],Board3,Board4), concat([[H,X,Y,Z]],Board4,Board5), retractall(board(_)), asserta(board(Board5)). 

push([A,B,C,D]):- board(Board),enemy([A,B,C,D],[W,X,Y,Z]), is_stronger([A,B,C,D],[W,X,Y,Z]), H is X+1, board_limit(H), is_free([H,X,Y,Z]), I is B+1, board_limit(I), supprimer([A,B,C,D],Board,Board2), concat([[I,B,C,D]],Board2,Board3),supprimer([W,X,Y,Z],Board3,Board4), concat([[H,X,Y,Z]],Board4,Board5), retractall(board(_)), asserta(board(Board5)). 

push([A,B,C,D]):- board(Board),enemy([A,B,C,D],[W,X,Y,Z]), is_stronger([A,B,C,D],[W,X,Y,Z]), H is X-1, board_limit(H), is_free([H,X,Y,Z]), I is B-1, board_limit(I), supprimer([A,B,C,D],Board,Board2), concat([[I,B,C,D]],Board2,Board3),supprimer([W,X,Y,Z],Board3,Board4), concat([[H,X,Y,Z]],Board4,Board5), retractall(board(_)), asserta(board(Board5)). 

reculer([A,B,C,D], [X,B,_,_]):- X is A-1, board_limit(X), is_free([X,B,C,D]).
reculer([A,B,C,D], [X,B,_,_]):- X is A+1, board_limit(X), is_free([X,B,C,D]).
reculer([A,B,C,D], [A,X,_,_]):- X is B+1, board_limit(X), is_free([A,X,C,D]).
reculer([A,B,C,D], [A,X,_,_]):- X is B-1, board_limit(X), is_free([A,X,C,D]).

pull([A,B,C,D]):- board(Board),enemy([A,B,C,D],[W,X,Y,Z]), is_stronger([A,B,C,D],[W,X,Y,Z]), reculer([A,B,C,D],[M,N,_,_]), supprimer([W,X,Y,Z],Board,Board2), concat([[A,B,Y,Z]],Board2,Board3), supprimer([A,B,C,D],Board3,Board4), concat([M,N,C,D],Board4,Board5), retractall(board(_)), asserta(board(Board5)).
% vérifier que l'on est bien dans les limites du plateau de jeu pour faire un mouvement

% deplacer une piece d'une case

change_board(OldPosition, NewPosition):-board(Board), supprimer(OldPosition,Board,Board2), concat(NewPosition,Board2,Board3),retractall(board(_)), asserta(board(Board3)).

move_up([A,B,C,D]):- X is B+1, board_limit(X), is_free([A,X,C,D]), \+ trap([A,X,C,D]), \+ is_frozen([A,X,C,D]), change_board([A,B,C,D],[A,X,C,D]).
move_right([A,B,C,D]):- X is B+1, board_limit(X), is_free([X,B,C,D]), \+ trap([X,B,C,D]), \+ is_frozen([X,B,C,D]), change_board([A,B,C,D],[X,B,C,D]).
move_left([A,B,C,D]):- X is B-1, board_limit(X), is_free([X,B,C,D]), \+ trap([X,B,C,D]), \+ is_frozen([X,B,C,D]), change_board([A,B,C,D],[X,B,C,D]).
move_down([A,B,C,D]):- X is B-1, board_limit(X), is_free([A,X,C,D]), \+ trap([A,X,C,D]), \+ is_frozen([A,X,C,D]), change_board([A,B,C,D],[A,X,C,D]).

% move chercher un mouvement unitaire (le meilleur) pour une pièce donnée. 
% En priorité on cherche à avancer vers l'autre côté de l'échiquier, sinon à gêner l'adversaire en perturbant ses mouvements
% si notre IA commence en bas du plateau, move_up en premier, sinon move_down en premier

move([A,B,C,D]):- move_up([A,B,C,D]).  
move([A,B,C,D]):- push([A,B,C,D]).
move([A,B,C,D]):- pull([A,B,C,D]).
move([A,B,C,D]):- move_right([A,B,C,D]).
move([A,B,C,D]):- move_left([A,B,C,D]).
move([A,B,C,D]):- move_down([A,B,C,D]).


is_rabbit([A,B,C,D]):- C==rabbit.

first_rabbit([T|Q],T):- is_rabbit(T).
first_rabbit([T|Q],X):-first_rabbit(Q). 

% fonction qui récupère un rabbit dans le board (le premier dans la liste Board):

get_rabbit(Rabbit):-board(Board),first_rabbit(Board,Rabbit).

% ça ne marche plus a partir de la, on veut faire une fonction qui recupere la liste de tous les lapins de l'IA sur le board :

get_rabbits(RabbitList,[T|Q]):-board([T|Q]), get_rabbit(Rabbit),concat([Rabbit],List, RabbitList),\+ Q=[], get_rabbits(List,Q).


%->Objectif : chercher les rabbits dispo (ceux les plus avancés sur le plateau en priorité), et les avancer vers la ligne adversaire le plus vite possible pour gagner
%donc écrire un fonction qui parmi la liste des lapins, choisi 4 mouvements unitaires à faire effectuer aux lapins les plus avancés sur le board.

%Si plus de rabbits allies (ils ont tous été capturés) alors bouger les autres pièces de façon à gener les mouvements adverses

%get_moves(Moves, Gamestate, Board):-