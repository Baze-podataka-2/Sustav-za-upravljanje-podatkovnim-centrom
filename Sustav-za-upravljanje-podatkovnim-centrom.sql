DROP DATABASE IF EXISTS datacentar;
CREATE DATABASE datacentar;
USE datacentar;

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
    id_troskovi_datacentra INT PRIMARY KEY AUTO_INCREMENT,
    id_potrosnja INT,
    id_licenca VARCHAR(50)
    -- FOREIGN KEY (id_potrosnja) REFRENCES potrosnja(id_potrosnja)
);

INSERT INTO usluge (vrsta, cijena) VALUES     ("FREE" ,0.0 ),
                                              ("START" ,4.99 ),
                                              ("PRO" ,9.99 ),
                                              ("PRO+" ,39.99 ),
                                              ("ENTERPRISE", 99.99);

INSERT INTO klijenti (ime, prezime, oib) VALUES     ('Ivan', 'Horvat', 12345678901),
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
                                                    ('Jelena', 'Rogić', 66789012345);


INSERT INTO usluge_klijenata (id_klijent, id_usluga, pocetak_usluge, kraj_usluge) VALUES
                                                    (1, 1, STR_TO_DATE('2024-01-15', '%Y-%m-%d'), STR_TO_DATE('2024-04-10', '%Y-%m-%d')),
                                                    (2, 2, STR_TO_DATE('2023-03-20', '%Y-%m-%d'), STR_TO_DATE('2023-06-12', '%Y-%m-%d')),
                                                    (3, 3, STR_TO_DATE('2024-05-03', '%Y-%m-%d'), STR_TO_DATE('2024-07-25', '%Y-%m-%d')),
                                                    (4, 4, STR_TO_DATE('2024-02-28', '%Y-%m-%d'), STR_TO_DATE('2024-05-17', '%Y-%m-%d')),
                                                    (5, 5, STR_TO_DATE('2025-01-22', '%Y-%m-%d'), STR_TO_DATE('2025-04-19', '%Y-%m-%d')),
                                                    (6, 1, STR_TO_DATE('2023-06-11', '%Y-%m-%d'), STR_TO_DATE('2023-08-27', '%Y-%m-%d')),
                                                    (7, 2, STR_TO_DATE('2024-09-14', '%Y-%m-%d'), STR_TO_DATE('2024-12-01', '%Y-%m-%d')),
                                                    (8, 3, STR_TO_DATE('2025-02-08', '%Y-%m-%d'), STR_TO_DATE('2025-04-22', '%Y-%m-%d')),
                                                    (9, 4, STR_TO_DATE('2024-07-19', '%Y-%m-%d'), STR_TO_DATE('2024-10-04', '%Y-%m-%d')),
                                                    (10, 5, STR_TO_DATE('2024-11-02', '%Y-%m-%d'), STR_TO_DATE('2025-01-15', '%Y-%m-%d')),
                                                    (11, 1, STR_TO_DATE('2023-04-07', '%Y-%m-%d'), STR_TO_DATE('2023-06-30', '%Y-%m-%d')),
                                                    (12, 2, STR_TO_DATE('2024-10-05', '%Y-%m-%d'), STR_TO_DATE('2025-01-01', '%Y-%m-%d')),
                                                    (13, 3, STR_TO_DATE('2023-07-13', '%Y-%m-%d'), STR_TO_DATE('2023-10-08', '%Y-%m-%d')),
                                                    (14, 4, STR_TO_DATE('2024-03-21', '%Y-%m-%d'), STR_TO_DATE('2024-06-10', '%Y-%m-%d')),
                                                    (15, 5, STR_TO_DATE('2024-12-09', '%Y-%m-%d'), STR_TO_DATE('2025-02-28', '%Y-%m-%d'));
-- -------------------

-- Mario FUNKCIJE I OSTALO --

-- ------------------- STATS -> Br.Procedura: 1, Br.Funkcija: 2, Br.Trigger: 2

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

    -- Test Triggera

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

INSERT INTO racuni_prema_klijentima (id_usluga_klijent) VALUES(15);
SELECT * FROM racuni_prema_klijentima;







-- Mario KRAJ


-- --- --- --- --- --- --- --- --- --- ---


-- Ronan START


-- Kreiranje tablica
CREATE TABLE Posluzitelj (
    id_posluzitelj INT AUTO_INCREMENT PRIMARY KEY,
    id_konfiguracija INT NOT NULL,
    id_rack INT NOT NULL,
    id_smjestaj INT NOT NULL,
    kategorija VARCHAR(50) NOT NULL
);
drop table  Posluzitelj;
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

