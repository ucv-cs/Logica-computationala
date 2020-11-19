%1. Definiti un predicat Prolog care sa calculeze media numerelor unei liste.
count_list([], 0).
count_list([_|Tail], Count) :- count_list(Tail, Count1), Count is Count1 + 1.

sum_list([], 0).
sum_list([Head|Tail], Result) :- sum_list(Tail, Temp), Result is Head + Temp.

avg_list([], 0).
avg_list([Head|Tail], Result) :- sum_list([Head|Tail], Sum),
  count_list([Head|Tail], Count),
  Result is Sum / Count.

%2. Scrieti un predicat care sa calculeze suma tuturor numerelor pozitive ale unei liste.
sum_pos_list([], 0).
sum_pos_list([Head|Tail], Result) :- Head > 0 -> sum_pos_list(Tail, Temp), Result is Head + Temp;
  sum_pos_list(Tail, Temp), Result is Temp.

%3. Determinati cu ajutorul unui predicat Prolog maximul unei liste.
max_list([Head|Tail], Max) :- max_list(Tail, Temp),
  Temp > Head -> Max is Temp;
  Max is Head.

%4. Sa se inverseze o lista.
inv_list([], []).
inv_list([Head|Tail], Result) :- inv_list(Tail, Temp), append(Temp, [Head], Result).

%5. Sa se stearga toate aparitiile unui element dintr-o lista.

%%https://prologprogramslibrary.blogspot.com/2014/05/prolog-program-to-delete-all.html
% del_elem(_, [], []).
% del_elem(X, [_|Tail], Result) :- del_elem(X, Tail, Result).
% del_elem(X, [Head|Tail], [Head|Tail_1]) :- X =\= Head, del_elem(X, Tail, Tail_1).
%%http://alumni.cs.ucr.edu/~vladimir/cs181/prolog_4.pdf
del_elem(_, [ ], [ ]).
del_elem(X, [X|Tail], Result) :- !, del_elem(X, Tail, Result).
del_elem(X, [Head_1|Tail_1], [Head_1|Tail_2]) :- del_elem(X, Tail_1, Tail_2).

%6. Determinati sublista care sa contina numai pozitiile 2, 4, 6, ... din lista initiala.
%even_pos([], []).
%even_pos([_|[Elem|Tail]], Result) :- even_pos([Elem|Tail], Result), fail.%append([Elem], Result_1, Result),
even_pos([], 0, []).
even_pos([], 1, []).
even_pos([_|[Elem|_]], Counter, Result) :- even_pos(Elem, Counter_2, Result), Counter_2 is Counter+2.