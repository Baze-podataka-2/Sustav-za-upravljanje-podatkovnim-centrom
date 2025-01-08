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

-- ------------------- STATS -> Br.Procedura: 1, Br.Funkcija: 2

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








-- Mario KRAJ


-- --- --- --- --- --- --- --- --- --- ---


-- Ronan START


-- Kreiranje tablica
CREATE TABLE Server (
    id_server INT AUTO_INCREMENT PRIMARY KEY,
    id_konfiguracija INT NOT NULL,
    id_rack INT NOT NULL,
    id_smjestaj INT NOT NULL,
    kategorija VARCHAR(50) NOT NULL
);

CREATE TABLE Monitoring (
    id_monitoring INT AUTO_INCREMENT PRIMARY KEY,
    id_server INT NOT NULL,
    vrsta VARCHAR(50) NOT NULL,
    FOREIGN KEY (id_server) REFERENCES Server(id_server)
);

CREATE TABLE Incidenti (
    id_incidenta INT AUTO_INCREMENT PRIMARY KEY,
    datum DATE NOT NULL,
    opis TEXT NOT NULL,
    id_server INT NOT NULL,
    status VARCHAR(20) NOT NULL,
    FOREIGN KEY (id_server) REFERENCES Server(id_server)
);

CREATE TABLE Logovi (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    id_server INT NOT NULL,
    akcija VARCHAR(100) NOT NULL,
    datum DATETIME NOT NULL,
    user VARCHAR(50) NOT NULL,
    FOREIGN KEY (id_server) REFERENCES Server(id_server)
);

-- Server
INSERT INTO Server (id_konfiguracija, id_rack, id_smjestaj, kategorija) VALUES
(101, 201, 301, 'Web poslužitelj'),
(102, 202, 302, 'Baza podataka'),
(103, 203, 303, 'Aplikacijski poslužitelj'),
(104, 204, 304, 'Proxy poslužitelj'),
(105, 205, 305, 'Backup poslužitelj'),
(106, 206, 306, 'DNS poslužitelj'),
(107, 207, 307, 'Mail poslužitelj'),
(108, 208, 308, 'FTP poslužitelj'),
(109, 209, 309, 'Virtualizacijski poslužitelj'),
(110, 210, 310, 'Streaming poslužitelj'),
(111, 211, 311, 'VoIP poslužitelj'),
(112, 212, 312, 'IoT Gateway'),
(113, 213, 313, 'Load Balancer'),
(114, 214, 314, 'Cache poslužitelj'),
(115, 215, 315, 'Testni poslužitelj');

-- Monitoring
INSERT INTO Monitoring (id_server, vrsta) VALUES
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
INSERT INTO Incidenti (datum, opis, id_server, status) VALUES
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
INSERT INTO Logovi (id_server, akcija, datum, user) VALUES
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
select * from Server;
select * from Incidenti;
select * from Monitoring;
-- Ronan END
