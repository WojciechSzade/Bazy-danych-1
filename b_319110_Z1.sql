/* Wojciech Szade 319110 */

/* ID_OSOBY w OSOBY i ID_MIASTA w MIASTA samonumerujące IDENTITY
** to jedyne kolumny typu INT (jak i klucze obce do nich)
** OD i DO to DATETIME, PENSJA to MONEY, wszystkie pozostałe 
** nchar i nvarchar. Jedyna typu NULL to DO w ETATY, pozostałe NOT NULL
*/
IF OBJECT_ID(N'ETATY') IS NOT NULL
	DROP TABLE ETATY
GO
IF OBJECT_ID(N'OSOBY') IS NOT NULL
	DROP TABLE OSOBY
GO
IF OBJECT_ID(N'FIRMY') IS NOT NULL
	DROP TABLE FIRMY
GO
IF OBJECT_ID(N'MIASTA') IS NOT NULL
	DROP TABLE MIASTA
GO
IF OBJECT_ID(N'WOJ') IS NOT NULL
	DROP TABLE WOJ
GO
/* fragment skryptu z wykladu 07.03 od 140 linii do konca */
CREATE TABLE dbo.WOJ 
(	kod_woj nchar(4)	NOT NULL CONSTRAINT PK_WOJ PRIMARY KEY
,	nazwa	nvarchar(50) NOT NULL
)
GO
CREATE TABLE dbo.MIASTA
(	id_miasta	int				not null IDENTITY CONSTRAINT PK_MIASTA PRIMARY KEY
,	nazwa		nvarchar(50)	NOT NULL
,	kod_woj		nchar(4)		NOT NULL 
	CONSTRAINT FK_MIASTA_WOJ FOREIGN KEY REFERENCES WOJ(kod_woj)
/* klucz obcy to powiązanie do lucza głownego w innej tabelce
** typy kolumn muszą się zgadzac - nazwy nie muszą */ 
)
GO
CREATE TABLE dbo.OSOBY
(	id_miasta	int				not null CONSTRAINT FK_OSOBY_MIASTA FOREIGN KEY
		REFERENCES MIASTA(id_miasta)
,	imie		nvarchar(50)	NOT NULL
,	nazwisko	nvarchar(50)	NOT NULL 
,	id_osoby int NOT NULL IDENTITY CONSTRAINT PK_OSOBY PRIMARY KEY
/* klucz obcy to powiązanie do lucza głownego w innej tabelce
** typy kolumn muszą się zgadzac - nazwy nie muszą */ 
)
GO
CREATE TABLE dbo.FIRMY
(  nazwa_skr nvarchar(10) not null CONSTRAINT PK_FIRMA PRIMARY KEY
,	id_miasta int				not null CONSTRAINT FK_FIRMY_MIASTA FOREIGN KEY
		REFERENCES MIASTA(id_miasta)
,	nazwa nvarchar(50)		NOT NULL
,	kod_pocztowy nchar(6)	NOT NULL
,	ulica nvarchar(50) NOT NULL
)
GO
CREATE TABLE dbo.ETATY
( id_osoby int not null CONSTRAINT FK_ETATY_OSOBY FOREIGN KEY REFERENCES OSOBY(id_osoby)
, id_firmy nvarchar(10) not null CONSTRAINT FK_ETATY_FIRMA FOREIGN KEY REFERENCES FIRMY(nazwa_skr)
, stanowisko nvarchar(50) not null
, pensja int not null
, od datetime not null
, do datetime null
, id_etatu int not null IDENTITY CONSTRAINT PK_ETAT PRIMARY KEY
)
GO

/* nie można dodać miasta z nieznanym kodem woj */
INSERT INTO WOJ (kod_woj, nazwa) VALUES (N'???', N'<Nieznane>')
INSERT INTO WOJ (kod_woj, nazwa) VALUES (N'MAZ', N'MAZOWIECKIE')
INSERT INTO WOJ (kod_woj, nazwa) VALUES (N'POD', N'PODKARPACKIE')
INSERT INTO WOJ (kod_woj, nazwa) VALUES (N'POM', N'POMORSKIE')


DECLARE @id_wa int, @id_jk int, @id_gr int, @id_zb int, @id_mo int, @id_gd int, @id_pi int	/* zmienne id miast */



