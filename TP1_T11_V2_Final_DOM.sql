/****************************** PROJET DE SESSION TP-1 ******************************************************
   **************************** 420-T11-BB COLLECTE DE DONNÉES IDO ************************************
   ****************************
      *************************
         **************************** T11 – Projet 1 – Team 3 ****************************************
         **************************** Dominique Dupuis 2095133
         **************************** Michel Boulay, 2095013    
                    -- SVP Prendre note que pour pouvoir travailler sans conflis dans le GROUPE_T-11
                    -- nous avons ajouter MB_ au debut, ainsi que _DD a la fin de chaque table que 
                    -- nous avons creer comme par exemple :MB_nomDeLaTable_DD 
*** --*Début*--***CODE SQL POUR CREER 9 TABLES dans l'ORDRE SUIVANT: CATEGORIES, MEDICAMENT, ORDONNANCE,
             ORDONNANCEMEDICAMENT, ORDONNANCECHIRURGIE, SPECIALITE, DOCTEUR, DOSSIERPATIENT, CONSULTATION
*/
create table MB_CATEGORIES_DD(                 --*Début*--Table CATEGORIES est l'enfant de MEDICAMENT                    
idCategorie integer primary key,                        --PF= Clef primaire
nom varchar(50) UNIQUE not null,                        --CONTRAINTE UNIQUE et Not Null=toujours connu 
Description varchar(250)                                --250 caractere pour avoir la place suffisante pour ecrire la description
);                                               --*Fin*--
                                                        --
create table MB_MEDICAMENT_DD (                --*Début*--Table MEDICAMENT est l'enfant de ORDONNANCEMEDICAMENT et parent de CATEGORIES
idMed integer primary key,                              --PF=Clef primaire
categorie integer,                                      --Les cathégories de médicament sont répertorié en chapitre avec des numéros
nomMed varchar(50) not null,                            --Les noms complet de medicaments peuvent etre long : RimabotulinumtoxinB
unique(nomMed, categorie),                              --PF=Clef primaire est une clef composé de 
prix number(6,2) default 0,                             --
CONSTRAINT prix_Contrainte check (prix>=0),             --CONTRAINTE prix_Contrainte est une valeur positive et le egal (=) est tres IMP car default est a 0
foreign key(categorie) references MB_CATEGORIES_DD(idCategorie) 
                                                        --FK= 2 clefs étrangères
);                                               --*Fin*--
                                                        --
create table MB_ORDONNANCE_DD (                --*Début*--Table ORDONNANCE est liée à la table CONSULTATION  et parent de 2 enfants: ORDONNANCEMEDICAMENT et ORDONNANCECHIRURGIE                 
numOrd integer primary key,                             --PK=PRIMAY KEY composé de idCategorie et numOrd
recommandations varchar(150),                           --
typeO varchar(11),                                      -- 11 charactères est le MIN pour écrire (Médicament ou Chirurgie) car le (é) semble prendre 2 caractères
CONSTRAINT typeO_CONSTRAINT CHECK (typeO IN ( 'Médicament', 'Chirurgie')),
                                                        --Contrainte typeO_CONSTRAINT pour limiter le champ à 2 choix Médicament ou Chirurgie
dateC date not null                                     --La variable dateC a le format date et est toujours connu
);                                              ---*Fin*--PAS DE PK
                                                        --
create table MB_ORDONNANCEMEDICAMENT_DD (      --*Début*--Table ORDONNANCEMEDICAMENT est un enfant/2 de la table ORDONNANCE et 1 enfant MEDICAMENT
numOrd integer,                                         --PFa=Clef primaire #1
idMed integer,                                          --PFb=Clef primaire #2
primary key(numOrd, idMed),                             --PK=PRIMAY KEY composé de numOrd et idMed
nbBoites number(2) default 0,                           --Variable nbBoites est un nombre de 0 à 99 avec une valeur de 0 par défaut
CONSTRAINT nbBoites_Contrainte check (nbBoites>=0),     --CONTRAINTE nbBoites_Contrainte est une valeur positive et le egal (=) est tres IMP car default est a 0
foreign key(numOrd) references MB_Ordonnance_DD(numOrd),--FK= Clé étrangère
foreign key(idMed) references MB_MEDICAMENT_DD(idMed)   --FK= Clé étrangère
);                                              ---*Fin*--
                                                        --
