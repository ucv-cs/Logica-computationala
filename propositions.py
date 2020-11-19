"""Să se realizeze un program care să spună despre o
propoziție complexă dată de utilizator dacă este:
- tautologie
- satisfiabilă
- contingentă
- nesatisfiabilă
"""
"""
specificație:

corespondență:
input	intern		output		 	 semnificație
~		  not		¬	'\u00ac'	= non
&		  and		∧	'\u2227'	= și alt. '\u039b' (lambda)
|		  or		∨	'\u2228'	= sau alt. 'V'
+		__add__		+ 	'+'			= sau exclusiv (overload de +) '\u2D32'
>		__gt__		→	'\u2192'	= implică (overload de >)
<		__lt__		↔ 	'\u2194'	= echivalent cu (overload de <) alt. ≡	'\u2261'

definiții:
- tautologie: toate interpretările sunt A
- satisfiabilă: există o interpretare A
- contingentă: există o interpretare A și una F
- nesatisfiabilă: toate interpretările sunt F
"""
import re
import itertools

fixed_chars = {
    '~': '\u00ac',
    '&': ' \u039b ', #'/\\', #'\u2227',
    '|': ' V ', #'\/', #'\u2228',
    '+': ' + ', #'\u2D32'
    '>': ' \u2192 ',
    '<': ' \u2194 ', #'\u2261',
    '(': '(',
    ')': ')'
}
initial_string = ""
simple_props = []


class Proposition():
	"""
	Reprezentarea unei propoziții și a operațiilor pe care le suportă.
	Toți operatorii necesari sunt overloadați pentru controlul outputului.
	"""

	#constructor
	def __init__(self, value=bool(), name=str()):
		self.value = True if value != False else False
		self.name = name

	#negația
	def __invert__(self):
		"""
		Operatorul pentru negație, prin overload
		'\u00ac' #simbolul ¬
		"""
		value = True if self.value == False else False
		name = f'\u00ac{self.name}'
		return Proposition(value, name)

	#conjuncția
	def __and__(self, other):
		"""
		Operatorul pentru conjuncție, prin overload
		'\u2227' #simbolul ∧
		"""
		value = True if self.value and other.value else False
		name = f'{self.name} \u2227 {other.name}'
		return Proposition(value, name)

	#disjuncția
	def __or__(self, other):
		"""
		Operatorul pentru disjuncție, prin overload
		'\u2228' #simbolul ∨
		"""
		value = True if self.value or other.value else False
		name = f'{self.name} \u2228 {other.name}'
		return Proposition(value, name)

	#disjuncția exclusivă
	def __add__(self, other):
		"""
		Operatorul pentru xor, prin overload
		'+', '^'
		"""
		value = False if self.value == other.value else True
		name = f'{self.name} + {other.name}'
		return Proposition(value, name)

	#implicația
	def __gt__(self, other):
		"""
		Operatorul pentru implicație, prin overload
		'\u2192' #simbolul →
		"""
		value = False if (self.value == True) and (other.value == False) else True
		name = f'{self.name} \u2192 {other.name}'
		return Proposition(value, name)

	#echivalența
	def __lt__(self, other):
		"""
		Operatorul pentru echivalență, prin overload
		'\u2194' #simbolul ↔ (alt. ≡)
		"""
		value = True if self.value == other.value else False
		name = f'{self.name} \u2194 {other.name}'
		return Proposition(value, name)


def extract_simple_props(string):
	"""
	Generează obiecte Proposition() din fiecare literă distinctă,
	cu același nume precum cel introdus de utilizator, le plasează
	în scopul global și le adaugă într-o listă globală sortată crescător
	 param string: textul din input
	 return: None
	"""
	#declară și inițializează o variabilă globală pentru propozițiile simple
	global simple_props
	simple_props = []

	letters = set(re.findall(r"([a-z])", string))
	letters = sorted(list(letters))

	for e in letters:
		if eval(f"'{e}' not in [prop.name for prop in simple_props]"):
			exec(
			    f"global {e}; {e} = Proposition(name = '{e}'); simple_props.append({e})"
			)


