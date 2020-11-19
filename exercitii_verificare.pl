/**
 * 1. Rezolvarea ecuatiei de gradul 2.
 **/
delta(A, B, C, D) :- D is (B*B - 4*A*C).
solve_eq2(A, B, C, X1) :- A \= 0, delta(A, B, C, D), D >= 0,
  X1 is ((-B + sqrt(D))/2*A).
solve_eq2(A, B, C, X2) :- A \= 0, delta(A, B, C, D), D >= 0,
  X2 is ((-B - sqrt(D))/2*A).
solve_eq2(A, _, _, _) :- A == 0,
  writeln("Daca A = 0, ecuatia nu este de gradul 2."), !.
solve_eq2(A, B, C, _) :- delta(A, B, C, D), D =< 0,
  format("Ecuatia ~gx^2 + ~gx + ~g = 0 nu are solutii in R.", [A, B, C]), !.

/**
 * 2. Scrieti un predicat Prolog care sa calculeze pentru n dat, valoarea
 * elementului xn din sirul: xn = 1 + 1/2 + 1/3 + ... + 1/n.
 **/
sum_series(1, 1) :- !.
sum_series(N, R) :- N > 1, N1 is N-1,
  sum_series(N1, R1),
  R is (R1 + 1/N).

/**
 * 3. Scrieti un predicat Prolog care calculeaza valorile functiei lui
 * Ackermann:
 *   ac : NxN -> N, ac(m, n) =
 *      n+1, daca m=0,
 *      ac(m-1, 1), daca n=0,
 *      ac(m-1, ac(m, n-1)), altfel.
 **/
ac(0, N, R) :- R is N+1, !.
ac(M, 0, R) :- M > 0, M1 is M-1,
  ac(M1, 1, R), !.
ac(M, N, R) :- M > 0, N > 0, N1 is N-1, M1 is M-1,
  ac(M, N1, R1),
  ac(M1, R1, R), !.

/**
 * 4. Definiti un predicat Prolog care sa calculeze valoarea functiei lui
 * Fibonacci intr-un punct:
 * f(1) = f(2) = 1; f(n) = f(n-2) + f(n-1) pentru n>=3.
 **/
fib(1, 1) :- !.
fib(2, 1) :- !.
fib(N, R) :- N > 2, N2 is N-2, N1 is N-1,
  fib(N2, R2),
  fib(N1, R1),
  R is R2+R1.

/**
 * 5. Scrieti un predicat prolog care sa calculeze valoarea functiei f in
 * punctele m si n, unde f este definita astfel:
 * f: N x N -> N, f(m, n) =
 *                          n^m, daca n < m
 *                          m*n, altfel.
 **/
f5(M, N, R) :- N < M, R is N**M, !.
f5(M, N, R) :- N >= M, R is M*N, !.

/**
 * 6. Sa se verifice daca un numar k este divizor al unui numar n.
 * Construiti apoi un predicat Prolog care sa afiseze toti divizorii
 * unui numar natural n.
 **/
%var. 1
is_div(K, N) :- K \= 0, 0 is mod(N, K), write(K), tab(2).
divs(N) :- N >= 0, between(1, N, R), is_div(R, N), fail.
%var. 2 - incompleta
divs2(N) :- format("Divizorii lui ~w sunt: ", [N]), divn(N, 2).
divn(_, 1).
divn(N, D) :- N1 is N / 2, N1<D.
divn(N, D) :- is_div(D, N), fail.
divn(N, D) :- D1 is D+1, divn(N, D1).

/**
 * 7. Scrieti un predicat prolog care sa calculeze valoarea functiei f in
 * punctele m si n, unde f este definita astfel:
 * f: N x N -> N, f(m, n) =
 *                          m * (n!), daca n < m
 *                          n - m, altfel.
 **/
factorial(0, 1) :- !.
factorial(1, 1) :- !.
factorial(N, R) :- N >= 2, N1 is N-1,
  factorial(N1, R1),
  R is N*R1.
f7(M, N, R) :- N < M, factorial(N, F), R is M * F, !.
f7(M, N, R) :- N >= M, R is N - M, !.

/**
 * 8. Definiti un predicat Prolog care sa calculeze media numerelor
 * unei liste.
 **/