create table MB_ORDONNANCECHIRURGIE_DD (       --*Début*--Table ORDONNANCECHIRURGIE est un enfant/2 de la table ORDONNANCE
numOrd integer,                                         --PFa=Clef primaire #1
rang integer,                                           --PFa=Clef primaire #2
primary key(numOrd,rang),                               --PK=PRIMAY KEY composé de numOrd + idMed
nomChirurgie varchar(40),                               --Variable de 40 caracteres pour se garder une marge de sécurité
foreign key(numOrd) references MB_Ordonnance_DD(numOrd) --FK= Clé étrangère
);                                               --*Fin*--
                                                        --
create table MB_SPECIALITE_DD(                 --*Début*--Table SPECIALITE est l'enfant de la table DOCTEUR
code integer primary key,                               --PF= Clef primaire
titre varchar(20) UNIQUE,                               --le nom des specialitées n'est pas si long mais on se garde une marge de sécurité
description varchar(150) UNIQUE                         --150 caractères pour les poetes en herbe
);                                               --*Fin*--
                                                        --
create table MB_DOCTEUR_DD(                    --*Début*--Table DOCTEUR est un lien avec DOSSIERPATIENT et est le parent de SPECIALITE pont entre DOCTEUR et ORDONNANCE
matricule integer primary key,                          --PF= Clef primaire
nomM varchar(30) not null,                              --
prenomM varchar(30) not null,                           --
specialite integer,                                     --
ville varchar(40),                                      -- 40 char car, des villes ont des noms très long, ex : Cape St. George-Petit Jardin-Grand Jardin-De Grau-Marches Point-Loretto
adresse varchar(50),                                    -- 50 char, des rues ont des noms longs
niveau varchar(9),                                      -- 9 char est le minimum pour les 4 niveaux 'Etudiant', 'Étudiant', 'Interne', 'Docteur'
CONSTRAINT niveau_Contrainte CHECK (niveau IN ( 'Etudiant', 'Étudiant', 'Interne', 'Docteur')),
                                                        --CONTRAINTE niveau_Contrainte car les niveaux autorisés sont : Étudiant, Interne, ou Docteur
nbrPatients number(2) default 0,                        --CONTRAINTE: Variable nbrPatients est un nombre de 0 à 99 avec une valeur de 0 par défaut
CONSTRAINT nbrPatients_Contrainte check (nbrPatients>=0),--CONTRAINTE brPatients_Contrainte est une valeur positive et le egal (=) est tres IMP car default est a 0
foreign key(specialite) references MB_SPECIALITE_DD(code)--FK= Clé étrangère
);                                               --*Fin*--
                                                        --
create table MB_DOSSIERPATIENT_DD(             --*Début*--Table DOSSIERPATIENT est relié aux tables DOCTEUR et CONSULTATION
numDos integer primary key,                             --PF= Clef primaire
nomP varchar(30) not null,                              --
prenomP varchar(30) not null,                           --
genre char(1),                                          --
check (genre in ('F','M')),                             --
numAS varchar (12) UNIQUE,                             --assurance maladie a (4 caractères + 8 chiffres) UNIQUE
dateNaiss date not null,                                --
matricule integer,                                      --
dateC date,                                             --
foreign key(matricule) references MB_DOCTEUR_DD(matricule)
 );                                                     --Cette FK n'est pas passé par consultation qui est le lien entre Patient et Docteur
                                                 --*Fin*--
                                                        --
create table MB_CONSULTATION_DD (              --*Début*--Table CONSULTATION est le pont entre DOCTEUR et ORDONNANCE     
CodeDocteur integer,                                    --PFa=Clef primaire #1
numDos integer,                                         --PFb=Clef primaire #2
dateC date,                                             --PFc=Clef primaire #3 PK qui n'a pas un format INTEGER ???
numOrd integer,                                         --
primary key(CodeDocteur,numDos,dateC),                  --PK=PRIMAY KEY composé de CodeDocteur,numDos,dateC
diagnostic varchar(500) not null,                       -- UN diagnostic peut-etre complexe et necessite de l'espace
foreign key(CodeDocteur) references MB_DOCTEUR_DD(matricule),
foreign key(numDos) references MB_DOSSIERPATIENT_DD(numDos),
foreign key(numOrd) references MB_ORDONNANCE_DD(numOrd)
                                                        --FK= Clé étrangère qui lient la table DOCTEUR + DOSSIERPATIENT avec ORDONNANCE 
);                                              --*Fin*--

