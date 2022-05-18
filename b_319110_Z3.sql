/*Wojciech Szade 319110*/

/*select * from WOJ
select * from MIASTA
select * from OSOBY
select * from FIRMY
select * from ETATY
*/
 /* Z3.1 - policzyæ liczbê osób w ka¿dym mieœcie (zapytanie z grupowaniem)
Najlepiej wynik zapamiêtaæ w tabeli tymczasowej*/
IF OBJECT_ID(N'POPULACJA') IS NOT NULL
	DROP TABLE POPULACJA
GO
IF OBJECT_ID(N'WOJ_FIR') IS NOT NULL
	DROP TABLE WOJ_FIR
GO

CREATE TABLE POPULACJA
(
nazwa nvarchar(50) not null PRIMARY KEY
, ludzie int not null
)
INSERT INTO POPULACJA(nazwa, ludzie)
SELECT MIASTA.nazwa, COUNT(OSOBY.id_osoby) 
FROM MIASTA, OSOBY
WHERE MIASTA.id_miasta = OSOBY.id_miasta
GROUP BY MIASTA.nazwa
ORDER BY COUNT(OSOBY.id_osoby) DESC

SELECT * FROM POPULACJA

/*nazwa	ludzie
Grójec	5
Mor¹g	6
Warszawa	5
Zb¹szynek	2*/

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
/*id_miasta	nazwa	kod_woj
1	Warszawa	MAZ 
2	Mor¹g	POM 
3	Grójec	MAZ 
4	Zb¹szynek	MAZ 
5	Gdynia	POM 
6	Piaseczno	MAZ */

/*Z3.2- korzystaj¹c z wyniku Z3,1 - pokazaæ, które miasto ma najwiêksz¹ liczbê osób
(zapytanie z fa - analogiczne do zadañ z Z2)*/
SELECT TOP 1 ludzie, nazwa
FROM POPULACJA
ORDER BY ludzie DESC

/*ludzie	nazwa
6	Mor¹g*/

/*Z3.3 Pokazaæ liczbê firm w ka¿dym z województw (czyli grupowanie po kod_woj)*/
SELECT WOJ.nazwa, COUNT(FIRMY.nazwa_skr) as liczba_firm
FROM FIRMY, WOJ, MIASTA
WHERE FIRMY.id_miasta=MIASTA.id_miasta and MIASTA.kod_woj=WOJ.kod_woj
GROUP BY WOJ.nazwa

/*nazwa	liczba_firm
MAZOWIECKIE	3
POMORSKIE	3*/
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
/*id_miasta	nazwa	kod_woj
1	Warszawa	MAZ 
2	Mor¹g	POM 
3	Grójec	MAZ 
4	Zb¹szynek	MAZ 
5	Gdynia	POM 
6	Piaseczno	MAZ */

/*Z3.4 Poazaæ województwa w których nie ma ¿adnej firmy*/
SELECT *
FROM WOJ
WHERE NOT EXISTS
(SELECT 1 FROM FIRMY, MIASTA WHERE FIRMY.id_miasta=MIASTA.id_miasta and WOJ.kod_woj=MIASTA.kod_woj)

/*kod_woj	nazwa
??? 	<Nieznane>
POD 	PODKARPACKIE*/