%trabajaPara(Empleador, Empleado)
trabajaPara(marsellus, vincent).
trabajaPara(marsellus, jules).
trabajaPara(marsellus, winston).

%Punto 1 salen juntos
saleCon(Quien,Cual):-
	pareja(Quien,Cual).
saleCon(Quien,Cual):-
	pareja(Cual,Quien).
