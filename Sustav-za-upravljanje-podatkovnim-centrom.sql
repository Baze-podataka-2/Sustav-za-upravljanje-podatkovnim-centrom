DROP DATABASE IF EXISTS datacentar;
CREATE DATABASE datacentar;
USE datacentar;

-- GENERAL STATS -> Br.Procedura: 11, Br.Funkcija: 2, Br.Trigger: 6, Br.Pogled: 6

-- Mario

CREATE TABLE usluge (
    id_usluga INT PRIMARY KEY AUTO_INCREMENT,
    vrsta VARCHAR(40) UNIQUE,
    cijena FLOAT --  cijena po mjesecu -> 1 mj = 30 dana!
);

CREATE TABLE klijenti(
  id_klijent INT PRIMARY KEY AUTO_INCREMENT,
  ime VARCHAR(50),
  prezime VARCHAR(50),
  oib BIGINT UNIQUE
);

CREATE TABLE usluge_klijenata(
    id_usluga_klijent INT PRIMARY KEY AUTO_INCREMENT,
    id_klijent INT,
    id_usluga INT,
    pocetak_usluge DATETIME,
    kraj_usluge DATETIME,
    FOREIGN KEY (id_klijent) REFERENCES klijenti(id_klijent),
    FOREIGN KEY (id_usluga) REFERENCES usluge(id_usluga)
);


CREATE TABLE racuni_prema_klijentima(
    id_racun INT PRIMARY KEY AUTO_INCREMENT,
    datum_izdavanja DATE,
    id_usluga_klijent INT,
    ukupan_iznos FLOAT,
    FOREIGN KEY (id_usluga_klijent) REFERENCES usluge_klijenata(id_usluga_klijent)
);


CREATE TABLE troskovi_datacentra (
    id_troskovi_datacentra INT PRIMARY KEY AUTO_INCREMENT ,
    id_potrosnja INT,
    id_licenca VARCHAR(50),
    FOREIGN KEY (id_potrosnja) REFERENCES potrosnja(id)
);

INSERT INTO usluge (vrsta, cijena) VALUES     ("FREE" ,0.0 ),
                                              ("START" ,4.99 ),
                                              ("PRO" ,9.99 ),
                                              ("PRO+" ,39.99 ),
                                              ("ENTERPRISE", 99.99);


INSERT INTO klijenti (ime, prezime, oib) VALUES
                                                ('Ivan', 'Horvat', 12345678901),
                                                ('Ana', 'Kovač', 23456789012),
                                                ('Marko', 'Novak', 34567890123),
                                                ('Marija', 'Babić', 45678901234),
                                                ('Petar', 'Jurić', 56789012345),
                                                ('Luka', 'Savić', 67890123456),
                                                ('Maja', 'Pavlić', 78901234567),
                                                ('Tina', 'Matić', 89012345678),
                                                ('Dino', 'Grgić', 90123456789),
                                                ('Sara', 'Kralj', 11234567890),
                                                ('Nina', 'Vuković', 22345678901),
                                                ('Tomislav', 'Šarić', 33456789012),
                                                ('Katarina', 'Zorić', 44567890123),
                                                ('Andrej', 'Križ', 55678901234),
                                                ('Jelena', 'Rogić', 66789012345),
                                                ('Filip', 'Tomić', 77890123456),
                                                ('Lana', 'Pavić', 88901234567),
                                                ('Davor', 'Kovačević', 99012345678),
                                                ('Ema', 'Blažević', 10123456789),
                                                ('Roko', 'Milić', 11123456780),
                                                ('Lea', 'Vlahović', 12123456781),
                                                ('Toni', 'Križan', 13123456782),
                                                ('Marta', 'Soldo', 14123456783),
                                                ('Viktor', 'Pavlović', 15123456784),
                                                ('Nika', 'Grgurić', 16123456785),
                                                ('Milan', 'Šeparović', 17123456786),
                                                ('Klara', 'Banić', 18123456787),
                                                ('Ruža', 'Kovačić', 19123456788),
                                                ('Ingrid', 'Trava', 12356547889);



INSERT INTO usluge_klijenata (id_klijent, id_usluga, pocetak_usluge, kraj_usluge) VALUES
                                          (1, 1, STR_TO_DATE('2024-01-15', '%Y-%m-%d'), STR_TO_DATE('2024-04-10', '%Y-%m-%d')),
                                          (2, 3, STR_TO_DATE('2023-03-20', '%Y-%m-%d'), STR_TO_DATE('2023-06-12', '%Y-%m-%d')),
                                          (3, 3, STR_TO_DATE('2024-05-03', '%Y-%m-%d'), STR_TO_DATE('2024-07-25', '%Y-%m-%d')),
                                          (4, 4, STR_TO_DATE('2024-02-28', '%Y-%m-%d'), STR_TO_DATE('2024-05-17', '%Y-%m-%d')),
                                          (5, 1, STR_TO_DATE('2025-01-22', '%Y-%m-%d'), STR_TO_DATE('2025-04-19', '%Y-%m-%d')),
                                          (6, 1, STR_TO_DATE('2023-06-11', '%Y-%m-%d'), STR_TO_DATE('2023-08-27', '%Y-%m-%d')),
                                          (7, 2, STR_TO_DATE('2024-09-14', '%Y-%m-%d'), STR_TO_DATE('2024-12-01', '%Y-%m-%d')),
                                          (8, 5, STR_TO_DATE('2025-02-08', '%Y-%m-%d'), STR_TO_DATE('2025-04-22', '%Y-%m-%d')),
                                          (9, 4, STR_TO_DATE('2024-07-19', '%Y-%m-%d'), STR_TO_DATE('2024-10-04', '%Y-%m-%d')),
                                          (10, 5, STR_TO_DATE('2024-11-02', '%Y-%m-%d'), STR_TO_DATE('2025-01-15', '%Y-%m-%d')),
                                          (11, 1, STR_TO_DATE('2023-04-07', '%Y-%m-%d'), STR_TO_DATE('2023-06-30', '%Y-%m-%d')),
                                          (12, 2, STR_TO_DATE('2024-10-05', '%Y-%m-%d'), STR_TO_DATE('2025-01-01', '%Y-%m-%d')),
                                          (13, 1, STR_TO_DATE('2023-07-13', '%Y-%m-%d'), STR_TO_DATE('2023-10-08', '%Y-%m-%d')),
                                          (14, 4, STR_TO_DATE('2024-03-21', '%Y-%m-%d'), STR_TO_DATE('2024-06-10', '%Y-%m-%d')),
                                          (15, 5, STR_TO_DATE('2024-12-09', '%Y-%m-%d'), STR_TO_DATE('2025-02-28', '%Y-%m-%d')),
                                          (16, 3, STR_TO_DATE('2024-02-12', '%Y-%m-%d'), STR_TO_DATE('2024-05-19', '%Y-%m-%d')),
                                          (17, 3, STR_TO_DATE('2024-06-10', '%Y-%m-%d'), STR_TO_DATE('2024-09-01', '%Y-%m-%d')),
                                          (18, 1, STR_TO_DATE('2024-08-15', '%Y-%m-%d'), STR_TO_DATE('2024-11-10', '%Y-%m-%d')),
                                          (19, 5, STR_TO_DATE('2024-12-22', '%Y-%m-%d'), STR_TO_DATE('2025-03-30', '%Y-%m-%d')),
                                          (20, 4, STR_TO_DATE('2025-01-14', '%Y-%m-%d'), STR_TO_DATE('2025-04-25', '%Y-%m-%d')),
                                          (21, 2, STR_TO_DATE('2025-03-05', '%Y-%m-%d'), STR_TO_DATE('2025-06-20', '%Y-%m-%d')),
                                          (22, 1, STR_TO_DATE('2024-09-01', '%Y-%m-%d'), STR_TO_DATE('2024-12-20', '%Y-%m-%d')),
                                          (23, 4, STR_TO_DATE('2024-04-18', '%Y-%m-%d'), STR_TO_DATE('2024-07-10', '%Y-%m-%d')),
                                          (24, 5, STR_TO_DATE('2024-05-25', '%Y-%m-%d'), STR_TO_DATE('2024-08-18', '%Y-%m-%d')),
                                          (25, 3, STR_TO_DATE('2024-10-09', '%Y-%m-%d'), STR_TO_DATE('2025-01-31', '%Y-%m-%d')),
                                          (26, 2, STR_TO_DATE('2025-02-20', '%Y-%m-%d'), STR_TO_DATE('2025-05-29', '%Y-%m-%d')),
                                          (27, 1, STR_TO_DATE('2024-07-13', '%Y-%m-%d'), STR_TO_DATE('2024-10-25', '%Y-%m-%d')),
                                          (28, 5, STR_TO_DATE('2025-04-02', '%Y-%m-%d'), STR_TO_DATE('2025-07-11', '%Y-%m-%d')),
                                          (29, 4, STR_TO_DATE('2024-11-15', '%Y-%m-%d'), STR_TO_DATE('2025-02-14', '%Y-%m-%d'));                                     (30, 3, STR_TO_DATE('2024-06-21', '%Y-%m-%d'), STR_TO_DATE('2024-09-13', '%Y-%m-%d'));

INSERT INTO racuni_prema_klijentima (id_usluga_klijent) VALUES
                                                                (1),
                                                                (2),
                                                                (3),
                                                                (4),
                                                                (5),
                                                                (6),
                                                                (7),
                                                                (8),
                                                                (9),
                                                                (10),
                                                                (11),
                                                                (12),
                                                                (13),
                                                                (14),
                                                                (15),
                                                                (16),
                                                                (17),
                                                                (18),
                                                                (19),
                                                                (20),
                                                                (21),
                                                                (22),
                                                                (23),
                                                                (24),
                                                                (25),
                                                                (26),
                                                                (27),
                                                                (28),
                                                                (29);







-- -------------------

-- Mario FUNKCIJE I OSTALO --

-- ------------------- MARIO STATS -> Br.Procedura: 1, Br.Funkcija: 2, Br.Trigger: 2, Br.Pogled: 4

-- 1. Procedrua - azurira / mijenja cijenu usluge prema prosljeđenom ID-u


DELIMITER //
CREATE PROCEDURE PromjenaCijeneUsluge(IN ID INT, IN n_cijena FLOAT)
BEGIN
    DECLARE c FLOAT;
    SELECT cijena INTO c FROM usluge WHERE id_usluga = ID;
    IF c < n_cijena THEN
        UPDATE usluge
        SET cijena = n_cijena
        WHERE id_usluga = ID;
    ELSE
        SIGNAL SQLSTATE '50000' SET MESSAGE_TEXT = 'Nova cijena nemože biti manja od stare!';
    END IF;
END //
DELIMITER ;

SELECT * FROM usluge;

-- Procedura izbacuje grešku jer želimo unijeti manju cijenu od postojece.
    CALL PromjenaCijeneUsluge(5,91.00);

-- Procedura radi jer je nova cijena veca od postojece

    CALL PromjenaCijeneUsluge(5,119.99);
    SELECT * FROM usluge;

-- 2. Funkcija vraca ukupan broji dana trajanja usluge nekog klijenta ( sa recenicom za bolje korisnicko iskustvo )

DELIMITER //
CREATE FUNCTION BrojDanaR(ID int) RETURNS VARCHAR(100)
    DETERMINISTIC
    BEGIN
        DECLARE br INT;
        DECLARE recenica VARCHAR(100);
        SELECT  DATEDIFF(usluge_klijenata.kraj_usluge,usluge_klijenata.pocetak_usluge) INTO br FROM usluge_klijenata
                WHERE id_usluga_klijent=id;
        SET recenica = CONCAT('Broj dana koliko je klijent koristio uslugu: ',br);
        RETURN recenica;
END //
DELIMITER ;

SELECT * FROM usluge_klijenata;

-- Vraca broj dana koristenja usluge od strane klijenta sa ID 1

    SELECT BrojDanaR(1);

-- 3. Funkcija BrojDana samo vraca INT u svrhu njezine inkomporacije u druge dijelove projekta

DELIMITER //
CREATE FUNCTION BrojDana(ID int) RETURNS INT
    DETERMINISTIC
    BEGIN
        DECLARE br INT;
        SELECT  DATEDIFF(usluge_klijenata.kraj_usluge,usluge_klijenata.pocetak_usluge) INTO br FROM usluge_klijenata
                WHERE id_usluga_klijent=id;
        RETURN br;
END //
DELIMITER ;

SELECT BrojDana(1);


-- 4. Trigger koji sprijecava upis datuma kraja koristenja usluge koji je se dogodio prije pocetka usluge.

DELIMITER //
CREATE TRIGGER KontrolaDatuma
BEFORE INSERT ON usluge_klijenata
FOR EACH ROW
BEGIN
   IF NEW.kraj_usluge < NEW.pocetak_usluge THEN
      SIGNAL SQLSTATE '50000' SET MESSAGE_TEXT  = 'Datum kraja usluge ne može biti prije datuma početka.';
   END IF ;