def extract_tokens(string):
	"""
	Generează un dicționar de tokenuri, în care sunt reprezentate
	grupurile din paranteze și pozițiile lor în string
	 param string: textul din input
	 return: [string, {tokenurile ordonate}]
	"""
	#tokenizează folosind un dicționar de tip {poziție: grup},
	# subgrupurile sunt simbolizate prin cheia din dicționar
	# * devin obiecte Proposition():
	#  - fiecare literă
	#  - fiecare grup de paranteze ()
	#  - fiecare grup de tip ~(alt token)

	tokens = dict()
	counter = 0 #indică poziția grupului în dicționar

	while True:
		groups = re.findall(r"(~?\([^()]*?\))", string)
		if groups:
			for i in range(len(groups)):
				tokens[counter] = groups[i]
				string = string.replace(groups[i], f'{counter}')
				counter += 1
		else:
			break

	return [string, tokens]


def decompress_tokens(string, tokens):
	"""
	Reface stringul utilizat pentru tokenizare, pornind de la outputul
	lui extract_tokens()
	"""
	while True:
		match = re.search(r'(\d+?)', string)
		if not match:
			return string
		else:
			i = match.group(1)
			string = string.replace(i, tokens[1][int(i)])


def get_table():
	"""
	Generează o listă cu elementele tabelei de adevăr. Utilizează
	variabilele globale simple_props și tokens
	 return: matrice (listă de liste)
	 rtype: list
	"""
	table_header = [prop.name for prop in simple_props] + \
   [decompress_tokens(tokens[1][tok], tokens) for tok in tokens[1]] + \
   [initial_string]
	table = [table_header]

	#generează o listă cu combinațiile valorilor de adevăr pentru propozițiile simple
	truth_combinations = list(
	    itertools.product([True, False], repeat=len(simple_props)))

	#iterează lista de combinații și evaluează propozițiile compuse
	for row_index in range(len(truth_combinations)):
		table.append(list(truth_combinations[row_index]))
		for ind in range(len(simple_props)):
			simple_props[ind].value = truth_combinations[row_index][ind]
		for ind in range(len(simple_props), len(table_header)):
			code = table_header[ind]
			table[row_index + 1].append(eval(f'({code}).value'))

	return table


def display_table(table):
	"""
	Afișează tabela de adevăr folosind caracterele speciale potrivite ex. ∧
	 param table: matrice (listă de liste)
	 return: tabelul ca text
	 rtype: string
	"""
	result = '\n\t'
	empty = ''
	column_width = []
	table.insert(1,
	             ['' for i in table[0]]) #adaugă un rând pentru linia de separare
	for i in range(len(table)):
		for j in range(len(table[i])):
			#separator între elemente și rânduri
			separator = '\n\t' if j == (len(table[i]) - 1) else '|'
			if i == 0: #cap de tabel
				header = operator_replacer(table[0][j])
				element = f'{header:^{len(header)+2}}'
				result += element + separator
				column_width.append(len(element))
			elif i == 1: #linia de separare
				result += f'{empty:-^{column_width[j]}}' + \
         ('\n\t' if j == (len(table[i])-1) else '+') #separator
			else: #conținutul tabelului
				value = 'A' if table[i][j] is True else 'F'
				result += f'{value:^{column_width[j]}}' + separator

	return result


def operator_replacer(string):
	"""
	Înlocuiește operatorii din input cu cei pentru display, folosind
	fixed_chars
	 param string: input
	 return: text modificat
	 rtype: string
	"""
	for key in fixed_chars.keys():
		string = string.replace(key, fixed_chars[key])

	return string


def get_proposition_type(table):
	"""
	Află ce fel de propoziție complexă este cea a cărei tabelă de adevăr
	este introdusă
	 param table: tabela de adevăr
	 return: text cu felul propoziției
	 rtype: string
	"""
	last_column = []
	j = len(table[1]) - 1
	for i in range(1, len(table)):
		last_column += [table[i][j]]

	result = ''
	if False not in last_column:
		result = 'validă (tautologie, deci și satisfiabilă)'
	elif True not in last_column:
		result = 'contradicție (nesatisfiabilă)'
	elif True in last_column:
		result = 'satisfiabilă' #nu va arăta acest rezultat niciodată... :)
		if False in last_column:
			result = 'contingentă (deci și satisfiabilă)'

	return result


