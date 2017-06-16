
:- dynamic board/1.

board([[0,0,rabbit,silver],[0,1,rabbit,silver],[0,2,horse,silver],[0,3,rabbit,silver],[0,4,elephant,silver],[0,5,rabbit,silver],[0,6,rabbit,silver],[0,7,rabbit,silver],[1,0,camel,silver],[1,1,cat,silver],[1,2,rabbit,silver],[1,3,dog,silver],[1,4,rabbit,silver],[4,5,horse,silver],[4,6,dog,gold],
[1,7,cat,silver],[2,7,rabbit,gold],[6,1,horse,gold],[6,2,camel,silver],[6,3,elephant,gold],[6,4,rabbit,gold],[6,5,dog,gold],[6,6,rabbit,gold],[7,0,rabbit,gold],[7,1,rabbit,gold],[7,2,rabbit,gold],[7,3,cat,gold],[7,4,dog,gold],[7,5,rabbit,gold],[7,6,horse,gold],[7,7,rabbit,gold]]).


%%% Fonction g�n�rale :

% Retourne le maximum et son index (� partir de z�ro !)dans une liste 
max_list(L, M, I) :- nth0(I, L, M), \+ (member(E, L), E > M).

% predicats pour la comparaison de la force des pieces

strength([_,_,elephant,_],6).
strength([_,_,camel,_],5).
strength([_,_,horse,_],4).
strength([_,_,dog,_],3).
strength([_,_,cat,_],2).
strength([_,_,rabbit,_],1).

is_stronger(Piece1,Piece2):- strength(Piece1,X),strength(Piece2,Y), X>Y.

% predicat de capture d'une piece

is_silver([_,_,_,silver]).
is_gold([_,_,_,gold]).

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
% push doit chercher s'il existe une pi�ce adverse que l'on peut repousser

push([A,B,C,D]):- board(Board), enemy([A,B,C,D],[W,X,Y,Z]), is_stronger([A,B,C,D],[W,X,Y,Z]), H is W+1, board_limit(H), is_free([H,X,Y,Z]), I is A+1, board_limit(I), supprimer([A,B,C,D],Board,Board2), concat([[I,B,C,D]],Board2,Board3),supprimer([W,X,Y,Z],Board3,Board4), concat([[H,X,Y,Z]],Board4,Board5), retractall(board(_)), asserta(board(Board5)). 

push([A,B,C,D]):- board(Board),enemy([A,B,C,D],[W,X,Y,Z]), is_stronger([A,B,C,D],[W,X,Y,Z]), H is W-1, board_limit(H), is_free([H,X,Y,Z]), I is A-1, board_limit(I), supprimer([A,B,C,D],Board,Board2), concat([[I,B,C,D]],Board2,Board3),supprimer([W,X,Y,Z],Board3,Board4), concat([[H,X,Y,Z]],Board4,Board5), retractall(board(_)), asserta(board(Board5)). 

push([A,B,C,D]):- board(Board),enemy([A,B,C,D],[W,X,Y,Z]), is_stronger([A,B,C,D],[W,X,Y,Z]), H is X+1, board_limit(H), is_free([H,X,Y,Z]), I is B+1, board_limit(I), supprimer([A,B,C,D],Board,Board2), concat([[I,B,C,D]],Board2,Board3),supprimer([W,X,Y,Z],Board3,Board4), concat([[H,X,Y,Z]],Board4,Board5), retractall(board(_)), asserta(board(Board5)). 

push([A,B,C,D]):- board(Board),enemy([A,B,C,D],[W,X,Y,Z]), is_stronger([A,B,C,D],[W,X,Y,Z]), H is X-1, board_limit(H), is_free([H,X,Y,Z]), I is B-1, board_limit(I), supprimer([A,B,C,D],Board,Board2), concat([[I,B,C,D]],Board2,Board3),supprimer([W,X,Y,Z],Board3,Board4), concat([[H,X,Y,Z]],Board4,Board5), retractall(board(_)), asserta(board(Board5)). 

reculer([A,B,C,D], [X,B,_,_]):- X is A-1, board_limit(X), is_free([X,B,C,D]).
reculer([A,B,C,D], [X,B,_,_]):- X is A+1, board_limit(X), is_free([X,B,C,D]).
reculer([A,B,C,D], [A,X,_,_]):- X is B+1, board_limit(X), is_free([A,X,C,D]).
reculer([A,B,C,D], [A,X,_,_]):- X is B-1, board_limit(X), is_free([A,X,C,D]).

pull([A,B,C,D]):- board(Board),enemy([A,B,C,D],[W,X,Y,Z]), is_stronger([A,B,C,D],[W,X,Y,Z]), reculer([A,B,C,D],[M,N,_,_]), supprimer([W,X,Y,Z],Board,Board2), concat([[A,B,Y,Z]],Board2,Board3), supprimer([A,B,C,D],Board3,Board4), concat([M,N,C,D],Board4,Board5), retractall(board(_)), asserta(board(Board5)).
% v�rifier que l'on est bien dans les limites du plateau de jeu pour faire un mouvement

% deplacer une piece d'une case

change_board(OldPosition, NewPosition):-board(Board), supprimer(OldPosition,Board,Board2), concat(NewPosition,Board2,Board3),retractall(board(_)), asserta(board(Board3)).

