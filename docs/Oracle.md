# **PARTIE1:**



#### se connecter a la bdd avec sys:

C: \\Users\\RIKO>set ORACLE\_SID=BDD2026



C:\\Users\\RIKO>sqlplus



Enter user-name: sys/oracle as sysdba

\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

#### Le nom de la base et de service SID:

SQL> SELECT name FROM v$database;





SQL> SELECT instance\_name FROM v$instance;



\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_



#### Le fichier de paramètres d’initialisation:

SQL> SHOW PARAMETER spfile;

\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_



#### Deux fichiers de contrôle:

SELECT name FROM v$controlfile;

\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

#### Fichiers de données:

SQL> SELECT tablespace\_name, file\_name FROM dba\_data\_files;



SQL> SELECT tablespace\_name, file\_name FROM dba\_temp\_files;



\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

#### Trois groupes de fichier de journalisation:

SQL> SELECT group#, members FROM v$log;



SQL> SELECT group#, member FROM v$logfile;



# **PARTIE2:**

#### 

#### Création fichiers de données pour chaque service:

SQL> CREATE TABLESPACE TS\_COMPTABILITE DATAFILE 'D:\\APP\\RIKO\\ORADATA\\BDD2026\\SERVICES\\COMPTA01.DBF' SIZE 50M;





SQL> CREATE TABLESPACE TS\_COMMERCIAL DATAFILE 'D:\\APP\\RIKO\\ORADATA\\BDD2026\\SERVICES\\COM01.DBF' SIZE 50M;





SQL> CREATE TABLESPACE TS\_RH DATAFILE 'D:\\APP\\RIKO\\ORADATA\\BDD2026\\SERVICES\\RH01.DBF' SIZE 50M;





SQL> CREATE TABLESPACE TS\_ACHAT DATAFILE 'D:\\APP\\RIKO\\ORADATA\\BDD2026\\SERVICES\\ACHAT01.DBF' SIZE 50M;



SQL> CREATE TABLESPACE TS\_PRODUCTION DATAFILE 'D:\\APP\\RIKO\\ORADATA\\BDD2026\\SERVICES\\PROD01.DBF' SIZE 50M;



\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

#### Multiplexage des fichiers de contrôle:

SQL> ALTER SYSTEM SET control\_files =

'D: \\APP\\RIKO\\ORADATA\\BDD2026\\CONTROL01.CTL'

'D: \\APP\\RIKO\\FLASH\_RECOVERY\_AREA\\BDD2026\\CONTROL02.CTL',

'D: \\APP\\RIKO\\PROJET\\CONTROL\\ CONTROL03.CTL'

SCOPE=SPFILE;



SQL> SHUTDOWN IMMEDIATE;



SQL> SELECT name FROM v$controlfile;





\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

#### Multiplexage des fichiers de journalisation :

SQL> ALTER DATABASE ADD LOGFILE MEMBER 'D:\\APP\\RIKO\\PROJET\\REDO\\RED001\_B.LOG' TO GROUP 1;





SQL> ALTER DATABASE ADD LOGFILE MEMBER 'D:\\APP\\RIKO\\PROJET\\REDO\\RED002\_B.LOG' TO GROUP 2;





SQL> ALTER DATABASE ADD LOGFILE MEMBER 'D:\\APP\\RIKO\\PROJET\\REDO\\RED003\_B.LOG' TO GROUP 3;



SQL> SELECT group#, member, status FROM v$logfile ORDER BY group#;



SQL> SELECT group#, COUNT(member) AS nombre\_de\_membres

FROM v$logfile

GROUP BY group#

ORDER BY group#;



\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

#### Création d'une copie de sauvegarde du fichier de paramètres:

SQL> CREATE PFILE='D:\\APP\\RIKO\\PROJET\\BACKUP\\SpfileProd\_bak. ora' FROM SPFILE;





# **PARTIE3:**



#### Création des profils, quotas et utilisateurs:



\-- Profil pour les chefs de service (plus de sécurité sur les tentatives)

CREATE PROFILE PROF\_CHEF LIMIT

&#x20; FAILED\_LOGIN\_ATTEMPTS 3

&#x20; PASSWORD\_LIFE\_TIME 90;



\-- Profil pour les employés standard

CREATE PROFILE PROF\_EMPLOYE LIMIT

&#x20; FAILED\_LOGIN\_ATTEMPTS 5

&#x20; PASSWORD\_LIFE\_TIME 60;



\-- Création des utilisateurs

CREATE USER CPT\_USER1 IDENTIFIED BY pass123 DEFAULT TABLESPACE TS\_COMPTABILITE PROFILE PROF\_EMPLOYE;

CREATE USER CPT\_USER2 IDENTIFIED BY pass123 DEFAULT TABLESPACE TS\_COMPTABILITE PROFILE PROF\_EMPLOYE;

