DROP DATABASE IF EXISTS datacentar;
CREATE DATABASE datacentar;
USE datacentar;

-- -------------------

-- Mario FUNKCIJE I OSTALO --

-- ------------------- MARIO STATS -> Br.Procedura: 3, Br.Funkcija: 2, Br.Trigger: 5, Br.Pogled: 3

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

-- *********  Obavezno pokrenuti kako bi fetch recenice radio *********** --------------------
  SELECT BrojDanaR(1) as recenica;           -- !!!!!             
-- *********************************************************************

-- Vraca broj dana koristenja usluge od strane klijenta sa ID 1

  

-- 3. Funkcija BrojDana samo vraca INT u svrhu njezine inkomporacije u druge dijelove projekta
DROP FUNCTION BrojDana;
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
    usluge.vrsta AS 'Usluga',
    SUM(racuni_prema_klijentima.ukupan_iznos) AS 'Ukupni_prihod'
FROM
    racuni_prema_klijentima
JOIN
    usluge_klijenata ON racuni_prema_klijentima.id_usluga_klijent = usluge_klijenata.id_usluga_klijent
JOIN
    usluge ON usluge_klijenata.id_usluga = usluge.id_usluga
GROUP BY
    usluge.vrsta;

SELECT * FROM UkupniPrihodiUsluge;
drop view UkupniPrihodiUsluge;
SELECT * FROM racuni_prema_klijentima;


-- 10. Trigger automatski oduzima iznos racuna od credita koji klijent ima te ažurira iznos kredita.

DELIMITER //
CREATE TRIGGER CreditAzuriranje
BEFORE INSERT ON credit
FOR EACH ROW
BEGIN

    DECLARE ukupan_iznos_kraj FLOAT;
    DECLARE iznosA FLOAT;

    SELECT ukupan_iznos INTO ukupan_iznos_kraj
    FROM racuni_prema_klijentima
    WHERE id_usluga_klijent = NEW.id_klijent_credit;

    SET iznosA = NEW.iznos - ukupan_iznos_kraj;

    IF iznosA > 0 THEN
        SET NEW.iznos = iznosA;
    ELSE
        INSERT INTO dugovanja (id_klijent_dugovanje, iznos_dugovanja, status)
        VALUES (NEW.id_klijent_credit, iznosA, 'Duznik');

    END IF;

END //
DELIMITER ;

-- 11. Procedura koja provjerava ako je neki klijent duznik
DROP PROCEDURE ProvjeraDuznikaR;

DELIMITER //
CREATE PROCEDURE ProvjeraDuznikaR(in id INT,out rec VARCHAR(100))
DETERMINISTIC
BEGIN
   DECLARE pid INT;
   SET pid = 0;
    SELECT id_klijent_dugovanje INTO pid
    FROM dugovanja
    WHERE id_klijent_dugovanje = id;
   IF pid!=id THEN
    SET rec = CONCAT('Klijent sa ID: ',id,' nema dugovanja');
   ELSE
    SET rec = CONCAT('Klijent sa ID: ',id,' ima dugovanja');
   END IF;
END //
DELIMITER ;

SELECT * FROM dugovanja;
CALL ProvjeraDuznikaR(8,@temp);
SELECT @temp;

-- 12. Procedura mijenja paket usluge korisnika ukoliko isti ima dovoljno credit na računu za novu uslugu

DELIMITER //
CREATE PROCEDURE PromjenaUslugeKlijenta(in id INT,in id_u INT,out recenica VARCHAR(150))
NOT DETERMINISTIC
BEGIN
   DECLARE pid INT;
   DECLARE cijena_u,saldo_k FLOAT;
   SET cijena_u =0, saldo_k =0;
   SET pid = 0;
    SELECT id_klijent_dugovanje INTO pid
                                        FROM dugovanja
                                        WHERE id_klijent_dugovanje = id;
    SELECT cijena INTO cijena_u
                                FROM usluge
                                WHERE id_u=id_usluga;
    SELECT  iznos INTO saldo_k
                              FROM credit
                              WHERE id=id_klijent_credit;
    IF pid!=id AND cijena_u<saldo_k THEN
        UPDATE usluge_klijenata SET id_usluga = id_u WHERE id_klijent=id;
        SET recenica = CONCAT('Usluga je uspjesno promijnenjena za klijenta sa ID: ', id);
    ELSE
        SET recenica = CONCAT('Usluga za klijenta sa ID ',id,' nije promijenjena zbog dugovanja ili iznosa credita na racunu!');
    END IF;

END //
DELIMITER ;

CALL PromjenaUslugeKlijenta(15,5,@rec);
SELECT @rec;