move_up([A,B,C,D]):- X is B+1, board_limit(X), is_free([A,X,C,D]), \+ trap([A,X,C,D]), \+ is_frozen([A,X,C,D]), change_board([A,B,C,D],[A,X,C,D]).
move_right([A,B,C,D]):- X is B+1, board_limit(X), is_free([X,B,C,D]), \+ trap([X,B,C,D]), \+ is_frozen([X,B,C,D]), change_board([A,B,C,D],[X,B,C,D]).
move_left([A,B,C,D]):- X is B-1, board_limit(X), is_free([X,B,C,D]), \+ trap([X,B,C,D]), \+ is_frozen([X,B,C,D]), change_board([A,B,C,D],[X,B,C,D]).
move_down([A,B,C,D]):- X is B-1, board_limit(X), is_free([A,X,C,D]), \+ trap([A,X,C,D]), \+ is_frozen([A,X,C,D]), change_board([A,B,C,D],[A,X,C,D]).

% move chercher un mouvement unitaire (le meilleur) pour une pi�ce donn�e. 
% En priorit� on cherche � avancer vers l'autre c�t� de l'�chiquier, sinon � g�ner l'adversaire en perturbant ses mouvements
% si notre IA commence en bas du plateau, move_up en premier, sinon move_down en premier

move([A,B,C,D]):- move_up([A,B,C,D]).  
move([A,B,C,D]):- push([A,B,C,D]).
move([A,B,C,D]):- pull([A,B,C,D]).
move([A,B,C,D]):- move_right([A,B,C,D]).
move([A,B,C,D]):- move_left([A,B,C,D]).
move([A,B,C,D]):- move_down([A,B,C,D]).


is_rabbit([A,B,C,D]):- C==rabbit.
% ou is_rabbit([_,_,rabbit,_]).

first_rabbit([T|Q],T):- is_rabbit(T).
first_rabbit([T|Q],X):-first_rabbit(Q). 

% fonction qui r�cup�re un rabbit dans le board (le premier dans la liste Board):

get_rabbit(Rabbit):-board(Board),first_rabbit(Board,Rabbit).

% �a ne marche plus a partir de la, on veut faire une fonction qui recupere la liste de tous les lapins de l'IA sur le board :

get_rabbits(RabbitList,[T|Q]):-board([T|Q]), get_rabbit(Rabbit),concat([Rabbit],List, RabbitList),\+ Q=[], get_rabbits(List,Q).

%->Objectif : chercher les rabbits dispo (ceux les plus avanc�s sur le plateau en priorit�), et les avancer vers la ligne adversaire le plus vite possible pour gagner
%donc �crire un fonction qui parmi la liste des lapins, choisi 4 mouvements unitaires � faire effectuer aux lapins les plus avanc�s sur le board.

%Si plus de rabbits allies (ils ont tous �t� captur�s) alors bouger les autres pi�ces de fa�on � gener les mouvements adverses

% R�cup�re la liste des lapins silver.
get_rabbits_silver([TRabbitList|QRabbitList],RabbitListSilver):-is_silver(TRabbitList), concat([TRabbitList,ListIntermediaire,RabbitListSilver]), 
get_rabbits_silver(QRabbitList,ListIntermediaire).

%renseigne quelle est la pi�ce la plus pr�s du camp gold (entre 2 pi�ces) : renvoie la position (en ordonn�e) de la pi�ce la plus proche
is_closer_to_gold_side([_,B,_,_],[_,Y,_,_],B):-B>Y.

% R�cup�re la position X absicsse
get_Xpos([X,_,_,_],X).
%R�cup�re la position Y ordonn�e
get_Ypos([_,Y,_,_],Y).

%R�cup�re les positions Y en ordonn�e de la liste des pi�ces en argument.
get_Ypos_list([], []).
get_Ypos_list([TList|QList], PosList):-get_Ypos(TList,Y),concat([Y],ListIntermediaire,PosList) get_Ypos_list(QList,ListIntermediaire).

%% R�cup�re le lapin le plus pr�s du camp gold : 
%1) R�cup�re la liste des positions Y des lapins.
% 2) Cherche le Y max et � quel lapin correspond cette valeur. 
% 3) Renvoie le lapin ayant la position max.
get_closest_rabbit_to_gold(RabbitList, Rabbit):-get_Ypos_list(RabbitList,PosList),max_list(PosList,Ymax,WhichRabbit),nth0(WhichRabbit,RabbitList,Rabbit).

% Fais avancer le lapin silver le plus pr�s du camp gold.
% 1) R�cup�re la liste des lapins
% 2) R�cup�re la liste des lapins silver
% 3) R�cup�re le lapin le plus proche du camp gold.
% 4) Fais avancer ce lapin.
move_closest_rabbit_silver(Rabbit):-board(Board) get_rabbits(RabbitList,Board),get_rabbits_silver(RabbitList,RabbitListSilver), 
get_closest_rabbit_to_gold(RabbitList,Rabbit),move(Rabbit).

% Bordure du camp gold
gold_border([0,7,_,_]). %bas gauche
gold_border([1,7,_,_]).
gold_border([2,7,_,_]).
gold_border([3,7,_,_]).
gold_border([4,7,_,_]).
gold_border([5,7,_,_]).
gold_border([6,7,_,_]).
gold_border([7,7,_,_]). %bas droite

% Bordure du camp silver
silver_border([0,0,_,_]). %haut gauche
silver_border([1,0,_,_]).
silver_border([2,0,_,_]).
silver_border([3,0,_,_]).
silver_border([4,0,_,_]).
silver_border([5,0,_,_]).
silver_border([6,0,_,_]).
silver_border([7,0,_,_]). %haut droite

% Enl�ve une pi�ce qui est pi�g�e du plateau
has_lost_piece(Piece):-capture(Piece),board(Board),supprimer(Piece, Board, NewBoard), retractall(board(_)), asserta(board(NewBoard)). 


% Vrai si un lapin silver a atteint le camp gold.
has_won_silver() :- board(Board), element2([_,7,rabbit,silver],Board).


%get_moves(Moves, Gamestate, Board):-