/*** --*Fin*--***CODE SQL POUR CREER 9 TABLES
**********************************************************************************************************
*******************************REQ SQL pour tester les tables ********************************************
*/
--Insertion de DATAs dans la table1 CATEGORIES avec la 
Insert into MB_CATEGORIES_DD (idCategorie, nom, Description) values (1, 'Analgésiques et Anti-inflammatoires', 'bla bla 1');
Insert into MB_CATEGORIES_DD (idCategorie, nom, Description) values (2, 'Antibiotiques et Antibactériens', 'bla bla 2');
Insert into MB_CATEGORIES_DD (idCategorie, nom, Description) values (3, 'Antituberculeux et Antilépreux', 'bla bla 3');
Insert into MB_CATEGORIES_DD (idCategorie, nom, Description) values (4, 'Antimycosiques', 'bla bla 4');
Insert into MB_CATEGORIES_DD (idCategorie, nom, Description) values (5, 'Antiviraux', 'bla bla 5');
Insert into MB_CATEGORIES_DD (idCategorie, nom, Description) values (11, 'Gynécologie obstétrique et contraception', 'bla bla 6');
Insert into MB_CATEGORIES_DD (idCategorie, nom, Description) values (25, 'Vaccins, immunoglobulines, sérothérapie', 'bla bla 7');

--Insertion de DATAs dans la table2 MEDICAMENT avec la 
Insert into MB_MEDICAMENT_DD (idMed, categorie, nomMed, prix) values (1001, 1, 'Talimogene Laherparepvec', 10.00);
Insert into MB_MEDICAMENT_DD (idMed, categorie, nomMed, prix) values (1002, 2, 'Isavuconazonium Sulfate', 10.9900);
Insert into MB_MEDICAMENT_DD (idMed, categorie, nomMed, prix) values (1003, 3, 'SGLT2 Inhibitors: Dapagliflozin', 50.90);
Insert into MB_MEDICAMENT_DD (idMed, categorie, nomMed, prix) values (1004, 4, 'Ritonavir + Dasabuvir', 60.90);
Insert into MB_MEDICAMENT_DD (idMed, categorie, nomMed, prix) values (1005, 3, 'Umeclidinium Bromide', 70.90);

--Insertion de DATAs dans la table3 ORDONNANCE avec la 
Insert into MB_ORDONNANCE_DD (numOrd , recommandations , typeO, dateC ) 
   values (1001, 'Recommendations sur le medicament imed 1001', 'Médicament', To_DATE('2019/12/25','YYYY/MM/DD'));
Insert into MB_ORDONNANCE_DD (numOrd , recommandations , typeO, dateC ) 
   values (1002, 'Recommendations sur le medicament imed 1002', 'Médicament', To_DATE('2018/11/25','YYYY/MM/DD'));
Insert into MB_ORDONNANCE_DD (numOrd , recommandations , typeO, dateC ) 
   values (1003, 'Recommendations sur le medicament imed 1003', 'Médicament', To_DATE('2020/10/25','YYYY/MM/DD'));
Insert into MB_ORDONNANCE_DD (numOrd , recommandations , typeO, dateC ) 
   values (1004, 'Recommendations sur le medicament imed 1004', 'Médicament', To_DATE('2019/9/25','YYYY/MM/DD'));
Insert into MB_ORDONNANCE_DD (numOrd , recommandations , typeO, dateC ) 
   values (1005, 'Recommendations sur le medicament imed 1005', 'Médicament', To_DATE('2019/8/25','YYYY/MM/DD'));

Insert into MB_ORDONNANCE_DD (numOrd , recommandations , typeO, dateC ) 
   values (919001, 'Recommendations sur le chirurgie 1001', 'Chirurgie', To_DATE('2019/12/25','YYYY/MM/DD'));
