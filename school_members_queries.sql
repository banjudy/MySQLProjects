-- a lekérdezések a school_members_db nevű adatbázishoz tartoznak

/* Kik a nem-diákok az adatbázisban?*/
SELECT * FROM members
	WHERE state != 'student';

/* Hány személy szerepel az adatbázisban beosztásonként, ahol a beosztás nem 'unknown'?*/
SELECT state, COUNT(*) AS 'number_of_persons' 
	FROM members
		WHERE state != 'unknown'
			GROUP BY state;
	
/* Mennyi a legtöbb szerezhető kredit?*/
SELECT MAX(credit)
	FROM subjects;

/* Milyen nappali képzések vannak?*/
SELECT *
	FROM courses
		WHERE is_daytime = 1
			ORDER BY length_week DESC;

/* Melyek azok a tantárgyak, amelyek neve tartalmazza a “programozás” vagy a “Programozás” szavak valamelyikét?*/
SELECT subject_name
	FROM subjects
		WHERE subject_name LIKE '%rogramozás%';


/* Melyek azok a tantárgyak, amelyeket hétvégén tartanak?
		növekvő sorrendben a következők szerint:
			- először a nap szerint (szombat, vasárnap),
			- másodszor a tantárgy (órákban mért) hosszúsága szerint.*/
SELECT *
	FROM subjects JOIN subjects2courses ON subjects.id = subjects2courses.subject_id
		WHERE subjects2courses.schedule_day LIKE 'saturday' OR subjects2courses.schedule_day LIKE 'sunday'
			ORDER BY subjects2courses.schedule_day, subjects.length_hour;
				


/* Mi a TOP 3-as kurzuslista, amihez a legkevesebb TÁRGY tartozik?
		A találati lista a 3 legkevesebb tantárggyal rendelkező kurzusok id-ját és tantárgyaik számát tartalmazza!*/
SELECT course_id, COUNT(*) AS 'count_of_subjects'
	FROM subjects2courses
		GROUP BY course_id
			ORDER BY count_of_subjects LIMIT 3;

/* Írj utasítást, amely a members táblához hozzáad egy új mezőt, amelyben telefonszámot lehet tárolni.*/
ALTER TABLE members
	ADD phone_number INT(30) UNSIGNED;


/* Írj utasítást, amely módosítja a subjects táblán a 42 id-val rendelkező rekord kreditértékét 2-re.*/
UPDATE subjects
	SET credit = 2
		WHERE id = 42;


/* Írj utasítást, amely hozzáad három új tanárt a members táblához!
	A tanárok adatai a következők legyenek:
		1. neve: Ró Kázmér; email-címe: rokazmer@progmatic.ac
		2. neve: Mor Zsolt; email-címe: morzsolt@progmatic.ac
		3. neve: Rázár Lázár; email-címe: razarlazar@progmatic.ac*/
INSERT INTO members (name, emil) VALUES 
 ('Ró Kázmér', 'rokazmer@progmatic.ac'),
 ('Mor Zsolt', 'morzsolt@progmatic.ac'),
 ('Rázár Lázár', 'razarlazar@progmatic.ac');

/* Mennyi kredit szerezhető a különböző kurzusokon?
		nevét és az összkreditet (azaz a kurzus tantárgyaiért kapható kreditek összegét)*/

SELECT CourseID, CourseName, COUNT(TotalCredits) AS 'TotalOfCredits'
	 FROM (
			SELECT subjects2courses.course_id AS 'CourseID', courses.course_name AS 'CourseName', subjects.credit AS 'TotalCredits'
				FROM subjects2courses
					JOIN subjects ON subjects2courses.subject_id = subjects.id
					JOIN courses ON subjects2courses.course_id = courses.id
					ORDER BY subjects2courses.course_id) result
        GROUP BY CourseID;

/*  Kik azok a diákok, akik jelenleg valamilyen esti kurzuson vesznek részt?*/
SELECT members.*
	FROM member2courses
		JOIN members ON member2courses.member_id = members.id
        JOIN courses ON member2courses.course_id = courses.id
			WHERE members.state = 'student' AND courses.is_daytime = 0;

