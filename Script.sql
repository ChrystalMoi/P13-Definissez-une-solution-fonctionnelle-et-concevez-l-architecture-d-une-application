-- ------------------
-- CREATION TABLES --
-- ------------------
CREATE TABLE Utilisateurs(
   Id_Utilisateur INT AUTO_INCREMENT,
   Email VARCHAR(255) NOT NULL,
   MotDePasse VARCHAR(255) NOT NULL,
   Nom VARCHAR(100) NOT NULL,
   Prenom VARCHAR(100) NOT NULL,
   Telephone VARCHAR(20) NOT NULL,
   created_at DATETIME NOT NULL,
   PRIMARY KEY(Id_Utilisateur),
   UNIQUE(Email)
);

CREATE TABLE Agences(
   Id_Agence INT AUTO_INCREMENT,
   Nom VARCHAR(150) NOT NULL,
   Adresse VARCHAR(255) NOT NULL,
   Telephone VARCHAR(20) NOT NULL,
   Ville VARCHAR(100) NOT NULL,
   PRIMARY KEY(Id_Agence)
);

CREATE TABLE Statuts_Reservation (
   Id_Statut INT AUTO_INCREMENT,
   Statut VARCHAR(50) NOT NULL,
   PRIMARY KEY(Id_Statut)
);

CREATE TABLE Reservations(
   Id_Reservation INT AUTO_INCREMENT,
   Date_Debut DATE NOT NULL,
   Date_Fin DATE NOT NULL,
   Prix_Total DECIMAL(10,2) NOT NULL,
   Statut INT NOT NULL DEFAULT 1,
   Date_Reservation DATE NOT NULL,
   Id_Utilisateur INT NOT NULL,
   PRIMARY KEY(Id_Reservation),
   FOREIGN KEY(Id_Utilisateur) REFERENCES Utilisateurs(Id_Utilisateur),
   FOREIGN KEY(Statut) REFERENCES Statuts_Reservation(Id_Statut),
   CONSTRAINT chk_dates CHECK (Date_Debut < Date_Fin)
);

CREATE TABLE Vehicules(
   Id_Vehicule INT AUTO_INCREMENT,
   Nom VARCHAR(150) NOT NULL,
   Categorie VARCHAR(50) NOT NULL,
   Prix_Par_Jour DECIMAL(10,2) NOT NULL,
   Disponible BOOLEAN NOT NULL,
   Id_Agence INT NOT NULL,
   Id_Reservation INT,
   PRIMARY KEY(Id_Vehicule),
   FOREIGN KEY(Id_Agence) REFERENCES Agences(Id_Agence),
   FOREIGN KEY(Id_Reservation) REFERENCES Reservations(Id_Reservation) ON DELETE SET NULL
);

CREATE TABLE Statuts_Paiement (
   Id_Statut INT AUTO_INCREMENT,
   Statut VARCHAR(50) NOT NULL,
   PRIMARY KEY(Id_Statut)
);

CREATE TABLE Paiements (
   Id_Paiement INT AUTO_INCREMENT,
   Id_Reservation INT NOT NULL,
   Montant DECIMAL(10,2) NOT NULL,
   Date_Paiement DATETIME NOT NULL,
   Statut INT NOT NULL DEFAULT 1,
   PRIMARY KEY(Id_Paiement),
   FOREIGN KEY(Id_Reservation) REFERENCES Reservations(Id_Reservation)
);

CREATE TABLE Statuts_Message (
   Id_Statut INT AUTO_INCREMENT,
   Statut VARCHAR(50) NOT NULL,
   PRIMARY KEY(Id_Statut)
);

CREATE TABLE Messages (
   Id_Message INT AUTO_INCREMENT,
   Id_Utilisateur INT NOT NULL,
   Sujet VARCHAR(255) NOT NULL,
   Message TEXT NOT NULL,
   Date_Envoi DATETIME NOT NULL,
   Statut INT NOT NULL DEFAULT 1,
   PRIMARY KEY(Id_Message),
   FOREIGN KEY(Id_Utilisateur) REFERENCES Utilisateurs(Id_Utilisateur)
);

-- ----------
-- TRIGGER --
-- ----------
DELIMITER $$

CREATE TRIGGER refus_multiple_paiements
BEFORE INSERT ON Paiements
FOR EACH ROW
BEGIN
   DECLARE nombre_paiements INT;
   -- Verifier s'il y a deja un paiement pour cette réservation
   SELECT COUNT(*) INTO nombre_paiements
   FROM Paiements
   WHERE Id_Reservation = NEW.Id_Reservation;
   
   -- Si un paiement existe deja, lever une erreur
   IF nombre_paiements > 0 THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Il y a deja� un paiement effectue pour cette reservation';
   END IF;
END $$

DELIMITER ;


