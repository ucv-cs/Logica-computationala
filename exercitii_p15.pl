/** 1. Definiti un predicat care sa calculeze suma primelor n
 * numere naturale nenule.
 **/
sum_n(N, Result) :- N == 1 -> Result is 1;
  N > 0,
  N1 is N-1,
  sum_n(N1, R1),
  Result is N + R1.

/** 2. Scrieti un predicat care sa calculeze pentru un n dat
 * valoarea elementului xn din sirul:
 * xn = 1 + 1/2 + 1/3 + ... + 1/n
 **/
s_inv_n(N, Result) :- N == 1 -> Result is 1;
  N > 0,
  N1 is N-1,
  s_inv_n(N1, R1),
  Result is 1/N + R1.

/** 3. Urmatorul predicat calculeaza valorile functiei lui Ackerman:
 * ac : N x N -> N, ac(m, n) =
 *      n+1, daca m=0,
 *      ac(m-1, 1), daca n=0,
 *      ac(m-1, ac(m, n-1)), altfel.
 * Scrieti un predicat care sa calculeze valoarea acestei functii
 * intr-un anumit punct.
 **/
ac(0, N, Result) :- Result is N+1, !. % cut ! face ca rezultatul sa se afiseze imediat dupa comanda,
ac(M, 0, Result) :- M > 0, M1 is M-1, ac(M1, 1, Result), !. %   fara a mai astepta vreun input
ac(M, N, Result) :- M > 0, N > 0,
  M1 is M-1, N1 is N-1,
  ac(M, N1, Temp),
  ac(M1, Temp, Result).

/** 4. Scrieti un predicat Prolog care sa calculeze cel mai mare divizor
 * comun dintre doua numere.
 **/
cmmdc(M, 0, M).% :- !.
cmmdc(0, M, M).% :- !.
cmmdc(M, N, Result) :- Rest is (M mod N),
  cmmdc(N, Rest, Result).

/** 5. Definiti un predicat Prolog care sa calculeze valoarea functiei
 * lui Fibonacci intr-un punct.
 * f(1) = f(2) = 1; f(n) = f(n-2) + f(n-1) pentru n >= 3
 **/
fib(1, 1) :- !. % idem supra
fib(2, 1) :- !.
fib(N, Result) :- N >= 3,
  N1 is N-1, N2 is N-2,
  fib(N1, R1), fib(N2, R2),
  Result is R1+R2.

/** 6. Scrieti un predicat Prolog care sa calculeze n^m, unde m si n sunt
 * numere naturale.
 **/
nm(N, 0, 1) :- N > 0, !. % idem supra
nm(0, N, 0) :- N > 0, !.
nm(N, M, Result) :- N > 0, M >= 0,
  M1 is M-1,
  nm(N, M1, T),
  Result is N * T.

/** 7. Sa se verifice daca un numar k este divizor al unui numar n.
 * Construiti apoi un predicat Prolog care sa afiseze toti divizorii unui
 * numar natural n. (Nota: foloseste predicatul predefinit mod)
 **/
is_divisor(X, Number) :- X > 0, 0 is Number mod X -> write(X), tab(2).
divisors(Number, Result) :- between(1, Number, Result), is_divisor(Result, Number), fail.