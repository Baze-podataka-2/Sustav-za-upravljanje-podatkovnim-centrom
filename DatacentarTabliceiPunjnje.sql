DROP DATABASE IF EXISTS datacentar;
CREATE DATABASE datacentar;
USE datacentar;


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



CREATE TABLE credit(
    id_credit INT AUTO_INCREMENT PRIMARY KEY,
    iznos FLOAT NOT NULL,
    id_klijent_credit INT,
    FOREIGN KEY (id_klijent_credit) REFERENCES klijenti(id_klijent)
);

CREATE TABLE dugovanja(
    id_dugovanje INT AUTO_INCREMENT PRIMARY KEY,
    iznos_dugovanja FLOAT,
    id_klijent_dugovanje INT,
    status VARCHAR(100)
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
            -- 10
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
           -- 20
                                                ('Lea', 'Vlahović', 12123456781),
                                                ('Toni', 'Križan', 13123456782),
                                                ('Marta', 'Soldo', 14123456783),
                                                ('Viktor', 'Pavlović', 15123456784),
                                                ('Nika', 'Grgurić', 16123456785),
                                                ('Milan', 'Šeparović', 17123456786),
                                                ('Klara', 'Banić', 18123456787),
                                                ('Ruža', 'Kovačić', 19123456788),
                                                ('Ingrid', 'Trava', 15123498326),
                                                ('Marko', 'Šimunić', 12351237543),
           -- 30
                                                ('Ksenija', 'Benežić', 1816755985),
                                                ('Ružaica', 'Kovač', 19123098788),
                                                ('Ingrid', 'Tenezić', 12356512379);
                                                
                                                
SELECT * FROM klijenti;
-- PRVO NAPRAVITI TRIGGER KontrolaDatuma kako bi se sprijecli upisi neispravnih datuma!
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
                                          (29, 4, STR_TO_DATE('2024-11-15', '%Y-%m-%d'), STR_TO_DATE('2025-02-14', '%Y-%m-%d')),
                                          (30, 3, STR_TO_DATE('2024-06-21', '%Y-%m-%d'), STR_TO_DATE('2024-09-13', '%Y-%m-%d')),
                                          (31, 5, STR_TO_DATE('2025-08-02', '%Y-%m-%d'), STR_TO_DATE('2025-12-11', '%Y-%m-%d')),
                                          (32, 4, STR_TO_DATE('2024-01-15', '%Y-%m-%d'), STR_TO_DATE('2025-03-11', '%Y-%m-%d')),
                                          (33, 3, STR_TO_DATE('2024-06-01', '%Y-%m-%d'), STR_TO_DATE('2025-09-13', '%Y-%m-%d'));




-- PRVO NAPRAVITI TIRGGER IznosRacuna i IznosRacunaUpdate!!!
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
                                                                (29),
																(30),
                                                                (31),
                                                                (32),
                                                                (33);



-- PRVO NAPRAVITI TRIGGER CreditAzuriranje!!!
INSERT INTO credit(iznos, id_klijent_credit) VALUES
                                                        (1, 1),
                                                        (100, 1),
                                                        (12, 2),
                                                        (1000.12, 3),
                                                        (0, 4),
                                                        (11.56, 5),
                                                        (123, 6),
                                                        (56, 7),
                                                        (12, 8),
                                                        (22, 9),
                                                        (332, 10),
                                                        (111, 11),
                                                        (12, 12),
                                                        (13, 13),
                                                        (14, 14),
                                                        (1400, 15),
                                                        (16, 16),
                                                        (12, 17),
                                                        (18.43, 18),
                                                        (642, 19),
                                                        (20, 20),
                                                        (21, 21),
                                                        (22, 22),
                                                        (23, 23),
                                                        (275, 24),
                                                        (25, 25),
                                                        (26, 26),
                                                        (27, 27),
                                                        (28, 28),
                                                        (29, 29),
                                                        (600, 30),
                                                        (550, 31),
                                                        (510, 32),
                                                        (520, 33);
                                                        
                                                        
CREATE TABLE Dobavljaci (
    id_dobavljac INT PRIMARY KEY AUTO_INCREMENT,
    ime VARCHAR(100) NOT NULL,
    oib VARCHAR(11) NOT NULL UNIQUE,
    opis TEXT
);

INSERT INTO Dobavljaci (id_dobavljac, ime, oib, opis)
VALUES
(1, 'IT Solutions', '12345678901', 'Dobavljač IT opreme i softvera.'),
(2, 'Tech Supply', '98765432109', 'Specijalizirani za mrežnu opremu.'),
(3, 'Hardware Hub', '56473829101', 'Dobavljač hardverskih komponenti.'),
(4, 'Network Builders', '45612378902', 'Dobavljač mrežne infrastrukture.'),
(5, 'Cloud Providers', '78945612303', 'Specijalizirani za cloud tehnologije.'),
(6, 'Secure Systems', '32165498706', 'Dobavljač sigurnosnih sustava.'),
(7, 'Data Dynamics', '74185296307', 'Dobavljač podatkovnih rješenja.'),
(8, 'Alpha Tech', '85274196308', 'Opća IT oprema i softver.'),
(9, 'Beta Supplies', '96385274109', 'Nabava kablova i konektora.'),
(10, 'Gamma Solutions', '14725836910', 'Specijalizirani za UPS sustave.'),
(11, 'Delta Networks', '25836914711', 'Mrežne infrastrukture i servisi.'),
(12, 'Zeta Systems', '36914725812', 'Backup i recovery rješenja.'),
(13, 'Theta Supplies', '45678912313', 'Oprema za ventilaciju i hlađenje.'),
(14, 'Omicron Hardware', '12378945614', 'Hardware specijalizacije.'),
(15, 'Lambda Tech', '78912345615', 'Nabava server rack opreme.'),
(16, 'Sigma Power', '45612378916', 'Napajanje i distribucija energije.'),
(17, 'Omega Support', '32198765417', 'IT konzultacije i podrška.'),
(18, 'Epsilon Hardware', '65432198718', 'Komponente za IT sustave.'),
(19, 'Iota Systems', '98765412319', 'Infrastruktura i tehnologije.'),
(20, 'Kappa Networks', '15975348620', 'Napredni mrežni sustavi.');       

                                                 
                                                        
CREATE TABLE oprema ( 
 id INT PRIMARY KEY AUTO_INCREMENT,
 vrsta VARCHAR(255) NOT NULL,
 specifikacije VARCHAR(255) NOT NULL,
 stanje_na_zalihama INTEGER NOT NULL,
 id_dobavljac INTEGER NOT NULL,
 FOREIGN KEY (id_dobavljac) REFERENCES Dobavljaci(id_dobavljac)
);


ALTER TABLE oprema
ADD CONSTRAINT 
CHK_Vrsta 
	CHECK (vrsta IN ('Grafička kartica', 'Procesor', 'SSD', 'RAM', 'Dimenzije', 'PDU', 'Patchpanel', 
    'Rack Rails', 'UPS', 'Hlađenje', 'Switch', 'Router')); -- popraviti na kraju prema nazivima iz rekorda koji su vec unutra

CREATE INDEX idx_vrsta ON oprema(vrsta);


CREATE TABLE konfiguracija_uredjaja (
	id INT PRIMARY KEY AUTO_INCREMENT,
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

-- Tablica oprema, punjeno redoslijedom radi lakseg razumijevanja rasporeda podataka. 
-- Redoslijed takoder predstavlja jacinu opreme. Tako je prvi id te opreme najslabiji, a zadnji najjaci. Sto ce nam dodatno osigurati ispravan rad 
-- Procedura koje mijenjaju kompoente nekog uredjaj

-- graficke kartice
INSERT INTO oprema (vrsta, specifikacije, stanje_na_zalihama, id_dobavljac)
VALUES
  -- (1) Najslabija
  ('Grafička kartica', 'Intel Iris Xe Max, 4GB LPDDR4X', 6, 3),
  -- (2)
  ('Grafička kartica', 'NVIDIA Quadro T1000, 4GB GDDR6', 7, 3),
  -- (3)
  ('Grafička kartica', 'AMD Radeon RX 5500, 4GB GDDR6', 12, 3),
  -- (4)
  ('Grafička kartica', 'AMD Radeon RX 6500 XT, 4GB GDDR6', 10, 3),
  -- (5)
  ('Grafička kartica', 'NVIDIA GTX 1660 Super, 6GB GDDR6', 11, 3),
  -- (6)
  ('Grafička kartica', 'AMD RX 6600 XT, 8GB GDDR6', 10, 3),
  -- (7)
  ('Grafička kartica', 'NVIDIA RTX 2000, 8GB GDDR6', 15, 3),
  -- (8)
  ('Grafička kartica', 'AMD RX Vega 64, 8GB HBM2', 10, 3),
  -- (9)
  ('Grafička kartica', 'NVIDIA GTX 1080 Ti, 11GB GDDR5X', 9, 3),
  -- (10)
  ('Grafička kartica', 'NVIDIA RTX 3050, 8GB GDDR6', 8, 3),
  -- (11)
  ('Grafička kartica', 'AMD Radeon RX 6800, 16GB GDDR6', 7, 3),
  -- (12)
  ('Grafička kartica', 'AMD Radeon VII, 16GB HBM2', 14, 3),
  -- (13)
  ('Grafička kartica', 'AMD Radeon RX 7900, 24GB GDDR6', 7, 3),
  -- (14)
  ('Grafička kartica', 'AMD Radeon Pro VII, 16GB HBM2', 7, 3),
  -- (15)
  ('Grafička kartica', 'NVIDIA RTX 4000 Ada, 20GB GDDR6', 9, 3),
  -- (16)
  ('Grafička kartica', 'NVIDIA RTX 5000, 16GB GDDR6', 13, 3),
  -- (17)
  ('Grafička kartica', 'NVIDIA Tesla K80, 24GB GDDR5', 8, 3),
  -- (18)
  ('Grafička kartica', 'NVIDIA Tesla P100, 16GB HBM2', 9, 3),
  -- (19)
  ('Grafička kartica', 'NVIDIA RTX 6000 Ada, 48GB GDDR6', 11, 3),
  -- (20)
  ('Grafička kartica', 'NVIDIA Quadro RTX 8000, 48GB GDDR6', 12, 3),
  -- (21)
  ('Grafička kartica', 'NVIDIA Tesla V100, 32GB HBM2', 10, 3),
  -- (22)
  ('Grafička kartica', 'AMD Instinct MI100, 32GB HBM2', 5, 3),
  -- (23)
  ('Grafička kartica', 'NVIDIA A100, 40GB HBM2', 6, 3),
  -- (24)
  ('Grafička kartica', 'NVIDIA RTX 3090, 24GB GDDR6X', 15, 3),
  -- (25) Najjača
  ('Grafička kartica', 'NVIDIA GeForce RTX 4080, 16GB GDDR6X', 13, 3);
  
-- Procesori
INSERT INTO oprema (vrsta, specifikacije, stanje_na_zalihama, id_dobavljac)
VALUES
  -- (1) Najslabiji
  ('Procesor', 'Intel Xeon D-1602, 2 jezgra, 2.5 GHz', 9, 3),
  -- (2)
  ('Procesor', 'Intel Pentium Gold G6400, 2 jezgra, 4.0 GHz', 10, 3),
  -- (3)
  ('Procesor', 'AMD Athlon Gold 3150G, 4 jezgra, 3.5 GHz', 7, 3),
  -- (4)
  ('Procesor', 'AMD Ryzen 3 5300U, 4 jezgra, 2.6 GHz', 13, 3),
  -- (5)
  ('Procesor', 'Intel Core i3-12100, 4 jezgra, 3.3 GHz', 11, 3),
  -- (6)
  ('Procesor', 'AMD Ryzen 5 5600X, 6 jezgra, 3.9 GHz', 7, 3),
  -- (7)
  ('Procesor', 'Intel Core i5-12600K, 10 jezgra, 3.7 GHz', 8, 3),
  -- (8)
  ('Procesor', 'Intel Xeon Bronze 3206R, 8 jezgra, 1.9 GHz', 11, 3),
  -- (9)
  ('Procesor', 'AMD EPYC 7302, 16 jezgra, 3.0 GHz', 12, 3),
  -- (10)
  ('Procesor', 'Intel Xeon Silver 4214R, 12 jezgra, 2.4 GHz', 9, 3),
  -- (11)
  ('Procesor', 'AMD Ryzen 7 5800X, 8 jezgra, 3.8 GHz', 13, 3),
  -- (12)
  ('Procesor', 'Intel Core i7-12700F, 12 jezgra, 2.1 GHz', 14, 3),
  -- (13)
  ('Procesor', 'Intel Core i7-12800H, 14 jezgra, 2.8 GHz', 10, 3),
  -- (14)
  ('Procesor', 'AMD EPYC 7371, 16 jezgra, 3.8 GHz', 10, 3),
  -- (15)
  ('Procesor', 'Intel Xeon Gold 5218, 16 jezgra, 2.3 GHz', 7, 3),
  -- (16)
  ('Procesor', 'AMD Ryzen 9 5950X, 16 jezgra, 3.4 GHz', 5, 3),
  -- (17)
  ('Procesor', 'Intel Core i9-12900K, 16 jezgra, 3.2 GHz', 6, 3),
  -- (18)
  ('Procesor', 'AMD EPYC 7402, 24 jezgra, 2.8 GHz', 9, 3),
  -- (19)
  ('Procesor', 'Intel Xeon E5-2697, 14 jezgra, 2.7 GHz', 12, 3),
  -- (20)
  ('Procesor', 'AMD EPYC 7452, 32 jezgra, 2.35 GHz', 8, 3),
  -- (21)
  ('Procesor', 'Intel Xeon Gold 6230R, 26 jezgra, 2.1 GHz', 7, 3),
  -- (22)
  ('Procesor', 'AMD Ryzen Threadripper 3960X, 24 jezgra, 3.5 GHz', 6, 3),
  -- (23)
  ('Procesor', 'Intel Xeon W-3265, 24 jezgra, 2.7 GHz', 15, 3),
  -- (24)
  ('Procesor', 'AMD EPYC 7742, 64 jezgra, 2.25 GHz', 15, 3),
  -- (25) Najjači
  ('Procesor', 'Intel Xeon Platinum 8280, 28 jezgra, 2.7 GHz', 10, 3);
  
  -- SSdovi
  INSERT INTO oprema (vrsta, specifikacije, stanje_na_zalihama, id_dobavljac)
VALUES
  -- SATA (sporije)
  ('SSD', 'Patriot Burst Elite, 240GB SATA',       8,  14),
  ('SSD', 'Toshiba OCZ VX500, 512GB SATA',        9,  14),
  ('SSD', 'ADATA SU800, 1TB SATA',                7,  14),
  ('SSD', 'Crucial MX500, 1TB SATA',             14,  14),
  ('SSD', 'Seagate Barracuda, 2TB SATA',          6,  14),

  -- Osnovni NVMe
  ('SSD', 'Samsung 970 Evo Plus, 500GB NVMe',     8,  14),
  ('SSD', 'WD Blue SN550, 1TB NVMe',            10,  14),
  ('SSD', 'PNY CS3030, 1TB NVMe',               11,  14),
  ('SSD', 'SanDisk Extreme Pro, 1TB NVMe',       9,  14),
  ('SSD', 'Samsung T7 Touch, 1TB NVMe',         12,  14),  -- T7 je eksterni, cca mid-range

  -- Srednji NVMe
  ('SSD', 'Crucial P5 Plus, 1TB NVMe',          18,  14),
  ('SSD', 'Intel SSD 660p, 2TB NVMe',           10,  14),
  ('SSD', 'ADATA XPG Gammix S70, 2TB NVMe',      7,  14),
  ('SSD', 'HP EX950, 2TB NVMe',                11,  14),
  ('SSD', 'Kingston KC3000, 2TB NVMe',         12,  14),

  -- Jači NVMe
  ('SSD', 'Toshiba XG6, 2TB NVMe',             13,  14),
  ('SSD', 'WD Black SN850, 1TB NVMe',          20,  14),
  ('SSD', 'Samsung 980 Pro, 2TB NVMe',         25,  14),
  ('SSD', 'Western Digital Gold, 4TB NVMe',    10,  14),
  ('SSD', 'Corsair MP600 Pro XT, 4TB NVMe',     9,  14),

  ('SSD', 'Samsung PM983, 3.84TB NVMe',         8,  14),
  ('SSD', 'Intel D7-P5600, 3.2TB NVMe',        15,  14),
  ('SSD', 'Intel Optane 905P, 960GB NVMe',     15,  14),
  ('SSD', 'Seagate FireCuda 530, 4TB NVMe',    10,  14),
  ('SSD', 'Micron 9300 Max, 6.4TB NVMe',        6,  14);
  
  -- Ram
  INSERT INTO oprema (vrsta, specifikacije, stanje_na_zalihama, id_dobavljac)
VALUES
  -- slabiji / niži kapacitet
  ('RAM', 'TeamGroup Elite DDR3, 8GB, 1600MHz',            9,  18),
  ('RAM', 'Patriot Signature DDR4, 8GB, 2666MHz',          8,  18),
  ('RAM', 'Corsair LPX DDR4, 16GB, 2666MHz',              10,  18),
  ('RAM', 'Crucial DDR4, 16GB, 2666MHz',                  10,  18),
  ('RAM', 'Micron DDR4, 16GB, 2400MHz',                   12,  18),

  -- mid-range
  ('RAM', 'Kingston ValueRAM DDR4, 32GB, 2400MHz',         6,  18),
  ('RAM', 'ADATA DDR4, 32GB, 3000MHz',                   12,  18),
  ('RAM', 'Crucial DDR5, 32GB, 4800MHz',                 25,  18),
  ('RAM', 'Kingston Fury Beast DDR5, 32GB, 6000MHz',     10,  18),
  ('RAM', 'Kingston Fury Impact DDR5, 32GB, 4800MHz',     7,  18),

  -- 64GB
  ('RAM', 'Corsair Dominator Platinum, 64GB, 3000MHz',     8,  18),
  ('RAM', 'Patriot Viper Steel, 64GB, 3000MHz',           9,  18),
  ('RAM', 'Kingston DDR4, 64GB, 3200MHz',                30,  18),
  ('RAM', 'HyperX Predator DDR4, 64GB, 3200MHz',         13,  18),
  ('RAM', 'Corsair Vengeance DDR5, 64GB, 5200MHz',        6,  18),

  -- 128GB
  ('RAM', 'G.Skill Trident Z, 128GB, 4000MHz',           15,  18),
  ('RAM', 'Micron DDR4, 128GB, 2666MHz',                  7,  18),
  ('RAM', 'TeamGroup T-Force DDR4, 128GB, 3600MHz',      11,  18),
  ('RAM', 'Corsair Vengeance DDR4, 128GB, 3600MHz',      20,  18),

  -- iznad 128GB
  ('RAM', 'Samsung DDR4, 256GB, 3200MHz',                10,  18),
  ('RAM', 'Samsung DDR5, 128GB, 4800MHz',                14,  18),
  ('RAM', 'ADATA XPG DDR5, 64GB, 5200MHz',                8,  18),
  ('RAM', 'Samsung DDR5, 256GB, 5200MHz',                 7,  18),
  
  -- par "viših" dodatno
  ('RAM', 'G.Skill Trident Z5, 128GB, 6000MHz',          10,  18), -- ovaj izmišljen kao jači
  ('RAM', 'Corsair RGB Pro DDR4, 32GB, 3200MHz',          9,  18);


-- PDU
INSERT INTO oprema (vrsta, specifikacije, stanje_na_zalihama, id_dobavljac)
VALUES
  -- manji broj izlaza = slabije
  ('PDU', 'Tripp Lite Rack PDU, 12 izlaza, 120V',                     12, 16),
  ('PDU', 'CyberPower Basic Rack PDU, 12 izlaza, 120V',               15, 16),
  ('PDU', 'Tripp Lite Basic Rack PDU, 12 izlaza, 230V',                7, 16),
  ('PDU', 'APC Metered Rack PDU, 8 izlaza, 230V',                     13, 16),
  ('PDU', 'Schneider Electric Switched Rack PDU, 8 izlaza, 120V',     11, 16),

  -- 16/20 izlaza
  ('PDU', 'Server Technology Rack PDU, 16 izlaza, 120V',              11, 16),
  ('PDU', 'Eaton Rack PDU, 16 izlaza, 230V',                           9, 16),
  ('PDU', 'Schneider Electric Rack PDU, 20 izlaza, 230V',              7, 16),
  ('PDU', 'APC Monitored Rack PDU, 24 izlaza, 230V',                   9, 16),
  ('PDU', 'Eaton Switched Rack PDU, 16 izlaza, 230V',                 10, 16),

  -- 24/32 izlaza
  ('PDU', 'Raritan Rack PDU, 24 izlaza, 230V',                         5, 16),
  ('PDU', 'Vertiv Basic Rack PDU, 12 izlaza, 230V',                    7, 16),
  ('PDU', 'Vertiv Geist Rack PDU, 32 izlaza, 230V',                   15, 16),
  ('PDU', 'Vertiv MPX Rack PDU, 32 izlaza, 230V',                      8, 16),
  ('PDU', 'ServerTech Switched Rack PDU, 32 izlaza, 230V',             6, 16),

  ('PDU', 'Raritan PX3 Rack PDU, 16 izlaza, 230V',                     8, 16),
  ('PDU', 'Tripp Lite Switched Rack PDU, 16 izlaza, 230V',             9, 16),
  ('PDU', 'CyberPower Monitored Rack PDU, 8 izlaza, 120V',            12, 16),
  ('PDU', 'Raritan Switched Rack PDU, 32 izlaza, 230V',               13, 16),
  ('PDU', 'Vertiv Monitored Rack PDU, 16 izlaza, 230V',               10, 16),

  -- veći broj izlaza
  ('PDU', 'APC Rack PDU, 24 izlaza, 230V',                            10, 16),
  ('PDU', 'APC Smart Rack PDU, 24 izlaza, 230V',                      10, 16),
  ('PDU', 'APC Switched Rack PDU, 48 izlaza, 230V',                    6, 16),
  ('PDU', 'Eaton Managed Rack PDU, 24 izlaza, 120V',                  14, 16),
  ('PDU', 'CyberPower Rack PDU, 20 izlaza, 120V',                      7, 16);
  
  -- patchpanel
  INSERT INTO oprema (vrsta, specifikacije, stanje_na_zalihama, id_dobavljac)
VALUES
  ('Patchpanel', 'TP-Link 12-portni patchpanel, CAT6',              7,  9),
  ('Patchpanel', 'Netgear 12-portni patchpanel, CAT5e',             9,  9),
  ('Patchpanel', 'Ubiquiti 12-portni patchpanel, CAT6',             6,  9),
  ('Patchpanel', 'D-Link 12-portni patchpanel, CAT6a',             10, 9),
  ('Patchpanel', 'TP-Link 24-portni patchpanel, CAT6',             15, 9),

  ('Patchpanel', 'Netgear 24-portni patchpanel, CAT6',             11, 9),
  ('Patchpanel', 'Cisco 24-portni patchpanel, CAT6',               13, 9),
  ('Patchpanel', 'D-Link 24-portni patchpanel, CAT6',               8,  9),
  ('Patchpanel', 'Ubiquiti 24-portni patchpanel, CAT5e',            9,  9),
  ('Patchpanel', 'TP-Link 24-portni patchpanel, CAT6a',            14, 9),

  ('Patchpanel', 'Netgear 24-portni patchpanel, CAT5e',             7,  9),
  ('Patchpanel', 'Cisco 24-portni patchpanel, CAT6a',               8,  9),
  ('Patchpanel', 'D-Link 48-portni patchpanel, CAT5e',             10, 9),
  ('Patchpanel', 'Netgear 48-portni patchpanel, CAT5e',            12, 9),
  ('Patchpanel', 'Ubiquiti 24-portni patchpanel, CAT6a',           11, 9),

  ('Patchpanel', 'TP-Link 48-portni patchpanel, CAT6a',             8,  9),
  ('Patchpanel', 'D-Link 48-portni patchpanel, CAT6',              10, 9),
  ('Patchpanel', 'Netgear 48-portni patchpanel, CAT6a',            12, 9),
  ('Patchpanel', 'Cisco 48-portni patchpanel, CAT6',                6,  9),
  ('Patchpanel', 'Cisco 48-portni patchpanel, CAT6a',               6,  9),

  ('Patchpanel', 'Ubiquiti 48-portni patchpanel, CAT5e',            7,  9),
  ('Patchpanel', 'Ubiquiti 24-portni patchpanel, CAT6',             9,  9),
  ('Patchpanel', 'Netgear 48-portni patchpanel, CAT6',             12, 9),
  ('Patchpanel', 'D-Link 48-portni patchpanel, CAT6a',             10, 9),
  ('Patchpanel', 'Cisco 24-portni patchpanel, CAT6',               13, 9);
  
  -- ups
  INSERT INTO oprema (vrsta, specifikacije, stanje_na_zalihama, id_dobavljac)
VALUES
  ('UPS', 'APC BE600M1, 600VA, 330W',            7,  10),
  ('UPS', 'Eaton 5S, 700VA, 420W',              9,  10),
  ('UPS', 'Eaton 9130, 700VA, 630W',            6,  10),
  ('UPS', 'Tripp Lite ECO850LCD, 850VA, 510W', 15,  10),
  ('UPS', 'CyberPower EC850LCD, 850VA, 510W',   7,  10),

  ('UPS', 'APC Smart-UPS C, 1000VA, 700W',     14,  10),
  ('UPS', 'CyberPower CP1000PFCLCD, 1000VA, 600W',12,10),
  ('UPS', 'APC Back-UPS, 1200VA, 700W',         5,  10),
  ('UPS', 'APC BR1500MS, 1500VA, 865W',         8,  10),
  ('UPS', 'CyberPower OR1500, 1500VA, 900W',    7,  10),

  ('UPS', 'Vertiv Liebert PSI5, 1500VA, 1350W', 7,  10),
  ('UPS', 'Tripp Lite SMART1500LCD, 1500VA, 900W',13,10),
  ('UPS', 'APC Smart-UPS, 1500VA, 1000W',      15,  10),
  ('UPS', 'CyberPower CP1500PFCLCD, 1500VA, 1000W',11,10),
  ('UPS', 'Eaton 5P, 1550VA, 1000W',           10, 10),

  ('UPS', 'Tripp Lite SU1500RTXL2UA, 1500VA, 1200W',8,  10),
  ('UPS', 'Vertiv Liebert GXT4, 1500VA, 1200W',10,  10),
  ('UPS', 'Vertiv Edge-1500, 1500VA, 1350W',   10,  10),
  ('UPS', 'CyberPower OR2200, 2200VA, 1600W',  9,  10),
  ('UPS', 'Tripp Lite SMART2200RMXL2U, 2200VA,1600W',11,10),

  ('UPS', 'Eaton 5PX, 2200VA, 1800W',         13,  10),
  ('UPS', 'Vertiv Liebert GXT5, 2000VA, 1800W',9,   10),
  ('UPS', 'Eaton 9PX, 3000VA, 2700W',          6,  10),
  ('UPS', 'Vertiv Liebert GXTS, 3000VA, 2700W',10, 10),
  ('UPS', 'Tripp Lite SmartPro, 2200VA, 1600W',12, 10);

-- hladenje
INSERT INTO oprema (vrsta, specifikacije, stanje_na_zalihama, id_dobavljac)
VALUES
  ('Hlađenje', 'Cooler Master Hyper T20, 120mm ventilator',    8,  13),
  ('Hlađenje', 'Thermaltake Contact Silent 12, 120mm',        13,  13),
  ('Hlađenje', 'Arctic F14, 140mm ventilator',                10,  13),
  ('Hlađenje', 'DeepCool Gammaxx 400, 120mm ventilator',       7,  13),
  ('Hlađenje', 'Cooler Master Hyper 212, 120mm ventilator',   12,  13),

  ('Hlađenje', 'Arctic Freezer 34 eSports DUO, 120mm',        10,  13),
  ('Hlađenje', 'Noctua NH-L12S, low-profile ventilator',      10,  13),
  ('Hlađenje', 'Noctua NH-U12A, 120mm ventilator',             8,  13),
  ('Hlađenje', 'be quiet! Pure Rock 2, 150W TDP',              9,  13),
  ('Hlađenje', 'Thermalright Macho Rev. B, 120mm',             9,  13),

  -- Vodena hlađenja
  ('Hlađenje', 'Cooler Master ML240L, vodeno hlađenje, 240mm',11,  13),
  ('Hlađenje', 'DeepCool Captain 240 Pro, vodeno, 240mm',     12,  13),
  ('Hlađenje', 'Corsair H100i Pro, vodeno hlađenje, 240mm',   13,  13),
  ('Hlađenje', 'NZXT Kraken M22, vodeno, 120mm',               7,  13),
  ('Hlađenje', 'be quiet! Dark Rock Pro 4, 250W TDP',          7,  13),

  ('Hlađenje', 'Cooler Master MA620M, dual vent, 140mm',      12,  13),
  ('Hlađenje', 'DeepCool Assassin III, dual vent, 140mm',      8,  13),
  ('Hlađenje', 'Thermaltake Floe DX, vodeno, 360mm',           6,  13),
  ('Hlađenje', 'Corsair H115i RGB, vodeno, 280mm',            11,  13),
  ('Hlađenje', 'NZXT Kraken X73, vodeno, 360mm',              10,  13),

  ('Hlađenje', 'NZXT Kraken Z73, vodeno hlađenje, 360mm',     14,  13),
  ('Hlađenje', 'Noctua NH-D15, dual ventilator, 140mm',       15,  13),
  ('Hlađenje', 'Arctic Liquid Freezer II, 280mm, vodeno',      6,  13),
  ('Hlađenje', 'Cooler Master MasterLiquid ML240, vodeno',     8,  13),
  ('Hlađenje', 'be quiet! Dark Rock TF2, top-flow cooler',     9,  13); -- dodan kao primjer da se popuni 25 rekorda
  
  
  -- rackrails
  INSERT INTO oprema (vrsta, specifikacije, stanje_na_zalihama, id_dobavljac)
VALUES
  -- (1)
  ('Rack Rails', '1U Universal Rack Rails, 19\" Depth, Steel', 10, 15),
  -- (2)
  ('Rack Rails', '2U Universal Rack Rails, 19\" Depth, Steel', 8, 15),
  -- (3)
  ('Rack Rails', '1U Server Rack Rails, Adjustable 18-26\" Depth, Steel', 12, 15),
  -- (4)
  ('Rack Rails', '2U Server Rack Rails, Adjustable 18-26\" Depth, Steel', 9, 15),
  -- (5)
  ('Rack Rails', '4U Rack Rails, 19\" Depth, Reinforced Steel', 15, 15),
  -- (6)
  ('Rack Rails', '1U Slide Rails, 20-29\" Depth, Ball Bearing', 6, 15),
  -- (7)
  ('Rack Rails', '2U Slide Rails, 20-29\" Depth, Ball Bearing', 7, 15),
  -- (8)
  ('Rack Rails', '1U Quick Mount Rack Rails, 19\" Depth', 11, 15),
  -- (9)
  ('Rack Rails', '2U Quick Mount Rack Rails, 19\" Depth', 5, 15),
  -- (10)
  ('Rack Rails', '1U Short Depth Rails, 15\" Depth', 8, 15),
  -- (11)
  ('Rack Rails', '1U Full Depth Rails, 27\" Depth', 10, 15),
  -- (12)
  ('Rack Rails', '1U Light Duty Rack Rails, 19\" Depth', 7, 15),
  -- (13)
  ('Rack Rails', '2U Light Duty Rack Rails, 19\" Depth', 9, 15),
  -- (14)
  ('Rack Rails', '1U Heavy Duty Rack Rails, 28\" Depth', 13, 15),
  -- (15)
  ('Rack Rails', '2U Heavy Duty Rack Rails, 28\" Depth', 7, 15),
  -- (16)
  ('Rack Rails', '1U Tool-Less Rack Rails, 19\" Depth', 14, 15),
  -- (17)
  ('Rack Rails', '2U Tool-Less Rack Rails, 19\" Depth', 5, 15),
  -- (18)
  ('Rack Rails', '3U Rack Rails, 20-30\" Depth, Steel', 11, 15),
  -- (19)
  ('Rack Rails', '4U Slide Rails, 20-28\" Depth, Ball Bearing', 10, 15),
  -- (20)
  ('Rack Rails', '1U Rack Rails, 18-22\" Depth, Aluminum', 8, 15),
  -- (21)
  ('Rack Rails', '2U Rack Rails, 18-22\" Depth, Aluminum', 7, 15),
  -- (22)
  ('Rack Rails', '3U Rack Rails, 18-24\" Depth, Aluminum', 6, 15),
  -- (23)
  ('Rack Rails', '4U Rack Rails, 18-24\" Depth, Aluminum', 15, 15),
  -- (24)
  ('Rack Rails', '1U Slide Rails, 16-22\" Depth, Quick Release', 9, 15),
  -- (25)
  ('Rack Rails', '2U Slide Rails, 16-22\" Depth, Quick Release', 10, 15);

  
  -- dimenzije racka
  INSERT INTO oprema (vrsta, specifikacije, stanje_na_zalihama, id_dobavljac)
VALUES
  ('Dimenzije', 'Mali rack, 20U',   5, 15),
  ('Dimenzije', 'Mali rack, 20U',  11, 15),
  ('Dimenzije', 'Mali rack, 22U',   6, 15),
  ('Dimenzije', 'Mali rack, 22U',  12, 15),
  ('Dimenzije', 'Mali rack, 24U',   9, 15),

  ('Dimenzije', 'Mali rack, 24U',  10, 15),
  ('Dimenzije', 'Mali rack, 26U',   7, 15),
  ('Dimenzije', 'Srednji rack, 38U',13,15),
  ('Dimenzije', 'Srednji rack, 40U', 8, 15),
  ('Dimenzije', 'Srednji rack, 40U', 9, 15),

  ('Dimenzije', 'Srednji rack, 42U',15,15),
  ('Dimenzije', 'Srednji rack, 42U',15,15),
  ('Dimenzije', 'Srednji rack, 44U',11,15),
  ('Dimenzije', 'Srednji rack, 44U',10,15),
  ('Dimenzije', 'Veliki rack, 46U', 8, 15),

  ('Dimenzije', 'Veliki rack, 46U', 9, 15),
  ('Dimenzije', 'Veliki rack, 48U', 7, 15),
  ('Dimenzije', 'Veliki rack, 48U',10, 15),
  ('Dimenzije', 'Veliki rack, 50U', 6, 15),
  ('Dimenzije', 'Veliki rack, 50U', 7, 15),

  ('Dimenzije', 'Veliki rack, 52U',14,15),
  ('Dimenzije', 'Veliki rack, 52U',13,15),
  ('Dimenzije', 'Srednji rack, 38U',12,15),
  ('Dimenzije', 'Mali rack, 26U',   7, 15),
  ('Dimenzije', 'Mali rack, 24U',  10, 15);
  
  -- switchevi
  INSERT INTO oprema (vrsta, specifikacije, stanje_na_zalihama, id_dobavljac)
VALUES
  ('Switch', 'MikroTik CRS305, 5-portni, 10Gbps',             6,  11),
  ('Switch', 'Netgear ProSafe GS724, 24-portni, 1Gbps',      13, 11),
  ('Switch', 'Netgear ProSafe GS728, 48-portni, 1Gbps',       5,  11),
  ('Switch', 'Juniper EX4300, 24-portni, 1Gbps',             15, 11),
  ('Switch', 'HP ProCurve 2920, 24-portni, 1Gbps',            9,  11),

  ('Switch', 'Dell EMC N3200, 48-portni, 1Gbps',              7,  11),
  ('Switch', 'Ubiquiti EdgeSwitch, 24-portni, 1Gbps',        14, 11),
  ('Switch', 'Cisco Catalyst 9200, 24-portni, 1Gbps',         8,  11),
  ('Switch', 'Juniper EX3400, 48-portni, 1Gbps',             11, 11),
  ('Switch', 'HP Aruba 2930F, 48-portni, 1Gbps',             12, 11),

  ('Switch', 'MikroTik CRS328, 28-portni, 1Gbps',             6,  11),
  ('Switch', 'Dell EMC N2200, 24-portni, 10Gbps',             9,  11),
  ('Switch', 'TP-Link TL-SG5428, 28-portni, 10Gbps',         11, 11),
  ('Switch', 'Ubiquiti UniFi Switch, 24-portni, 10Gbps',      7,  11),
  ('Switch', 'Cisco Catalyst 9300, 48-portni, 10Gbps',       10, 11),

  ('Switch', 'Juniper QFX5100, 48-portni, 10Gbps',           13, 11),
  ('Switch', 'TP-Link JetStream, 48-portni, 10Gbps',          7,  11),
  ('Switch', 'Ubiquiti UniFi Pro, 48-portni, 10Gbps',        10, 11),
  ('Switch', 'HP Aruba CX6400, 48-portni, 10Gbps',           10, 11),
  ('Switch', 'MikroTik CRS317, 16-portni, 10Gbps',           12, 11),

  ('Switch', 'Extreme Networks X460, 48-portni, 1Gbps',       8,  11),
  ('Switch', 'Extreme Networks X670, 48-portni, 40Gbps',      9,  11),
  ('Switch', 'Cisco Nexus 9000, 24-portni, 40Gbps',           7,  11),
  ('Switch', 'Dell EMC S4148, 48-portni, 25Gbps',             8,  11),
  ('Switch', 'Ubiquiti UniFi Dream Switch, 24-portni, 10Gbps',9,  11); 
  
  -- routeri
  INSERT INTO oprema (vrsta, specifikacije, stanje_na_zalihama, id_dobavljac)
VALUES
  ('Router', 'Asus RT-AX88U, 4-portni, 1Gbps',             5,  20),
  ('Router', 'Asus ROG Rapture, 8-portni, 1Gbps',          6,  20),
  ('Router', 'Asus RT-AC86U, 4-portni, 1Gbps',             7,  20),
  ('Router', 'Linksys MR9600, 4-portni, 1Gbps',           12,  20),
  ('Router', 'Linksys EA9500, 8-portni, 1Gbps',           11,  20),

  ('Router', 'TP-Link Archer C5400, 4-portni, 1Gbps',     10,  20),
  ('Router', 'Netgear Orbi Pro, 4-portni, 1Gbps',          8,  20),
  ('Router', 'Netgear Nighthawk X10, 6-portni, 1Gbps',     6,  20),
  ('Router', 'Cisco RV340, 4-portni, 1Gbps',              8,  20),
  ('Router', 'Ubiquiti EdgeRouter 4, 4-portni, 1Gbps',    12,  20),

  ('Router', 'Juniper SRX300, 4-portni, 1Gbps',           15,  20),
  ('Router', 'TP-Link ER7206, 5-portni, 1Gbps',            9,  20),
  ('Router', 'TP-Link TL-R605, 5-portni, 1Gbps',          10,  20),
  ('Router', 'MikroTik RB3011, 10-portni, 1Gbps',         13,  20),
  ('Router', 'MikroTik RB1100AHx4, 13-portni, 1Gbps',      8,  20),

  -- prelazak na 10Gbps / advanced
  ('Router', 'MikroTik CCR2004, 7-portni, 10Gbps',         7,  20),
  ('Router', 'Cisco ISR 4321, 2-portni, 1Gbps',           10,  20),
  ('Router', 'Cisco ASR 1001-X, 6-portni, 10Gbps',         7,  20),
  ('Router', 'Cisco ISR 4451-X, 8-portni, 10Gbps',        13,  20),
  ('Router', 'Juniper SRX4100, 8-portni, 10Gbps',          9,  20),

  ('Router', 'Ubiquiti UniFi Dream Machine, 4-portni, 1Gbps',14,20),
  ('Router', 'Ubiquiti AmpliFi HD, 4-portni, 1Gbps',       11, 20),
  ('Router', 'Netgear ProSafe FVS336G, 4-portni, 1Gbps',   9,  20),
  ('Router', 'Juniper MX204, 8-portni, 100Gbps',           7,  20),
  ('Router', 'Cisco ISR 4331, 3-portni, 10Gbps',           8,  20); 



-- konfiguracija uredjaja

-- serveri 
INSERT INTO konfiguracija_uredjaja
  (id, graficka_kartica, procesor, ssd, ram, IP_adresa)
VALUES
-- (1) Fujitsu, Web poslužitelj
(1,  5,   31,  56,  78,  '192.168.10.101'),

-- (2) Dell, Baza podataka
(2,  3,   40,  66,  89,  '192.168.10.102'),

-- (3) Lenovo, Aplikacijski poslužitelj
(3,  7,   32,  58,  79,  '192.168.10.103'),

-- (4) HP, Proxy poslužitelj
(4,  1,   26,  51,  76,  '192.168.10.104'),

-- (5) Fujitsu, Backup poslužitelj
(5,  8,   35,  60,  81,  '192.168.10.105'),

-- (6) Dell, DNS poslužitelj
(6,  2,   27,  52,  77,  '192.168.10.106'),

-- (7) Lenovo, Mail poslužitelj
(7,  4,   28,  53,  80,  '192.168.10.107'),

-- (8) HP, FTP poslužitelj
(8,  6,   29,  54,  82,  '192.168.10.108'),

-- (9) Fujitsu, Virtualizacijski poslužitelj
(9,  15,  44,  72,  88,  '192.168.10.109'),

-- (10) Dell, Streaming poslužitelj
(10, 24,  36,  68,  87,  '192.168.10.110'),

-- (11) Lenovo, VoIP poslužitelj
(11, 9,   30,  55,  83,  '192.168.10.111'),

-- (12) HP, IoT Gateway
(12, 10,  33,  59,  84,  '192.168.10.112'),

-- (13) Fujitsu, Load Balancer
(13, 14,  37,  61,  85,  '192.168.10.113'),

-- (14) Dell, Cache poslužitelj
(14, 25,  43,  62,  86,  '192.168.10.114'),

-- (15) Lenovo, Testni poslužitelj
(15, 12,  34,  63, 100,  '192.168.10.115'),

-- (16) HP, Analitički poslužitelj
(16, 19,  49,  75,  95,  '192.168.10.116'),

-- (17) Fujitsu, Web Proxy
(17, 13,  38,  64,  91,  '192.168.10.117'),

-- (18) Dell, Data Warehouse
(18, 21,  50,  74,  96,  '192.168.10.118'),

-- (19) Lenovo, CI/CD poslužitelj
(19, 18,  46,  67,  92,  '192.168.10.119'),

-- (20) HP, VPN poslužitelj
(20, 20,  45,  65,  93,  '192.168.10.120'),

-- (21) Fujitsu, Sigurnosni poslužitelj
(21, 22,  42,  71,  94,  '192.168.10.121'),

-- (22) Dell, CRM poslužitelj
(22, 23,  47,  70,  97,  '192.168.10.122');



-- standardni rackovi
INSERT INTO konfiguracija_uredjaja
  (dimenzije, PDU, patchpanel, rack_rails, UPS, hladenje, switch, router)
VALUES
(226, 101, 126, 201, 151, 176, NULL, NULL),
(227, 102, 127, 202, 152, 177, NULL, NULL),
(228, 103, 128, 203, 153, 178, NULL, NULL),
(229, 104, 129, 204, 154, 179, NULL, NULL),
(230, 105, 130, 205, 155, 180, NULL, NULL),
(231, 106, 131, 206, 156, 181, NULL, NULL),
(232, 107, 132, 207, 157, 182, NULL, NULL),
(233, 108, 133, 208, 158, 183, NULL, NULL),
(234, 109, 134, 209, 159, 184, NULL, NULL),
(235, 110, 135, 210, 160, 185, NULL, NULL),
(236, 111, 136, 211, 161, 186, NULL, NULL),
(237, 112, 137, 212, 162, 187, NULL, NULL);



-- mrezni rackovi
INSERT INTO konfiguracija_uredjaja
  (dimenzije, PDU, patchpanel, rack_rails, UPS, hladenje, switch, router)
VALUES
(238, 113, 138, 213, 163, 188, 251, 276),
(239, 114, 139, 214, 164, 189, 252, 277),
(240, 115, 140, 215, 165, 190, 253, 278),
(241, 116, 141, 216, 166, 191, 254, 279),
(242, 117, 142, 217, 167, 192, 255, 280),
(243, 118, 143, 218, 168, 193, 256, 281),
(244, 119, 144, 219, 169, 194, 257, 282),
(245, 120, 145, 220, 170, 195, 258, 283),
(246, 121, 146, 221, 171, 196, 259, 284),
(247, 122, 147, 222, 172, 197, 260, 285),
(248, 123, 148, 223, 173, 198, 261, 286),
(249, 124, 149, 224, 174, 199, 262, 287),
(250, 125, 150, 225, 175, 200, 263, 288);



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
    kategorija ENUM('server_rack','mrezni_rack') NOT NULL,
    CONSTRAINT fk_rack_fizicki 
       FOREIGN KEY (id_smjestaj) REFERENCES Fizicki_smjestaj(id_smjestaj)
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
(22, 65, 'Protuprovalni, Protupožarni, Detektori pokreta', 12, 'Visoka'),
(23, 5,  'Protuprovalni, Detektori pokreta', 2, 'Niska'),
(24, 70, 'Protupožarni, Protuprovalni', 14, 'Visoka'),
(25, 25, 'Detektori pokreta', 4, 'Srednja'),
(26, 15, 'Protuprovalni', 3, 'Niska'),
(27, 45, 'Protuprovalni, Protupožarni, Detektori pokreta', 9, 'Visoka'),
(28, 10, 'Protuprovalni', 2, 'Niska'),
(29, 50, 'Protupožarni, Detektori pokreta', 8, 'Visoka'),
(30, 20, 'Protuprovalni, Protupožarni', 5, 'Srednja'),
(31, 12, 'Protuprovalni', 3, 'Niska'),
(32, 80, 'Protuprovalni, Detektori pokreta', 15, 'Visoka');

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
(22, 'Europa','Hrvatska','Gorski Kotar','Delnice','Hala 22','1. kat','CET',22),
(23, 'Europa', 'Hrvatska', 'Zagreb',      'Velika Gorica', 'Hala 23', 'Prizemlje', 'CET', 1),
(24, 'Azija',  'Kina',     'Sichuan',     'Chengdu',       'Hala 24', '2. kat',    'CST', 2),
(25, 'Europa', 'Italija',  'Veneto',      'Venecija',      'Hala 25', '1. kat',    'CET', 3),
(26, 'Južna Amerika', 'Argentina', 'Buenos Aires', 'Buenos Aires', 'Hala 26', 'Prizemlje', 'ART', 4),
(27, 'Europa', 'Njemačka', 'Sjeverna Rajna-Vestfalija', 'Düsseldorf', 'Hala 27', '3. kat', 'CET', 5),
(28, 'Sjeverna Amerika', 'Meksiko', 'Jukatan',      'Cancún',        'Hala 28', '1. kat',  'CST', 6),
(29, 'Afrika', 'Južnoafrička Republika', 'Gauteng', 'Johannesburg',  'Hala 29', 'Prizemlje','SAST',7),
(30, 'Europa', 'Hrvatska', 'Dalmacija',  'Dubrovnik',    'Hala 30',   '2. kat',  'CET', 8),
(31, 'Australija','Australija','Queensland','Brisbane',   'Hala 31',   '1. kat',  'AEST', 9),
(32, 'Europa', 'Francuska', 'Provence',  'Marseille',    'Hala 32',   '3. kat',  'CET', 10),
(33, 'Europa', 'Hrvatska', 'Gorski Kotar','Rijeka',      'Hala 33',   'Prizemlje','CET', 11),
(34, 'Azija',  'Indonezija','Java',      'Jakarta',      'Hala 34',   '2. kat',  'WIB', 12),
(35, 'Sjeverna Amerika','SAD','New York','New York City','Hala 35','Prizemlje','EST',13),
(36, 'Europa', 'Španjolska', 'Madrid',   'Madrid',       'Hala 36',   '1. kat',  'CET', 14),
(37, 'Europa', 'Hrvatska', 'Zagreb',     'Velika Gorica','Hala 37',   '2. kat',  'CET', 15),
(38, 'Afrika', 'Egipat', 'Aleksandrija', 'Aleksandrija', 'Hala 38',   'Prizemlje','EET', 16),
(39, 'Azija', 'Japan', 'Tokyo', 'Tokyo', 'Hala 39', '3. kat', 'JST', 17),
(40, 'Sjeverna Amerika', 'Kanada', 'Alberta', 'Calgary', 'Hala 40', '1. kat', 'MST', 18),
(41, 'Europa', 'Švicarska', 'Zurich', 'Zurich', 'Hala 41', '1. kat', 'CET', 19),
(42, 'Europa', 'Srbija', 'Beograd', 'Beograd', 'Hala 42', '3. kat', 'CET', 20);


INSERT INTO Rack (id_rack, id_konfiguracija, id_smjestaj, kategorija)
VALUES
(1,  23, 1,  'server_rack'),
(2,  47, 2,  'mrezni_rack'),
(3,  24, 3,  'server_rack'),
(4,  25, 4,  'server_rack'),
(5,  46, 5,  'mrezni_rack'),
(6,  26, 6,  'server_rack'),
(7,  45, 7,  'mrezni_rack'),
(8,  27, 8,  'server_rack'),
(9,  44, 9,  'mrezni_rack'),
(10, 28, 10, 'server_rack'),
(11, 29, 11, 'server_rack'),
(12, 43, 12, 'mrezni_rack'),
(13, 43, 12, 'server_rack'),
(14, 30, 14, 'server_rack'),
(15, 42, 15, 'mrezni_rack'),
(16, 31, 16, 'server_rack'),
(17, 31, 16, 'server_rack'),
(18, 41, 18, 'mrezni_rack'),
(19, 32, 19, 'server_rack'),
(20, 32, 19, 'server_rack'),
(21, 40, 21, 'mrezni_rack'),
(22, 33, 22, 'server_rack');


 CREATE TABLE Posluzitelj (
    id_posluzitelj INT AUTO_INCREMENT PRIMARY KEY,
    id_konfiguracija  INT DEFAULT NULL,
    id_rack INT DEFAULT NULL,
    id_smjestaj INT DEFAULT NULL,
    naziv  VARCHAR(50) NOT NULL,
    kategorija VARCHAR(50) NOT NULL,
	FOREIGN KEY (id_konfiguracija) REFERENCES konfiguracija_uredjaja(id),
    FOREIGN KEY (id_rack) REFERENCES Rack(id_rack),
    FOREIGN KEY (id_smjestaj) REFERENCES Fizicki_smjestaj(id_smjestaj)
);



CREATE TABLE Monitoring (
    id_monitoring INT AUTO_INCREMENT PRIMARY KEY,
    id_posluzitelj INT DEFAULT NULL,
    vrsta VARCHAR(50) NOT NULL,
    FOREIGN KEY (id_posluzitelj) REFERENCES Posluzitelj(id_posluzitelj)
);

CREATE TABLE Incidenti (
    id_incidenta INT AUTO_INCREMENT PRIMARY KEY,
    datum DATE NOT NULL,
    opis TEXT NOT NULL,
    id_posluzitelj INT DEFAULT NULL,
    status VARCHAR(20) NOT NULL,
    FOREIGN KEY (id_posluzitelj) REFERENCES Posluzitelj(id_posluzitelj)
);


CREATE TABLE Logovi (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    id_posluzitelj INT DEFAULT NULL,
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



CREATE TABLE pracenje_statusa_posluzitelja (
	id INT PRIMARY KEY AUTO_INCREMENT,
    id_posluzitelj INT NOT NULL,
    procesor_status ENUM('Normalan', 'Visoko opterecenje', 'Kritican') NOT NULL,
    ram_status ENUM('Normalan', 'Visoko opterecenje', 'Kritican') NOT NULL,
    ssd_status ENUM('Normalan', 'Visoko opterecenje', 'Kritican') NOT NULL,
    temperatura_status ENUM('Normalan', 'Visoko opterecenje', 'Kritican') NOT NULL,
    vrijeme_statusa TIMESTAMP DEFAULT NOW() NOT NULL,
	FOREIGN KEY (id_posluzitelj) REFERENCES Posluzitelj(id_posluzitelj)
);

-- Nalazi se insert kako tablica nebi bila prazna, no zgodnije je raditit inserte preko aplikacije kako bi 
-- se lakse pratio od pocetka stvarni rad baze i kako ona reagira. Svakako inserti ce biti ubaceni prije kreiranih procedura i triggera
-- kako bi se lakse pratila prava situacija.

INSERT INTO pracenje_statusa_posluzitelja (id_posluzitelj, procesor_status, ram_status, ssd_status, temperatura_status, vrijeme_statusa)
VALUES (16, 'Kritican', 'Visoko opterecenje', 'Kritican', 'Normalan', NOW());


CREATE TABLE pracenje_statusa_racka (
	id SERIAL PRIMARY KEY,
    id_rack INT NOT NULL,
    temperatura_status ENUM('Normalan', 'Visoko opterecenje', 'Kritican') NOT NULL,
    popunjenost_status ENUM('Slobodno', 'Pun') NOT NULL,
    pdu_status ENUM('Normalan', 'Visoko opterecenje', 'Kritican') NOT NULL,
    ups_status ENUM('Normalan', 'Visoko opterecenje', 'Kritican') NOT NULL,
    bandwith_status_switch VARCHAR(255) NOT NULL DEFAULT 'Standardni rack',
    interface_status_router VARCHAR(255) NOT NULL DEFAULT 'Standardni rack',
	vrijeme_statusa TIMESTAMP DEFAULT NOW() NOT NULL,
    FOREIGN KEY (id_rack) REFERENCES Rack(id_rack)
);

-- Nalazi se insert kako tablica nebi bila prazna, no zgodnije je raditit inserte preko aplikacije kako bi 
-- se lakse pratio od pocetka stvarni rad baze i kako ona reagira. Svakako inserti ce biti ubaceni prije kreiranih procedura i triggera
-- kako bi se lakse pratila prava situacija.

INSERT INTO pracenje_statusa_racka (id_rack, temperatura_status, popunjenost_status, pdu_status, ups_status, vrijeme_statusa)
VALUES (3, 'Kritican', 'Slobodno', 'Kritican', 'Kritican', NOW());


CREATE TABLE potrosnja (
	id INT PRIMARY KEY AUTO_INCREMENT,
    potrosnja_kw DECIMAL(10, 2) NOT NULL,
    datum DATE NOT NULL
);

-- Tablica potrosnja nema inserta jer ona se puni na kraju dana.


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
(24, 'Damir',   'Hrgović',2, 'Inženjer sustava'),
(25, 'Vanja',   'Radman',    3, 'Sigurnosni analitičar'),
(26, 'Ivana',   'Lovrić',    4, 'Tehnički projektant'),
(27, 'Krešimir','Šimić',     5, 'Voditelj tima'),
(28, 'Dunja',   'Pavlović',  2, 'Mrežni arhitekt'),
(29, 'Marijan', 'Kovačević', 1, 'Računalni tehničar'),
(30, 'Lucija',  'Perić',     4, 'Specijalist za IT infrastrukturu'),
(31, 'Toni',    'Vuković',   1, 'Sistem tehničar'),
(32, 'Andrea',  'Kralj',     2, 'Inženjer za pohranu podataka'),
(33, 'Hrvoje',  'Grgić',     3, 'Sigurnosni koordinator'),
(34, 'Sara',    'Đurić',     5, 'Projektni asistent'),
(35, 'Igor',    'Barišić',   4, 'Specijalist za virtualizaciju'),
(36, 'Ema',     'Petrović',  2, 'Razvojni inženjer softvera'),
(37, 'Luka',    'Matijević', 1, 'Tehnički specijalist'),
(38, 'Martina', 'Jakovljević',3, 'Specijalist za mrežnu sigurnost'),
(39, 'Ivan',    'Marić',     5, 'Tehnički voditelj projekta'),
(40, 'Karla',   'Grabar',    2, 'QA analitičar'),
(41, 'Davor',   'Prpić',     4, 'Projektni menadžer'),
(42, 'Lana',    'Erceg',     3, 'Analitičar sigurnosnih rizika'),
(43, 'Stipe',   'Raić',      1, 'Administrator sustava'),
(44, 'Tina',    'Pavić',     5, 'IT konzultant'),
(45, 'Mario',   'Radić',     2, 'Sistem inženjer'),
(46, 'Zrinka',  'Ivanković', 4, 'Inženjer za cloud infrastrukturu');


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
(32, '2025-02-03', 'Nadogradnja sigurnosnih postavki OS-a',        5,  24),
(33, '2025-02-04', 'Instalacija novih diskova za pohranu',         3,  11),
(34, '2025-02-05', 'Ažuriranje firmvera na mrežnim uređajima',     2,  14),
(35, '2025-02-06', 'Zamjena oštećenih mrežnih kabela',             6,  15),
(36, '2025-02-07', 'Izrada novih sigurnosnih pravila vatrozida',   4,  16),
(37, '2025-02-08', 'Provjera redundancije napajanja sustava',      7,  17),
(38, '2025-02-09', 'Provjera i zamjena ventilatora u rackovima',   5,  18),
(39, '2025-02-10', 'Optimizacija SQL baze podataka',               8,  19),
(40, '2025-02-11', 'Kalibracija temperaturnih senzora',            9,  20),
(41, '2025-02-12', 'Migracija virtualnih poslužitelja na novi host',10, 21),
(42, '2025-02-13', 'Resetiranje sustava za praćenje mreže',        1,  22),
(43, '2025-02-14', 'Provjera i ažuriranje certifikata SSL',        2,  23),
(44, '2025-02-15', 'Implementacija novog sustava za backup',       3,  24),
(45, '2025-02-16', 'Zamjena baterija u UPS sustavu',               4,  25),
(46, '2025-02-17', 'Testiranje redundancije mrežnih čvorova',      5,  26);



CREATE TABLE Narudzbe (
    id_narudzbe INT PRIMARY KEY AUTO_INCREMENT,
    id_dobavljac INT NOT NULL,
    datum DATE NOT NULL,
    opis TEXT,
    id_oprema INT,
    FOREIGN KEY (id_dobavljac) REFERENCES Dobavljaci(id_dobavljac) ON DELETE CASCADE,
    FOREIGN KEY (id_oprema) REFERENCES oprema(id) ON DELETE CASCADE
);




CREATE TABLE Licence (
    id_licenca INT PRIMARY KEY AUTO_INCREMENT,
    datum_pocetak DATE NOT NULL,
    datum_istek DATE NOT NULL,
    vrsta VARCHAR(255) NOT NULL
);




INSERT INTO Narudzbe (id_narudzbe, id_dobavljac, datum, opis, id_oprema)
VALUES
(1, 1, '2025-01-15', 'Nabava novih servera za podatkovni centar.', 10),
(2, 2, '2025-01-18', 'Nabava mrežnih switch uređaja.', 12),
(3, 3, '2025-01-20', 'Nabava rezervnih hard diskova.', 15),
(4, 4, '2025-01-22', 'Instalacija i konfiguracija mrežne opreme.', NULL),
(5, 5, '2025-01-25', 'Nabava softvera za virtualizaciju.', NULL),
(6, 6, '2025-01-27', 'Nabava sigurnosnih kamera.', 18),
(7, 7, '2025-01-29', 'Proširenje sustava za backup.', 20),
(8, 8, '2025-01-30', 'Kupnja novih procesora za servere.', 25),
(9, 9, '2025-02-02', 'Nabava ventilacijskih modula.', 28),
(10, 10, '2025-02-05', 'Instalacija UPS napajanja.', NULL),
(11, 11, '2025-02-08', 'Dodavanje novih mrežnih adaptera.', 33),
(12, 12, '2025-02-10', 'Proširenje kapaciteta za backup.', 35),
(13, 13, '2025-02-12', 'Zamjena rashladnih sustava.', 38),
(14, 14, '2025-02-14', 'Ažuriranje hardverskih komponenti.', 40),
(15, 15, '2025-02-16', 'Instalacija dodatnih rack-ova.', NULL),
(16, 16, '2025-02-18', 'Kupnja PDU jedinica.', 45),
(17, 17, '2025-02-20', 'Nabava konzola za upravljanje.', 48),
(18, 18, '2025-02-22', 'Testiranje novih naponskih modula.', 50),
(19, 19, '2025-02-24', 'Zamjena mrežnih preklopnika.', 52),
(20, 20, '2025-02-26', 'Dodavanje novih sigurnosnih uređaja.', NULL);


CREATE TABLE Odjel (
    id_odjel INT PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(100) NOT NULL,
    id_smjestaj INT NOT NULL,
    FOREIGN KEY (id_smjestaj) REFERENCES Fizicki_smjestaj(id_smjestaj) ON DELETE CASCADE
);


INSERT INTO Licence (id_licenca, datum_pocetak, datum_istek, vrsta)
VALUES
(1, '2025-01-01', '2026-01-01', 'mrežni'),
(2, '2025-02-01', '2026-02-01', 'mailovi'),
(3, '2025-03-01', '2026-03-01', 'SSL'),
(4, '2025-04-01', '2026-04-01', 'antivirusni'),
(5, '2025-05-01', '2026-05-01', 'virtualizacijski'),
(6, '2025-06-01', '2026-06-01', 'backup sustavi'),
(7, '2025-07-01', '2026-07-01', 'mrežna sigurnost'),
(8, '2025-08-01', '2026-08-01', 'VPN'),
(9, '2025-09-01', '2026-09-01', 'firewall'),
(10, '2025-10-01', '2026-10-01', 'load balancing'),
(11, '2025-11-01', '2026-11-01', 'monitoring'),
(12, '2025-12-01', '2026-12-01', 'sustavi hlađenja'),
(13, '2026-01-01', '2027-01-01', 'komunikacijski sustavi'),
(14, '2026-02-01', '2027-02-01', 'upravljanje energijom'),
(15, '2026-03-01', '2027-03-01', 'hardverska kompatibilnost'),
(16, '2026-04-01', '2027-04-01', 'server administracija'),
(17, '2026-05-01', '2027-05-01', 'softverska rješenja'),
(18, '2026-06-01', '2027-06-01', 'zaštita podataka'),
(19, '2026-07-01', '2027-07-01', 'umjetna inteligencija'),
(20, '2026-08-01', '2027-08-01', 'sigurnosne kopije');

INSERT INTO Odjel (id_odjel, naziv, id_smjestaj)
VALUES
(1, 'IT podrška', 1),
(2, 'Mrežna administracija', 2),
(3, 'Razvoj softvera', 3),
(4, 'Sigurnosni tim', 4),
(5, 'Operativno održavanje', 5),
(6, 'Analiza podataka', 6),
(7, 'R&D odjel', 7),
(8, 'Upravljanje energijom', 8),
(9, 'Planiranje i logistika', 9),
(10, 'Projektni menadžment', 10),
(11, 'Korisnička podrška', 11),
(12, 'Testiranje sustava', 12),
(13, 'Marketing', 13),
(14, 'Prodaja', 14),
(15, 'Financije', 15),
(16, 'Održavanje infrastrukture', 16),
(17, 'Interna revizija', 17),
(18, 'Upravljanje rizikom', 18),
(19, 'Sustavi kvalitete', 19),
(20, 'Kontrola pristupa', 20);