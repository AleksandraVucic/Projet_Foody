#I.1- Requêtage simple
#1.Lister le contenu de la table Produit
SELECT * FROM foody.produit;
#2.N'afficher que les 10 premiers produits
SELECT * FROM foody.produit
LIMIT 10;
#3.Trier tous les produits par leur prix unitaire .
SELECT * FROM foody.produit
order by PrixUnit asc;
#4.Lister les trois produits les plus chers
SELECT * FROM foody.produit
order by PrixUnit desc
limit 3;

#I.2- Restriction
#1.Lister les clients français installés à Paris
SELECT * FROM foody.client where pays = 'France' and ville = 'Paris';
#2.Lister les clients français, allemands et canadiens
SELECT * FROM foody.client where pays = 'France' OR pays = 'Germany' or pays = 'Canada';
SELECT * FROM foody.client where pays in('France', 'Germany','Canada');
#3.Lister les clients dont le numéro de fax n'est pas renseigné
SELECT * FROM foody.client where Fax IS NULL;
#4.Lister les clients dont le nom contient "restaurant" (nom présent dans la colonne Societe/CompanyName)
SELECT * FROM foody.client where Societe like '%restaurant%' ;

#I.3- Projection
#1.Lister uniquement la description des catégories de produits (table Categorie)
SELECT Descriptionn FROM foody.categorie;
#2.Lister les différents pays des clients
SELECT DISTINCT Pays FROM foody.client ;
#3.Idem en ajoutant les villes, le tout trié par ordre alphabétique du pays et de la ville
SELECT DISTINCT Pays, Ville FROM foody.client order by Pays,Ville asc;
#4.Lister tous les produits vendus en bouteilles (bottle) ou en canettes(can)s
Select * FROM foody.produit where QteParUnit like '%bottle%' or QteParUnit like '%can%';
#5.Lister les fournisseurs français, en affichant uniquement le nom, le contact et la ville, triés par ville
SELECT Societe as Nom,Contact,Ville FROM foody.fournisseur where Pays='France' order by Ville;
#6.Lister les produits (nom en majuscule et référence) du fournisseur n° 8 dont le prix
#unitaire est entre 10 et 100 euros, en renommant les attributs pour que ça soit explicite
Select upper(NomProd) as 'Product name', RefProd as 'Référence'  FROM foody.produit 
where NoFour=8 and (PrixUnit>=10 and PrixUnit<=100);
#7.Lister les numéros d'employés ayant réalisé une commande (cf table Commande) à livrer en France, à Lille, Lyon ou Nantes
SELECT Distinct NoEmp FROM foody.commande where VilleLiv in ('Lille', 'Lyon','Nantes') and PaysLiv='France';
#8.Lister les produits dont le nom contient le terme "tofu" ou le terme "choco", dont le prix est inférieur à 100 euros (attention à la condition à écrire)
SELECT * FROM foody.produit where NomProd like '%tofu%' or NomProd like '%choco%' and PrixUnit between 1 and 100;
SELECT * FROM foody.produit where (NomProd like '%tofu%' or NomProd like '%choco%') and PrixUnit<=100;

#II.1.1- Calcul simple
#La table DetailsCommande contient l'ensemble des lignes d'achat de chaque commande.
# Calculer, pour la commande numéro 10251, pour chaque produit acheté dans celle-ci,
# le montant de la ligne d'achat en incluant la remise (stockée en proportion dans la table). 
#Afficher donc (dans une même requête) :
#- le prix unitaire,
#- la remise,
#- la quantité,
#- le montant de la remise Remise*PrixUnit,
#- le montant à payer pour ce produit  PrixUnit*(1-Remise)
SELECT RefProd, PrixUnit as 'Prix unitaire ', Remise, Qte as 'Quantité',
 round(Remise*PrixUnit,2) as 'montant de la remise', 
 round((1-Remise),2) as 'montant à payer' from foody.detailscommande
 Where NoCom=10251 ;
 