INSERT INTO Posluzitelj (id_konfiguracija, id_rack, id_smjestaj, kategorija) VALUES
(101, 201, 301, 'Web Hosting poslužitelj'),
(102, 202, 302, 'Storage poslužitelj'),
(103, 203, 303, 'Machine Learning poslužitelj'),
(104, 204, 304, 'Proxy poslužitelj'),
(105, 205, 305, 'Backup poslužitelj'),
(106, 206, 306, 'DNS poslužitelj'),
(107, 207, 307, 'Mail poslužitelj'),
(108, 208, 308, 'FTP poslužitelj'),
(109, 209, 309, 'Hypervisor Tip 1'),
(110, 210, 310, 'Streaming poslužitelj'),
(111, 211, 311, 'VoIP poslužitelj'),
(112, 212, 312, 'IoT Gateway poslužitelj'),
(113, 213, 313, 'Load Balancer poslužitelj'),
(114, 214, 314, 'Cache poslužitelj'),
(115, 215, 315, 'Testni poslužitelj'),
(116, 216, 316, 'Web poslužitelj'),
(117, 217, 317, 'Baza podataka'),
(118, 218, 318, 'Aplikacijski poslužitelj'),
(119, 219, 319, 'Big Data poslužitelj'),
(120, 220, 320, 'Firewall poslužitelj'),
(121, 221, 321, 'Data Warehouse poslužitelj'),
(122, 222, 322, 'Streaming Media poslužitelj'),
(123, 223, 323, 'Raspberry Pi Cluster poslužitelj'),
(124, 224, 324, 'VPN Gateway poslužitelj'),
(125, 225, 325, 'File Server poslužitelj'),
(126, 226, 326, 'Analytics poslužitelj'),
(127, 227, 327, 'Edge Computing poslužitelj'),
(128, 228, 328, 'CI/CD Pipeline poslužitelj'),
(129, 229, 329, 'Log Management poslužitelj'),
(130, 230, 330, 'Hybrid Cloud poslužitelj');

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
(15, 'Praćenje usluga'),
(16, 'Praćenje memorije'),
(17, 'Praćenje temperature'),
(18, 'Praćenje ventilatora'),
(19, 'Praćenje RAID statusa'),
(20, 'Praćenje I/O operacija'),
(21, 'Praćenje baze podataka'),
(22, 'Praćenje aplikacijskih logova'),
(23, 'Praćenje vremena zastoja'),
(24, 'Praćenje sigurnosnih zakrpa'),
(25, 'Praćenje mrežnih latencija'),
(26, 'Praćenje DNS zahtjeva'),
(27, 'Praćenje e-pošte'),
(28, 'Praćenje virtualnih strojeva'),
(29, 'Praćenje mrežnih protokola'),
(30, 'Praćenje udaljenih veza');

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
('2025-01-15', 'Backup nije uspješan', 15, 'U tijeku'),
('2025-01-16', 'Visoka upotreba CPU-a', 16, 'Otvoreno'),
('2025-01-17', 'Problemi s virtualizacijom', 17, 'Riješen'),
('2025-01-18', 'Neispravno preusmjeravanje portova', 18, 'U tijeku'),
('2025-01-19', 'Povećana latencija u mreži', 19, 'Otvoreno'),
('2025-01-20', 'Nedostupnost usluga', 20, 'Riješen'),
('2025-01-21', 'Problemi s sigurnosnim zakrpama', 21, 'U tijeku'),
('2025-01-22', 'Greška u konfiguraciji sustava', 22, 'Otvoreno'),
('2025-01-23', 'Pregrijavanje uređaja', 23, 'Riješen'),
('2025-01-24', 'Greška u sinkronizaciji podataka', 24, 'U tijeku'),
('2025-01-25', 'Neispravni sigurnosni certifikati', 25, 'Otvoreno'),
('2025-01-26', 'Pad aplikacijskog servisa', 26, 'Riješen'),
('2025-01-27', 'Propusnost mreže je niska', 27, 'U tijeku'),
('2025-01-28', 'Problemi s pohranom podataka', 28, 'Otvoreno'),
('2025-01-29', 'Nedostupnost backup servera', 29, 'Riješen'),
('2025-01-30', 'Problemi s autentifikacijom', 30, 'U tijeku');

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
(15, 'Ponovno učitavanje usluge', '2025-01-15 17:20:00', 'service_admin'),
(16, 'Testiranje novog API-ja', '2025-01-16 14:00:00', 'api_team'),
(17, 'Postavljanje SSL certifikata', '2025-01-17 11:30:00', 'security_admin'),
(18, 'Pregled sistemskih resursa', '2025-01-18 09:45:00', 'sys_monitor'),
(19, 'Arhiviranje starih podataka', '2025-01-19 16:00:00', 'archive_team'),
(20, 'Ažuriranje korisničkog profila', '2025-01-20 12:15:00', 'user_support'),
(21, 'Praćenje mrežnog prometa', '2025-01-21 10:20:00', 'net_ops'),
(22, 'Nadogradnja virtualnog poslužitelja', '2025-01-22 13:30:00', 'cloud_admin'),
(23, 'Optimizacija performansi aplikacije', '2025-01-23 15:10:00', 'devops_team'),
(24, 'Dodavanje nove domene', '2025-01-24 09:50:00', 'dns_admin'),
(25, 'Provjera dnevnika grešaka', '2025-01-25 14:25:00', 'error_handling'),
(26, 'Resetiranje mrežnih uređaja', '2025-01-26 17:40:00', 'network_admin'),
(27, 'Izrada novog sigurnosnog pravila', '2025-01-27 08:10:00', 'security_team'),
(28, 'Promjena konfiguracije servisa', '2025-01-28 11:55:00', 'service_admin'),
(29, 'Testiranje redundancije sustava', '2025-01-29 19:00:00', 'redundancy_ops'),
(30, 'Povrat podataka iz sigurnosne kopije', '2025-01-30 03:30:00', 'backup_admin');



