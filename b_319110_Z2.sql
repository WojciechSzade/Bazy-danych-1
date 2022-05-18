/*Z2, Wojciech Szade, Gr. 3, 319110*/

/*1. Pokazaæ dane podstawowe osoby, w jakim mieœcie mieszka i w jakim to jest województwie*/

SELECT OSOBY.imie, OSOBY.nazwisko, MIASTA.nazwa, WOJ.nazwa
from OSOBY, MIASTA, WOJ
where OSOBY.id_miasta=MIASTA.id_miasta and OSOBY.id_osoby=1 and WOJ.kod_woj=MIASTA.kod_woj

/*imie	nazwisko	nazwa	nazwa
adam	chiliñski	Mor¹g	POMORSKIE*/

/* 2. Pokazaæ wszystkie etaty gdzie STANOWISKO zaczyna siê na literê M i koñczy na X lub Y
(je¿eli nie macie takowych to wybierzcie takie warunki - inn¹ literê pocz¹tkow¹ i inne 2 koñcowe aby wybra³y siê takie M%I lub takie M%Y)
które maj¹ pensje pomiêdzy 3000 a 5000 (te¿ mo¿ecie zmieniæ je¿eli macie g³ownie inne zakresy)
mieszkaj¹ce w mieœcie o kodzie X (proszê wybraæ dowolne)
(wystarcz¹ dane z tabel etaty, firmy, osoby , miasta)*/

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
w.b¹czkowski	Robotnik	2014-01-01 00:00:00.000	NULL	200	Grójec	FABRYKA CHLORU	FABR	Piaseczno
e.kusibab	Robotnik	1998-10-10 00:00:00.000	NULL	2000	Grójec	DESTYLARNIA	DEST	Gdynia*/

/*id_osoby	id_firmy	stanowisko	pensja	od	do	id_etatu
1	TORF	Górnik	100	2002-01-01 00:00:00.000	NULL	1
1	KAMI	Robotnik	50	2000-10-10 00:00:00.000	NULL	2
1	¯ABK	Mened¿er parówek	200	2010-01-10 00:00:00.000	NULL	3
2	TORF	Górnik	100	2002-05-01 00:00:00.000	2030-02-10 00:00:00.000	4
2	KAMI	Górnik	150	2010-12-05 00:00:00.000	2030-02-10 00:00:00.000	5
2	SI£O	Mened¿er powierzchni p³askich	212	2005-02-10 00:00:00.000	NULL	6
4	TORF	Górnik	100	2002-01-01 00:00:00.000	2025-02-10 00:00:00.000	7
4	KAMI	Robotnik	50	2000-05-10 00:00:00.000	NULL	8
4	¯ABK	Kasjer	100	2015-05-10 00:00:00.000	NULL	9
3	FABR	Sprz¹tacz	5000	2020-10-15 00:00:00.000	NULL	10
3	DEST	Tester	1203	2003-04-20 00:00:00.000	2005-04-20 00:00:00.000	11
5	DEST	Kierownik	120000	2001-01-01 00:00:00.000	2001-01-02 00:00:00.000	12
5	FABR	M³odszy zastêpca robotnika	15	2001-01-03 00:00:00.000	2050-01-01 00:00:00.000	13
6	TORF	Górnik	100	2020-10-10 00:00:00.000	2021-10-10 00:00:00.000	14
7	¯ABK	Kierownik	110	2002-10-10 00:00:00.000	NULL	15
7	¯ABK	Zastêpca sprz¹tacza	10000	2022-01-01 00:00:00.000	NULL	16
8	FABR	Robotnik	200	2014-01-01 00:00:00.000	NULL	17
9	SI£O	Trener	12000	2012-01-01 00:00:00.000	NULL	18
10	SI£O	Trener	12000	2015-03-01 00:00:00.000	NULL	19
11	SI£O	Recepcjonistka	2000	2016-05-03 00:00:00.000	NULL	20
12	DEST	Robotnik	2000	1998-10-10 00:00:00.000	NULL	21
13	TORF	Kierownik	1200	2002-05-03 00:00:00.000	NULL	22*/

/*3. Pokazaæ kto ma najd³u¿sze pole NAZWA w tabeli WOJ
(najpierw szukamy MAX z LEN(NAZWA) a potem pokazujemy te WOJ z tak¹ d³ugoœci¹ pola NAZWA)*/

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

/* 4. Policzyæ liczbê OSOB w wybranym MIESCIE (tu dajê Wam wybór - w którym macie najwiêcej) */

select N'Grójec' as "miasto",COUNT(OSOBY.id_miasta) as "populacja" from OSOBY, MIASTA
where MIASTa.id_miasta=OSOBY.id_miasta and miasta.id_miasta=3

/*select miasta.id_miasta, MIASta.nazwa, COUNT(OSOBY.id_miasta) as "populacja" FROM OSOBY, MIASTA
where MIASTA.id_miasta=OSOBY.id_miasta
GROUP BY MIASTA.nazwa, miasta.id_miasta
order by populacja DESC*/

/*miasto	populacja
Grójec	5*/
/*id_miasta	nazwa	populacja
2	Mor¹g	6
3	Grójec	5
1	Warszawa	5
4	Zb¹szynek	2*/

/*id_miasta	imie	nazwisko	id_osoby
2	adam	chiliñski	1
4	bartosz	walaszek	2
3	jan	pawe³	3
2	krystian	maczuga	4
3	wies³aw	paleta	5
4	janusz	œruta	6
1	rafa³	zb¹szyñski	7
3	witek	b¹czkowski	8
2	stefan	kwasigróch	9
2	tadeusz	lapeta	10
1	izabela	pomietlarz	11
3	el¿bieta	kusibab	12
1	krystyna	ciapciak	13
2	micha³	waleczny	14
1	patrycja	bia³y	15
3	kuba	grochowski	16
2	kuba	tragarz	17
1	jacek	korytkowski	18*/
