Oracle Infrastructure Management – Projet DBA

Déploiement, sécurisation et migration d'une infrastructure de base de données Oracle 11g.

🚀 Description du projet

Ce projet consiste en la gestion complète du cycle de vie d'une instance Oracle 11g ("Prod") au sein d'une structure multi-départementale. L'objectif était de garantir la haute disponibilité, la sécurité des accès et l'optimisation des performances via une migration physique vers un stockage SSD.

✨ Réalisations techniques
Architecture & Haute Disponibilité

    Déploiement : Utilisation de l'outil DBCA (Database Configuration Assistant) pour l'initialisation de l'instance.

    Optimisation du stockage : Allocation de tablespaces dédiés pour chaque département afin d'isoler les données.

    Sécurisation des fichiers : Multiplexage des fichiers de contrôle et des Redo Logs pour prévenir toute perte de données.

Sécurité & Conformité

    Contrôle d'accès : Mise en place d'une politique de sécurité granulaire (RBAC).

    Gestion des ressources : Création de profils de sécurité et attribution de quotas de stockage.

    Privilèges : Administration fine des droits systèmes et objets (ex: isolation des schémas HR et GESCDE).

Monitoring & Maintenance

    Audit : Exploitation avancée du dictionnaire de données (DBA_ views) pour le suivi de l'activité et de l'intégrité de la base.

    Sauvegarde : Passage de l'instance en mode ARCHIVELOG pour permettre la restauration en cas de crash.

    Migration : Migration physique des fichiers de données (Datafiles) vers une nouvelle infrastructure de stockage SSD pour gain de performance.

🛠 Stack Technique

    SGBD : Oracle Database 11g

    Outils d'administration : DBCA, SQL*Plus

    Concepts : Tablespaces, Redo Logs, Profiles, Rôles, Archivelog

    OS : Oracle Linux / Unix

📂 Structure du dépôt

    /scripts : Scripts SQL utilisés pour la création des rôles, profils et utilisateurs.

    /docs : Rapports techniques sur la stratégie de migration et le schéma d'architecture.