select * from Logovi;
select * from Posluzitelj;
select * from Incidenti;
select * from Monitoring;
-- Ronan END

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

-- Adis START

CREATE TABLE oprema (
 id SERIAL PRIMARY KEY,
 vrsta VARCHAR(255) NOT NULL,
 specifikacije VARCHAR(255) NOT NULL,
 stanje_na_zalihama INTEGER NOT NULL
 -- id_dobavljac INTEGER,
 -- FOREIGN KEY (id_dobavljac) REFERENCES dobavljac(id)
);

CREATE TABLE konfiguracija_uredjaja (
	id SERIAL PRIMARY KEY,
    graficka_kartica BIGINT UNSIGNED DEFAULT NULL, -- 'Rack ne sadrzi',
    procesor BIGINT UNSIGNED DEFAULT NULL, -- 'Rack ne sadrzi',
    SSD BIGINT UNSIGNED DEFAULT NULL, -- 'Rack ne sadrzi',
    ram BIGINT UNSIGNED DEFAULT NULL, -- 'Rack ne sadrzi',
    IP_adresa VARCHAR(45) DEFAULT NULL, --  'Standardni rack ne sadrzi',
    dimenzije BIGINT UNSIGNED DEFAULT NULL, -- 'Posluzitelj ne sadrzi',
    PDU BIGINT UNSIGNED DEFAULT NULL, -- 'Posluzitelj ne sadrzi',
    patchpanel BIGINT UNSIGNED DEFAULT NULL, --  'Posluzitelj ne sadrzi',
    rack_rails BIGINT UNSIGNED DEFAULT NULL, -- 'Posluzitelj ne sadrzi',
    UPS BIGINT UNSIGNED DEFAULT NULL, -- 'Posluzitelj ne sadrzi',
    hladenje BIGINT UNSIGNED DEFAULT NULL, -- 'Posluzitelj ne sadrzi',
    switch BIGINT UNSIGNED DEFAULT NULL, -- 'Posluzitelj, standardni rack ne sadrze',
    router BIGINT UNSIGNED DEFAULT NULL, -- 'Posluzitelj, standardni rack ne sadrze',
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
	id SERIAL PRIMARY KEY,
    -- id_posluzitelj INT NOT NULL,
    procesor_status VARCHAR(255) NOT NULL,
    ram_status VARCHAR(255) NOT NULL,
    ssd_status VARCHAR(255) NOT NULL,
    temperatura_status VARCHAR(255) NOT NULL,
    vrijeme_statusa TIMESTAMP NOT NULL
	-- FOREIGN KEY (id_posluzitelj) REFERENCES posluzitelj(id)
);

CREATE TABLE pracenje_statusa_racka (
	id SERIAL PRIMARY KEY,
    -- id_rack INT NOT NULL,
    temperatura_status VARCHAR(255) NOT NULL,
    popunjenost_status VARCHAR(255) NOT NULL,
    pdu_status VARCHAR(255) NOT NULL,
    ups_status VARCHAR(255) NOT NULL,
    bandwith_status_switch VARCHAR(255) NOT NULL DEFAULT 'Standardni rack',
    interface_status_router VARCHAR(255) NOT NULL DEFAULT 'Standardni rack',
	vrijeme_statusa TIMESTAMP NOT NULL
    -- FOREIGN KEY (id_rack) REFERENCES rack(id)
);