SELECT * FROM credit;
SELECT * FROM dugovanja;
SELECT * FROM usluge_klijenata; -- id_usluga_klijent i id_klijent SU ISTI jer ide auttoincrement INT ( za oboje ) te imamo isti broj recorda !
SELECT * FROM racuni_prema_klijentima;
-- 13 .Trigger IznosRacuna ne radi na UPDATE -> Iznos racuna se nebi promjenio nakon procedure PromjenaUslugeKlijenta, Trigger IznosRacunaUpdate racuna iznos

DELIMITER //
CREATE TRIGGER IznosRacunaUpdate
AFTER UPDATE ON usluge_klijenata
FOR EACH ROW
BEGIN
    DECLARE broj_dana INT;
    DECLARE cijena_usluge FLOAT;

    SELECT DATEDIFF(NEW.kraj_usluge, NEW.pocetak_usluge), usluge.cijena
                INTO broj_dana, cijena_usluge
    FROM usluge
                WHERE usluge.id_usluga = NEW.id_usluga;

    UPDATE racuni_prema_klijentima
    SET ukupan_iznos = (broj_dana / 30) * cijena_usluge, -- dogovoreno kao 1mj = 30 dana
        datum_izdavanja = CURDATE()
    WHERE id_usluga_klijent = NEW.id_usluga_klijent;

    END //
DELIMITER ;

-- 14. Trigger AzuriranjeCreditaKONZISTENTNOST azurira ili umece u tablice credit / dugovanje nakon što se izvrši UPDATE ( procedura PromjenaUslugeKlijenta )

DELIMITER //
CREATE TRIGGER AzuriranjeCreditaKONZISTENTNOST
AFTER UPDATE ON usluge_klijenata
FOR EACH ROW
BEGIN
    DECLARE ukupan_iznos_kraj FLOAT;
    DECLARE trenutni_iznos FLOAT;
    DECLARE klijent_dug INT;

    -- IZRAČUNAJ UKUPAN IZNOS USLUGE ZA KLIJENTA
    SELECT DATEDIFF(NEW.kraj_usluge, NEW.pocetak_usluge) * (cijena / 30) INTO ukupan_iznos_kraj
            FROM usluge
            WHERE id_usluga = NEW.id_usluga;

    -- DOHVATI TRENUTNI KREDIT KLIJENTA
    SELECT iznos INTO trenutni_iznos
            FROM credit
            WHERE id_klijent_credit = NEW.id_klijent;

    -- PROVJERA DUGOVANJA
    SELECT id_dugovanje INTO klijent_dug
            FROM dugovanja
            WHERE id_klijent_dugovanje = NEW.id_klijent;

    IF trenutni_iznos >= ukupan_iznos_kraj THEN
        UPDATE credit
        SET iznos = trenutni_iznos - ukupan_iznos_kraj
        WHERE id_klijent_credit = NEW.id_klijent;
    ELSE
        IF klijent_dug IS NOT NULL THEN -- PROVJERA DUGOVANJA 2
            -- KLIJENT IMA DUGOVANJE -> AZURIRAJ IZNOS
            UPDATE dugovanja
            SET iznos_dugovanja = iznos_dugovanja + (ukupan_iznos_kraj - trenutni_iznos),
                status = 'Duznik'
            WHERE id_klijent_dugovanje = NEW.id_klijent;
        ELSE
            -- KLIJENT NEMA DUGOVANJE -> STAVI NOVO DUGOVANJE
            INSERT INTO dugovanja (id_klijent_dugovanje, iznos_dugovanja, status)
            VALUES (NEW.id_klijent, ukupan_iznos_kraj - trenutni_iznos, 'Duznik');
        END IF;
    END IF;
END //
DELIMITER ;


CREATE VIEW klijenti_usluge_krediti AS
SELECT 
    k.id_klijent AS id_klijent,
    k.ime AS ime_klijenta,
    k.prezime AS prezime_klijenta,
    u.vrsta AS usluga,
    c.iznos AS stanje_kredita
FROM 
    klijenti k
LEFT JOIN 
    usluge_klijenata uk ON k.id_klijent = uk.id_klijent
LEFT JOIN 
    usluge u ON uk.id_usluga = u.id_usluga
LEFT JOIN 
    credit c ON k.id_klijent = c.id_klijent_credit;

-- Mario KRAJ

-- --- --- --- --- --- --- --- --- --- ---


-- Ronan START


-- Triger koji ce za svaki incident dodati log
-- ------------------
DELIMITER //

CREATE TRIGGER logAfterIncident
AFTER INSERT ON Incidenti
FOR EACH ROW
BEGIN
    INSERT INTO Logovi (id_posluzitelj, akcija, datum, user)
    VALUES (NEW.id_posluzitelj, 
            CONCAT('Novi incident prijavljen: ', NEW.opis), 
            NOW(), 
            'Sustav'); 
END;
//
DELIMITER ;