#II.2- Traitement conditionnel
#1.A partir de la table Produit, afficher "Produit non disponible" lorsque
#l'attribut Indisponible vaut 1, et "Produit disponible" sinon.
SELECT Indisponible,NiveauReap, UnitesStock,Indisponible,
CASE
WHEN (Indisponible = 1) THEN "Produit non disponible"
WHEN (Indisponible = 0) THEN "Produit disponible"
ELSE null 
END AS "Disponible"
FROM Produit;
#2.Dans la table DetailsCommande, indiquer les infos suivantes en fonction de la remise
#si elle vaut 0 : "aucune remise"
#si elle vaut entre 1 et 5% (inclus) : "petite remise"
#si elle vaut entre 6 et 15% (inclus) : "remise modérée"
#sinon :"remise importante"
SELECT *, 
CASE
WHEN (Remise =0) THEN "aucune remise"
WHEN (Remise < 0.051) THEN "petite remise"
WHEN (Remise <= 0.15) THEN "remise modérée"
ELSE "remise importante"
END AS Informations
FROM foody.detailscommande;
#3.Indiquer pour les commandes envoyées si elles ont été envoyées en retard (date
#d'envoi DateEnv supérieure (ou égale) à la date butoir ALivAvant) ou à temps
SELECT NoCom,CodeCli,NoEmp,DateCom,ALivAvant,DateEnv, 
CASE
WHEN (DateEnv>=ALivAvant) THEN "Envoyées en retard"
WHEN (DateEnv< ALivAvant) THEN "Envoyées à temps"
ELSE "No information"
END AS Informations
FROM foody.commande;

#II.3- Fonctions sur chaînes de caractères
# Dans une même requête, sur la table Client :
# Concaténer les champs Adresse, Ville, CodePostal et Pays dans un nouveau champ nommé Adresse_complète, pour avoir : Adresse, CodePostal, Ville, Pays
# Extraire les deux derniers caractères des codes clients
# Mettre en minuscule le nom des sociétés
# Remplacer le terme "Owner" par "Freelance" dans Fonction
# Indiquer la présence du terme "Manager" dans Fonction
Select Codecli,right(Codecli,length(Codecli)-3) as 'shortOf', 
lower(Societe) as 'minuscule le nom des sociétés', Fonction ,
REPLACE(Fonction, "Owner", "Freelance") as 'FonOwner-Freelance', 
CASE
WHEN Fonction Like "%manager%" THEN "Manager"
ELSE "Not Manager" END AS IsManager, concat(Adresse,CodePostal,Ville,Pays)
 as Adresse_complète FROM foody.client;
 
#II.4- Fonctions sur les dates
#1.Afficher le jour de la semaine en lettre pour toutes les dates de commande, afficher "week-end" pour les samedi et dimanche,
SELECT NoCom, CodeCli, DateCom,  
CASE
WHEN (weekday(DateCom) =0) THEN "lundi"
WHEN (weekday(DateCom)=1) THEN "mardi"
WHEN (weekday(DateCom)=2) THEN "mercredi"
WHEN (weekday(DateCom)=3) THEN "jeudi"
WHEN (weekday(DateCom)=4) THEN "vendredi"
ELSE "week-end"
END AS 'jour de la semaine'
FROM foody.commande;
#2.Calculer le nombre de jours entre la date de la commande (DateCom) et la date butoir de livraison (ALivAvant),
# pour chaque commande, On souhaite aussi contacter les clients 1 mois après leur commande.
# ajouter la date correspondante pour chaque commande
select NoCom,CodeCli,NoEmp,DateCom,ALivAvant,  DATEDIFF(AlivAvant,DateCom) as NbrJoursALivrer, 
DATE_ADD(DateCom, INTERVAL 30 DAY) as DayAContact FROM foody.commande;