CREATE TABLE potrosnja (
	id SERIAL PRIMARY KEY,
    potrosnja_kw DECIMAL(10, 2) NOT NULL,
    datum DATE NOT NULL
    -- napraviti kao materijalizirani pogled na kraju dana na temelju podataka iz pracenje_statusa_servera i pracenje_statusa_racka
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
INSERT INTO konfiguracija_uredjaja (graficka_kartica, procesor, SSD, ram, IP_adresa, dimenzije, PDU, rack_rails, UPS, hladenje)
VALUES
(1, 26, 51, 76, '192.168.1.1', 201, 101, 126, 151, 176),
(2, 27, 52, 77, '192.168.1.2', 202, 102, 127, 152, 177),
(3, 28, 53, 78, '192.168.1.3', 203, 103, 128, 153, 178),
(4, 29, 54, 79, '192.168.1.4', 204, 104, 129, 154, 179),
(5, 30, 55, 80, '192.168.1.5', 205, 105, 130, 155, 180),
(6, 31, 56, 81, '192.168.1.6', 206, 106, 131, 156, 181),
(7, 32, 57, 82, '192.168.1.7', 207, 107, 132, 157, 182),
(8, 33, 58, 83, '192.168.1.8', 208, 108, 133, 158, 183),
(9, 34, 59, 84, '192.168.1.9', 209, 109, 134, 159, 184),
(10, 35, 60, 85, '192.168.1.10', 210, 110, 135, 160, 185),
(11, 36, 61, 86, '192.168.1.11', 211, 111, 136, 161, 186),
(12, 37, 62, 87, '192.168.1.12', 212, 112, 137, 162, 187),
(13, 38, 63, 88, '192.168.1.13', 213, 113, 138, 163, 188),
(14, 39, 64, 89, '192.168.1.14', 214, 114, 139, 164, 189),
(15, 40, 65, 90, '192.168.1.15', 215, 115, 140, 165, 190),
(16, 41, 66, 91, '192.168.1.16', 216, 116, 141, 166, 191),
(17, 42, 67, 92, '192.168.1.17', 217, 117, 142, 167, 192),
(18, 43, 68, 93, '192.168.1.18', 218, 118, 143, 168, 193),
(19, 44, 69, 94, '192.168.1.19', 219, 119, 144, 169, 194),
(20, 45, 70, 95, '192.168.1.20', 220, 120, 145, 170, 195),
(21, 46, 71, 96, '192.168.1.21', 221, 121, 146, 171, 196),
(22, 47, 72, 97, '192.168.1.22', 222, 122, 147, 172, 197),
(23, 48, 73, 98, '192.168.1.23', 223, 123, 148, 173, 198),
(24, 49, 74, 99, '192.168.1.24', 224, 124, 149, 174, 199),
(25, 50, 75, 100, '192.168.1.25', 225, 125, 150, 175, 200);


-- standardni rackovi
INSERT INTO konfiguracija_uredjaja (dimenzije, PDU, patchpanel, rack_rails, UPS, hladenje)
VALUES
(201, 101, 126, 151, 176, 201),
(202, 102, 127, 152, 177, 202),
(203, 103, 128, 153, 178, 203),
(204, 104, 129, 154, 179, 204),
(205, 105, 130, 155, 180, 205),
(206, 106, 131, 156, 181, 206),
(207, 107, 132, 157, 182, 207),
(208, 108, 133, 158, 183, 208),
(209, 109, 134, 159, 184, 209),
(210, 110, 135, 160, 185, 210),
(211, 111, 136, 161, 186, 211),
(212, 112, 137, 162, 187, 212);


-- mrezni rackovi
INSERT INTO konfiguracija_uredjaja (dimenzije, PDU, patchpanel, rack_rails, UPS, hladenje, switch, router)
VALUES
(213, 113, 138, 163, 188, 213, 226, 251),
(214, 114, 139, 164, 189, 214, 227, 252),
(215, 115, 140, 165, 190, 215, 228, 253),
(216, 116, 141, 166, 191, 216, 229, 254),
(217, 117, 142, 167, 192, 217, 230, 255),
(218, 118, 143, 168, 193, 218, 231, 256),
(219, 119, 144, 169, 194, 219, 232, 257),
(220, 120, 145, 170, 195, 220, 233, 258),
(221, 121, 146, 171, 196, 221, 234, 259),
(222, 122, 147, 172, 197, 222, 235, 260),
(223, 123, 148, 173, 198, 223, 236, 261),
(224, 124, 149, 174, 199, 224, 237, 262),
(225, 125, 150, 175, 200, 225, 238, 263);

-- Adis END za sada :)
