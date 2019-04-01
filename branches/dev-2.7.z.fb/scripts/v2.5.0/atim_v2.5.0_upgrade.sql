INSERT INTO `versions` (version_number, date_installed, build_number) 
VALUES('2.5.0', NOW(),'4792');

SELECT IF(sample_type='amplified rna', 'Purified RNA sample type has changed from 2.4.3 to 2.4.3A. It has now been deactivated. Read the release notes for more informations.', '') as msg FROM sample_controls WHERE sample_type='purified rna';
UPDATE parent_to_derivative_sample_controls SET flag_active=0 WHERE parent_sample_control_id=(SELECT id FROM sample_controls WHERE sample_type='purified rna') OR derivative_sample_control_id=(SELECT id FROM sample_controls WHERE sample_type='purified rna');

REPLACE INTO i18n (id, en, fr) VALUES
("time_hour", "Time", "Heure"),
("tracking #", "Tracking #", "# de suivi"),
("phone #", "Phone #", "# de téléphone"),
("department/door", "Department/Door", "Département/Porte"),
('events','Events','Événements'),
('aliquot details', 'Aliquot Details', 'Détails aliquot'),
('order line details', 'Order Line Details', 'Détails ligne commande'),
('no storage layout is defined for this storage type','No storage layout is defined for this storage type','Aucun plan d''entreposage est défini pour ce type d''entreposage'),
("has notes", "Has notes", "A des notes"),
("nodes selection", "Nodes selection", "Sélection des noeuds"),
("passwords do not match", "Passwords do not match.", "Les mots de passe ne correspondent pas."),
('data conflict: at least one updated aliquot is defined as not in stock - please update in stock value', 'Data conflict: At least one updated aliquot is defined as not in stock. Please update in stock value.', "Conflit de données : Au moins un aliquot mis à jour est défini comme 'non stocké'. Veuillez mettre a jour la valeur 'En Stock'."),
('aliquots positions have been deleted', 'Aliquots positions have been deleted', 'Les positions des aliquots ont été supprimées'),
('data conflict: you can not remove aliquot and set a storage','Data conflict: You can not remove aliquot and set a storage', ' Conflit de données : Vous ne pouvez pas enlever l''aliquot et lui associer un entreposage'),
('the aliquot with barcode [%s] has reached a volume below 0','The aliquot with barcode [%s] has reached a volume below 0.',"L'aliquot avec le code à barres [%s] a atteint un volume inférieur à 0."),
('starting element','Starting Element','Élément de départ'),
('you have been redirected automatically','you have been redirected automatically','Vous avez été redirigé automatiquement'),
('no source aliquot data has to be updated','No data has to be updated!','Aucune donnée n''a a être mise à jour!'),
('viability (%)', 'Viability (&#37;)', 'Viabilité (&#37;)'),
("batch_alter_msg", 
 "Some batch functions permissions were altered based on their unit counterpart.",
 "Les permissions de certaines fonctions en lot on été altérées étant donné l'était de leur contrepartie unitaire."), 
("recurrent", "Recurrent", "Récurrent"),
("collection to creation spent time (min)", "Collection to creation spent time (min)", "Temps écoulé entre la collection et la création (min)"),
("creation to storage spent time (min)", "Creation to storage spent time (min)", "Temps écoulé entre la création et l'entreposage (min)"),  
("there is no data to add to a temporary batchset", "There is no data to add to a temporary batchset.", "Il n'y a pas de données à ajouter à un lot de données temporaire."),
("add to temporary batchset", "Add to temporary batchset", "Ajouter à un lot de données temporaire"),
("group", "Group", "Groupe"),
("change group", "Change group", "Changement de groupe"),
("this user name is already in use", "This user name is already in use.", "Ce nom d'utilisateur est déjà utilisé."),
("multi_entry_form_confirmation_msg",
 "You are about to submit a form with multiple entries. Do you want to continue?",
 "Vous êtes sur le point de soumettre un formulaire contenant des entrées multiples. Souhaitez-vous continuer?"),
("batch_edit_confirmation_msg", 
 "Batch edit operations are not reversible. Do you want to continue?", 
 "Les opérations de modification en lot ne peuvent pas être annulées. Souhaitez-vous continuer?"), 
('source aliquot detail', 'Source Aliquot Detail', 'Détail aliquot source'),
('edit link', 'Edit Link', 'Modifier lien') ,
('delete link', 'Delete Link', 'Supprimer lien') ,
('parent aliquot detail', 'Parent Aliquot Detail', 'Détail aliquot parent'),
("merge_confirmation_msg",
 "Merge actions cannot be undone. Do you want to continue?",
 "Les fusions ne peuvent pas être annulées. Souhaitez-vous continuer?"),
('import precisions from associated protocol','Import Precisions From Protocol','Importer précisions du protocole'),
("bad internet explorer version msg",
 "You need to use Internet Explorer 8+. If you already have such a version, make sure Compatibility View is turned off.",
 "Vous devez utiliser Internet Explorer 8+. Si vous avez déjà une telle version, assurez-vous que le mode de compatibilité est désactivé."),
("common-law partner", "Common-Law Partner", "Conjoint de fait"),
("unmatched value", "Unmatched value", "Valeur sans correspondance"),
("supported value", "Supported value", "Valeur supportée"),
("some identifiers were not merge because they were conflicting",
 "Some identifiers were not merge because they were conflicting.",
 "Certains identifiants n'ont pas été fusionnés car ils étaient conflictuels."),
('the collection date is after the storage date','The storage date is earlier than the collection date.',"La date d'entreposage est anterieure à la date de collection."),
('the creation date is after the storage date','The storage date is earlier than the creation date.',"La date d'entreposage est anterieure à la date de création."),
('the reception date is after the storage date','The storage date is earlier than the reception date.',"La date d'entreposage est anterieure à la date de réception."),
("collection to storage spent time (min)", "Collection to Storage Spent Time (min)", "Temps écoulé entre le prélèvement et l'entreposage (min)"),
("reception to storage spent time (min)", "Reception to storage spent time (min)", "Temps écoulé entre la réception et l'entreposage (min)"),
("collection to reception spent time (min)", "Collection to Reception Spent Time (min)", "Temps écoulé entre le prélèvement et la réception (min)"),
('print barcode', 'Print Barcode', 'Imprimer code à barres'),
('access to data', 'Access To Data', 'Accéder aux données'),
('view data', 'View Data', 'Visualiser les données'),
('specimen data','specimen data','Données des spécimens'),
('add precision', 'Add Precisions', 'Ajouter des précisions'),
("help_csv_export_type",
 "\"Visible columns\" will only export columns visible on the screen while \"All\" will export every columns. (When using \"All\", some fields might not be user readable data.)",
 "\"Colonnes visibles\" exportera seulement les colonnes visibles à l'écran tandis que \"Tout\" exportera toutes les colonnes. (Quand l'option \"Tout\" est utilisée, certains champs peuvent contenir des données non lisibles pour les utilisateurs.)"),
("help_csv_redundancy",
 "Defines how relations causing redundancy will be exported. \"Multiple line\" will generate a file the same way the display is rendered. \"Same line\" let you select nodes to export and all entries related to the primary line will be exported on the same line with incrementing labels.",
 "Défini comment seront exportés les relations provoquant des redondances. \"Multi-lignes\" génèrera un fichier comparable à la manière dont les données sont affichées. \"Même ligne\" vous laisse choisir les noeuds à exporter et chaque élément rattaché à l'élément du noeud primaire sera exporté sur la même ligne avec des titres incrémentaux."),  
(' of ', ' of ', ' sur '),
('add source aliquots','Add Source Aliquots','Ajouter aliquots source'),
('encoding','Encoding','Codage'),
('identifiers','Identifiers','Identifiants'),
('multiple lines','Multiple Lines','Multi-lignes'),
('redundancy display','Redundancy Display','Affichage des redondances'),
('same line','Same Line','Même ligne'),
('separator','Separator','Séparateur'),
('visible columns','Visible Columns','Colonnes visibles'),
("saved browsing steps", "Saved Browsing Steps", "Étapes de navigation sauvegardées"),
("save browsing steps", "Save browsing steps", "Sauvegarder les étapes de navigation"),
("there is no barcodes to print", "There is no barcodes to print.", "Il n'y a pas de code à barres à imprimer."),  
("print barcodes", "Print Barcodes", "Imprimer Codes Barres"),
("add_order_items_info",
 "To add items in batch, you may use query tools batch actions.",
 "Pour ajouter des items en lot, vous pouvez utiliser les traitement par lots des outils de requêtes."),
("default required date", "Default date required", "Date requise par défaut"),
("date that is selected by default when adding order lines",
 "Date that is selected by default when adding order lines.",
 "Date qui sera sélectionnée par défaut lors d'ajout de lignes de commandes."),
("the ordering institution", "The ordering institution.", "L'institution ayant placé la commande."),
("the contact's name at the ordering institution", "The contact's name at the ordering institution.", "Le nom du contact à l'institution ayant placé la commande."),
("merge participant", "Merge participant", "Fusionner le participant"),
("into participant", "Into participant", "Dans le participant"),
("merge_part_desc",
 "The participant from which the sub forms information is transfered. No profile information is transfered. Identifiers are merged when non conflicting. The participant is not deleted automaticaly after the process to allow an identifiers review.",
 "Le participant à partir duquel l'information des sous formulaires sera transférée. Aucune information de profil n'est transférée. Les identifiants non conflictuels sont fusionés. Le participant n'est pas automatiquement supprimé pour permettre la validation des identifiants."),
("merge_part_into_desc", "The participant where the data will be transfered.", "Le participant vers lequel les données seront transférées."),  
("merge operations are not reversible", "Merge operations are not reversible.", "Les opérations de fusion ne sont pas réversibles."),
("merge", "Merge", "Fusion"),
("merge complete", "Merge complete", "Fusion terminée"),
("the starting collection could not be deleted", "The starting collection could not be deleted.", "La collection de départ n'a pas pu être supprimée."),
("merge collection", "Merge collection", "Fusionner la collection"),
("into collection", "Into collection", "Dans la collection"),
("merge_coll_desc", 
 "The collection from which the content will be merged. After the operation that collection will be deleted.", 
 "La collection dont le contenu sera déplacé. Après l'opération la collection sera supprimée."),
("merge_coll_into_desc",
 "The collection into which the content will be merged.",
 "La collection dans laquelle le contenu sera fusionné."),
("counter", "Counter", "Compteur"),
("special parameters", "Special parameters", "Paramètres particuliers"),
("counters", "Counters", "Compteurs"),
("invalid disease code", "Invalid disease code.", "Code de maladie invalide."),
("participant contacts", "Participant contacts", "Contacts des participants"),
("reproductive histories", "Reproductive histories", "Gynécologie"),
("apply saved browsing steps", "Apply saved browsing steps", "Appliquer les étapes de naviguation sauvegardées"),
("cannot calculate on incomplete date", "Cannot calculate on incomplete date", "Impossible de calculer sur date incomplète"),
("years", "Years", "Années"),
("smoked for", "Smoked for", "Fumé pendant"),
("stopped since", "Stopped since", "Arrêté depuis"),
("started on", "Started on", "Commencé le"),
("stopped on", "Stopped on", "Arrêté le"),
('collection contents', 'Collection contents', 'Contenu de la collection'),
('no participant is linked to the current participant collection', 
 "No participant is linked to the current participant collection.",
 "Aucun participant n'est lié à la présente collection de participant."),
('reserved for study','Reserved For Study/Project','Réservé pour une Étude/Projet'),
('identifier name','Identifier Name', "Nom d'identifiant"),
('click here to access it', "Click here to access it.", "Cliquez ici pour y accéder."),
("last modification", "Last Modification", "Dernière Modification"),
("help_part_last_mod", "The date at which the last participant clinical related data was created or modified, excluding .", "Date de la plus récente création ou modification de données cliniques liées au participant."),
("add identifier", "Add identifier", "Ajouter identifiant"),
("batch edit", "Batch edit", "Modification en lot"),
("you need to at least update a value", "You need to at least update a value.", "Vous devez mettre à jour au moins une valeur."),
("you are about to edit %d element(s)", "You are about to edit %d element(s).", "Vous êtes sur le point de mettre %s élément(s) à jour."),
("collection details", "Collection details", "Détails de la collection"),
("collection content", "Collection content", "Contenu de la collection"),
("empty spaces", "Empty Spaces", "Emplacements Vides"),
("keep entries with the most recent start date per participant",
 "Keep entries with the most recent start date per participant",
 "Conserver les entrées avec la date de départ la plus récente par participant"),
("keep entries with the oldest start date per participant",
 "Keep entries with the oldest start date per participant",
 "Conserver les entrées avec la date de départ la plus ancienne par participant"),
("keep entries with the most recent date per participant",
 "Keep entries with the most recent date per participant",
 "Conserver les entrées avec la date la plus récente par participant"),
("keep entries with the oldest date per participant",
 "Keep entries with the oldest date per participant",
 "Conserver les entrées avec la  date la plus ancienne par participant"),
("a special parameter could not be applied because relations between %s and its children node are shared",
 "A special paremeter could not be applied because relations between %s and its children node are shared.",
 "Un paramètre spécial n'a pas pu être appliqué car les relations entre %s et son noeud enfant sont partagées."),
("core_newpassword", "New password", "Nouveau mot de passe"),
("core_confirmpassword", "Confirm new password", "Confirmez les nouveau mot de passe"),
("unsaved browsing trees that are automatically deleted when there are more than %d",
 "Unsaved browsing trees that are automatically deleted when there are more than %d.",
 "Arbres de navigation non enregistrés qui sont supprimés automatiquement lorsqu'il y en a plus de %d."),
("temporary batch sets", "Temporary batch sets", "Lots de données temporaires"),
("unsaved batch sets that are automatically deleted when there are more than %d",
 "Unsaved batch sets that are automatically deleted when there are more than %d.",
 "Lots de données non enregistrés qui sont supprimés automatiquement lorsqu'il y en a plus de %d."),
("saved batch sets", "Saved batch sets", "Lots de données enregistrés"),
("permissions were altered to grant group administrators all administrative privileges",
 "Permissions were altered to grant group \"Administrators\" all administrative privileges.",
 "Les permissions ont été altérées pour que le groupe des \"Administrators\" ait tous les privilèges d'administration."),
("the group administrators cannot be deleted",
 "The group \"Administrators\" cannot be deleted.",
 "Le groups \"Administrators\" ne peut pas être supprimé."),
("the group administrators cannot be edited",
 "The group \"Administrators\" cannot be edited.",
 "Le groups \"Administrators\" ne peut pas être modifié."),
("you need privileges on the following modules to manage participant inventory: %s",
 "You need privileges on the following modules to manage participant inventory: %s.",
 "Vous devez avoir des privilèges sur les modules suivants pour gérer l'inventaire des participants: %s."),
("at least one collection is linked to that treatment",
 "At least one collection is linked to that treatment.",
 "Au moins une collection est liée à ce traitement."),
("links to collections", "Links to collections", "Liens à des collections"),
("at least one collection is linked to that annotation",
 "At least one collection is linked to that annotation.",
 "Au moins une collection est liée à cette annotation."),
("unlinked participant collections", "Unlinked participant collections", "Collections de participants non liées"),
("for all banks", "for all banks", "pour toutes les banques"),
("for your bank", "for your bank", "pour votre banque"),
("partial response", "Partial response", "Réponse partielle"),
("complete response", "Complete response", "Réponse complète"),
("collection date missing", "Collection date missing", "Date de collection manquante"),
("reception date missing", "Reception date missing", "Date de réception manquante"),
("creation date missing", "Creation date missing", "Date de création manquante"),
("spent time cannot be calculated on inaccurate dates", "Spent time cannot be calculated on inaccurate dates", "Le temps écoulé ne peut pas être calculé sur des dates inexactes"),
("the collection date is after the derivative creation date", "The collection date is after the derivative creation date", "La date de collection est après la date de création du dérivé"),
("the collection date is after the specimen reception date", "The collection date is after the specimen reception date", "La date de collection est après la date de réception su spécimen"),
("all (participant, consent, diagnosis and treatment/annotation)",
 "All (Participant, Consent, Diagnosis and Treatment/Annotation)",
 "Tout (participant, Consentement, Diagnotic, Traitement/Annotation)"),
("the value must be between %g and %g", "The value must be between %g and %g", "La valeur doit être entre %g et %g"),
("invalid primary disease code", "Invalid primary disease code", "Code de maladie primaire invalide");

UPDATE collections SET collection_datetime_accuracy='c' WHERE collection_datetime IS NOT NULL AND collection_datetime_accuracy='';
UPDATE aliquot_masters SET storage_datetime_accuracy='c' WHERE storage_datetime IS NOT NULL AND storage_datetime_accuracy='';
UPDATE specimen_details SET reception_datetime_accuracy='c' WHERE reception_datetime IS NOT NULL AND reception_datetime_accuracy='';
UPDATE derivative_details SET creation_datetime_accuracy='c' WHERE creation_datetime IS NOT NULL AND creation_datetime_accuracy='';
UPDATE participants SET date_of_birth_accuracy='c' WHERE date_of_birth IS NOT NULL AND date_of_birth_accuracy='';
UPDATE participants SET date_of_death_accuracy='c' WHERE date_of_death IS NOT NULL AND date_of_death_accuracy='';

UPDATE menus SET use_link='/ClinicalAnnotation/Participants/search/' WHERE id='clin_CAN_1';
UPDATE menus SET use_link='/ClinicalAnnotation/FamilyHistories/listall/%%Participant.id%%' WHERE id='clin_CAN_10';
UPDATE menus SET use_link='/ClinicalAnnotation/Participants/chronology/%%Participant.id%%' WHERE id='clin_CAN_1_13';
UPDATE menus SET use_link='/ClinicalAnnotation/MiscIdentifiers/listall/%%Participant.id%%' WHERE id='clin_CAN_24';
UPDATE menus SET use_link='/ClinicalAnnotation/ParticipantMessages/listall/%%Participant.id%%' WHERE id='clin_CAN_25';
UPDATE menus SET use_link='/ClinicalAnnotation/ParticipantContacts/listall/%%Participant.id%%' WHERE id='clin_CAN_26';
UPDATE menus SET use_link='/ClinicalAnnotation/EventMasters/listall/screening/%%Participant.id%%' WHERE id='clin_CAN_27';
UPDATE menus SET use_link='/ClinicalAnnotation/EventMasters/listall/lab/%%Participant.id%%' WHERE id='clin_CAN_28';
UPDATE menus SET use_link='/ClinicalAnnotation/EventMasters/listall/lifestyle/%%Participant.id%%' WHERE id='clin_CAN_30';
UPDATE menus SET use_link='/ClinicalAnnotation/EventMasters/listall/Clinical/%%Participant.id%%' WHERE id='clin_CAN_31';
UPDATE menus SET use_link='/ClinicalAnnotation/EventMasters/listall/adverse_events/%%Participant.id%%' WHERE id='clin_CAN_32';
UPDATE menus SET use_link='/ClinicalAnnotation/EventMasters/listall/Study/%%Participant.id%%' WHERE id='clin_CAN_33';
UPDATE menus SET use_link='/ClinicalAnnotation/EventMasters/listall/Clinical/%%Participant.id%%' WHERE id='clin_CAN_4';
UPDATE menus SET use_link='/ClinicalAnnotation/DiagnosisMasters/listall/%%Participant.id%%' WHERE id='clin_CAN_5';
UPDATE menus SET use_link='/ClinicalAnnotation/ClinicalCollectionLinks/listall/%%Participant.id%%' WHERE id='clin_CAN_57';
UPDATE menus SET use_link='/ClinicalAnnotation/ProductMasters/productsTreeView/%%Participant.id%%' WHERE id='clin_CAN_571';
UPDATE menus SET use_link='/ClinicalAnnotation/DiagnosisMasters/detail/%%Participant.id%%/%%DiagnosisMaster.primary_id%%' WHERE id='clin_CAN_5_1';
UPDATE menus SET use_link='/ClinicalAnnotation/DiagnosisMasters/detail/%%Participant.id%%/%%DiagnosisMaster.progression_1_id%%' WHERE id='clin_CAN_5_1.1';
UPDATE menus SET use_link='/ClinicalAnnotation/DiagnosisMasters/detail/%%Participant.id%%/%%DiagnosisMaster.progression_2_id%%' WHERE id='clin_CAN_5_1.2';
UPDATE menus SET use_link='/ClinicalAnnotation/Participants/profile/%%Participant.id%%' WHERE id='clin_CAN_6';
UPDATE menus SET use_link='/ClinicalAnnotation/ClinicalCollectionLinks/listall/%%Participant.id%%' WHERE id='clin_CAN_67';
UPDATE menus SET use_link='/ClinicalAnnotation/ReproductiveHistories/listall/%%Participant.id%%' WHERE id='clin_CAN_68';
UPDATE menus SET use_link='/ClinicalAnnotation/EventMasters/listall/Protocol/%%Participant.id%%' WHERE id='clin_CAN_69';
UPDATE menus SET use_link='/ClinicalAnnotation/TreatmentMasters/listall/%%Participant.id%%' WHERE id='clin_CAN_75';
UPDATE menus SET use_link='/ClinicalAnnotation/TreatmentMasters/detail/%%Participant.id%%/%%TreatmentMaster.id%%' WHERE id='clin_CAN_79';
UPDATE menus SET use_link='/ClinicalAnnotation/TreatmentExtends/listall/%%Participant.id%%/%%TreatmentMaster.id%%' WHERE id='clin_CAN_80';
UPDATE menus SET use_link='/ClinicalAnnotation/ConsentMasters/listall/%%Participant.id%%' WHERE id='clin_CAN_9';
UPDATE menus SET use_link='/Tools/Template/index' WHERE id='collection_template';
UPDATE menus SET use_link='/Menus/tools/' WHERE id='core_CAN_33';
UPDATE menus SET use_link='/Administrate/Groups' WHERE id='core_CAN_41';
UPDATE menus SET use_link='/Administrate/Groups/index' WHERE id='core_CAN_41_1';
UPDATE menus SET use_link='/Administrate/Groups/detail/%%Group.id%%/' WHERE id='core_CAN_41_1_1';
UPDATE menus SET use_link='/Administrate/Permissions/tree/%%Group.id%%/' WHERE id='core_CAN_41_1_2';
UPDATE menus SET use_link='/Administrate/AdminUsers/listall/%%Group.id%%/' WHERE id='core_CAN_41_1_3';
UPDATE menus SET use_link='/Administrate/AdminUsers/detail/%%Group.id%%/%%User.id%%/' WHERE id='core_CAN_41_1_3_1';
UPDATE menus SET use_link='/Administrate/Preferences/index/%%Group.id%%/%%User.id%%/' WHERE id='core_CAN_41_1_3_2';
UPDATE menus SET use_link='/Administrate/Passwords/index/%%Group.id%%/%%User.id%%/' WHERE id='core_CAN_41_1_3_3';
UPDATE menus SET use_link='/Administrate/UserLogs/index/%%Group.id%%/%%User.id%%/' WHERE id='core_CAN_41_1_3_4';
UPDATE menus SET use_link='/Administrate/Announcements/index/%%Group.id%%/%%User.id%%/' WHERE id='core_CAN_41_1_3_5';
UPDATE menus SET use_link='/Administrate/Banks/index' WHERE id='core_CAN_41_2';
UPDATE menus SET use_link='/Administrate/Banks/detail/%%Bank.id%%/' WHERE id='core_CAN_41_2_1';
UPDATE menus SET use_link='/Administrate/Announcements/index/%%Bank.id%%/' WHERE id='core_CAN_41_2_2';
UPDATE menus SET use_link='/Administrate/Dropdowns/index' WHERE id='core_CAN_41_3';
UPDATE menus SET use_link='/Administrate/MiscIdentifiers/index' WHERE id='core_CAN_41_4';
UPDATE menus SET use_link='/Administrate/AdminUsers/search/' WHERE id='core_CAN_41_5';
UPDATE menus SET use_link='/Customize/Preferences/index/' WHERE id='core_CAN_42';
UPDATE menus SET use_link='/Administrate/Versions/detail/' WHERE id='core_CAN_70';
UPDATE menus SET use_link='/Administrate/Menus/index/' WHERE id='core_CAN_71';
UPDATE menus SET use_link='/Administrate/Structures/index/' WHERE id='core_CAN_72';
UPDATE menus SET use_link='/Administrate/Structures/detail/%%Structure.id%%' WHERE id='core_CAN_75';
UPDATE menus SET use_link='/Administrate/Structure_formats/listall/%%Structure.id%%' WHERE id='core_CAN_76';
UPDATE menus SET use_link='/Customize/Profiles/index/' WHERE id='core_CAN_84';
UPDATE menus SET use_link='/Customize/Preferences/index/' WHERE id='core_CAN_85';
UPDATE menus SET use_link='/Customize/Passwords/index/' WHERE id='core_CAN_93';
UPDATE menus SET use_link='/Customize/Announcements/index/' WHERE id='core_CAN_97';
UPDATE menus SET use_link='/Drug/Drugs/search/' WHERE id='drug_CAN_96';
UPDATE menus SET use_link='/Drug/Drugs/etail/%%Drug.id%%' WHERE id='drug_CAN_97';
UPDATE menus SET use_link='/InventoryManagement/Collections/search' WHERE id='inv_CAN';
UPDATE menus SET use_link='/InventoryManagement/Collections/detail/%%Collection.id%%' WHERE id='inv_CAN_1';
UPDATE menus SET use_link='/InventoryManagement/SampleMasters/contentTreeView/%%Collection.id%%' WHERE id='inv_CAN_21';
UPDATE menus SET use_link='/InventoryManagement/SampleMasters/detail/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%' WHERE id='inv_CAN_221';
UPDATE menus SET use_link='/InventoryManagement/SampleMasters/listAllDerivatives/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%' WHERE id='inv_CAN_222';
UPDATE menus SET use_link='/InventoryManagement/SampleMasters/detail/%%Collection.id%%/%%SampleMaster.id%%' WHERE id='inv_CAN_2221';
UPDATE menus SET use_link='/InventoryManagement/AliquotMasters/listAllSourceAliquots/%%Collection.id%%/%%SampleMaster.id%%' WHERE id='inv_CAN_2222';
UPDATE menus SET use_link='/InventoryManagement/AliquotMasters/detail/%%Collection.id%%/%%SampleMaster.id%%/%%AliquotMaster.id%%' WHERE id='inv_CAN_22231';
UPDATE menus SET use_link='/InventoryManagement/AliquotMasters/listAllRealiquotedParents/%%Collection.id%%/%%SampleMaster.id%%/%%AliquotMaster.id%%/' WHERE id='inv_CAN_22233';
UPDATE menus SET use_link='/InventoryManagement/QualityCtrls/listAll/%%Collection.id%%/%%SampleMaster.id%%' WHERE id='inv_CAN_2224';
UPDATE menus SET use_link='/InventoryManagement/QualityCtrls/detail/%%Collection.id%%/%%SampleMaster.id%%/%%QualityCtrl.id%%' WHERE id='inv_CAN_22241';
UPDATE menus SET use_link='/InventoryManagement/AliquotMasters/detail/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%/%%AliquotMaster.id%%' WHERE id='inv_CAN_2231';
UPDATE menus SET use_link='/InventoryManagement/AliquotMasters/listAllRealiquotedParents/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%/%%AliquotMaster.id%%' WHERE id='inv_CAN_2233';
UPDATE menus SET use_link='/InventoryManagement/QualityCtrls/listAll/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%' WHERE id='inv_CAN_224';
UPDATE menus SET use_link='/InventoryManagement/QualityCtrls/detail/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%/%%QualityCtrl.id%%' WHERE id='inv_CAN_2241';
UPDATE menus SET use_link='/InventoryManagement/SpecimenReviews/listAll/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%' WHERE id='inv_CAN_225';
UPDATE menus SET use_link='/underdevelopment/' WHERE id='inv_CAN_3';
UPDATE menus SET use_link='/Menus' WHERE id='MAIN_MENU_1';
UPDATE menus SET use_link='/Users/logout' WHERE id='MAIN_MENU_2';
UPDATE menus SET use_link='/Material/materials/index/' WHERE id='mat_CAN_01';
UPDATE menus SET use_link='/Material/materials/detail/%%Material.id%%' WHERE id='mat_CAN_02';
UPDATE menus SET use_link='/Order/Orders/search/' WHERE id='ord_CAN_101';
UPDATE menus SET use_link='/Order/Orders/detail/%%Order.id%%/' WHERE id='ord_CAN_113';
UPDATE menus SET use_link='/Order/OrderLines/listall/%%Order.id%%/' WHERE id='ord_CAN_114';
UPDATE menus SET use_link='/Order/OrderLines/detail/%%Order.id%%/%%OrderLine.id%%/' WHERE id='ord_CAN_115';
UPDATE menus SET use_link='/Order/shipments/listall/%%Order.id%%/' WHERE id='ord_CAN_116';
UPDATE menus SET use_link='/Order/OrderItems/listall/%%Order.id%%/%%OrderLine.id%%/' WHERE id='ord_CAN_117';
UPDATE menus SET use_link='/Order/OrderItems/detail/%%Order.id%%/%%OrderLine.id%%/%%OrderItem.id%%/' WHERE id='ord_CAN_118';
UPDATE menus SET use_link='/Order/Shipments/detail/%%Order.id%%/%%Shipment.id%%/' WHERE id='ord_CAN_119';
UPDATE menus SET use_link='/LabBook/LabBookMasters/search/' WHERE id='procd_CAN_01';
UPDATE menus SET use_link='/LabBook/LabBookMasters/detail/%%LabBookMaster.id%%' WHERE id='procd_CAN_02';
UPDATE menus SET use_link='/Protocol/ProtocolMasters/search/' WHERE id='proto_CAN_37';
UPDATE menus SET use_link='/Protocol/ProtocolMasters/detail/%%ProtocolMaster.id%%' WHERE id='proto_CAN_82';
UPDATE menus SET use_link='/Protocol/ProtocolExtends/listall/%%ProtocolMaster.id%%' WHERE id='proto_CAN_83';
UPDATE menus SET use_link='/Provider/Providers/detail/%%Provider.id%%/' WHERE id='prov_CAN_10';
UPDATE menus SET use_link='/Menus/datamart/' WHERE id='qry-CAN-1';
UPDATE menus SET use_link='/Datamart/Browser/index' WHERE id='qry-CAN-1-1';
UPDATE menus SET use_link='/Datamart/Reports/index' WHERE id='qry-CAN-1-2';
UPDATE menus SET use_link='/Datamart/Adhocs/index/' WHERE id='qry-CAN-2';
UPDATE menus SET use_link='/Datamart/BatchSets/index/' WHERE id='qry-CAN-3';
UPDATE menus SET use_link='/RtbForm/RtbForms/index/' WHERE id='rtbf_CAN_01';
UPDATE menus SET use_link='/RtbForm/RtbForms/profile/%%Rtbform.id%%' WHERE id='rtbf_CAN_02';
UPDATE menus SET use_link='/Sop/SopMasters/listall/' WHERE id='sop_CAN_01';
UPDATE menus SET use_link='/Sop/SopMasters/detail/%%SopMaster.id%%/' WHERE id='sop_CAN_03';
UPDATE menus SET use_link='/Sop/SopExtends/listall/%%SopMaster.id%%/' WHERE id='sop_CAN_04';
UPDATE menus SET use_link='/StorageLayout/StorageMasters/search/' WHERE id='sto_CAN_01';
UPDATE menus SET use_link='/StorageLayout/StorageMasters/detail/%%StorageMaster.id%%' WHERE id='sto_CAN_02';
UPDATE menus SET use_link='/StorageLayout/StorageMasters/storageLayout/%%StorageMaster.id%%' WHERE id='sto_CAN_05';
UPDATE menus SET use_link='/StorageLayout/StorageCoordinates/listAll/%%StorageMaster.id%%' WHERE id='sto_CAN_06';
UPDATE menus SET use_link='/StorageLayout/StorageMasters/detail/%%StorageMaster.id%%/0/TMA' WHERE id='sto_CAN_07';
UPDATE menus SET use_link='/StorageLayout/TmaSlides/listAll/%%StorageMaster.id%%' WHERE id='sto_CAN_08';
UPDATE menus SET use_link='/StorageLayout/StorageMasters/contentTreeView/%%StorageMaster.id%%' WHERE id='sto_CAN_10';
UPDATE menus SET use_link='/Study/StudySummaries/search/' WHERE id='tool_CAN_100';
UPDATE menus SET use_link='/Study/StudySummaries/detail/%%StudySummary.id%%/' WHERE id='tool_CAN_104';
UPDATE menus SET use_link='/Study/StudyContacts/listall/%%StudySummary.id%%/' WHERE id='tool_CAN_105';
UPDATE menus SET use_link='/Study/StudyInvestigators/listall/%%StudySummary.id%%/' WHERE id='tool_CAN_106';
UPDATE menus SET use_link='/Study/StudyReviews/listall/%%StudySummary.id%%/' WHERE id='tool_CAN_107';
UPDATE menus SET use_link='/Study/StudyEthicsBoards/listall/%%StudySummary.id%%/' WHERE id='tool_CAN_108';
UPDATE menus SET use_link='/Study/StudyFundings/listall/%%StudySummary.id%%/' WHERE id='tool_CAN_109';
UPDATE menus SET use_link='/Study/StudyResults/listall/%%StudySummary.id%%/' WHERE id='tool_CAN_110';
UPDATE menus SET use_link='/Study/StudyRelated/listall/%%StudySummary.id%%/' WHERE id='tool_CAN_112';
UPDATE menus SET use_link='/Provider/Providers/index/' WHERE id='tool_CAN_43';

