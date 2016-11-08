
-- Diagnosis

UPDATE diagnosis_controls SET flag_active = 0;




















Verifier ce champ... DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='drug_list') AND structure_fields.model LIKE 'TreatmentExtendDetail');
DELETE FROM structure_formats WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='drug_list') AND structure_fields.model LIKE 'TreatmentExtendDetail');
DELETE FROM structure_fields WHERE structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='drug_list') AND structure_fields.model LIKE 'TreatmentExtendDetail';



--   ### 1 # Added Investigator and Funding sub-models to study tool
--   ### 2 # Replaced the study drop down list to both an autocomplete field and a text field
--   ### 2 # Added Study Model to the databrowser
--   ### 6 # Replaced the drug drop down list to both an autocomplete field and a text field plus moved drug_id field to Master model
--   ### 8 # Order tool upgrade
--   ### 9 # New Sample and aliquot controls
--
--      Created:
--			- Buffy Coat
--			- Nail
--			- Stool
--			- Vaginal swab














Bug au niveau de la chronology. Si PSA bcr = no, la données s'affiche comme BCR dans la chronology.

Ne garder au niveau de specimen 'creation sans incident et le flager a no par defaut
PAr défaut date entreposage = date creeation si template ou pbmc, etc
On veut voire les bcr de l'année dans le rapport et non pas juste la première.
Avec les tempaltes jouer sur les valeurs par défaut pour ne pas répeter comme entreposé par. Permet avoir valeur par défaut.

Dans les liste de traitement, annotation etc... avoir le bouton edit pour ne pas à avoir acliquer sur detail.
Ajouter email dans contact











Voudrait proposer la boite et la position par default en fonction du dernier aliquot de même type entreposé.....
Ajouter la boite et la position au niveau du fichier de transfert...

-- Reunion du 2016 10 11 ------------------------------------------------------------------------------------------------------------------

Creation d'une collection... bypasser le add collection - New collection creation sauf si y a des collections seules.

-- Collection

Ajouter a coté du champ visite une deuxieme drop down list 1 to 9 pour faire les visite v02.1, etc
Enlever I confirm that the identity....
Dans l'arbre de clinical collection link, afficher les specimens collectés au niveau de la collection.

-- Sang

Ne plus créer les tubes de sang qui sont créés mais pas disponibles car centrifugés tout de suite
Maintenant on a plus que 2 tubes de 1.5ml

On va créer 6 tubes de plasma de 1.8ml
On va créer 2 tubes de bfc 1 de 300ul et l'autre indéterminé.
On va créer aussi à partir des tubes EDTA du PBMC, 3 tubes (des fois juste 1). Mettre 1 par défaut.

Plus de papier whatman dans le template. Les garder en inventaire.

Pour les nouveaux tubes de sang pas de siasie de temps sur glace. Donc garder les vieilles données mais ne pas afficher pour 'add' et 'edit'.

'the blood collection was done' mettre 'clinic' par défaut.
Les 3 derniers check boxes garder les valeurs en BD mais ne plus les afficher.

Flager a deleted les tubes de sang (mis a part paxgene) qui sont'not in stock' dans la base de données car ne servent à rien.


-- Plasma, serum, pbmc, bfc 

Remplacer creation date par centrifugation date.
Verifier que date et heure de la centrifugation est bien recopiée à partir du plasma créé initialement.

---> Tube de plamsa

hemolyze no par defaut.
1.8 ml par defaut

---> Tube de paxgene

Pas d'expiration date.
Dans les banques il n'y a aucune position de saisie car devait être envoyé directement à PROCURE. Il faut loader les positions maintenant. 
Voire si on peut loader les position en batch.

---> Tube pbmc

Ajouter concentration et nbr de cellules. Comme sur la version de l'axe cancer.

-- Aliquots (general)

Aller chercher le dernier aliquots entreposés, chercher la boite, et afficher la boite par défaut et la prochaine position.
Bloquer si un tube est déjà à la position.
Remplacer initial storage date par storage date tout court.

-- Urine

Garder temps sur la galce.
Valuer no par defaut. Valeur Clear par defaut.
Date de centrifugation pour l'urine centrifugé.
Pas de cup d'urine.

On créé 4 tubes de 5ml d'urine centrifugé.

Pour le champ approximate volume of pellet, supprimer le for 50 ml et ajouter dans le dexuieme champ 50 par defaut.


-- Urine centrifugé.

Cacher le caoncentrated flag dans les écrans de add et edit

Enlever le processed at arrival et le stored à 4c et urine aspect mais garder pellet aspect.


---------------------------------------------------------------------------------------

-- F1a

Supprimer la fiche global de medicament (F1a).
Supprimer chir pour hyperplasie de la prostate et créer un traitement hyperplasie de la prostate.

-- F1

Date de la visite devient un formulaire mise a jour des données clinique.
Date de chirurgie est deja dna s treatment prostatectomie.
La recidive biochimique on s'en fout car deja dans PSA.

Recidive clinique displarait par contre on doit:
  - Ajouter une precision (chest / abomen pelvis / FDG) au niveau des examen.
  - Si un examen est positifi l'utilisateur est redirigé vers un nouveau formulaire 'Progression & Comorbidité' avec un champ select qui liste tous les examens la date 
  est donc celle de l'Examen et un deuxieme champ detail avec hydronephrosis, bone metastases, liver metastasesm spinal cord compression, region chirurgicale, etc). Faudra migrer ce qui existe deja.

Ajouter biopsie a la liste des examen
AJouter chirurgie metastase dans treatment.


Enlever le je confirme...

Supprimer les F1 F1a.... et les noms des worksheet.

Donc en gros plus de viche F1 F1a general.

PSA BCR No par defaut.

Testosterone a ajouter dans les dosage APS.... qui devient biochimie - nmol par litre. Mettre sur même ligne cqr probablement au meme moment.

Pour le type d'examen regarder si on veut vraiment une liste ou on garde un champ texte...



La version demo fin octobre....
Migration avant Noel....

Sortir la liste de tous les champs des 4 sites pour comparaison.

Penser au dernieres données a migrer de claire et lucie...

Path review et RIN sont mis au cusm dans un fichier structuré seront migrés dans ATiM dans un prochain temps.











mysql -u root procure --default-character-set=utf8 < 





mysql -u root procure --default-character-set=utf8 < atim_procure_v2.6.0_full_installation.sql
mysql -u root procure --default-character-set=utf8 < atim_v2.6.1_upgrade.sql
mysql -u root procure --default-character-set=utf8 < atim_v2.6.2_upgrade.sql
mysql -u root procure --default-character-set=utf8 < custom_post262.sql
mysql -u root procure --default-character-set=utf8 < atim_v2.6.3_upgrade.sql
mysql -u root procure --default-character-set=utf8 < custom_post263.sql
mysql -u root procure --default-character-set=utf8 < custom_post263.2.sql
mysql -u root procure --default-character-set=utf8 < atim_v2.6.4_upgrade.sql
mysql -u root procure --default-character-set=utf8 < custom_post264.sql
mysql -u root procure --default-character-set=utf8 < atim_v2.6.5_upgrade.sql
mysql -u root procure --default-character-set=utf8 < custom_post265.sql
mysql -u root procure --default-character-set=utf8 < atim_v2.6.6_upgrade.sql
mysql -u root procure --default-character-set=utf8 < custom_post266.sql
mysql -u root procure --default-character-set=utf8 < atim_v2.6.7_upgrade.sql
mysql -u root procure --default-character-set=utf8 < custom_post267.sql