CREATE USER CPT\_CHEF  IDENTIFIED BY pass123 DEFAULT TABLESPACE TS\_COMPTABILITE PROFILE PROF\_CHEF;



\-- Attribution des quotas (capacité de stockage)

ALTER USER CPT\_USER1 QUOTA 10M ON TS\_COMPTABILITE;

ALTER USER CPT\_USER2 QUOTA 10M ON TS\_COMPTABILITE;

ALTER USER CPT\_CHEF  QUOTA UNLIMITED ON TS\_COMPTABILITE;





SELECT username, default\_tablespace, profile 

FROM dba\_users 

WHERE username LIKE 'CPT\_%' OR username LIKE 'RH\_%' OR username LIKE 'COM\_%'

ORDER BY username;



\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

#### Autorisation de connexion et création d'objets :

\-- Création d'un rôle personnalisé

CREATE ROLE ROLE\_PROD\_ACCESS;



\-- Attribution des privilèges système au rôle

GRANT CREATE SESSION, 

&#x20;     CREATE TABLE, 

&#x20;     CREATE VIEW, 

&#x20;     CREATE PROCEDURE, 

&#x20;     CREATE SEQUENCE, 

&#x20;     CREATE TRIGGER, 

&#x20;     CREATE SYNONYM 

TO ROLE\_PROD\_ACCESS;



GRANT ROLE\_PROD\_ACCESS TO 

&#x20; CPT\_USER1, CPT\_USER2, CPT\_CHEF,

&#x20; RH\_USER1, RH\_USER2, RH\_CHEF,

&#x20; COM\_USER1, COM\_USER2, COM\_CHEF;



\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

#### Accès du service Ressources Humaines au schéma HR:

ALTER USER HR ACCOUNT UNLOCK IDENTIFIED BY hr;



\-- Donner le droit de lecture sur toutes les tables du schéma HR

GRANT SELECT ANY TABLE TO RH\_USER1, RH\_USER2, RH\_CHEF;



\-- OU (plus précis pour le schéma HR spécifiquement)

GRANT SELECT ON HR.EMPLOYEES TO RH\_USER1, RH\_USER2, RH\_CHEF;

GRANT SELECT ON HR.DEPARTMENTS TO RH\_USER1, RH\_USER2, RH\_CHEF;

GRANT SELECT ON HR.JOBS TO RH\_USER1, RH\_USER2, RH\_CHEF;



\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

#### Accès du service Commercial au schéma GESCDE:

\-- Création du propriétaire du schéma

CREATE USER GESCDE IDENTIFIED BY gescde123 

DEFAULT TABLESPACE TS\_COMMERCIAL;



\-- Droits de base pour le propriétaire

GRANT CREATE SESSION, CREATE TABLE TO GESCDE;

ALTER USER GESCDE QUOTA UNLIMITED ON TS\_COMMERCIAL;



REM    Script de la base de données



\-- Droits de lecture et modification sur les tables du schéma GESCDE

GRANT SELECT, INSERT, UPDATE, DELETE ON GESCDE.client TO COM\_USER1, COM\_USER2, COM\_CHEF;

GRANT SELECT, INSERT, UPDATE, DELETE ON GESCDE.commande TO COM\_USER1, COM\_USER2, COM\_CHEF;

GRANT SELECT, INSERT, UPDATE, DELETE ON GESCDE.article TO COM\_USER1, COM\_USER2, COM\_CHEF;

GRANT SELECT, INSERT, UPDATE, DELETE ON GESCDE.detail TO COM\_USER1, COM\_USER2, COM\_CHEF;





SQL> desc client;



SQL> desc commande;



SQL> desc article;



SQL> desc detail;





Enter user-name: com\_user1

Enter password:



SQL> select \* from gescde.client;



\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

#### Transfert de l'utilisateur de la Comptabilité vers le Commercial

\-- Changer le tablespace par défaut vers le Commercial

ALTER USER CPT\_USER2 DEFAULT TABLESPACE TS\_COMMERCIAL;



\-- Accorder un quota sur le nouveau tablespace

ALTER USER CPT\_USER2 QUOTA 10M ON TS\_COMMERCIAL;



\-- Optionnel : Supprimer son quota sur l'ancien tablespace (Comptabilité)

ALTER USER CPT\_USER2 QUOTA 0 ON TS\_COMPTABILITE;





\-- Lui donner l'accès au schéma de Gestion des Commandes (GESCDE)

GRANT SELECT, INSERT, UPDATE, DELETE ON GESCDE.client TO CPT\_USER2;

GRANT SELECT, INSERT, UPDATE, DELETE ON GESCDE.commande TO CPT\_USER2;

GRANT SELECT, INSERT, UPDATE, DELETE ON GESCDE.article TO CPT\_USER2;

GRANT SELECT, INSERT, UPDATE, DELETE ON GESCDE.detail TO CPT\_USER2;





