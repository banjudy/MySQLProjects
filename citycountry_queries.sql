SELECT Name 
	FROM city 
		WHERE CountryCode = 'NZL';
        
SELECT Name 
	FROM city 
		WHERE CountryCode = 'AUS' 
			ORDER BY Population ASC;
            
SELECT Name 
	FROM city 
		WHERE CountryCode = 'AUS' AND Population > 1000000 
			ORDER BY Population DESC;
            
SELECT * 
	FROM country 
		WHERE Continent = 'Africa' 
			ORDER BY Name ASC;
            
SELECT * 
	FROM country 
		ORDER BY LifeExpectancy DESC LIMIT 10;
        
SELECT * 
	FROM country 
		WHERE Continent LIKE '%America' 
			ORDER BY HeadOfState ASC;
            
SELECT * 
	FROM country 
		WHERE Continent = 'South America' AND GovernmentForm = 'Republic';
        
SELECT Name 
	FROM country 
		ORDER BY IndepYear DESC LIMIT 1;

-- kétféle megoldás:
SELECT* FROM 
	(SELECT* FROM city AS top10 
		Order BY Population DESC LIMIT 10) 
			AS tenth 
				ORDER BY Population LIMIT 1;
                
SELECT * 
	FROM city 
		ORDER BY Population DESC LIMIT 1 OFFSET 9;

-- kétféle megoldás:
SELECT * 
	FROM country 
		ORDER BY Population DESC LIMIT 1 OFFSET 9;
        
SELECT * FROM 
	(SELECT * 
		FROM Country AS top10Country 
			ORDER BY Population DESC LIMIT 10) 
				AS tenth ORDER BY Population LIMIT 1;

SELECT * 
	FROM country 
		WHERE IndepYear IS NULL 
			ORDER BY Population DESC;
            
SELECT Language 
	FROM countrylanguage 
		WHERE NOT Language LIKE 'Hungarian' 
			AND CountryCode = 'HUN' ;
            
SELECT COUNT(Code) 
	FROM country 
		WHERE HeadOfState LIKE '%Hamad%' OR HeadOfState LIKE '%Ahmad%' OR HeadOfState LIKE '%Ahmed%';
        
SELECT Name 
	FROM City 
		WHERE Population BETWEEN 100000 AND 200000;
        
SELECT CountryCode 
	FROM countrylanguage 
		WHERE Percentage = 100;
        
SELECT * 
	FROM country 
		WHERE NOT Continent LIKE 'Antarctica' 
			AND Population = 0;
            
SELECT * 
	FROM country 
		WHERE Code LIKE 'Y%';
        
SELECT * 
	FROM country 
		WHERE Continent = 'Europe' 
			ORDER BY LifeExpectancy ASC LIMIT 1;
            
SELECT DISTINCT Language 
	FROM countrylanguage;
    
SELECT countrylanguage.CountryCode, Country.name
	FROM countrylanguage JOIN country ON countrylanguage.CountryCode = country.Code
		WHERE NOT CountryCode LIKE 'HUN' AND Language = 'Hungarian'; -- != is lehet hasznalni mint not equal to
    
SELECT Name 
	FROM country 
		WHERE GNP > 200000 ORDER BY SurfaceArea;









-- gyakorlas3
-- 1. feladat: Mennyi a világ (nyilvántartás szerinti) összpopulációja?
SELECT SUM(Population) FROM Country;

-- 2. feladat: Hány országot szabadítottak fel a 1800 és 1850 között?
SELECT COUNT(Name) FROM Country
	WHERE IndepYear BETWEEN 1800 AND 1850;
    
-- 3.feladat: Hány brazil megyét (district) tartunk nyilván?
SELECT COUNT(DISTINCT District) FROM City
	WHERE CountryCode = 'BRA';

-- 4. feladat: Hány országban beszél egy nyelvet a lakosság legalább 99%-a?
SELECT COUNT(CountryCode) FROM countrylanguage
	WHERE Percentage >= 99;

-- 5. feladat: Adj meg egy populáció szerinti bontást régiókra! (Első oszlop: régió neve, második oszlop: populáció aránya a teljes populációban)
SELECT Region, SUM(Population) FROM Country
	GROUP BY Region; 

