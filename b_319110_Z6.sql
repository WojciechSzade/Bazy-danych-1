/* Wojciech Szade 319110, grupa 3 */
/*
** 3 regu³y tworzenia TRIGGERA
** R1 - Trigger nie mo¿e aktualizowaæ CALEJ tabeli a co najwy¿ej elementy zmienione
** R2 - Trigger mo¿e wywo³aæ sam siebie - uzysamy niesoñczon¹ rekurencjê == stack overflow
** R3 - Zawsze zakladamy, ¿e wstawiono / zmodyfikowano / skasowano wiecej jak 1 rekord
*/
/* Z1: Napisaæ trigger, który bêdzie usuwa³ spacje z pola IMIE
** Trigger na INSERT, UPDATE
** UWAGA !! Trigger bêdzie robi³ UPDATE na polu IMIE
** To grozi REKURENCJ¥ i przepelnieniem stosu
** Dlatego trzeba bêdzie sprawdzaæ UPDATE(IMIE) i sprawdzaæ czy we
** wstawionych rekordach by³y spacje i tylko takowe poprawiaæ (ze spacjami w nazwisku)
*/
IF OBJECT_ID(N'T1') IS NOT NULL
	DROP TRIGGER T1

GO
CREATE TRIGGER dbo.T1 ON OSOBY FOR INSERT, UPDATE
AS
	IF UPDATE(imie)
	AND EXISTS (select 1 from inserted WHERE charindex(' ', inserted.imie) > 0)
	UPDATE OSOBY SET imie = REPLACE(imie, ' ', '')
GO
/* Z2: Napisaæ procedurê szukaj¹c¹ WOJ z paramertrami
** @nazwa_wzor nvarchar(20) = NULL
** @kod_woj_wzor nvarchar(20) = NULL
** @pokaz_zarobki bit = 0
** Procedura ma mieæ zmienn¹ @sql nvarchar(1000), któr¹ buduje dynamicznie
** @pokaz_zarobki = 0 => (WOJ.NAZWA AS woj, kod_woj)
** @pokaz_zarobki = 1 => (WOJ.NAZWA AS woj, kod_woj
, œr_z_akt_etatow)
** Mozliwe wywo³ania: EXEC sz_w @nazw_wzor = N'M%'
** powinno zbudowaæ zmienn¹ tekstow¹
** @sql = N'SELECT w.* FROM woj w WHERE w.nazwa LIKE N''M%'' '
** uruchomienie zapytania to EXEC sp_sqlExec @sql
** rekomendujê aby najpierw procedura zwraca³a zapytanie SELECT @sql
** a dopiero jak bêd¹ poprawne uruachamia³a je
*/

IF OBJECT_ID(N'P2') IS NOT NULL
	DROP PROCEDURE P2

GO
CREATE PROCEDURE dbo.P2 (@nazwa_wzor nvarchar(20) = '', @kod_woj_wzor nvarchar(20) = '', @pokaz_zarobki bit = 0, @debug bit = 0)
AS
	DECLARE @sql nvarchar(1000)
	IF @pokaz_zarobki = 0
		SET @sql = N'select WOJ.nazwa, WOJ.kod_woj from WOJ where WOJ.nazwa like ''' + @nazwa_wzor + ''' or WOJ.kod_woj like '''+@kod_woj_wzor+'''';
	IF @pokaz_zarobki = 1
		SET @SQL = N'select WOJ.nazwa, WOJ.kod_woj, AVG(ETATY.pensja) as srednia from WOJ, MIASTA, ETATY, OSOBY where MIASTA.kod_woj=WOJ.kod_woj AND OSOBY.id_miasta=MIASTA.id_miasta AND ETATY.id_osoby=OSOBY.id_osoby AND WOJ.nazwa like ''' + @nazwa_wzor + ''' or WOJ.kod_woj like ''' + @kod_woj_wzor +  '''GROUP BY WOJ.nazwa, WOJ.kod_woj';
	IF @debug = 1
		SELECT @sql
	ELSE
		EXEC sp_sqlexec @sql
GO
EXEC dbo.P2 @nazwa_wzor = N'MAZOWIECKIE', @kod_woj_wzor = 'MAZ'
EXEC dbo.P2 @nazwa_wzor = N'MAZOWIECKIE', @kod_woj_wzor = 'MAZ', @pokaz_zarobki = 1
EXEC dbo.P2 @nazwa_wzor = N'POMORSKIE', @pokaz_zarobki = 1, @debug = 0

--SELECT nazwa, kod_woj from WOJ
--select WOJ.nazwa, WOJ.kod_woj, AVG(ETATY.pensja) as srednia from WOJ, MIASTA, ETATY, OSOBY where MIASTA.kod_woj=WOJ.kod_woj AND OSOBY.id_miasta=MIASTA.id_miasta AND ETATY.id_osoby=OSOBY.id_osoby AND WOJ.nazwa like 'MAZOWIECKIE' or WOJ.kod_woj like 'MAZ'  GROUP BY WOJ.nazwa, WOJ.kod_woj

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
/*
kod_woj	nazwa
??? 	<Nieznane>
MAZ 	MAZOWIECKIE
POD 	PODKARPACKIE
POM 	POMORSKIE
*/