END //
DELIMITER ;

    -- Test Triggera -- RADI ISKLJUCIVO PRIJE SVIH GORE INSERTOVA ZBOG OGRANICENJA!!!

    INSERT INTO usluge_klijenata (id_klijent, id_usluga, pocetak_usluge, kraj_usluge) VALUES
    ( 4,1, STR_TO_DATE('2024-04-10', '%Y-%m-%d'), STR_TO_DATE('2024-01-15', '%Y-%m-%d')); -- Ne prolazi

    INSERT INTO usluge_klijenata (id_klijent, id_usluga, pocetak_usluge, kraj_usluge) VALUES
    (4, 3, STR_TO_DATE('2024-04-10', '%Y-%m-%d'), STR_TO_DATE('2024-05-15', '%Y-%m-%d')); -- Prolazi

    SELECT * FROM usluge_klijenata;


-- 5. Trigger koji izračun iznos računa te isti inserta u tablicu racuni_prema_klijentima + inserta trenutni datum

DELIMITER //
CREATE TRIGGER IznosRacuna
BEFORE INSERT ON racuni_prema_klijentima
FOR EACH ROW
BEGIN
    DECLARE broj_dana INT;
    DECLARE cijena_usluge FLOAT;

    SELECT DATEDIFF(usluge_klijenata.kraj_usluge, usluge_klijenata.pocetak_usluge), usluge.cijena
    INTO broj_dana, cijena_usluge FROM usluge_klijenata
    JOIN usluge ON usluge_klijenata.id_usluga = usluge.id_usluga
    WHERE usluge_klijenata.id_usluga_klijent = NEW.id_usluga_klijent;

    SET NEW.ukupan_iznos = (broj_dana / 30) * cijena_usluge; -- dogovoreno kao 1mj = 30 dana
    SET NEW.datum_izdavanja = CURDATE();
END //
DELIMITER ;


-- Provjera triggera

-- INSERT INTO racuni_prema_klijentima (id_usluga_klijent) VALUES(15);
SELECT * FROM racuni_prema_klijentima;

-- 6. Pogled koji radi privremenu tablicu sa svim korsinicima te prikazuje oni koji su "najvjerniji" korisnika, te one koji nisu -> Statistika korisnika

CREATE VIEW StatistikaKorisnika AS
SELECT
    klijenti.id_klijent,
    klijenti.ime,
    klijenti.prezime,
    usluge_klijenata.id_usluga_klijent,
    usluge_klijenata.pocetak_usluge,
    usluge_klijenata.kraj_usluge,
    DATEDIFF(usluge_klijenata.kraj_usluge, usluge_klijenata.pocetak_usluge) AS broj_dana_koristenja,
    CASE
        WHEN DATEDIFF(usluge_klijenata.kraj_usluge, usluge_klijenata.pocetak_usluge) > 80 THEN 'Izuzetno vjeran korisnik'
        WHEN DATEDIFF(usluge_klijenata.kraj_usluge, usluge_klijenata.pocetak_usluge) < 80 THEN 'Vjeran korisnik'
        WHEN DATEDIFF(usluge_klijenata.kraj_usluge, usluge_klijenata.pocetak_usluge) < 30 THEN 'Obican korisnik'
    END AS statistika_korisnika
FROM
    klijenti
JOIN
    usluge_klijenata ON klijenti.id_klijent = usluge_klijenata.id_klijent;


-- Testiranje pogleda

    SELECT * FROM StatistikaKorisnika;

-- 7. Pogled koji vraca raspodjelu kategorija ( pogled StatistikaKorisnika ) prema razini preplate od korisnika
DROP VIEW StatistikaUsluga;

CREATE VIEW StatistikaUsluga AS
SELECT
    usluge.vrsta AS 'Vrsta usluge',
    StatistikaKorisnika.statistika_korisnika,
    COUNT(*) AS 'Broj korisnika'
FROM
    StatistikaKorisnika
JOIN
    usluge_klijenata ON StatistikaKorisnika.id_usluga_klijent = usluge_klijenata.id_usluga_klijent
JOIN
    usluge ON usluge_klijenata.id_usluga = usluge.id_usluga
GROUP BY
    usluge.vrsta, StatistikaKorisnika.statistika_korisnika;


SELECT * FROM StatistikaUsluga ORDER BY 'Broj korisnika' DESC;

-- 8. Pogled AktivniKlijenti uzima trenutni datum te izbacujue trenutno aktivne klijente ( datum koji je u trenutku kada osoba pokrece pogled )

CREATE VIEW AktivniKlijenti AS
SELECT
    ime, prezime, klijenti.id_klijent,
    usluge_klijenata.pocetak_usluge, usluge_klijenata.kraj_usluge, usluge_klijenata.id_usluga,
    usluge.vrsta
FROM klijenti
JOIN usluge_klijenata ON klijenti.id_klijent=usluge_klijenata.id_klijent
JOIN usluge ON usluge.id_usluga =usluge_klijenata.id_usluga
WHERE pocetak_usluge<CURRENT_DATE AND kraj_usluge>CURRENT_DATE;

SELECT * FROM AktivniKlijenti;

-- 9. Pogled UkupniPrihodiUsluge prikazuje ukupni prihod prema svakoj kategoriji usluge
DROP VIEW UkupniPrihodiUsluge;

CREATE VIEW UkupniPrihodiUsluge AS
SELECT
    usluge.vrsta AS 'Usluga:',
    SUM(racuni_prema_klijentima.ukupan_iznos) AS 'Ukupni prihod:'
FROM
    racuni_prema_klijentima
JOIN
    usluge_klijenata ON racuni_prema_klijentima.id_usluga_klijent = usluge_klijenata.id_usluga_klijent
JOIN
    usluge ON usluge_klijenata.id_usluga = usluge.id_usluga
GROUP BY
    usluge.vrsta;

SELECT * FROM UkupniPrihodiUsluge;

SELECT * FROM racuni_prema_klijentima;


-- Mario KRAJ

-- --- --- --- --- --- --- --- --- --- ---


-- Ronan START


-- Kreiranje tablica
 CREATE TABLE Posluzitelj (
    id_posluzitelj INT AUTO_INCREMENT PRIMARY KEY,
    id_konfiguracija  INT NOT NULL,
    id_rack INT NOT NULL,
    id_smjestaj INT  NOT NULL,
    naziv  VARCHAR(50) NOT NULL,
    kategorija VARCHAR(50) NOT NULL,
	FOREIGN KEY (id_konfiguracija) REFERENCES konfiguracija_uredjaja(id),
    FOREIGN KEY (id_rack) REFERENCES rack(id_rack),
    FOREIGN KEY (id_smjestaj) REFERENCES Fizicki_smjestaj(id_smjestaj)
);


CREATE TABLE Monitoring (
    id_monitoring INT AUTO_INCREMENT PRIMARY KEY,
    id_posluzitelj INT NOT NULL,
    vrsta VARCHAR(50) NOT NULL,
    FOREIGN KEY (id_posluzitelj) REFERENCES Posluzitelj(id_posluzitelj)
);

CREATE TABLE Incidenti (
    id_incidenta INT AUTO_INCREMENT PRIMARY KEY,
    datum DATE NOT NULL,
    opis TEXT NOT NULL,
    id_posluzitelj INT NOT NULL,
    status VARCHAR(20) NOT NULL,
    FOREIGN KEY (id_posluzitelj) REFERENCES Posluzitelj(id_posluzitelj)
);

CREATE TABLE Logovi (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    id_posluzitelj INT NOT NULL,
    akcija VARCHAR(100) NOT NULL,
    datum DATETIME NOT NULL,
    user VARCHAR(50) NOT NULL,
    FOREIGN KEY (id_posluzitelj) REFERENCES Posluzitelj(id_posluzitelj)
);

-- Server
INSERT INTO Posluzitelj (id_konfiguracija, id_rack, id_smjestaj, naziv, kategorija) VALUES
(1, 1, 1, 'Fujitsu', 'Web poslužitelj'),
(2, 2, 2, 'Dell', 'Baza podataka'),
(3, 3, 3, 'Lenovo', 'Aplikacijski poslužitelj'),
(4, 4, 4, 'HP', 'Proxy poslužitelj'),
(5, 5, 5, 'Fujitsu', 'Backup poslužitelj'),
(6, 6, 6, 'Dell', 'DNS poslužitelj'),
(7, 7, 7, 'Lenovo', 'Mail poslužitelj'),
(8, 8, 8, 'HP', 'FTP poslužitelj'),
(9, 9, 9, 'Fujitsu', 'Virtualizacijski poslužitelj'),
(10, 10, 10, 'Dell', 'Streaming poslužitelj'),
(11, 11, 11, 'Lenovo', 'VoIP poslužitelj'),
(12, 12, 12, 'HP', 'IoT Gateway'),
(13, 13, 13, 'Fujitsu', 'Load Balancer'),
(14, 14, 14, 'Dell', 'Cache poslužitelj'),
(15, 15, 15, 'Lenovo', 'Testni poslužitelj'),
(16, 16, 16, 'HP', 'Analitički poslužitelj'),
(17, 17, 17, 'Fujitsu', 'Web Proxy'),
(18, 18, 18, 'Dell', 'Data Warehouse'),
(19, 19, 19, 'Lenovo', 'CI/CD poslužitelj'),
(20, 20, 20, 'HP', 'VPN poslužitelj'),
(21, 21, 21, 'Fujitsu', 'Sigurnosni poslužitelj'),
(22, 22, 22, 'Dell', 'CRM poslužitelj');

-- Monitoring
INSERT INTO Monitoring (id_posluzitelj, vrsta) VALUES
(1, 'Praćenje performansi'),
(2, 'Praćenje sigurnosti'),
(3, 'Praćenje mreže'),
(4, 'Praćenje dostupnosti'),
(5, 'Praćenje kapaciteta'),
(6, 'Praćenje logova'),
(7, 'Praćenje učitavanja'),
(8, 'Praćenje propusnosti'),
(9, 'Praćenje grešaka'),
(10, 'Praćenje upotrebe diska'),
(11, 'Praćenje odziva'),
(12, 'Praćenje SSL certifikata'),
(13, 'Praćenje CPU-a'),
(14, 'Praćenje mrežnih portova'),
(15, 'Praćenje usluga');

-- Incidenti
INSERT INTO Incidenti (datum, opis, id_posluzitelj, status) VALUES
('2025-01-01', 'Neočekivano ponovno pokretanje', 1, 'Riješen'),
('2025-01-02', 'Visoka upotreba memorije', 2, 'U tijeku'),
('2025-01-03', 'Problemi s mrežnom povezivošću', 3, 'Otvoreno'),
('2025-01-04', 'Disk je gotovo pun', 4, 'Riješen'),
('2025-01-05', 'Ažuriranje nije uspjelo', 5, 'U tijeku'),
('2025-01-06', 'Neautorizirani pristup', 6, 'Otvoreno'),
('2025-01-07', 'Hardverski kvar', 7, 'Riješen'),
('2025-01-08', 'Povećano kašnjenje', 8, 'U tijeku'),
('2025-01-09', 'Neispravan kabel', 9, 'Otvoreno'),
('2025-01-10', 'Problemi s SSL certifikatom', 10, 'Riješen'),
('2025-01-11', 'Problemi s DNS-om', 11, 'U tijeku'),
('2025-01-12', 'Neispravni podaci u bazi', 12, 'Otvoreno'),
('2025-01-13', 'Greška u aplikaciji', 13, 'Riješen'),
('2025-01-14', 'Nedostupnost mreže', 14, 'Otvoreno'),
('2025-01-15', 'Backup nije uspješan', 15, 'U tijeku');

-- Logovi
INSERT INTO Logovi (id_posluzitelj, akcija, datum, user) VALUES
(1, 'Ponovno pokretanje poslužitelja', '2025-01-01 12:00:00', 'admin'),
(2, 'Ažuriranje postavki vatrozida', '2025-01-02 15:30:00', 'network_admin'),
(3, 'Implementacija nove verzije aplikacije', '2025-01-03 09:00:00', 'devops_team'),
(4, 'Provjera sigurnosnih kopija', '2025-01-04 10:00:00', 'backup_admin'),
(5, 'Optimizacija baze podataka', '2025-01-05 14:45:00', 'db_admin'),
(6, 'Dodavanje novog korisnika', '2025-01-06 11:00:00', 'hr_admin'),
(7, 'Resetiranje lozinke', '2025-01-07 13:00:00', 'it_support'),
(8, 'Ažuriranje softvera', '2025-01-08 16:00:00', 'sys_admin'),
(9, 'Brisanje starih logova', '2025-01-09 08:30:00', 'cleanup_task'),
(10, 'Konfiguracija mrežnih postavki', '2025-01-10 18:00:00', 'network_admin'),
(11, 'Provjera mrežne dostupnosti', '2025-01-11 10:30:00', 'net_ops'),
(12, 'Migracija podataka', '2025-01-12 22:00:00', 'migration_team'),
(13, 'Prijenos podataka na backup server', '2025-01-13 03:00:00', 'backup_admin'),
(14, 'Otvaranje novog korisničkog računa', '2025-01-14 09:15:00', 'user_support'),
(15, 'Ponovno učitavanje usluge', '2025-01-15 17:20:00', 'service_admin');