UPDATE structure_fields SET plugin='Administrate' WHERE plugin='administrate';
UPDATE structure_fields SET plugin='ClinicalAnnotation' WHERE plugin='clinicalannotation';
UPDATE structure_fields SET plugin='CodingIcd' WHERE plugin='codingicd';
UPDATE structure_fields SET plugin='Customize' WHERE plugin='customize';
UPDATE structure_fields SET plugin='Datamart' WHERE plugin='datamart';
UPDATE structure_fields SET plugin='Drug' WHERE plugin='Drug';
UPDATE structure_fields SET plugin='InventoryManagement' WHERE plugin='inventorymanagement';
UPDATE structure_fields SET plugin='LabBook' WHERE plugin='labbook';
UPDATE structure_fields SET plugin='Material' WHERE plugin='material';
UPDATE structure_fields SET plugin='Order' WHERE plugin='order';
UPDATE structure_fields SET plugin='Protocol' WHERE plugin='protocol';
UPDATE structure_fields SET plugin='RtbForm' WHERE plugin='rtbform';
UPDATE structure_fields SET plugin='Sop' WHERE plugin='sop';
UPDATE structure_fields SET plugin='StorageLayout' WHERE plugin='storagelayout';
UPDATE structure_fields SET plugin='Study' WHERE plugin='study';
UPDATE structure_fields SET plugin='Tools' WHERE plugin='Tools';

UPDATE structure_value_domains SET source='InventoryManagement.AliquotControl::getAliquotTypePermissibleValues' WHERE source='InventoryManagement.AliquotControl::getAliquotTypePermissibleValues';
UPDATE structure_value_domains SET source='ClinicalAnnotation.TreatmentControl::getDiseaseSitePermissibleValues' WHERE source='ClinicalAnnotation.TreatmentControl::getDiseaseSitePermissibleValues';
UPDATE structure_value_domains SET source='Protocol.ProtocolControl::getProtocolTypePermissibleValues' WHERE source='Protocol.ProtocolControl::getProtocolTypePermissibleValues';
UPDATE structure_value_domains SET source='StructurePermissibleValuesCustom::getCustomDropdown(''quality control tools'')' WHERE source='StructurePermissibleValuesCustom::getCustomDropdown(''quality control tools'')';
UPDATE structure_value_domains SET source='InventoryManagement.SampleControl::getSpecimenSampleTypePermissibleValues' WHERE source='InventoryManagement.SampleControl::getSpecimenSampleTypePermissibleValues';
UPDATE structure_value_domains SET source='InventoryManagement.SampleControl::getSampleTypePermissibleValues' WHERE source='InventoryManagement.SampleControl::getSampleTypePermissibleValues';
UPDATE structure_value_domains SET source='StorageLayout.StorageControl::getStorageTypePermissibleValues' WHERE source='StorageLayout.StorageControl::getStorageTypePermissibleValues';
UPDATE structure_value_domains SET source='StructurePermissibleValuesCustom::getCustomDropdown(''specimen collection sites'')' WHERE source='StructurePermissibleValuesCustom::getCustomDropdown(''specimen collection sites'')';
UPDATE structure_value_domains SET source='StructurePermissibleValuesCustom::getCustomDropdown(''laboratory staff'')' WHERE source='StructurePermissibleValuesCustom::getCustomDropdown(''laboratory staff'')';
UPDATE structure_value_domains SET source='StructurePermissibleValuesCustom::getCustomDropdown(''specimen supplier departments'')' WHERE source='StructurePermissibleValuesCustom::getCustomDropdown(''specimen supplier departments'')';
UPDATE structure_value_domains SET source='StructurePermissibleValuesCustom::getCustomDropdown(''laboratory sites'')' WHERE source='StructurePermissibleValuesCustom::getCustomDropdown(''laboratory sites'')';
UPDATE structure_value_domains SET source='ClinicalAnnotation.Icd10::permissibleValues' WHERE source='ClinicalAnnotation.Icd10::permissibleValues';
UPDATE structure_value_domains SET source='Administrate.Bank::getBankPermissibleValues' WHERE source='Administrate.Bank::getBankPermissibleValues';
UPDATE structure_value_domains SET source='Drug.Drug::getDrugPermissibleValues' WHERE source='Drug.Drug::getDrugPermissibleValues';
UPDATE structure_value_domains SET source='Protocol.ProtocolControl::getProtocolTumourGroupPermissibleValues' WHERE source='Protocol.ProtocolControl::getProtocolTumourGroupPermissibleValues';
UPDATE structure_value_domains SET source='StorageLayout.StorageMaster::getParentStoragePermissibleValues' WHERE source='StorageLayout.StorageMaster::getParentStoragePermissibleValues';
UPDATE structure_value_domains SET source='Sop.SopMaster::getTmaBlockSopPermissibleValues' WHERE source='Sop.SopMaster::getTmaBlockSopPermissibleValues';
UPDATE structure_value_domains SET source='Sop.SopMaster::getTmaSlideSopPermissibleValues' WHERE source='Sop.SopMaster::getTmaSlideSopPermissibleValues';
UPDATE structure_value_domains SET source='Study.StudySummary::getStudyPermissibleValues' WHERE source='Study.StudySummary::getStudyPermissibleValues';
UPDATE structure_value_domains SET source='InventoryManagement.AliquotControl::getAliquotTypePermissibleValuesFromId' WHERE source='InventoryManagement.AliquotControl::getAliquotTypePermissibleValuesFromId';
UPDATE structure_value_domains SET source='InventoryManagement.SampleControl::getSampleTypePermissibleValuesFromId' WHERE source='InventoryManagement.SampleControl::getSampleTypePermissibleValuesFromId';
UPDATE structure_value_domains SET source='InventoryManagement.AliquotControl::getSampleAliquotTypesPermissibleValues' WHERE source='InventoryManagement.AliquotControl::getSampleAliquotTypesPermissibleValues';
UPDATE structure_value_domains SET source='Order.Shipment::getShipmentPermissibleValues' WHERE source='Order.Shipment::getShipmentPermissibleValues';
UPDATE structure_value_domains SET source='Sop.SopMaster::getCollectionSopPermissibleValues' WHERE source='Sop.SopMaster::getCollectionSopPermissibleValues';
UPDATE structure_value_domains SET source='Sop.SopMaster::getSampleSopPermissibleValues' WHERE source='Sop.SopMaster::getSampleSopPermissibleValues';
UPDATE structure_value_domains SET source='InventoryManagement.SampleDetail::getTissueSourcePermissibleValues' WHERE source='InventoryManagement.SampleDetail::getTissueSourcePermissibleValues';
UPDATE structure_value_domains SET source='Sop.SopMaster::getAliquotSopPermissibleValues' WHERE source='Sop.SopMaster::getAliquotSopPermissibleValues';
UPDATE structure_value_domains SET source='ClinicalAnnotation.MiscIdentifierControl::getMiscIdentifierNamePermissibleValues' WHERE source='ClinicalAnnotation.MiscIdentifierControl::getMiscIdentifierNamePermissibleValues';
UPDATE structure_value_domains SET source='ClinicalAnnotation.MiscIdentifierControl::getMiscIdentifierNameAbrevPermissibleValues' WHERE source='ClinicalAnnotation.MiscIdentifierControl::getMiscIdentifierNameAbrevPermissibleValues';
UPDATE structure_value_domains SET source='ClinicalAnnotation.ConsentControl::getConsentTypePermissibleValuesFromId' WHERE source='ClinicalAnnotation.ConsentControl::getConsentTypePermissibleValuesFromId';
UPDATE structure_value_domains SET source='ClinicalAnnotation.DiagnosisControl::getDiagnosisTypePermissibleValuesFromId' WHERE source='ClinicalAnnotation.DiagnosisControl::getDiagnosisTypePermissibleValuesFromId';
UPDATE structure_value_domains SET source='ClinicalAnnotation.EventControl::getEventDiseaseSitePermissibleValues' WHERE source='ClinicalAnnotation.EventControl::getEventDiseaseSitePermissibleValues';
UPDATE structure_value_domains SET source='ClinicalAnnotation.EventControl::getEventTypePermissibleValues' WHERE source='ClinicalAnnotation.EventControl::getEventTypePermissibleValues';
UPDATE structure_value_domains SET source='ClinicalAnnotation.TreatmentControl::getMethodPermissibleValues' WHERE source='ClinicalAnnotation.TreatmentControl::getMethodPermissibleValues';
UPDATE structure_value_domains SET source='Protocol.ProtocolMaster::getProtocolPermissibleValuesFromId' WHERE source='Protocol.ProtocolMaster::getProtocolPermissibleValuesFromId';
UPDATE structure_value_domains SET source='ClinicalAnnotation.DiagnosisMaster::getMorphologyValues' WHERE source='ClinicalAnnotation.DiagnosisMaster::getMorphologyValues';
UPDATE structure_value_domains SET source='ClinicalAnnotation.MiscIdentifierControl::getMiscIdentifierNamePermissibleValuesFromId' WHERE source='ClinicalAnnotation.MiscIdentifierControl::getMiscIdentifierNamePermissibleValuesFromId';
UPDATE structure_value_domains SET source='InventoryManagement.SampleControl::getSpecimenSampleTypePermissibleValuesFromId' WHERE source='InventoryManagement.SampleControl::getSpecimenSampleTypePermissibleValuesFromId';
UPDATE structure_value_domains SET source='InventoryManagement.SpecimenReviewControl::getSpecimenTypePermissibleValues' WHERE source='InventoryManagement.SpecimenReviewControl::getSpecimenTypePermissibleValues';
UPDATE structure_value_domains SET source='InventoryManagement.SpecimenReviewControl::getReviewTypePermissibleValues' WHERE source='InventoryManagement.SpecimenReviewControl::getReviewTypePermissibleValues';
UPDATE structure_value_domains SET source='InventoryManagement.AliquotReviewMaster::getAliquotListForReview' WHERE source='InventoryManagement.AliquotReviewMaster::getAliquotListForReview';
UPDATE structure_value_domains SET source='User::getUsersList' WHERE source='User::getUsersList';
UPDATE structure_value_domains SET source='Datamart.Batchset::getActionsDropdown' WHERE source='Datamart.Batchset::getActionsDropdown';
UPDATE structure_value_domains SET source='InventoryManagement.SampleMaster::getParentSampleDropdown' WHERE source='InventoryManagement.SampleMaster::getParentSampleDropdown';
UPDATE structure_value_domains SET source='StorageLayout.StorageMaster::getStoragesDropdown' WHERE source='StorageLayout.StorageMaster::getStoragesDropdown';
UPDATE structure_value_domains SET source='InventoryManagement.AliquotMaster::getRealiquotDropdown' WHERE source='InventoryManagement.AliquotMaster::getRealiquotDropdown';
UPDATE structure_value_domains SET source='InventoryManagement.SampleMaster::getDerivativesDropdown' WHERE source='InventoryManagement.SampleMaster::getDerivativesDropdown';
UPDATE structure_value_domains SET source='LabBook.LabBookControl::getLabBookTypePermissibleValuesFromId' WHERE source='LabBook.LabBookControl::getLabBookTypePermissibleValuesFromId';
UPDATE structure_value_domains SET source='LabBook.LabBookMaster::getLabBookPermissibleValuesFromId' WHERE source='LabBook.LabBookMaster::getLabBookPermissibleValuesFromId';
UPDATE structure_value_domains SET source='Datamart.DatamartStructure::getDisplayNameFromId' WHERE source='Datamart.DatamartStructure::getDisplayNameFromId';
UPDATE structure_value_domains SET source='Sop.SopControl::getTypePermissibleValues' WHERE source='Sop.SopControl::getTypePermissibleValues';
UPDATE structure_value_domains SET source='Sop.SopControl::getGroupPermissibleValues' WHERE source='Sop.SopControl::getGroupPermissibleValues';
UPDATE structure_value_domains SET source='ClinicalAnnotation.DiagnosisControl::getTypePermissibleValues' WHERE source='ClinicalAnnotation.DiagnosisControl::getTypePermissibleValues';
UPDATE structure_value_domains SET source='ClinicalAnnotation.DiagnosisControl::getCategoryPermissibleValues' WHERE source='ClinicalAnnotation.DiagnosisControl::getCategoryPermissibleValues';
UPDATE structure_value_domains SET source='StructurePermissibleValuesCustom::getCustomDropdown(''sop versions'')' WHERE source='StructurePermissibleValuesCustom::getCustomDropdown(''sop versions'')';
UPDATE structure_value_domains SET source='StructurePermissibleValuesCustom::getCustomDropdown(''consent form versions'')' WHERE source='StructurePermissibleValuesCustom::getCustomDropdown(''consent form versions'')';
UPDATE structure_value_domains SET source='ClinicalAnnotation.EventControl::getEventGroupPermissibleValues' WHERE source='ClinicalAnnotation.EventControl::getEventGroupPermissibleValues';
UPDATE structure_value_domains SET source='InventoryManagement.SampleControl::getParentSampleTypePermissibleValues' WHERE source='InventoryManagement.SampleControl::getParentSampleTypePermissibleValues';
UPDATE structure_value_domains SET source='InventoryManagement.SampleControl::getParentSampleTypePermissibleValuesFromId' WHERE source='InventoryManagement.SampleControl::getParentSampleTypePermissibleValuesFromId';

UPDATE menus SET use_summary=REPLACE(use_summary, 'Inventorymanagement', 'InventoryManagement'); 
UPDATE menus SET use_summary=REPLACE(use_summary, 'Storagelayout', 'StorageLayout'); 
UPDATE menus SET use_summary=REPLACE(use_summary, 'Clinicalannotation', 'ClinicalAnnotation'); 

UPDATE datamart_structures SET plugin='InventoryManagement' WHERE plugin='Inventorymanagement';
UPDATE datamart_structures SET plugin='ClinicalAnnotation' WHERE plugin='ClinicalAnnotation';
UPDATE datamart_structures SET plugin='StorageLayout' WHERE plugin='StorageLayout';
UPDATE datamart_structures SET index_link=REPLACE(index_link, '/inventorymanagement/', '/InventoryManagement/'); 
UPDATE datamart_structures SET index_link=REPLACE(index_link, '/storagelayout/', '/StorageLayout/'); 
UPDATE datamart_structures SET index_link=REPLACE(index_link, '/clinicalannotation/', '/ClinicalAnnotation/'); 
UPDATE datamart_structures SET index_link=REPLACE(index_link, '/aliquot_masters/', '/AliquotMasters/'); 
UPDATE datamart_structures SET index_link=REPLACE(index_link, '/collections/', '/Collections/'); 
UPDATE datamart_structures SET index_link=REPLACE(index_link, '/storage_masters/', '/StorageMasters/'); 
UPDATE datamart_structures SET index_link=REPLACE(index_link, '/participants/', '/Participants/'); 
UPDATE datamart_structures SET index_link=REPLACE(index_link, '/consent_masters/', '/ConsentMasters/'); 
UPDATE datamart_structures SET index_link=REPLACE(index_link, '/diagnosis_masters/', '/DiagnosisMasters/'); 
UPDATE datamart_structures SET index_link=REPLACE(index_link, '/treatment_masters/', '/TreatmentMasters/'); 
UPDATE datamart_structures SET index_link=REPLACE(index_link, '/family_histories/', '/FamilyHistory/'); 
UPDATE datamart_structures SET index_link=REPLACE(index_link, '/participant_messages/', '/ParicipantMessages/'); 
UPDATE datamart_structures SET index_link=REPLACE(index_link, '/quality_ctrls/', '/QualityCtrls/'); 
UPDATE datamart_structures SET index_link=REPLACE(index_link, '/event_masters/', '/EventMasters/'); 
UPDATE datamart_structures SET index_link=REPLACE(index_link, '/specimen_reviews/', '/SpecimenReviews/'); 
UPDATE datamart_structures SET index_link=REPLACE(index_link, '/order/', '/Order/'); 
UPDATE datamart_structures SET index_link=REPLACE(index_link, '/order_items/', '/OrderItems/'); 
UPDATE datamart_structures SET index_link=REPLACE(index_link, '/shipments/', '/Shipments/'); 

UPDATE structure_fields SET setting=REPLACE(setting, 'codingicd', 'CodingIcd') WHERE setting like '%codingicd%';
UPDATE structure_fields SET setting=REPLACE(setting, '/inventorymanagement/', '/InventoryManagement/') WHERE setting like '%/inventorymanagement/%';
UPDATE structure_fields SET setting=REPLACE(setting, '/aliquot_masters/', '/AliquotMasters/') WHERE setting like '%/aliquot_masters/%';
UPDATE structure_fields SET setting=REPLACE(setting, '/labbook/', '/LabBook/') WHERE setting like '%/labbook/%';
UPDATE structure_fields SET setting=REPLACE(setting, '/lab_book_masters/', '/LabBookMasters/') WHERE setting like '%/lab_book_masters/%';
UPDATE structure_fields SET setting=REPLACE(setting, '/storagelayout/', '/StorageLayout/') WHERE setting like '%/storagelayout/%';
UPDATE structure_fields SET setting=REPLACE(setting, '/storage_masters/', '/StorageMasters/') WHERE setting like '%/storagemasters/%';

UPDATE datamart_adhoc SET plugin='ClinicalAnnotation' WHERE plugin like 'clinicalannotation';
UPDATE datamart_adhoc SET plugin='InventoryManagement' WHERE plugin like 'inventorymanagement';
UPDATE datamart_adhoc SET plugin='StorageLayout' WHERE plugin like 'storagelayout';
UPDATE datamart_adhoc SET form_links_for_results=REPLACE(form_links_for_results, '/clinicalannotation/', '/ClinicalAnnotation/');
UPDATE datamart_adhoc SET form_links_for_results=REPLACE(form_links_for_results, '/inventorymanagement/', '/InventoryManagement/');
UPDATE datamart_adhoc SET form_links_for_results=REPLACE(form_links_for_results, '/storagelayout/', '/StorageLayout/');
UPDATE datamart_adhoc SET form_links_for_results=REPLACE(form_links_for_results, '/participants/', '/Participants/');
UPDATE datamart_adhoc SET form_links_for_results=REPLACE(form_links_for_results, '/aliquot_masters/', '/AliquotMasters/');

UPDATE menus SET use_link='/Drug/Drugs/detail/%%Drug.id%%' WHERE id='drug_CAN_97';

ALTER TABLE collections
 ADD COLUMN participant_id INT DEFAULT NULL AFTER collection_notes,
 ADD COLUMN diagnosis_master_id INT DEFAULT NULL AFTER participant_id,
 ADD COLUMN consent_master_id INT DEFAULT NULL AFTER diagnosis_master_id,
 ADD COLUMN treatment_master_id INT DEFAULT NULL AFTER consent_master_id,
 ADD COLUMN event_master_id INT DEFAULT NULL AFTER treatment_master_id, 
 ADD FOREIGN KEY (participant_id) REFERENCES participants(id),
 ADD FOREIGN KEY (diagnosis_master_id) REFERENCES diagnosis_masters(id),
 ADD FOREIGN KEY (consent_master_id) REFERENCES consent_masters(id),
 ADD FOREIGN KEY (treatment_master_id) REFERENCES treatment_masters(id),
 ADD FOREIGN KEY (event_master_id) REFERENCES event_masters(id);
ALTER TABLE collections_revs
 ADD COLUMN participant_id INT DEFAULT NULL AFTER collection_notes,
 ADD COLUMN diagnosis_master_id INT DEFAULT NULL AFTER participant_id,
 ADD COLUMN consent_master_id INT DEFAULT NULL AFTER diagnosis_master_id,
 ADD COLUMN treatment_master_id INT DEFAULT NULL AFTER consent_master_id,
 ADD COLUMN event_master_id INT DEFAULT NULL AFTER treatment_master_id;
 
UPDATE collections AS c
INNER JOIN clinical_collection_links AS ccl ON c.id=ccl.collection_id
SET c.participant_id=ccl.participant_id, c.diagnosis_master_id=ccl.diagnosis_master_id, c.consent_master_id=ccl.consent_master_id;
INSERT INTO collections_revs (id, acquisition_label, bank_id, collection_site, collection_datetime, collection_datetime_accuracy, sop_master_id, collection_property, collection_notes, participant_id, diagnosis_master_id, modified_by, version_created)
(SELECT id, acquisition_label, bank_id, collection_site, collection_datetime, collection_datetime_accuracy, sop_master_id, collection_property, collection_notes, participant_id, diagnosis_master_id, modified_by, NOW() FROM collections);

ALTER TABLE specimen_details MODIFY sample_master_id INT NOT NULL;
ALTER TABLE specimen_details_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE derivative_details MODIFY sample_master_id INT NOT NULL;
ALTER TABLE derivative_details_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE ad_tubes MODIFY aliquot_master_id INT NOT NULL;
ALTER TABLE ad_tubes_revs MODIFY aliquot_master_id INT NOT NULL;
ALTER TABLE ad_bags MODIFY aliquot_master_id INT NOT NULL;
ALTER TABLE ad_bags_revs MODIFY aliquot_master_id INT NOT NULL;
ALTER TABLE ad_blocks MODIFY aliquot_master_id INT NOT NULL;
ALTER TABLE ad_blocks_revs MODIFY aliquot_master_id INT NOT NULL;
ALTER TABLE ad_cell_cores MODIFY aliquot_master_id INT NOT NULL;
ALTER TABLE ad_cell_cores_revs MODIFY aliquot_master_id INT NOT NULL;
ALTER TABLE ad_cell_slides MODIFY aliquot_master_id INT NOT NULL;
ALTER TABLE ad_cell_slides_revs MODIFY aliquot_master_id INT NOT NULL;
ALTER TABLE ad_gel_matrices MODIFY aliquot_master_id INT NOT NULL;
ALTER TABLE ad_gel_matrices_revs MODIFY aliquot_master_id INT NOT NULL;
ALTER TABLE ad_tissue_cores MODIFY aliquot_master_id INT NOT NULL;
ALTER TABLE ad_tissue_cores_revs MODIFY aliquot_master_id INT NOT NULL;
ALTER TABLE ad_tissue_slides MODIFY aliquot_master_id INT NOT NULL;
ALTER TABLE ad_tissue_slides_revs MODIFY aliquot_master_id INT NOT NULL;
ALTER TABLE ad_tubes_revs MODIFY aliquot_master_id INT NOT NULL;
ALTER TABLE ad_whatman_papers MODIFY aliquot_master_id INT NOT NULL;
ALTER TABLE ad_whatman_papers_revs MODIFY aliquot_master_id INT NOT NULL;
ALTER TABLE aliquot_internal_uses MODIFY aliquot_master_id INT NOT NULL;
ALTER TABLE aliquot_internal_uses_revs MODIFY aliquot_master_id INT NOT NULL;
ALTER TABLE ar_breast_tissue_slides MODIFY aliquot_review_master_id INT NOT NULL;
ALTER TABLE ar_breast_tissue_slides_revs MODIFY aliquot_review_master_id INT NOT NULL;
ALTER TABLE derivative_details_revs MODIFY sample_master_id INT NOT NULL,
 MODIFY lab_book_master_id INT NULL;
