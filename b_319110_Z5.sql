/*
Z5 Wojciech Szade 319110, 3
*/
/*
Z5.1 - Pokazaæ miasta wraz ze œredni¹ aktualna
pensj¹ w nich z firm tam siê mieszcz¹cych
U¿ywaj¹c UNION, rozwa¿yæ opcjê ALL
jak nie ma etatów to 0 pokazujemy
(czyli musimy obs³u¿yæ miasta bez etatów AKT firm)

id_miasta, nazwa (z miasta), avg(pensja) lub 0
jak brak etatow firmowych w danym miescie
*/

select MIASTA.id_miasta, MIASTA.nazwa ,AVG(ETATY.pensja) as srednia
FROM ETATY
inner join FIRMY on FIRMY.nazwa_skr=ETATY.id_firmy
inner join MIASTA on MIASTA.id_miasta=FIRMY.id_miasta
group by MIASTA.id_miasta, MIASTA.nazwa
UNION
select MIASTA.id_miasta, MIASTA.nazwa, 0
FROM MIASTA
where MIASTA.id_miasta not in (select FIRMY.id_miasta from FIRMY)
/*
id_miasta	nazwa	(No column name)
1	Warszawa	320
2	Mor¹g	83
3	Grójec	0
4	Zb¹szynek	0
5	Gdynia	19087
6	Piaseczno	4489
*/
/*
Z5.2 - to samo co w Z5.1
Ale z wykorzystaniem LEFT OUTER*/

SELECT MIASTA.id_miasta, MIASTA.nazwa, isnull(AVG(ETATY.pensja), 0) as srednia
FROM MIASTA
LEFT JOIN FIRMY on FIRMY.id_miasta=MIASTA.id_miasta
LEFT JOIN ETATY on FIRMY.nazwa_skr=ETATY.id_firmy
group by MIASTA.id_miasta, MIASTA.nazwa
/*
id_miasta	nazwa	(No column name)
1	Warszawa	320
2	Mor¹g	83
3	Grójec	0
4	Zb¹szynek	0
5	Gdynia	19087
6	Piaseczno	4489
*/
/*
Z5.3 Napisaæ procedurê pokazuj¹c¹ œredni¹ pensjê w
osób z miasta - parametr procedure @id_miasta
WYNIK:
id_osoby, imie, nazwisko, avg(pensja)
czyli srednie pensje osob z wszystkich etatow
osob mieszkajacych w danym miescie
*/
GO
IF OBJECT_ID(N'P1') IS NOT NULL
	DROP PROCEDURE P1
GO

CREATE PROCEDURE dbo.P1 (@id_miasta int)
AS
	select MIASTA.id_miasta, MIASTA.nazwa, isnull(AVG(ETATY.pensja), 0) as srednia
	FROM MIASTA
	LEFT JOIN OSOBY ON MIASTA.id_miasta=OSOBY.id_miasta
	LEFT JOIN ETATY ON ETATY.id_osoby=OSOBY.id_osoby
	WHERE MIASTA.id_miasta=@id_miasta
	group by MIASTA.id_miasta, MIASTA.nazwa
GO
EXEC P1 4
GO

/* DO SPRAWDZENIA:

nazwa_skr	id_miasta	nazwa	kod_pocztowy	ulica
DEST	5	DESTYLARNIA	81-981	Promilowa
FABR	6	FABRYKA CHLORU	12-009	Bezpieczeñstwa
KAMI	2	KAMIENO£OM	69-214	Robotnicza
SI£O	6	SI£OWNIA STERYD	12-444	¯elazna
TORF	1	KOPALNIA_TORFU	00-421	Torfowa
¯ABK	5	¯ABKA	81-222	Parówkowa

id_osoby	id_firmy	stanowisko	pensja	od	do	id_etatu
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
13	TORF	Kierownik	1200	2002-05-03 00:00:00.000	NULL	22

id_miasta	nazwa	kod_woj
1	Warszawa	MAZ 
2	Mor¹g	POM 
3	Grójec	MAZ 
4	Zb¹szynek	MAZ 
5	Gdynia	POM 
6	Piaseczno	MAZ 

id_miasta	imie	nazwisko	id_osoby
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