-- 6. feladat: Készíts egy olyan két oszlopos lekérdezést, ahol az első oszlop az ország neve, 
-- a második oszlop pedig a “kevés” stringet tartalmazza, ha az ország lakossága 10 milliónál kisebb, 
-- és a “sok” stringet tartalmazza, ha 10 millió vagy afölötti.
SELECT Name,
	CASE
		WHEN Population > 10000000 THEN "SOK"
        WHEN Population < 10000000 THEN 'KEVÉS'
	END
FROM Country;

-- 7. feladat: Mi a fővárosa a legsűrűbben lakott országnak? (Lakosság per terület.)
SELECT City.Name, Country.Population/Country.SurfaceArea AS Density FROM City
	JOIN Country ON Country.Capital = City.ID
		ORDER BY Density DESC LIMIT 1;
        
-- 8. feladat: Listázd ki az országokat és a fővárosukat! (Első oszlop: ország neve, második
-- oszlop: főváros neve.)
SELECT Country.Name, City.Name FROM City
	JOIN Country ON Country.Capital = City.ID;

-- 9. feladat: Listázd ki azokat a városokat ABC-rendben, ahol a hivatalos nyelv a spanyol!
SELECT City.Name FROM City
	JOIN countrylanguage ON City.CountryCode = countrylanguage.CountryCode
		WHERE countrylanguage.language = 'Spanish'
			ORDER BY City.Name;

-- 10. feladat: Melyik az az ország (vagy országok) ahol a legtöbb nyelvet beszélik?		-- TODO, mert nemjo!!!!
SELECT countrylanguage.CountryCode, COUNT(Language) FROM countrylanguage GROUP BY Language
    HAVING COUNT(Language) = (
        SELECT MAX(countrylanguage.count)
			FROM ( 
				SELECT CountryCode, COUNT(Language) AS count FROM countrylanguage
					GROUP BY CountryCode
				) 
			countrylanguage
            );

SELECT CountryCode, COUNT(Language) AS count FROM countrylanguage
	GROUP BY CountryCode
		ORDER BY count DESC;



-- 11. Melyik a legnépesebb holland megye?
SELECT District, MAX(Population) FROM City
	WHERE CountryCode = 'NLD';

-- 12. Hány országnál nem tartunk nyilván fővárost?
SELECT COUNT(Name) FROM Country
	WHERE Capital IS NULL;

-- 13. Hány országnál nem ugyanazzal a betűvel kezdődik a 3 betűs országkód, mint a 2 betűs?
SELECT COUNT(*) FROM country
	WHERE LEFT(Code, 1) != LEFT(Code2, 1);

-- 14. Melyik a legnagyobb dél-amerikai ország?
SELECT Name, MAX(SurfaceArea) FROM country
	WHERE Continent = 'South America';

-- 15. Kontinensenként mennyi az összterület?
SELECT Continent, SUM(SurfaceArea) AS sum FROM country
	GROUP BY Continent
		ORDER BY sum;

-- 16. Hány Magyarországnál kisebb területű ország van, ahol a populáció nagyobb mint Magyarországon? -- TODO!!!!!
SELECT COUNT(Name) FROM Country;
	-- WHERE SurfaceArea

-- 17. Melyik az az ország Magyarországon kívül, ahol a lakosság arányában a legtöbben beszélik a magyar nyelvet?
SELECT CountryCode, Percentage FROM countrylanguage
	WHERE Language = 'Hungarian' AND CountryCode != 'HUN'
		ORDER BY Percentage DESC LIMIT 1;

-- 18. A fenti kérdés lélekszámra, nem arányra:
SELECT Country.Name, (country.Population*countrylanguage.Percentage/100) as hungarianSpeakers FROM country
	JOIN countrylanguage ON country.Code = countrylanguage.CountryCode
		WHERE Language = 'Hungarian' AND CountryCode != 'HUN'
			ORDER BY hungarianSpeakers DESC LIMIT 1;

-- 19. Hány ország neve kezdődik ugyanolyan betűvel, mint a fővárosa?
SELECT COUNT(Country.Name) FROM Country
	JOIN City ON Country.Capital = City.ID
		WHERE LEFT(Country.Name, 1) = LEFT (City.Name, 1);