INSERT INTO MIASTA (nazwa, kod_woj)VALUES (N'Warszawa', N'MAZ')
SET @id_wa = SCOPE_IDENTITY() /* zwraca jakie ID nadano automatycznie w poprzednim poleceniu */
INSERT INTO MIASTA(nazwa, kod_woj) VALUES(N'Morąg', N'POM')
SET @id_mo = SCOPE_IDENTITY()
INSERT INTO MIASTA (nazwa, kod_woj) VALUES (N'Grójec', N'MAZ')
SET @id_gr = SCOPE_IDENTITY()
INSERT INTO MIASTA (nazwa, kod_woj) VALUES (N'Zbąszynek', N'MAZ')
SET @id_zb = SCOPE_IDENTITY()
INSERT INTO MIASTA (nazwa, kod_woj) VALUES (N'Gdynia', N'POM')
SET @id_gd = SCOPE_IDENTITY()
INSERT INTO MIASTA(nazwa, kod_woj) VALUES (N'Piaseczno', N'MAZ')
SET @id_pi = SCOPE_IDENTITY()


INSERT INTO FIRMY (nazwa_skr, id_miasta, nazwa, kod_pocztowy, ulica) VALUES (N'TORF', @id_wa, N'KOPALNIA_TORFU', N'00-421', N'Torfowa')
INSERT INTO FIRMY (nazwa_skr, id_miasta, nazwa, kod_pocztowy, ulica) VALUES (N'KAMI', @id_mo, N'KAMIENOŁOM', N'69-214', N'Robotnicza')
INSERT INTO FIRMY (nazwa_skr, id_miasta, nazwa, kod_pocztowy, ulica) VALUES (N'SIŁO', @id_pi, N'SIŁOWNIA STERYD', N'12-444', N'Żelazna')
INSERT INTO FIRMY (nazwa_skr, id_miasta, nazwa, kod_pocztowy, ulica) VALUES (N'ŻABK', @id_gd, N'ŻABKA', N'81-222', N'Parówkowa')
INSERT INTO FIRMY (nazwa_skr, id_miasta, nazwa, kod_pocztowy, ulica) VALUES (N'FABR', @id_pi, N'FABRYKA CHLORU', N'12-009', N'Bezpieczeństwa')
INSERT INTO FIRMY (nazwa_skr, id_miasta, nazwa, kod_pocztowy, ulica) VALUES (N'DEST', @id_gd, N'DESTYLARNIA', N'81-981', N'Promilowa')

DECLARE @os_ac int,  @os_bw int, @os_jp int, @os_km int, @os_wp int, @os_js int, @os_rz int, @os_wb int, @os_sk int, @os_tl int, @os_ip int, @os_ek int, @os_kc int, @os_mw int /*zmienne id ludzi - inicjaly*/