ALTER TABLE ed_all_adverse_events_adverse_events MODIFY event_master_id INT NOT NULL;
ALTER TABLE ed_all_adverse_events_adverse_events_revs MODIFY event_master_id INT NOT NULL;
ALTER TABLE ed_all_clinical_followups MODIFY event_master_id INT NOT NULL;
ALTER TABLE ed_all_clinical_followups_revs MODIFY event_master_id INT NOT NULL;
ALTER TABLE ed_all_clinical_presentations MODIFY event_master_id INT NOT NULL;
ALTER TABLE ed_all_clinical_presentations_revs MODIFY event_master_id INT NOT NULL;
ALTER TABLE ed_all_comorbidities MODIFY event_master_id INT NOT NULL;
ALTER TABLE ed_all_comorbidities_revs MODIFY event_master_id INT NOT NULL;
ALTER TABLE ed_all_lifestyle_smokings MODIFY event_master_id INT NOT NULL;
ALTER TABLE ed_all_lifestyle_smokings_revs MODIFY event_master_id INT NOT NULL;
ALTER TABLE ed_all_protocol_followups MODIFY event_master_id INT NOT NULL;
ALTER TABLE ed_all_protocol_followups_revs MODIFY event_master_id INT NOT NULL;
ALTER TABLE ed_all_study_researches MODIFY event_master_id INT NOT NULL;
ALTER TABLE ed_all_study_researches_revs MODIFY event_master_id INT NOT NULL;
ALTER TABLE ed_breast_lab_pathologies MODIFY event_master_id INT NOT NULL;
ALTER TABLE ed_breast_lab_pathologies_revs MODIFY event_master_id INT NOT NULL;
ALTER TABLE ed_breast_screening_mammograms MODIFY event_master_id INT NOT NULL;
ALTER TABLE ed_breast_screening_mammograms_revs MODIFY event_master_id INT NOT NULL;
ALTER TABLE lbd_dna_extractions MODIFY lab_book_master_id INT NOT NULL;
ALTER TABLE lbd_dna_extractions_revs MODIFY lab_book_master_id INT NOT NULL;
ALTER TABLE lbd_slide_creations MODIFY lab_book_master_id INT NOT NULL;
ALTER TABLE lbd_slide_creations_revs MODIFY lab_book_master_id INT NOT NULL;
ALTER TABLE order_items MODIFY aliquot_master_id INT NOT NULL;
ALTER TABLE order_items_revs MODIFY aliquot_master_id INT NOT NULL;
ALTER TABLE pd_chemos MODIFY protocol_master_id INT NOT NULL;
ALTER TABLE pd_chemos_revs MODIFY protocol_master_id INT NOT NULL;
ALTER TABLE pd_surgeries MODIFY protocol_master_id INT NOT NULL;
ALTER TABLE pd_surgeries_revs MODIFY protocol_master_id INT NOT NULL;
ALTER TABLE pe_chemos MODIFY protocol_master_id INT NOT NULL;
ALTER TABLE pe_chemos_revs MODIFY protocol_master_id INT NOT NULL;
ALTER TABLE quality_ctrls MODIFY sample_master_id INT NOT NULL;
ALTER TABLE quality_ctrls_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE realiquotings MODIFY parent_aliquot_master_id INT NOT NULL;
ALTER TABLE realiquotings MODIFY child_aliquot_master_id INT NOT NULL;
ALTER TABLE realiquotings_revs MODIFY parent_aliquot_master_id INT NOT NULL;
ALTER TABLE realiquotings_revs MODIFY child_aliquot_master_id INT NOT NULL;
ALTER TABLE sd_der_amp_rnas MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_amp_rnas_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_ascite_cells MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_ascite_cells_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_ascite_sups MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_ascite_sups_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_b_cells MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_b_cells_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_blood_cells MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_blood_cells_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_bone_marrow_susps MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_bone_marrow_susps_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_cdnas MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_cdnas_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_cell_cultures MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_cell_cultures_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_cell_lysates MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_cell_lysates_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_cystic_fl_cells MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_cystic_fl_cells_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_cystic_fl_sups MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_cystic_fl_sups_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_dnas MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_dnas_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_no_b_cells MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_no_b_cells_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_pbmcs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_pbmcs_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_pericardial_fl_cells MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_pericardial_fl_cells_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_pericardial_fl_sups MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_pericardial_fl_sups_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_plasmas MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_plasmas_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_pleural_fl_cells MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_pleural_fl_cells_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_pleural_fl_sups MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_pleural_fl_sups_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_proteins MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_proteins_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_pw_cells MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_pw_cells_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_pw_sups MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_pw_sups_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_rnas MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_rnas_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_serums MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_serums_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_tiss_lysates MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_tiss_lysates_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_tiss_susps MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_tiss_susps_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_urine_cents MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_urine_cents_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_urine_cons MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_der_urine_cons_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_spe_ascites MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_spe_ascites_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_spe_bloods MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_spe_bloods_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_spe_bone_marrows MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_spe_bone_marrows_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_spe_cystic_fluids MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_spe_cystic_fluids_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_spe_pericardial_fluids MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_spe_pericardial_fluids_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_spe_peritoneal_washes MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_spe_peritoneal_washes_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_spe_pleural_fluids MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_spe_pleural_fluids_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_spe_tissues MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_spe_tissues_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_spe_urines MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sd_spe_urines_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE sopd_general_alls MODIFY sop_master_id INT NOT NULL;
ALTER TABLE sopd_general_alls_revs MODIFY sop_master_id INT NOT NULL;
ALTER TABLE sopd_inventory_alls MODIFY sop_master_id INT NOT NULL;
ALTER TABLE sopd_inventory_alls_revs MODIFY sop_master_id INT NOT NULL;
ALTER TABLE sope_general_all MODIFY sop_master_id INT NOT NULL;
ALTER TABLE sope_general_all_revs MODIFY sop_master_id INT NOT NULL;
ALTER TABLE sope_inventory_all MODIFY sop_master_id INT NOT NULL;
ALTER TABLE sope_inventory_all_revs MODIFY sop_master_id INT NOT NULL;
ALTER TABLE source_aliquots MODIFY sample_master_id INT NOT NULL;
ALTER TABLE source_aliquots MODIFY aliquot_master_id INT NOT NULL;
ALTER TABLE source_aliquots_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE source_aliquots_revs MODIFY aliquot_master_id INT NOT NULL;
ALTER TABLE specimen_details_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE specimen_review_masters MODIFY sample_master_id INT NOT NULL;
ALTER TABLE specimen_review_masters_revs MODIFY sample_master_id INT NOT NULL;
ALTER TABLE spr_breast_cancer_types MODIFY specimen_review_master_id INT NOT NULL;
ALTER TABLE spr_breast_cancer_types_revs MODIFY specimen_review_master_id INT NOT NULL;
ALTER TABLE std_boxs MODIFY storage_master_id INT NOT NULL;
ALTER TABLE std_boxs_revs MODIFY storage_master_id INT NOT NULL;
ALTER TABLE std_cupboards MODIFY storage_master_id INT NOT NULL;
ALTER TABLE std_cupboards_revs MODIFY storage_master_id INT NOT NULL;
ALTER TABLE std_freezers MODIFY storage_master_id INT NOT NULL;
ALTER TABLE std_freezers_revs MODIFY storage_master_id INT NOT NULL;
ALTER TABLE std_fridges MODIFY storage_master_id INT NOT NULL;
ALTER TABLE std_fridges_revs MODIFY storage_master_id INT NOT NULL;
ALTER TABLE std_incubators MODIFY storage_master_id INT NOT NULL;
ALTER TABLE std_incubators_revs MODIFY storage_master_id INT NOT NULL;
ALTER TABLE std_nitro_locates MODIFY storage_master_id INT NOT NULL;
ALTER TABLE std_nitro_locates_revs MODIFY storage_master_id INT NOT NULL;
ALTER TABLE std_racks MODIFY storage_master_id INT NOT NULL;
ALTER TABLE std_racks_revs MODIFY storage_master_id INT NOT NULL;
ALTER TABLE std_rooms MODIFY storage_master_id INT NOT NULL;
ALTER TABLE std_rooms_revs MODIFY storage_master_id INT NOT NULL;
ALTER TABLE std_shelfs MODIFY storage_master_id INT NOT NULL;
ALTER TABLE std_shelfs_revs MODIFY storage_master_id INT NOT NULL;
ALTER TABLE std_tma_blocks MODIFY storage_master_id INT NOT NULL;
ALTER TABLE std_tma_blocks MODIFY sop_master_id INT NOT NULL;
ALTER TABLE std_tma_blocks_revs MODIFY storage_master_id INT NOT NULL;
ALTER TABLE std_tma_blocks_revs MODIFY sop_master_id INT NOT NULL;
ALTER TABLE storage_coordinates MODIFY storage_master_id INT NOT NULL;
ALTER TABLE storage_coordinates_revs MODIFY storage_master_id INT NOT NULL;
ALTER TABLE txe_radiations MODIFY tx_master_id INT NOT NULL;
ALTER TABLE txe_radiations_revs MODIFY tx_master_id INT NOT NULL;
 
CREATE TABLE system_vars(
 k VARCHAR(50) NOT NULL PRIMARY KEY,
 v VARCHAR(50) NOT NULL
)Engine=InnoDb;
INSERT INTO system_vars (k, v) VALUES
('permission_timestamp', 0);

ALTER TABLE permissions_presets_revs
 DROP KEY name;
 
UPDATE structure_fields SET  `setting`='noCtrl=' WHERE model='0' AND tablename='' AND field='report_date_range_period' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='date_range_period');
UPDATE structure_fields SET  `setting`='noCtrl=' WHERE model='0' AND tablename='' AND field='report_spent_time_display_mode' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='spent_time_display_mode');
UPDATE structure_fields SET setting='' WHERE setting='accuracy';

UPDATE datamart_structure_functions SET link=REPLACE(link, '/clinicalannotation/', '/ClinicalAnnotation/');
UPDATE datamart_structure_functions SET link=REPLACE(link, '/inventorymanagement/', '/InventoryManagement/');
UPDATE datamart_structure_functions SET link=REPLACE(link, '/aliquot_masters/', '/AliquotMasters/');
UPDATE datamart_structure_functions SET link=REPLACE(link, '/sample_masters/', '/SampleMasters/');
UPDATE datamart_structure_functions SET link=REPLACE(link, '/order/', '/Order/');
UPDATE datamart_structure_functions SET link=REPLACE(link, '/order_items/', '/OrderItems/');
UPDATE datamart_structure_functions SET link=REPLACE(link, 'datamart/reports/', '/Datamart/Reports/');
UPDATE datamart_structure_functions SET link=REPLACE(link, '/quality_ctrls/', '/QualityCtrls/');

ALTER TABLE misc_identifiers
 ADD COLUMN flag_unique TINYINT DEFAULT NULL,
 ADD UNIQUE KEY(misc_identifier_control_id, identifier_value, flag_unique);
ALTER TABLE misc_identifiers_revs
 ADD COLUMN flag_unique TINYINT DEFAULT NULL;
ALTER TABLE misc_identifier_controls
 ADD COLUMN flag_unique BOOLEAN NOT NULL DEFAULT true;

SELECT IF(COUNT(*) > 0, "Identifiers error. Run the following query to find duplicated identifiers (or remove flag_unique on their control id if it's fine). [SELECT participant_id, identifier_value, misc_identifier_name FROM misc_identifiers AS mi INNER JOIN misc_identifier_controls AS mic ON mi.misc_identifier_control_id=mic.id WHERE deleted=0 GROUP BY identifier_value, misc_identifier_control_id HAVING COUNT(*) > 1;]", '') AS msg FROM misc_identifiers AS mi
INNER JOIN misc_identifier_controls AS mic ON mi.misc_identifier_control_id=mic.id
WHERE deleted=0 GROUP BY identifier_value, misc_identifier_control_id HAVING COUNT(*) > 1 LIMIT 1;

SELECT "If there are no misc_identifiers errors or when they are resolved, run the following query. [UPDATE misc_identifiers mi INNER JOIN misc_identifier_controls mic ON mi.misc_identifier_control_id=mic.id SET mi.flag_unique=1 WHERE mic.flag_unique=true AND mi.deleted=0;]" AS msg;
 
ALTER TABLE participants 
 ADD COLUMN last_modification DATETIME NOT NULL DEFAULT '2001-01-01 00:00:00' AFTER last_chart_checked_date_accuracy,
 ADD COLUMN last_modification_ds_id INT UNSIGNED NOT NULL DEFAULT 1 AFTER last_modification,
 ADD FOREIGN KEY (last_modification_ds_id) REFERENCES datamart_structures(id);
ALTER TABLE participants_revs 
 ADD COLUMN last_modification DATETIME NOT NULL DEFAULT '2001-01-01 00:00:00' AFTER last_chart_checked_date_accuracy,
 ADD COLUMN last_modification_ds_id INT UNSIGNED NOT NULL DEFAULT 1 AFTER last_modification;
 
ALTER TABLE datamart_structures
 DROP COLUMN use_key,
 DROP COLUMN control_model,
 DROP COLUMN control_field;
 
INSERT INTO datamart_structures(plugin, model, structure_id, display_name, control_master_model, index_link, batch_edit_link) VALUES
('ClinicalAnnotation', 'ParticipantContact', 30, 'participant contacts', '', '/ClinicalAnnotation/ParticipantContacts/detail/%%ParticipantContact.participant_id%%/%%ParticipantContact.id%%', ''), 
('ClinicalAnnotation', 'ReproductiveHistory', 110, 'reproductive histories', '', '/ClinicalAnnotation/ReproductiveHistories/detail/%%ReproductiveHistory.participant_id%%/%%ReproductiveHistory.id%%', '');

INSERT INTO datamart_browsing_controls (id1, id2, flag_active_1_to_2, flag_active_2_to_1, use_field) VALUES
(18, 4, 1, 1, 'ParticipantContact.participant_id'), 
(19, 4, 1, 1, 'ReproductiveHistory.participant_id');

UPDATE participants SET last_modification=modified, last_modification_ds_id=4; 
UPDATE participants AS t1 INNER JOIN misc_identifiers AS t2 ON t1.id=t2.participant_id SET last_modification=IF(t1.last_modification > t2.modified, t1.last_modification, t2.modified), last_modification_ds_id=IF(t1.last_modification > t2.modified, t1.last_modification_ds_id, 6); 
UPDATE participants AS t1 INNER JOIN consent_masters AS t2 ON t1.id=t2.participant_id SET last_modification=IF(t1.last_modification > t2.modified, t1.last_modification, t2.modified), last_modification_ds_id=IF(t1.last_modification > t2.modified, t1.last_modification_ds_id, 8); 
UPDATE participants AS t1 INNER JOIN diagnosis_masters AS t2 ON t1.id=t2.participant_id SET last_modification=IF(t1.last_modification > t2.modified, t1.last_modification, t2.modified), last_modification_ds_id=IF(t1.last_modification > t2.modified, t1.last_modification_ds_id, 9); 
UPDATE participants AS t1 INNER JOIN treatment_masters AS t2 ON t1.id=t2.participant_id SET last_modification=IF(t1.last_modification > t2.modified, t1.last_modification, t2.modified), last_modification_ds_id=IF(t1.last_modification > t2.modified, t1.last_modification_ds_id, 10); 
UPDATE participants AS t1 INNER JOIN family_histories AS t2 ON t1.id=t2.participant_id SET last_modification=IF(t1.last_modification > t2.modified, t1.last_modification, t2.modified), last_modification_ds_id=IF(t1.last_modification > t2.modified, t1.last_modification_ds_id, 11); 
UPDATE participants AS t1 INNER JOIN participant_messages AS t2 ON t1.id=t2.participant_id SET last_modification=IF(t1.last_modification > t2.modified, t1.last_modification, t2.modified), last_modification_ds_id=IF(t1.last_modification > t2.modified, t1.last_modification_ds_id, 12); 
UPDATE participants AS t1 INNER JOIN event_masters AS t2 ON t1.id=t2.participant_id SET last_modification=IF(t1.last_modification > t2.modified, t1.last_modification, t2.modified), last_modification_ds_id=IF(t1.last_modification > t2.modified, t1.last_modification_ds_id, 14); 
UPDATE participants AS t1 INNER JOIN participant_contacts AS t2 ON t1.id=t2.participant_id SET last_modification=IF(t1.last_modification > t2.modified, t1.last_modification, t2.modified), last_modification_ds_id=IF(t1.last_modification > t2.modified, t1.last_modification_ds_id, 18); 
UPDATE participants AS t1 INNER JOIN reproductive_histories AS t2 ON t1.id=t2.participant_id SET last_modification=IF(t1.last_modification > t2.modified, t1.last_modification, t2.modified), last_modification_ds_id=IF(t1.last_modification > t2.modified, t1.last_modification_ds_id, 19); 

ALTER TABLE participants 
 MODIFY last_modification DATETIME NOT NULL;
ALTER TABLE participants_revs 
 MODIFY last_modification DATETIME NOT NULL;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'last_modification', 'datetime',  NULL , '0', '', '', 'help_part_last_mod', 'last modification', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='last_modification' AND `type`='datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_part_last_mod' AND `language_label`='last modification' AND `language_tag`=''), '3', '100', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1');

#disable identifiers menu
UPDATE menus SET flag_active=false WHERE id IN('clin_CAN_24');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='incrementedmiscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='DE-118' AND `plugin`='ClinicalAnnotation' AND `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='identifier_abrv' AND `language_label`='identifier abrv' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='identifier_abrv_list') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='new_bank_participant_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='DE-118' AND `plugin`='ClinicalAnnotation' AND `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='identifier_abrv' AND `language_label`='identifier abrv' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='identifier_abrv_list') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_fields WHERE (`public_identifier`='DE-118' AND `plugin`='ClinicalAnnotation' AND `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='identifier_abrv' AND `language_label`='identifier abrv' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='identifier_abrv_list') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

UPDATE structure_formats SET structure_field_id=(SELECT id FROM structure_fields WHERE field='misc_identifier_name' AND structure_value_domain IS NOT NULL) WHERE structure_field_id=(SELECT id FROM structure_fields WHERE field='identifier_name' AND model='MiscIdentifier');
DELETE FROM structure_fields WHERE field='identifier_name' AND model='MiscIdentifier';

UPDATE menus SET flag_active=false WHERE id IN('inv_CAN_2222');
UPDATE menus SET flag_active=false WHERE id IN('inv_CAN_22233');