select * from Logovi;
select * from Posluzitelj;
select * from Incidenti;
select * from Monitoring;
-- Ronan END

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Adis START

CREATE TABLE oprema ( -- pojedinacni queryi npr u pogledima, u Topics na frontendu za ovu tablicu slozeniji quey u pogledu koji vraca najpopularniju opremu(ima najveci broj koristenja u konfiguracijskim setovima)
 id INT PRIMARY KEY AUTO_INCREMENT,
 vrsta VARCHAR(255) NOT NULL, -- check in (vrste koje imamo)?
 specifikacije VARCHAR(255) NOT NULL,
 stanje_na_zalihama INTEGER NOT NULL
 -- id_dobavljac INTEGER,
 -- FOREIGN KEY (id_dobavljac) REFERENCES dobavljac(id)
);

CREATE TABLE konfiguracija_uredjaja (
	id INT PRIMARY KEY AUTO_INCREMENT, -- prije je bio SERIAL vracam na INT sa autoincrementom kako bi se slagalo sa referencama
    graficka_kartica INT DEFAULT NULL, -- 'Rack ne sadrzi',
    procesor INT DEFAULT NULL, -- 'Rack ne sadrzi',
    SSD INT DEFAULT NULL, -- 'Rack ne sadrzi',
    ram INT DEFAULT NULL, -- 'Rack ne sadrzi',
    IP_adresa VARCHAR(45) DEFAULT NULL, --  'Standardni rack ne sadrzi',
    dimenzije INT DEFAULT NULL, -- 'Posluzitelj ne sadrzi',
    PDU INT DEFAULT NULL, -- 'Posluzitelj ne sadrzi',
    patchpanel INT DEFAULT NULL, --  'Posluzitelj ne sadrzi',
    rack_rails INT DEFAULT NULL, -- 'Posluzitelj ne sadrzi',
    UPS INT DEFAULT NULL, -- 'Posluzitelj ne sadrzi',
    hladenje INT DEFAULT NULL, -- 'Posluzitelj ne sadrzi',
    switch INT DEFAULT NULL, -- 'Posluzitelj, standardni rack ne sadrze',
    router INT DEFAULT NULL, -- 'Posluzitelj, standardni rack ne sadrze',
    FOREIGN KEY (graficka_kartica) REFERENCES oprema(id),
    FOREIGN KEY (procesor) REFERENCES oprema(id),
    FOREIGN KEY (SSD) REFERENCES oprema(id),
    FOREIGN KEY (RAM) REFERENCES oprema(id),
    FOREIGN KEY (dimenzije) REFERENCES oprema(id),
    FOREIGN KEY (PDU) REFERENCES oprema(id),
    FOREIGN KEY (patchpanel) REFERENCES oprema(id),
	FOREIGN KEY (rack_rails) REFERENCES oprema(id),
	FOREIGN KEY (UPS) REFERENCES oprema(id),
    FOREIGN KEY (hladenje) REFERENCES oprema(id),
    FOREIGN KEY (switch) REFERENCES oprema(id), 
    FOREIGN KEY (router) REFERENCES oprema(id)
);


CREATE TABLE pracenje_statusa_posluzitelja (
	id INT PRIMARY KEY AUTO_INCREMENT,
    id_posluzitelj INT NOT NULL,
    procesor_status ENUM('Normalan', 'Visoko opterecenje', 'Kritican') NOT NULL,
    ram_status ENUM('Normalan', 'Visoko opterecenje', 'Kritican') NOT NULL,
    ssd_status ENUM('Normalan', 'Visoko opterecenje', 'Kritican') NOT NULL,
    temperatura_status ENUM('Normalan', 'Visoko opterecenje', 'Kritican') NOT NULL,
    vrijeme_statusa TIMESTAMP NOT NULL,
	FOREIGN KEY (id_posluzitelj) REFERENCES Posluzitelj(id_posluzitelj)
);


CREATE TABLE pracenje_statusa_racka (
	id SERIAL PRIMARY KEY,
    id_rack INT NOT NULL,
    temperatura_status ENUM('Normalan', 'Visoko opterecenje', 'Kritican') NOT NULL,
    popunjenost_status ENUM('Slobodno', 'Pun') NOT NULL,
    pdu_status ENUM('Normalan', 'Visoko opterecenje', 'Kritican') NOT NULL,
    ups_status ENUM('Normalan', 'Visoko opterecenje', 'Kritican') NOT NULL,
    bandwith_status_switch VARCHAR(255) NOT NULL DEFAULT 'Standardni rack',
    interface_status_router VARCHAR(255) NOT NULL DEFAULT 'Standardni rack',
	vrijeme_statusa TIMESTAMP NOT NULL,
    FOREIGN KEY (id_rack) REFERENCES Rack(id_rack)
);


CREATE TABLE potrosnja (
	id INT PRIMARY KEY AUTO_INCREMENT,
    potrosnja_kw DECIMAL(10, 2) NOT NULL,
    datum DATE NOT NULL
);


-- PUNJENJE:

-- Tablica oprema, punjeno redoslijedom radi lakseg razumijevanja rasporeda podataka

-- graficke kartice
INSERT INTO oprema (vrsta, specifikacije, stanje_na_zalihama)
VALUES
('Grafička kartica', 'NVIDIA Tesla V100, 32GB HBM2', 10),
('Grafička kartica', 'NVIDIA RTX 3090, 24GB GDDR6X', 15),
('Grafička kartica', 'AMD Radeon Pro VII, 16GB HBM2', 7),
('Grafička kartica', 'NVIDIA Quadro RTX 8000, 48GB GDDR6', 12),
('Grafička kartica', 'NVIDIA Tesla P100, 16GB HBM2', 9),
('Grafička kartica', 'NVIDIA A100, 40GB HBM2', 6),
('Grafička kartica', 'AMD Instinct MI100, 32GB HBM2', 5),
('Grafička kartica', 'NVIDIA RTX 6000 Ada, 48GB GDDR6', 11),
('Grafička kartica', 'NVIDIA Tesla K80, 24GB GDDR5', 8),
('Grafička kartica', 'AMD Radeon RX 6800, 16GB GDDR6', 7),
('Grafička kartica', 'NVIDIA RTX 5000, 16GB GDDR6', 13),
('Grafička kartica', 'AMD Radeon VII, 16GB HBM2', 14),
('Grafička kartica', 'NVIDIA GTX 1080 Ti, 11GB GDDR5X', 9),
('Grafička kartica', 'NVIDIA RTX 2000, 8GB GDDR6', 15),
('Grafička kartica', 'AMD RX Vega 64, 8GB HBM2', 10),
('Grafička kartica', 'Intel Iris Xe Max, 4GB LPDDR4X', 6),
('Grafička kartica', 'NVIDIA RTX 3050, 8GB GDDR6', 8),
('Grafička kartica', 'AMD Radeon RX 7900, 24GB GDDR6', 7),
('Grafička kartica', 'NVIDIA GTX 1660 Super, 6GB GDDR6', 11),
('Grafička kartica', 'AMD RX 6600 XT, 8GB GDDR6', 10),
('Grafička kartica', 'NVIDIA RTX 4000 Ada, 20GB GDDR6', 9),
('Grafička kartica', 'NVIDIA Quadro T1000, 4GB GDDR6', 7),
('Grafička kartica', 'AMD Radeon RX 5500, 4GB GDDR6', 12),
('Grafička kartica', 'NVIDIA GeForce RTX 4080, 16GB GDDR6X', 13),
('Grafička kartica', 'AMD Radeon RX 6500 XT, 4GB GDDR6', 10);

-- procesori
INSERT INTO oprema (vrsta, specifikacije, stanje_na_zalihama)
VALUES
('Procesor', 'Intel Xeon Platinum 8280, 28 jezgra, 2.7 GHz', 10),
('Procesor', 'AMD EPYC 7742, 64 jezgra, 2.25 GHz', 15),
('Procesor', 'Intel Xeon Gold 6230R, 26 jezgra, 2.1 GHz', 7),
('Procesor', 'AMD EPYC 7302, 16 jezgra, 3.0 GHz', 12),
('Procesor', 'Intel Xeon Silver 4214R, 12 jezgra, 2.4 GHz', 9),
('Procesor', 'Intel Core i9-12900K, 16 jezgra, 3.2 GHz', 6),
('Procesor', 'AMD Ryzen 9 5950X, 16 jezgra, 3.4 GHz', 5),
('Procesor', 'Intel Xeon Bronze 3206R, 8 jezgra, 1.9 GHz', 11),
('Procesor', 'AMD EPYC 7452, 32 jezgra, 2.35 GHz', 8),
('Procesor', 'Intel Xeon Gold 5218, 16 jezgra, 2.3 GHz', 7),
('Procesor', 'AMD Ryzen 7 5800X, 8 jezgra, 3.8 GHz', 13),
('Procesor', 'Intel Core i7-12700F, 12 jezgra, 2.1 GHz', 14),
('Procesor', 'AMD EPYC 7402, 24 jezgra, 2.8 GHz', 9),
('Procesor', 'Intel Xeon W-3265, 24 jezgra, 2.7 GHz', 15),
('Procesor', 'Intel Pentium Gold G6400, 2 jezgra, 4.0 GHz', 10),
('Procesor', 'AMD Ryzen Threadripper 3960X, 24 jezgra, 3.5 GHz', 6),
('Procesor', 'Intel Core i5-12600K, 10 jezgra, 3.7 GHz', 8),
('Procesor', 'AMD Ryzen 5 5600X, 6 jezgra, 3.9 GHz', 7),
('Procesor', 'Intel Core i3-12100, 4 jezgra, 3.3 GHz', 11),
('Procesor', 'AMD EPYC 7371, 16 jezgra, 3.8 GHz', 10),
('Procesor', 'Intel Xeon D-1602, 2 jezgra, 2.5 GHz', 9),
('Procesor', 'AMD Athlon Gold 3150G, 4 jezgra, 3.5 GHz', 7),
('Procesor', 'Intel Xeon E5-2697, 14 jezgra, 2.7 GHz', 12),
('Procesor', 'AMD Ryzen 3 5300U, 4 jezgra, 2.6 GHz', 13),
('Procesor', 'Intel Core i7-12800H, 14 jezgra, 2.8 GHz', 10);

-- SSDovi
INSERT INTO oprema (vrsta, specifikacije, stanje_na_zalihama)
VALUES
('SSD', 'Samsung 980 Pro, 2TB NVMe', 25),
('SSD', 'WD Black SN850, 1TB NVMe', 20),
('SSD', 'Intel Optane 905P, 960GB NVMe', 15),
('SSD', 'Seagate FireCuda 530, 4TB NVMe', 10),
('SSD', 'Crucial P5 Plus, 1TB NVMe', 18),
('SSD', 'Samsung PM983, 3.84TB NVMe', 8),
('SSD', 'Micron 9300 Max, 6.4TB NVMe', 6),
('SSD', 'Kingston KC3000, 2TB NVMe', 12),
('SSD', 'Corsair MP600 Pro XT, 4TB NVMe', 9),
('SSD', 'ADATA XPG Gammix S70, 2TB NVMe', 7),
('SSD', 'WD Blue SN550, 1TB NVMe', 10),
('SSD', 'Toshiba XG6, 2TB NVMe', 13),
('SSD', 'SanDisk Extreme Pro, 1TB NVMe', 9),
('SSD', 'Intel D7-P5600, 3.2TB NVMe', 15),
('SSD', 'HP EX950, 2TB NVMe', 11),
('SSD', 'Samsung 970 Evo Plus, 500GB NVMe', 8),
('SSD', 'Crucial MX500, 1TB SATA', 14),
('SSD', 'Seagate Barracuda, 2TB SATA', 6),
('SSD', 'Western Digital Gold, 4TB NVMe', 10),
('SSD', 'ADATA SU800, 1TB SATA', 7),
('SSD', 'Toshiba OCZ VX500, 512GB SATA', 9),
('SSD', 'PNY CS3030, 1TB NVMe', 11),
('SSD', 'Patriot Burst Elite, 240GB SATA', 8),
('SSD', 'Samsung T7 Touch, 1TB NVMe', 12),
('SSD', 'Intel SSD 660p, 2TB NVMe', 10);