def proposition_matcher(string):
	"""
	Validează inputul potrivit specificațiilor, creează variabile globale
	pentru fiecare propoziție simplă și returnează un obiect reprezentând
	tokenii din stringul valid
	 param string: textul din input
	 result: False sau obiect reprezentând tokenii din stringul valid
	 rtype: [string cu simboluri, dicționar cu tokeni]
	"""
	global fixed_chars
	global initial_string

	#elimină spațiile și memorează global forma simplă a inputului
	string = re.sub(r'\s', '', string.lower())
	if string == '':
		print("Inputul nu poate fi gol.")
		return False

	initial_string = string

	#teste pentru eliminarea rapidă a principalelor forme greșite:
	patterns = """
	(?:(\d)|			# 1 nu conține cifre
	([^a-z()~&|+<>])|	# 2 conține numai caractere acceptabile
	([a-z]{2,})|		# 3 nu conține litere adiacente
	(\([^(~a-z])|		# 4	un grup are la început doar: ( ~ sau a-z
	([^a-z)]\))|		# 5 un grup are la sfârșit doar: ) sau a-z
	([a-z)]~)|			# 6 ~ nu poate apărea între două propoziții sau la final
	([^)a-z][&|+<>]|	# 7 operatorii binari nu pot avea decât 2 termeni (propoziții)
		[&|+<>][^a-z(~]|
		^[&|+<>]|
		[&|+<>~]$)|
	([a-z][(]|[)][a-z]))# 8 parantezele nu pot fi lipite de litere astfel: a( sau )a
	"""
	regex = re.compile(patterns, re.X)
	matcher = regex.search(string)
	if matcher:
		message = str()
		if matcher.group(1):
			message = f"Inputul conține cifre (ex. {matcher.group(1)})!"
		elif matcher.group(2):
			message = f"Inputul conține caractere inacceptabile (ex. {matcher.group(2)})!"
		elif matcher.group(3):
			message = f"Fiecare propoziție simplă trebuie reprezentată printr-o singură literă! (ex. {matcher.group(3)})!"
		elif matcher.group(4):
			message = f"Un grup are la început doar: ( ~ sau o literă! (ex. {matcher.group(4)})!"
		elif matcher.group(5):
			message = f"Un grup are la sfârșit doar: ) sau o literă! (ex. {matcher.group(5)})!"
		elif matcher.group(6):
			message = f"Operatorul ~ nu poate apărea între două propoziții sau la final! (ex. {matcher.group(6)})!"
		elif matcher.group(7):
			message = f"Operatorii binari nu pot avea decât 2 termeni (propoziții)! (ex. {matcher.group(7)})!"
		elif matcher.group(8):
			message = f"Parantezele nu pot fi lipite de litere astfel: a( sau )a! (ex. {matcher.group(8)})!"
		print(message)
		return False

	tokens = extract_tokens(string)
	if re.search(r'[()]', tokens[0]):
		print("Inputul conține paranteze fără pereche!")
		return False
	extract_simple_props(string)

	return tokens


def validate_input(string):
	"""
	Verifică dacă inputul corespunde formatului acceptat conform funcției
	proposition_matcher
	 param string: text primit din input
	 return: obiectul rezultat din proposition_matcher
	 rtype: list
	"""
	while True:
		output = proposition_matcher(string)
		if output:
			return output
		else:
			string = input(
			    "Trebuie să scrii inputul în forma acceptată!\nMai încearcă: ")


#aplicația
print(__doc__) #afișează enunțul temei
example = """Forma acceptată a inputului îndeplinește următoarele condiții:
	- fiecare propoziție simplă este reprezentată printr-o singură literă
	- operatorii logici acceptați sunt:
		~ (¬ neagă, not)
		& (Λ și, and)
		| (V sau, or)
		+ (+ sau exclusiv, xor)
		> (→ implică, if)
		< (↔ echivalent, iff)
	- nu sunt acceptate alte caractere în afară de spații, litere,
		paranteze rotunde și operatorii enumerați (ex. nu cifre)
	- parantezele pot fi incluse în alte paranteze, dar e obligatoriu să
		fie împerecheate
"""
print(example)
while True:
	print("\nScrie o propoziție complexă: ")
	tokens = validate_input(input())
	table = get_table()
	print(display_table(table))
	print(f"\nPropoziția este {get_proposition_type(table)}.")