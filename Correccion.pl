%pareja(Persona, Persona)
pareja(marsellus, mia).
pareja(pumkin,honeyBunny).
pareja(bernardo,bianca).
pareja(bernardo,charo).

%trabajaPara(Empleador, Empleado)
trabajaPara(marsellus, vincent).
trabajaPara(marsellus, jules).
trabajaPara(marsellus, winston).
%Punto 3 nuevos trabajadores
trabajaPara(Quien,george):-
	saleCon(Quien,bernardo).
trabajaPara(Quien,bernardo):-
	trabajaPara(marsellus,Quien), Quien\=jules.

%Punto 1 salen juntos
saleCon(Quien,Cual):-
	pareja(Quien,Cual).
saleCon(Quien,Cual):-
	pareja(Cual,Quien).

%Punto 4 fidelidad
esInfiel(Personaje):-
	pareja(Personaje,Persona),
	pareja(Personaje,OtraPersona),
	Persona \= OtraPersona.
esFiel(Personaje):-
	saleCon(Personaje,_),
	not(esInfiel(Personaje)).

%Punto 5 acatar ordenes
acataOrden(Empleador,Empleado):- %caso base
	trabajaPara(Empleador,Empleado).
acataOrden(Empleador,Empleado):- %caso recursivo
	trabajaPara(Empleador,OtroEmpleado),
	acataOrden(OtroEmpleado,Empleado).

%PARTE 2
% Información base
% personaje(Nombre, Ocupacion)
personaje(pumkin,     ladron([estacionesDeServicio, licorerias])).
personaje(honeyBunny, ladron([licorerias, estacionesDeServicio])).
personaje(vincent,    mafioso(maton)).
personaje(jules,      mafioso(maton)).
personaje(marsellus,  mafioso(capo)).
personaje(winston,    mafioso(resuelveProblemas)).
personaje(mia,        actriz([foxForceFive])).
personaje(butch,      boxeador).
personaje(bernardo,   mafioso(cerebro)).
personaje(bianca,     actriz([elPadrino1])).
personaje(elVendedor, vender([humo, iphone])).
personaje(jimmie,     vender([auto])).

% encargo(Solicitante, Encargado, Tarea). 
% las tareas pueden ser cuidar(Protegido), ayudar(Ayudado), buscar(Buscado, Lugar)
encargo(marsellus, vincent,   cuidar(mia)).
encargo(vincent,  elVendedor, cuidar(mia)).
encargo(marsellus, winston, ayudar(jules)).
encargo(marsellus, winston, ayudar(vincent)).
encargo(marsellus, vincent, buscar(butch, losAngeles)).
encargo(bernardo, vincent, buscar(jules, fuerteApache)).
encargo(bernardo, winston, buscar(jules, sanMartin)).
encargo(bernardo, winston, buscar(jules, lugano)).

amigo(vincent, jules).
amigo(jules, jimmie).
amigo(vincent, elVendedor).


%PUNTO 1 Personajes peligrosos

actividadPeligrosa(mafioso(maton)).
actividadPeligrosa(ladron(Lista)):-
	member(licorerias,Lista).

esPeligroso(Personaje):-
	personaje(Personaje,Ocupacion),
	actividadPeligrosa(Ocupacion).
esPeligroso(Personaje):-
	trabajaPara(Empleador,Personaje),
	esPeligroso(Empleador).

%Punto 2 san cayetano
tieneCerca(Personaje,PersonajeCercano):-
	amigo(Personaje,PersonajeCercano).
tieneCerca(Personaje,PersonajeCercano):-
	trabajaPara(Personaje,PersonajeCercano).
tieneCerca(Personaje,PersonajeCercano):-
	trabajaPara(PersonajeCercano,Personaje).

sanCayetano(Quien):-
	tieneCerca(Quien,_),
	forall(tieneCerca(Quien,PersonajeCercano),encargo(Quien,PersonajeCercano,_)).

%Punto 3 Nivel de respeto

respect(actriz(Lista),NivelDeRespeto):-
	length(Lista,Largo),
	NivelDeRespeto is Largo/10.
respect(mafioso(capo),20).
respect(mafioso(resuelveProblemas),10).


nivelRespeto(Personaje,NivelDeRespeto):-
	personaje(Personaje,Ocupacion),
	respect(Ocupacion,NivelDeRespeto).
nivelRespeto(vincent,15).

%Punto 4 Personajes respetables
cantidadDeGente(Cantidad):-
	findall(_,personaje(_,_),Lista),
	length(Lista,Cantidad).

respetabilidad(Respetables,NoRespetables):-
	findall(Personaje,esRespetable(Personaje),ListaRespetable),
	length(ListaRespetable,Respetables),
	cantidadDeGente(Cantidad),
	NoRespetables is Cantidad-Respetables.

esRespetable(Personaje) :-
	nivelRespeto(Personaje,Nivel),
	Nivel>9.

%Punto 5 mas atareado
cantidadEncargos(Personaje,CantidadEncargos):-
	personaje(Personaje,_),
	findall(Encargo,encargo(_,Personaje,Encargo),Encargos),
	length(Encargos,CantidadEncargos).

masAtareado(Personaje):-
	cantidadEncargos(Personaje,CantidadEncargos),
	forall(nivelDeRespetoDeOtroPersonaje(Personaje, _, CantidadDeEncargos2),CantidadEncargos > CantidadEncargos2).

nivelDeRespetoDeOtroPersonaje(Personaje, OtraPersona, CantidadDeEncargos) :-
	personaje(OtraPersona,_),
	cantidadEncargos(OtraPersona,CantidadDeEncargos),
	Personaje\=OtraPersona.