-- RAM
INSERT INTO oprema (vrsta, specifikacije, stanje_na_zalihama)
VALUES
('RAM', 'Kingston DDR4, 64GB, 3200MHz', 30),
('RAM', 'Corsair Vengeance DDR4, 128GB, 3600MHz', 20),
('RAM', 'Crucial DDR5, 32GB, 4800MHz', 25),
('RAM', 'G.Skill Trident Z, 128GB, 4000MHz', 15),
('RAM', 'Samsung DDR4, 256GB, 3200MHz', 10),
('RAM', 'Corsair Dominator Platinum, 64GB, 3000MHz', 8),
('RAM', 'ADATA DDR4, 32GB, 3000MHz', 12),
('RAM', 'Micron DDR4, 128GB, 2666MHz', 7),
('RAM', 'Patriot Viper Steel, 64GB, 3000MHz', 9),
('RAM', 'Corsair Vengeance DDR5, 64GB, 5200MHz', 6),
('RAM', 'Crucial Ballistix DDR4, 16GB, 3200MHz', 15),
('RAM', 'Kingston Fury Beast DDR5, 32GB, 6000MHz', 10),
('RAM', 'TeamGroup Elite DDR3, 8GB, 1600MHz', 9),
('RAM', 'HyperX Predator DDR4, 64GB, 3200MHz', 13),
('RAM', 'Samsung DDR5, 128GB, 4800MHz', 14),
('RAM', 'Corsair LPX DDR4, 16GB, 2666MHz', 10),
('RAM', 'ADATA XPG DDR5, 64GB, 5200MHz', 8),
('RAM', 'Kingston ValueRAM DDR4, 32GB, 2400MHz', 6),
('RAM', 'Micron DDR4, 16GB, 2400MHz', 12),
('RAM', 'TeamGroup T-Force DDR4, 128GB, 3600MHz', 11),
('RAM', 'Kingston Fury Impact DDR5, 32GB, 4800MHz', 7),
('RAM', 'Patriot Signature DDR4, 8GB, 2666MHz', 8),
('RAM', 'Corsair RGB Pro DDR4, 32GB, 3200MHz', 9),
('RAM', 'Crucial DDR4, 16GB, 2666MHz', 10),
('RAM', 'Samsung DDR5, 256GB, 5200MHz', 7);

-- PDU
INSERT INTO oprema (vrsta, specifikacije, stanje_na_zalihama)
VALUES
('PDU', 'APC Rack PDU, 24 izlaza, 230V', 10),
('PDU', 'Vertiv Geist Rack PDU, 32 izlaza, 230V', 15),
('PDU', 'CyberPower Rack PDU, 20 izlaza, 120V', 7),
('PDU', 'Tripp Lite Rack PDU, 12 izlaza, 120V', 12),
('PDU', 'Eaton Rack PDU, 16 izlaza, 230V', 9),
('PDU', 'APC Switched Rack PDU, 48 izlaza, 230V', 6),
('PDU', 'Raritan Rack PDU, 24 izlaza, 230V', 5),
('PDU', 'Server Technology Rack PDU, 16 izlaza, 120V', 11),
('PDU', 'Vertiv MPX Rack PDU, 32 izlaza, 230V', 8),
('PDU', 'Schneider Electric Rack PDU, 20 izlaza, 230V', 7),
('PDU', 'APC Metered Rack PDU, 8 izlaza, 230V', 13),
('PDU', 'Eaton Managed Rack PDU, 24 izlaza, 120V', 14),
('PDU', 'Tripp Lite Switched Rack PDU, 16 izlaza, 230V', 9),
('PDU', 'CyberPower Basic Rack PDU, 12 izlaza, 120V', 15),
('PDU', 'APC Smart Rack PDU, 24 izlaza, 230V', 10),
('PDU', 'ServerTech Switched Rack PDU, 32 izlaza, 230V', 6),
('PDU', 'Raritan PX3 Rack PDU, 16 izlaza, 230V', 8),
('PDU', 'Vertiv Basic Rack PDU, 12 izlaza, 230V', 7),
('PDU', 'Schneider Electric Switched Rack PDU, 8 izlaza, 120V', 11),
('PDU', 'Eaton Switched Rack PDU, 16 izlaza, 230V', 10),
('PDU', 'APC Monitored Rack PDU, 24 izlaza, 230V', 9),
('PDU', 'Tripp Lite Basic Rack PDU, 12 izlaza, 230V', 7),
('PDU', 'CyberPower Monitored Rack PDU, 8 izlaza, 120V', 12),
('PDU', 'Raritan Switched Rack PDU, 32 izlaza, 230V', 13),
('PDU', 'Vertiv Monitored Rack PDU, 16 izlaza, 230V', 10);

-- patchpanel
INSERT INTO oprema (vrsta, specifikacije, stanje_na_zalihama)
VALUES
('Patchpanel', 'TP-Link 24-portni patchpanel, CAT6', 15),
('Patchpanel', 'Netgear 48-portni patchpanel, CAT5e', 12),
('Patchpanel', 'Cisco 24-portni patchpanel, CAT6a', 8),
('Patchpanel', 'D-Link 48-portni patchpanel, CAT6', 10),
('Patchpanel', 'Ubiquiti 24-portni patchpanel, CAT5e', 9),
('Patchpanel', 'TP-Link 12-portni patchpanel, CAT6', 7),
('Patchpanel', 'Netgear 24-portni patchpanel, CAT6', 11),
('Patchpanel', 'Cisco 48-portni patchpanel, CAT6a', 6),
('Patchpanel', 'D-Link 24-portni patchpanel, CAT6', 8),
('Patchpanel', 'Ubiquiti 48-portni patchpanel, CAT5e', 7),
('Patchpanel', 'TP-Link 24-portni patchpanel, CAT6a', 14),
('Patchpanel', 'Netgear 12-portni patchpanel, CAT5e', 9),
('Patchpanel', 'Cisco 24-portni patchpanel, CAT6', 13),
('Patchpanel', 'D-Link 48-portni patchpanel, CAT6a', 10),
('Patchpanel', 'Ubiquiti 12-portni patchpanel, CAT6', 6),
('Patchpanel', 'TP-Link 48-portni patchpanel, CAT6a', 8),
('Patchpanel', 'Netgear 24-portni patchpanel, CAT5e', 7),
('Patchpanel', 'Cisco 48-portni patchpanel, CAT6', 11),
('Patchpanel', 'D-Link 12-portni patchpanel, CAT6a', 10),
('Patchpanel', 'Ubiquiti 24-portni patchpanel, CAT6', 9),
('Patchpanel', 'TP-Link 12-portni patchpanel, CAT6', 7),
('Patchpanel', 'Netgear 48-portni patchpanel, CAT6a', 12),
('Patchpanel', 'Cisco 24-portni patchpanel, CAT6', 13),
('Patchpanel', 'D-Link 48-portni patchpanel, CAT5e', 10),
('Patchpanel', 'Ubiquiti 24-portni patchpanel, CAT6a', 11);

-- UPS
INSERT INTO oprema (vrsta, specifikacije, stanje_na_zalihama)
VALUES
('UPS', 'Eaton 5P, 1550VA, 1000W', 10),
('UPS', 'APC Smart-UPS, 1500VA, 1000W', 15),
('UPS', 'CyberPower OR1500, 1500VA, 900W', 7),
('UPS', 'Tripp Lite SmartPro, 2200VA, 1600W', 12),
('UPS', 'Vertiv Liebert GXT5, 2000VA, 1800W', 9),
('UPS', 'Eaton 9PX, 3000VA, 2700W', 6),
('UPS', 'APC Back-UPS, 1200VA, 700W', 5),
('UPS', 'CyberPower CP1500PFCLCD, 1500VA, 1000W', 11),
('UPS', 'Tripp Lite SU1500RTXL2UA, 1500VA, 1200W', 8),
('UPS', 'Vertiv Liebert PSI5, 1500VA, 1350W', 7),
('UPS', 'Eaton 5PX, 2200VA, 1800W', 13),
('UPS', 'APC Smart-UPS C, 1000VA, 700W', 14),
('UPS', 'CyberPower OR2200, 2200VA, 1600W', 9),
('UPS', 'Tripp Lite ECO850LCD, 850VA, 510W', 15),
('UPS', 'Vertiv Liebert GXTS, 3000VA, 2700W', 10),
('UPS', 'Eaton 9130, 700VA, 630W', 6),
('UPS', 'APC BR1500MS, 1500VA, 865W', 8),
('UPS', 'CyberPower EC850LCD, 850VA, 510W', 7),
('UPS', 'Tripp Lite SMART2200RMXL2U, 2200VA, 1600W', 11),
('UPS', 'Vertiv Edge-1500, 1500VA, 1350W', 10),
('UPS', 'Eaton 5S, 700VA, 420W', 9),
('UPS', 'APC BE600M1, 600VA, 330W', 7),
('UPS', 'CyberPower CP1000PFCLCD, 1000VA, 600W', 12),
('UPS', 'Tripp Lite SMART1500LCD, 1500VA, 900W', 13),
('UPS', 'Vertiv Liebert GXT4, 1500VA, 1200W', 10);

-- hladenje
INSERT INTO oprema (vrsta, specifikacije, stanje_na_zalihama)
VALUES
('Hlađenje', 'Noctua NH-D15, dual ventilator, 140mm', 15),
('Hlađenje', 'Cooler Master Hyper 212, 120mm ventilator', 12),
('Hlađenje', 'Corsair iCUE H150i, vodeno hlađenje, 360mm', 9),
('Hlađenje', 'NZXT Kraken X73, vodeno hlađenje, 360mm', 10),
('Hlađenje', 'DeepCool Assassin III, dual ventilator, 140mm', 8),
('Hlađenje', 'be quiet! Dark Rock Pro 4, 250W TDP', 7),
('Hlađenje', 'Arctic Liquid Freezer II, 280mm, vodeno', 6),
('Hlađenje', 'Thermalright Macho Rev. B, 120mm', 9),
('Hlađenje', 'Cooler Master ML240L, vodeno hlađenje, 240mm', 11),
('Hlađenje', 'Corsair H100i Pro, vodeno hlađenje, 240mm', 13),
('Hlađenje', 'NZXT Kraken Z73, vodeno hlađenje, 360mm', 14),
('Hlađenje', 'Arctic Freezer 34 eSports DUO, 120mm', 10),
('Hlađenje', 'Noctua NH-U12A, 120mm ventilator', 8),
('Hlađenje', 'Thermaltake Floe DX, vodeno hlađenje, 360mm', 6),
('Hlađenje', 'Cooler Master MA620M, dual ventilator, 140mm', 12),
('Hlađenje', 'DeepCool Gammaxx 400, 120mm ventilator', 7),
('Hlađenje', 'be quiet! Pure Rock 2, 150W TDP', 9),
('Hlađenje', 'Cooler Master Hyper T20, 120mm ventilator', 8),
('Hlađenje', 'Corsair H115i RGB, vodeno hlađenje, 280mm', 11),
('Hlađenje', 'Arctic F14, 140mm ventilator', 10),
('Hlađenje', 'NZXT Kraken M22, vodeno hlađenje, 120mm', 7),
('Hlađenje', 'DeepCool Captain 240 Pro, vodeno hlađenje, 240mm', 12),
('Hlađenje', 'Thermaltake Contact Silent 12, 120mm', 13),
('Hlađenje', 'Noctua NH-L12S, low-profile ventilator', 10),
('Hlađenje', 'Cooler Master MasterLiquid ML240, vodeno', 8);

-- rackovi
INSERT INTO oprema (vrsta, specifikacije, stanje_na_zalihama)
VALUES
('Dimenzije', 'Mali rack, 24U', 10),
('Dimenzije', 'Srednji rack, 42U', 15),
('Dimenzije', 'Veliki rack, 48U', 7),
('Dimenzije', 'Mali rack, 22U', 12),
('Dimenzije', 'Srednji rack, 40U', 9),
('Dimenzije', 'Veliki rack, 50U', 6),
('Dimenzije', 'Mali rack, 20U', 5),
('Dimenzije', 'Srednji rack, 44U', 11),
('Dimenzije', 'Veliki rack, 46U', 8),
('Dimenzije', 'Mali rack, 26U', 7),
('Dimenzije', 'Srednji rack, 38U', 13),
('Dimenzije', 'Veliki rack, 52U', 14),
('Dimenzije', 'Mali rack, 24U', 9),
('Dimenzije', 'Srednji rack, 42U', 15),
('Dimenzije', 'Veliki rack, 48U', 10),
('Dimenzije', 'Mali rack, 22U', 6),
('Dimenzije', 'Srednji rack, 40U', 8),
('Dimenzije', 'Veliki rack, 50U', 7),
('Dimenzije', 'Mali rack, 20U', 11),
('Dimenzije', 'Srednji rack, 44U', 10),
('Dimenzije', 'Veliki rack, 46U', 9),
('Dimenzije', 'Mali rack, 26U', 7),
('Dimenzije', 'Srednji rack, 38U', 12),
('Dimenzije', 'Veliki rack, 52U', 13),
('Dimenzije', 'Mali rack, 24U', 10);

