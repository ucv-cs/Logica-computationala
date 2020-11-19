/**
 * Rezolvarea exercitiului de la pag. 8.
 **/

camera(birou, masa).
camera(birou, computer).
camera(hol, cuier).
camera(sufragerie, televizor).
camera(sufragerie, biblioteca).
camera(bucatarie, aragaz).
camera(bucatarie, frigider).
camera(bucatarie, biscuiti).
camera(bucatarie, mere).
camera(subsol, "masina de spalat").
camera(subsol, "rufe murdare").

usa(birou, hol).
usa(birou, bucatarie).
usa(hol, sufragerie).
usa(hol, intrare).
usa(sufragerie, bucatarie).
usa(bucatarie, subsol).

obiecte(Camera) :- camera(Camera, Obiect), format("\t- ~w;\n", Obiect), fail.

camere_vecine(Camera) :- (usa(Camera, Camera_vecina); usa(Camera_vecina, Camera)),
        format("\t- ~w;\n", Camera_vecina), fail.

descrie(Camera) :- format("\n--------------\nEsti in ~w.", Camera),
        writeln("\nPoti vedea:"),
        obiecte(Camera);
        writeln("\nPoti merge in:"),
        camere_vecine(Camera).

viziteaza :- camera(Camera, _), descrie(Camera), fail.