-- Testiranje trigera
INSERT INTO Incidenti (datum, opis, id_posluzitelj, status) 
VALUES ('2024-02-18', 'Internal server error na web posluzitelju', 1, 'Otvoreno');

select * from konfiguracija_uredjaja;
select * from incidenti;

-- Triger 2 - triger koji na kriticno opterecenje dodati log
DELIMITER //

create trigger logAfterVisokoOpterecenje
after insert on pracenje_statusa_posluzitelja
for each row
begin
  if new.procesor_status = 'Kritican' and new.ram_status = 'Kritican' and new.temperatura_status = 'Kritican' then
    
    INSERT INTO Logovi (id_posluzitelj, akcija, datum, user)
    VALUES (NEW.id_posluzitelj, 'Upozorenje, server je u kriticon stanju', NOW(), 'Sustav');
  END IF;
END;
// DELIMITER ;


-- Trigger koji za kriticno stanje racka dodaje incident
DELIMITER //

create trigger logAfterVisokoOpterecenjeRacka
after insert on pracenje_statusa_racka
for each row
begin
  if new.temperatura_status = 'Kritican' and new.pdu_status = 'Kritican' and new.ups_status = 'Kritican' then
    
    INSERT INTO Incidenti (datum, opis, status)
    VALUES (NOW(), CONCAT('Kriticno stanje racka ', NEW.id_rack), 'otvoreno');
		 
        
  END IF;
END;
// DELIMITER ;

DROP TRIGGER logAfterVisokoOpterecenjeRacka;

-- Testiranje triggera 2
INSERT INTO pracenje_statusa_posluzitelja (id_posluzitelj, procesor_status, ram_status, ssd_status, temperatura_status, vrijeme_statusa)
	VALUES (1, 'Kritican', 'Kritican', 'Kritican', 'Kritican', NOW());

select * from logovi;

-- Funkcija koja broji aktivne incidente
-- ------------------------------------
DELIMITER //
create function brojAktivnihIncidenata (p_id_posluzitelj INT)
returns int
deterministic
begin
declare broj INT;
  select COUNT(*) 
    into broj
    from Incidenti
    where id_posluzitelj = p_id_posluzitelj AND status = 'Otvoreno';
    
    return broj;
end;
// DELIMITER ;

-- Testiranje funkcije
select BrojAktivnihIncidenata(1) as AktivniIncidenti;


-- Procedura koja mjenja status za sve incidente na nekom posluzitelju
-- ------------------------------------------------------------------------
DELIMITER //

create procedure PromijeniStatus(p_id_posluzitelj int)
begin
    declare p_novi_status varchar(20) default 'Zatvoreno';  
    
    update Incidenti
	 set status = p_novi_status
    where  id_posluzitelj = p_id_posluzitelj and status = 'Otvoreno';
end;
//
DELIMITER ;

-- Testiranje procedure
call PromijeniStatus(1);
select * from incidenti;



-- Ostaka ideja ako je nesto pod visokim opterecenjem neka ode u monitoring ja cu tu napraviti uvjet, a Ronan posto je njegova tablica neka napravi proceduru i ja cu je pozvati 
-- Procedura koja ce dodati novi posluzitelj u monitoring. Funkciju ce pozvati Adis ukoliko je status kritican 
DELIMITER //

create procedure DodajUMonitoring(p_id_posluzitelj int)
begin
     INSERT INTO Monitoring (id_posluzitelj, vrsta)
    VALUES (p_id_posluzitelj, "Pracenje rada posluzitelja");
end;
//
DELIMITER ;

-- Testiranje procedure
call DodajUMonitoring(22);
select * from monitoring;



-- View koji vraca ukupan broji logova i incidenata za svaki poslužitelj

create view ukupanBrojLiI as 
select p.id_posluzitelj, p.naziv, p.kategorija,
COUNT(DISTINCT i.id_incidenta) AS BrojIncidenata,
COUNT(DISTINCT l.id_log) AS BrojLogZapisa

from posluzitelj p

left join incidenti i  on i.id_posluzitelj = p.id_posluzitelj
left join logovi l on l.id_posluzitelj = p.id_posluzitelj

group by p.id_posluzitelj, p.naziv, p.kategorija;


select * from ukupanBrojLiI;


-- Ronan END
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --



-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Adis START


-- PROCEDURA i TRIGGER koji kreiraju novu narudzbu za pojedinu opremu kada njezino stanje u zalihama bude <= 5;
-- Temelji se na pozivu procedure koja izadje narudzbenicu u triggeru;

-- Procedura koja ce kreirati novu narudzbenicu
DELIMITER //
CREATE PROCEDURE p_narudzbenica_oprema(IN p_id_oprema INTEGER, IN p_id_dobavljac INTEGER)
BEGIN