-- switch uredjaji
INSERT INTO oprema (vrsta, specifikacije, stanje_na_zalihama)
VALUES
('Switch', 'Cisco Catalyst 9300, 48-portni, 10Gbps', 10),
('Switch', 'Juniper EX4300, 24-portni, 1Gbps', 15),
('Switch', 'Ubiquiti UniFi Switch, 24-portni, 10Gbps', 7),
('Switch', 'HP Aruba 2930F, 48-portni, 1Gbps', 12),
('Switch', 'Dell EMC N2200, 24-portni, 10Gbps', 9),
('Switch', 'MikroTik CRS328, 28-portni, 1Gbps', 6),
('Switch', 'Netgear ProSafe GS728, 48-portni, 1Gbps', 5),
('Switch', 'TP-Link TL-SG5428, 28-portni, 10Gbps', 11),
('Switch', 'Extreme Networks X460, 48-portni, 1Gbps', 8),
('Switch', 'Cisco Nexus 9000, 24-portni, 40Gbps', 7),
('Switch', 'Juniper QFX5100, 48-portni, 10Gbps', 13),
('Switch', 'Ubiquiti EdgeSwitch, 24-portni, 1Gbps', 14),
('Switch', 'HP Aruba CX6400, 48-portni, 10Gbps', 10),
('Switch', 'Dell EMC S4148, 48-portni, 25Gbps', 8),
('Switch', 'MikroTik CRS305, 5-portni, 10Gbps', 6),
('Switch', 'Netgear M4300, 24-portni, 1Gbps', 12),
('Switch', 'TP-Link JetStream, 48-portni, 10Gbps', 7),
('Switch', 'Extreme Networks X670, 48-portni, 40Gbps', 9),
('Switch', 'Cisco Catalyst 9200, 24-portni, 1Gbps', 8),
('Switch', 'Juniper EX3400, 48-portni, 1Gbps', 11),
('Switch', 'Ubiquiti UniFi Pro, 48-portni, 10Gbps', 10),
('Switch', 'HP ProCurve 2920, 24-portni, 1Gbps', 9),
('Switch', 'Dell EMC N3200, 48-portni, 1Gbps', 7),
('Switch', 'MikroTik CRS317, 16-portni, 10Gbps', 12),
('Switch', 'Netgear ProSafe GS724, 24-portni, 1Gbps', 13);

-- routeri
INSERT INTO oprema (vrsta, specifikacije, stanje_na_zalihama)
VALUES
('Router', 'Cisco ISR 4321, 2-portni, 1Gbps', 10),
('Router', 'Juniper SRX300, 4-portni, 1Gbps', 15),
('Router', 'MikroTik CCR2004, 7-portni, 10Gbps', 7),
('Router', 'Ubiquiti EdgeRouter 4, 4-portni, 1Gbps', 12),
('Router', 'TP-Link ER7206, 5-portni, 1Gbps', 9),
('Router', 'Netgear Nighthawk X10, 6-portni, 1Gbps', 6),
('Router', 'Asus RT-AX88U, 4-portni, 1Gbps', 5),
('Router', 'Linksys EA9500, 8-portni, 1Gbps', 11),
('Router', 'Cisco RV340, 4-portni, 1Gbps', 8),
('Router', 'Juniper MX204, 8-portni, 100Gbps', 7),
('Router', 'MikroTik RB3011, 10-portni, 1Gbps', 13),
('Router', 'Ubiquiti UniFi Dream Machine, 4-portni, 1Gbps', 14),
('Router', 'TP-Link Archer C5400, 4-portni, 1Gbps', 10),
('Router', 'Netgear Orbi Pro, 4-portni, 1Gbps', 8),
('Router', 'Asus ROG Rapture, 8-portni, 1Gbps', 6),
('Router', 'Linksys WRT3200ACM, 4-portni, 1Gbps', 12),
('Router', 'Cisco ASR 1001-X, 6-portni, 10Gbps', 7),
('Router', 'Juniper SRX4100, 8-portni, 10Gbps', 9),
('Router', 'MikroTik RB1100AHx4, 13-portni, 1Gbps', 8),
('Router', 'Ubiquiti AmpliFi HD, 4-portni, 1Gbps', 11),
('Router', 'TP-Link TL-R605, 5-portni, 1Gbps', 10),
('Router', 'Netgear ProSafe FVS336G, 4-portni, 1Gbps', 9),
('Router', 'Asus RT-AC86U, 4-portni, 1Gbps', 7),
('Router', 'Linksys MR9600, 4-portni, 1Gbps', 12),
('Router', 'Cisco ISR 4451-X, 8-portni, 10Gbps', 13);


-- konfiguracija uredjaja

-- serveri
INSERT INTO konfiguracija_uredjaja (graficka_kartica, procesor, SSD, ram, IP_adresa)
VALUES
(1, 26, 51, 76, '192.168.1.1'),
(2, 27, 52, 77, '192.168.1.2'),
(3, 28, 53, 78, '192.168.1.3'),
(4, 29, 54, 79, '192.168.1.4'),
(5, 30, 55, 80, '192.168.1.5'),
(6, 31, 56, 81, '192.168.1.6'),
(7, 32, 57, 82, '192.168.1.7'),
(8, 33, 58, 83, '192.168.1.8'),
(9, 34, 59, 84, '192.168.1.9'),
(10, 35, 60, 85, '192.168.1.10'),
(11, 36, 61, 86, '192.168.1.11'),
(12, 37, 62, 87, '192.168.1.12'),
(13, 38, 63, 88, '192.168.1.13'),
(14, 39, 64, 89, '192.168.1.14'),
(15, 40, 65, 90, '192.168.1.15'),
(16, 41, 66, 91, '192.168.1.16'),
(17, 42, 67, 92, '192.168.1.17'),
(18, 43, 68, 93, '192.168.1.18'),
(19, 44, 69, 94, '192.168.1.19'),
(20, 45, 70, 95, '192.168.1.20'),
(21, 46, 71, 96, '192.168.1.21'),
(22, 47, 72, 97, '192.168.1.22'),
(23, 48, 73, 98, '192.168.1.23'),
(24, 49, 74, 99, '192.168.1.24'),
(25, 50, 75, 100, '192.168.1.25');


-- standardni rackovi
INSERT INTO konfiguracija_uredjaja (dimenzije, PDU, UPS, hladenje)
VALUES
(201, 101, 151, 176),
(202, 102, 152, 177),
(203, 103, 153, 178),
(204, 104, 154, 179),
(205, 105, 155, 180),
(206, 106, 156, 181),
(207, 107, 157, 182),
(208, 108, 158, 183),
(209, 109, 159, 184),
(210, 110, 160, 185),
(211, 111, 161, 186),
(212, 112, 162, 187);


-- mrezni rackovi
INSERT INTO konfiguracija_uredjaja (dimenzije, patchpanel, switch, router)
VALUES
(213, 126, 226, 251),
(214, 127, 227, 252),
(215, 128, 228, 253),
(216, 129, 229, 254),
(217, 130, 230, 255),
(218, 131, 231, 256),
(219, 132, 232, 257),
(220, 133, 233, 258),
(221, 134, 234, 259),
(222, 135, 235, 260),
(223, 136, 236, 261),
(224, 137, 237, 262),
(225, 138, 238, 263);

-- Adis END za sada :)

-- Unjeti podatke za tablice pracenja, a potrosnja tablica ce se materijaliziranim pogledom puniti ONLINE ili OFFLINE nacin, na temelju statusa u tablicama pracenje



-- TRIGGER koji kreiraju novu narudzbu za pojedinu opremu kada njezino stanje u zalihama bude <= 5;
-- Temelji se na pozivu procedure koja izadje narudzbenicu;

-- Ovo cu pokrenuti kada Mark napravi tablice koje ovise o ovoj proceduri i trigeru
DELIMITER //
CREATE PROCEDURE p_narudzbenica_oprema(IN p_id_oprema INTEGER, IN p_id_dobavljac INTEGER)
BEGIN

DECLARE p_oprema_kolicina INTEGER DEFAULT 10;
DECLARE p_datum DATE;
DECLARE p_opisna_poruka VARCHAR(255);
SET p_datum = CURDATE();
SET p_opisna_poruka = CONCAT("Kreiram narudzbenicu za opremu sa ID-em ", p_id_oprema, " kolicine ", p_oprema_kolicina);


INSERT INTO narudzbe (id_dobavljac, datum, opis, id_oprema)
VALUES(p_id_dobavljac, p_datum, p_opisna_poruka, p_id_dobavljac);


END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER au_oprema
AFTER UPDATE ON oprema
FOR EACH ROW
BEGIN

IF NEW.stanje_na_zalihama <= 5 THEN
	CALL p_narudzbenica_oprema(NEW.id, NEW.id_dobavljac);
    SIGNAL SQLSTATE '01000'
    SET MESSAGE_TEXT = CONCAT('Uspjesno kreirana nova narudzba za opremu sa ID-em ', NEW.id, ' zbog niskih zaliha');
ELSEIF NEW.stanje_na_zalihama >= 5 THEN
	SIGNAL SQLSTATE '01000'
	SET MESSAGE_TEXT = 'Tablica oprema je uspjesno azurirana';    
END IF;

END ;
DELIMITER //


-- TRIGGER koji ce azurirati stanje na zalihama pojedine opreme u tablici oprema jednom kada se ona upotrijebi u konfiguracijskom setu

DELIMITER //
CREATE PROCEDURE p_azuriraj_zalihe(
IN p_graficka_kartica BIGINT,
IN p_procesor BIGINT,
IN p_SSD BIGINT,
IN p_ram BIGINT,
IN p_dimenzije BIGINT,
IN p_PDU BIGINT,
IN p_patchpanel BIGINT,
IN p_rack_rails BIGINT,
IN p_UPS BIGINT,
IN p_hladenje BIGINT,
IN p_switch BIGINT,
IN p_router BIGINT)
BEGIN

	IF p_graficka_kartica IS NOT NULL THEN
		UPDATE oprema
		SET stanje_na_zalihama = stanje_na_zalihama - 1
		WHERE id = p_graficka_kartica;
	END IF;

	IF p_procesor IS NOT NULL THEN
		UPDATE oprema
		SET stanje_na_zalihama = stanje_na_zalihama - 1
		WHERE id = p_procesor;
	END IF;

	IF p_SSD IS NOT NULL THEN
		UPDATE oprema
		SET stanje_na_zalihama = stanje_na_zalihama - 1
		WHERE id = p_SSD;
	END IF;

	IF p_ram IS NOT NULL THEN
		UPDATE oprema
		SET stanje_na_zalihama = stanje_na_zalihama - 1
		WHERE id = p_ram;
	END IF;

	IF p_dimenzije IS NOT NULL THEN
		UPDATE oprema
		SET stanje_na_zalihama = stanje_na_zalihama - 1
		WHERE id = p_dimenzije;
	END IF;

	IF p_PDU IS NOT NULL THEN
		UPDATE oprema
		SET stanje_na_zalihama = stanje_na_zalihama - 1
		WHERE id = p_PDU;
	END IF;

	IF p_patchpanel IS NOT NULL THEN
		UPDATE oprema
		SET stanje_na_zalihama = stanje_na_zalihama - 1
		WHERE id = p_patchpanel;
	END IF;

	IF p_rack_rails IS NOT NULL THEN
		UPDATE oprema
		SET stanje_na_zalihama = stanje_na_zalihama - 1
		WHERE id = p_rack_rails;
	END IF;

	IF p_UPS IS NOT NULL THEN
		UPDATE oprema
		SET stanje_na_zalihama = stanje_na_zalihama - 1
		WHERE id = p_UPS;
	END IF;

	IF p_hladenje IS NOT NULL THEN
		UPDATE oprema
		SET stanje_na_zalihama = stanje_na_zalihama - 1
		WHERE id = p_hladenje;
	END IF;

	IF p_switch IS NOT NULL THEN
		UPDATE oprema
		SET stanje_na_zalihama = stanje_na_zalihama - 1
		WHERE id = p_switch;
	END IF;

	IF p_router IS NOT NULL THEN
		UPDATE oprema
		SET stanje_na_zalihama = stanje_na_zalihama - 1
		WHERE id = p_router;
	END IF;
    
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER ai_konfiguracija_uredaja
AFTER INSERT ON konfiguracija_uredjaja
FOR EACH ROW
BEGIN

IF NEW.graficka_kartica IS NOT NULL OR
	NEW.procesor IS NOT NULL OR
    NEW.SSD IS NOT NULL OR
    NEW.ram IS NOT NULL OR
    NEW.dimenzije IS NOT NULL OR
    NEW.PDU IS NOT NULL OR
    NEW.patchpanel IS NOT NULL OR
    NEW.rack_rails IS NOT NULL OR
    NEW.UPS IS NOT NULL OR
    NEW.hladenje IS NOT NULL OR
    NEW.switch IS NOT NULL OR
    NEW.router IS NOT NULL
    THEN
		CALL p_azuriraj_zalihe(
			NEW.graficka_kartica,
			NEW.procesor,
			NEW.SSD,
			NEW.ram,
			NEW.dimenzije,
			NEW.PDU,
			NEW.patchpanel,
			NEW.rack_rails,
			NEW.UPS,
			NEW.hladenje,
			NEW.switch,
			NEW.router
		);
	END IF;

END //
DELIMITER ;

-- TEST(konfiguraciji set za server):
SELECT * FROM oprema;
INSERT INTO konfiguracija_uredjaja (graficka_kartica, procesor, SSD, ram, IP_adresa)
VALUES
(1, 26, 51, 76, '192.168.1.100');

-- TRIGGER koji ce ukoliko status nekog atributa bude pod visokim_opterecenjem ili kriticinim zamijeniti ga sa istim ili sljedecim tj. po performansama boljim.
-- Scenarij: Visoko_opterecenje mijenja trenutnu komponentu sa istom ali novijom(smatramo da je problem npr sa driverima ili je nekakvo ostecenje)
-- Kriticno mijenja ga sa sljedecim boljim znaci id + 1, iz razloga sto nema dovoljno resursa npr server za bazu