#III- Aggrégats
#1.Calculer le nombre d'employés qui sont "Sales Manager"
SELECT Count(*) FROM foody.employe where Fonction='Sales Manager';
#2.Calculer le nombre de produits de moins de 50 euros
SELECT count(*) FROM foody.produit Where PrixUnit<50;
#3.Calculer le nombre de produits de catégorie 2 et avec plus de 10 unités en stocks
SELECT count(*) FROM foody.produit Where CodeCateg=2 and UnitesStock>10;
#4.Calculer le nombre de produits de catégorie 1, des fournisseurs 1 et 18
SELECT count(*) FROM foody.produit Where (NoFour=1 or NoFour=18)  and CodeCateg=1;
#5.Calculer le nombre de pays différents de livraison
SELECT count(distinct(PaysLiv)) FROM foody.commande ;
#6.Calculer le nombre de commandes réalisées le en Aout 2006??
SELECT count(*) FROM foody.commande Where DateEnv between '2006-07-31 23:59:59' and '2006-08-31 23:59:59';

#III.2- Calculs statistiques simples
#1.Calculer le coût du port minimum et maximum des commandes , 
#ainsi que le coût moyen du port pour les commandes du client dont le code est "QUICK" (attribut CodeCli)
Select CodeCli, MIN(Portt) as 'minimum de commandes',  MAX(Portt) as 'maximum de commandes', round(avg(Portt),2) as 'le coût moyen' from foody.commande where CodeCli='QUICK';
#2.Pour chaque messager (par leur numéro : 1, 2 et 3), donner le montant total des frais de port leur correspondant
select NoMess, round(SUM(Portt),2) as 'le montant total des frais' from foody.commande group by NoMess;

#1.Donner le nombre d'employés par fonction
SELECT Fonction, count(*) as 'le nombre d\'employés par fonction' FROM foody.employe group by Fonction;
#2.Donner le montant moyen du port par messager(shipper)
select NoMess, round(AVG(Portt),2) as 'le montant moyen' from foody.commande group by NoMess;
#3.Donner le nombre de catégories de produits fournis par chaque fournisseur
Select  NoFour , count(*) as 'le nombre de catégories de produits' from foody.produit group by NoFour;
#4.Donner le prix moyen des produits pour chaque fournisseur et chaque catégorie de produits fournis par celui-ci
Select  NoFour , CodeCateg, round(AVG(PrixUnit),2) as 'le prix moyen' from foody.produit group by NoFour,CodeCateg ;


#1.Lister les fournisseurs ne fournissant qu'un seul produit
select NoFour, RefProd from foody.produit group by  NoFour having count(RefProd)<2;
#2.Lister les catégories dont les prix sont en moyenne supérieurs strictement à 50 euros
Select CodeCateg from foody.produit group by CodeCateg having Avg(PrixUnit)>50;
#3.Lister les fournisseurs ne fournissant qu'une seule catégorie de produits
select NoFour, CodeCateg, RefProd, count(*) as 'Nombre de meme produits' from foody.produit
 group by  NoFour having count(distinct(CodeCateg))=1;
#4.Lister le Products le plus cher pour chaque fournisseur, pour les Products de plus de 50 euro???
select NoFour, RefProd, PrixUnit, max(PrixUnit) from foody.produit group by  NoFour having max(PrixUnit)>50;

#IV- Jointures
#1.Récupérer les informations des fournisseurs pour chaque produit???
Select p.RefProd, p.NomProd from foody.produit as p  where p.NoFour in( select f.NoFour  from foody.fournisseur as f);
#2.Afficher les informations des commandes du client "Lazy K Kountry Store"
Select * from foody.commande where Destinataire= "Lazy K Kountry Store"  ;
#3.Afficher le nombre de commande pour chaque messager (en indiquant son nom)