DECLARE p_oprema_kolicina INTEGER DEFAULT 10;
DECLARE p_datum DATE;
DECLARE p_opisna_poruka VARCHAR(255);
SET p_datum = CURDATE();
SET p_opisna_poruka = CONCAT("Kreiram narudzbenicu za opremu sa ID-em ", p_id_oprema, " kolicine ", p_oprema_kolicina);


INSERT INTO Narudzbe (id_dobavljac, datum, opis, id_oprema)
VALUES(p_id_dobavljac, p_datum, p_opisna_poruka, p_id_oprema);


END //
DELIMITER ;

-- Trigger koji ce pozivati proceduru za kreiranje nove narudzbenice jednom kada novo stanje na zalihama bude <=5
DELIMITER //
CREATE TRIGGER au_oprema
AFTER UPDATE ON oprema
FOR EACH ROW
BEGIN
    IF NEW.stanje_na_zalihama <= 5 THEN
        CALL p_narudzbenica_oprema(NEW.id, NEW.id_dobavljac);
    END IF;
END //
DELIMITER ;


-- Procedura koja osigurava konzistentnost podataka, na nacin da se poziva u triggerima ili ostalim procedurama
-- Neki od primjera: Kada se kreira novi konfiguracijski set, koristenoj opremi u toj konfiguraciji ce se stanje na zalihama smanjiti za -1
-- Takoder se i koristi u proceduri koja mijenja odredenu komponentu nekom uredjaju ako mu je stanje Visoko opterecenje ili Kritican, takva izmjena ce 
-- isto promjeniti stanje na zalihama opreme, te se u tom slucaju poziva procedura sa IN paramterima odnosno sa IDevima nove dodjeljene opreme.

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

-- Triger koji omogucava azuriranje stanja na zalihama u tablici oprema pozivom procedure iznad.
-- Ukoliko se ID opreme nade u pozivu istom ce se stanje azurirat, dok NULL znaci da se u toj konfiguraciji oprema nije koristila
-- Razlog: U konfiguraciji posluzitelja koristi se graficka_kartica, dok za konfiguraciju Racka ista nije potrebna pa se prosljedjuje NULL

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

-- Procedura koja se poziva ukoliko je status visoko opterecenje, proceduri se prosljedjuje id_posluzitelj kako se bi se pronasao konfiguracijski 
-- set kojeg uredaj koristi. Te prosljedjuje mu se komponenta koja je pod visokim opterecenjem
-- Procedura ce 'simulirati' zamjenu komponente. tj koristit ce se isti ID ali zapravo novija komponenta koja do tada nije koristena

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

-- Procedura koja se poziva ukoliko je status Kritican, proceduri se prosljedjuje id_posluzitelj kako se bi se pronasao konfiguracijski 
-- set kojeg uredaj koristi. Te prosljedjuje mu se komponenta koja je pod visokim opterecenjem
-- Procedura ce 'simulirati' zamjenu komponente. tj koristit ce se ID + 1 time cemo dobiti opremu sa boljim performansama od te koje je bila
-- , zahvaljujuci takvom redoslijedu inserta podataka

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

-- Trigger koji ce pozvati procedure ovisno o statusima komponenti koje su na pracenju

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


-- Pracenje statusa racka slican princip kao i za posluzitelja, samo se prate drugaciji atributi te uvjeti i pozivanje procedure.
-- Zgodna stvar koju sam impleentirao je da ukoliko hladenje bude kriticno istom Racku ce se dodjeliti bilo koje vodeno hladenje.
-- Bilo koje pomocu RAND(), koristim RAND() kako procedura nebi konstanto dodjeljivala isto vodeno hladenje "Istu marku".

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

-- Trigger koji ce pozvati procedure ovisno o statusima komponenti koje su na pracenju, u odnosu na posluzitelja u ovom slucaju pozivam procedure 
-- samo kada je stanje Kritican

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


-- TEST(jedan je gore za konfiguracijski set sve prolazi dobro) -- Odnosi se na azuriranje opreme kada se kreira konfiguracijski set 

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



-- U ovom dijelu se bavim pracenjem potrosnje, generirane na temelju rada uredjaja tj. na temelju njihovih statusa u rekordima

-- Procedura koja se koristi kasnije u pozivu glavne procedure koja ce biti u EVENT JOBU tj. na kraju dana ce napraviti obracun generiranje potrosnje u kW.
-- Ova procedura racuna generiranu potrosnju posluzitelja. Ono sto prima je status temperature, RAM-a, SSD-a. 
-- Na temelju statusa ce se obracuvati potrosnja, s tim da svaki uredjaj ima bazni slucaj tj potrosnju 200 na koju se dodaju ostale potrosnje ovisno 
-- o stanjima 

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