-- Pored triggera biti ce potrebna i procedura, cak dvije koje ce posebno biti pozvane za visoko opterecenje posebno kritican status.

DELIMITER //
CREATE PROCEDURE p_zamijeni_posluzitelj_status_visoko_opterecenje(IN p_id_posluzitelj INTEGER, IN p_komponenta VARCHAR(255))
BEGIN

DECLARE konfiguracijski_set INTEGER;
DECLARE id_zamijenjene_komponente INTEGER;

SELECT id_konfiguracija INTO konfiguracijski_set
FROM Posluzitelj
WHERE id_posluzitelj = p_id_posluzitelj;

-- Ovime sam dosao do konfiguracijskog seta o kojem se radi

IF p_komponenta = 'Procesor' THEN
	SELECT id INTO id_zamijenjene_komponente 
    FROM oprema 
    WHERE vrsta = 'Procesor' AND id = (
		SELECT procesor FROM konfiguracija_uredjaja WHERE id = konfiguracijski_set
    );
    
	UPDATE konfiguracija_uredjaja
	SET procesor = id_zamijenjene_komponente
	WHERE id = konfiguracijski_set;
    
    CALL p_azuriraj_zalihe(
			NULL,
			id_zamijenjene_komponente,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL
		);
END IF;

IF p_komponenta = 'SSD' THEN
	SELECT id INTO id_zamijenjene_komponente 
    FROM oprema 
    WHERE vrsta = 'SSD' AND id = (
		SELECT SSD FROM konfiguracija_uredjaja WHERE id = konfiguracijski_set
    );

	UPDATE konfiguracija_uredjaja
	SET SSD = id_zamijenjene_komponente
	WHERE id = konfiguracijski_set;
    
    CALL p_azuriraj_zalihe(
			NULL,
			NULL,
			id_zamijenjene_komponente,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL
		);
END IF;

IF p_komponenta = 'RAM' THEN
	SELECT id INTO id_zamijenjene_komponente
    FROM oprema
    WHERE vrsta = 'RAM' AND id = (
		SELECT ram FROM konfiguracija_uredjaja WHERE id = konfiguracijski_set
    );
    
	UPDATE konfiguracija_uredjaja
	SET ram = id_zamijenjene_komponente
	WHERE id = konfiguracijski_set;
    
    
    CALL p_azuriraj_zalihe(
			NULL,
			NULL,
			NULL,
			id_zamijenjene_komponente,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL
		);
END IF;


END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE p_zamijeni_posluzitelj_status_kritican(IN p_id_posluzitelj INTEGER, IN p_komponenta VARCHAR(255))
BEGIN

DECLARE konfiguracijski_set INTEGER;
DECLARE id_zamijenjene_komponente INTEGER;

SELECT id_konfiguracija INTO konfiguracijski_set
FROM Posluzitelj
WHERE id_posluzitelj = p_id_posluzitelj;

-- Ovime sam dosao do konfiguracijskog seta o kojem se radi

IF p_komponenta = 'Procesor' THEN
	SELECT id + 1 INTO id_zamijenjene_komponente 
    FROM oprema 
    WHERE vrsta = 'Procesor' AND id = (
		SELECT procesor FROM konfiguracija_uredjaja WHERE id = konfiguracijski_set
    );
    
	UPDATE konfiguracija_uredjaja
	SET procesor = id_zamijenjene_komponente
	WHERE id = konfiguracijski_set;
    
    CALL p_azuriraj_zalihe(
			NULL,
			id_zamijenjene_komponente,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL
		);
END IF;

IF p_komponenta = 'SSD' THEN
	SELECT id + 1 INTO id_zamijenjene_komponente 
    FROM oprema 
    WHERE vrsta = 'SSD' AND id = (
		SELECT SSD FROM konfiguracija_uredjaja WHERE id = konfiguracijski_set
    );

	UPDATE konfiguracija_uredjaja
	SET SSD = id_zamijenjene_komponente
	WHERE id = konfiguracijski_set;
    
    CALL p_azuriraj_zalihe(
			NULL,
			NULL,
			id_zamijenjene_komponente,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL
		);
END IF;

IF p_komponenta = 'RAM' THEN
	SELECT id + 1 INTO id_zamijenjene_komponente
    FROM oprema
    WHERE vrsta = 'RAM' AND id = (
		SELECT ram FROM konfiguracija_uredjaja WHERE id = konfiguracijski_set
    );
    
	UPDATE konfiguracija_uredjaja
	SET ram = id_zamijenjene_komponente
	WHERE id = konfiguracijski_set;
    
    
    CALL p_azuriraj_zalihe(
			NULL,
			NULL,
			NULL,
			id_zamijenjene_komponente,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL
		);
END IF;


END //
DELIMITER ;



DELIMITER //
CREATE TRIGGER ai_pracenje_statusa_posluzitelja
AFTER INSERT ON pracenje_statusa_posluzitelja
FOR EACH ROW
BEGIN

	IF NEW.procesor_status != "Normalan" THEN
		IF NEW.procesor_status = "Visoko opterecenje" THEN
			CALL p_zamijeni_posluzitelj_status_visoko_opterecenje(NEW.id_posluzitelj, 'Procesor');
		ELSEIF NEW.procesor_status = "Kritican" THEN
			CALL p_zamijeni_posluzitelj_status_kritican(NEW.id_posluzitelj, 'Procesor');
		END IF;
	END IF;
    
    IF NEW.ssd_status != "Normalan" THEN
		IF NEW.ssd_status = "Visoko opterecenje" THEN
			CALL p_zamijeni_posluzitelj_status_visoko_opterecenje(NEW.id_posluzitelj, 'SSD');
		ELSEIF NEW.ssd_status = "Kritican" THEN
			CALL p_zamijeni_posluzitelj_status_kritican(NEW.id_posluzitelj, 'SSD');
		END IF;
	END IF;
    
	IF NEW.ram_status != "Normalan" THEN
		IF NEW.ram_status = "Visoko opterecenje" THEN
			CALL p_zamijeni_posluzitelj_status_visoko_opterecenje(NEW.id_posluzitelj, 'RAM');
		ELSEIF NEW.ram_status = "Kritican" THEN
			CALL p_zamijeni_posluzitelj_status_kritican(NEW.id_posluzitelj, 'RAM');
		END IF;
	END IF;


END //
DELIMITER ;


-- Pracenje statusa racka slican princip kao i za posluzitelja, samo se prate drugaciji atributi te uvjeti i pozivanje procedura

DELIMITER //
CREATE PROCEDURE p_zamijeni_rack_status_kritican(IN p_id_rack INTEGER, IN p_komponenta VARCHAR(255))
BEGIN

DECLARE konfiguracijski_set INTEGER;
DECLARE id_zamijenjene_komponente INTEGER;

SELECT id_konfiguracija INTO konfiguracijski_set
FROM Rack 
WHERE id_rack = p_id_rack;

IF p_komponenta = 'Hlađenje' THEN
SELECT id INTO id_zamijenjene_komponente
FROM oprema
WHERE vrsta = 'hladenje' AND specifikacije LIKE '%vodeno hlađenje%'
ORDER BY RAND()
LIMIT 1;


UPDATE konfiguracija_uredjaja
SET hladenje = id_zamijenjene_komponente
WHERE id = konfiguracijski_set;
CALL p_azuriraj_zalihe(
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			id_zamijenjene_komponente,
			NULL,
			NULL
		);
END IF;

IF p_komponenta = "PDU" THEN
SELECT id + 1 INTO id_zamijenjene_komponente 
FROM oprema 
WHERE vrsta = 'PDU' AND id = (
	SELECT PDU FROM konfiguracija_uredjaja WHERE id = konfiguracijski_set
);

UPDATE konfiguracija_uredjaja
SET PDU = id_zamijenjene_komponente
WHERE id = konfiguracijski_set;
CALL p_azuriraj_zalihe(
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			id_zamijenjene_komponente,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL
		);
END IF;
        
IF p_komponenta = "UPS" THEN
SELECT id + 1 INTO id_zamijenjene_komponente
FROM oprema 
WHERE vrsta = 'UPS' AND id = (
	SELECT UPS FROM konfiguracija_uredjaja WHERE id = konfiguracijski_set
);

UPDATE konfiguracija_uredjaja
SET UPS = id_zamijenjene_komponente
WHERE id = konfiguracijski_set;
CALL p_azuriraj_zalihe(
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			id_zamijenjene_komponente,
			NULL,
			NULL,
			NULL
		);
END IF;

END //
DELIMITER ;



DELIMITER //
CREATE TRIGGER ai_pracenje_statusa_racka
AFTER INSERT ON pracenje_statusa_racka
FOR EACH ROW
BEGIN
	-- ako je temperatura kriticna zamijenit cemo vodenim hladenjem
	IF NEW.temperatura_status = "Kritican" THEN
		CALL p_zamijeni_rack_status_kritican(NEW.id_rack, 'Hlađenje');
	END IF;
    
    -- ako je PDU visok, tj u ovom slucaju kritican zamijeniti ga boljim zbog optimizacije(u realnom svijetu nije jedini preduslov kao rjesenje problema)
    IF NEW.pdu_status = "Kritican" THEN
		CALL p_zamijeni_rack_status_kritican(NEW.id_rack, 'PDU');
	END IF;
    
	IF NEW.ups_status = "Kritican" THEN
		CALL p_zamijeni_rack_status_kritican(NEW.id_rack, 'UPS');
	END IF;
	
	

	-- Ostaka ideja ako je nesto pod visokim opterecenjem neka ode u monitoring ja cu tu napraviti uvjet, a Ronan posto je njegova tablica neka napravi proceduru i ja cu je pozvati 

END //
DELIMITER ;


-- TEST(jedan je gore za konfiguracijski set sve prolazi dobro)

-- Sada za pracenje statusa posluzitelja, provjeriti stanja u tablici nakon rekorda:  -- Radi
SELECT * FROM oprema;
SELECT * FROM konfiguracija_uredjaja;
 
INSERT INTO Posluzitelj (id_konfiguracija, id_rack, id_smjestaj, kategorija) VALUES
(4, 1, 1, 'Web poslužitelj');

SELECT *
FROM Posluzitelj;

INSERT INTO pracenje_statusa_posluzitelja (id_posluzitelj, procesor_status, ram_status, ssd_status, temperatura_status, vrijeme_statusa)
VALUES (16, 'Kritican', 'Visoko opterecenje', 'Kritican', 'Normalan', NOW());

-- Sada za pracenje statusa racka, provjeriti stanja u tablici nakon rekorda:  -- Radi
SELECT * FROM oprema;
SELECT * FROM konfiguracija_uredjaja;

INSERT INTO Rack VALUES
(103, 28, 1, 'server_rack');

SELECT * FROM Rack;

INSERT INTO pracenje_statusa_racka (id_rack, temperatura_status, popunjenost_status, pdu_status, ups_status, vrijeme_statusa)
VALUES (103, 'Kritican', 'Slobodno', 'Kritican', 'Kritican', NOW());

-- Jos imam plan dodati: Proceduru koja vraca broj izmjena kod pojedinog uredjaj -- nakon pauze gotove
-- Kreirati materijalizirani pogled koji puni tablicu potrosnja smislenim obracunom na temelju statusa iz pracenja uredjaja, tj. odredenih atributa i njihovog statusa(rada) danas gotovo
-- Na tu tablicu potrosnja napraviti proceduru koja vraca npr neki period(dan, mjesec) u kojem je ostvarena najveca potrosnja u kW. -- nakon pauze, barem kao test dok nemamo dosta rekorda gotovo

-- Onda bi moje stanje iznosilo: Procedure: 6-7, Triggeri: 5-6, Pogledi: 1 za sada taj materijalizirani, te mozda par slozenijih upita spremljenih u pogled za pojedinacni prikaz necega na frontendu

-- Krecem sa materijaliziranim pogledom, za pocetak za svaki unos, potom kao offline/batch nacin tj neka izracuna za cijeli dan potrosnju i ugraditi cu job tj event za to postici

DELIMITER //
CREATE PROCEDURE p_generirana_potrosnja_posluzitelja (
IN p_status_temperatura VARCHAR(255),
    IN p_status_RAM VARCHAR(255),
    IN p_status_SSD VARCHAR(255),
	OUT ukupno INTEGER)
BEGIN

	DECLARE potrosnja_lokalno_w INTEGER DEFAULT 0;
    SET potrosnja_lokalno_w = 200; -- bazni slucaj

-- temperatura
IF p_status_temperatura = "Normalan" THEN
	SET potrosnja_lokalno_w = potrosnja_lokalno_w + 50;
ELSEIF p_status_temperatura = "Visoko opterecenje" THEN
	SET potrosnja_lokalno_w = potrosnja_lokalno_w + 150;
ELSEIF p_status_temperatura = "Kritican" THEN
	SET potrosnja_lokalno_w = potrosnja_lokalno_w + 200;
END IF;