Insert into MB_ORDONNANCE_DD (numOrd , recommandations , typeO, dateC ) 
   values (919002, 'Recommendations sur le chirurgie  imed 1002', 'Chirurgie', To_DATE('2018/11/25','YYYY/MM/DD'));
Insert into MB_ORDONNANCE_DD (numOrd , recommandations , typeO, dateC ) 
   values (919003, 'Recommendations sur le chirurgie  imed 1003', 'Chirurgie', To_DATE('2020/10/25','YYYY/MM/DD'));
Insert into MB_ORDONNANCE_DD (numOrd , recommandations , typeO, dateC ) 
   values (919004, 'Recommendations sur le chirurgie  imed 1004', 'Chirurgie', To_DATE('2019/9/25','YYYY/MM/DD'));
Insert into MB_ORDONNANCE_DD (numOrd , recommandations , typeO, dateC ) 
   values (919005, 'Recommendations sur le chirurgie  imed 1005', 'Chirurgie', To_DATE('2019/8/25','YYYY/MM/DD'));

Insert into MB_ORDONNANCE_DD (numOrd , recommandations , typeO, dateC ) 
   values (99001, 'Recommendations sur le medicament imed 1001', 'Médicament', To_DATE('2019/12/2','YYYY/MM/DD'));
Insert into MB_ORDONNANCE_DD (numOrd , recommandations , typeO, dateC ) 
   values (99002, 'Recommendations sur le medicament imed 1002', 'Médicament', To_DATE('2018/11/2','YYYY/MM/DD'));
Insert into MB_ORDONNANCE_DD (numOrd , recommandations , typeO, dateC ) 
   values (99003, 'Recommendations sur le medicament imed 1003', 'Médicament', To_DATE('2020/10/2','YYYY/MM/DD'));
Insert into MB_ORDONNANCE_DD (numOrd , recommandations , typeO, dateC ) 
   values (99004, 'Recommendations sur le medicament imed 1004', 'Médicament', To_DATE('2019/9/2','YYYY/MM/DD'));
Insert into MB_ORDONNANCE_DD (numOrd , recommandations , typeO, dateC ) 
   values (99005, 'Recommendations sur le medicament imed 1005', 'Médicament', To_DATE('2019/8/2','YYYY/MM/DD'));

--Insertion de DATAs dans la table4 ORDONNANCEMEDICAMENT avec la 
Insert into MB_ORDONNANCEMEDICAMENT_DD (numOrd , idMed , nbBoites) values (99001, 1001, 01);
Insert into MB_ORDONNANCEMEDICAMENT_DD (numOrd , idMed , nbBoites) values (99002, 1002, 10);
Insert into MB_ORDONNANCEMEDICAMENT_DD (numOrd , idMed , nbBoites) values (99003, 1003, 2);
Insert into MB_ORDONNANCEMEDICAMENT_DD (numOrd , idMed , nbBoites) values (99004, 1004, 3);
Insert into MB_ORDONNANCEMEDICAMENT_DD (numOrd , idMed , nbBoites) values (99005, 1005, 4);


--Insertion de DATAs dans la table5 ORDONNANCECHIRURGIE avec la
Insert into MB_ORDONNANCECHIRURGIE_DD (numOrd , rang , nomChirurgie) values (919001, 1, 'Chirurgie cardiaque');
Insert into MB_ORDONNANCECHIRURGIE_DD (numOrd , rang , nomChirurgie) values (919002, 2, 'Chirurgie colorectale');
Insert into MB_ORDONNANCECHIRURGIE_DD (numOrd , rang , nomChirurgie) values (919003, 3, 'Chirurgie générale');
Insert into MB_ORDONNANCECHIRURGIE_DD (numOrd , rang , nomChirurgie) values (919004, 4, 'Chirurgie vasculaire');
Insert into MB_ORDONNANCECHIRURGIE_DD (numOrd , rang , nomChirurgie) values (919005, 5, 'Chirurgie pédiatrique');


Insert into MB_ORDONNANCE_DD (numOrd , recommandations , typeO, dateC ) 
   values (9190011, 'Recommendations sur le chirurgie 1001', 'Chirurgie', To_DATE('2019/12/25','YYYY/MM/DD'));