UPDATE structure_formats SET `flag_batchedit`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='used_aliq_in_stock_details') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='in_stock' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_in_stock_values') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_batchedit`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='used_aliq_in_stock_details') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='in_stock_detail' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_in_stock_detail') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_batchedit`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='used_aliq_in_stock_details') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='remove_from_storage' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_batchedit`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_sop_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_batchedit`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='study_summary_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list') AND `flag_confidential`='0');

INSERT INTO datamart_structure_functions (datamart_structure_id, label, link, flag_active) VALUES
((SELECT id FROM datamart_structures WHERE model='ViewAliquot'), 'edit', 'InventoryManagement/AliquotMasters/editInBatch/', 1);

UPDATE structure_formats SET structure_field_id=(SELECT id FROM structure_fields WHERE field='creation_site' AND model='DerivativeDetail' AND tablename='derivative_details') WHERE structure_field_id=(SELECT id FROM structure_fields WHERE field='creation_site' AND model='DerivativeDetail' AND tablename='');
DELETE FROM structure_fields WHERE field='creation_site' AND model='DerivativeDetail' AND tablename='';
UPDATE structure_formats SET structure_field_id=(SELECT id FROM structure_fields WHERE field='creation_by' AND model='DerivativeDetail' AND tablename='derivative_details') WHERE structure_field_id=(SELECT id FROM structure_fields WHERE field='creation_by' AND model='DerivativeDetail' AND tablename='');
DELETE FROM structure_fields WHERE field='creation_by' AND model='DerivativeDetail' AND tablename='';
UPDATE structure_fields SET tablename='derivative_details' WHERE model='DerivativeDetail';

UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_sop_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='collection_property' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_property') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='view_collections' AND `field`='created' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='collection_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_collection_site') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='collection_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE menus SET flag_active=false WHERE id IN('inv_CAN_21');
UPDATE menus SET parent_id='inv_CAN_1' WHERE parent_id='inv_CAN_21';

INSERT INTO structures(`alias`) VALUES ('storage_w_spaces');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('StorageLayout', '0', '', 'empty_spaces', 'integer_positive',  NULL , '0', '', '', '', 'empty spaces', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='storage_w_spaces'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='empty_spaces' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='empty spaces' AND `language_tag`=''), '0', '24', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1');

UPDATE storage_controls SET form_alias=CONCAT(form_alias, ',storage_w_spaces') WHERE coord_x_size IS NOT NULL OR coord_y_size IS NOT NULL;

ALTER TABLE datamart_structures
 ADD COLUMN adv_search_structure_alias VARCHAR(255) DEFAULT NULL AFTER structure_id, 
 ADD FOREIGN KEY (adv_search_structure_alias) REFERENCES structures(alias);
ALTER TABLE datamart_browsing_results
 CHANGE parent_node_id parent_id INT UNSIGNED DEFAULT NULL,
 ADD lft INT UNSIGNED DEFAULT NULL AFTER parent_id,
 ADD rght INT UNSIGNED DEFAULT NULL AFTER lft,
 ADD COLUMN browsing_type VARCHAR(20) NOT NULL DEFAULT '' AFTER raw;

UPDATE datamart_browsing_results SET browsing_type='drilldown' WHERE raw='0';
UPDATE datamart_browsing_results SET browsing_type='direct access' WHERE raw='1' AND LENGTH(serialized_search_params) < 66;
UPDATE datamart_browsing_results SET browsing_type='from batchset' WHERE raw='1' AND parent_id IS NULL AND serialized_search_params IS NULL;
UPDATE datamart_browsing_results SET browsing_type='search' WHERE raw='1';

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("adv_coll_datetime", "", "", "");

INSERT INTO structures(`alias`) VALUES ('collections_adv_search');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewCollection', 'view_collections', 'collection_datetime', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='adv_coll_datetime') , '0', 'noCtrl=', '', '', 'collection datetime', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='collections_adv_search'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='view_collections' AND `field`='collection_datetime' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='adv_coll_datetime')  AND `flag_confidential`='0' AND `setting`='noCtrl=' AND `default`='' AND `language_help`='' AND `language_label`='collection datetime' AND `language_tag`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

UPDATE datamart_structures SET adv_search_structure_alias='collections_adv_search' WHERE model='ViewCollection';

UPDATE datamart_browsing_controls SET use_field=SUBSTR(use_field, LOCATE('.', use_field) + 1);

UPDATE datamart_structures SET index_link='/ClinicalAnnotation/participants/profile/%%MiscIdentifier.participant_id%%' WHERE model='MiscIdentifier';

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("tx_filter", "", "", "ClinicalAnnotation.TreatmentMaster::getBrowsingFilter");
INSERT INTO structures(`alias`) VALUES ('tx_adv_search');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentMaster', '', 'browsing_filter', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='tx_filter') , '0', '', '', '', 'filter', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='tx_adv_search'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='' AND `field`='browsing_filter' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_filter')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='filter' AND `language_tag`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
UPDATE datamart_structures SET adv_search_structure_alias='tx_adv_search' WHERE model='TreatmentMaster'; 
UPDATE structure_fields SET `setting`='noCtrl=' WHERE model='TreatmentMaster' AND tablename='' AND field='browsing_filter' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='tx_filter');

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("dx_filter", "", "", "ClinicalAnnotation.DiagnosisMaster::getBrowsingFilter");
INSERT INTO structures(`alias`) VALUES ('dx_adv_search');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisMaster', '', 'browsing_filter', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='dx_filter') , '0', '', '', '', '', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='dx_adv_search'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='' AND `field`='browsing_filter' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='dx_filter')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
UPDATE datamart_structures SET adv_search_structure_alias='dx_adv_search' WHERE model='DiagnosisMaster';
UPDATE structure_fields SET `language_label`='filter', `setting`='noCtrl=' WHERE model='DiagnosisMaster' AND tablename='' AND field='browsing_filter' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='dx_filter');

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("collection_filter", "", "", "InventoryManagement.Collection::getBrowsingFilter");
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewCollection', '', 'browsing_filter', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='collection_filter') , '0', 'noCtrl=', '', '', 'filter', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='collections_adv_search'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='browsing_filter' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_filter')  AND `flag_confidential`='0' AND `setting`='noCtrl=' AND `default`='' AND `language_help`='' AND `language_label`='filter' AND `language_tag`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='chemo_completed' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='response' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='response') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='num_cycles' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='length_cycles' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='completed_cycles' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_radiations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_radiations' AND `field`='rad_completed' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno') AND `flag_confidential`='0');

UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_surgeries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='path_num' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_value_domains SET `source`="InventoryManagement.Collection::getBrowsingFilter" WHERE domain_name="collection_filter";
UPDATE structure_value_domains SET `source`="InventoryManagement.Collection::getBrowsingAdvSearch('collection_datetime')" WHERE domain_name="adv_coll_datetime";

CREATE TABLE datamart_saved_browsing_indexes(
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 user_id INT NOT NULL,
 group_id INT NOT NULL,
 sharing_status VARCHAR(50) NOT NULL DEFAULT 'user',
 name VARCHAR(50) NOT NULL DEFAULT '',
 starting_datamart_structure_id INT UNSIGNED NOT NULL,
 deleted BOOLEAN NOT NULL DEFAULT false,
 FOREIGN KEY (starting_datamart_structure_id) REFERENCES datamart_structures(id)
)Engine=InnoDb;

CREATE TABLE datamart_saved_browsing_steps(
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 datamart_saved_browsing_index_id INT UNSIGNED NOT NULL,
 datamart_structure_id INT UNSIGNED NOT NULL,
 datamart_sub_structure_id INT UNSIGNED DEFAULT NULL,
 serialized_search_params TEXT,
 deleted BOOLEAN NOT NULL DEFAULT false,
 FOREIGN KEY (datamart_saved_browsing_index_id) REFERENCES datamart_saved_browsing_indexes(id),
 FOREIGN KEY (datamart_structure_id) REFERENCES datamart_structures(id)
)Engine=InnoDb;

INSERT INTO structures(`alias`) VALUES ('datamart_saved_browsing');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', 'SavedBrowsingIndex', 'datamart_saved_browsing_indexes', 'name', 'input',  NULL , '0', '', '', '', 'name', ''), 
('Datamart', 'SavedBrowsingIndex', 'datamart_saved_browsing_indexes', 'sharing_status', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='batch_sets_sharing_status') , '0', '', '', '', 'status', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='datamart_saved_browsing'), (SELECT id FROM structure_fields WHERE `model`='SavedBrowsingIndex' AND `tablename`='datamart_saved_browsing_indexes' AND `field`='name' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='name' AND `language_tag`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='datamart_saved_browsing'), (SELECT id FROM structure_fields WHERE `model`='SavedBrowsingIndex' AND `tablename`='datamart_saved_browsing_indexes' AND `field`='sharing_status' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='batch_sets_sharing_status')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='status' AND `language_tag`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT INTO structure_validations(structure_field_id, rule) VALUES
((SELECT id FROM structure_fields WHERE `model`='SavedBrowsingIndex' AND `tablename`='datamart_saved_browsing_indexes' AND `field`='sharing_status' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='batch_sets_sharing_status')), 'notEmpty'),
((SELECT id FROM structure_fields WHERE `model`='SavedBrowsingIndex' AND `tablename`='datamart_saved_browsing_indexes' AND `field`='name' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='name' AND `language_tag`=''), 'isUnique');

UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='batch_sets_sharing_status') ,  `default`='user' WHERE model='SavedBrowsingIndex' AND tablename='datamart_saved_browsing_indexes' AND field='sharing_status' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='batch_sets_sharing_status');

ALTER TABLE menus
 DROP COLUMN created,
 DROP COLUMN created_by,
 DROP COLUMN modified,
 DROP COLUMN modified_by;

INSERT INTO menus (id, parent_id, is_root, display_order, language_title, language_description, use_link, use_summary, flag_active) VALUES
('qry-CAN-1-1-1', 'qry-CAN-1-1', 0, 1, 'data browser', '', '/Datamart/Browser/index', '', 1),
('qry-CAN-1-1-2', 'qry-CAN-1-1', 0, 1, 'saved browsing steps', '', '/Datamart/BrowsingSteps/listall', '', 1);

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', 'DatamartStructure', 'datamart_structures', 'display_name', 'input',  NULL , '0', '', '', '', 'starting element', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='datamart_saved_browsing'), (SELECT id FROM structure_fields WHERE `model`='DatamartStructure' AND `tablename`='datamart_structures' AND `field`='display_name' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='starting element' AND `language_tag`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

UPDATE datamart_structures SET control_master_model='StorageMaster' WHERE model='StorageMaster';

UPDATE structure_fields SET  `type`='password' WHERE model='User' AND tablename='users' AND field='new_password' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `type`='password' WHERE model='User' AND tablename='users' AND field='confirm_password' AND `type`='input' AND structure_value_domain  IS NULL ;

ALTER TABLE ad_bags DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ad_bags_revs DROP COLUMN id;
ALTER TABLE ad_blocks DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ad_blocks_revs DROP COLUMN id;
ALTER TABLE ad_cell_cores DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ad_cell_cores_revs DROP COLUMN id;
ALTER TABLE ad_cell_slides DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ad_cell_slides_revs DROP COLUMN id;
ALTER TABLE ad_gel_matrices DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ad_gel_matrices_revs DROP COLUMN id;
ALTER TABLE ad_tissue_cores DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ad_tissue_cores_revs DROP COLUMN id;
ALTER TABLE ad_tissue_slides DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ad_tissue_slides_revs DROP COLUMN id;
ALTER TABLE ad_tubes DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ad_tubes_revs DROP COLUMN id;
ALTER TABLE ad_whatman_papers DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ad_whatman_papers_revs DROP COLUMN id;
ALTER TABLE ar_breast_tissue_slides DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ar_breast_tissue_slides_revs DROP COLUMN id;
ALTER TABLE cd_nationals DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE cd_nationals_revs DROP COLUMN id;
ALTER TABLE derivative_details DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE derivative_details_revs DROP COLUMN id;
ALTER TABLE dxd_bloods DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE dxd_bloods_revs DROP COLUMN id;
ALTER TABLE dxd_primaries DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE dxd_primaries_revs DROP COLUMN id;
ALTER TABLE dxd_progressions DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE dxd_progressions_revs DROP COLUMN id;
ALTER TABLE dxd_recurrences DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE dxd_recurrences_revs DROP COLUMN id;
ALTER TABLE dxd_remissions DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE dxd_remissions_revs DROP COLUMN id;
ALTER TABLE dxd_secondaries DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE dxd_secondaries_revs DROP COLUMN id;
ALTER TABLE dxd_tissues DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE dxd_tissues_revs DROP COLUMN id;
ALTER TABLE ed_all_adverse_events_adverse_events DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ed_all_adverse_events_adverse_events_revs DROP COLUMN id;
ALTER TABLE ed_all_clinical_followups DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ed_all_clinical_followups_revs DROP COLUMN id;
ALTER TABLE ed_all_clinical_presentations DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ed_all_clinical_presentations_revs DROP COLUMN id;
ALTER TABLE ed_all_comorbidities DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ed_all_comorbidities_revs DROP COLUMN id;
ALTER TABLE ed_all_lifestyle_smokings DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ed_all_lifestyle_smokings_revs DROP COLUMN id;
ALTER TABLE ed_all_protocol_followups DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ed_all_protocol_followups_revs DROP COLUMN id;
ALTER TABLE ed_all_study_researches DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ed_all_study_researches_revs DROP COLUMN id;
ALTER TABLE ed_breast_lab_pathologies DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ed_breast_lab_pathologies_revs DROP COLUMN id;
ALTER TABLE ed_breast_screening_mammograms DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ed_breast_screening_mammograms_revs DROP COLUMN id;
ALTER TABLE ed_cap_report_ampullas DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ed_cap_report_ampullas_revs DROP COLUMN id;
ALTER TABLE ed_cap_report_colon_biopsies DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ed_cap_report_colon_biopsies_revs DROP COLUMN id;
ALTER TABLE ed_cap_report_colon_rectum_resections DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ed_cap_report_colon_rectum_resections_revs DROP COLUMN id;
ALTER TABLE ed_cap_report_distalexbileducts DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ed_cap_report_distalexbileducts_revs DROP COLUMN id;
ALTER TABLE ed_cap_report_gallbladders DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ed_cap_report_gallbladders_revs DROP COLUMN id;
ALTER TABLE ed_cap_report_hepatocellular_carcinomas DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ed_cap_report_hepatocellular_carcinomas_revs DROP COLUMN id;
ALTER TABLE ed_cap_report_intrahepbileducts DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ed_cap_report_intrahepbileducts_revs DROP COLUMN id;
ALTER TABLE ed_cap_report_pancreasendos DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ed_cap_report_pancreasendos_revs DROP COLUMN id;
ALTER TABLE ed_cap_report_pancreasexos DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ed_cap_report_pancreasexos_revs DROP COLUMN id;
ALTER TABLE ed_cap_report_perihilarbileducts DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ed_cap_report_perihilarbileducts_revs DROP COLUMN id;
ALTER TABLE ed_cap_report_smintestines DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE ed_cap_report_smintestines_revs DROP COLUMN id;
ALTER TABLE pd_chemos DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE pd_chemos_revs DROP COLUMN id;
ALTER TABLE pd_surgeries DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE pd_surgeries_revs DROP COLUMN id;
ALTER TABLE sd_der_amp_rnas DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_der_amp_rnas_revs DROP COLUMN id;
ALTER TABLE sd_der_ascite_cells DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_der_ascite_cells_revs DROP COLUMN id;
ALTER TABLE sd_der_ascite_sups DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_der_ascite_sups_revs DROP COLUMN id;
ALTER TABLE sd_der_b_cells DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_der_b_cells_revs DROP COLUMN id;
ALTER TABLE sd_der_blood_cells DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_der_blood_cells_revs DROP COLUMN id;
ALTER TABLE sd_der_bone_marrow_susps DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_der_bone_marrow_susps_revs DROP COLUMN id;
ALTER TABLE sd_der_cdnas DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_der_cdnas_revs DROP COLUMN id;
ALTER TABLE sd_der_cell_cultures DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_der_cell_cultures_revs DROP COLUMN id;
ALTER TABLE sd_der_cell_lysates DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_der_cell_lysates_revs DROP COLUMN id;
ALTER TABLE sd_der_cystic_fl_cells DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_der_cystic_fl_cells_revs DROP COLUMN id;
ALTER TABLE sd_der_cystic_fl_sups DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_der_cystic_fl_sups_revs DROP COLUMN id;
ALTER TABLE sd_der_dnas DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_der_dnas_revs DROP COLUMN id;
ALTER TABLE sd_der_no_b_cells DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_der_no_b_cells_revs DROP COLUMN id;
ALTER TABLE sd_der_pbmcs DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_der_pbmcs_revs DROP COLUMN id;
ALTER TABLE sd_der_pericardial_fl_cells DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_der_pericardial_fl_cells_revs DROP COLUMN id;
ALTER TABLE sd_der_pericardial_fl_sups DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_der_pericardial_fl_sups_revs DROP COLUMN id;
ALTER TABLE sd_der_plasmas DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_der_plasmas_revs DROP COLUMN id;
ALTER TABLE sd_der_pleural_fl_cells DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_der_pleural_fl_cells_revs DROP COLUMN id;
ALTER TABLE sd_der_pleural_fl_sups DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_der_pleural_fl_sups_revs DROP COLUMN id;
ALTER TABLE sd_der_proteins DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_der_proteins_revs DROP COLUMN id;
ALTER TABLE sd_der_pw_cells DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_der_pw_cells_revs DROP COLUMN id;
ALTER TABLE sd_der_pw_sups DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_der_pw_sups_revs DROP COLUMN id;
ALTER TABLE sd_der_rnas DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_der_rnas_revs DROP COLUMN id;
ALTER TABLE sd_der_serums DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_der_serums_revs DROP COLUMN id;
ALTER TABLE sd_der_tiss_lysates DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_der_tiss_lysates_revs DROP COLUMN id;
ALTER TABLE sd_der_tiss_susps DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_der_tiss_susps_revs DROP COLUMN id;
ALTER TABLE sd_der_urine_cents DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_der_urine_cents_revs DROP COLUMN id;
ALTER TABLE sd_der_urine_cons DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_der_urine_cons_revs DROP COLUMN id;
ALTER TABLE sd_spe_ascites DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_spe_ascites_revs DROP COLUMN id;
ALTER TABLE sd_spe_bloods DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_spe_bloods_revs DROP COLUMN id;
ALTER TABLE sd_spe_bone_marrows DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_spe_bone_marrows_revs DROP COLUMN id;
ALTER TABLE sd_spe_cystic_fluids DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_spe_cystic_fluids_revs DROP COLUMN id;
ALTER TABLE sd_spe_pericardial_fluids DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_spe_pericardial_fluids_revs DROP COLUMN id;
ALTER TABLE sd_spe_peritoneal_washes DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_spe_peritoneal_washes_revs DROP COLUMN id;
ALTER TABLE sd_spe_pleural_fluids DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_spe_pleural_fluids_revs DROP COLUMN id;
ALTER TABLE sd_spe_tissues DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_spe_tissues_revs DROP COLUMN id;
ALTER TABLE sd_spe_urines DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sd_spe_urines_revs DROP COLUMN id;
ALTER TABLE sopd_general_alls DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sopd_general_alls_revs DROP COLUMN id;
ALTER TABLE sopd_inventory_alls DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE sopd_inventory_alls_revs DROP COLUMN id;
ALTER TABLE specimen_details DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE specimen_details_revs DROP COLUMN id;
ALTER TABLE spr_breast_cancer_types DROP COLUMN id, DROP COLUMN deleted, DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE spr_breast_cancer_types_revs DROP COLUMN id, DROP COLUMN modified_by;
ALTER TABLE std_boxs DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE std_boxs_revs DROP COLUMN id;
ALTER TABLE std_cupboards DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE std_cupboards_revs DROP COLUMN id;
ALTER TABLE std_freezers DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE std_freezers_revs DROP COLUMN id;
ALTER TABLE std_fridges DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE std_fridges_revs DROP COLUMN id;
ALTER TABLE std_incubators DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE std_incubators_revs DROP COLUMN id;
ALTER TABLE std_nitro_locates DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE std_nitro_locates_revs DROP COLUMN id;
ALTER TABLE std_racks DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE std_racks_revs DROP COLUMN id;
ALTER TABLE std_rooms DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE std_rooms_revs DROP COLUMN id;
ALTER TABLE std_shelfs DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE std_shelfs_revs DROP COLUMN id;
ALTER TABLE std_tma_blocks DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE std_tma_blocks_revs DROP COLUMN id;
ALTER TABLE txd_chemos DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE txd_chemos_revs DROP COLUMN id;
ALTER TABLE txd_radiations DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE txd_radiations_revs DROP COLUMN id;
ALTER TABLE txd_surgeries DROP COLUMN id, DROP COLUMN deleted;
ALTER TABLE txd_surgeries_revs DROP COLUMN id;


ALTER TABLE datamart_batch_sets
 MODIFY COLUMN user_id INT NOT NULL,
 MODIFY COLUMN group_id INT NOT NULL,
 ADD FOREIGN KEY (user_id) REFERENCES users(id),
 ADD FOREIGN KEY (group_id) REFERENCES groups(id);

ALTER TABLE datamart_batch_ids
 ADD FOREIGN KEY (set_id) REFERENCES datamart_batch_sets(id);

DROP VIEW view_aliquot_uses;
CREATE VIEW `view_aliquot_uses` AS select concat(`source`.`id`,1) AS `id`,`aliq`.`id` AS `aliquot_master_id`,'sample derivative creation' AS `use_definition`,`samp`.`sample_code` AS `use_code`,'' AS `use_details`,`source`.`used_volume` AS `used_volume`,`aliqc`.`volume_unit` AS `aliquot_volume_unit`,`der`.`creation_datetime` AS `use_datetime`,`der`.`creation_datetime_accuracy` AS `use_datetime_accuracy`,`der`.`creation_by` AS `used_by`,`source`.`created` AS `created`,concat('inventorymanagement/aliquot_masters/listAllSourceAliquots/',`samp`.`collection_id`,'/',`samp`.`id`) AS `detail_url`,`samp2`.`id` AS `sample_master_id`,`samp2`.`collection_id` AS `collection_id` from (((((`source_aliquots` `source` 
join `sample_masters` `samp` on(((`samp`.`id` = `source`.`sample_master_id`) and (`samp`.`deleted` <> 1)))) 
join `derivative_details` `der` on((`samp`.`id` = `der`.`sample_master_id`))) 
join `aliquot_masters` `aliq` on(((`aliq`.`id` = `source`.`aliquot_master_id`) and (`aliq`.`deleted` <> 1)))) 
join `aliquot_controls` `aliqc` on((`aliq`.`aliquot_control_id` = `aliqc`.`id`))) 
join `sample_masters` `samp2` on(((`samp2`.`id` = `aliq`.`sample_master_id`) and (`samp`.`deleted` <> 1)))) where (`source`.`deleted` <> 1) 
union all 
select concat(`realiq`.`id`,2) AS `id`,`aliq`.`id` AS `aliquot_master_id`,'realiquoted to' AS `use_definition`,`child`.`barcode` AS `use_code`,'' AS `use_details`,`realiq`.`parent_used_volume` AS `used_volume`,`aliqc`.`volume_unit` AS `aliquot_volume_unit`,`realiq`.`realiquoting_datetime` AS `use_datetime`,`realiq`.`realiquoting_datetime_accuracy` AS `use_datetime_accuracy`,`realiq`.`realiquoted_by` AS `used_by`,`realiq`.`created` AS `created`,concat('/inventorymanagement/aliquot_masters/listAllRealiquotedParents/',`child`.`collection_id`,'/',`child`.`sample_master_id`,'/',`child`.`id`) AS `detail_url`,`samp`.`id` AS `sample_master_id`,`samp`.`collection_id` AS `collection_id` from ((((`realiquotings` `realiq` 
join `aliquot_masters` `aliq` on(((`aliq`.`id` = `realiq`.`parent_aliquot_master_id`) and (`aliq`.`deleted` <> 1)))) 
join `aliquot_controls` `aliqc` on((`aliq`.`aliquot_control_id` = `aliqc`.`id`))) 
join `aliquot_masters` `child` on(((`child`.`id` = `realiq`.`child_aliquot_master_id`) and (`child`.`deleted` <> 1)))) 
join `sample_masters` `samp` on(((`samp`.`id` = `aliq`.`sample_master_id`) and (`samp`.`deleted` <> 1)))) where (`realiq`.`deleted` <> 1) 
union all 
select concat(`qc`.`id`,3) AS `id`,`aliq`.`id` AS `aliquot_master_id`,'quality control' AS `use_definition`,`qc`.`qc_code` AS `use_code`,'' AS `use_details`,`qc`.`used_volume` AS `used_volume`,`aliqc`.`volume_unit` AS `aliquot_volume_unit`,`qc`.`date` AS `use_datetime`,`qc`.`date_accuracy` AS `use_datetime_accuracy`,`qc`.`run_by` AS `used_by`,`qc`.`created` AS `created`,concat('/inventorymanagement/quality_ctrls/detail/',`aliq`.`collection_id`,'/',`aliq`.`sample_master_id`,'/',`qc`.`id`) AS `detail_url`,`samp`.`id` AS `sample_master_id`,`samp`.`collection_id` AS `collection_id` from (((`quality_ctrls` `qc` 
join `aliquot_masters` `aliq` on(((`aliq`.`id` = `qc`.`aliquot_master_id`) and (`aliq`.`deleted` <> 1)))) 
join `aliquot_controls` `aliqc` on((`aliq`.`aliquot_control_id` = `aliqc`.`id`))) 
join `sample_masters` `samp` on(((`samp`.`id` = `aliq`.`sample_master_id`) and (`samp`.`deleted` <> 1)))) where (`qc`.`deleted` <> 1)
union all 
select concat(`item`.`id`,4) AS `id`,`aliq`.`id` AS `aliquot_master_id`,'aliquot shipment' AS `use_definition`,`sh`.`shipment_code` AS `use_code`,'' AS `use_details`,'' AS `used_volume`,'' AS `aliquot_volume_unit`,`sh`.`datetime_shipped` AS `use_datetime`,`sh`.`datetime_shipped_accuracy` AS `use_datetime_accuracy`,`sh`.`shipped_by` AS `used_by`,`sh`.`created` AS `created`,concat('/order/shipments/detail/',`sh`.`order_id`,'/',`sh`.`id`) AS `detail_url`,`samp`.`id` AS `sample_master_id`,`samp`.`collection_id` AS `collection_id` from (((`order_items` `item` 
join `aliquot_masters` `aliq` on(((`aliq`.`id` = `item`.`aliquot_master_id`) and (`aliq`.`deleted` <> 1)))) 
join `shipments` `sh` on(((`sh`.`id` = `item`.`shipment_id`) and (`sh`.`deleted` <> 1)))) 
join `sample_masters` `samp` on(((`samp`.`id` = `aliq`.`sample_master_id`) and (`samp`.`deleted` <> 1)))) where (`item`.`deleted` <> 1) 
union all 
select concat(`alr`.`id`,5) AS `id`,`aliq`.`id` AS `aliquot_master_id`,'specimen review' AS `use_definition`,`spr`.`review_code` AS `use_code`,'' AS `use_details`,'' AS `used_volume`,'' AS `aliquot_volume_unit`,`spr`.`review_date` AS `use_datetime`,`spr`.`review_date_accuracy` AS `use_datetime_accuracy`,'' AS `used_by`,`alr`.`created` AS `created`,concat('/inventorymanagement/specimen_reviews/detail/',`aliq`.`collection_id`,'/',`aliq`.`sample_master_id`,'/',`spr`.`id`) AS `detail_url`,`samp`.`id` AS `sample_master_id`,`samp`.`collection_id` AS `collection_id` from (((`aliquot_review_masters` `alr` 
join `aliquot_masters` `aliq` on(((`aliq`.`id` = `alr`.`aliquot_master_id`) and (`aliq`.`deleted` <> 1)))) 
join `specimen_review_masters` `spr` on(((`spr`.`id` = `alr`.`specimen_review_master_id`) and (`spr`.`deleted` <> 1)))) 
join `sample_masters` `samp` on(((`samp`.`id` = `aliq`.`sample_master_id`) and (`samp`.`deleted` <> 1)))) where (`alr`.`deleted` <> 1) 
union all 
select concat(`aluse`.`id`,6) AS `id`,`aliq`.`id` AS `aliquot_master_id`,'internal use' AS `use_definition`,`aluse`.`use_code` AS `use_code`,`aluse`.`use_details` AS `use_details`,`aluse`.`used_volume` AS `used_volume`,`aliqc`.`volume_unit` AS `aliquot_volume_unit`,`aluse`.`use_datetime` AS `use_datetime`,`aluse`.`use_datetime_accuracy` AS `use_datetime_accuracy`,`aluse`.`used_by` AS `used_by`,`aluse`.`created` AS `created`,concat('/inventorymanagement/aliquot_masters/detailAliquotInternalUse/',`aliq`.`id`,'/',`aluse`.`id`) AS `detail_url`,`samp`.`id` AS `sample_master_id`,`samp`.`collection_id` AS `collection_id` from (((`aliquot_internal_uses` `aluse` 
join `aliquot_masters` `aliq` on(((`aliq`.`id` = `aluse`.`aliquot_master_id`) and (`aliq`.`deleted` <> 1)))) 
join `aliquot_controls` `aliqc` on((`aliq`.`aliquot_control_id` = `aliqc`.`id`))) 
join `sample_masters` `samp` on(((`samp`.`id` = `aliq`.`sample_master_id`) and (`samp`.`deleted` <> 1)))) where (`aluse`.`deleted` <> 1);

UPDATE menus SET flag_active=false WHERE id IN('inv_CAN_2233');

UPDATE structure_formats AS sfo
INNER JOIN structure_fields AS sfi ON sfo.structure_field_id=sfi.id
SET structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' ORDER BY id LIMIT 1),
flag_override_setting=1, sfo.setting=sfi.setting, sfo.flag_override_type=1, sfo.type=sfi.type
WHERE sfo.structure_field_id IN(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats AS sfo
INNER JOIN structure_fields AS sfi ON sfo.structure_field_id=sfi.id
SET structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' ORDER BY id LIMIT 1),
flag_override_setting=1, sfo.setting=sfi.setting, sfo.flag_override_type=1, sfo.type=sfi.type
WHERE sfo.structure_field_id IN(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats AS sfo
INNER JOIN structure_fields AS sfi ON sfo.structure_field_id=sfi.id
SET sfo.flag_override_setting=0, sfo.setting=''
WHERE sfo.flag_override_setting=1 AND sfi.setting=sfo.setting;

UPDATE structure_formats AS sfo
INNER JOIN structure_fields AS sfi ON sfo.structure_field_id=sfi.id
SET sfo.flag_override_type=0, sfo.type=''
WHERE sfo.flag_override_type=1 AND sfi.type=sfo.type;

CREATE TABLE tmp (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND id NOT IN(SELECT structure_formats.structure_field_id FROM structure_formats));
DELETE FROM structure_validations WHERE structure_field_id IN(SELECT * FROM tmp);
DELETE FROM structure_fields WHERE id IN(SELECT * FROM tmp);
DROP TABLE tmp;

CREATE TABLE tmp (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND id NOT IN(SELECT structure_formats.structure_field_id FROM structure_formats));
DELETE FROM structure_validations WHERE structure_field_id IN(SELECT * FROM tmp);
DELETE FROM structure_fields WHERE id IN(SELECT * FROM tmp);
DROP TABLE tmp;

UPDATE structure_formats SET `flag_edit`='1', `flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='realiquotedparent') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='1', `flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='realiquotedparent') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='aliquot_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='realiquotedparent') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Realiquoting' AND `tablename`='realiquotings' AND `field`='parent_used_volume' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='1', `flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='realiquotedparent') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='volume_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='realiquotedparent') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Realiquoting' AND `tablename`='realiquotings' AND `field`='realiquoting_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='realiquotedparent') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Realiquoting' AND `tablename`='realiquotings' AND `field`='realiquoted_by' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='1', `flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='realiquotedparent') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

ALTER TABLE treatment_controls
 ADD COLUMN flag_use_for_ccl BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE event_controls
 ADD COLUMN flag_use_for_ccl BOOLEAN NOT NULL DEFAULT FALSE;

UPDATE treatment_controls SET flag_use_for_ccl=true WHERE tx_method like '%surgery%';

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentControl', 'treatment_controls', 'tx_method', 'input',  NULL , '0', '', '', '', 'name', ''), 
('ClinicalAnnotation', 'EventControl', 'event_controls', 'event_type', 'input',  NULL , '0', '', '', '', 'type', ''), 
('ClinicalAnnotation', 'EventControl', 'event_masters', 'event_date', 'date',  NULL , '0', '', '', '', 'date / start date', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), (SELECT id FROM structure_fields WHERE `model`='TreatmentControl' AND `tablename`='treatment_controls' AND `field`='tx_method' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='name' AND `language_tag`=''), '1', '300', 'treatment', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='start_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '301', '', '1', 'start date', '0', '', '1', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), (SELECT id FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='event_type' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '1', '400', 'annotation', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), (SELECT id FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_masters' AND `field`='event_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date / start date' AND `language_tag`=''), '1', '401', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

UPDATE structure_formats SET `language_heading`='collection' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='diagnosis' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisControl' AND `tablename`='diagnosis_controls' AND `field`='category' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='diagnosis_category') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `language_heading`='consent' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='consent_type_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='consent_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_signed_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_fields SET  `language_label`='date' WHERE model='EventControl' AND tablename='event_masters' AND field='event_date' AND `type`='date' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `flag_override_label`='0', `language_label`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='start_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

DROP TABLE clinical_collection_links;
DROP TABLE clinical_collection_links_revs;
UPDATE menus SET use_summary='' WHERE id='clin_CAN_67';


DROP VIEW view_aliquots;
DROP VIEW view_samples;

UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `type`='date' AND `structure_value_domain` IS NULL ) WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_masters' AND `field`='event_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
-- Delete obsolete structure fields and validations
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (model='EventControl' AND tablename='event_masters' AND field='event_date' AND `type`='date' AND structure_value_domain IS NULL ));
DELETE FROM structure_fields WHERE (model='EventControl' AND tablename='event_masters' AND field='event_date' AND `type`='date' AND structure_value_domain IS NULL );

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), (SELECT id FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='disease_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_disease_site_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='event_form_type' AND `language_tag`=''), '1', '400', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');
UPDATE structure_formats SET `display_order`='401', `flag_override_tag`='1', `language_tag`='', `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='event_type' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='event_type_list')) WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='event_type' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='402' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
-- Delete obsolete structure fields and validations
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (model='EventControl' AND tablename='event_controls' AND field='event_type' AND `type`='input' AND structure_value_domain IS NULL ));
DELETE FROM structure_fields WHERE (model='EventControl' AND tablename='event_controls' AND field='event_type' AND `type`='input' AND structure_value_domain IS NULL );
UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='event_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_type_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='annotation' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_disease_site_list') AND `flag_confidential`='0');

UPDATE datamart_structures SET index_link='/ClinicalAnnotation/EventMasters/detail/%%EventMaster.participant_id%%/%%EventMaster.id%%/' WHERE model='EventMaster';

ALTER TABLE templates
 MODIFY owning_entity_id INT NOT NULL,
 MODIFY visible_entity_id INT NOT NULL;

ALTER TABLE misc_identifier_controls
 ADD COLUMN pad_to_length TINYINT NOT NULL DEFAULT 0;


INSERT INTO structure_permissible_values (value, language_alias) VALUES("complete", "complete response");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="response"), (SELECT id FROM structure_permissible_values WHERE value="complete" AND language_alias="complete response"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("partial", "partial response");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="response"), (SELECT id FROM structure_permissible_values WHERE value="partial" AND language_alias="partial response"), "1", "1");
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="complete" AND spv.language_alias="complete";
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="partial" AND spv.language_alias="partial";
DELETE FROM structure_permissible_values WHERE value="partial" AND language_alias="partial";

UPDATE structure_fields SET model='SampleMaster' WHERE model='Generated' AND field='coll_to_creation_spent_time_msg';
UPDATE structure_fields SET model='SampleMaster' WHERE model='Generated' AND field='coll_to_rec_spent_time_msg';

INSERT INTO structure_permissible_values (value, language_alias) VALUES("6", "all (participant, consent, diagnosis and treatment/annotation)");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="col_copy_binding_opt"), (SELECT id FROM structure_permissible_values WHERE value="6" AND language_alias="all (participant, consent, diagnosis and treatment/annotation)"), "3", "1");
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="3" AND spv.language_alias="participant and diagnosis";
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="4" AND spv.language_alias="participant and consent";
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="5" AND spv.language_alias="participant, consent and diagnosis";
DELETE FROM structure_permissible_values WHERE value="3" AND language_alias="participant and diagnosis";
DELETE FROM structure_permissible_values WHERE value="4" AND language_alias="participant and consent";
DELETE FROM structure_permissible_values WHERE value="5" AND language_alias="participant, consent and diagnosis";

UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='col_copy_binding_opt') ,  `default`='6' WHERE model='FunctionManagement' AND tablename='' AND field='col_copy_binding_opt' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='col_copy_binding_opt');


INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("csv_export_type", "", "", NULL);
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="csv_export_type"), (SELECT id FROM structure_permissible_values WHERE value="all" AND language_alias="all"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("visible", "visible columns");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="csv_export_type"), (SELECT id FROM structure_permissible_values WHERE value="visible" AND language_alias="visible columns"), "2", "1");

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("csv_redundancy", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("same", "same line");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="csv_redundancy"), (SELECT id FROM structure_permissible_values WHERE value="same" AND language_alias="same line"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("multiple", "multiple lines");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="csv_redundancy"), (SELECT id FROM structure_permissible_values WHERE value="multiple" AND language_alias="multiple lines"), "2", "1");

INSERT INTO structures(`alias`) VALUES ('csv_popup');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('', '0', '', 'type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='csv_export_type') , '0', '', '', 'help_csv_export_type', 'type', ''), 
('', '0', '', 'redundancy', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='csv_redundancy') , '0', '', '', '', 'redundancy display', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='csv_popup'), (SELECT id FROM structure_fields WHERE `model`='Config' AND `tablename`='configs' AND `field`='config_language' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='lang')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_config_language' AND `language_label`='language' AND `language_tag`=''), '1', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='csv_popup'), (SELECT id FROM structure_fields WHERE `model`='Config' AND `tablename`='configs' AND `field`='define_csv_separator' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '1', '', '1', 'separator', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='csv_popup'), (SELECT id FROM structure_fields WHERE `model`='Config' AND `tablename`='configs' AND `field`='define_csv_encoding' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='csv_encoding')  AND `flag_confidential`='0'), '1', '2', '', '1', 'encoding', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='csv_popup'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='csv_export_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_csv_export_type' AND `language_label`='type' AND `language_tag`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='csv_popup'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='redundancy' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='csv_redundancy')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='redundancy display' AND `language_tag`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
UPDATE structure_fields SET `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='csv_export_type') ,  `default`='visible' WHERE model='0' AND tablename='' AND field='type' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='csv_export_type');
UPDATE structure_fields SET `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='csv_redundancy') ,  `default`='multiple',  `language_help`='help_csv_redundancy' WHERE model='0' AND tablename='' AND field='redundancy' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='csv_redundancy');

INSERT INTO structure_validations(structure_field_id, rule) VALUES
((SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='csv_export_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='visible' AND `language_help`='help_csv_export_type' AND `language_label`='type' AND `language_tag`=''), 'notEmpty'), 
((SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='redundancy' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='csv_redundancy')  AND `flag_confidential`='0' AND `setting`='' AND `default`='multiple' AND `language_help`='help_csv_redundancy' AND `language_label`='redundancy display' AND `language_tag`=''), 'notEmpty');

ALTER TABLE specimen_details
 DROP COLUMN created,
 DROP COLUMN created_by,
 DROP COLUMN modified,
 DROP COLUMN modified_by;
ALTER TABLE specimen_details_revs
 DROP COLUMN modified_by;
ALTER TABLE derivative_details
 DROP COLUMN created,
 DROP COLUMN created_by,
 DROP COLUMN modified,
 DROP COLUMN modified_by;
ALTER TABLE derivative_details_revs
 DROP COLUMN modified_by;
 
ALTER TABLE protocol_masters
 DROP COLUMN type;
ALTER TABLE protocol_masters_revs
 DROP COLUMN type;
 
UPDATE event_controls SET disease_site='general' WHERE disease_site='all';
UPDATE treatment_controls SET disease_site='general' WHERE disease_site='all';
 
INSERT INTO structures(`alias`) VALUES ('template_init_structure');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='supplier_dept' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_specimen_supplier_dept')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='supplier dept' AND `language_tag`=''), '1', '100', 'specimen data', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='reception_by' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='reception by' AND `language_tag`=''), '1', '200', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='reception_datetime' AND `type`='datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='inv_reception_datetime_defintion' AND `language_label`='reception date' AND `language_tag`=''), '1', '300', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
 
ALTER TABLE ed_all_lifestyle_smokings
 ADD COLUMN started_on DATE DEFAULT NULL,
 ADD COLUMN started_on_accuracy CHAR(1) NOT NULL DEFAULT 'c',
 ADD COLUMN stopped_on DATE DEFAULT NULL,
 ADD COLUMN stopped_on_accuracy CHAR(1) NOT NULL DEFAULT 'c';
ALTER TABLE ed_all_lifestyle_smokings_revs
 ADD COLUMN started_on DATE DEFAULT NULL,
 ADD COLUMN started_on_accuracy CHAR(1) NOT NULL DEFAULT 'c',
 ADD COLUMN stopped_on DATE DEFAULT NULL,
 ADD COLUMN stopped_on_accuracy CHAR(1) NOT NULL DEFAULT 'c';
 
SELECT IF(COUNT(*) = 0, "You have no entries into ed_all_lifestyle_smokings.years_quit_smoking. Drop that column.", "You have entries into ed_all_lifestyle_smokings.years_quit_smoking. That column is no longer supported in the trunk and have been hidden. You may either update the other columns in order to drop it or reactivate it. If you reactive it, you must customize the virtual fields") AS msg FROM ed_all_lifestyle_smokings WHERE years_quit_smoking IS NULL;
 
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'ed_all_lifestyle_smokings', 'started_on', 'date',  NULL , '0', '', '', '', 'started on', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_all_lifestyle_smokings', 'stopped_on', 'date',  NULL , '0', '', '', '', 'stopped on', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ed_all_lifestyle_smoking'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_all_lifestyle_smokings' AND `field`='started_on' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='started on' AND `language_tag`=''), '1', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_all_lifestyle_smoking'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_all_lifestyle_smokings' AND `field`='stopped_on' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='stopped on' AND `language_tag`=''), '1', '16', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');
-- delete structure_formats
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_all_lifestyle_smoking') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='ed_all_lifestyle_smokings' AND `field`='years_quit_smoking' AND `language_label`='years quit smoking' AND `language_tag`='' AND `type`='input' AND `setting`='size=10' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
-- Delete obsolete structure fields and validations
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='ed_all_lifestyle_smokings' AND `field`='years_quit_smoking' AND `language_label`='years quit smoking' AND `language_tag`='' AND `type`='input' AND `setting`='size=10' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='ed_all_lifestyle_smokings' AND `field`='years_quit_smoking' AND `language_label`='years quit smoking' AND `language_tag`='' AND `type`='input' AND `setting`='size=10' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', '', 'smoked_for', 'input',  NULL , '0', '', '', '', 'smoked for', ''), 
('ClinicalAnnotation', 'EventDetail', '', 'stopped_since', 'input',  NULL , '0', '', '', '', 'stopped since', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ed_all_lifestyle_smoking'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='smoked_for' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='smoked for' AND `language_tag`=''), '1', '17', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_all_lifestyle_smoking'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='stopped_since' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='stopped since' AND `language_tag`=''), '1', '18', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

UPDATE menus SET use_link='/Administrate/PasswordsAdmin/index/%%Group.id%%/%%User.id%%/' WHERE id='core_CAN_41_1_3_3';

ALTER TABLE structure_formats
 ADD COLUMN flag_float BOOLEAN DEFAULT false;

DROP VIEW view_structure_formats_simplified;
CREATE VIEW `view_structure_formats_simplified` AS select `str`.`alias` AS `structure_alias`,`sfo`.`id` AS `structure_format_id`,`sfi`.`id` AS `structure_field_id`,`sfo`.`structure_id` AS `structure_id`,`sfi`.`plugin` AS `plugin`,`sfi`.`model` AS `model`,`sfi`.`tablename` AS `tablename`,`sfi`.`field` AS `field`,`sfi`.`structure_value_domain` AS `structure_value_domain`,`svd`.`domain_name` AS `structure_value_domain_name`,`sfi`.`flag_confidential` AS `flag_confidential`,if((`sfo`.`flag_override_label` = '1'),`sfo`.`language_label`,`sfi`.`language_label`) AS `language_label`,if((`sfo`.`flag_override_tag` = '1'),`sfo`.`language_tag`,`sfi`.`language_tag`) AS `language_tag`,if((`sfo`.`flag_override_help` = '1'),`sfo`.`language_help`,`sfi`.`language_help`) AS `language_help`,if((`sfo`.`flag_override_type` = '1'),`sfo`.`type`,`sfi`.`type`) AS `type`,if((`sfo`.`flag_override_setting` = '1'),`sfo`.`setting`,`sfi`.`setting`) AS `setting`,if((`sfo`.`flag_override_default` = '1'),`sfo`.`default`,`sfi`.`default`) AS `default`,`sfo`.`flag_add` AS `flag_add`,`sfo`.`flag_add_readonly` AS `flag_add_readonly`,`sfo`.`flag_edit` AS `flag_edit`,`sfo`.`flag_edit_readonly` AS `flag_edit_readonly`,`sfo`.`flag_search` AS `flag_search`,`sfo`.`flag_search_readonly` AS `flag_search_readonly`,`sfo`.`flag_addgrid` AS `flag_addgrid`,`sfo`.`flag_addgrid_readonly` AS `flag_addgrid_readonly`,`sfo`.`flag_editgrid` AS `flag_editgrid`,`sfo`.`flag_editgrid_readonly` AS `flag_editgrid_readonly`,`sfo`.`flag_batchedit` AS `flag_batchedit`,`sfo`.`flag_batchedit_readonly` AS `flag_batchedit_readonly`,`sfo`.`flag_index` AS `flag_index`,`sfo`.`flag_detail` AS `flag_detail`,`sfo`.`flag_summary` AS `flag_summary`, sfo.flag_float AS flag_float, `sfo`.`display_column` AS `display_column`,`sfo`.`display_order` AS `display_order`,`sfo`.`language_heading` AS `language_heading` 
from (((`structure_formats` `sfo` join `structure_fields` `sfi` on((`sfo`.`structure_field_id` = `sfi`.`id`))) 
join `structures` `str` on((`str`.`id` = `sfo`.`structure_id`))) 
left join `structure_value_domains` `svd` on((`svd`.`id` = `sfi`.`structure_value_domain`)));
 
