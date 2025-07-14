-- Création de la base de données
CREATE DATABASE gowill_db;
USE gowill_db;

-- Table vehicule
CREATE TABLE vehicule (
    idVehicule INT AUTO_INCREMENT PRIMARY KEY,
    num_chassis VARCHAR(50) UNIQUE NOT NULL,
    marque VARCHAR(50) NOT NULL,
    prix DOUBLE NOT NULL CHECK (prix > 0),
    photo VARCHAR(200)
);

-- Table client
CREATE TABLE client (
    idClient INT AUTO_INCREMENT PRIMARY KEY,
    noms VARCHAR(50) UNIQUE NOT NULL,
    contact VARCHAR(50) NOT NULL,
    mail VARCHAR(50),
    adresse VARCHAR(50),
    pswd VARCHAR(50) NOT NULL
);

-- Table commande
CREATE TABLE commande (
    idCmd INT AUTO_INCREMENT PRIMARY KEY,
    refVehicule INT NOT NULL,
    refClient INT NOT NULL,
    dateCmd DATE NOT NULL,
    statut VARCHAR(20) NOT NULL,
    FOREIGN KEY (refVehicule) REFERENCES vehicule(idVehicule),
    FOREIGN KEY (refClient) REFERENCES client(idClient)
);

-- Table payement
CREATE TABLE payement (
    idPaye INT AUTO_INCREMENT PRIMARY KEY,
    refCmd INT NOT NULL,
    montantPaye DOUBLE NOT NULL CHECK (montantPaye > 0),
    datePaye DATE NOT NULL,
    FOREIGN KEY (refCmd) REFERENCES commande(idCmd)
);

-- Table programme
CREATE TABLE programme (
    idProgramme INT AUTO_INCREMENT PRIMARY KEY,
    refCmdP INT NOT NULL,
    dateEstime DATE NOT NULL,
    FOREIGN KEY (refCmdP) REFERENCES commande(idCmd)
);

-- Table utilisateur
CREATE TABLE utilisateur (
    idUser INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    pswdUser VARCHAR(50) NOT NULL,
    photoUser VARCHAR(200)
);
-- ===============Les views==========
CREATE VIEW vue_commande_complete AS
SELECT
    c.idCmd,
    c.dateCmd,
    c.refVehicule,
    v.num_chassis,
    v.marque,
    v.prix,
    c.refClient,
    cl.noms AS nomClient,
    cl.contact,
    cl.mail,
    cl.adresse
FROM commande c
JOIN vehicule v ON c.refVehicule = v.idVehicule
JOIN client cl ON c.refClient = cl.idClient;
-- =====================
CREATE VIEW vue_payement_complete AS
SELECT
    p.idPaye,
    p.datePaye,
    p.montantPaye,
    p.refCmd,
    c.dateCmd,
    c.refVehicule,
    v.num_chassis,
    v.marque,
    c.refClient,
    cl.noms AS nomClient,
    cl.contact
FROM payement p
JOIN commande c ON p.refCmd = c.idCmd
JOIN client cl ON c.refClient = cl.idClient
JOIN vehicule v ON c.refVehicule = v.idVehicule;
-- =============================================
CREATE VIEW vue_programme_complete AS
SELECT
    pr.idProgramme,
    pr.dateEstime,
    pr.refCmdP,
    c.dateCmd,
    v.num_chassis,
    v.marque,
    cl.noms AS nomClient
FROM programme pr
JOIN commande c ON pr.refCmdP = c.idCmd
JOIN client cl ON c.refClient = cl.idClient
JOIN vehicule v ON c.refVehicule = v.idVehicule;