INSERT INTO OSOBY (id_miasta, imie, nazwisko) VALUES (@id_mo, N'adam', N'chiliński')
SET @os_ac = SCOPE_IDENTITY()
INSERT INTO OSOBY (id_miasta, imie, nazwisko) VALUES (@id_zb, N'bartosz', N'walaszek')
SET @os_bw = SCOPE_IDENTITY()
INSERT INTO OSOBY (id_miasta, imie, nazwisko) VALUES (@id_gr, N'jan', N'paweł')
SET @os_jp = SCOPE_IDENTITY()
INSERT INTO OSOBY (id_miasta, imie, nazwisko) VALUES (@id_mo, N'krystian', N'maczuga')
SET @os_km = SCOPE_IDENTITY()
INSERT INTO OSOBY (id_miasta, imie, nazwisko) VALUES (@id_gr, N'wiesław', N'paleta')
SET @os_wp = SCOPE_IDENTITY()
INSERT INTO OSOBY (id_miasta, imie, nazwisko) VALUES (@id_zb, N'janusz', N'śruta')
SET @os_js = SCOPE_IDENTITY()
INSERT INTO OSOBY (id_miasta, imie, nazwisko) VALUES (@id_wa, N'rafał', N'zbąszyński')
SET @os_rz = SCOPE_IDENTITY()
INSERT INTO OSOBY (id_miasta, imie, nazwisko) VALUES (@id_gr, N'witek', N'bączkowski')
SET @os_wb = SCOPE_IDENTITY()
INSERT INTO OSOBY (id_miasta, imie, nazwisko) VALUES (@id_mo, N'stefan', N'kwasigróch')
SET @os_sk = SCOPE_IDENTITY()
INSERT INTO OSOBY (id_miasta, imie, nazwisko) VALUES (@id_mo, N'tadeusz', N'lapeta')
SET @os_tl = SCOPE_IDENTITY()
INSERT INTO OSOBY (id_miasta, imie, nazwisko) VALUES (@id_wa, N'izabela', N'pomietlarz')
SET @os_ip = SCOPE_IDENTITY()
INSERT INTO OSOBY (id_miasta, imie, nazwisko) VALUES (@id_gr, N'elżbieta', N'kusibab')
SET @os_ek = SCOPE_IDENTITY()
INSERT INTO OSOBY (id_miasta, imie, nazwisko) VALUES (@id_wa, N'krystyna', N'ciapciak')
SET @os_kc = SCOPE_IDENTITY()
INSERT INTO OSOBY (id_miasta, imie, nazwisko) VALUES (@id_mo, N'michał', N'waleczny')
SET @os_mw = SCOPE_IDENTITY()
INSERT INTO OSOBY (id_miasta, imie, nazwisko) VALUES (@id_wa, N'patrycja', N'biały')
INSERT INTO OSOBY (id_miasta, imie, nazwisko) VALUES (@id_gr, N'kuba', N'grochowski')
INSERT INTO OSOBY (id_miasta, imie, nazwisko) VALUES (@id_mo, N'kuba', N'tragarz')
INSERT INTO OSOBY (id_miasta, imie, nazwisko) VALUES (@id_wa, N'jacek' , N'korytkowski')
SET @id_jk = SCOPE_IDENTITY()
INSERT INTO ETATY (id_osoby, id_firmy, stanowisko, pensja, od, do) VALUES(@os_ac, N'TORF', N'Górnik', 100, convert(datetime, N'20020101', 112), null)
INSERT INTO ETATY (id_osoby, id_firmy, stanowisko, pensja, od, do) VALUES(@os_ac, N'KAMI', N'Robotnik', 50, CONVERT(datetime, N'20001010', 112), null)
INSERT INTO ETATY (id_osoby, id_firmy, stanowisko, pensja, od, do) VALUES(@os_ac, N'ŻABK', N'Menedżer parówek', 200, CONVERT(datetime, N'20100110', 112), null)
INSERT INTO ETATY (id_osoby, id_firmy, stanowisko, pensja, od, do) VALUES(@os_bw, N'TORF', N'Górnik', 100, convert(datetime, N'20020501', 112), CONVERT(datetime, N'20300210', 112))
INSERT INTO ETATY (id_osoby, id_firmy, stanowisko, pensja, od, do) VALUES(@os_bw, N'KAMI', N'Górnik', 150, CONVERT(datetime, N'20101205', 112), CONVERT(datetime, N'20300210', 112))
INSERT INTO ETATY (id_osoby, id_firmy, stanowisko, pensja, od, do) VALUES(@os_bw, N'SIŁO', N'Menedżer powierzchni płaskich', 212, CONVERT(datetime, N'20050210', 112), null)
INSERT INTO ETATY (id_osoby, id_firmy, stanowisko, pensja, od, do) VALUES(@os_km, N'TORF', N'Górnik', 100, convert(datetime, N'20020101', 112), CONVERT(datetime, N'20250210', 112))
INSERT INTO ETATY (id_osoby, id_firmy, stanowisko, pensja, od, do) VALUES(@os_km, N'KAMI', N'Robotnik', 50, CONVERT(datetime, N'20000510', 112), null)
INSERT INTO ETATY (id_osoby, id_firmy, stanowisko, pensja, od, do) VALUES(@os_km, N'ŻABK', N'Kasjer', 100, CONVERT(datetime, N'20150510', 112), null)
INSERT INTO ETATY (id_osoby, id_firmy, stanowisko, pensja, od, do) VALUES(@os_jp, N'FABR', N'Sprzątacz', 5000, CONVERT(datetime, N'20201015', 112), null)
INSERT INTO ETATY (id_osoby, id_firmy, stanowisko, pensja, od, do) VALUES(@os_jp, N'DEST', N'Tester', 1203, CONVERT(datetime, N'20030420', 112), CONVERT(datetime, N'20050420', 112)) /*nieaktualny etat*/
INSERT INTO ETATY (id_osoby, id_firmy, stanowisko, pensja, od, do) VALUES(@os_wp, N'DEST', N'Kierownik', 120000, CONVERT(datetime, N'20010101', 112), CONVERT(datetime, N'20010102', 112)) /*nieaktualny etat*/
INSERT INTO ETATY (id_osoby, id_firmy, stanowisko, pensja, od, do) VALUES(@os_wp, N'FABR', N'Młodszy zastępca robotnika', 15, CONVERT(datetime, N'20010103', 112), CONVERT(datetime, N'20500101', 112))
INSERT INTO ETATY (id_osoby, id_firmy, stanowisko, pensja, od, do) VALUES(@os_js, N'TORF', N'Górnik', 100, CONVERT(datetime, N'20201010', 112), CONVERT(datetime, N'20211010', 112)) /*nieaktulny etat*/
INSERT INTO ETATY (id_osoby, id_firmy, stanowisko, pensja, od, do) VALUES(@os_rz, N'ŻABK', N'Kierownik', 110, CONVERT(datetime, N'20021010', 112), null)
INSERT INTO ETATY (id_osoby, id_firmy, stanowisko, pensja, od, do) VALUES(@os_rz, N'ŻABK', N'Zastępca sprzątacza', 10000, CONVERT(datetime, N'20220101', 112), null)
INSERT INTO ETATY (id_osoby, id_firmy, stanowisko, pensja, od, do) VALUES(@os_wb, N'FABR', N'Robotnik', 200, CONVERT(datetime, N'20140101', 112), null)
INSERT INTO ETATY (id_osoby, id_firmy, stanowisko, pensja, od, do) VALUES(@os_sk, N'SIŁO', N'Trener', 12000, CONVERT(datetime, N'20120101', 112), null)
INSERT INTO ETATY (id_osoby, id_firmy, stanowisko, pensja, od, do) VALUES(@os_tl, N'SIŁO', N'Trener', 12000, CONVERT(datetime, N'20150301', 112), null)
INSERT INTO ETATY (id_osoby, id_firmy, stanowisko, pensja, od, do) VALUES(@os_ip, N'SIŁO', N'Recepcjonistka', 2000, CONVERT(datetime, N'20160503', 112), null)
INSERT INTO ETATY (id_osoby, id_firmy, stanowisko, pensja, od, do) VALUES(@os_ek, N'DEST', N'Robotnik', 2000, CONVERT(datetime, N'19981010', 112), null)
INSERT INTO ETATY (id_osoby, id_firmy, stanowisko, pensja, od, do) VALUES(@os_kc, N'TORF', N'Kierownik', 1200, CONVERT(datetime, N'20020503', 112), null)

