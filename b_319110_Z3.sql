/*Wojciech Szade 319110*/

/*select * from WOJ
select * from MIASTA
select * from OSOBY
select * from FIRMY
select * from ETATY
*/
 /* Z3.1 - policzy� liczb� os�b w ka�dym mie�cie (zapytanie z grupowaniem)
Najlepiej wynik zapami�ta� w tabeli tymczasowej*/
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
Gr�jec	5
Mor�g	6
Warszawa	5
Zb�szynek	2*/

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
/*id_miasta	nazwa	kod_woj
1	Warszawa	MAZ 
2	Mor�g	POM 
3	Gr�jec	MAZ 
4	Zb�szynek	MAZ 
5	Gdynia	POM 
6	Piaseczno	MAZ */

/*Z3.2- korzystaj�c z wyniku Z3,1 - pokaza�, kt�re miasto ma najwi�ksz� liczb� os�b
(zapytanie z fa - analogiczne do zada� z Z2)*/
SELECT TOP 1 ludzie, nazwa
FROM POPULACJA
ORDER BY ludzie DESC

/*ludzie	nazwa
6	Mor�g*/

/*Z3.3 Pokaza� liczb� firm w ka�dym z wojew�dztw (czyli grupowanie po kod_woj)*/
SELECT WOJ.nazwa, COUNT(FIRMY.nazwa_skr) as liczba_firm
FROM FIRMY, WOJ, MIASTA
WHERE FIRMY.id_miasta=MIASTA.id_miasta and MIASTA.kod_woj=WOJ.kod_woj
GROUP BY WOJ.nazwa

/*nazwa	liczba_firm
MAZOWIECKIE	3
POMORSKIE	3*/
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
/*id_miasta	nazwa	kod_woj
1	Warszawa	MAZ 
2	Mor�g	POM 
3	Gr�jec	MAZ 
4	Zb�szynek	MAZ 
5	Gdynia	POM 
6	Piaseczno	MAZ */

/*Z3.4 Poaza� wojew�dztwa w kt�rych nie ma �adnej firmy*/
SELECT *
FROM WOJ
WHERE NOT EXISTS
(SELECT 1 FROM FIRMY, MIASTA WHERE FIRMY.id_miasta=MIASTA.id_miasta and WOJ.kod_woj=MIASTA.kod_woj)

/*kod_woj	nazwa
??? 	<Nieznane>
POD 	PODKARPACKIE*/