-- -- Procedura koja se koristi kasnije u pozivu glavne procedure koja ce biti u EVENT JOBU tj. na kraju dana ce napraviti obracun generiranje potrosnje u kW.
-- Ova procedura racuna generiranu potrosnju racka. Ono sto prima je status temperature, PDU-a, UPS-a. 
-- Na temelju statusa ce se obracunavati potrosnja, s tim da svaki uredjaj ima bazni slucaj tj potrosnju 200 na koju se dodaju ostale potrosnje ovisno 
-- o stanjima 

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

-- Postigao sam racunanje potrosnje prilikom inserta u pracenje statusa
-- , sada bi to trebalo zakurziti na kraj dana. Znaci jos jedna procedura koja to sve racuna te ima event job

-- Ovo je ta glavna procedura koja kao IN parametar uzima p_datum ponajvise zbog poziva u EVENT JOBU sa CURDATE(),
-- Out je tu ukoliko bi se pozvala u nekom odredenom periodu u danu kako bi se saznala trenutna potrosnja do tog trenutka.
-- Npr to radim kroz frontend, treba napomenuti da nije bas zahvalno to raditi jer jednom kada se pozove insertati ce tu potrosnju u tablicu potrosnja
-- Tako da podataka u tablici nece biti realan onom cemu tablica sluzi tj. svaki rekord prikazuje dan i ukupnu potrosnju na kraju dana.


-- Procedura je malo duga. Ovo je zapravo i materijalizirani pogled .
-- Generalno nije komplicirana ali je duga. Znaci ona u sebi poziva 2 procedure, jednu koja racuna ukupnu potrosnju posluzitelja koju sam objasnio gore,
-- te jedna koja vraca ukupnu potrosnju rackova isto objasnjena gore.
-- Jednostavno receno p_ukupno_kw ce biti = @ukupno od posluzitelja + @ukupno od rackova

-- Tu su kursori koji dohvacaju sve statuse uredjaja iz rekorda u tablicama i spremaju ih u lokalne varijable. 
-- Potom se procedure pozivaju sa tim lokalnim varijablama. U LOOPovima kako bi se izracunala potrosnja svakog statusa

DELIMITER //
CREATE PROCEDURE p_dnevna_potrosnja (INOUT p_datum DATE, OUT p_ukupno_kw DECIMAL(10,2))
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


 SET p_ukupno_kw = ukupna_dnevna_potrosnja;

-- Inserta se u tablicu potrosnja sve sto je generirano u tom pozivu procedure (gledajmo na kraju dana) podijeljeno sa 1000 tj. pretvorba W u kW

INSERT INTO potrosnja (potrosnja_kw, datum)
VALUES (ukupna_dnevna_potrosnja / 1000, p_datum);

END //
DELIMITER ;

-- radi na temelju podataka u tablicama pracenje sve je kriticno sto iznosi 800+800+800+800+800+800 tj 
-- 4800 kada to pretvorimo u kW 4800/1000 moramo dobiti 
-- 4.8 sto je tocno onom sto je u tablici potrosnja dobiveno sa 2 testna poziva procedure, sada cu je napraviti kao job tj. event za svaki dan


CALL p_dnevna_potrosnja(@datum := CURDATE(), @rezultat);
SELECT @datum, @rezultat FROM DUAL;

SELECT *
FROM potrosnja;

-- Kreiranje EVENTa koji poziva proceduru 
CREATE EVENT job_obracun_dnevne_potrosnje
ON SCHEDULE EVERY 1 DAY
DO
	CALL p_dnevna_potrosnja(CURDATE(), @rezultat);
	

-- Procedura koja vraca broj izmjena kod pojedinog uredjaja pracenjem iz statusa uredjaja. Kao sto sam gore objasnio uredjaju se komponenta mijenja 
-- ako je njezin status Visoko opterecenje ili kritican. Za rack samo kada je kritican, smatramo Rack moze podnositi visoka opterecenja

-- Procedura mora primiti vrstu uredjaja kako bi znala koju tablicu gledati, a OUT nam je broj izmjena.
-- Tu je ponovno kursor kojim prolazimo kroz svaki rekord gledamo da li je jedan od statusa Visoko opterecenje ili Kritican. Ako je povecavamo brojac

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


CALL p_broj_izmjena_na_uredjaju('posluzitelj', 22, @izmjene);
SELECT @izmjene FROM DUAL;

-- Pogled koji vraca ukupnu potrosnju energije za mjesece u godini, 
-- moze raditi i za pojedinacni mjesec u godini(pogodno za pretrazivanje sa frontenda npr)

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

-- Pogled koji vraca najpopularniju opremu, najpopularnija oprema se gleda na temelju njezinog broja koristenja u konfiguracijskim setovima.
-- Vrati ce onu opremu koja ima najveci broj koristenja. Pogled je malo dug, to je zbog strukture tablice konfiguracija_uredjaja i njeznimo vezom sa
-- tablicom oprema