/*INSERT INTO ETATY (id_osoby, id_firmy, stanowisko, pensja, od, do) VALUES(@os_, N'', N'', , CONVERT(datetime, N'', 112), null)*/

/*id_miasta   nazwa                                              kod_woj
----------- -------------------------------------------------- -------
1           Warszawa                                           MAZ 

(1 row(s) affected) 
*/

/*
Nie można wstawić do tabeli etaty osoby, której nie ma w tabeli osoby:

INSERT INTO ETATY(id_osoby, id_firmy, stanowisko, pensja, od, do) VALUES(100, N'TORF', N'Robotnik', 1200, CONVERT(datetime, N'20021010'), null)

Msg 547, Level 16, State 0, Line 167
The INSERT statement conflicted with the FOREIGN KEY constraint "FK_ETATY_OSOBY". The conflict occurred in database "b_319110", table "dbo.OSOBY", column 'id_osoby'.
*/
/*
Nie można usunąc miasta w którym są firmy lub ludzie:

DELETE FROM MIASTA WHERE nazwa = 'Gdynia'

Msg 547, Level 16, State 0, Line 176
The DELETE statement conflicted with the REFERENCE constraint "FK_FIRMY_MIASTA". The conflict occurred in database "b_319110", table "dbo.FIRMY", column 'id_miasta'.
*/
/*
Nie można usunąć tabeli osoby, jeżeli istnieje tabela ETATY

DROP TABLE OSOBY

Msg 3726, Level 16, State 1, Line 183
Could not drop object 'OSOBY' because it is referenced by a FOREIGN KEY constraint.
*/

