/* Z4 Wojciech Szade 391110, 3 */
/*Z4.1 - pokazaæ firmy z województwa o kodzie X, w których nigdy
nie pracowa³y / nie pracuj¹ (ignorujemy kolumny OD i DO) osoby mieszkaj¹ce w mieœcie o kodzie id_miasta=Y

Czyli jak FIRMA PW ma 2 etaty i jeden
osoby mieszkaj¹cej w mieœcie o ID= X
a drugi etat osoby mieszkaj¹cej w mieœcie o ID=Y
to takiej FIRMY NIE POKOZUJEMY !!!
A nie, ¿e poka¿emy jeden etat a drugi nie*/
 

 /*SELECT ETATY.id_etatu, MIASTA.id_miasta, FIRMY.nazwa, OSOBY.imie, OSOBY.id_miasta, WOJ.kod_woj
 FROM ETATY
 INNER JOIN FIRMY ON FIRMY.nazwa_skr=ETATY.id_firmy
 INNER JOIN MIASTA ON MIASTA.id_miasta=FIRMY.id_miasta
 INNER JOIN OSOBY ON OSOBY.id_osoby=ETATY.id_osoby
 INNER JOIN WOJ ON WOJ.kod_woj=MIASTA.kod_woj
 ORDER BY FIRMY.nazwa*/

 /*W DESTYLARNIA Z ID_MIASTA 5, (POM) PRACUJA TYLKO OSOBY Z MIASTA ID3)*/
 IF OBJECT_ID(N'PENSJAMIAST') IS NOT NULL
	DROP TABLE PENSJAMIAST
GO
IF OBJECT_ID(N'POPULACJA') IS NOT NULL
	DROP TABLE POPULACJA
GO
IF OBJECT_ID(N'PENSJAFIRM') IS NOT NULL
	DROP TABLE PENSJAFIRM
GO



SELECT FIRMY.nazwa, WOJ.kod_woj
FROM FIRMY
INNER JOIN MIASTA ON MIASTA.id_miasta=FIRMY.id_miasta
INNER JOIN WOJ ON WOJ.kod_woj=MIASTA.kod_woj
WHERE WOJ.kod_woj=N'MAZ' AND NOT EXISTS
(SELECT 1
FROM ETATY
INNER JOIN FIRMY ON FIRMY.nazwa_skr=ETATY.id_firmy
INNER JOIN OSOBY ON OSOBY.id_osoby=ETATY.id_osoby
WHERE OSOBY.id_miasta=5)


/*SELECT OSOBY.id_osoby, OSOBY.id_miasta, FIRMY.nazwa
FROM OSOBY
INNER JOIN ETATY ON ETATY.id_osoby=OSOBY.id_osoby
INNER JOIN FIRMY ON FIRMY.nazwa_skr=ETATY.id_firmy*/

/*nazwa	kod_woj
FABRYKA CHLORU	MAZ 
SI£OWNIA STERYD	MAZ 
KOPALNIA_TORFU	MAZ 
poprawne wyniki*/

/*id_osoby	id_miasta	nazwa
1	2	KOPALNIA_TORFU
1	2	KAMIENO£OM
1	2	¯ABKA
2	4	KOPALNIA_TORFU
2	4	KAMIENO£OM
2	4	SI£OWNIA STERYD
4	2	KOPALNIA_TORFU
4	2	KAMIENO£OM
4	2	¯ABKA
3	3	FABRYKA CHLORU
3	3	DESTYLARNIA
5	3	DESTYLARNIA
5	3	FABRYKA CHLORU
6	4	KOPALNIA_TORFU
7	1	¯ABKA
7	1	¯ABKA
8	3	FABRYKA CHLORU
9	2	SI£OWNIA STERYD
10	2	SI£OWNIA STERYD
11	1	SI£OWNIA STERYD
12	3	DESTYLARNIA
13	1	KOPALNIA_TORFU
1	2	¯ABKA

id_miasta	nazwa	kod_woj
1	Warszawa	MAZ 
2	Mor¹g	POM 
3	Grójec	MAZ 
4	Zb¹szynek	MAZ 
5	Gdynia	POM 
6	Piaseczno	MAZ 



dane do sprawdzenia

*/