UPDATE structure_formats SET `flag_float`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'); 

UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur maligne de nature primaire ou secondaire non assurée", translated=1 WHERE id=80009;
UPDATE coding_icd_o_3_morphology SET fr_description="Cellules tumorales bénignes", translated=1 WHERE id=80010;
UPDATE coding_icd_o_3_morphology SET fr_description="Cellules tumorales de bénignité ou  de malignité non assurée", translated=1 WHERE id=80011;
UPDATE coding_icd_o_3_morphology SET fr_description="Cellules tumorales malignes", translated=1 WHERE id=80013;
UPDATE coding_icd_o_3_morphology SET fr_description= " Tumeur maligne à petites cellules", translated=1 WHERE id=80023;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur maligne à grandes cellules", translated=1 WHERE id=80033;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur maligne à cellules fusiformes", translated=1 WHERE id=80043;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur à cellules claires", translated=1 WHERE id=80050;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur maligne à cellules claires", translated=1 WHERE id=80053;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur épithéliale bénigne", translated=1 WHERE id=80100;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome in situ", translated=1 WHERE id=80102;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome", translated=1 WHERE id=80103;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome métastatique", translated=1 WHERE id=80106;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinomatose", translated=1 WHERE id=80109;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome à grandes cellules", translated=1 WHERE id=80123;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome neuroendocrinien à grandes cellules", translated=1 WHERE id=80133;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome à grandes cellules avec un phénotype rhabdoïde", translated=1 WHERE id=80143;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome à cellules hyalines", translated=1 WHERE id=80153;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome indifférencié", translated=1 WHERE id=80203;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome anaplasique", translated=1 WHERE id=80213;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome à cellules fusiformes", translated=1 WHERE id=80323;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome à cellules géantes ostéoclastiformes", translated=1 WHERE id=80353;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumorlet bénin", translated=1 WHERE id=80400;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumorlet", translated=1 WHERE id=80401;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome à petites cellules", translated=1 WHERE id=80413;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome à petites cellules intermédiaires", translated=1 WHERE id=80443;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome mixte à petites cellules", translated=1 WHERE id=80453;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome non à petites cellules", translated=1 WHERE id=80463;
UPDATE coding_icd_o_3_morphology SET fr_description="Papillome", translated=1 WHERE id=80500;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome papillaire", translated=1 WHERE id=80503;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome verruqueux", translated=1 WHERE id=80513;
UPDATE coding_icd_o_3_morphology SET fr_description="Papillome spinocellulaire", translated=1 WHERE id=80520;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome épidermoïde papillaire non invasif", translated=1 WHERE id=80522;
UPDATE coding_icd_o_3_morphology SET fr_description="Papillome épidermoïde inversé", translated=1 WHERE id=80530;
UPDATE coding_icd_o_3_morphology SET fr_description="Papillomatose épidermoïde", translated=1 WHERE id=80600;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome épidermoïde in situ", translated=1 WHERE id=80702;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome épidermoïde", translated=1 WHERE id=80703;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome épidermoïde métastatique", translated=1 WHERE id=80706;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome épidermoïde kératinisant", translated=1 WHERE id=80713;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome épidermoïde non kératinisant, à grandes cellules", translated=1 WHERE id=80723;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome épidermoïde pseudo-glandulaire", translated=1 WHERE id=80753;
UPDATE coding_icd_o_3_morphology SET fr_description="Néoplasie intraépithéliale, grade III", translated=1 WHERE id=80772;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome épidermoïde avec formation d'une corne cutanée", translated=1 WHERE id=80783;
UPDATE coding_icd_o_3_morphology SET fr_description="Érythroplasie de Queyrat", translated=1 WHERE id=80802;
UPDATE coding_icd_o_3_morphology SET fr_description="Maladie de Bowen", translated=1 WHERE id=80812;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome épidermoïde basaloïde", translated=1 WHERE id=80833;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome épidermoïde à cellules claires", translated=1 WHERE id=80843;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur basocellulaire", translated=1 WHERE id=80901;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome basocellulaire", translated=1 WHERE id=80903;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome basocellulaire superficiel multifocal", translated=1 WHERE id=80913;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome basocellulaire infiltrant", translated=1 WHERE id=80923;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome basocellulaire nodulaire", translated=1 WHERE id=80973;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome basocellulaire adénoïde", translated=1 WHERE id=80983;
UPDATE coding_icd_o_3_morphology SET fr_description="Trichilemmome", translated=1 WHERE id=81020;
UPDATE coding_icd_o_3_morphology SET fr_description="Trichilemmocarcinome", translated=1 WHERE id=81023;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur pilaire", translated=1 WHERE id=81030;
UPDATE coding_icd_o_3_morphology SET fr_description="Pilomatrixome", translated=1 WHERE id=81100;
UPDATE coding_icd_o_3_morphology SET fr_description="Papillome bénin à cellules transitionnelles", translated=1 WHERE id=81200;
UPDATE coding_icd_o_3_morphology SET fr_description="Papillome à cellules transitionnelles", translated=1 WHERE id=81201;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome à cellules transitionnelles", translated=1 WHERE id=81203;
UPDATE coding_icd_o_3_morphology SET fr_description="Papillome schneidérien", translated=1 WHERE id=81210;
UPDATE coding_icd_o_3_morphology SET fr_description="Papillome transitionnel inversé", translated=1 WHERE id=81211;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur transitionnelle papillaire à faible potentiel malin", translated=1 WHERE id=81301;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome transitionnel papillaire non invasif", translated=1 WHERE id=81302;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome transitionnel micropapillaire", translated=1 WHERE id=81313;
UPDATE coding_icd_o_3_morphology SET fr_description="Adénome", translated=1 WHERE id=81400;
UPDATE coding_icd_o_3_morphology SET fr_description="Adénome atypique", translated=1 WHERE id=81401;
UPDATE coding_icd_o_3_morphology SET fr_description="Adénocarcinome in situ", translated=1 WHERE id=81402;
UPDATE coding_icd_o_3_morphology SET fr_description="Adénocarcinome", translated=1 WHERE id=81403;
UPDATE coding_icd_o_3_morphology SET fr_description="Adénocarcinome métastatique", translated=1 WHERE id=81406;
UPDATE coding_icd_o_3_morphology SET fr_description="Néoplasie glandulaire intraépithéliale, grade III", translated=1 WHERE id=81482;
UPDATE coding_icd_o_3_morphology SET fr_description="Adénome canaliculaire", translated=1 WHERE id=81490;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur à cellules insulaires", translated=1 WHERE id=81501;
UPDATE coding_icd_o_3_morphology SET fr_description="Insulinome", translated=1 WHERE id=81510;
UPDATE coding_icd_o_3_morphology SET fr_description="Glucagonome", translated=1 WHERE id=81521;
UPDATE coding_icd_o_3_morphology SET fr_description="Gastrinome", translated=1 WHERE id=81531;
UPDATE coding_icd_o_3_morphology SET fr_description="Vipome", translated=1 WHERE id=81551;
UPDATE coding_icd_o_3_morphology SET fr_description="Vipome malin", translated=1 WHERE id=81553;
UPDATE coding_icd_o_3_morphology SET fr_description="Somatostatinome", translated=1 WHERE id=81561;
UPDATE coding_icd_o_3_morphology SET fr_description="Somatostatinome malin", translated=1 WHERE id=81563;
UPDATE coding_icd_o_3_morphology SET fr_description="Entéroglucagonome", translated=1 WHERE id=81571;
UPDATE coding_icd_o_3_morphology SET fr_description="Entéroglucagonome malin", translated=1 WHERE id=81573;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur de Klatskin", translated=1 WHERE id=81623;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome hépatocellulaire", translated=1 WHERE id=81703;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome hépatocellulaire squirrheux", translated=1 WHERE id=81723;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome hépatocellulaire, variante à cellules fusiformes", translated=1 WHERE id=81733;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome hépatocellulaire à cellules claires", translated=1 WHERE id=81743;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome hépatocellulaire pléomorphe", translated=1 WHERE id=81753;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome hépatocellulaire et cholangiocarcinome combinés", translated=1 WHERE id=81803;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome cribiforme intraépithélial", translated=1 WHERE id=82012;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome cribiforme", translated=1 WHERE id=82013;
UPDATE coding_icd_o_3_morphology SET fr_description="Adénome de lactation", translated=1 WHERE id=82040;
UPDATE coding_icd_o_3_morphology SET fr_description="Polype adénomateux", translated=1 WHERE id=82100;
UPDATE coding_icd_o_3_morphology SET fr_description="Adénome tubuleux", translated=1 WHERE id=82110;
UPDATE coding_icd_o_3_morphology SET fr_description="Adénome plat", translated=1 WHERE id=82120;
UPDATE coding_icd_o_3_morphology SET fr_description="Adénome dentelé", translated=1 WHERE id=82130;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome à cellules pariétales", translated=1 WHERE id=82143;
UPDATE coding_icd_o_3_morphology SET fr_description="Adénocarcinome des glandes anales", translated=1 WHERE id=82153;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome canalaire intraépithélial solide", translated=1 WHERE id=82302;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome solide", translated=1 WHERE id=82303;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur carcinoïde de potentiel malin incertain", translated=1 WHERE id=82401;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur carcinoïde", translated=1 WHERE id=82403;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinoïde malin à cellules entérochromaffines", translated=1 WHERE id=82413;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinoïde à cellules entérochromaffinoïdes", translated=1 WHERE id=82421;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinoïde malin à cellules entérochromaffinoïdes", translated=1 WHERE id=82423;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinoïde tubuleux", translated=1 WHERE id=82451;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur adénocarcinoïde", translated=1 WHERE id=82453;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome neuroendocrinien", translated=1 WHERE id=82463;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur carcinoïde maligne atypique", translated=1 WHERE id=82493;
UPDATE coding_icd_o_3_morphology SET fr_description="Adénocarcinome bronchioloalvéolaire", translated=1 WHERE id=82503;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome bronchioloalvéolaire non mucineux", translated=1 WHERE id=82523;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome bronchioloalvéolaire mucineux", translated=1 WHERE id=82533;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome bronchioloalvéolaire mixte mucineux et non mucineux", translated=1 WHERE id=82543;
UPDATE coding_icd_o_3_morphology SET fr_description="Adénocarcinome avec sous-types mixtes", translated=1 WHERE id=82553;
UPDATE coding_icd_o_3_morphology SET fr_description="Adénome papillaire", translated=1 WHERE id=82600;
UPDATE coding_icd_o_3_morphology SET fr_description="Adénocarcinome papillaire", translated=1 WHERE id=82603;
UPDATE coding_icd_o_3_morphology SET fr_description="Adénome villeux", translated=1 WHERE id=82610;
UPDATE coding_icd_o_3_morphology SET fr_description="Adénocarcinome in situ sur adénome villeux", translated=1 WHERE id=82612;
UPDATE coding_icd_o_3_morphology SET fr_description="Adénome tubulovilleux", translated=1 WHERE id=82630;
UPDATE coding_icd_o_3_morphology SET fr_description="Papillomatose glandulaire", translated=1 WHERE id=82640;
UPDATE coding_icd_o_3_morphology SET fr_description="Adénome pituitaire", translated=1 WHERE id=82720;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome pituitaire", translated=1 WHERE id=82723;
UPDATE coding_icd_o_3_morphology SET fr_description="Adénocarcinome à cellules claires", translated=1 WHERE id=83103;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur hypernéphroïde", translated=1 WHERE id=83111;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome à cellules rénales", translated=1 WHERE id=83123;
UPDATE coding_icd_o_3_morphology SET fr_description="Adénofibrome à cellules claires à la limite de la malignité", translated=1 WHERE id=83131;
UPDATE coding_icd_o_3_morphology SET fr_description="Adénocarcinofibrome à cellules claires", translated=1 WHERE id=83133;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome à cellules rénales associé à un kyste", translated=1 WHERE id=83163;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome à cellules rénales chromophobes", translated=1 WHERE id=83173;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome à cellules rénales sarcomatoïde", translated=1 WHERE id=83183;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome des tubes droits du rein", translated=1 WHERE id=83193;
UPDATE coding_icd_o_3_morphology SET fr_description="Adénome métanéphrique", translated=1 WHERE id=83250;
UPDATE coding_icd_o_3_morphology SET fr_description="Adénome vésiculaire atypique", translated=1 WHERE id=83301;
UPDATE coding_icd_o_3_morphology SET fr_description="Adénocarcinome vésiculaire", translated=1 WHERE id=83303;
UPDATE coding_icd_o_3_morphology SET fr_description="Adénome microvésiculaire", translated=1 WHERE id=83330;
UPDATE coding_icd_o_3_morphology SET fr_description="Adénocarcinome fœtal", translated=1 WHERE id=83333;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome vésiculaire microinvasif", translated=1 WHERE id=83353;
UPDATE coding_icd_o_3_morphology SET fr_description="Adénome trabéculaire hyalinisant", translated=1 WHERE id=83360;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome insulaire", translated=1 WHERE id=83373;
UPDATE coding_icd_o_3_morphology SET fr_description="Microcarcinome papillaire", translated=1 WHERE id=83413;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome papillaire à cellules oxyphile", translated=1 WHERE id=83423;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome papillaire encapsulé", translated=1 WHERE id=83433;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome papillaire à cellules cylindriques", translated=1 WHERE id=83443;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome mixte médullaire et vésiculaire", translated=1 WHERE id=83463;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome mixte médullaire et papillaire", translated=1 WHERE id=83473;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur juxtaglomérulaire", translated=1 WHERE id=83610;
UPDATE coding_icd_o_3_morphology SET fr_description="Adénome corticosurrénalien", translated=1 WHERE id=83700;
UPDATE coding_icd_o_3_morphology SET fr_description="Adénome corticosurrénalien à cellules compactes", translated=1 WHERE id=83710;
UPDATE coding_icd_o_3_morphology SET fr_description="Adénome corticosurrénalien pigmenté", translated=1 WHERE id=83720;
UPDATE coding_icd_o_3_morphology SET fr_description="Adénome endométrioïde", translated=1 WHERE id=83800;
UPDATE coding_icd_o_3_morphology SET fr_description="Adénocarcinome endométrioïde", translated=1 WHERE id=83803;
UPDATE coding_icd_o_3_morphology SET fr_description="Adénofibrome endométrioïde", translated=1 WHERE id=83810;
UPDATE coding_icd_o_3_morphology SET fr_description="Adénocarcinome endométrioïde, variante sécrétoire", translated=1 WHERE id=83823;
UPDATE coding_icd_o_3_morphology SET fr_description="Adénocarcinome endométrioïde, variante à cellules ciliées", translated=1 WHERE id=83833;
UPDATE coding_icd_o_3_morphology SET fr_description="Adénocarcinome de type endocervical", translated=1 WHERE id=83843;
UPDATE coding_icd_o_3_morphology SET fr_description="Fibrome folliculaire", translated=1 WHERE id=83910;
UPDATE coding_icd_o_3_morphology SET fr_description="Syringofibroadénome", translated=1 WHERE id=83920;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur de glandes sudoripares", translated=1 WHERE id=84001;
UPDATE coding_icd_o_3_morphology SET fr_description="Hidradénome nodulaire", translated=1 WHERE id=84020;
UPDATE coding_icd_o_3_morphology SET fr_description="Hidradénome nodulaire malin", translated=1 WHERE id=84023;
UPDATE coding_icd_o_3_morphology SET fr_description="Spiradénome eccrine malin", translated=1 WHERE id=84033;
UPDATE coding_icd_o_3_morphology SET fr_description="Syringome", translated=1 WHERE id=84070;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome sclérosant d'un canal sudorifère", translated=1 WHERE id=84073;
UPDATE coding_icd_o_3_morphology SET fr_description="Adénome papillaire digital agressif", translated=1 WHERE id=84081;
UPDATE coding_icd_o_3_morphology SET fr_description="Adénocarcinome papillaire eccrine", translated=1 WHERE id=84083;
UPDATE coding_icd_o_3_morphology SET fr_description="Porome eccrine", translated=1 WHERE id=84090;
UPDATE coding_icd_o_3_morphology SET fr_description="Porome eccrine malin", translated=1 WHERE id=84093;
UPDATE coding_icd_o_3_morphology SET fr_description="Adénocarcinome eccrine", translated=1 WHERE id=84133;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur muco-épidermoïde", translated=1 WHERE id=84301;
UPDATE coding_icd_o_3_morphology SET fr_description="Cystadénome", translated=1 WHERE id=84400;
UPDATE coding_icd_o_3_morphology SET fr_description="Cystadénocarcinome", translated=1 WHERE id=84403;
UPDATE coding_icd_o_3_morphology SET fr_description="Cystadénome séreux", translated=1 WHERE id=84410;
UPDATE coding_icd_o_3_morphology SET fr_description="Cystadénocarcinome séreux", translated=1 WHERE id=84413;
UPDATE coding_icd_o_3_morphology SET fr_description="Cystadénome à cellules claires", translated=1 WHERE id=84430;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur kystique à cellules claires à la limite de la malignité", translated=1 WHERE id=84441;
UPDATE coding_icd_o_3_morphology SET fr_description="Cystadénome papillaire", translated=1 WHERE id=84500;
UPDATE coding_icd_o_3_morphology SET fr_description="Cystadénocarcinome papillaire", translated=1 WHERE id=84503;
UPDATE coding_icd_o_3_morphology SET fr_description="Cystadénome papillaire à la limite de la malignité", translated=1 WHERE id=84511;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur pseudopapillaire solide", translated=1 WHERE id=84521;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome pseudopapillaire solide", translated=1 WHERE id=84523;
UPDATE coding_icd_o_3_morphology SET fr_description="Adénome intracanalaire mucineux et papillaire", translated=1 WHERE id=84530;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur intracanalaire mucineuse et papillaire avec dysplasie modérée", translated=1 WHERE id=84531;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome intracanalaire mucineux et papillaire non invasif", translated=1 WHERE id=84532;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome intracanalaire mucineux et papillaire invasif", translated=1 WHERE id=84533;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur kystique du nœud auriculo-ventriculaire", translated=1 WHERE id=84540;
UPDATE coding_icd_o_3_morphology SET fr_description="Cystadénome séreux papillaire", translated=1 WHERE id=84600;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur kystique séreuse papillaire à la limite de la malignité", translated=1 WHERE id=84621;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur séreuse papillaire de surface à la limite de la malignité", translated=1 WHERE id=84631;
UPDATE coding_icd_o_3_morphology SET fr_description="Cystadénome mucineux", translated=1 WHERE id=84700;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur kystique mucineuse avec dysplasie modérée", translated=1 WHERE id=84701;
UPDATE coding_icd_o_3_morphology SET fr_description="Cystadénocarcinome mucineux non invasif", translated=1 WHERE id=84702;
UPDATE coding_icd_o_3_morphology SET fr_description="Cystadénocarcinome mucineux", translated=1 WHERE id=84703;
UPDATE coding_icd_o_3_morphology SET fr_description="Cystadénome papillaire mucineux", translated=1 WHERE id=84710;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur kystique mucineuse à la limite de la malignité", translated=1 WHERE id=84721;
UPDATE coding_icd_o_3_morphology SET fr_description="Pseudomyxome du péritoine", translated=1 WHERE id=84806;
UPDATE coding_icd_o_3_morphology SET fr_description="Adénocarcinome mucineux de type endocervical", translated=1 WHERE id=84823;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome intracanalaire non infiltrant", translated=1 WHERE id=85002;
UPDATE coding_icd_o_3_morphology SET fr_description="Adénocarcinome canalaire infiltrant", translated=1 WHERE id=85003;
UPDATE coding_icd_o_3_morphology SET fr_description="Comédocarcinome", translated=1 WHERE id=85013;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome juvénile du sein", translated=1 WHERE id=85023;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome intrakystique", translated=1 WHERE id=85043;
UPDATE coding_icd_o_3_morphology SET fr_description="Papillomatose intracanalaire", translated=1 WHERE id=85050;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome intracanalaire micropapillaire", translated=1 WHERE id=85072;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome hypersécrétoire kystique", translated=1 WHERE id=85083;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome médullaire", translated=1 WHERE id=85103;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome médullaire à stroma lymphoïde", translated=1 WHERE id=85123;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome médullaire atypique", translated=1 WHERE id=85133;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome canalaire de type desmoplasique", translated=1 WHERE id=85143;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome lobulaire in situ", translated=1 WHERE id=85202;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome lobulaire", translated=1 WHERE id=85203;
UPDATE coding_icd_o_3_morphology SET fr_description="Liposarcome fibroblastique", translated=1 WHERE id=88573;
UPDATE coding_icd_o_3_morphology SET fr_description="Angiolipome", translated=1 WHERE id=88610;
UPDATE coding_icd_o_3_morphology SET fr_description="Lipome chondroïde", translated=1 WHERE id=88620;
UPDATE coding_icd_o_3_morphology SET fr_description="Léiomyome", translated=1 WHERE id=88900;
UPDATE coding_icd_o_3_morphology SET fr_description="Léiomyomatose", translated=1 WHERE id=88901;
UPDATE coding_icd_o_3_morphology SET fr_description="Léiomyosarcome", translated=1 WHERE id=88903;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur des muscles lisses à potentiel malin incertain", translated=1 WHERE id=88971;
UPDATE coding_icd_o_3_morphology SET fr_description="Léiomyome métastasant", translated=1 WHERE id=88981;
UPDATE coding_icd_o_3_morphology SET fr_description="Rhabdomyome", translated=1 WHERE id=89000;
UPDATE coding_icd_o_3_morphology SET fr_description="Rhabdomyosarcome", translated=1 WHERE id=89003;
UPDATE coding_icd_o_3_morphology SET fr_description="Rhabdomyosarcome pléomorphe de type adulte", translated=1 WHERE id=89013;
UPDATE coding_icd_o_3_morphology SET fr_description="Rhabdomyome génital", translated=1 WHERE id=89050;
UPDATE coding_icd_o_3_morphology SET fr_description="Sarcome du stroma endométrial", translated=1 WHERE id=89303;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinofibrome", translated=1 WHERE id=89343;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur stromale bénigne", translated=1 WHERE id=89350;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur stromale", translated=1 WHERE id=89351;
UPDATE coding_icd_o_3_morphology SET fr_description="Sarcome stromal", translated=1 WHERE id=89353;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome intracanalaire et carcinome lobulaire in situ", translated=1 WHERE id=85222;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome canalaire infiltrant avec autres types de carcinomes", translated=1 WHERE id=85233;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome lobulaire infiltrant avec autres types de carcinomes", translated=1 WHERE id=85243;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome métaplasique", translated=1 WHERE id=85753;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur des cordons sexuels et du stroma gonadique", translated=1 WHERE id=85901;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur des cordons sexuels et du stroma gonadique partiellement différenciée", translated=1 WHERE id=85911;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur des cordons sexuels et du stroma gonadique, forme mixtes", translated=1 WHERE id=85921;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur du stroma gonadique avec peu d'éléments des cordons sexuels", translated=1 WHERE id=85931;
UPDATE coding_icd_o_3_morphology SET fr_description="Thécome", translated=1 WHERE id=86000;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur stromale sclérosante", translated=1 WHERE id=86020;
UPDATE coding_icd_o_3_morphology SET fr_description="Lutéome", translated=1 WHERE id=86100;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur de la granulosa de type adulte", translated=1 WHERE id=86201;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur maligne de la granulosa", translated=1 WHERE id=86203;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur de la granulosa et de la thèque", translated=1 WHERE id=86211;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur de la granulosa juvénile", translated=1 WHERE id=86221;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur des cordons sexuels avec tubules annulaires", translated=1 WHERE id=86231;
UPDATE coding_icd_o_3_morphology SET fr_description="Androblastome", translated=1 WHERE id=86301;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur à cellules de Sertoli-Leydig bien différenciée", translated=1 WHERE id=86310;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur à cellules de Sertoli-Leydig de différenciation intermédiaire", translated=1 WHERE id=86311;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur à cellules de Sertoli-Leydig peu différenciée", translated=1 WHERE id=86313;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur rétiforme à cellules de Sertoli-Leydig", translated=1 WHERE id=86331;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur à cellules de Sertoli-Leydig, diff. inter. avec éléments hétérologues", translated=1 WHERE id=86341;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur à cellules de Sertoli-Leydig, peu diff. avec éléments hétérologues", translated=1 WHERE id=86343;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur à cellules de Sertoli", translated=1 WHERE id=86401;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur à cellules de Sertoli lipidiques", translated=1 WHERE id=86410;
UPDATE coding_icd_o_3_morphology SET fr_description="Androblastome calcifiant à grandes cellules", translated=1 WHERE id=86421;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur bénigne à cellules de Leydig", translated=1 WHERE id=86500;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur à cellules de Leydig", translated=1 WHERE id=86501;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur maligne à cellules de Leydig", translated=1 WHERE id=86503;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur à cellules du hile", translated=1 WHERE id=86600;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur à cellules lipoïdiques de l'ovaire", translated=1 WHERE id=86700;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur maligne à cellules stéroïdiennes", translated=1 WHERE id=86703;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur des vestiges surrénaliens", translated=1 WHERE id=86710;
UPDATE coding_icd_o_3_morphology SET fr_description="Paragangliome bénin", translated=1 WHERE id=86800;
UPDATE coding_icd_o_3_morphology SET fr_description="Paragangliome", translated=1 WHERE id=86801;
UPDATE coding_icd_o_3_morphology SET fr_description="Mélanome malin", translated=1 WHERE id=87203;
UPDATE coding_icd_o_3_morphology SET fr_description="Sarcome", translated=1 WHERE id=88003;
UPDATE coding_icd_o_3_morphology SET fr_description="Sarcomatose", translated=1 WHERE id=88009;
UPDATE coding_icd_o_3_morphology SET fr_description="Sarcome indifférencié", translated=1 WHERE id=88053;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur desmoplasique à petites cellules rondes", translated=1 WHERE id=88063;
UPDATE coding_icd_o_3_morphology SET fr_description="Fibrome", translated=1 WHERE id=88100;
UPDATE coding_icd_o_3_morphology SET fr_description="Fibrome cellulaire", translated=1 WHERE id=88101;
UPDATE coding_icd_o_3_morphology SET fr_description="Fibrosarcome", translated=1 WHERE id=88103;
UPDATE coding_icd_o_3_morphology SET fr_description="Myofibrome", translated=1 WHERE id=88240;
UPDATE coding_icd_o_3_morphology SET fr_description="Myofibroblastome", translated=1 WHERE id=88250;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur myofibroblastique", translated=1 WHERE id=88251;
UPDATE coding_icd_o_3_morphology SET fr_description="Angiomyofibroblastome", translated=1 WHERE id=88260;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur myofibroblastique péribronchique", translated=1 WHERE id=88271;
UPDATE coding_icd_o_3_morphology SET fr_description="Myxome", translated=1 WHERE id=88400;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur fibromyxoïde ossifiante", translated=1 WHERE id=88420;
UPDATE coding_icd_o_3_morphology SET fr_description="Lipome", translated=1 WHERE id=88500;
UPDATE coding_icd_o_3_morphology SET fr_description="Lipome atypique", translated=1 WHERE id=88501;
UPDATE coding_icd_o_3_morphology SET fr_description="Liposarcome", translated=1 WHERE id=88503;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur bénigne du stroma gastro intestinal", translated=1 WHERE id=89360;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur du stroma gastro intestinal", translated=1 WHERE id=89361;
UPDATE coding_icd_o_3_morphology SET fr_description="Sarcome du stroma gastro intestinal", translated=1 WHERE id=89363;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur mixte maligne", translated=1 WHERE id=89403;
UPDATE coding_icd_o_3_morphology SET fr_description="Mulleroblastome", translated=1 WHERE id=89503;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur mixte mésodermique", translated=1 WHERE id=89513;
UPDATE coding_icd_o_3_morphology SET fr_description="Néphrome kystique bénin", translated=1 WHERE id=89590;
UPDATE coding_icd_o_3_morphology SET fr_description="Néphrome kystique partiellement différencié", translated=1 WHERE id=89591;
UPDATE coding_icd_o_3_morphology SET fr_description="Néphrome kystique malin", translated=1 WHERE id=89593;
UPDATE coding_icd_o_3_morphology SET fr_description="Néphroblastome", translated=1 WHERE id=89603;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur rhabdoïde maligne", translated=1 WHERE id=89633;
UPDATE coding_icd_o_3_morphology SET fr_description="Adénofibrome néphrogène", translated=1 WHERE id=89650;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur à cellules interstitielles rénomédulaires", translated=1 WHERE id=89660;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur rénale ossifiante", translated=1 WHERE id=89670;
UPDATE coding_icd_o_3_morphology SET fr_description="Blastome pleuropulmonaire", translated=1 WHERE id=89733;
UPDATE coding_icd_o_3_morphology SET fr_description="Sialoblastome", translated=1 WHERE id=89741;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinosarcome", translated=1 WHERE id=89803;
UPDATE coding_icd_o_3_morphology SET fr_description="Myoépithéliome malin", translated=1 WHERE id=89823;
UPDATE coding_icd_o_3_morphology SET fr_description="Adénomyoépithéliome", translated=1 WHERE id=89830;
UPDATE coding_icd_o_3_morphology SET fr_description="Mésenchymome", translated=1 WHERE id=89901;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur de Brenner", translated=1 WHERE id=90000;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur de Brenner à la limite de la malignité", translated=1 WHERE id=90001;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur de Brenner maligne", translated=1 WHERE id=90003;
UPDATE coding_icd_o_3_morphology SET fr_description="Fibroadénome", translated=1 WHERE id=90100;
UPDATE coding_icd_o_3_morphology SET fr_description="Adénofibrome", translated=1 WHERE id=90130;
UPDATE coding_icd_o_3_morphology SET fr_description="Adénofibrome séreux", translated=1 WHERE id=90140;
UPDATE coding_icd_o_3_morphology SET fr_description="Adénofibrome séreux à la limite de la malignité", translated=1 WHERE id=90141;
UPDATE coding_icd_o_3_morphology SET fr_description="Adénocarcinofibrome séreux", translated=1 WHERE id=90143;
UPDATE coding_icd_o_3_morphology SET fr_description="Adénofibrome mucineux", translated=1 WHERE id=90150;
UPDATE coding_icd_o_3_morphology SET fr_description="Adénofibrome mucineux à la limite de la malignité", translated=1 WHERE id=90151;
UPDATE coding_icd_o_3_morphology SET fr_description="Adénocarcinofibrome mucineux", translated=1 WHERE id=90153;
UPDATE coding_icd_o_3_morphology SET fr_description="Sarcome synovial", translated=1 WHERE id=90403;
UPDATE coding_icd_o_3_morphology SET fr_description="Sarcome à cellules claires", translated=1 WHERE id=90443;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur adénomatoïde", translated=1 WHERE id=90540;
UPDATE coding_icd_o_3_morphology SET fr_description="Mésothéliome polykystique bénin", translated=1 WHERE id=90550;
UPDATE coding_icd_o_3_morphology SET fr_description="Mésothéliome kystique", translated=1 WHERE id=90551;
UPDATE coding_icd_o_3_morphology SET fr_description="Séminome", translated=1 WHERE id=90613;
UPDATE coding_icd_o_3_morphology SET fr_description="Cellules germinales intratubulaires malignes", translated=1 WHERE id=90642;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur à cellules germinales, non séminomateuse", translated=1 WHERE id=90653;
UPDATE coding_icd_o_3_morphology SET fr_description="Carcinome embryonnaire", translated=1 WHERE id=90703;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur vitelline", translated=1 WHERE id=90713;
UPDATE coding_icd_o_3_morphology SET fr_description="Tératome", translated=1 WHERE id=90801;
UPDATE coding_icd_o_3_morphology SET fr_description="Tératome malin", translated=1 WHERE id=90803;
UPDATE coding_icd_o_3_morphology SET fr_description="Kyste dermoïde", translated=1 WHERE id=90840;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur mixte des cellules germinales", translated=1 WHERE id=90853;
UPDATE coding_icd_o_3_morphology SET fr_description="Goitre ovarien", translated=1 WHERE id=90900;
UPDATE coding_icd_o_3_morphology SET fr_description="Môle hydatiforme", translated=1 WHERE id=91000;
UPDATE coding_icd_o_3_morphology SET fr_description="Choriocarcinome", translated=1 WHERE id=91003;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur trophoblastique du site placentaire", translated=1 WHERE id=91041;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur trophoblastique épithélioïde", translated=1 WHERE id=91053;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur mésonéphrique", translated=1 WHERE id=91101;
UPDATE coding_icd_o_3_morphology SET fr_description="Hémangiome", translated=1 WHERE id=91200;
UPDATE coding_icd_o_3_morphology SET fr_description="Hémangiosarcome", translated=1 WHERE id=91203;
UPDATE coding_icd_o_3_morphology SET fr_description="Hémangiome caverneux", translated=1 WHERE id=91210;
UPDATE coding_icd_o_3_morphology SET fr_description="Hémangiome veineux", translated=1 WHERE id=91220;
UPDATE coding_icd_o_3_morphology SET fr_description="Hémangiome racémeux", translated=1 WHERE id=91230;
UPDATE coding_icd_o_3_morphology SET fr_description="Hémangiome épithélioïde", translated=1 WHERE id=91250;
UPDATE coding_icd_o_3_morphology SET fr_description="Hémangioendothéliome bénin", translated=1 WHERE id=91300;
UPDATE coding_icd_o_3_morphology SET fr_description="Hémangioendothéliome", translated=1 WHERE id=91301;
UPDATE coding_icd_o_3_morphology SET fr_description="Hémangioendothéliome malin", translated=1 WHERE id=91303;
UPDATE coding_icd_o_3_morphology SET fr_description="Hémangiome capillaire", translated=1 WHERE id=91310;
UPDATE coding_icd_o_3_morphology SET fr_description="Hémangiome intramusculaire", translated=1 WHERE id=91320;
UPDATE coding_icd_o_3_morphology SET fr_description="Hémangioendothéliome épithélioïde", translated=1 WHERE id=91331;
UPDATE coding_icd_o_3_morphology SET fr_description="Hémangioendothéliome épithélioïde malin", translated=1 WHERE id=91333;
UPDATE coding_icd_o_3_morphology SET fr_description="Angioendothéliome papillaire endovasculaire", translated=1 WHERE id=91351;
UPDATE coding_icd_o_3_morphology SET fr_description="Hémangioendothéliome à cellules fusiformes", translated=1 WHERE id=91361;
UPDATE coding_icd_o_3_morphology SET fr_description="Sarcome de Kaposi", translated=1 WHERE id=91403;
UPDATE coding_icd_o_3_morphology SET fr_description="Hémangiome verruqueux kératosique", translated=1 WHERE id=91420;
UPDATE coding_icd_o_3_morphology SET fr_description="Hémangiopéricytome bénin", translated=1 WHERE id=91500;
UPDATE coding_icd_o_3_morphology SET fr_description="Hémangiopéricytome", translated=1 WHERE id=91501;
UPDATE coding_icd_o_3_morphology SET fr_description="Hémangiopéricytome malin", translated=1 WHERE id=91503;
UPDATE coding_icd_o_3_morphology SET fr_description="Angiofibrome", translated=1 WHERE id=91600;
UPDATE coding_icd_o_3_morphology SET fr_description="Hémangiome pelotonné acquis", translated=1 WHERE id=91610;
UPDATE coding_icd_o_3_morphology SET fr_description="Hémangioblastome", translated=1 WHERE id=91611;
UPDATE coding_icd_o_3_morphology SET fr_description="Lymphangiome", translated=1 WHERE id=91700;
UPDATE coding_icd_o_3_morphology SET fr_description="Hémolymphangiome", translated=1 WHERE id=91750;
UPDATE coding_icd_o_3_morphology SET fr_description="Ostéome", translated=1 WHERE id=91800;
UPDATE coding_icd_o_3_morphology SET fr_description="Ostéosarcome", translated=1 WHERE id=91803;
UPDATE coding_icd_o_3_morphology SET fr_description="Ostéosarcome sur maladie de Paget de l'os", translated=1 WHERE id=91843;
UPDATE coding_icd_o_3_morphology SET fr_description="Ostéosarcome central", translated=1 WHERE id=91863;
UPDATE coding_icd_o_3_morphology SET fr_description="Ostéosarcome intraosseux bien différencié", translated=1 WHERE id=91873;
UPDATE coding_icd_o_3_morphology SET fr_description="Ostéome ostéoïde", translated=1 WHERE id=91910;
UPDATE coding_icd_o_3_morphology SET fr_description="Ostéosarcome parostéal", translated=1 WHERE id=91923;
UPDATE coding_icd_o_3_morphology SET fr_description="Ostéosarcome périosté", translated=1 WHERE id=91933;
UPDATE coding_icd_o_3_morphology SET fr_description="Ostéosarcome de surface de haut grade", translated=1 WHERE id=91943;
UPDATE coding_icd_o_3_morphology SET fr_description="Ostéosarcome intra cortical", translated=1 WHERE id=91953;
UPDATE coding_icd_o_3_morphology SET fr_description="Ostéoblastome", translated=1 WHERE id=92000;
UPDATE coding_icd_o_3_morphology SET fr_description="Ostéoblastome agressif", translated=1 WHERE id=92101;
UPDATE coding_icd_o_3_morphology SET fr_description="Chondrome", translated=1 WHERE id=92200;
UPDATE coding_icd_o_3_morphology SET fr_description="Chondromatose", translated=1 WHERE id=92201;
UPDATE coding_icd_o_3_morphology SET fr_description="Chondrosarcome", translated=1 WHERE id=92203;
UPDATE coding_icd_o_3_morphology SET fr_description="Chondroblastome", translated=1 WHERE id=92300;
UPDATE coding_icd_o_3_morphology SET fr_description="Chondrosarcome à cellules claires", translated=1 WHERE id=92423;
UPDATE coding_icd_o_3_morphology SET fr_description="Chondrosarcome dédifférencié", translated=1 WHERE id=92433;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur à cellules géantes de l'os", translated=1 WHERE id=92501;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur maligne à cellules géantes de l'os", translated=1 WHERE id=92503;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur à cellules géantes des tissus mous", translated=1 WHERE id=92511;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur maligne à cellules géantes des tissus mous", translated=1 WHERE id=92513;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur ténosynoviale à cellules géantes", translated=1 WHERE id=92520;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur ténosynoviale maligne à cellules géantes", translated=1 WHERE id=92523;
UPDATE coding_icd_o_3_morphology SET fr_description="Sarcome d'Ewing", translated=1 WHERE id=92603;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur odontogène bénigne", translated=1 WHERE id=92700;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur odontogène", translated=1 WHERE id=92701;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur odontogène maligne", translated=1 WHERE id=92703;
UPDATE coding_icd_o_3_morphology SET fr_description="Fibrodentinome améloblastique", translated=1 WHERE id=92710;
UPDATE coding_icd_o_3_morphology SET fr_description="Cémentome", translated=1 WHERE id=92720;
UPDATE coding_icd_o_3_morphology SET fr_description="Odontome", translated=1 WHERE id=92800;
UPDATE coding_icd_o_3_morphology SET fr_description="Astrocytome", translated=1 WHERE id=94003;
UPDATE coding_icd_o_3_morphology SET fr_description="Astrocytome desmoplastique infantile", translated=1 WHERE id=94121;
UPDATE coding_icd_o_3_morphology SET fr_description="Gliome chondroïde", translated=1 WHERE id=94441;
UPDATE coding_icd_o_3_morphology SET fr_description="Médulloblastome", translated=1 WHERE id=94703;
UPDATE coding_icd_o_3_morphology SET fr_description="Médulloblastome nodulaire desmoplastique", translated=1 WHERE id=94713;
UPDATE coding_icd_o_3_morphology SET fr_description="Sarcome cérébelleux", translated=1 WHERE id=94803;
UPDATE coding_icd_o_3_morphology SET fr_description="Gangliocytome", translated=1 WHERE id=94920;
UPDATE coding_icd_o_3_morphology SET fr_description="Gangliocytome dysplasique du cervelet", translated=1 WHERE id=94930;
UPDATE coding_icd_o_3_morphology SET fr_description="Neuroblastome", translated=1 WHERE id=95003;
UPDATE coding_icd_o_3_morphology SET fr_description="Gangliogliome", translated=1 WHERE id=95051;
UPDATE coding_icd_o_3_morphology SET fr_description="Gangliogliome anaplasique", translated=1 WHERE id=95053;
UPDATE coding_icd_o_3_morphology SET fr_description="Neurocytome central", translated=1 WHERE id=95061;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur des corpuscules de Pacini", translated=1 WHERE id=95070;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur rhabdoïde/tératoïde atypique", translated=1 WHERE id=95083;
UPDATE coding_icd_o_3_morphology SET fr_description="Méningiome", translated=1 WHERE id=95300;
UPDATE coding_icd_o_3_morphology SET fr_description="Méningiomatose", translated=1 WHERE id=95301;
UPDATE coding_icd_o_3_morphology SET fr_description="Neurofibrome", translated=1 WHERE id=95400;
UPDATE coding_icd_o_3_morphology SET fr_description="Neurilemmome", translated=1 WHERE id=95600;
UPDATE coding_icd_o_3_morphology SET fr_description="Névrome", translated=1 WHERE id=95700;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur à cellules granuleuses", translated=1 WHERE id=95800;
UPDATE coding_icd_o_3_morphology SET fr_description="Lymphome malin", translated=1 WHERE id=95903;
UPDATE coding_icd_o_3_morphology SET fr_description="Leucémie", translated=1 WHERE id=98003;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur maligne des cordons sexuels et du stroma gonadique", translated=1 WHERE id=85903;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur maligne de la granulosa et de la thèque", translated=1 WHERE id=86213;
UPDATE coding_icd_o_3_morphology SET fr_description="Gynandroblastome malin", translated=1 WHERE id=86323;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur maligne du corpuscule aortique", translated=1 WHERE id=86913;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur maligne du corpuscule carotidien", translated=1 WHERE id=86923;
UPDATE coding_icd_o_3_morphology SET fr_description="Mélanome à extension superficielle in situ", translated=1 WHERE id=87432;
UPDATE coding_icd_o_3_morphology SET fr_description="Tumeur trophoblastique maligne du site placentaire", translated=1 WHERE id=91043;
 