SELECT username, default\_tablespace 

FROM dba\_users 

WHERE username = 'CPT\_USER2';



# **PARTIE4:**

#### **Vérification des noms et emplacements des fichiers de données:**

**SELECT tablespace\_name, file\_name, bytes / 1024 / 1024 AS "Taille (Mo)"**

**FROM dba\_data\_files**

**WHERE tablespace\_name IN ('TS\_COMPTABILITE', 'TS\_COMMERCIAL', 'TS\_RH', 'TS\_ACHAT', 'TS\_PRODUCTION')**

**ORDER BY tablespace\_name;**



#### **État des fichiers de données (Online/Offline):**

**SELECT file\_name, tablespace\_name, status, online\_status** 

**FROM dba\_data\_files** 

**WHERE tablespace\_name LIKE 'TS\_%';**





\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

#### Vérification des utilisateurs créés:

SELECT username, default\_tablespace, profile, account\_status

FROM dba\_users

WHERE username LIKE 'CPT\_%' OR username LIKE 'RH\_%' OR username LIKE 'COM\_%' OR username = 'GESCDE'

ORDER BY username;



\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

#### Vérification les tables, contraintes, indexes et privilèges:

SELECT table\_name, tablespace\_name, num\_rows

FROM dba\_tables

WHERE owner = 'GESCDE';



SELECT table\_name, constraint\_name, constraint\_type, status

FROM dba\_constraints

WHERE owner = 'GESCDE'

ORDER BY table\_name;



SELECT owner, index\_name, table\_name, index\_type 

FROM dba\_indexes 

WHERE owner = 'GESCDE';





SELECT role, privilege, admin\_option

FROM role\_sys\_privs

WHERE role = 'ROLE\_DEV\_PROD'

ORDER BY privilege;



SELECT grantee, table\_name, privilege, grantor

FROM dba\_tab\_privs

WHERE grantee LIKE 'RH\_%' OR grantee LIKE 'COM\_%'

ORDER BY grantee;



SELECT grantee, table\_name, privilege, grantable 

FROM dba\_tab\_privs 

WHERE grantee IN ('RH\_CHEF', 'COM\_CHEF', 'CPT\_USER2')

ORDER BY grantee;





\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

#### Requêtes supplémentaires pertinentes:



a. État des Quotas sur les Tablespaces

SELECT tablespace\_name, username, max\_bytes / 1024 / 1024 AS "Limite (Mo)"

FROM dba\_ts\_quotas

WHERE username LIKE 'CPT\_%' OR username LIKE 'RH\_%' OR username LIKE 'COM\_%';





b. Multiplexage des Fichiers de Contrôle

SELECT name AS "Fichiers de Controle" FROM v$controlfile;





c. Multiplexage des Journaux (Redo Logs)

SELECT group#, member, type FROM v$logfile ORDER BY group#;





d. Détails précis des limitations des Profils

SELECT profile, resource\_name, limit 

FROM dba\_profiles 

WHERE profile IN ('PROF\_CHEF', 'PROF\_EMPLOYE')

&#x20; AND resource\_type = 'PASSWORD'

ORDER BY profile;



e. Vérification du Fichier de Paramètres (Spfile)

SELECT name, value 

FROM v$parameter 

WHERE name = 'spfile';



\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_



# **PARTIE5:**



#### **Transfert de fichiers de données**



**2.5.1 Mise hors ligne des tablespaces**



**ALTER TABLESPACE TS\_COMPTABILITE OFFLINE;**



**2.5.2 Déplacement physique et logique des fichiers (UX1, UX2, UX3)**



**ALTER TABLESPACE TS\_COMPTABILITE** 

**RENAME DATAFILE 'D:\\APP\\RIKO\\ORADATA\\BDD2026\\SERVICES\\COMPTA01.DBF'** 

**TO 'D:\\app\\RIKO\\PROJET\\UX1\\COMPTA01.DBF';**



**2.5.3 Remise en ligne des tablespaces et vérification**

**ALTER TABLESPACE TS\_COMPTABILITE ONLINE;**



**SELECT file\_name, tablespace\_name, status** 

**FROM dba\_data\_files** 

**WHERE tablespace\_name = 'TS\_COMPTABILITE';**

&#x20;

\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

# **PARTIE ARCHIVAGE:**



**Archive log list;**



**SQL> ALTER SYSTEM SET log\_archive\_dest\_1="location=D:\\app\\RIKO\\PROJET\\Archive1 MANDATORY" SCOPE=spfile;**



SQL> ALTER SYSTEM SET log\_archive\_dest\_2="location=D:\\app\\RIKO\\PROJET\\Archive2 OPTIONAL" SCOPE=spfile;



SQL> shutdown immediate;

SQL> startup mount;

SQL> alter database archivelog;

SQL> alter database open;



SQL> ALTER SYSTEM SWITCH LOGFILE;



