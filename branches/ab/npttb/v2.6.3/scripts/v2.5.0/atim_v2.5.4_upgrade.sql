INSERT INTO `versions` (version_number, date_installed, trunk_build_number) VALUES
('2.5.4', NOW(), '5152');

INSERT IGNORE INTO i18n (id,en,fr) VALUES ('delete collection link','Delete Collection Link','Supprimer Lien à la Collection');

INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
('treatment precisions','Treatment Precisions','Précisions du traitement'),
('chemotherapy drugs','Chemotherapy Drugs','Molécules de Chimiothérapie'),
('surgeries','Surgeries','Chirurgies');
