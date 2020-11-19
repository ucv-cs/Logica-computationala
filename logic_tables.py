"""Tema 1: Realizați un program pentru a calcula AND, OR, XOR pentru două șiruri date de biți."""
#condiții:
## 1. șirurile trebuie să conțină numai 0 sau 1
## 2. șirurile trebuie să aibă aceeași lungime
#folosim proprietatea limbajului de a atribui True lui (int) 1 și False lui 0


def logical_and(a, b):
	"""Realizează operația AND pentru două șiruri egale de biți și returnează șirul rezultat."""
	result = ""
	i = 0
	while i < len(a):
		result += str(int(a[i]) & int(b[i]))
		i += 1
	return result


def logical_or(a, b):
	"""Realizează operația OR pentru două șiruri egale de biți și returnează șirul rezultat."""
	result = ""
	i = 0
	while i < len(a):
		result += str(int(a[i]) | int(b[i]))
		i += 1
	return result


def logical_xor(a, b):
	"""Realizează operația XOR pentru două șiruri egale de biți și returnează șirul rezultat."""
	result = ""
	i = 0
	while i < len(a):
		result += str(int(a[i]) ^ int(b[i]))
		i += 1
	return result


def display_results(a, b):
	"""Afișează tabelul logic."""
	print("      a = " + a)
	print("      b = " + b)
	print("------------------")
	print("a AND b = " + logical_and(a, b))
	print("a OR  b = " + logical_or(a, b))
	print("a XOR b = " + logical_xor(a, b))
	input("\nApasă ENTER pentru a închide programul...")


def get_bits():
	"""Obține șirurile de biți de la tastatură. Validează inputul: șiruri de 0 sau 1 și șiruri egale."""
	result = ""
	while True:
		string = input().replace(" ", "") #vom tolera doar spațiile...
		if len(string
		      ) == 0: #repetă loop-ul dacă utilizatorul nu introduce niciun caracter
			print("Șir gol, trebuie să scrii caractere valide (1 sau 0)!")
			continue
		isValid = True
		for x in string: #fiecare caracter din input trebuie să fie ori 0 ori 1
			if (x not in {"0", "1"}):
				isValid = False
				break
		if not isValid:
			print("Scrie numai 0 sau 1!")
			continue
		else:
			result = string
			break
	return result


#aplicația
print(__doc__)
print("\nScrie două șiruri de biți (de aceeași lungime, fără separatori!):")
print("a: ")
a = get_bits()
print("b: ")
b = get_bits()
if len(b) != len(a): #verifică lungimea șirului, retrimite dacă len(a) != len(b)
	print(
	    "Lungimea acestui șir ({1}) trebuie să fie egală cu cea a primului șir ({0})!"
	    .format(len(a), len(b)))
	b = get_bits()
display_results(a, b)