-- RAM
IF p_status_RAM = "Normalan" THEN
	SET potrosnja_lokalno_w = potrosnja_lokalno_w + 50;
ELSEIF p_status_RAM = "Visoko opterecenje" THEN
	SET potrosnja_lokalno_w = potrosnja_lokalno_w + 150;
ELSEIF p_status_RAM = "Kritican" THEN
	SET potrosnja_lokalno_w = potrosnja_lokalno_w + 200;
END IF;

-- SSD
IF p_status_SSD = "Normalan" THEN
	SET potrosnja_lokalno_w = potrosnja_lokalno_w + 50;
ELSEIF p_status_SSD = "Visoko opterecenje" THEN
	SET potrosnja_lokalno_w = potrosnja_lokalno_w + 150;
ELSEIF p_status_SSD = "Kritican" THEN
	SET potrosnja_lokalno_w = potrosnja_lokalno_w + 200;
END IF;

SET ukupno = potrosnja_lokalno_w;


END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE p_generirana_potrosnja_racka (
IN p_status_temperatura VARCHAR(255),
    IN p_status_PDU VARCHAR(255),
    IN p_status_UPS VARCHAR(255),
	OUT ukupno INTEGER)
BEGIN

	DECLARE potrosnja_lokalno_w INTEGER DEFAULT 0;
    SET potrosnja_lokalno_w = 200; -- bazni slucaj

-- temperatura
IF p_status_temperatura = "Normalan" THEN
	SET potrosnja_lokalno_w = potrosnja_lokalno_w + 50;
ELSEIF p_status_temperatura = "Visoko opterecenje" THEN
	SET potrosnja_lokalno_w = potrosnja_lokalno_w + 150;
ELSEIF p_status_temperatura = "Kritican" THEN
	SET potrosnja_lokalno_w = potrosnja_lokalno_w + 200;
END IF;

-- PDU
IF p_status_PDU = "Normalan" THEN
	SET potrosnja_lokalno_w = potrosnja_lokalno_w + 50;
ELSEIF p_status_PDU = "Visoko opterecenje" THEN
	SET potrosnja_lokalno_w = potrosnja_lokalno_w + 150;
ELSEIF p_status_PDU = "Kritican" THEN
	SET potrosnja_lokalno_w = potrosnja_lokalno_w + 200;
END IF;

-- UPS
IF p_status_UPS = "Normalan" THEN
	SET potrosnja_lokalno_w = potrosnja_lokalno_w + 50;
ELSEIF p_status_UPS = "Visoko opterecenje" THEN
	SET potrosnja_lokalno_w = potrosnja_lokalno_w + 150;
ELSEIF p_status_UPS = "Kritican" THEN
	SET potrosnja_lokalno_w = potrosnja_lokalno_w + 200;
END IF;

SET ukupno = potrosnja_lokalno_w;



END //
DELIMITER ;

-- Postigao sam racunanje potrosnje prilikom inserta u pracenje statusa, sada bi to trebalo zakurziti na kraj dana. Znaci jos jedna procedura koja to sve racuna te ima event job

DELIMITER //
CREATE PROCEDURE p_dnevna_potrosnja (p_datum DATE)
BEGIN

DECLARE ukupna_dnevna_potrosnja INTEGER DEFAULT 0;
-- posluzitelj
DECLARE p_status_temperatura_posluzitelj VARCHAR(255);
DECLARE p_status_RAM VARCHAR(255);
DECLARE p_status_SSD VARCHAR(255);
-- rack
DECLARE p_status_temperatura_rack VARCHAR(255);
DECLARE p_status_PDU VARCHAR(255);
DECLARE p_status_UPS VARCHAR(255);

DECLARE fleg INTEGER DEFAULT 0;

DECLARE moj_kursor_posluzitelj CURSOR FOR
SELECT temperatura_status, ram_status, ssd_status
FROM pracenje_statusa_posluzitelja
WHERE DATE(vrijeme_statusa) = DATE(p_datum);


DECLARE moj_kursor_rack CURSOR FOR
SELECT temperatura_status, pdu_status, ups_status
FROM pracenje_statusa_racka
WHERE DATE(vrijeme_statusa) = DATE(p_datum);


DECLARE CONTINUE HANDLER FOR NOT FOUND SET fleg = 1;

OPEN moj_kursor_posluzitelj;
moja_petlja_posluzitelj:LOOP
	
    FETCH moj_kursor_posluzitelj INTO p_status_temperatura_posluzitelj, p_status_RAM, p_status_SSD;
    
    IF fleg = 1 THEN
		LEAVE moja_petlja_posluzitelj;
	END IF;
    
    
    CALL p_generirana_potrosnja_posluzitelja(p_status_temperatura_posluzitelj, p_status_RAM, p_status_SSD, @ukupno);
    SET ukupna_dnevna_potrosnja = ukupna_dnevna_potrosnja + @ukupno;
END LOOP moja_petlja_posluzitelj;
CLOSE moj_kursor_posluzitelj;

SET fleg = 0;

-- sada rackovi

OPEN moj_kursor_rack;
moja_petlja_rack:LOOP

	FETCH moj_kursor_rack INTO p_status_temperatura_rack, p_status_PDU, p_status_UPS;
    
    IF fleg = 1 THEN
		LEAVE moja_petlja_rack;
	END IF;
    
    CALL p_generirana_potrosnja_racka(p_status_temperatura_rack, p_status_PDU, p_status_UPS, @ukupno);
    SET ukupna_dnevna_potrosnja = ukupna_dnevna_potrosnja + @ukupno;
END LOOP moja_petlja_rack;
CLOSE moj_kursor_rack;

    

INSERT INTO potrosnja (potrosnja_kw, datum)
VALUES (ukupna_dnevna_potrosnja / 1000, p_datum);
END //
DELIMITER ;

-- radi na temelju podataka u tablicama pracenje sve je kriticno sto iznosi 800+800+800+800+800+800 tj 4800 kada to pretvorimo u kW 4800/1000 moramo dobiti 4.8 sto je tocno onom sto je u tablici potrosnja dobiveno sa 2 testna poziva procedure, sada cu je napraviti kao job tj. event za svaki dan
CALL p_dnevna_potrosnja(CURDATE());

CREATE EVENT job_obracun_dnevne_potrosnje
ON SCHEDULE EVERY 1 DAY
DO
	CALL p_dnevna_potrosnja(CURDATE());
	

SELECT *
FROM potrosnja;
SELECT *
FROM pracenje_statusa_posluzitelja;

-- Procedura koja vraca broj izmjena kod pojedinog uredjaja pracenjem iz statusa uredjaja.

DELIMITER //
CREATE PROCEDURE p_broj_izmjena_na_uredjaju(IN p_vrsta_uredjaja VARCHAR(255), IN p_id_uredjaja INTEGER, OUT broj_izmjena INTEGER)
BEGIN

DECLARE brojac INTEGER DEFAULT 0;
DECLARE fleg INTEGER DEFAULT 0;
DECLARE p_procesor_status VARCHAR(255);
DECLARE p_ram_status VARCHAR(255);
DECLARE p_ssd_status VARCHAR(255);
DECLARE p_temperatura_status VARCHAR(255);
DECLARE p_PDU_status VARCHAR(255);
DECLARE p_UPS_status VARCHAR(255);


DECLARE moj_kursor_posluzitelj CURSOR FOR
SELECT procesor_status, ram_status, ssd_status
FROM pracenje_statusa_posluzitelja
WHERE id_posluzitelj = p_id_uredjaja;


DECLARE moj_kursor_rack CURSOR FOR
SELECT temperatura_status, pdu_status, ups_status
FROM pracenje_statusa_racka
WHERE id_rack = p_id_uredjaja;

DECLARE CONTINUE HANDLER FOR NOT FOUND SET fleg = 1;

IF p_vrsta_uredjaja = 'posluzitelj' THEN
	OPEN moj_kursor_posluzitelj;
	moja_petlja_posluzitelj:LOOP

		FETCH moj_kursor_posluzitelj INTO p_procesor_status, p_ram_status, p_ssd_status;
		
		IF fleg = 1 THEN
			LEAVE moja_petlja_posluzitelj;
		END IF;
		
		IF p_procesor_status IN ('Visoko opterecenje', 'Kritican') THEN
			SET brojac = brojac + 1;
		END IF;
		
		 IF p_ram_status IN ('Visoko opterecenje', 'Kritican') THEN
			SET brojac = brojac + 1;
		END IF;
		
		IF p_ssd_status IN ('Visoko opterecenje', 'Kritican') THEN
			SET brojac = brojac + 1;
		END IF;
		
		END LOOP moja_petlja_posluzitelj;
		CLOSE moj_kursor_posluzitelj;
ELSEIF p_vrsta_uredjaja = 'rack' THEN
	OPEN moj_kursor_rack;
	moja_petlja_rack:LOOP

		FETCH moj_kursor_rack INTO p_temperatura_status, p_pdu_status, p_ups_status;
		
		IF fleg = 1 THEN
			LEAVE moja_petlja_rack;
		END IF;
		
		IF p_temperatura_status = 'Kritican' THEN
			SET brojac = brojac + 1;
		END IF;
		
		 IF p_pdu_status = 'Kritican' THEN
			SET brojac = brojac + 1;
		END IF;
		
		IF p_ups_status = 'Kritican' THEN
			SET brojac = brojac + 1;
		END IF;
		
		END LOOP moja_petlja_rack;
		CLOSE moj_kursor_rack;
END IF;
    
    
    SET broj_izmjena = brojac;
END //
DELIMITER ;


CALL p_broj_izmjena_na_uredjaju('rack', 103, @izmjene);
SELECT @izmjene FROM DUAL;

-- Pogled koji vraca ukupnu potrosnju energije za mjesece u godini, moze raditi i za pojedinacni mjesec u godini(pogodno za pretrazivanje sa frontenda npr)

CREATE VIEW ukupna_energetska_potrosnja_po_mjesecima AS
SELECT 
    MONTH(datum) AS mjesec,       
    YEAR(datum) AS godina,        
    SUM(potrosnja_kw) AS ukupna_potrosnja
FROM potrosnja
GROUP BY YEAR(datum), MONTH(datum)
ORDER BY godina, mjesec; -- ostavljeno defaultno zbog ASC koji je pogodan za ovaj slucaj

SELECT * FROM ukupna_energetska_potrosnja_po_mjesecima;
SELECT * FROM potrosnja;

-- Pogled koji vraca najpopularniju opremu na temelju broja njezinog koristenja u konfiguracijama uredjaja
/* jos testirati
SELECT 
    o.id AS oprema_id,
    o.vrsta AS naziv_opreme,
    COUNT(*) AS broj_koristenja
FROM oprema o
LEFT JOIN (
    SELECT graficka_kartica AS oprema_id FROM konfiguracija_uredjaja WHERE graficka_kartica IS NOT NULL
    UNION ALL
    SELECT procesor FROM konfiguracija_uredjaja WHERE procesor IS NOT NULL
    UNION ALL
    SELECT SSD FROM konfiguracija_uredjaja WHERE SSD IS NOT NULL
    UNION ALL
    SELECT ram FROM konfiguracija_uredjaja WHERE ram IS NOT NULL
    UNION ALL
    SELECT dimenzije FROM konfiguracija_uredjaja WHERE dimenzije IS NOT NULL
    UNION ALL
    SELECT PDU FROM konfiguracija_uredjaja WHERE PDU IS NOT NULL
    UNION ALL
    SELECT patchpanel FROM konfiguracija_uredjaja WHERE patchpanel IS NOT NULL
    UNION ALL
    SELECT rack_rails FROM konfiguracija_uredjaja WHERE rack_rails IS NOT NULL
    UNION ALL
    SELECT UPS FROM konfiguracija_uredjaja WHERE UPS IS NOT NULL
    UNION ALL
    SELECT hladenje FROM konfiguracija_uredjaja WHERE hladenje IS NOT NULL
    UNION ALL
    SELECT switch FROM konfiguracija_uredjaja WHERE switch IS NOT NULL
    UNION ALL
    SELECT router FROM konfiguracija_uredjaja WHERE router IS NOT NULL
) AS svi_uredjaji ON o.id = svi_uredjaji.oprema_id
GROUP BY o.id, o.vrsta
ORDER BY broj_koristenja DESC
LIMIT 1;
*/


-- STATUS: Ono sto sam mislio napraviti za svoj dio sam napravio, morati cu jos nesto testirati jednom kada ponovno insertam rekorde za sve tablice 
-- Mozda u hodu ubacim jos neki cisti query ili view ako nam bude falilo toga za zahtjev projekta
-- Sadasnje stanje: JOB EVENTI: 1 TRIGGERI: 4 PROCEDURE: 9 Pogledi: 2 (od toga jedan materijaliziran), Cisit query 1
-- Od toga Procedure i triggeri rade vecinu smislenog posla nad mojim tablicama
-- Napravim index na tablici oprema

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Marko START 