#1.Récupérer les informations des fournisseurs pour chaque produit, avec une jointure interne
Select p.RefProd, p.NomProd, f.* from foody.produit as p JOIN foody.fournisseur as f using(NoFour);
#2.Afficher les informations des commandes du client "Lazy K Kountry Store", avec une jointure interne
Select cl.Societe, co.* from foody.commande as co JOIN foody.client as cl using(CodeCli) where cl.Societe= "Lazy K Kountry Store"  ;
#3.Afficher le nombre de commande pour chaque messager (en indiquant son nom), avec une jointure interne
Select co.NoCom, m.NomMess from foody.commande as co JOIN foody.messager as m using(NoMess);

#1.Compter pour chaque produit, le nombre de commandes où il apparaît, même pour ceux dans aucune commande
Select p.RefProd, p.NomProd, count(NoCom) as 'le nombre de commandes', dc.* from foody.produit as p LEFT JOIN foody.detailscommande as dc using(RefProd) group by p.RefProd;
#2.Lister les produits n'apparaissant dans aucune commande
Select p.RefProd, p.NomProd as 'le nombre de commandes', dc.* from foody.produit as p LEFT OUTER JOIN foody.detailscommande as dc using(RefProd) group by p.RefProd having dc.RefProd is null ;
Select p.RefProd, p.NomProd as 'le nombre de commandes', dc.* from foody.produit as p LEFT OUTER JOIN foody.detailscommande as dc using(RefProd) where dc.RefProd is null ;
Select p.RefProd, p.NomProd from foody.produit as p  where p.RefProd NOT in( select dc.RefProd  from foody.detailscommande as dc);
#3.Existe-t'il un employé n'ayant enregistré aucune commande ?
Select p.RefProd, p.NomProd as 'le nombre de commandes', dc.* from foody.produit as p LEFT OUTER JOIN foody.detailscommande as dc using(RefProd) where dc.RefProd is null ;
Select e.NoEmp, e.Nom from foody.employe as e  where e.NoEmp NOT in( select co.NoEmp  from foody.commande as co);

#1. Récupérer les informations des fournisseurs pour chaque produit, avec jointure à la main
Select p.RefProd, f.*
From foody.produit as p, foody.fournisseur as f
where p.NoFour=f.NoFour;
#2.Afficher les informations des commandes du client "Lazy K Kountry Store", avec jointure à la main
Select cl.Societe, co.* from foody.commande as co, foody.client as cl where co.CodeCli=cl.Codecli and cl.Societe= "Lazy K Kountry Store"  ;
#3.Afficher le nombre de commande pour chaque messager (en indiquant son nom), avec jointure à la main
Select co.NoCom, m.NomMess from foody.commande as co, foody.messager as m where co.NoMess=m.NoMess;

#1.Lister les employés n'ayant jamais effectué une commande, via une sous-requête
Select e.NoEmp, e.Nom from foody.employe as e  where e.NoEmp NOT in( select co.NoEmp  from foody.commande as co where e.NoEmp=co.NoEmp ) ;
#2.Nombre de produits proposés par la société fournisseur "Ma Maison", via une sous-requête
Select count(*) as 'Nombre de produits' ,p.RefProd, p.NoFour from foody.produit as p  where p.NoFour in( select f.NoFour from foody.fournisseur as f where f.Societe="Ma Maison" ) ;

#3. Nombre de commandes passées par des employés sous la responsabilité de "Buchanan Steven"
Select count(*) as 'Nombre de commandes',co.NoEmp  , co.NoCom from foody.commande as co  
where co.NoEmp in( 
select e.NoEmp from foody.employe as e where e.RendCompteA in( select ee.NoEmp from foody.employe as ee where Nom= 'Buchanan' and Prenom='Steven' ) ) ;
#group by  co.NoEmp;