count_list([], 0).
count_list([_|T], R) :- count_list(T, R1), R is R1+1.
sum_list([], 0).
sum_list([H|T], R) :- sum_list(T, R1), R is H+R1.
avg_list(X, R) :- sum_list(X, S), count_list(X, C), C \= 0, R is S/C.

/**
 * 9. Scrieti un predicat care sa determine cate numere pozitive se gasesc
 * intr-o lista data.
 **/
count_pos([], 0).
count_pos([H|T], R) :- H > 0, count_pos(T, R1), R is R1+1, !.
count_pos([H|T], R) :- H =< 0, count_pos(T, R).

/**
 * 10. Calculati suma patratelor elementelor unei liste.
 **/
sum_sq([], 0).
sum_sq([H|T], R) :- sum_sq(T, R1), R is H**2 + R1.

/**
 * 11. Determinati cu ajutorul unui predicat Prolog maximul unei liste.
 **/
max_list([H|T], R) :- max_list(T, R1),
  R1 > H -> R is R1;
  R is H.

/**
 * 12. Realizati un predicat prolog care sa determine pozitia pe care se
 * gaseste minimul unei liste.
 **/
min_list([H|T], R) :- min_list(T, R1),
  R1 < H -> R is R1;
  R is H.
pos(E, [E|_], 0) :- !.
pos(E, [_|T], R) :- pos(E, T, R1), R is R1+1.
pos_min(L, R) :- min_list(L, M), pos(M, L, R).

/**
 * 13. Sa se compare lungimile a doua liste date.
 **/
%var. 1
len_list([], 0) :- !.
len_list([_], 1) :- !.
len_list([_|T], R) :- len_list(T, R1), R is R1+1.
cmp_lists(A, B) :- len_list(A, LA), len_list(B, LB),
  (LA > LB -> format("Lista ~w este mai lunga decat lista ~w.", [A, B]);
  LA == LB -> format("Listele ~w si ~w au lungimi egale.", [A, B]);
  LA < LB -> format("Lista ~w este mai lunga decat lista ~w.", [B, A])).
%var. 2
cmp_lists2([], []) :- writeln("Listele au lungimi egale.").
cmp_lists2(_, []) :- writeln("Prima lista este mai lunga.").
cmp_lists2([], _) :- writeln("A doua lista este mai lunga.").
cmp_lists2([_|T1], [_|T2]) :- cmp_lists2(T1, T2), !.

/**
 * 14. Sa se inverseze o lista.
 **/
%var. 1
inv_list([], []) :- !.
inv_list([H|T], R) :- inv_list(T, R1), append(R1, [H], R).
%var. 2
inv_list2(X, Y) :- inv(X, [], Y).
inv([], X, X).
inv([H|X], Y, Z) :- inv(X, [H|Y], Z).

/**
 * 15. Sa se stearga toate aparitiile unui element dintr-o lista.
 **/
del_elem(_, [], []) :- !.
del_elem(E, [E|T], R) :- del_elem(E, T, R), !.
del_elem(E, [H|T], [H|T1]) :- del_elem(E, T, T1), !.

/**
 * 16. Determinati sublista care sa contina numai pozitiile 2, 4, 6...
 * din lista initiala.
 **/
%var. 1
even_pos([X], [X], []).
even_pos([X,Y], [X], [Y]).
even_pos([X,Y|T], I, P) :- even_pos(T, I1, P1), I = [X|I1], P = [Y|P1].
%var. 2
even_pos2([_], []) :- !.
even_pos2([_, Y], [Y]) :- !.
even_pos2([_, Y|T], R) :- even_pos2(T, R1), R = [Y|R1], !.
%var. 2 - odds
odd_pos([X], [X]) :- !.
odd_pos([X, _], [X]) :- !.
odd_pos([X, _|T], R) :- odd_pos(T, R1), R = [X|R1], !.

/**
 * 17. Definiti doua predicate Prolog care sa testeze daca o lista este
 * prefix al unei alte liste, respectiv sufix al unei liste date.
 **/
is_prefix([], _).
is_prefix([P|R1], [P|R2]) :- is_prefix(R1, R2).
is_sufix(X, X).
is_sufix(X, [_|S]) :- is_sufix(X, S).