INSERT INTO structures(`alias`) VALUES ('aliquot_barcode');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='aliquot_barcode'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '1', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='aliquot_barcode'), (SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='aliquot_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='aliquot type' AND `language_tag`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

INSERT INTO datamart_structure_functions (datamart_structure_id, label, link, flag_active) VALUES
((SELECT id FROM datamart_structures WHERE model='ViewCollection'), 'print barcodes', 'InventoryManagement/AliquotMasters/printBarcodes/model:Collection/', 1),
((SELECT id FROM datamart_structures WHERE model='ViewSample'), 'print barcodes', 'InventoryManagement/AliquotMasters/printBarcodes/model:SampleMaster/', 1),
((SELECT id FROM datamart_structures WHERE model='ViewAliquot'), 'print barcodes', 'InventoryManagement/AliquotMasters/printBarcodes/model:AliquotMaster/', 1);

INSERT INTO structure_validations (structure_field_id, rule, on_action, language_message) VALUES
((SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_all_comorbidities' AND `field`='icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), 'validateIcd10WhoCode', '', 'invalid disease code');

UPDATE menus SET is_root=1 WHERE parent_id='qry-CAN-1';

INSERT INTO menus (id, parent_id, is_root, display_order, language_title, language_description, use_link, use_summary, flag_active) VALUES
('clin_CAN_1_1', 'clin_CAN_1', 1, 1, 'add', '', '/ClinicalAnnotation/Participants/add', '', 1),
('clin_CAN_1_2', 'clin_CAN_1', 1, 2, 'identifiers', '', '/ClinicalAnnotation/MiscIdentifiers/search/', '', 1),
('clin_CAN_1_3', 'clin_CAN_1', 1, 3, 'messages', '', '/ClinicalAnnotation/ParticipantMessages/search/', '', 1),
('inv_CAN_4', 'inv_CAN', 1, 1, 'add', '', '/InventoryManagement/Collections/add', '', 1),
('inv_CAN_5', 'inv_CAN', 1, 1, 'samples', '', '/InventoryManagement/SampleMasters/search/', '', 1),
('inv_CAN_6', 'inv_CAN', 1, 1, 'aliquots', '', '/InventoryManagement/AliquotMasters/search/', '', 1),
('core_CAN_41_6', 'core_CAN_41', 0, 1, 'merge', '', '/Administrate/Merge/index/', '', 1);

INSERT INTO structures(`alias`) VALUES ('merge_index');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Administrate', 'Merge', '', 'title', 'input',  NULL , '0', '', '', '', 'title', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='Merge_index'), (SELECT id FROM structure_fields WHERE `model`='Merge' AND `tablename`='' AND `field`='title' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='title' AND `language_tag`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'); 

UPDATE datamart_structures
 SET index_link='/ClinicalAnnotation/ParticipantMessages/detail/%%ParticipantMessage.participant_id%%/%%ParticipantMessage.id%%/' WHERE model= 'ParticipantMessage';
UPDATE datamart_structures
 SET index_link='/ClinicalAnnotation/FamilyHistories/detail/%%FamilyHistory.participant_id%%/%%FamilyHistory.id%%/' WHERE model= 'FamilyHistory';



ALTER TABLE orders
 ADD COLUMN institution VARCHAR(50) NOT NULL DEFAULT '' AFTER default_study_summary_id,
 ADD COLUMN contact VARCHAR(50) NOT NULL DEFAULT '' AFTER institution,
 ADD COLUMN default_required_date DATE DEFAULT NULL AFTER contact,
 ADD COLUMN default_required_date_accuracy CHAR(1) DEFAULT 'c';
ALTER TABLE orders_revs
 ADD COLUMN institution VARCHAR(50) NOT NULL DEFAULT '' AFTER default_study_summary_id,
 ADD COLUMN contact VARCHAR(50) NOT NULL DEFAULT '' AFTER institution,
 ADD COLUMN default_required_date DATE DEFAULT NULL AFTER contact,
 ADD COLUMN default_required_date_accuracy CHAR(1) DEFAULT 'c';
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) VALUES
('orders_institution', 1, 50),
('orders_contact', 1, 50);

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("orders_institution", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'orders_institution\')");
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("orders_contact", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'orders_contact\')");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Order', 'Order', 'orders', 'institution', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='orders_institution') , '0', '', '', '', 'institution', ''), 
('Order', 'Order', 'orders', 'contact', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='orders_contact') , '0', '', '', '', 'contact', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='orders'), (SELECT id FROM structure_fields WHERE `model`='Order' AND `tablename`='orders' AND `field`='institution' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='orders_institution')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='institution' AND `language_tag`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='orders'), (SELECT id FROM structure_fields WHERE `model`='Order' AND `tablename`='orders' AND `field`='contact' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='orders_contact')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='contact' AND `language_tag`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

UPDATE structure_fields SET `language_help`='the ordering institution' WHERE model='Order' AND tablename='orders' AND field='institution' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='orders_institution');
UPDATE structure_fields SET `language_help`='the contact\'s name at the ordering institution' WHERE model='Order' AND tablename='orders' AND field='contact' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='orders_contact');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Order', 'Order', 'orders', 'default_required_date', 'date',  NULL , '0', '', '', '', 'default required date', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='orders'), (SELECT id FROM structure_fields WHERE `model`='Order' AND `tablename`='orders' AND `field`='default_required_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='default required date' AND `language_tag`=''), '1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

UPDATE structure_fields SET  `language_help`='date that is selected by default when adding order lines' WHERE model='Order' AND tablename='orders' AND field='default_required_date' AND `type`='date' AND structure_value_domain  IS NULL ;

-- delete structure_formats
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='orderlines') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Order' AND `model`='OrderLine' AND `tablename`='order_lines' AND `field`='product_code' AND `language_label`='order_product_code' AND `language_tag`='' AND `type`='input' AND `setting`='size=10' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
-- Delete obsolete structure fields and validations
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='Order' AND `model`='OrderLine' AND `tablename`='order_lines' AND `field`='product_code' AND `language_label`='order_product_code' AND `language_tag`='' AND `type`='input' AND `setting`='size=10' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='Order' AND `model`='OrderLine' AND `tablename`='order_lines' AND `field`='product_code' AND `language_label`='order_product_code' AND `language_tag`='' AND `type`='input' AND `setting`='size=10' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

ALTER TABLE order_lines
 DROP COLUMN product_code;
ALTER TABLE order_lines_revs
 DROP COLUMN product_code;

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='shippeditems') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Core' AND `model`='FunctionManagement' AND `tablename`='' AND `field`='use' AND `language_label`='use' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `language_help`='use_help' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
 
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='shippeditems') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='id' AND `language_label`='' AND `language_tag`='' AND `type`='hidden' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='shippeditems') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Order' AND `model`='OrderItem' AND `tablename`='order_items' AND `field`='id' AND `language_label`='' AND `language_tag`='' AND `type`='hidden' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='shippeditems') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Order' AND `model`='OrderLine' AND `tablename`='order_lines' AND `field`='id' AND `language_label`='' AND `language_tag`='' AND `type`='hidden' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
-- Delete obsolete structure fields and validations
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='Order' AND `model`='OrderItem' AND `tablename`='order_items' AND `field`='id' AND `language_label`='' AND `language_tag`='' AND `type`='hidden' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='Order' AND `model`='OrderLine' AND `tablename`='order_lines' AND `field`='id' AND `language_label`='' AND `language_tag`='' AND `type`='hidden' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='Order' AND `model`='OrderItem' AND `tablename`='order_items' AND `field`='id' AND `language_label`='' AND `language_tag`='' AND `type`='hidden' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='Order' AND `model`='OrderLine' AND `tablename`='order_lines' AND `field`='id' AND `language_label`='' AND `language_tag`='' AND `type`='hidden' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='shippeditems') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='OrderItem' AND `tablename`='order_items' AND `field`='date_added' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='shippeditems') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='OrderItem' AND `tablename`='order_items' AND `field`='added_by' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderlines') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='OrderLine' AND `tablename`='order_lines' AND `field`='date_required' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderlines') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='OrderLine' AND `tablename`='order_lines' AND `field`='quantity_ordered' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderlines') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='OrderLine' AND `tablename`='order_lines' AND `field`='quantity_unit' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderlines') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='OrderLine' AND `tablename`='order_lines' AND `field`='min_quantity_ordered' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

ALTER TABLE menus 
 ADD COLUMN flag_submenu BOOLEAN NOT NULL DEFAULT true;

UPDATE menus SET flag_submenu=false WHERE id IN('ord_CAN_114', 'ord_CAN_116');

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("event_filter", "", "", "ClinicalAnnotation.EventMaster::getBrowsingFilter");

INSERT INTO structures(`alias`) VALUES ('event_adv_search');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventMaster', '', 'browsing_filter', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='event_filter') , '0', 'noCtrl=', '', '', 'filter', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='event_adv_search'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='' AND `field`='browsing_filter' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_filter')  AND `flag_confidential`='0' AND `setting`='noCtrl=' AND `default`='' AND `language_help`='' AND `language_label`='filter' AND `language_tag`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

UPDATE datamart_structures SET adv_search_structure_alias='event_adv_search' WHERE model='EventMaster';

UPDATE structure_fields SET  `model`='ViewSample',  `tablename`='view_samples',  `setting`='' WHERE model='SampleMaster' AND tablename='' AND field='coll_to_rec_spent_time_msg' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `flag_override_setting`='0', `setting`='', `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimens') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='view_samples' AND `field`='coll_to_rec_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_fields SET  `setting`='' WHERE model='SampleMaster' AND tablename='' AND field='coll_to_creation_spent_time_msg' AND `type`='input' AND structure_value_domain  IS NULL ;

UPDATE structure_fields SET  `model`='ViewSample',  `tablename`='view_samples' WHERE model='SampleMaster' AND tablename='' AND field='coll_to_creation_spent_time_msg' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='derivatives') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='view_samples' AND `field`='coll_to_creation_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'); 

UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimens') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='view_samples' AND `field`='coll_to_rec_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND type='input');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='specimens'), (SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='view_samples' AND `field`='coll_to_rec_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '400', '', '1', 'collection to reception spent time (min)', '0', '', '0', '', '1', 'integer_positive', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

UPDATE structure_fields SET model='ViewAliquot', tablename='view_aliquots' WHERE field='rec_to_stor_spent_time_msg' AND plugin='InventoryManagement' AND model='Generated';
UPDATE structure_fields SET model='ViewAliquot', tablename='view_aliquots' WHERE field='coll_to_stor_spent_time_msg' AND plugin='InventoryManagement' AND model='Generated';
UPDATE structure_fields SET model='ViewAliquot', tablename='view_aliquots' WHERE field='creat_to_stor_spent_time_msg' AND plugin='InventoryManagement' AND model='Generated';

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tubes') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='rec_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tubes') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_spec_tubes'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='rec_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '61', '', '1', 'reception to storage spent time (min)', '0', '', '0', '', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_spec_tubes'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '60', '', '1', 'collection to storage spent time (min)', '0', '', '0', '', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='rec_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ml_vol'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='rec_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '61', '', '1', 'reception to storage spent time (min)', '0', '', '0', '', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ml_vol'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '60', '', '0', 'collection to storage spent time (min)', '0', '', '0', '', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='rec_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='rec_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '61', '', '1', 'reception to storage spent time (min)', '0', '', '0', '', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '60', '', '0', 'collection to storage spent time (min)', '0', '', '0', '', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ml_vol'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '60', '', '1', 'creation to storage spent time (min)', '0', '', '0', '', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ml_vol'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '59', '', '1', 'collection to storage spent time (min)', '0', '', '1', 'inv_coll_to_stor_spent_time_msg_defintion', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_cell_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_cell_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_der_cell_slides'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '60', '', '1', 'creation to storage spent time (min)', '0', '', '0', '', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_der_cell_slides'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '59', '', '1', 'collection to storage spent time (min)', '0', '', '0', '', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ul_vol_and_conc') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ul_vol_and_conc') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ul_vol_and_conc'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '60', '', '1', 'creation to storage spent time (min)', '0', '', '0', '', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ul_vol_and_conc'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '59', '', '1', 'collection to storage spent time (min)', '0', '', '0', '', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_cel_gel_matrices') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_cel_gel_matrices') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_der_cel_gel_matrices'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '60', '', '1', 'creation to storage spent time (min)', '0', '', '0', '', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_der_cel_gel_matrices'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '59', '', '1', 'collection to storage spent time (min)', '0', '', '0', '', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_cell_cores') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_cell_cores') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_der_cell_cores'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '60', '', '1', 'creation to storage spent time (min)', '0', '', '0', '', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_der_cell_cores'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '59', '', '1', 'collection to storage spent time (min)', '0', '', '0', '', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_cell_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_cell_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_der_cell_tubes_incl_ml_vol'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '60', '', '1', 'creation to storage spent time (min)', '0', '', '0', '', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_der_cell_tubes_incl_ml_vol'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '59', '', '1', 'collection to storage spent time (min)', '0', '', '0', '', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

UPDATE structure_fields SET  `type`='hidden' WHERE model='AliquotReviewMaster' AND tablename='aliquot_review_masters' AND field='id' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `display_order`='3', `flag_addgrid`='0', `flag_addgrid_readonly`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ar_breast_tissue_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotReviewMaster' AND `tablename`='aliquot_review_masters' AND `field`='id' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_editgrid_readonly`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ar_breast_tissue_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotReviewMaster' AND `tablename`='aliquot_review_masters' AND `field`='id' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_override_setting`='0', `setting`='', `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='derivatives') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='view_samples' AND `field`='coll_to_creation_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='derivatives'), (SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='view_samples' AND `field`='coll_to_creation_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '400', '', '1', 'collection to creation spent time (min)', '0', '', '1', '', '1', 'integer_positive', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

UPDATE aliquot_controls SET form_alias=SUBSTR(form_alias, 17) WHERE form_alias LIKE 'aliquot_masters,%';
UPDATE consent_controls SET form_alias=SUBSTR(form_alias, 17) WHERE form_alias LIKE 'consent_masters,%';
UPDATE diagnosis_controls SET form_alias=SUBSTR(form_alias, 18) WHERE form_alias LIKE 'diagnosismasters,%';
UPDATE event_controls SET form_alias=SUBSTR(form_alias, 14) WHERE form_alias LIKE 'eventmasters,%';
UPDATE lab_book_controls SET form_alias=SUBSTR(form_alias, 17) WHERE form_alias LIKE 'labbookmasters,%';
UPDATE sample_controls SET form_alias=SUBSTR(form_alias, 16) WHERE form_alias LIKE 'sample_masters,%';
UPDATE sop_controls SET form_alias=SUBSTR(form_alias, 12) WHERE form_alias LIKE 'sopmasters,%';
UPDATE storage_controls SET form_alias=SUBSTR(form_alias, 16) WHERE form_alias LIKE 'storagemasters,%';
UPDATE storage_controls SET form_alias=SUBSTR(form_alias, 15) WHERE form_alias LIKE 'storagemasters%';
UPDATE treatment_controls SET form_alias=SUBSTR(form_alias, 18) WHERE form_alias LIKE 'treatmentmasters,%';

ALTER TABLE aliquot_controls CHANGE form_alias detail_form_alias VARCHAR(255) NOT NULL DEFAULT '';
ALTER TABLE aliquot_review_controls CHANGE form_alias detail_form_alias VARCHAR(255) NOT NULL DEFAULT '';
ALTER TABLE consent_controls CHANGE form_alias detail_form_alias VARCHAR(255) NOT NULL DEFAULT '';
ALTER TABLE diagnosis_controls CHANGE form_alias detail_form_alias VARCHAR(255) NOT NULL DEFAULT '';
ALTER TABLE event_controls CHANGE form_alias detail_form_alias VARCHAR(255) NOT NULL DEFAULT '';
ALTER TABLE lab_book_controls CHANGE form_alias detail_form_alias VARCHAR(255) NOT NULL DEFAULT '';
ALTER TABLE protocol_controls CHANGE form_alias detail_form_alias VARCHAR(255) NOT NULL DEFAULT '';
ALTER TABLE sample_controls CHANGE form_alias detail_form_alias VARCHAR(255) NOT NULL DEFAULT '';
ALTER TABLE sop_controls CHANGE form_alias detail_form_alias VARCHAR(255) NOT NULL DEFAULT '';
ALTER TABLE specimen_review_controls CHANGE form_alias detail_form_alias VARCHAR(255) NOT NULL DEFAULT '';
ALTER TABLE storage_controls CHANGE form_alias detail_form_alias VARCHAR(255) NOT NULL DEFAULT '';
ALTER TABLE treatment_controls CHANGE form_alias detail_form_alias VARCHAR(255) NOT NULL DEFAULT '';

UPDATE structure_formats SET `flag_batchedit`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='recorded_storage_selection_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_permissible_values SET value = 'common-law partner', language_alias = 'common-law partner' WHERE value = 'common-law spouse' AND language_alias = 'common-law spouse'; 
UPDATE participant_contacts SET relationship = 'common-law partner' WHERE relationship = 'common-law spouse';

UPDATE aliquot_controls AS ac 
INNER JOIN sample_controls AS sc ON sc.id=ac.sample_control_id
SET ac.databrowser_label=CONCAT(sc.databrowser_label, '|', ac.databrowser_label);

UPDATE structure_formats sf, structures str, treatment_controls tc SET sf.flag_addgrid = sf.flag_add, sf.flag_addgrid_readonly = sf.flag_add_readonly, sf.flag_index = sf.flag_detail WHERE sf.structure_id = str.id AND tc.extend_form_alias = str.alias;
UPDATE structure_formats sf, structures str, treatment_controls tc SET sf.flag_add = 0, sf.flag_add_readonly = 0, sf.flag_detail = 0 WHERE sf.structure_id = str.id AND tc.extend_form_alias = str.alias;
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/TreatmentExtends/%';

UPDATE `datamart_reports` SET flag_active = 0 WHERE name = 'aliquots spent times summary';

INSERT INTO structures(`alias`) VALUES ('realiquotedparent_vol');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='realiquotedparent_vol'), (SELECT id FROM structure_fields WHERE `model`='Realiquoting' AND `tablename`='realiquotings' AND `field`='parent_used_volume' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='parent_used_volume_help' AND `language_label`='parent used volume' AND `language_tag`=''), '0', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='realiquotedparent_vol'), (SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='volume_unit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '0', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0');

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='realiquotedparent') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='Realiquoting' AND `tablename`='realiquotings' AND `field`='parent_used_volume' AND `language_label`='parent used volume' AND `language_tag`='' AND `type`='float_positive' AND `setting`='size=5' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='parent_used_volume_help' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='realiquotedparent') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='volume_unit' AND `language_label`='' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