#1.Lister les produits n'ayant jamais été commandés, à l'aide de l'opérateur EXISTS
select p.RefProd, p.NomProd from foody.produit as p where not exists(select dc.RefProd from foody.detailscommande as dc where p.RefProd=dc.RefProd );
#2.Lister les fournisseurs dont au moins un produit a été livré en France
select NoFour,Societe from foody.fournisseur as f where exists (select distinct(NoFour) from foody.produit as p where exists (select RefProd from foody.detailscommande as dc where exists (
Select NoCom from foody.commande where PaysLiv='France' and NoCom=dc.NoCom) and p.RefProd=dc.RefProd)and f.NoFour=p.NoFour );
#3.Liste des fournisseurs qui ne proposent que des boissons (drinks)
select f.NoFour, f.Societe from foody.fournisseur as f where exists(
select distinct(p.NoFour) from foody.produit as p where exists (
Select CodeCateg from foody.categorie where NomCateg='drinks' and CodeCateg=p.CodeCateg) and f.NoFour=p.NoFour);

#VI- Opérations Ensemblistes
#1.Lister les employés (nom et prénom) étant "Representative" ou étant basé au Royaume-Uni (UK)
SELECT e.NoEmp,e.Nom,e.Prenom FROM foody.employe as e where e.Fonction like '%representative%'
union SELECT e.NoEmp,e.Nom,e.Prenom FROM foody.employe as e where e.Pays = 'UK' order by 1;
#2.Lister les clients (société et pays) ayant commandés via un employé situé à Londres ("London" pour rappel)
# ou ayant été livré par "Speedy Express"
Select distinct(cl.Codecli), cl.Societe, cl.pays, e.Ville as AVerifie from foody.client as cl join foody.commande as co using(Codecli)
join foody.employe as e using(NoEmp) where e.Ville='London' union
Select distinct(cl.Codecli), cl.Societe, cl.pays, m.NomMess as AVerifie from foody.client as cl join foody.commande as co using(Codecli)
join foody.messager as m using(NoMess) where m.NomMess='Speedy Express'
order by 1;

#1.Lister les employés (nom et prénom) étant "Representative" et étant basé au Royaume-Uni (UK)
SELECT DISTINCT(e.NoEmp),e.Nom,e.Prenom,e.Fonction,e.Pays FROM foody.employe as e where e.Fonction like '%representative%' and e.NoEmp in
 (SELECT e.NoEmp FROM foody.employe as e where e.Pays = 'UK') order by 1;
#2.Lister les clients (société et pays) ayant commandés via un employé basé à "Seattle" et ayant commandé des "Desserts"
Select distinct(cl.Codecli), cl.Societe, cl.pays, e.Ville as AVerifie from foody.client as cl join foody.commande as co using(Codecli)
join foody.employe as e using(NoEmp) where e.Ville='Seattle' and cl.Codecli in
(Select distinct(cl.Codecli) as AVerifie from foody.client as cl join foody.commande as co using(Codecli)
join foody.detailscommande as dc using(NoCom) join foody.produit as p using (RefProd) join foody.categorie as ca using (CodeCateg) where ca.NomCateg='Desserts')
order by 1;

#1.Lister les employés (nom et prénom) étant "Representative" mais n'étant pas basé au Royaume-Uni (UK)
SELECT e.NoEmp,e.Nom,e.Prenom FROM foody.employe as e where e.Fonction like '%representative%' and e.NoEmp
not in (SELECT e.NoEmp FROM foody.employe as e where e.Pays = 'UK' ) order by 1;

#2.Lister les clients (société et pays) ayant commandés via un employé situé à Londres ("London" pour rappel) 
#et n'ayant jamais été livré par "United Package"
Select distinct(cl.Codecli), cl.Societe, cl.pays, e.Ville as AVerifie from foody.client as cl join foody.commande as co using(Codecli)
join foody.employe as e using(NoEmp) where (e.Ville='London' and cl.Codecli
not in (Select distinct(cl.Codecli) from foody.client as cl join foody.commande as co using(Codecli)
join foody.messager as m using(NoMess) where m.NomMess!='United Package'))
order by 1;