Insert into MB_ORDONNANCE_DD (numOrd , recommandations , typeO, dateC ) 
   values (9190012, 'Recommendations sur le chirurgie  imed 1002', 'Chirurgie', To_DATE('2018/11/25','YYYY/MM/DD'));
Insert into MB_ORDONNANCE_DD (numOrd , recommandations , typeO, dateC ) 
   values (9190013, 'Recommendations sur le chirurgie  imed 1003', 'Chirurgie', To_DATE('2020/10/25','YYYY/MM/DD'));
Insert into MB_ORDONNANCE_DD (numOrd , recommandations , typeO, dateC ) 
   values (9190014, 'Recommendations sur le chirurgie  imed 1004', 'Chirurgie', To_DATE('2019/9/25','YYYY/MM/DD'));
Insert into MB_ORDONNANCE_DD (numOrd , recommandations , typeO, dateC ) 
   values (9190015, 'Recommendations sur le chirurgie  imed 1005', 'Chirurgie', To_DATE('2019/8/25','YYYY/MM/DD'));
DSFKLDFGJKLHDSFJKHLFDSGKJLHSFDGKJLH

--Insertion de DATAs dans la table6 SPECIALITE avec la
Insert into MB_SPECIALITE_DD (code , titre , description) values (0001, 'Psychiatre', 'Traite la maladie mentale');
Insert into MB_SPECIALITE_DD (code , titre , description) values (0002, 'Chirurgien', 'Opérations à l''aide d''outils');
Insert into MB_SPECIALITE_DD (code , titre , description) values (0003, 'Dermatologue', 'S''occupe des soins de la peau, des muqueuses et des phanères');
Insert into MB_SPECIALITE_DD (code , titre , description) values (0004, 'Gynécologue', 'Diagnostise et traite le système génital de la femme');
Insert into MB_SPECIALITE_DD (code , titre , description) values (0005, 'Neurologue', 'Étudie et traite les troubles du système nerveux, principalement le cerveau');

--Insertion de DATAs dans la table7 DOCTEUR avec la
Insert into MB_DOCTEUR_DD  (matricule, nomM, prenomM, specialite, ville, adresse, niveau, nbrPatients) 
values (2135227,'Diallo', 'Fatoumata bientôt',0001,'Montréal', '1705 Rue Gohier', 'Interne',1);
Insert into MB_DOCTEUR_DD  (matricule, nomM, prenomM, specialite, ville, adresse, niveau, nbrPatients) 
values (2135228,'Chernomyrdin', 'Konstantin',0005,'Montréal', '808 13e Avenue', 'Docteur',2);
Insert into MB_DOCTEUR_DD  (matricule, nomM, prenomM, specialite, ville, adresse, niveau, nbrPatients) 
values (2135229,'Chrétien', 'Jean',0002,'Montréal', '260 Rue Thornhill', 'Docteur',6);
Insert into MB_DOCTEUR_DD  (matricule, nomM, prenomM, specialite, ville, adresse, niveau, nbrPatients) 
values (2135230,'Wolfeschlegelsteinhausenberger', 'Hubert(Papa)',0002,'Montréal', '9 Rue Crois Skye', 'Docteur',8);
Insert into MB_DOCTEUR_DD  (matricule, nomM, prenomM, specialite, ville, adresse, niveau, nbrPatients) 
values (2135233,'Wolfeschlegelsteinhausenberge', 'Manon (Maman)',0003,'Montréal', '9 Rue Crois Skye', 'Docteur',8);

--Insertion de DATAs dans la table8 DOSSIERPATIENT avec la
Insert into MB_DOSSIERPATIENT_DD (numDos, nomP, prenomP, genre, numAS, dateNaiss,  dateC, matricule) 
    values (20277604,'Girard', 'Marc-André','M', 'GIRM45072717', To_DATE('1945/7/27','YYYY/MM/DD'), To_DATE('2019/8/25','YYYY/MM/DD'), 2135229);
