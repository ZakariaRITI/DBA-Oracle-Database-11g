
REM     Insertion des données de la base


delete from detail;
delete from article;
delete from commande;
delete from client;

Insert into client values(1,'ALAMI','Casa');
Insert into client values(2,'BENNANI','Rabat');
Insert into client values(3,'ANBARI','Casa');
Insert into client values(4,'ANOUAR','Rabat');
Insert into client values(5,'SAMIA','Fes');
Insert into client values(6,'AHMED','Casa');
Insert into client values(7,'NADIA','Rabat');
Insert into client values(8,'NABIL','Casa');
Insert into client values(9,'SAMIRA','Rabat');
Insert into client values(10,'WASSIM','Casa');



Insert into commande(num_cde,matricule_CLT) values(100,1);
Insert into commande(num_cde,matricule_CLT) values(101,2);
Insert into commande(num_cde,matricule_CLT) values(102,3);
Insert into commande(num_cde,matricule_CLT) values(103,1);
Insert into commande(num_cde,matricule_CLT) values(104,2);
Insert into commande(num_cde,matricule_CLT) values(105,3);
Insert into commande(num_cde,matricule_CLT) values(106,1);
Insert into commande(num_cde,matricule_CLT) values(107,10);
Insert into commande(num_cde,matricule_CLT) values(108,8);
Insert into commande(num_cde,matricule_CLT) values(109,9);


Insert into article values(10,'Cartable',200);
Insert into article values(11,'Stylo',20);
Insert into article values(12,'Gomme',10);
Insert into article values(13,'Crayon',15);
Insert into article values(14,'Regle',100);
Insert into article values(15,'Classeur',150);
Insert into article values(16,'PC Portable',4000);
Insert into article values(17,'Souris',50);


Insert into detail values(100,10,20);
Insert into detail values(100,11,10);
Insert into detail values(100,12,15);
Insert into detail values(100,13,5);
Insert into detail values(101,10,10);
Insert into detail values(101,11,25);
Insert into detail values(102,12,30);
Insert into detail values(103,10,15);
Insert into detail values(103,13,12);
Insert into detail values(104,16,10);
Insert into detail values(105,17,15);
Insert into detail values(108,14,30);
Insert into detail values(108,13,25);
Insert into detail values(104,12,10);
Insert into detail values(104,10,15);

Commit;