select * from FIRMY
select * from ETATY
select * from MIASTA
select * from WOJ
select * from OSOBY


/*
nazwa_skr	id_miasta	nazwa	kod_pocztowy	ulica
DEST	5	DESTYLARNIA	81-981	Promilowa
FABR	6	FABRYKA CHLORU	12-009	Bezpieczeństwa
KAMI	2	KAMIENOŁOM	69-214	Robotnicza
SIŁO	6	SIŁOWNIA STERYD	12-444	Żelazna
TORF	1	KOPALNIA_TORFU	00-421	Torfowa
ŻABK	5	ŻABKA	81-222	Parówkowa

id_osoby	id_firmy	stanowisko	pensja	od	do	id_etatu
1	TORF	Górnik	100	2002-01-01 00:00:00.000	NULL	1
1	KAMI	Robotnik	50	2000-10-10 00:00:00.000	NULL	2
1	ŻABK	Menedżer parówek	200	2010-01-10 00:00:00.000	NULL	3
2	TORF	Górnik	100	2002-05-01 00:00:00.000	2030-02-10 00:00:00.000	4
2	KAMI	Górnik	150	2010-12-05 00:00:00.000	2030-02-10 00:00:00.000	5
2	SIŁO	Menedżer powierzchni płaskich	212	2005-02-10 00:00:00.000	NULL	6
4	TORF	Górnik	100	2002-01-01 00:00:00.000	2025-02-10 00:00:00.000	7
4	KAMI	Robotnik	50	2000-05-10 00:00:00.000	NULL	8
4	ŻABK	Kasjer	100	2015-05-10 00:00:00.000	NULL	9
3	FABR	Sprzątacz	5000	2020-10-15 00:00:00.000	NULL	10
3	DEST	Tester	1203	2003-04-20 00:00:00.000	2005-04-20 00:00:00.000	11
5	DEST	Kierownik	120000	2001-01-01 00:00:00.000	2001-01-02 00:00:00.000	12
5	FABR	Młodszy zastępca robotnika	15	2001-01-03 00:00:00.000	2050-01-01 00:00:00.000	13
6	TORF	Górnik	100	2020-10-10 00:00:00.000	2021-10-10 00:00:00.000	14
7	ŻABK	Kierownik	110	2002-10-10 00:00:00.000	NULL	15
7	ŻABK	Zastępca sprzątacza	10000	2022-01-01 00:00:00.000	NULL	16
8	FABR	Robotnik	200	2014-01-01 00:00:00.000	NULL	17
9	SIŁO	Trener	12000	2012-01-01 00:00:00.000	NULL	18
10	SIŁO	Trener	12000	2015-03-01 00:00:00.000	NULL	19
11	SIŁO	Recepcjonistka	2000	2016-05-03 00:00:00.000	NULL	20
12	DEST	Robotnik	2000	1998-10-10 00:00:00.000	NULL	21
13	TORF	Kierownik	1200	2002-05-03 00:00:00.000	NULL	22

id_miasta	nazwa	kod_woj
1	Warszawa	MAZ 
2	Morąg	POM 
3	Grójec	MAZ 
4	Zbąszynek	MAZ 
5	Gdynia	POM 
6	Piaseczno	MAZ 

kod_woj	nazwa
??? 	<Nieznane>
MAZ 	MAZOWIECKIE
POD 	PODKARPACKIE
POM 	POMORSKIE

id_miasta	imie	nazwisko	id_osoby
2	adam	chiliński	1
4	bartosz	walaszek	2
3	jan	paweł	3
2	krystian	maczuga	4
3	wiesław	paleta	5
4	janusz	śruta	6
1	rafał	zbąszyński	7
3	witek	bączkowski	8
2	stefan	kwasigróch	9
2	tadeusz	lapeta	10
1	izabela	pomietlarz	11
3	elżbieta	kusibab	12
1	krystyna	ciapciak	13
2	michał	waleczny	14
1	patrycja	biały	15
3	kuba	grochowski	16
2	kuba	tragarz	17
1	jacek	korytkowski	18*/