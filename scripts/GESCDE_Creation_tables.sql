REM    Script de la base de données

drop table client cascade constraints;

create table client(Matricule number(5) constraint PK_Clt_Mat Primary Key,
                    Nom varchar2(30) Not null,
                    ville varchar2(20) check (ville in('Casa','Rabat','Fes','Tanger'))
                   );

drop table commande cascade constraints;

create table commande(Num_CDE number(6) primary key,
                      Date_CDE date default sysdate,
                      Matricule_clt number(5),
                      constraint FK_Mat_Clt foreign key (Matricule_clt)
                      references client(Matricule) on delete cascade);
 

drop table article cascade constraints;

create table article(Code_art number(3) primary key,
                     designation varchar2(20),
                     prix number(9,2)
                     );

drop table detail cascade constraints;

create table detail(Num_CDE number(6) references commande(Num_CDE) on delete cascade,
                    Code_ART  number(3) references article(Code_ART) on delete cascade,
                    QTE number(4) check (QTE>=0),
                    Constraint PK_detail Primary Key(Num_CDE,Code_ART)
                    );

desc client;
desc commande;
desc article;
desc detail;
