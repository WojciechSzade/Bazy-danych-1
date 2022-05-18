/*Z2, Wojciech Szade, Gr. 3, 319110*/

/*1. Pokaza� dane podstawowe osoby, w jakim mie�cie mieszka i w jakim to jest wojew�dztwie*/

SELECT OSOBY.imie, OSOBY.nazwisko, MIASTA.nazwa, WOJ.nazwa
from OSOBY, MIASTA, WOJ
where OSOBY.id_miasta=MIASTA.id_miasta and OSOBY.id_osoby=1 and WOJ.kod_woj=MIASTA.kod_woj

/*imie	nazwisko	nazwa	nazwa
adam	chili�ski	Mor�g	POMORSKIE*/

/* 2. Pokaza� wszystkie etaty gdzie STANOWISKO zaczyna si� na liter� M i ko�czy na X lub Y
(je�eli nie macie takowych to wybierzcie takie warunki - inn� liter� pocz�tkow� i inne 2 ko�cowe aby wybra�y si� takie M%I lub takie M%Y)
kt�re maj� pensje pomi�dzy 3000 a 5000 (te� mo�ecie zmieni� je�eli macie g�ownie inne zakresy)
mieszkaj�ce w mie�cie o kodzie X (prosz� wybra� dowolne)
(wystarcz� dane z tabel etaty, firmy, osoby , miasta)*/

CREATE TABLE FIRMAMIASTO
(
nazwa_skr nvarchar(10) not null CONSTRAINT PK_FIRMAM PRIMARY KEY
, id_miasta int not null
, nazwa nvarchar(50) not null
, kod_pocztowy nvarchar(6) not null
, ulica nvarchar(50) not null
, nazwa_miasta nvarchar(50) not null
)
INSERT INTO FIRMAMIASTO (nazwa_skr, id_miasta, nazwa, kod_pocztowy, ulica, nazwa_miasta)
SELECT nazwa_skr, FIRMY.id_miasta, FIRMY.nazwa, kod_pocztowy, ulica, MIASTA.nazwa
FROM FIRMY, MIASTA
WHERE FIRMY.id_miasta=MIASTA.id_miasta



SELECT convert(nvarchar(20)
	,LEFT(imie, 1)+N'.'+RIGHT(OSOBY.nazwisko, 17)) as "osoba", ETATY.stanowisko, ETATY.od, ETATY.do,ETATY.pensja, MIASTA.nazwa as "Miasto osoby", FIRMAMIASTO.nazwa as "Nazwa firmy", ETATY.id_firmy, FIRMAMIASTO.nazwa_miasta as "Miasto firmy"
from ETATY, OSOBY, MIASTA, FIRMAMIASTO
where OSOBY.id_osoby=ETATY.id_osoby and OSOBY.id_miasta=MIASTA.id_miasta and FIRMAMIASTO.nazwa_skr=ETATy.id_firmy and ETATY.stanowisko like N'R%' and (ETATY.stanowisko like N'%k' or ETATY.stanowisko like N'%a')
and ETATY.pensja>=200 and ETATY.pensja<=2000 and OSOBY.id_miasta=3

IF OBJECT_ID(N'FIRMAMIASTO') IS NOT NULL
	DROP TABLE FIRMAMIASTO
GO

/*(No column name)	stanowisko	od	do	pensja	Miasto osoby	Nazwa firmy	id_firmy	Miasto firmy
w.b�czkowski	Robotnik	2014-01-01 00:00:00.000	NULL	200	Gr�jec	FABRYKA CHLORU	FABR	Piaseczno
e.kusibab	Robotnik	1998-10-10 00:00:00.000	NULL	2000	Gr�jec	DESTYLARNIA	DEST	Gdynia*/