CREATE VIEW najpopularnija_oprema AS
SELECT 
    id,
    vrsta AS naziv_opreme,
    COUNT(*) AS broj_koristenja
FROM oprema 
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
) AS svi_uredjaji ON oprema.id = svi_uredjaji.oprema_id
GROUP BY oprema.id, oprema.vrsta
ORDER BY broj_koristenja DESC
LIMIT 1;

SELECT *
FROM najpopularnija_oprema;
DROP VIEW najpopularnija_oprema;



-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Marko START 

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
    IN p_kategorija ENUM('server_rack', 'mrezni_rack')
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

-- funkcionalnost
-- pronađi zaposlenika s najmanje zadataka i vrati ga(ime.prezime,id i broj zadataka)
DELIMITER //

CREATE PROCEDURE VratiZaposlenika(
    OUT p_zaposlenik_id INTEGER, 
    OUT p_zaposlenik_ime VARCHAR(255), 
    OUT p_zaposlenik_prezime VARCHAR(255), 
    OUT p_broj_zadataka INTEGER
)
BEGIN
    SELECT 
        z.id_zaposlenik, 
        z.ime, 
        z.prezime, 
        COUNT(o.id_odrzavanja) AS broj_zadataka
    INTO 
        p_zaposlenik_id, 
        p_zaposlenik_ime, 
        p_zaposlenik_prezime, 
        p_broj_zadataka
    FROM 
        Zaposlenik z
    LEFT JOIN 
        Odrzavanje o ON z.id_zaposlenik = o.id_zaposlenik
    GROUP BY 
        z.id_zaposlenik, z.ime, z.prezime
    ORDER BY 
        broj_zadataka ASC
    LIMIT 1;
END //

DELIMITER ;

	CALL VratiZaposlenika(@id, @ime, @prezime, @broj);
    SELECT @id, @ime, @prezime, @broj FROM DUAL;
	
    
    CREATE VIEW broj_zadataka_po_zaposleniku AS
    SELECT zaposlenik.*, COUNT(odrzavanje.id_zaposlenik) AS broj_zadataka
    FROM zaposlenik LEFT JOIN odrzavanje ON zaposlenik.id_zaposlenik = odrzavanje.id_zaposlenik
    GROUP BY id_zaposlenik;
--------------------------------
-- vratit će true ako smiještaj ima rackove inače će vratiti false 

DELIMITER $$

CREATE FUNCTION ImaRack(smjestajID INT) 
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE ima_rack BOOLEAN;

    SELECT COUNT(*)
    INTO ima_rack
    FROM Rack
    WHERE id_smjestaj = smjestajID;

    RETURN ima_rack > 0;
END$$

DELIMITER ;

-- test  
SELECT ImaRack(1) AS rezultat;
--------

-- vraća id-ove zadnje održavanih rackova
DELIMITER $$

CREATE FUNCTION ZadnjeOdrzavaniRack() 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE z_rack INT;

    SELECT id_posluzitelj
    INTO z_rack
    FROM Odrzavanje
    ORDER BY datum DESC
    LIMIT 1;

    RETURN z_rack;
END$$

DELIMITER ;

-- test za ZadnjeOdrzavaniRack
SELECT ZadnjeOdrzavaniRack() AS z_rack;
-----

-- prikazuje sve rackove koji se nalaze u smještajima s niskom mjerom sigurnosti
CREATE VIEW RackNiskaSigurnost AS
SELECT 
    r.id_rack, r.kategorija, fs.grad, fs.hala, so.razina_sigurnosti
FROM Rack r
JOIN Fizicki_smjestaj fs ON r.id_smjestaj = fs.id_smjestaj
JOIN Sigurnost_objekta so ON fs.id_sigurnost = so.id_sigurnost
WHERE so.razina_sigurnosti = 'Niska';

-- test pogleda 
SELECT * FROM RackNiskaSigurnost;

-- ako želimo jos filtrirati prema nekim našim specifičnim kriterijima

SELECT * 
FROM RackNiskaSigurnost
WHERE grad = 'Zabok';
-------------------------

-- testni podaci 

INSERT INTO Sigurnost_objekta (id_sigurnost, sigurnosne_kamere, vrste_alarma, broj_zastitara, razina_sigurnosti)
VALUES (3, 15, 'Protuprovalni', 4, 'Niska');

INSERT INTO Fizicki_smjestaj (id_smjestaj, kontinent, drzava, grad, hala, prostor_kat, vremenska_zona, id_sigurnost)
VALUES (100, 'Europa', 'Hrvatska', 'Zagreb', 'Hala A', 'Prizemlje', 'CET', 3);

INSERT INTO Rack (id_rack, id_konfiguracija, id_smjestaj, kategorija)
VALUES (500, 101, 100, 'server_rack');