Insert into MB_DOSSIERPATIENT_DD (numDos, nomP, prenomP, genre, numAS, dateNaiss,  dateC, matricule) 
    values (20277605,'Girard', 'Marc-André','M', 'GIRM45072718', To_DATE('1945/7/27','YYYY/MM/DD'), To_DATE('2019/8/25','YYYY/MM/DD'), 2135229);
Insert into MB_DOSSIERPATIENT_DD (numDos, nomP, prenomP, genre, numAS, dateNaiss,  dateC, matricule) 
    values (20277606,'Girard', 'Marc-André','M', 'GIRM45072721', To_DATE('1945/7/27','YYYY/MM/DD'), To_DATE('2019/8/25','YYYY/MM/DD'), 2135229);
Insert into MB_DOSSIERPATIENT_DD (numDos, nomP, prenomP, genre, numAS, dateNaiss,  dateC, matricule) 
    values (20277607,'Girard', 'Marc-André','M', 'GIRM45072722', To_DATE('1945/7/27','YYYY/MM/DD'), To_DATE('2019/8/25','YYYY/MM/DD'), 2135229);
Insert into MB_DOSSIERPATIENT_DD (numDos, nomP, prenomP, genre, numAS, dateNaiss,  dateC, matricule) 
    values (20277608,'Girard', 'Marc-André','M', 'GIRM45072723', To_DATE('1945/7/27','YYYY/MM/DD'), To_DATE('2019/8/25','YYYY/MM/DD'), 2135229);






--Insertion de DATAs dans la table9 CONSULTATION avec la
Insert into MB_CONSULTATION_DD (CodeDocteur , numDos, dateC, numOrd, diagnostic) 
values (2135229,20277604, To_DATE('2019/8/25','YYYY/MM/DD'),99001, 'Il vas mourir si ...');
Insert into MB_CONSULTATION_DD (CodeDocteur , numDos, dateC, numOrd, diagnostic) 
values (2135229,20277605, To_DATE('2018/7/25','YYYY/MM/DD'),99001, 'Il vas mourir si ...');
Insert into MB_CONSULTATION_DD (CodeDocteur , numDos, dateC, numOrd, diagnostic) 
values (2135229,20277606, To_DATE('2017/6/25','YYYY/MM/DD'),99001, 'Il vas mourir si ...');
Insert into MB_CONSULTATION_DD (CodeDocteur , numDos, dateC, numOrd, diagnostic) 
values (2135229,20277607, To_DATE('2016/5/25','YYYY/MM/DD'),99001, 'Il vas mourir si ...');
Insert into MB_CONSULTATION_DD (CodeDocteur , numDos, dateC, numOrd, diagnostic) 
values (2135229,20277608, To_DATE('2015/4/25','YYYY/MM/DD'),99001, 'Il vas mourir si ...');

--Test Contrainte
Insert into MB_ORDONNANCEMEDICAMENT_DD (numOrd , idMed , nbBoites) values (99006, 1005, -1);
Insert into MB_ORDONNANCEMEDICAMENT_DD (numOrd , idMed , nbBoites) values (99006, 1005, 101);
Insert into MB_MEDICAMENT_DD (idMed, categorie, nomMed, prix) values (1001, 1, 'Botulinum Toxins: OnabotulinumtoxinA', 10.00); --TST DOUBLONS
Insert into MB_DOCTEUR_DD  (matricule, nomM, prenomM, specialite, ville, adresse, niveau, nbrPatients) 
values (2135233,'Wolfeschlegelsteinhausenbergerdorff', 'Sofia (fille','Interne','Montréal', '9 Rue Crois Skye', 'Docteur',8);
Insert into MB_DOCTEUR_DD  (matricule, nomM, prenomM, specialite, ville, adresse, niveau, nbrPatients) 
values (2135226,'Girard', 'Marc-André',0001,' L’Immaculée-Conception-de-la-Bienheureuse', '1352 Rue des Iris', 'Étudiant',0);
Insert into MB_DOSSIERPATIENT_DD (numDos, nomP, prenomP, genre, numAS, dateNaiss,  dateC, matricule) 
    values (20277603,'Girard', 'Marc-André','M', 'GIRM45072717', To_DATE('1945/7/27','YYYY/MM/DD'), To_DATE('2019/8/25','YYYY/MM/DD'), 2135229);