/**
 * 18. Scrieti un predicat Prolog care sa verifice daca doua elemente sunt
 * consecutive intr-o lista.
 **/
cons(A, B, [A|B]) :- !.
cons(A, B, [A|[B|_]]) :- !.
cons(A, B, [_|T]) :- cons(A, B, T), !.
cons_m(A, B, L) :- cons(A, B, L) ->
  format("Elementele ~w si ~w sunt consecutive in lista ~w.", [A, B, L]);
  format("Elementele ~w si ~w nu sunt consecutive in lista ~w.", [A, B, L]).

/**
 * 19. Verificati daca elementele unei liste pot forma o multime.
 **/
%multimea nu are duplicate
is_member(E, [E|_]).
is_member(E, [_|T]) :- is_member(E, T).
is_set([]).
is_set([_]).
is_set([H|T]) :- not(is_member(H, T)), is_set(T), !.
is_set_m(L) :- is_set(L) ->
  format("Elementele listei ~w pot forma o multime.", [L]);
  format("Elementele listei ~w nu pot forma o multime.", [L]).

/**
 * 20. Scrieti un predicat Prolog care sa realizeze eliminarea duplicatelor
 * dintr-o lista data.
 **/
%is_member este definit la ex. 19.
del_dup([], []).
del_dup([H|T], R) :- is_member(H, T), del_dup(T, R), !.
del_dup([H|T1], [H|T2]) :- del_dup(T1, T2), !.

/**
 * 21. Dandu-se doua liste, sa se determine daca prima este sublista celei
 * de-a doua.
 **/
%is_prefix si is_sufix sunt definite la ex. 17.
is_sublist(L1, L2) :- is_prefix(X, L2), is_sufix(L1, X).

/**
 * 22. Scrieti un program pentru calcularea produsului scalar a doi vectori.
 **/
 %vectorii trebuie sa aiba aceeasi lungime
prod([], [], []).
prod([H1|T1], [H2|T2], R) :- number(H1), number(H2),
  prod(T1, T2, R1),
  H is H1*H2,
  R = [H|R1].

/**
 * 23. Sa se realizeze interclasarea elementelor a doua liste ordonate
 * crescator.
 **/
intercl(X, [], X).
intercl([], X, X).
intercl([H1|T1], [H2|T2], [H1|Tr]) :- H1 < H2, intercl(T1, [H2|T2], Tr).
intercl([H1|T1], [H1|T2], [H1|Tr]) :- intercl(T1, T2, Tr).
intercl(T1, [H2|T2], [H2|Tr]) :- intercl(T1, T2, Tr).

/**
 * 24. Avand o lista de numere intregi, sa se imparta aceasta in doua liste:
 * una care contine numerele pare si una care le contine pe cele impare.
 **/
is_even(X) :- 0 is X mod 2.
even_ints([], [], []).
even_ints([H|T], I, P) :- even_ints(T, I1, P1),
  (is_even(H) -> (P = [H|P1], I = I1);
                 (P = P1, I = [H|I1])).

/**
 * 25. Sa se adauge un element la sfarsitul unei liste.
 **/
add_end(E, [], [E]).
add_end(E, [H|T], [H|R]) :- add_end(E, T, R), !.

/**
 * 26. Dandu-se o lista si un numar intreg pozitiv i, sa se gaseasca elementul
 * aflat pe pozitia i in lista.
 **/
at_index([E|_], 1, E) :- !.
at_index([_|T], I, E) :- I1 is I-1, at_index(T, I1, E), !.

/**
 * 27. Avand date o lista si un element care apartine acestei liste, sa se
 * specifice pe ce pozitie este situat elementul in lista data.
 **/
index_of(E, [E|_], 1) :- !.
index_of(E, [_|T], I) :- index_of(E, T, I1), I is I1+1, !.

/**
 * 28. Se da o lista: sa se obtina doua liste din aceasta astfel incat prima din
 * ele sa contina elementele de pe pozitiile pare, iar a doua pe cele de pe
 * pozitiile impare.
 **/
split_list_pos([X], [], [X]) :- !.
split_list_pos([X,Y], [Y], [X]) :- !.
split_list_pos([X,Y|T], P, I) :- split_list_pos(T, P1, I1), I = [X|I1], P = [Y|P1], !.