SELECT * FROM Sigurnost_objekta;
SELECT * FROM Fizicki_smjestaj;
SELECT * FROM Rack;

START TRANSACTION;

DELETE FROM Rack
WHERE id_smjestaj IN (
    SELECT id_smjestaj 
    FROM Fizicki_smjestaj 
    WHERE id_sigurnost = 3
);

SELECT * FROM Rack WHERE id_smjestaj = 100;

DELETE FROM Fizicki_smjestaj
WHERE id_sigurnost = 3;

SELECT * FROM Fizicki_smjestaj WHERE id_sigurnost = 3;

DELETE FROM Sigurnost_objekta
WHERE id_sigurnost = 3;

SELECT * FROM Sigurnost_objekta WHERE id_sigurnost = 3;

COMMIT;

SELECT * FROM Rack;
SELECT * FROM Fizicki_smjestaj;
SELECT * FROM Sigurnost_objekta;

-------------------------------------------

-- povećava broj sigurnosnih kamera za sve lokacije s niskom sigurnosti
DELIMITER $$

CREATE PROCEDURE PovecajSigurnosneKamere()
BEGIN
    UPDATE Sigurnost_objekta
    SET sigurnosne_kamere = sigurnosne_kamere + 10
    WHERE razina_sigurnosti = 'Niska' AND id_sigurnost IS NOT NULL;
END$$

DELIMITER ;

SELECT * FROM Sigurnost_objekta WHERE razina_sigurnosti = 'Niska';

SET SQL_SAFE_UPDATES = 0;
CALL PovecajSigurnosneKamere();
SET SQL_SAFE_UPDATES = 1;
----------------------------------
-- procedura koja dodaje zadatak održavanja za svaki rack u određenom smještaju
DELIMITER $$

CREATE PROCEDURE DodajOdrzavanjeRacka(IN p_id_smjestaj INT)
BEGIN
    INSERT INTO Odrzavanje (datum, opis, id_posluzitelj, id_zaposlenik)
    SELECT CURDATE(), 'Redovno održavanje racka', id_rack, 1
    FROM Rack
    WHERE id_smjestaj = p_id_smjestaj;
END$$

DELIMITER ;
CALL DodajOdrzavanjeRacka(5);

SELECT * FROM Rack WHERE id_smjestaj = 5;
SELECT * FROM Odrzavanje WHERE id_posluzitelj IN (SELECT id_rack FROM Rack WHERE id_smjestaj = 5);
------------

-- prikazuje sve poslužitelje s brojem rackova koje održavaju.
CREATE VIEW PosluziteljiIRackovi AS
SELECT 
    p.id_posluzitelj,
    p.naziv AS naziv_posluzitelja,
    COUNT(r.id_rack) AS broj_povezanih_rackova
FROM Posluzitelj p
LEFT JOIN Odrzavanje o ON p.id_posluzitelj = o.id_posluzitelj
LEFT JOIN Rack r ON o.id_posluzitelj = r.id_rack
GROUP BY p.id_posluzitelj;

SELECT * FROM PosluziteljiIRackovi;

--------------


-- nakon dodavanja ili brisanja racka, automatski se ažurira broj rackova u tablici fizicki_smjestaj.

DELIMITER $$

CREATE TRIGGER AzurirajBrojRackova
AFTER INSERT ON Rack
FOR EACH ROW
BEGIN
    UPDATE Smjestaj
    SET broj_rackova = (SELECT COUNT(*) FROM Rack WHERE id_smjestaj = NEW.id_smjestaj)
    WHERE id_smjestaj = NEW.id_smjestaj;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER AzurirajBrojRackovaBrisanje
AFTER DELETE ON Rack
FOR EACH ROW
BEGIN
    UPDATE Smjestaj
    SET broj_rackova = (SELECT COUNT(*) FROM Rack WHERE id_smjestaj = OLD.id_smjestaj)
    WHERE id_smjestaj = OLD.id_smjestaj;
END$$

DELIMITER ;

SELECT * FROM Fizicki_smjestaj;
SELECT * FROM Rack;

----------------

-- automatsko ažuriranje razine sigurnosti na 'Visoka' ako broj zaštitara premaši 10

DELIMITER $$

CREATE TRIGGER UpdateRazinaSigurnosti
BEFORE UPDATE ON Sigurnost_objekta
FOR EACH ROW
BEGIN
    IF NEW.broj_zastitara > 10 THEN
        SET NEW.razina_sigurnosti = 'Visoka';
    END IF;
END$$

DELIMITER ;
-- test 
UPDATE Sigurnost_objekta
SET broj_zastitara = 12
WHERE id_sigurnost = 1;

SELECT * FROM Sigurnost_objekta WHERE id_sigurnost = 1;

------------------------
-- automatski unos datuma održavanja/ automatski se postavlja trenutni datum
DELIMITER $$