UPDATE event_controls SET flag_use_for_ccl=0 WHERE event_group != 'lab';
UPDATE event_controls SET flag_use_for_ccl=1 WHERE event_group = 'lab';

INSERT INTO menus (id, parent_id, is_root, display_order, language_title, language_description, use_link, use_summary, flag_active) VALUES
('core_CAN_41_1_3_6', 'core_CAN_41_1_3', 0, 6, 'change group', '', '/Administrate/AdminUsers/changeGroup/%%Group.id%%/%%User.id%%', '', 1);

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("group_select", "", "", "Group::getList");
INSERT INTO structures(`alias`) VALUES ('group_select');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Administrate', 'Group', 'groups', 'id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='group_select') , '0', '', '', '', 'group', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='group_select'), (SELECT id FROM structure_fields WHERE `model`='Group' AND `tablename`='groups' AND `field`='id' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='group_select')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='group' AND `language_tag`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'); 
INSERT INTO structure_validations(structure_field_id, rule) VALUES
((SELECT id FROM structure_fields WHERE `model`='Group' AND `tablename`='groups' AND `field`='id' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='group_select')), 'notEmpty');

UPDATE structure_formats SET flag_override_label=1, language_label='identifier value'
WHERE structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='identifier_value' AND `structure_value_domain`  IS NULL  AND `flag_confidential`=0 AND language_label='identifier value') AND flag_override_label=0; 
UPDATE structure_formats SET structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='identifier_value' AND `structure_value_domain`  IS NULL  AND `flag_confidential`=0 AND language_label='value')
WHERE structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='identifier_value' AND `structure_value_domain`  IS NULL  AND `flag_confidential`=0 AND language_label='identifier value');
DELETE FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='identifier_value' AND `structure_value_domain`  IS NULL  AND `flag_confidential`=0 AND language_label='identifier value'; 
UPDATE structure_formats SET `flag_override_setting`='1', `setting`='size=30,class=range file' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers_for_participant_search') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='identifier_value' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE event_controls SET databrowser_label=REPLACE(databrowser_label, '|all|', '|general|');

UPDATE structure_fields SET tablename='treatment_controls' WHERE tablename='tx_controls';
UPDATE structure_fields SET tablename='shipment_contacts' WHERE tablename='shipments_contacts';

ALTER TABLE datamart_structure_functions
 ADD COLUMN ref_single_fct_link VARCHAR(200) NOT NULL DEFAULT '';
UPDATE datamart_structure_functions SET link=CONCAT('/', link) WHERE LOCATE('/', link) != 1;
UPDATE datamart_structure_functions SET ref_single_fct_link='/ClinicalAnnotation/Participants/edit/' WHERE link='/ClinicalAnnotation/Participants/batchEdit/';
UPDATE datamart_structure_functions SET ref_single_fct_link='/InventoryManagement/AliquotMasters/edit/' WHERE link='/InventoryManagement/AliquotMasters/editInBatch/';

INSERT INTO datamart_browsing_controls (id1, id2, flag_active_1_to_2, flag_active_2_to_1, use_field) VALUES
((SELECT id FROM datamart_structures WHERE model='ViewCollection'), (SELECT id FROM datamart_structures WHERE model='DiagnosisMaster'), 1, 1, 'diagnosis_master_id'),
((SELECT id FROM datamart_structures WHERE model='ViewCollection'), (SELECT id FROM datamart_structures WHERE model='EventMaster'), 1, 1, 'event_master_id'),
((SELECT id FROM datamart_structures WHERE model='ViewCollection'), (SELECT id FROM datamart_structures WHERE model='ConsentMaster'), 1, 1, 'consent_master_id'),
((SELECT id FROM datamart_structures WHERE model='ViewCollection'), (SELECT id FROM datamart_structures WHERE model='TreatmentMaster'), 1, 1, 'treatment_master_id'),
((SELECT id FROM datamart_structures WHERE model='TreatmentMaster'), (SELECT id FROM datamart_structures WHERE model='DiagnosisMaster'), 1, 1, 'diagnosis_master_id'),
((SELECT id FROM datamart_structures WHERE model='EventMaster'), (SELECT id FROM datamart_structures WHERE model='DiagnosisMaster'), 1, 1, 'diagnosis_master_id');
UPDATE structure_formats SET `flag_edit`='0', `flag_edit_readonly`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sourcealiquots') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='in_stock' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_in_stock_values') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='0', `flag_edit_readonly`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sourcealiquots') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='in_stock_detail' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_in_stock_detail') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='0', `flag_edit_readonly`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sourcealiquots') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='selection_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='0', `flag_edit_readonly`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sourcealiquots') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='storage_coord_x' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='0', `flag_edit_readonly`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sourcealiquots') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='storage_coord_y' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sourcealiquots_volume') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SourceAliquot' AND `tablename`='source_aliquots' AND `field`='used_volume' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sourcealiquots') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='remove_from_storage' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');

INSERT INTO structure_validations(structure_field_id, rule) VALUES
((SELECT id FROM structure_fields WHERE model='SampleMaster' AND tablename='sample_masters' AND field='sample_control_id' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='derivative')), 'notEmpty'),
((SELECT id FROM structure_fields WHERE model='0' AND tablename='' AND field='realiquot_into' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='realiquot_into')), 'notEmpty');

INSERT INTO structures(`alias`) VALUES ('aliquot_master_edit_in_batchs');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'FunctionManagement', '', 'remove_from_storage', 'yes_no',  NULL , '0', '', '', '', '', 'remove'),
('InventoryManagement', 'FunctionManagement', '', 'remove_in_stock_detail', 'yes_no',  NULL , '0', '', '', '', '', 'or delete data'), 
('InventoryManagement', 'FunctionManagement', '', 'remove_study_summary_id', 'yes_no',  NULL , '0', '', '', '', '', 'or delete data'), 
('InventoryManagement', 'FunctionManagement', '', 'remove_sop_master_id', 'yes_no',  NULL , '0', '', '', '', '', 'or delete data');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='aliquot_master_edit_in_batchs'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='in_stock' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_in_stock_values')  AND `flag_confidential`='0' AND `setting`='' AND `default`='yes - available' AND `language_help`='aliquot_in_stock_help' AND `language_label`='aliquot in stock' AND `language_tag`=''), '0', '400', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='aliquot_master_edit_in_batchs'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='in_stock_detail' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_in_stock_detail')  AND `flag_confidential`='0'), '0', '500', '', '0', '', '1', 'new value', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='aliquot_master_edit_in_batchs'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='recorded_storage_selection_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '701', '', '0', '', '1', 'new storage selection label', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='aliquot_master_edit_in_batchs'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='remove_from_storage' AND type = 'yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '702', '', '0', '', '1', 'or remove', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='aliquot_master_edit_in_batchs'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='study_summary_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list')  AND `flag_confidential`='0'), '0', '1180', '', '0', '', '1', 'new value', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='aliquot_master_edit_in_batchs'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_sop_list')  AND `flag_confidential`='0'), '0', '1200', '', '0', '', '1', 'new value', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='aliquot_master_edit_in_batchs'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='remove_sop_master_id' AND `type`='yes_no'), '0', '1202', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='aliquot_master_edit_in_batchs'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='remove_in_stock_detail' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='or delete data'), '0', '501', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='aliquot_master_edit_in_batchs'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='remove_study_summary_id' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='or delete data'), '0', '1181', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
UPDATE structure_formats SET `flag_batchedit`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_master_edit_in_batchs');

INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
('new value', 'New Value', 'Nouvelle valeur'),
('or delete data', 'Or Delete Data', 'Ou supprimer donnée'),
('or remove','Or Remove','Ou enlever'),
('new storage selection label','New (selection label)','Nouveau (Identifiant de sélection)'),
('data conflict: you can not delete data and set a new one', 'Data conflict: You can not delete data and set a new one', ' Conflit de données : Vous ne pouvez supprimer la données et en définir une nouvelle');

DELETE FROM datamart_reports WHERE function = 'aliquotSpentTimesCalulations';
DELETE FROM structure_formats WHERE structure_id IN (SELECT id FROM structures WHERE alias IN ('aliquot_spent_times_report', 'report_aliquot_spent_times_defintion'));
DELETE FROM structures WHERE alias IN ('aliquot_spent_times_report', 'report_aliquot_spent_times_defintion');
DELETE FROM datamart_structure_functions WHERE label = 'generate aliquots spent times summary';

ALTER TABLE	 ar_breast_tissue_slides DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 ar_breast_tissue_slides_revs DROP COLUMN modified_by;

INSERT IGNORE INTO i18n (id,en,fr) VALUES 
("a valid order line has to be selected", "A valid order line has to be selected", "Une ligne de commande valide doit être sélectionnée"),
('edit all order line items','Edit All Items','Modifier Articles'),
('order item','Order Item','Article de commande'),
('line items','Line Items','Articles de la ligne'),
('line item','Line Item','Article de la ligne'),
('no item has been defined as shipped','No item has been defined as shipped','Aucun article n''a été défini comme envoyé');

DELETE FROM menus WHERE use_link = '/Order/OrderItems/listall/%%Order.id%%/%%OrderLine.id%%/';
UPDATE menus SET language_title = 'line', language_description = 'line', use_link = '/Order/OrderLines/detail/%%Order.id%%/' WHERE use_link = '/Order/OrderLines/listall/%%Order.id%%/';
UPDATE menus SET language_title = 'shipment', language_description = 'shipment', use_link = '/Order/shipments/detail/%%Order.id%%/' WHERE use_link = '/Order/shipments/listall/%%Order.id%%/';

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='orderitems'), (SELECT id FROM structure_fields WHERE `model`='Shipment' AND `tablename`='shipments' AND `field`='shipment_code' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='order_shipment code' AND `language_tag`=''), '0', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='orderitems'), (SELECT id FROM structure_fields WHERE `model`='Shipment' AND `tablename`='shipments' AND `field`='datetime_shipped' AND `type`='datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='order_datetime_shipped' AND `language_tag`=''), '0', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Order' AND `model`='OrderItem' AND `tablename`='order_items' AND `field`='shipment_id' AND `language_label`='order_shipment' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='shipment_list') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='Order' AND `model`='OrderItem' AND `tablename`='order_items' AND `field`='shipment_id' AND `language_label`='order_shipment' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='shipment_list') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='Order' AND `model`='OrderItem' AND `tablename`='order_items' AND `field`='shipment_id' AND `language_label`='order_shipment' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='shipment_list') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Shipment' AND `tablename`='shipments' AND `field`='shipment_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Shipment' AND `tablename`='shipments' AND `field`='datetime_shipped' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE datamart_structures SET index_link = '/Order/OrderLines/detail/%%OrderLine.order_id%%/%%OrderLine.id%%/' WHERE index_link  = '/Order/OrderItems/listall/%%OrderLine.order_id%%/%%OrderLine.id%%/';

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='orderitems'), (SELECT id FROM structure_fields WHERE `model`='Shipment' AND `tablename`='shipments' AND `field`='facility' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=40' AND `default`='' AND `language_help`='' AND `language_label`='facility' AND `language_tag`=''), '0', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');

ALTER TABLE lbd_dna_extractions
 DROP COLUMN id,
 ADD PRIMARY KEY(lab_book_master_id);
ALTER TABLE lbd_dna_extractions_revs
 DROP COLUMN id;
ALTER TABLE lbd_slide_creations
 DROP COLUMN id,
 ADD PRIMARY KEY(lab_book_master_id);
ALTER TABLE lbd_slide_creations_revs
 DROP COLUMN id;
 
DELETE FROM menus WHERE use_link IN ('/StorageLayout/StorageMasters/detail/%%StorageMaster.id%%/0/TMA','/StorageLayout/TmaSlides/listAll/%%StorageMaster.id%%');

INSERT IGNORE INTO i18n (id,en,fr) VALUES ('TMA-blc','TMA-Block','TMA-Bloc');

ALTER TABLE `std_tma_blocks` CHANGE `sop_master_id` `sop_master_id` INT( 11 ) NULL ;
ALTER TABLE `std_tma_blocks_revs` CHANGE `sop_master_id` `sop_master_id` INT( 11 ) NULL ;

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='selection_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tma_slide_sop_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='storage_coord_x' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='storage_coord_y' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');


INSERT INTO structures(`alias`) VALUES ('orderitems_plus');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='orderitems_plus'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='sample_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sample type' AND `language_tag`=''), '0', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='orderitems_plus'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='selection_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '21', '', '0', '', '0', '', '1', '', '0', '', '1', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='orderitems_plus'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='storage_coord_x' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '22', '', '0', '', '0', '', '0', '', '0', '', '1', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='orderitems_plus'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='storage_coord_y' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '23', '', '0', '', '0', '', '0', '', '0', '', '1', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

UPDATE structure_formats SET `display_order`='30' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='OrderItem' AND `tablename`='order_items' AND `field`='date_added' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='31' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='OrderItem' AND `tablename`='order_items' AND `field`='added_by' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='32' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='OrderItem' AND `tablename`='order_items' AND `field`='status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='order_item_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='40' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Shipment' AND `tablename`='shipments' AND `field`='shipment_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='41' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Shipment' AND `tablename`='shipments' AND `field`='datetime_shipped' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='42' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Shipment' AND `tablename`='shipments' AND `field`='facility' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO i18n (id,en,fr) VALUES ('are you sure you want to reset?','Are you sure you want to reset?','Êtes-vous sûr de vouloir réinitialiser?');

UPDATE menus SET language_title = 'browsing' WHERE id = 'qry-CAN-1-1-1';
DELETE FROM menus WHERE id IN ('qry-CAN-1-2-1','qry-CAN-3-1');
INSERT INTO `menus` (`id`, `parent_id`, `is_root`, `display_order`, `language_title`, `language_description`, `use_link`, `use_summary`, `flag_active`, `flag_submenu`) VALUES
('qry-CAN-1-2-1', 'qry-CAN-1-2', 0, 1, 'details', '', '/Datamart/Reports/manageReport/%%Report.id%%/', 'Datamart.Report::summary', 1, 1),
('qry-CAN-3-1', 'qry-CAN-3', 0, 1, 'details', '', '/Datamart/BatchSets/listall/%%BatchSet.id%%/', 'Datamart.BatchSet::summary', 1, 1);
UPDATE menus SET use_summary = '' WHERE id IN ('qry-CAN-1-2','qry-CAN-3');


INSERT INTO structures(`alias`) VALUES ('template_disabled');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='template_disabled'), (SELECT id FROM structure_fields WHERE `model`='Template' AND `tablename`='templates' AND `field`='name' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='name' AND `language_tag`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='template_disabled'), (SELECT id FROM structure_fields WHERE `model`='Template' AND `tablename`='templates' AND `field`='owner' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sharing')  AND `flag_confidential`='0' AND `setting`='' AND `default`='user' AND `language_help`='' AND `language_label`='owner' AND `language_tag`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='template_disabled'), (SELECT id FROM structure_fields WHERE `model`='Template' AND `tablename`='templates' AND `field`='visibility' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sharing')  AND `flag_confidential`='0' AND `setting`='' AND `default`='user' AND `language_help`='' AND `language_label`='visibility' AND `language_tag`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='template_disabled'), (SELECT id FROM structure_fields WHERE `model`='Template' AND `tablename`='templates' AND `field`='flag_active' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='1' AND `language_help`='' AND `language_label`='active' AND `language_tag`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotMaster', '', 'has_notes', 'yes_no',  NULL , '0', '', '', '', 'has notes', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='' AND `field`='has_notes' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='has notes' AND `language_tag`=''), '0', '27', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_formats SET `display_order`='28' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='created' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_fields SET  `model`='ViewAliquot' WHERE model='AliquotMaster' AND tablename='' AND field='has_notes' AND `type`='yes_no' AND structure_value_domain  IS NULL ;

UPDATE structure_value_domains SET source = 'ClinicalAnnotation.DiagnosisControl::getCategoryPermissibleValues' WHERE source = 'Cinicalannotation.DiagnosisControl::getCategoryPermissibleValues';
UPDATE structure_value_domains SET source = 'ClinicalAnnotation.DiagnosisControl::getTypePermissibleValues' WHERE source = 'Cinicalannotation.DiagnosisControl::getTypePermissibleValues';
UPDATE structure_value_domains SET source=REPLACE(source, 'Clinicalannotation', 'ClinicalAnnotation');
UPDATE structure_value_domains SET source=REPLACE(source, 'Inventorymanagement', 'InventoryManagement');

ALTER TABLE misc_identifier_controls
 ADD COLUMN reg_exp_validation VARCHAR(50) NOT NULL DEFAULT '',
 ADD COLUMN user_readable_format VARCHAR(50) NOT NULL DEFAULT '';

UPDATE acos SET alias='Controller' WHERE id=1;

UPDATE structure_fields SET language_label = '', language_tag = '-' WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='disease_site';
UPDATE structure_fields SET language_label = 'event_form_type', language_tag = '' WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='event_type';
UPDATE structure_formats SET `display_order`='-3' WHERE structure_id=(SELECT id FROM structures WHERE alias='eventmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_disease_site_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='-4' WHERE structure_id=(SELECT id FROM structures WHERE alias='eventmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='event_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_type_list') AND `flag_confidential`='0');

UPDATE structure_fields SET language_label = '' WHERE `model`='TreatmentControl' AND `tablename`='treatment_controls' AND `field`='disease_site';
UPDATE structure_fields SET language_label = 'type' WHERE `model`='TreatmentControl' AND `tablename`='treatment_controls' AND `field`='tx_method';
UPDATE structure_formats SET `display_order`='0', `flag_override_tag`='0', `language_tag`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='treatmentmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentControl' AND `tablename`='treatment_controls' AND `field`='tx_method' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_method_site_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='1', `flag_override_tag`='1', `language_tag`='-' WHERE structure_id=(SELECT id FROM structures WHERE alias='treatmentmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentControl' AND `tablename`='treatment_controls' AND `field`='disease_site');

UPDATE structure_formats SET `language_heading`='', `display_order`='401', `flag_override_tag`='1', `language_tag`='-' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_disease_site_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='annotation', `display_order`='400', `flag_override_tag`='1', `language_tag`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='event_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_type_list') AND `flag_confidential`='0');

UPDATE structure_formats SET structure_field_id = (SELECT id FROM structure_fields WHERE model = 'TreatmentControl' AND field = 'tx_method' AND type = 'select') WHERE structure_field_id = (SELECT id FROM structure_fields WHERE model = 'TreatmentControl' AND field = 'tx_method' AND type = 'input');
DELETE FROM structure_fields WHERE model = 'TreatmentControl' AND field = 'tx_method' AND type = 'input';

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), (SELECT id FROM structure_fields WHERE `model`='TreatmentControl' AND `tablename`='treatment_controls' AND `field`='disease_site'), '1', '301', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_formats SET `display_order`='302' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='start_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

ALTER TABLE shipments
 ADD COLUMN delivery_phone_number VARCHAR(50) NOT NULL DEFAULT '' AFTER delivery_country,
 ADD COLUMN delivery_department_or_door VARCHAR(50) NOT NULL DEFAULT '' AFTER delivery_phone_number,
 ADD COLUMN delivery_notes text DEFAULT NULL AFTER delivery_department_or_door,
 ADD COLUMN tracking VARCHAR(50) NOT NULL DEFAULT '' AFTER shipping_account_nbr; 
ALTER TABLE shipments_revs
 ADD COLUMN delivery_phone_number VARCHAR(50) NOT NULL DEFAULT '' AFTER delivery_country,
 ADD COLUMN delivery_department_or_door VARCHAR(50) NOT NULL DEFAULT '' AFTER delivery_phone_number,
 ADD COLUMN delivery_notes text DEFAULT NULL AFTER delivery_department_or_door,
 ADD COLUMN tracking VARCHAR(50) NOT NULL DEFAULT '' AFTER shipping_account_nbr; 
ALTER TABLE shipment_contacts
 ADD COLUMN delivery_phone_number VARCHAR(50) NOT NULL DEFAULT '' AFTER delivery_country,
 ADD COLUMN delivery_department_or_door VARCHAR(50) NOT NULL DEFAULT '' AFTER delivery_phone_number,
 ADD COLUMN delivery_notes text DEFAULT NULL AFTER delivery_department_or_door; 
ALTER TABLE shipment_contacts_revs
 ADD COLUMN delivery_phone_number VARCHAR(50) NOT NULL DEFAULT '' AFTER delivery_country,
 ADD COLUMN delivery_department_or_door VARCHAR(50) NOT NULL DEFAULT '' AFTER delivery_phone_number,
 ADD COLUMN delivery_notes text DEFAULT NULL AFTER delivery_department_or_door; 

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Order', 'Shipment', 'shipments', 'delivery_department_or_door', 'input',  NULL , '0', '', '', '', 'department/door', ''), 
('Order', 'Shipment', 'shipments', 'delivery_phone_number', 'input',  NULL , '0', '', '', '', 'phone #', ''),
('Order', 'Shipment', 'shipments', 'delivery_notes', 'textarea',  NULL , '0', '', '', '', 'notes', ''),
('Order', 'Shipment', 'shipments', 'tracking', 'input',  NULL , '0', '', '', '', 'tracking #', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='shipments'), (SELECT id FROM structure_fields WHERE `model`='Shipment' AND `tablename`='shipments' AND `field`='delivery_department_or_door' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='department/door' AND `language_tag`=''), '1', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='shipments'), (SELECT id FROM structure_fields WHERE `model`='Shipment' AND `tablename`='shipments' AND `field`='delivery_phone_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='phone #' AND `language_tag`=''), '1', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='shipments'), (SELECT id FROM structure_fields WHERE `model`='Shipment' AND `tablename`='shipments' AND `field`='delivery_notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='notes' AND `language_tag`=''), '1', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='shipments'), (SELECT id FROM structure_fields WHERE `model`='Shipment' AND `tablename`='shipments' AND `field`='tracking' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tracking #' AND `language_tag`=''), '0', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
UPDATE structure_formats SET `display_order`='15' WHERE structure_id=(SELECT id FROM structures WHERE alias='shipments') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Shipment' AND `tablename`='shipments' AND `field`='delivery_street_address' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='16' WHERE structure_id=(SELECT id FROM structures WHERE alias='shipments') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Shipment' AND `tablename`='shipments' AND `field`='delivery_city' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='17' WHERE structure_id=(SELECT id FROM structures WHERE alias='shipments') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Shipment' AND `tablename`='shipments' AND `field`='delivery_province' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='18' WHERE structure_id=(SELECT id FROM structures WHERE alias='shipments') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Shipment' AND `tablename`='shipments' AND `field`='delivery_postal_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='19' WHERE structure_id=(SELECT id FROM structures WHERE alias='shipments') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Shipment' AND `tablename`='shipments' AND `field`='delivery_country' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='13' WHERE structure_id=(SELECT id FROM structures WHERE alias='shipments') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Shipment' AND `tablename`='shipments' AND `field`='facility' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='12' WHERE structure_id=(SELECT id FROM structures WHERE alias='shipments') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Shipment' AND `tablename`='shipments' AND `field`='delivery_phone_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Order', 'ShipmentContact', 'shipment_contacts', 'delivery_phone_number', 'input',  NULL , '0', '', '', '', 'delivery phone #', ''), 
('Order', 'ShipmentContact', 'shipment_contacts', 'delivery_department_or_door', 'input',  NULL , '0', '', '', '', 'delivery department or door', ''), 
('Order', 'ShipmentContact', 'shipment_contacts', 'delivery_notes', 'textarea',  NULL , '0', '', '', '', 'delivery notes', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='shipment_recipients'), (SELECT id FROM structure_fields WHERE `model`='ShipmentContact' AND `tablename`='shipment_contacts' AND `field`='delivery_phone_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='delivery phone #' AND `language_tag`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='shipment_recipients'), (SELECT id FROM structure_fields WHERE `model`='ShipmentContact' AND `tablename`='shipment_contacts' AND `field`='delivery_department_or_door' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='delivery department or door' AND `language_tag`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='shipment_recipients'), (SELECT id FROM structure_fields WHERE `model`='ShipmentContact' AND `tablename`='shipment_contacts' AND `field`='delivery_notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='delivery notes' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
UPDATE structure_formats SET `display_order`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='shipment_recipients') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ShipmentContact' AND `tablename`='shipment_contacts' AND `field`='facility' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='5' WHERE structure_id=(SELECT id FROM structures WHERE alias='shipment_recipients') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ShipmentContact' AND `tablename`='shipment_contacts' AND `field`='delivery_street_address' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='6' WHERE structure_id=(SELECT id FROM structures WHERE alias='shipment_recipients') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ShipmentContact' AND `tablename`='shipment_contacts' AND `field`='delivery_city' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='7' WHERE structure_id=(SELECT id FROM structures WHERE alias='shipment_recipients') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ShipmentContact' AND `tablename`='shipment_contacts' AND `field`='delivery_province' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='8' WHERE structure_id=(SELECT id FROM structures WHERE alias='shipment_recipients') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ShipmentContact' AND `tablename`='shipment_contacts' AND `field`='delivery_postal_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='9' WHERE structure_id=(SELECT id FROM structures WHERE alias='shipment_recipients') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ShipmentContact' AND `tablename`='shipment_contacts' AND `field`='delivery_country' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_fields SET  `language_label`='time_hour' WHERE model='custom' AND tablename='' AND field='time' AND `type`='time' AND structure_value_domain  IS NULL ;

ALTER TABLE sd_spe_tissues MODIFY `tissue_laterality` varchar(30) DEFAULT NULL;
ALTER TABLE sd_spe_tissues_revs MODIFY `tissue_laterality` varchar(30) DEFAULT NULL;

REPLACE INTO i18n (id,en,fr) VALUES 
('the format of the identifier is incorrect', 'The format of the identifier is incorrect', 'Le format de l''identifiant est incorrecte'),
('expected misc identifier format is %s', '(The expected misc identifier format is %s)', '(Le format de l''identifiant attendu est %s)'),
('all with filter', 'All with Filter', 'Tous avec filtre');

ALTER TABLE aliquot_internal_uses 
  ADD COLUMN `type` varchar(50) DEFAULT NULL AFTER aliquot_master_id,
  ADD COLUMN `duration` int(6) DEFAULT NULL AFTER use_datetime_accuracy,
  ADD COLUMN `duration_unit` varchar(25)  DEFAULT NULL AFTER duration;
ALTER TABLE aliquot_internal_uses_revs 
  ADD COLUMN `type` varchar(50) DEFAULT NULL AFTER aliquot_master_id,
  ADD COLUMN `duration` int(6) DEFAULT NULL AFTER use_datetime_accuracy,
  ADD COLUMN `duration_unit` varchar(25)  DEFAULT NULL AFTER duration;