/*Z4.2 - pokazaæ liczbê miast w WOJ. Ale tylko takie maj¹ce wiêcej jak jedno miasto*/

SELECT COUNT(MIASTA.nazwa) as "liczba miasta", WOJ.kod_woj
FROM WOJ
INNER JOIN MIASTA ON MIASTA.kod_woj=WOJ.kod_woj
GROUP BY WOJ.kod_woj
HAVING COUNT(MIASTA.nazwa)>0

/*liczba miasta	kod_woj
4	MAZ 
2	POM */

/*id_miasta	nazwa	kod_woj
1	Warszawa	MAZ 
2	Mor¹g	POM 
3	Grójec	MAZ 
4	Zb¹szynek	MAZ 
5	Gdynia	POM 
6	Piaseczno	MAZ */

/*Z4,3 - pokazaæ œredni¹ pensjê w MIASTA
ale tylko tych posiadaj¹cych wiêcej ja jednego mieszkañca

1 wariant -> etaty -> osoby -> miasta
teraz z³aczamy wynik tego zapytania z osoby->miasta (grupowane po ID_MIASTA z HAVING)
2 wariant -> (œrednia z firm o danym id_miasta) a liczba mieszkañców z OSOBY
(czyli œrednia wyliczana z tabel Etaty -> Firmy -> Miasta) -> do tab #tymcz
(³aczymy tabelê #tymczas z osoby -> miasta z grupowaniem poprzez ID_MIASTA)
*/


CREATE TABLE POPULACJA
(
nazwa int not null PRIMARY KEY
, ludzie int not null
)
INSERT INTO POPULACJA(nazwa, ludzie)
SELECT MIASTA.id_miasta, COUNT(OSOBY.id_osoby) 
FROM MIASTA, OSOBY
WHERE MIASTA.id_miasta = OSOBY.id_miasta
GROUP BY MIASTA.id_miasta
ORDER BY COUNT(OSOBY.id_osoby) DESC



CREATE TABLE PENSJAMIAST
(
id_miasta int not null CONSTRAINT PK_MIASTA PRIMARY KEY,
 pensja int not null
)

INSERT INTO PENSJAMIAST(id_miasta, pensja)
SELECT MIASTA.id_miasta, AVG(ETATY.pensja)
FROM ETATY
INNER JOIN OSOBY ON OSOBY.id_osoby=ETATY.id_osoby
INNER JOIN MIASTA ON MIASTA.id_miasta=OSOBY.id_miasta
GROUP BY MIASTA.id_miasta


SELECT *
FROM PENSJAMIAST
INNER JOIN POPULACJA ON POPULACJA.nazwa=PENSJAMIAST.id_miasta
WHERE ludzie>1

CREATE TABLE PENSJAFIRM
(id_miasta int not null CONSTRAINT PK_MIASTA2 PRIMARY KEY,
pensja int not null
)
INSERT INTO PENSJAFIRM(id_miasta, pensja)
SELECT FIRMY.id_miasta, AVG(ETATY.pensja)
FROM ETATY
INNER JOIN FIRMY ON FIRMY.nazwa_skr=ETATY.id_firmy
INNER JOIN MIASTA ON MIASTA.id_miasta=FIRMy.id_miasta
GROUP BY FIRMY.id_miasta


SELECT * FROM PENSJAFIRM
INNER JOIN POPULACJA ON POPULACJA.nazwa=PENSJAFIRM.id_miasta
WHERE ludzie>1


/*id_miasta	pensja	nazwa	ludzie
1	3327	1	5
2	2866	2	6
3	21403	3	5
4	140	4	2*/

/*id_miasta	pensja	nazwa	ludzie
1	320	1	5
2	83	2	6*/