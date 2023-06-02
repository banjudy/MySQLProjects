/*
Az alkalmazásban a felhasználók regisztrálás után tudnak üzenetet küldeni szintén regisztrált felhasználóknak, 
valamint a kapott üzenetekre válaszolhatnak. 
Nincs lehetőség több címzett megadására - azaz egy üzenetet csak egy felhasználó részére lehet küldeni.

Az adatbázisnak képesnek kell lennie a következő adatok tárolására:
    1. regisztrált felhasználók adatai
        - kötelező adatok: név, email-cím, jelszó, profilkép és regisztrálás időpontja
    2. a regisztrált felhasználók által egymásnak küldött üzenetek adatai
        - kötelező adatok: küldő, címzett, üzenet szövege, az üzenet küldésének időpontja, 
          továbbá ha az üzenet egy korábban kapottra válasz, akkor a megválaszolt üzenet

Adatbázis létrehozásának (és használatának) MySQL utasítása.
A táblák létrehozásának MySQL utasítása.
A táblák mezőinek létrehozásához és beállításához szükséges MySQL utasítások.
A tesztadatok adatbázisba rögzítésének MySQL utasítása (tesztadatokkal együtt)
*/

DROP DATABASE IF EXISTS chatDB;

CREATE DATABASE IF NOT EXISTS chatDB;

USE chatDB;

CREATE TABLE IF NOT EXISTS users (
	id INT UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL,
    email VARCHAR(50) NOT NULL,						 
    password VARCHAR(20) NOT NULL,
    profile_pic BLOB,
    reg_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(id)
    );

CREATE TABLE IF NOT EXISTS texts (
	text_id INT UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT,
    sender_id INT UNSIGNED NOT NULL,   -- a felhasználó ID-ja
    receiver_id INT UNSIGNED NOT NULL, -- a felhasznaló ID-ja
    text_message VARCHAR(300) NOT NULL,
    sent_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    replied_to_text_id INT DEFAULT NULL,     -- self JOIN; ha értéke default NULL --> ez egy vadiúj üzenet a 2 felhasználó között, ha egy ID, akkor self JOIN-nal visszakeresheto az eredeti üzenet
	PRIMARY KEY(text_id),
    FOREIGN KEY (sender_id) REFERENCES users(id),
    FOREIGN KEY (receiver_id) REFERENCES users(id)
	);
    
-- nincs szükség külön kapcsolótáblára, mert a texts megmondja ki kinek küldött üzit

INSERT INTO users(name, email, password) VALUES 
	('Kojak', 'kojak@gmail.com', 'WhoLovesYaBaby?'),
    ('Columbo', 'columbo@gmail.com', 'CsakmegegyKerdesUram'),
    ('Hasselhoff', 'donthasselthehoff@gmail.com', 'WaxTheHoff')
;
INSERT INTO texts(sender_id, receiver_id, text_message, replied_to_text_id) VALUES 
	(1, 2, 'Nincs egy nyalókád?', NULL),
    (2, 1, 'Nincs, max szivarral tudok szolgálni.', 1),
	(3, 2, 'A strandon is sok ám a bűntény!', NULL),
    (2, 3, 'Te nem azzal a beszélő kocsival furikázol össze meg vissza?? Mit keresel most meg a strandon?', 3),
    (3, 2, 'De jóllátod, ámbár másodállásban a tengerparton életeket mentek. Nézz ki egyszer!', 4),
    (2, 3, 'Áhh, vár otthon az én kis feleségem. Tudja, nagyon nem örülne neki ha megint elkésnék a vacsoráról.', 5),
    (3, 2, 'Értem, Columbo, ne aggódjon! Nekem most mennem kell! Tschüß!!', 6)
;

SELECT users.name, text_message
	FROM texts JOIN users ON texts.sender_id = users.id
		WHERE texts.sender_id = 3 OR texts.receiver_id = 3
			ORDER BY replied_to_text_id;
            
SELECT COUNT(text_message) AS 'AllTextsToFrom', users.name
	FROM texts JOIN users ON texts.sender_id = users.id
		WHERE texts.sender_id = 3 OR texts.receiver_id = 3;
            
SELECT users.name, COUNT(*) AS 'NumberOfTexts'
	FROM texts JOIN users ON texts.receiver_id = users.id
		WHERE users.name = 'Kojak';