CREATE TABLE Sigurnost_objekta (
    id_sigurnost INT PRIMARY KEY AUTO_INCREMENT,
    sigurnosne_kamere INT NOT NULL,
    vrste_alarma VARCHAR(200),
    broj_zastitara INT,
    razina_sigurnosti ENUM('Niska','Srednja','Visoka') NOT NULL
);

CREATE TABLE Fizicki_smjestaj (
    id_smjestaj INT PRIMARY KEY AUTO_INCREMENT,
    kontinent VARCHAR(50) NOT NULL,
    drzava VARCHAR(50) NOT NULL,
    regija VARCHAR(50),
    grad VARCHAR(50) NOT NULL,
    hala VARCHAR(50),
    prostor_kat VARCHAR(50),
    vremenska_zona VARCHAR(10),
    id_sigurnost INT,
    CONSTRAINT fk_fizicki_sigurnost 
       FOREIGN KEY (id_sigurnost) REFERENCES Sigurnost_objekta(id_sigurnost)
);

CREATE TABLE Rack (
    id_rack INT PRIMARY KEY AUTO_INCREMENT,
    id_konfiguracija INT,
    id_smjestaj INT NOT NULL,
    kategorija ENUM('server_rack','mrezni_rack','drugo') NOT NULL,
    CONSTRAINT fk_rack_fizicki 
       FOREIGN KEY (id_smjestaj) REFERENCES Fizicki_smjestaj(id_smjestaj)
);



CREATE TABLE Zaposlenik (
    id_zaposlenik INT PRIMARY KEY AUTO_INCREMENT,
    ime VARCHAR(50) NOT NULL,
    prezime VARCHAR(50) NOT NULL,
    id_odjel INT,
    zanimanje VARCHAR(100) NOT NULL
);

CREATE TABLE Odrzavanje (
    id_odrzavanja INT PRIMARY KEY AUTO_INCREMENT,
    datum DATE NOT NULL,
    opis TEXT NOT NULL,
   id_posluzitelj INT NOT NULL,          
    id_zaposlenik INT NOT NULL,
    CONSTRAINT fk_odrzavanje_zaposlenik 
        FOREIGN KEY (id_zaposlenik) 
        REFERENCES Zaposlenik(id_zaposlenik)

);




INSERT INTO Sigurnost_objekta 
    (id_sigurnost, sigurnosne_kamere, vrste_alarma, broj_zastitara, razina_sigurnosti)
VALUES 
(1, 20, 'Protuprovalni, Protupožarni', 5, 'Visoka'),
(2, 15, 'Protuprovalni', 3, 'Srednja'),
(3, 10, 'Protupožarni', 2, 'Niska'),
(4, 30, 'Protuprovalni, Protupožarni, Detektori pokreta', 6, 'Visoka'),
(5, 5,  'Protuprovalni', 1, 'Niska'),
(6, 40, 'Detektori pokreta', 8, 'Visoka'),
(7, 8,  'Protuprovalni', 2, 'Niska'),
(8, 25, 'Protupožarni', 4, 'Srednja'),
(9, 50, 'Protuprovalni, Detektori pokreta', 10, 'Visoka'),
(10, 12, 'Protupožarni', 3, 'Niska'),
(11, 18, 'Protuprovalni, Protupožarni', 3, 'Srednja'),
(12, 60, 'Protuprovalni, Detektori pokreta', 12, 'Visoka'),
(13, 2,  'Protupožarni', 1, 'Niska'),
(14, 35, 'Detektori pokreta, Protupožarni', 7, 'Visoka'),
(15, 45, 'Protuprovalni', 9, 'Visoka'),
(16, 22, 'Protupožarni', 4, 'Srednja'),
(17, 6,  'Protuprovalni', 2, 'Niska'),
(18, 28, 'Protuprovalni, Detektori pokreta', 5, 'Srednja'),
(19, 55, 'Protuprovalni, Protupožarni, Detektori pokreta', 11, 'Visoka'),
(20, 10, 'Protupožarni', 2, 'Niska'),
(21, 1,  'Protuprovalni', 1, 'Niska'),
(22, 65, 'Protuprovalni, Protupožarni, Detektori pokreta', 12, 'Visoka');

INSERT INTO Fizicki_smjestaj 
    (id_smjestaj, kontinent, drzava, regija, grad, hala, prostor_kat, vremenska_zona, id_sigurnost)
VALUES 
(1, 'Europa', 'Hrvatska', 'Dalmacija',   'Split',       'Hala 1',  '1. kat',     'CET', 1),
(2, 'Europa', 'Hrvatska', 'Slavonija',   'Osijek',      'Hala 2',  'Prizemlje',  'CET', 2),
(3, 'Europa', 'Hrvatska', 'Zagorje',     'Zabok',       'Hala 3',  '2. kat',     'CET', 3),
(4, 'Europa', 'Njemačka', 'Bavarska',    'Minhen',      'Hala 4',  'Prizemlje',  'CET', 4),
(5, 'Sjeverna Amerika', 'SAD', 'Kalifornija', 'Los Angeles','Hala 5','1. kat',  'PST', 5),
(6, 'Azija', 'Japan', 'Kansai', 'Osaka', 'Hala 6','3. kat','JST', 6),
(7, 'Europa', 'Italija', 'Toskana', 'Firenca', 'Hala 7','Prizemlje','CET', 7),
(8, 'Australija','Australija','Novi Južni Wales','Sidnej','Hala 8','1. kat','AEST',8),
(9, 'Južna Amerika','Brazil','Rio de Janeiro','Rio','Hala 9','Prizemlje','BRT',9),
(10, 'Europa','Francuska','Ile-de-France','Pariz','Hala 10','2. kat','CET',10),
(11, 'Europa','Hrvatska','Istra','Pula','Hala 11','Prizemlje','CET',11),
(12, 'Azija','Kina','Guangdong','Guangzhou','Hala 12','1. kat','CST',12),
(13, 'Europa','Španjolska','Katalonija','Barcelona','Hala 13','2. kat','CET',13),
(14, 'Europa','Hrvatska','Zagreb','Zagreb','Hala 14','1. kat','CET',14),
(15, 'Europa','Hrvatska','Slavonija','Vinkovci','Hala 15','Prizemlje','CET',15),
(16, 'Azija','Indija','Maharashtra','Mumbai','Hala 16','3. kat','IST',16),
(17, 'Afrika','Egipat','Kairo','Kairo','Hala 17','1. kat','EET',17),
(18, 'Europa','Srbija','Vojvodina','Novi Sad','Hala 18','2. kat','CET',18),
(19, 'Sjeverna Amerika','Kanada','Ontario','Toronto','Hala 19','Prizemlje','EST',19),
(20, 'Europa','Grčka','Atika','Atena','Hala 20','2. kat','EET',20),
(21, 'Europa','Hrvatska','Istra','Rovinj','Hala 21','Podrum','CET',21),
(22, 'Europa','Hrvatska','Gorski Kotar','Delnice','Hala 22','1. kat','CET',22);


INSERT INTO Rack (id_rack, id_konfiguracija, id_smjestaj, kategorija)
VALUES
(1,  101, 1,  'server_rack'),
(2,  102, 2,  'mrezni_rack'),
(3,  103, 3,  'server_rack'),
(4,  104, 4,  'server_rack'),
(5,  105, 5,  'mrezni_rack'),
(6,  106, 6,  'server_rack'),
(7,  107, 7,  'mrezni_rack'),
(8,  108, 8,  'server_rack'),
(9,  109, 9,  'mrezni_rack'),
(10, 110, 10, 'server_rack'),
(11, 201, 11, 'server_rack'),
(12, 202, 12, 'mrezni_rack'),
(13, 203, 13, 'drugo'),
(14, 204, 14, 'server_rack'),
(15, 205, 15, 'mrezni_rack'),
(16, 206, 16, 'server_rack'),
(17, 207, 17, 'drugo'),
(18, 208, 18, 'mrezni_rack'),
(19, 209, 19, 'server_rack'),
(20, 210, 20, 'drugo'),
(21, 211, 21, 'mrezni_rack'),
(22, 212, 22, 'server_rack');



INSERT INTO Zaposlenik (id_zaposlenik, ime, prezime, id_odjel, zanimanje)
VALUES
(1,  'Ivan',    'Horvat', 1, 'Tehničar'),
(2,  'Ana',     'Kovač',  2, 'Inženjer'),
(3,  'Petar',   'Perić',  1, 'Administrator'),
(4,  'Marko',   'Jurić',  3, 'Sigurnosni stručnjak'),
(5,  'Lana',    'Novak',  4, 'Mrežni inženjer'),
(6,  'Tomislav','Barić',  1, 'Tehničar'),
(7,  'Jelena',  'Milić',  5, 'Projektni menadžer'),
(8,  'Karla',   'Ljubić', 2, 'Dizajner'),
(9,  'Filip',   'Marić',  4, 'Razvojni inženjer'),
(10, 'Sandra',  'Božić',  3, 'Menadžer sigurnosti'),
(11, 'Luka',    'Vidović',1, 'Sistem administrator'),
(12, 'Iva',     'Šarić',  5, 'Konzultant'),
(13, 'Marina',  'Lozić',  1, 'Računalni tehničar'),
(14, 'Josip',   'Babić',  2, 'Sistem inženjer'),
(15, 'Robert',  'Crnić',  3, 'Specijalist za sigurnost'),
(16, 'Mia',     'Sertić', 1, 'Tehničar'),
(17, 'Dario',   'Šimić',  4, 'Projektni koordinator'),
(18, 'Tihana',  'Vrban',  2, 'DevOps inženjer'),
(19, 'Goran',   'Bubalo', 3, 'Voditelj tima'),
(20, 'Anita',   'Kos',    2, 'QA inženjer'),
(21, 'Helena',  'Zorić',  1, 'Administrator bazepodataka'),
(22, 'Stjepan', 'Rajner', 5, 'Voditelj projekata'),
(23, 'Nikolina','Bašić',  1, 'Specijalist za baze podataka'),
(24, 'Damir',   'Hrgović',2, 'Inženjer sustava');


INSERT INTO Odrzavanje (id_odrzavanja, datum, opis, id_posluzitelj, id_zaposlenik)
VALUES
(16, '2025-01-17', 'Zamjena UPS baterija',                         5,  13),
(17, '2025-01-18', 'Čišćenje prašine i ventilacije',               2,  14),
(18, '2025-01-19', 'Optimizacija mrežnih postavki',                4,  15),
(19, '2025-01-20', 'Ponovno pokretanje servisa nakon pada',        8,  16),
(20, '2025-01-21', 'Provjera backupa i test vraćanja',             1,  17),
(21, '2025-01-22', 'Instalacija antivirusa',                       10, 18),
(22, '2025-01-23', 'Provjera RAID polja',                          3,  19),
(23, '2025-01-24', 'Ažuriranje operativnog sustava',               7,  20),
(24, '2025-01-25', 'Zamjena patch kabela',                         2,  21),
(25, '2025-01-26', 'Migracija virtualnih mašina',                  5,  22),
(26, '2025-01-27', 'Optimizacija hlađenja',                        6,  13),
(27, '2025-01-28', 'Nadogradnja BIOS-a',                           9,  14),
(28, '2025-01-29', 'Praćenje performansi 24h test',                10, 15),
(29, '2025-01-30', 'Zamjena mrežnog switcha',                      4,  16),
(30, '2025-02-01', 'Testiranje redundancije napajanja',            1,  17),
(31, '2025-02-02', 'Zamjena dotrajalih kabela unutar racka 21',    2,  23),
(32, '2025-02-03', 'Nadogradnja sigurnosnih postavki OS-a',        5,  24);

SELECT * FROM Sigurnost_objekta;
SELECT * FROM Fizicki_smjestaj;
SELECT * FROM Rack;
SELECT * FROM Zaposlenik;
SELECT * FROM Održavanje;

-- -- -- -- -- --
-- UPITI

-- pregled svih rackova s detaljima o njihovoj lokaciji i sigurnosti
CREATE VIEW RackDetalji AS
SELECT 
    r.id_rack,
    r.kategorija,
    f.grad,
    f.hala,
    f.prostor_kat,
    s.sigurnosne_kamere,
    s.razina_sigurnosti
FROM Rack r
JOIN Fizicki_smjestaj f ON r.id_smjestaj = f.id_smjestaj
JOIN Sigurnost_objekta s ON f.id_sigurnost = s.id_sigurnost;


-- dodavanje novog racka
DELIMITER //

CREATE PROCEDURE DodajRack(
    IN p_id_konfiguracija INT,
    IN p_id_smjestaj INT,
    IN p_kategorija ENUM('server_rack', 'patch_rack', 'drugo')
)
BEGIN
    INSERT INTO Rack (id_konfiguracija, id_smjestaj, kategorija)
    VALUES (p_id_konfiguracija, p_id_smjestaj, p_kategorija);
END //

DELIMITER ;

-- dobijanje ukupnog broja zaposlenika u određenom odjelu

DELIMITER //

CREATE FUNCTION BrojZaposlenikaUOdjelu(p_id_odjel INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (SELECT COUNT(*) 
            FROM Zaposlenik 
            WHERE id_odjel = p_id_odjel);
END //

DELIMITER ;

-- Marko KRAJ za sada 

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