CREATE TRIGGER DatumOdrzavanja
BEFORE INSERT ON Odrzavanje
FOR EACH ROW
BEGIN
    IF NEW.datum IS NULL THEN
        SET NEW.datum = CURDATE();
    END IF;
END$$

DELIMITER ;
-- test 
INSERT INTO Odrzavanje (opis, id_posluzitelj, id_zaposlenik)
VALUES ('Testiranje unosa bez datuma', 1, 1);

SELECT * FROM Odrzavanje
WHERE opis = 'Testiranje unosa bez datuma';
-------------
-- izvješće o održavanjima za određeni smještaj s brojem održavanja i zadnjim datumom održavanja 
DELIMITER $$

CREATE PROCEDURE IzvjesceOdrzavanja(IN p_id_smjestaj INT)
BEGIN
    SELECT 
        f.grad,
        COUNT(o.id_odrzavanja) AS broj_odrzavanja,
        MAX(o.datum) AS zadnje_odrzavanje
    FROM Fizicki_smjestaj f
    JOIN Rack r ON f.id_smjestaj = r.id_smjestaj
    JOIN Odrzavanje o ON r.id_rack = o.id_posluzitelj
    WHERE f.id_smjestaj = p_id_smjestaj
    GROUP BY f.grad;
END$$

DELIMITER ;

CALL IzvjesceOdrzavanja(1);

------

-- prikazuje broj objekata i ukupnu sigurnost po regijama.
CREATE VIEW SigurnostRegije AS
SELECT
    regija,
    COUNT(f.id_smjestaj) AS broj_objekata,
    SUM(s.broj_zastitara) AS ukupno_zastitara,
    AVG(s.sigurnosne_kamere) AS prosjecne_kamere
FROM Fizicki_smjestaj f
JOIN Sigurnost_objekta s ON f.id_sigurnost = s.id_sigurnost
GROUP BY regija;

SELECT * FROM SigurnostRegije;


-- Marko KRAJ 

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 


-- Mark start


-- pregled narudzbe po dobavljacu
CREATE VIEW pregled_narudzbi_po_dobavljacu AS
SELECT n.id_narudzbe, n.datum, n.opis AS narudzba_opis, d.ime AS dobavljac_ime
FROM Narudzbe n
JOIN Dobavljaci d ON n.id_dobavljac = d.id_dobavljac;

select * From Dobavljaci;
select * from Narudzbe;
select * from pregled_narudzbi_po_dobavljacu;


-- ako opis nije naveden automatski postavlja opis
DELIMITER //

CREATE TRIGGER opis_narudzbe
BEFORE INSERT ON Narudzbe
FOR EACH ROW
BEGIN
    IF NEW.opis IS NULL OR TRIM(NEW.opis) = '' THEN
        SET NEW.opis = 'Nije naveden opis narudžbe.';
    END IF;
END;
//

DELIMITER ;
-- provjera
INSERT INTO Narudzbe (id_dobavljac, datum, id_oprema) 
VALUES (15, '2025-01-20', 2);
SELECT * FROM Narudzbe;

INSERT INTO Narudzbe (id_dobavljac, datum, opis, id_oprema) 
VALUES (2, '2025-01-21', 'Opis', 3);



-- pregled licenci
CREATE VIEW pregled_licenci AS
SELECT id_licenca, datum_pocetak, datum_istek, vrsta
FROM Licence;


select * from  pregled_licenci;
-- pregled licenca po datumu isteka
CREATE VIEW LicencePoIsteku AS
SELECT 
    id_licenca, 
    datum_pocetak, 
    datum_istek, 
    vrsta
FROM Licence
ORDER BY datum_istek;

select * from LicencePoIsteku;

-- pogled po vrsti licenca
CREATE VIEW VrstaLicence AS
SELECT 
    id_licenca, 
    datum_pocetak, 
    datum_istek, 
    vrsta
FROM Licence
ORDER BY vrsta;

select * from Vrstalicence;


-- funkcija za provjeru isteka licenca
DELIMITER //
CREATE PROCEDURE AktivnostLicence (
    IN uneseni_id INT,
    OUT status VARCHAR(20)
)
BEGIN
    SELECT 
        CASE 
            WHEN datum_istek < CURDATE() THEN 'Licenca istekla'
            ELSE 'Licenca važeća'
        END
    INTO status
    FROM Licence
    WHERE id_licenca = uneseni_id;

    IF status IS NULL THEN
        SET status = 'Licenca ne postoji';
    END IF;
END;
//
DELIMITER ;

-- pregled 
set @status = '';
call aktivnostlicence(98,@status);
INSERT INTO Licence (id_licenca, datum_pocetak, datum_istek, vrsta)
VALUES (98, '2024-01-01','2025-01-01',1);
select @status;


-- Mark kraj
