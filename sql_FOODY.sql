use FOODY;
CREATE TABLE Client
(
Codecli char(5) primary key,
Societe varchar(40),
Contact varchar(25),
Fonction varchar(30),
Adresse char(50),
Ville varchar(20),
Region varchar(15),
Codepostal varchar(10),
Pays varchar(15),
Tel varchar(20),
Fax varchar(20)
) ;

CREATE TABLE Messager
(
NoMess int primary key,
NomMess varchar(20),
Tel varchar(14)
) ;
drop table employe;
CREATE TABLE Employe
(
NoEmp int primary key,
Nom varchar(15),
Prenom varchar(15),
Fonction varchar(25),
TitreCourtoisie varchar(4),
DateNaissance datetime,
DateEmbauche datetime,
Adresse varchar(30),
Ville varchar(10),
Region varchar(2),
Codepostal varchar(10),
Pays varchar(3),
TelDom varchar(14),
Extension int,
RendCompteA int,
FOREIGN KEY (RendCompteA) references Employe(NoEmp)
) ;

drop table commande;
CREATE TABLE Commande
(
NoCom int not null primary key,
CodeCli varchar(5),
NoEmp int,
DateCom datetime,
ALivAvant datetime,
DateEnv datetime,
NoMess int,
Portt float,
Destinataire varchar(40),
AdrLiv varchar(50),
VilleLiv varchar(20),
RegionLiv varchar(15),
CodePostalLiv varchar(10),
PaysLiv varchar(15),
FOREIGN KEY (NoMess) references Messager(NoMess),
FOREIGN KEY (CodeCli) references Client(CodeCli),
FOREIGN KEY (NoEmp) references employe(NoEmp)
);

CREATE TABLE Categorie
(
CodeCateg int not null primary key,
NomCateg varchar(15),
Descriptionn varchar(60)
) ;

drop table detailsCommande;
CREATE TABLE detailsCommande
(
NoCom int, RefProd int,
PRIMARY KEY(NoCom,RefProd),
PrixUnit float,
Qte float,
Remise float,
FOREIGN KEY (NoCom) references Commande(NoCom),
FOREIGN KEY (RefProd) references produit(RefProd)
) ;

CREATE TABLE produit
(
RefProd int not null primary key,
NomProd varchar(35),
NoFour int,
CodeCateg int,
QteParUnit varchar(20),
PrixUnit float,
UnitesStock int,
UnitesCom int,
NiveauReap int,
Indisponible bool,
FOREIGN KEY (CodeCateg) references Categorie(CodeCateg),
FOREIGN KEY (NoFour) references Fournisseur(NoFour)
) ;

Alter table produit
MODIFY Indisponible bool;

CREATE TABLE Fournisseur
(
NoFour int not null primary key,
Societe varchar(40),
Contact varchar(30),
Fonction varchar(30),
Adresse varchar(50),
Ville varchar(15),
Region varchar(10),
CodePostal varchar(10),
Pays varchar(15),
Tel varchar(15),
Fax  varchar(15),
PageAccueil varchar(100)
) ;

#LOAD DATA LOCAL INFILE  'C:/Users/pavuc/Dropbox/My PC (VUCIC)/Documents/Simplon/Programmation/MySQL/proojet_FOODY/client.csv'
#LOAD DATA LOCAL INFILE  '*/client.csv'
#LOAD DATA LOCAL INFILE  'C:\Users\pavuc\Dropbox\messager.csv'
LOAD DATA LOCAL INFILE  'C:/Users/pavuc/Dropbox/messager.csv'
INTO TABLE messager
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

set global local_infile=true;
SHOW GLOBAL VARIABLES LIKE 'local_infile';

LOAD DATA LOCAL INFILE "fournisseur.csv" INTO TABLE Fournisseur;

LOAD DATA LOCAL INFILE  'C:/Users/pavuc/Dropbox/My PC (VUCIC)/Documents/Simplon/Programmation/MySQL/proojet_FOODY/client.csv'
INTO TABLE client
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE  'C:/Users/pavuc/Dropbox/My PC (VUCIC)/Documents/Simplon/Programmation/MySQL/proojet_FOODY/categorie.csv'
INTO TABLE categorie
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE  'C:/Users/pavuc/Dropbox/My PC (VUCIC)/Documents/Simplon/Programmation/MySQL/proojet_FOODY/commande.csv'
INTO TABLE commande
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE  'C:/Users/pavuc/Dropbox/My PC (VUCIC)/Documents/Simplon/Programmation/MySQL/proojet_FOODY/detailsCommande.csv'
INTO TABLE detailsCommande
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE  'C:/Users/pavuc/Dropbox/My PC (VUCIC)/Documents/Simplon/Programmation/MySQL/proojet_FOODY/fournisseur.csv'
INTO TABLE fournisseur
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE  'C:/Users/pavuc/Dropbox/My PC (VUCIC)/Documents/Simplon/Programmation/MySQL/proojet_FOODY/employe.csv'
INTO TABLE employe
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

INSERT INTO employe values(1,'Davolio','Nancy','Sales Representative','Ms.','1948-12-08 0:00:00','1992-05-01 0:00:00','507 - 20th Ave. E.Apt. 2A','Seattle','WA','98122','USA','(206) 555-9857','5467','2');

LOAD DATA LOCAL INFILE  'C:/Users/pavuc/Dropbox/My PC (VUCIC)/Documents/Simplon/Programmation/MySQL/proojet_FOODY/produit.csv'
INTO TABLE produit
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