/*id_osoby	id_firmy	stanowisko	pensja	od	do	id_etatu
1	TORF	G�rnik	100	2002-01-01 00:00:00.000	NULL	1
1	KAMI	Robotnik	50	2000-10-10 00:00:00.000	NULL	2
1	�ABK	Mened�er par�wek	200	2010-01-10 00:00:00.000	NULL	3
2	TORF	G�rnik	100	2002-05-01 00:00:00.000	2030-02-10 00:00:00.000	4
2	KAMI	G�rnik	150	2010-12-05 00:00:00.000	2030-02-10 00:00:00.000	5
2	SI�O	Mened�er powierzchni p�askich	212	2005-02-10 00:00:00.000	NULL	6
4	TORF	G�rnik	100	2002-01-01 00:00:00.000	2025-02-10 00:00:00.000	7
4	KAMI	Robotnik	50	2000-05-10 00:00:00.000	NULL	8
4	�ABK	Kasjer	100	2015-05-10 00:00:00.000	NULL	9
3	FABR	Sprz�tacz	5000	2020-10-15 00:00:00.000	NULL	10
3	DEST	Tester	1203	2003-04-20 00:00:00.000	2005-04-20 00:00:00.000	11
5	DEST	Kierownik	120000	2001-01-01 00:00:00.000	2001-01-02 00:00:00.000	12
5	FABR	M�odszy zast�pca robotnika	15	2001-01-03 00:00:00.000	2050-01-01 00:00:00.000	13
6	TORF	G�rnik	100	2020-10-10 00:00:00.000	2021-10-10 00:00:00.000	14
7	�ABK	Kierownik	110	2002-10-10 00:00:00.000	NULL	15
7	�ABK	Zast�pca sprz�tacza	10000	2022-01-01 00:00:00.000	NULL	16
8	FABR	Robotnik	200	2014-01-01 00:00:00.000	NULL	17
9	SI�O	Trener	12000	2012-01-01 00:00:00.000	NULL	18
10	SI�O	Trener	12000	2015-03-01 00:00:00.000	NULL	19
11	SI�O	Recepcjonistka	2000	2016-05-03 00:00:00.000	NULL	20
12	DEST	Robotnik	2000	1998-10-10 00:00:00.000	NULL	21
13	TORF	Kierownik	1200	2002-05-03 00:00:00.000	NULL	22*/

/*3. Pokaza� kto ma najd�u�sze pole NAZWA w tabeli WOJ
(najpierw szukamy MAX z LEN(NAZWA) a potem pokazujemy te WOJ z tak� d�ugo�ci� pola NAZWA)*/

DECLARE @max_dl_woj int

SELECT @max_dl_woj = max(len(WOJ.nazwa)) from WOJ

select WOJ.nazwa, len(woj.nazwa) as "dlugosc" from WOJ where len(woj.nazwa)=@max_dl_woj

/*nazwa	dlugosc
PODKARPACKIE	12*/

/*kod_woj	nazwa
??? 	<Nieznane>
MAZ 	MAZOWIECKIE
POD 	PODKARPACKIE
POM 	POMORSKIE*/

/* 4. Policzy� liczb� OSOB w wybranym MIESCIE (tu daj� Wam wyb�r - w kt�rym macie najwi�cej) */

select N'Gr�jec' as "miasto",COUNT(OSOBY.id_miasta) as "populacja" from OSOBY, MIASTA
where MIASTa.id_miasta=OSOBY.id_miasta and miasta.id_miasta=3

/*select miasta.id_miasta, MIASta.nazwa, COUNT(OSOBY.id_miasta) as "populacja" FROM OSOBY, MIASTA
where MIASTA.id_miasta=OSOBY.id_miasta
GROUP BY MIASTA.nazwa, miasta.id_miasta
order by populacja DESC*/

/*miasto	populacja
Gr�jec	5*/
/*id_miasta	nazwa	populacja
2	Mor�g	6
3	Gr�jec	5
1	Warszawa	5
4	Zb�szynek	2*/

/*id_miasta	imie	nazwisko	id_osoby
2	adam	chili�ski	1
4	bartosz	walaszek	2
3	jan	pawe�	3
2	krystian	maczuga	4
3	wies�aw	paleta	5
4	janusz	�ruta	6
1	rafa�	zb�szy�ski	7
3	witek	b�czkowski	8
2	stefan	kwasigr�ch	9
2	tadeusz	lapeta	10
1	izabela	pomietlarz	11
3	el�bieta	kusibab	12
1	krystyna	ciapciak	13
2	micha�	waleczny	14
1	patrycja	bia�y	15
3	kuba	grochowski	16
2	kuba	tragarz	17
1	jacek	korytkowski	18*/
