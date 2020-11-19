% 1. Definiti un predicat care sa adauge o unitate la un numar dat.
add_1(X, Result) :- Result is X+1. %sau succ() pentru numere naturale

% 2. Maximul a doua numere.
max(X, Y, Result) :-
  X < Y -> Result is Y; Result is X. %if then else...

% 3. Maximul a trei numere.
max(X, Y, Z, Result) :-
  X > Y, X > Z -> Result is X; %if then else...
  Y > X, Y > Z -> Result is Y;
  Z > Y, Z > X -> Result is Z;
  X == Y, X == Z -> Result is X.

% 4. Valoarea absoluta a unui numar.
abs(X, Result) :- X < 0 -> Result is -X; Result is X. %sau: Result is abs(X).

% 5. Functia f(x) care este x-1 daca x>0 si 0 altfel.
f(X, Result) :- number(X), X > 0 -> Result is X-1; Result is 0.