UPDATE aliquot_internal_uses SET type = 'internal use';
UPDATE aliquot_internal_uses_revs SET type = 'internal use';

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("duration_unit", "", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
VALUES
("mn", "minutes_unit"),
("hr", "hour_unit"),
("d", "day_unit"),
("m", "month_unit"),
("yr", "year_unit");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="duration_unit"), (SELECT id FROM structure_permissible_values WHERE value="mn" AND language_alias="minutes_unit"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="duration_unit"), (SELECT id FROM structure_permissible_values WHERE value="hr" AND language_alias="hour_unit"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="duration_unit"), (SELECT id FROM structure_permissible_values WHERE value="d" AND language_alias="day_unit"), "3", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="duration_unit"), (SELECT id FROM structure_permissible_values WHERE value="m" AND language_alias="month_unit"), "4", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="duration_unit"), (SELECT id FROM structure_permissible_values WHERE value="yr" AND language_alias="year_unit"), "5", "1");

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("aliquot_internal_use_type", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'aliquot use and event types\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) VALUES ('aliquot use and event types', 1, 50);
SET @control_id = LAST_INSERT_ID();
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES ('internal use', 'Internal Use', 'Utilisation interne', '1', @control_id, NOW(), NOW(), 1, 1);
SET @last_id = LAST_INSERT_ID();
INSERT INTO `structure_permissible_values_customs_revs` (`use_as_input`, `value`, `en`, `fr`, `control_id`, `modified_by`, `id`, `version_created`) VALUES ('1', 'internal use', 'Internal Use', 'Utilisation interne', @control_id, 1, @last_id, NOW());

INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES ('at room temperature', 'At Room Temperature', 'À température pièce', '1', @control_id, NOW(), NOW(), 1, 1);
SET @last_id = LAST_INSERT_ID();
INSERT INTO `structure_permissible_values_customs_revs` (`use_as_input`, `value`, `en`, `fr`, `control_id`, `modified_by`, `id`, `version_created`) VALUES ('1', 'at room temperature', 'At Room Temperature', 'À température pièce', @control_id, 1, @last_id, NOW());

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotInternalUse', 'aliquot_internal_uses', 'type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='aliquot_internal_use_type') , '0', '', '', '', 'type', ''), 
('InventoryManagement', 'AliquotInternalUse', 'aliquot_internal_uses', 'duration', 'integer_positive',  NULL , '0', 'size=6', '', '', 'duration', ''), 
('InventoryManagement', 'AliquotInternalUse', 'aliquot_internal_uses', 'duration_unit', 'select',  (SELECT id FROM structure_value_domains WHERE domain_name='duration_unit') , '0', '', '', '', '', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='aliquotinternaluses'), (SELECT id FROM structure_fields WHERE `model`='AliquotInternalUse' AND `tablename`='aliquot_internal_uses' AND `field`='type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_internal_use_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '0', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='aliquotinternaluses'), (SELECT id FROM structure_fields WHERE `model`='AliquotInternalUse' AND `tablename`='aliquot_internal_uses' AND `field`='duration' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=6' AND `default`='' AND `language_help`='' AND `language_label`='duration' AND `language_tag`=''), '0', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='aliquotinternaluses'), (SELECT id FROM structure_fields WHERE `model`='AliquotInternalUse' AND `tablename`='aliquot_internal_uses' AND `field`='duration_unit' AND `type`='select' AND `structure_value_domain`  =(SELECT id FROM structure_value_domains WHERE domain_name='duration_unit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '0', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0');

INSERT INTO structure_validations(structure_field_id, rule) VALUES ((SELECT id FROM structure_fields WHERE `model`='AliquotInternalUse' AND `field`='type'), 'notEmpty');

REPLACE INTO i18n (id,en,fr) VALUES
("minutes_unit", "mn", "mn"),
("hour_unit", "hr", "hr"),
("day_unit", "d", "d"),
("month_unit", "m", "m"),
("year_unit", "yr", "yr"),
("duration", "Duration", "Durée");

DROP VIEW view_aliquot_uses;

CREATE VIEW `view_aliquot_uses` AS 

SELECT concat(`source`.`id`,1) AS `id`,
`aliq`.`id` AS `aliquot_master_id`,
'sample derivative creation' AS `use_definition`,
`samp`.`sample_code` AS `use_code`,
'' AS `use_details`,
`source`.`used_volume` AS `used_volume`,
`aliqc`.`volume_unit` AS `aliquot_volume_unit`,
`der`.`creation_datetime` AS `use_datetime`,
`der`.`creation_datetime_accuracy` AS `use_datetime_accuracy`,
'' AS `duration`,
'' AS `duration_unit`,
`der`.`creation_by` AS `used_by`,
`source`.`created` AS `created`,
concat('inventorymanagement/aliquot_masters/listAllSourceAliquots/',`samp`.`collection_id`,'/',`samp`.`id`) AS `detail_url`,
`samp2`.`id` AS `sample_master_id`,
`samp2`.`collection_id` AS `collection_id` 
FROM (((((`source_aliquots` `source` 
JOIN `sample_masters` `samp` ON (((`samp`.`id` = `source`.`sample_master_id`) AND (`samp`.`deleted` <> 1)))) 
JOIN `derivative_details` `der` ON ((`samp`.`id` = `der`.`sample_master_id`))) 
JOIN `aliquot_masters` `aliq` ON (((`aliq`.`id` = `source`.`aliquot_master_id`) AND (`aliq`.`deleted` <> 1)))) 
JOIN `aliquot_controls` `aliqc` ON ((`aliq`.`aliquot_control_id` = `aliqc`.`id`))) 
JOIN `sample_masters` `samp2` ON (((`samp2`.`id` = `aliq`.`sample_master_id`) AND (`samp`.`deleted` <> 1)))) WHERE (`source`.`deleted` <> 1) 

UNION ALL
 
SELECT concat(`realiq`.`id`,2) AS `id`,
`aliq`.`id` AS `aliquot_master_id`,
'realiquoted to' AS `use_definition`,
`child`.`barcode` AS `use_code`,
'' AS `use_details`,
`realiq`.`parent_used_volume` AS `used_volume`,
`aliqc`.`volume_unit` AS `aliquot_volume_unit`,
`realiq`.`realiquoting_datetime` AS `use_datetime`,
`realiq`.`realiquoting_datetime_accuracy` AS `use_datetime_accuracy`,
'' AS `duration`,
'' AS `duration_unit`,
`realiq`.`realiquoted_by` AS `used_by`,
`realiq`.`created` AS `created`,
concat('/inventorymanagement/aliquot_masters/listAllRealiquotedParents/',`child`.`collection_id`,'/',`child`.`sample_master_id`,'/',`child`.`id`) AS `detail_url`,
`samp`.`id` AS `sample_master_id`,
`samp`.`collection_id` AS `collection_id` 
FROM ((((`realiquotings` `realiq` 
JOIN `aliquot_masters` `aliq` ON (((`aliq`.`id` = `realiq`.`parent_aliquot_master_id`) AND (`aliq`.`deleted` <> 1)))) 
JOIN `aliquot_controls` `aliqc` ON ((`aliq`.`aliquot_control_id` = `aliqc`.`id`))) 
JOIN `aliquot_masters` `child` ON (((`child`.`id` = `realiq`.`child_aliquot_master_id`) AND (`child`.`deleted` <> 1)))) 
JOIN `sample_masters` `samp` ON (((`samp`.`id` = `aliq`.`sample_master_id`) AND (`samp`.`deleted` <> 1)))) 
WHERE (`realiq`.`deleted` <> 1) 

UNION ALL 

SELECT concat(`qc`.`id`,3) AS `id`,
`aliq`.`id` AS `aliquot_master_id`,
'quality control' AS `use_definition`,
`qc`.`qc_code` AS `use_code`,
'' AS `use_details`,
`qc`.`used_volume` AS `used_volume`,
`aliqc`.`volume_unit` AS `aliquot_volume_unit`,
`qc`.`date` AS `use_datetime`,
`qc`.`date_accuracy` AS `use_datetime_accuracy`,
'' AS `duration`,
'' AS `duration_unit`,
`qc`.`run_by` AS `used_by`,
`qc`.`created` AS `created`,
concat('/inventorymanagement/quality_ctrls/detail/',`aliq`.`collection_id`,'/',`aliq`.`sample_master_id`,'/',`qc`.`id`) AS `detail_url`,
`samp`.`id` AS `sample_master_id`,
`samp`.`collection_id` AS `collection_id` 
FROM (((`quality_ctrls` `qc` 
JOIN `aliquot_masters` `aliq` ON (((`aliq`.`id` = `qc`.`aliquot_master_id`) AND (`aliq`.`deleted` <> 1)))) 
JOIN `aliquot_controls` `aliqc` ON ((`aliq`.`aliquot_control_id` = `aliqc`.`id`))) 
JOIN `sample_masters` `samp` ON (((`samp`.`id` = `aliq`.`sample_master_id`) AND (`samp`.`deleted` <> 1)))) 
WHERE (`qc`.`deleted` <> 1)

UNION ALL 

SELECT concat(`item`.`id`,4) AS `id`,
`aliq`.`id` AS `aliquot_master_id`,
'aliquot shipment' AS `use_definition`,
`sh`.`shipment_code` AS `use_code`,
'' AS `use_details`,
'' AS `used_volume`,
'' AS `aliquot_volume_unit`,
`sh`.`datetime_shipped` AS `use_datetime`,
`sh`.`datetime_shipped_accuracy` AS `use_datetime_accuracy`,
'' AS `duration`,
'' AS `duration_unit`,
`sh`.`shipped_by` AS `used_by`,
`sh`.`created` AS `created`,
concat('/order/shipments/detail/',`sh`.`order_id`,'/',`sh`.`id`) AS `detail_url`,
`samp`.`id` AS `sample_master_id`,
`samp`.`collection_id` AS `collection_id` 
FROM (((`order_items` `item` 
JOIN `aliquot_masters` `aliq` ON (((`aliq`.`id` = `item`.`aliquot_master_id`) AND (`aliq`.`deleted` <> 1)))) 
JOIN `shipments` `sh` ON (((`sh`.`id` = `item`.`shipment_id`) AND (`sh`.`deleted` <> 1)))) 
JOIN `sample_masters` `samp` ON (((`samp`.`id` = `aliq`.`sample_master_id`) AND (`samp`.`deleted` <> 1)))) 
WHERE (`item`.`deleted` <> 1) 

UNION ALL 

SELECT concat(`alr`.`id`,5) AS `id`,
`aliq`.`id` AS `aliquot_master_id`,
'specimen review' AS `use_definition`,
`spr`.`review_code` AS `use_code`,
'' AS `use_details`,
'' AS `used_volume`,
'' AS `aliquot_volume_unit`,
`spr`.`review_date` AS `use_datetime`,
`spr`.`review_date_accuracy` AS `use_datetime_accuracy`,
'' AS `duration`,
'' AS `duration_unit`,
'' AS `used_by`,
`alr`.`created` AS `created`,
concat('/inventorymanagement/specimen_reviews/detail/',`aliq`.`collection_id`,'/',`aliq`.`sample_master_id`,'/',`spr`.`id`) AS `detail_url`,
`samp`.`id` AS `sample_master_id`,
`samp`.`collection_id` AS `collection_id` 
FROM (((`aliquot_review_masters` `alr` 
JOIN `aliquot_masters` `aliq` ON (((`aliq`.`id` = `alr`.`aliquot_master_id`) AND (`aliq`.`deleted` <> 1)))) 
JOIN `specimen_review_masters` `spr` ON (((`spr`.`id` = `alr`.`specimen_review_master_id`) AND (`spr`.`deleted` <> 1)))) 
JOIN `sample_masters` `samp` ON (((`samp`.`id` = `aliq`.`sample_master_id`) AND (`samp`.`deleted` <> 1)))) 
WHERE (`alr`.`deleted` <> 1) 

UNION ALL 

SELECT concat(`aluse`.`id`,6) AS `id`,
`aliq`.`id` AS `aliquot_master_id`,
`aluse`.`type` AS `use_definition`,
`aluse`.`use_code` AS `use_code`,
`aluse`.`use_details` AS `use_details`,
`aluse`.`used_volume` AS `used_volume`,
`aliqc`.`volume_unit` AS `aliquot_volume_unit`,
`aluse`.`use_datetime` AS `use_datetime`,
`aluse`.`use_datetime_accuracy` AS `use_datetime_accuracy`,
`aluse`.`duration` AS `duration`,
`aluse`.`duration_unit` AS `duration_unit`,
`aluse`.`used_by` AS `used_by`,
`aluse`.`created` AS `created`,
concat('/inventorymanagement/aliquot_masters/detailAliquotInternalUse/',`aliq`.`id`,'/',`aluse`.`id`) AS `detail_url`,
`samp`.`id` AS `sample_master_id`,
`samp`.`collection_id` AS `collection_id` 
FROM (((`aliquot_internal_uses` `aluse` 
JOIN `aliquot_masters` `aliq` ON (((`aliq`.`id` = `aluse`.`aliquot_master_id`) AND (`aliq`.`deleted` <> 1)))) 
JOIN `aliquot_controls` `aliqc` ON ((`aliq`.`aliquot_control_id` = `aliqc`.`id`))) 
JOIN `sample_masters` `samp` ON (((`samp`.`id` = `aliq`.`sample_master_id`) AND (`samp`.`deleted` <> 1)))) 
WHERE (`aluse`.`deleted` <> 1);

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewAliquotUse', 'view_aliquot_uses', 'duration', 'integer_positive',  NULL , '0', 'size=6', '', '', 'duration', ''), 
('InventoryManagement', 'ViewAliquotUse', 'view_aliquot_uses', 'duration_unit', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='duration_unit') , '0', '', '', '', '', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='viewaliquotuses'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquotUse' AND `tablename`='view_aliquot_uses' AND `field`='duration' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=6' AND `default`='' AND `language_help`='' AND `language_label`='duration' AND `language_tag`=''), '0', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='viewaliquotuses'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquotUse' AND `tablename`='view_aliquot_uses' AND `field`='duration_unit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='duration_unit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '0', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

DELETE FROM structure_value_domains_permissible_values WHERE structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="aliquot_use_definition");
UPDATE structure_value_domains SET source = "InventoryManagement.ViewAliquotUse::getUseDefinitions" WHERE domain_name = 'aliquot_use_definition';

UPDATE structure_fields SET  `language_label`='use and/or event' WHERE model='ViewAliquotUse' AND field='use_definition';
UPDATE datamart_structures SET display_name = 'aliquot uses and events' WHERE model = 'ViewAliquotUse';

REPLACE INTO i18n (id,en,fr) 
VALUES
('history','History','Historique'),
('use and/or event','Use/Event','Utilisation/événement'),
('aliquot uses and events','Aliquot Uses/Events','Utilisations/événements d''aliquot'),
('uses and events','Uses/Events','Utilisations/événements'),
('aliquot shipment','Aliquot Shipment nbr','Numéro d''envoi d''aliquots'),
('add uses/events','Add Uses/Events','Ajouter utilisations/événements'),
('use/event creation','Use/Event Creation','Cération utilisation/événement'),
('aliquot use/event','Aliquot Use/Event','Utilisation/événement d''aliquot');

-- ---------------------------------------------------------------------------
-- TNM Clean Up
-- ---------------------------------------------------------------------------

-- small intestine
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', '', 'tumour_grade', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='histologic_grade') , '0', '', '', '', 'histologic grade', '');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='tumour_grade' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='histologic_grade') ) WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_cap_report_smintestines') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='tumour_grade' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='histologic_grade_c') AND `flag_confidential`='0');

-- perihilar bile duct
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', '', 'tumour_grade', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='histologic_grade_pbd') , '0', '', '', '', 'histologic grade', '');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='tumour_grade' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='histologic_grade_pbd') ) WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_cap_report_perihilarbileducts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='tumour_grade' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='histologic_grade_c') AND `flag_confidential`='0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', '', 'path_tstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='path_tstage_pbd') , '0', '', '', '', 'path tstage', ''), 
('ClinicalAnnotation', 'EventDetail', '', 'path_nstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='path_nstage_pbd') , '0', '', '', '', 'path nstage', ''), 
('ClinicalAnnotation', 'EventDetail', '', 'path_mstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='path_mstage_pbd') , '0', '', '', '', 'path mstage', '');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='path_tstage' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='path_tstage_pbd') ) 
WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_cap_report_perihilarbileducts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='path_tstage' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='path_tstage_sm') AND `flag_confidential`='0');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='path_nstage' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='path_nstage_pbd') ) 
WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_cap_report_perihilarbileducts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='path_nstage' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='path_nstage_sm') AND `flag_confidential`='0');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='path_mstage' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='path_mstage_pbd') ) 
WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_cap_report_perihilarbileducts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='path_mstage' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='path_mstage_sm') AND `flag_confidential`='0');

-- pancreas exo
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', '', 'tumour_grade', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='histologic_grade_pex') , '0', '', '', '', 'histologic grade', '');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='tumour_grade' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='histologic_grade_pex') ) WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_cap_report_pancreasexos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='tumour_grade' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='histologic_grade_c') AND `flag_confidential`='0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', '', 'path_tstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='path_tstage_pex') , '0', '', '', '', 'path tstage', ''), 
('ClinicalAnnotation', 'EventDetail', '', 'path_nstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='path_nstage_pex') , '0', '', '', '', 'path nstage', ''), 
('ClinicalAnnotation', 'EventDetail', '', 'path_mstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='path_mstage_pex') , '0', '', '', '', 'path mstage', '');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='path_tstage' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='path_tstage_pex') ) 
WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_cap_report_pancreasexos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='path_tstage' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='path_tstage_sm') AND `flag_confidential`='0');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='path_nstage' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='path_nstage_pex') ) 
WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_cap_report_pancreasexos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='path_nstage' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='path_nstage_sm') AND `flag_confidential`='0');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='path_mstage' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='path_mstage_pex') ) 
WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_cap_report_pancreasexos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='path_mstage' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='path_mstage_sm') AND `flag_confidential`='0');
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="histologic_grade_pex"), (SELECT id FROM structure_permissible_values WHERE value="g2" AND language_alias="g2: moderately differentiated"), "4", "1");

-- pancreas endo
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', '', 'path_tstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='path_tstage_pe') , '0', '', '', '', 'path tstage', ''), 
('ClinicalAnnotation', 'EventDetail', '', 'path_nstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='path_nstage_pe') , '0', '', '', '', 'path nstage', ''), 
('ClinicalAnnotation', 'EventDetail', '', 'path_mstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='path_mstage_pe') , '0', '', '', '', 'path mstage', '');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='path_tstage' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='path_tstage_pe') ) 
WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_cap_report_pancreasendos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='path_tstage' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='path_tstage_sm') AND `flag_confidential`='0');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='path_nstage' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='path_nstage_pe') ) 
WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_cap_report_pancreasendos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='path_nstage' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='path_nstage_sm') AND `flag_confidential`='0');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='path_mstage' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='path_mstage_pe') ) 
WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_cap_report_pancreasendos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='path_mstage' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='path_mstage_sm') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_cap_report_pancreasendos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_cap_report_pancreasendos' AND `field`='carcinoma_precision' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='panc_endo_histo_type_carcinoma_precision') AND `flag_confidential`='0');
-- intra hepato bile duct
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', '', 'tumour_grade', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='histologic_grade_ibd') , '0', '', '', '', 'histologic grade', '');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='tumour_grade' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='histologic_grade_ibd') ) WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_cap_report_intrahepbileducts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='tumour_grade' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='histologic_grade_c') AND `flag_confidential`='0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', '', 'path_tstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='path_tstage_ibd') , '0', '', '', '', 'path tstage', ''), 
('ClinicalAnnotation', 'EventDetail', '', 'path_nstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='path_nstage_ibd') , '0', '', '', '', 'path nstage', ''), 
('ClinicalAnnotation', 'EventDetail', '', 'path_mstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='path_mstage_ibd') , '0', '', '', '', 'path mstage', '');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='path_tstage' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='path_tstage_ibd') ) 
WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_cap_report_intrahepbileducts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='path_tstage' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='path_tstage_sm') AND `flag_confidential`='0');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='path_nstage' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='path_nstage_ibd') ) 
WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_cap_report_intrahepbileducts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='path_nstage' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='path_nstage_sm') AND `flag_confidential`='0');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='path_mstage' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='path_mstage_ibd') ) 
WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_cap_report_intrahepbileducts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='path_mstage' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='path_mstage_sm') AND `flag_confidential`='0');

-- hepatocellular carcinomas
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', '', 'tumour_grade', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='histologic_grade_hc') , '0', '', '', '', 'histologic grade', '');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='tumour_grade' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='histologic_grade_hc') ) WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_cap_report_hepatocellular_carcinomas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='tumour_grade' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='histologic_grade_c') AND `flag_confidential`='0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', '', 'path_tstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='path_tstage_hc') , '0', '', '', '', 'path tstage', ''), 
('ClinicalAnnotation', 'EventDetail', '', 'path_nstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='path_nstage_hc') , '0', '', '', '', 'path nstage', ''), 
('ClinicalAnnotation', 'EventDetail', '', 'path_mstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='path_mstage_hc') , '0', '', '', '', 'path mstage', '');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='path_tstage' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='path_tstage_hc') ) 
WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_cap_report_hepatocellular_carcinomas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='path_tstage' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='path_tstage_sm') AND `flag_confidential`='0');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='path_nstage' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='path_nstage_hc') ) 
WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_cap_report_hepatocellular_carcinomas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='path_nstage' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='path_nstage_sm') AND `flag_confidential`='0');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='path_mstage' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='path_mstage_hc') ) 
WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_cap_report_hepatocellular_carcinomas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='path_mstage' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='path_mstage_sm') AND `flag_confidential`='0');

-- gallbladders
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', '', 'tumour_grade', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='histologic_grade_gb') , '0', '', '', '', 'histologic grade', '');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='tumour_grade' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='histologic_grade_gb') ) WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_cap_report_gallbladders') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='tumour_grade' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='histologic_grade_c') AND `flag_confidential`='0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', '', 'path_tstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='path_tstage_gb') , '0', '', '', '', 'path tstage', ''), 
('ClinicalAnnotation', 'EventDetail', '', 'path_nstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='path_nstage_gb') , '0', '', '', '', 'path nstage', ''), 
('ClinicalAnnotation', 'EventDetail', '', 'path_mstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='path_mstage_gb') , '0', '', '', '', 'path mstage', '');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='path_tstage' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='path_tstage_gb') ) 
WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_cap_report_gallbladders') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='path_tstage' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='path_tstage_sm') AND `flag_confidential`='0');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='path_nstage' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='path_nstage_gb') ) 
WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_cap_report_gallbladders') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='path_nstage' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='path_nstage_sm') AND `flag_confidential`='0');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='path_mstage' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='path_mstage_gb') ) 
WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_cap_report_gallbladders') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='path_mstage' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='path_mstage_sm') AND `flag_confidential`='0');

-- distal ex bile ducts
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', '', 'tumour_grade', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='histologic_grade_dbd') , '0', '', '', '', 'histologic grade', '');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='tumour_grade' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='histologic_grade_dbd') ) WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_cap_report_distalexbileducts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='tumour_grade' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='histologic_grade_c') AND `flag_confidential`='0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', '', 'path_tstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='path_tstage_dbd') , '0', '', '', '', 'path tstage', ''), 
('ClinicalAnnotation', 'EventDetail', '', 'path_nstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='path_nstage_dbd') , '0', '', '', '', 'path nstage', ''), 
('ClinicalAnnotation', 'EventDetail', '', 'path_mstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='path_mstage_dbd') , '0', '', '', '', 'path mstage', '');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='path_tstage' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='path_tstage_dbd') ) 
WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_cap_report_distalexbileducts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='path_tstage' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='path_tstage_sm') AND `flag_confidential`='0');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='path_nstage' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='path_nstage_dbd') ) 
WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_cap_report_distalexbileducts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='path_nstage' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='path_nstage_sm') AND `flag_confidential`='0');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='path_mstage' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='path_mstage_dbd') ) 
WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_cap_report_distalexbileducts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='path_mstage' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='path_mstage_sm') AND `flag_confidential`='0');

-- colon_biopsies

-- ampullas
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', '', 'tumour_grade', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='histologic_grade_a') , '0', '', '', '', 'histologic grade', '');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='tumour_grade' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='histologic_grade_a') ) WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_cap_report_ampullas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='tumour_grade' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='histologic_grade_c') AND `flag_confidential`='0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', '', 'path_tstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='path_tstage_a') , '0', '', '', '', 'path tstage', ''), 
('ClinicalAnnotation', 'EventDetail', '', 'path_nstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='path_nstage_a') , '0', '', '', '', 'path nstage', ''), 
('ClinicalAnnotation', 'EventDetail', '', 'path_mstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='path_mstage_a') , '0', '', '', '', 'path mstage', '');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='path_tstage' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='path_tstage_a') ) 
WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_cap_report_ampullas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='path_tstage' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='path_tstage_sm') AND `flag_confidential`='0');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='path_nstage' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='path_nstage_a') ) 
WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_cap_report_ampullas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='path_nstage' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='path_nstage_sm') AND `flag_confidential`='0');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='path_mstage' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='path_mstage_a') ) 
WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_cap_report_ampullas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='path_mstage' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='path_mstage_sm') AND `flag_confidential`='0');

-- ed_cap_report_colon_rectum_resections
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', '', 'tumour_grade', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='histologic_grade_cr') , '0', '', '', '', 'histologic grade', '');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='tumour_grade' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='histologic_grade_cr') ) WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_cap_report_colon_rectum_resections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='tumour_grade' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='histologic_grade_c') AND `flag_confidential`='0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', '', 'path_tstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='path_tstage_cr') , '0', '', '', '', 'path tstage', ''), 
('ClinicalAnnotation', 'EventDetail', '', 'path_nstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='path_nstage_cr') , '0', '', '', '', 'path nstage', ''), 
('ClinicalAnnotation', 'EventDetail', '', 'path_mstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='path_mstage_cr') , '0', '', '', '', 'path mstage', '');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='path_tstage' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='path_tstage_cr') ) 
WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_cap_report_colon_rectum_resections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='path_tstage' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='path_tstage_sm') AND `flag_confidential`='0');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='path_nstage' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='path_nstage_cr') ) 
WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_cap_report_colon_rectum_resections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='path_nstage' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='path_nstage_sm') AND `flag_confidential`='0');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='path_mstage' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='path_mstage_cr') ) 
WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_cap_report_colon_rectum_resections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='path_mstage' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='path_mstage_sm') AND `flag_confidential`='0');
UPDATE structure_permissible_values SET value = 'ptis.' WHERE language_alias = "ptis: carcinoma in situ, invasion of lamina propria";

-- ---------------------------------------------------------------------------
-- END TNM Clean Up
-- ---------------------------------------------------------------------------

INSERT INTO `realiquoting_controls` (`parent_aliquot_control_id`, `child_aliquot_control_id`, `flag_active`, `lab_book_control_id`) VALUES ((SELECT ac.id FROM aliquot_controls ac INNER JOIN sample_controls sc ON sc.id = ac.sample_control_id WHERE ac.aliquot_type = 'block' AND sc.sample_type = 'tissue'), (SELECT ac.id FROM aliquot_controls ac INNER JOIN sample_controls sc ON sc.id = ac.sample_control_id WHERE ac.aliquot_type = 'tube' AND sc.sample_type = 'tissue'), 1, NULL);

UPDATE structure_fields SET language_help = 'new_participants_nbr_help' WHERE plugin = 'Datamart' AND field = 'new_participants_nbr';
UPDATE structure_fields SET language_help = 'obtained_consents_nbr_help' WHERE plugin = 'Datamart' AND field = 'obtained_consents_nbr';
UPDATE structure_fields SET language_help = 'new_collections_nbr_help' WHERE plugin = 'Datamart' AND field = 'new_collections_nbr';

INSERT IGNORE INTO i18n (id,en,fr)
VALUES 
('new_participants_nbr_help', 
'Number of participants created into the system during the defined period (based on the dates of the participants creation into the system).',
'Nombre de participants créés dans le système pendant la période définie (selon les dates de création des patients dans le système).'),
('obtained_consents_nbr_help',
'Number of consents having a signature date included into the defined period.',
'Nombre de consentements ayant une date de signature inclue dans la période définie.'),
('new_collections_nbr_help',
'Number of participants linked to at least one collection with a collection date included into the defined period.',
'Nombre de participants liés à au moins une collection ayant une date de collection inclue dans la période définie.');

UPDATE structure_fields SET language_help = 'created_samples_nbr_help' WHERE plugin = 'Datamart' AND field = 'created_samples_nbr';
UPDATE structure_fields SET language_help = 'matching_participant_number_help' WHERE plugin = 'Datamart' AND field = 'matching_participant_number';

INSERT IGNORE INTO i18n (id,en,fr)
VALUES 
('created_samples_nbr_help', 
'Number of either specimens collected during the defined period or derivatives created during this same period.',
'Nombre de spécimens récoltés au cours de la période définie ou de dérivés créés au cours de cette même période.'),
('matching_participant_number_help', 
'Number of participants of the samples included into the count of the previous column.',
'Nombre de participants des échantillons inclus dans le décompte de la colonne précédente.');

UPDATE i18n SET id = 'report_3_name' WHERE id = 'bank activity report';
UPDATE i18n SET id = 'report_3_desc' WHERE id = 'number of new participants created, consents obtained and participants having samples collected';
UPDATE datamart_reports SET name = 'report_3_name', description = 'report_3_desc' WHERE id = 3;

UPDATE i18n SET id = 'report_4_name' WHERE id = 'specimens collection/derivatives creation';
UPDATE datamart_reports SET name = 'report_4_name', description = 'report_4_desc' WHERE id = 4;

REPLACE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('report_3_desc', '', 'Number of created participants, obtained consents and participants having samples collected.', 'Nombre de participants créés, de consentements obtenus et de participants ayant des échantillons collectés.'),
('report_4_desc', '', 'Specimens and derivatives count plus the count of matching participants.', 'Le compte des spécimens et dérivés ainsi que le compte des participants correspondants.'),
('report_4_name', '', 'Specimens Collection/Derivatives Creation', 'Collections des spécimens/Creations des dérivés');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'bank_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='banks') , '0', '', '', '', 'bank', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='report_datetime_range_definition'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='bank_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='bank' AND `language_tag`=''), '0', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

UPDATE i18n SET id = 'report_5_name' WHERE id = 'bank activity report (per period)';
UPDATE datamart_reports SET name = 'report_5_name', description = 'report_3_desc' WHERE id = 5;

-- ------------------------------------------------------
-- report for ctrnet catalogue update
-- ------------------------------------------------------

INSERT INTO `datamart_reports` (`id`, `name`, `description`, `form_alias_for_search`, `form_alias_for_results`, `form_type_for_results`, `function`, `flag_active`) VALUES
(null, 'report_ctrnet_catalogue_name', 'report_ctrnet_catalogue_desc', 'ctrnet_calatogue_submission_file_params', 'ctrnet_calatogue_submission_file', 'index', 'ctrnetCatalogueSubmissionFile', 1);

INSERT INTO structures(`alias`) VALUES ('ctrnet_calatogue_submission_file');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'sample_type', 'input',  NULL , '0', '', '', '', 'sample type', ''), 
('Datamart', '0', '', 'cases_nbr', 'input',  NULL , '0', '', '', '', 'cases number', ''), 
('Datamart', '0', '', 'aliquots_nbr', 'input',  NULL , '0', '', '', '', 'aliquots number', ''), 
('Datamart', '0', '', 'notes', 'input',  NULL , '0', '', '', '', '', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ctrnet_calatogue_submission_file'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='sample_type'), '0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ctrnet_calatogue_submission_file'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='cases_nbr'), '0', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ctrnet_calatogue_submission_file'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='aliquots_nbr'), '0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ctrnet_calatogue_submission_file'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='notes'), '0', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0');

INSERT INTO structures(`alias`) VALUES ('ctrnet_calatogue_submission_file_params');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'include_core_and_slide', 'checkbox',  (SELECT id FROM structure_value_domains WHERE domain_name = 'yes_no_checkbox') , '0', '', '', '', 'include core and slide in the count', ''), 
('Datamart', '0', '', 'include_whatman_paper', 'checkbox',  (SELECT id FROM structure_value_domains WHERE domain_name = 'yes_no_checkbox') , '0', '', '', '', 'include whatman paper in the count', ''), 
('Datamart', '0', '', 'detail_other_count', 'checkbox',  (SELECT id FROM structure_value_domains WHERE domain_name = 'yes_no_checkbox') , '0', '', '', '', 'detail other count', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ctrnet_calatogue_submission_file_params'), (SELECT id FROM structure_fields WHERE `plugin`='Datamart' AND `field`='include_core_and_slide'), '0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='ctrnet_calatogue_submission_file_params'), (SELECT id FROM structure_fields WHERE `plugin`='Datamart' AND `field`='include_whatman_paper'), '0', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='ctrnet_calatogue_submission_file_params'), (SELECT id FROM structure_fields WHERE `plugin`='Datamart' AND `field`='detail_other_count'), '0', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='ctrnet_calatogue_submission_file_params'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='bank_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='bank' AND `language_tag`=''), '0', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

UPDATE structure_fields SET  `language_label`='notes' WHERE model='0' AND tablename='' AND field='notes' AND `type`='input' AND structure_value_domain  IS NULL ;

INSERT IGNORE INTO i18n (id,en,fr) VALUES 
('report_ctrnet_catalogue_name','CTRNet catalogue', 'Catalogue CTRNet'),
('report_ctrnet_catalogue_desc','Data creation for CTRNet catalogue.', 'Génération des données pour le catalogue de CTRNet.'),
('cases number','Cases Number','Nombre de cas'),
('aliquots number','Aliquots Number','Nombre d''aliquots'),
('include core and slide in the count','Include core and slide in the count','Inclure les lames et les cores dans le décompte'),
('include whatman paper in the count','Include whatman paper in the count','Inclure les papier Whatman dans le décompte'),
('detail other count','Detail ''Other'' Count','Détailler ''Autre'' décompte'),
('FFPE','FFPE','FFPE'),
('total','Total','Total');

UPDATE versions SET permissions_regenerated = 0;

