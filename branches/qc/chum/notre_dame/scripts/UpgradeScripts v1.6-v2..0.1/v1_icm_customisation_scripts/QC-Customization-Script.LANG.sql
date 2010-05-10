-- ------------------------------------------------------------------------------------------------
--
-- VERSION: BEFORE PROD
--
-- ------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- CTRApp - clinical annotation 
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
--
-- GENERAL: MENU
--
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
--
-- PARTICIPANTS 
--
-- ---------------------------------------------------------------------

-- 
-- Table - `i18n`
-- 

-- Action: DELETE
-- Comments:

DELETE FROM `i18n`
WHERE `id` IN (
'identity',
'first name',
'last name',
'tumour bank number',
'sardo data',
'sardo participant id',
'last import date',
'last visit date',
'approximative last visit date',
'approximative date',
'sardo numero dossier',

'the sardo participant data has already been imported from SARDO, the sardo id can not be changed',

'the sardo participant id has already been recorded for another participant',

'approximative death date'
);

-- Action: INSERT
-- Comments:

INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES 
('identity', 'global', 'Identity', 'Identit&eacute;'),
('first name', 'global', 'First Name', 'Pr&eacute;nom'),
('the sardo participant data has already been imported from SARDO, the sardo id can not be changed', 'global', 'The sardo participant data has already been imported from SARDO: the sardo id can not be changed!', 'Les donn&eacute;es SARDO du participant ont d&eacute;j&agrave; &eacute;t&eacute; import&eacute;: l''ID ne peut pas &ecirc;tre modifi&eacute;!'),
('last name', 'global', 'Last Name', 'Nom'),
('tumour bank number', 'global', 'Participant Code', 'Code du participant'),
('sardo data', 'global', 'SARDO Data', 'Donn&eacute;es SARDO'),
('sardo participant id', 'global', 'SARDO Participant ID', 'ID du participant dans SARDO'), 
('sardo numero dossier', 'global', 'SARDO Hospital Participant Number', 'Num&eacute;ro de dossier hospitalier ''SARDO'''), 
('last import date', 'global', 'Last Import Date', 'Date du dernier import'),
('last visit date', 'global', 'Last Visit Date', 'Date de derni&egrave;re visite'),
('approximative last visit date', 'global', 'Approximative Last Visit Date', 'Date de derni&egrave;re visite approximative'),
('approximative date', 'global', 'Approximative Date', 'Date approximative'),
('the sardo participant id has already been recorded for another participant', 'global', 'The sardo participant id has already been recorded for another participant!', 'L''identifiant du participant dans SARDO a d&eacutej&agrave; &eacute;t&eacute; associ&eacute; &agrave; un autre participant!'),
('approximative death date', 'global', 'Approximative Death Date', 'Date d&eacute;c&egrave;s approximative');

-- ---------------------------------------------------------------------
--
-- CONSENTS
--
-- ---------------------------------------------------------------------

-- 
-- Table - `i18n`
-- 

-- Action: DELETE
-- Comments:

DELETE FROM `i18n`
WHERE `id` IN (
'consent_type',
'consent_version_date',

'biological material',

'consent data',

'allow blood and urine collection for follow-up',
'allow to be contacted for additional data',
'accept to complete questionnaire',
'inform significant discovery',
'inform of discoveries on other diseases',

'stop followup',
'stop followup date',
'stop questionnaire',
'stop questionnaire date',

'frsq', 
'procure',
'CHUM - Prostate',
'unknwon',

'2008-05-04',
'2007-10-25',
'2007-06-05',
'2007-05-23',
'2007-05-15',
'2007-05-05',
'2007-05-04',
'2007-04-04',
'2007-03-12',
'2006-08-05',
'2006-06-09',
'2006-05-26',
'2006-05-08',
'2006-05-07',
'2006-05-06',
'2006-02-26',
'2006-02-09',
'2006-02-01',
'2006-01-10',
'2005-10-27',
'2005-10-25',
'2005-07-27',
'2005-06-26',
'2005-05-26',
'2005-03-26',
'2005-01-26',
'2005-01-05',
'2004-12-14',
'2004-09-14',
'2004-07-15',
'2004-03-01',
'2003-12-03',
'2002-09-13',
'2002-04-08',
'2001-03-30',
'2000-04-20',

'language_fr',
'language_en'
);

-- Action: INSERT
-- Comments:

INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES 
('consent_type', 'global', 'Form Type', 'Type du formulaire'),
('consent_version_date', 'global', 'Version Date', 'Date de la version'),

('biological material', 'global', 'Biological Material', 'Mat&eacute;riel Biologique'),

('consent data', 'global', 'Consent Data', 'Donn&eacute;es du consentement'),

('allow blood and urine collection for follow-up', 'global', 'Allow blood and urine collection for follow-up', 'Authorise la collection d''urine et de sang pour le suivi'),
('allow to be contacted for additional data', 'global', 'Allow to be contacted for additional data', 'Accepte d''&ecirc;tre contact&eacute; pour d''autres informations'),
('accept to complete questionnaire', 'global', 'Accept to complete questionnaire', 'Accepte de compl&eacute;ter le questionnaire'),
('inform significant discovery', 'global', 'Inform of disease significant discovery', 'Informer des d&eacute;couvertes importantes sur la maladie'),
('inform of discoveries on other diseases', 'global', 'Inform of discoveries on other diseases', 'Informer des d&eacute;couvertes importantes sur d''autres maladies'),

('frsq', 'global', 'FRSQ', 'FRSQ'),
('procure', 'global', 'PROCURE', 'PROCURE'),
('CHUM - Prostate', 'global', 'CHUM - Prostate', 'CHUM - Prostate'),
('unknwon', 'global', 'Unknwon', 'Inconnu'),

('stop followup', 'global', 'Stop Followup', 'Arr&ecirc;t du suivi'),
('stop followup date', 'global', 'Date', 'Date'),
('stop questionnaire', 'global', 'Stop Questionnaire', 'Arr&ecirc;t du questionnaire'),
('stop questionnaire date', 'global', 'Date', 'Date'),

('2008-05-04', 'global', '2008-05-04', '2008-05-04'),
('2007-10-25', 'global', '2007-10-25', '2007-10-25'),
('2007-06-05', 'global', '2007-06-05', '2007-06-05'),
('2007-05-23', 'global', '2007-05-23', '2007-05-23'),
('2007-05-15', 'global', '2007-05-15', '2007-05-15'),
('2007-05-05', 'global', '2007-05-05', '2007-05-05'),
('2007-05-04', 'global', '2007-05-04', '2007-05-04'),
('2007-04-04', 'global', '2007-04-04', '2007-04-04'),
('2007-03-12', 'global', '2007-03-12', '2007-03-12'),
('2006-08-05', 'global', '2006-08-05', '2006-08-05'),
('2006-06-09', 'global', '2006-06-09', '2006-06-09'),
('2006-05-26', 'global', '2006-05-26', '2006-05-26'),
('2006-05-08', 'global', '2006-05-08', '2006-05-08'),
('2006-05-07', 'global', '2006-05-07', '2006-05-07'),
('2006-05-06', 'global', '2006-05-06', '2006-05-06'),
('2006-02-26', 'global', '2006-02-26', '2006-02-26'),
('2006-02-09', 'global', '2006-02-09', '2006-02-09'),
('2006-02-01', 'global', '2006-02-01', '2006-02-01'),
('2006-01-10', 'global', '2006-01-10', '2006-01-10'),
('2005-10-27', 'global', '2005-10-27', '2005-10-27'),
('2005-10-25', 'global', '2005-10-25', '2005-10-25'),
('2005-07-27', 'global', '2005-07-27', '2005-07-27'),
('2005-06-26', 'global', '2005-06-26', '2005-06-26'),
('2005-05-26', 'global', '2005-05-26', '2005-05-26'),
('2005-03-26', 'global', '2005-03-26', '2005-03-26'),
('2005-01-26', 'global', '2005-01-26', '2005-01-26'),
('2005-01-05', 'global', '2005-01-05', '2005-01-05'),
('2004-12-14', 'global', '2004-12-14', '2004-12-14'),
('2004-09-14', 'global', '2004-09-14', '2004-09-14'),
('2004-07-15', 'global', '2004-07-15', '2004-07-15'),
('2004-03-01', 'global', '2004-03-01', '2004-03-01'),
('2003-12-03', 'global', '2003-12-03', '2003-12-03'),
('2002-09-13', 'global', '2002-09-13', '2002-09-13'),
('2002-04-08', 'global', '2002-04-08', '2002-04-08'),
('2001-03-30', 'global', '2001-03-30', '2001-03-30'),
('2000-04-20', 'global', '2000-04-20', '2000-04-20'),

('language_fr', 'global', 'fr', 'fr'),
('language_en', 'global', 'eng', 'ang');

-- ---------------------------------------------------------------------
--
-- DIAGNOSIS
--
-- ---------------------------------------------------------------------

-- 
-- Table - `i18n`
-- 

-- Action: DELETE
-- Comments:

DELETE FROM `i18n`
WHERE `id` IN (
'ICD-O grade',
'sardo diagnosis id',
'the sardo diagnosis id has already been recorded for another diagnosis or family history',
'survival',
'diag is cause of death',
'month',
'bilateral',
'unilateral'
);

-- Action: INSERT
-- Comments:

INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES
('survival', 'global', 'Survival', 'Survie'),
('diag is cause of death', 'global', 'Cause of death', 'Censure'),

('month', 'global', 'Months', 'Mois'),

('bilateral', 'global', 'Bilateral', 'Bilat&eacute;rale'),
('unilateral', 'global', 'Unilateral', 'Unilat&eacute;rale'),

('ICD-O grade', 'global', 'ICD-O Grade', 'Grade ICD-O'),
('sardo diagnosis id', 'global', 'SARDO Diagnosis ID', 'ID du diagnostic dans SARDO'),
('the sardo diagnosis id has already been recorded for another diagnosis or family history', 'global', 'The sardo diagnosis id has already been recorded for another diagnosis or family history!', 'L''identifiant du diagnostic dans SARDO a d&eacutej&agrave; &eacute;t&eacute; associ&eacute; &agrave; un autre diagnostic ou un autre ant&eacute;c&eacute;dent familial!');

-- ---------------------------------------------------------------------
--
-- FAMILY HISTORIES
--
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
--
-- REPRODUCTIVE HISTORIES
--
-- ---------------------------------------------------------------------

DELETE FROM `i18n`
WHERE `id` IN (
'aborta'
);

INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES
('aborta', 'global', 'Aborta', 'Aborta');

-- ---------------------------------------------------------------------
--
-- CONTACT
--
-- ---------------------------------------------------------------------

-- 
-- Table - `i18n`
-- 

-- Action: DELETE
-- Comments:

DELETE FROM `i18n`
WHERE `id` IN (
'other contact',
'type precision',
'street nbr'
);

-- Action: INSERT
-- Comments:

INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES 
('other contact', 'global', 'Other Contact', 'Autre contact'),
('type precision', 'global', 'Type Precision', 'Description'),
('street nbr', 'global', 'Street Nbr', 'Num&eacute;ro');

-- ---------------------------------------------------------------------
--
-- MESSAGE
--
-- ---------------------------------------------------------------------

-- 
-- Table - `i18n`
-- 

-- Action: DELETE
-- Comments:

DELETE FROM `i18n`
WHERE `id` IN (
'sardo note id'
);

-- Action: INSERT
-- Comments:

INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES 
('sardo note id', 'global', 'SARDO Note ID ', 'ID de la note dans SARDO');

-- ---------------------------------------------------------------------
--
-- IDENTIFICATION
--
-- ---------------------------------------------------------------------

-- Action: DELETE
-- Comments:

DELETE FROM `i18n`
WHERE `id` IN (
'ramq nbr',
'hotel-dieu id nbr',
'notre-dame id nbr',
'saint-luc id nbr',
'other center id nbr',
'breast bank no lab',
'ovary bank no lab',
'prostate bank no lab',
'old bank no lab',
'code-barre'
);

-- Action: INSERT
-- Comments:

INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES 
('ramq nbr', 'global', 'RAMQ Number', 'Num&eacute;ro de RAMQ'), 
('hotel-dieu id nbr', 'global', 'H&ocirc;tel-Dieu Patient Number', 'Num&eacute;ro de dossier ''H&ocirc;tel-Dieu'''), 
('notre-dame id nbr', 'global', 'Notre-Dame Patient Number', 'Num&eacute;ro de dossier ''Notre-Dame'''), 
('saint-luc id nbr', 'global', 'Saint-Luc Patient Number', 'Num&eacute;ro de dossier ''Saint-Luc'''), 
('other center id nbr', 'global', 'Other Center Patient Number', 'Autre num&eacute;ro de dossier'),
('breast bank no lab', 'global', 'Breast Bank Participant Number', 'Num&eacute;ro de participant pour la banque ''Sein'''), 
('ovary bank no lab', 'global', 'Ovary Bank Participant Number', 'Num&eacute;ro de participant pour la banque ''Ovaire'''), 
('prostate bank no lab', 'global', 'Prostate Bank Participant Number', 'Num&eacute;ro de participant pour la banque ''Prostate'''), 
('old bank no lab', 'global', 'Old Bank Participant Number', 'Ancien Num&eacute;ro de participant de banque'), 
('code-barre', 'global', 'Code-barre', 'Code &agrave; barres');

-- ---------------------------------------------------------------------
--
-- TREATMENT
--
-- ---------------------------------------------------------------------

-- Action: DELETE
-- Comments:

DELETE FROM `i18n`
WHERE `id` IN (
'sardo treatment id',
'chemotherapy',
'therapeutic goal',
'suspect'
);

-- Action: INSERT
-- Comments:

INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES 
('therapeutic goal', 'global', 'Therapeutic Goal ', 'Objectif th&eacute;rapeutique'),
('suspect', 'global', 'Suspect ', 'Suspect'),
('chemotherapy', 'global', 'Chemotherapy ', 'Chimioth&eacute;rapie'),
('sardo treatment id', 'global', 'SARDO Treatment ID ', 'ID du traitement dans SARDO');

-- ---------------------------------------------------------------------
--
-- ANNOTATION
--
-- ---------------------------------------------------------------------

-- Action: DELETE
-- Comments:

DELETE FROM `i18n`
WHERE `id` IN (
'biopsy report',
'cytology report',
'revision report',
'surgery report',
'lab report code',
'lab report conclusion',
'lab report date',
'positif',
'negatif',
'collection for cytology',
'medical imaging',
'medical examination',
'lab path report code is required',

'sardo record id',
'sardo record source',

'ca 125',
'red blood cells',
'hemoglobin',
'hematocrit',
'mean corpuscular volume',

'lab blood report',
'aps pre-operatory',
'aps',
'relecture de lame',

'to deliver', 
'delivered', 
'received'
);



-- Action: INSERT
-- Comments:

INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES 
('relecture de lame', 'global', 'Slide review', 'Relecture de lame'),
('biopsy report', 'global', 'Biopsy Lab Report', 'Rapport de laboratoire - biopsie'),
('cytology report', 'global', 'Cytology Lab Report', 'Rapport de laboratoire - cytologie'),
('revision report', 'global', 'Revision Lab Report', 'Rapport de laboratoire - r&eacute;vision'),
('surgery report', 'global', 'Surgery Lab Report', 'Rapport de laboratoire - chirurgie'),

('lab report code', 'global', 'Code', 'Code'),
('lab report conclusion', 'global', 'Conclusion', 'Conclusion'),
('lab report date', 'global', 'Studied Samples Collection Date', 'Date des pr&eacute;l&egrave;vements &eacute;tudi&eacute;s'),
('positif', 'global', 'Positif', 'Positif'),
('negatif', 'global', 'Negatif', 'N&eacute;gatif'),

('collection for cytology', 'global', 'Collection for cytology', 'Collection pour cytologie'),
('medical imaging', 'global', 'Medical Imaging', 'Imagerie m&eacute;dicale'),
('medical examination', 'global', 'Medical Examination', 'Examen m&eacute;dical'),

('to deliver', 'global', 'To Deliver', '&Agrave; donner'),
('delivered', 'global', 'Delivered', 'Donn&eacute;'),
('received', 'global', 'Received', 'Re&ccedil;u'),

('ca 125', 'global', 'CA-125', 'CA-125'),
('red blood cells', 'global', 'Red Blood Cells', 'Globules Rouges'),
('hemoglobin', 'global', 'Hemoglobin', 'H&eacute;moglobine'),
('hematocrit', 'global', 'Hematocrit', 'H&eacute;matocrite'),
('mean corpuscular volume', 'global', 'Mean Corpuscular Volume', 'Volume globulaire moyen'),
('lab blood report', 'global', 'Blood Report', 'Analyse sanguine'),
('aps', 'global', 'APS', 'APS'),
('aps pre-operatory', 'global', 'Pre-operatory APS', 'APS pr&eacute;-op&eacute;ratoire'),

('sardo record id', 'global', 'SARDO Record ID', 'ID de la donn&eacute;e dans SARDO'),
('sardo record source', 'global', 'SARDO Record Source', 'Source de la donn&eacute;e SARDO'),

('lab path report code is required', 'global', 'The Pathology Report Code is required!', 'Le code du rapport de pathologie est requis!');

-- ---------------------------------------------------------------------
-- CTRApp - inventory management - Quebec Customization 
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- GENERAL: MENU
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- GENERAL: SIDEBARS
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- COLLECTION
-- ---------------------------------------------------------------------

-- 
-- Table - `i18n`
-- 

-- Action: DELETE
-- Comments:

DELETE FROM `i18n`
WHERE `id` IN (
'breast', 
'ovary',
'prostate',

'notre dame hospital',
'hotel dieu hospital',
'saint luc hospital',

'bank participant identifier',

'inconnue',
'lise portelance',
'chantale auger',
'jason madore',
'julie desgagnes',
'karine normandin',
'isabelle letourneau',
'josh levin',
'liliane meunier',
'manon de ladurantaye',
'magdalena zietarska',
'nathalie delvoye',
'patrick kibangou bondza',
'urszula krzemien',
'valerie forest',
'veronique barres',
'labo externe',
'pathologie',
'christine abaji',
'elsa',
'emilio, johanne et phil',
'hafida lounis',
'jessica godin ethier',
'kevin gu',
'louise champoux',
'marie-andree forget',
'marie-josee milot',
'marie-line puiffe',
'marise roy',
'matthew starek',
'mona alam',
'stephanie lepage',
'veronique ouellet',
'yuan chang',
'aurore pierrard',
'jennifer kendall-dupont',
'autre'
);

-- Action: INSERT
-- Comments:

INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES
('breast', 'global', 'Breast', 'Sein'),
('ovary', 'global', 'Ovary', 'Ovaire'),
('prostate', 'global', 'Prostate', 'Prostate'),

('notre dame hospital', 'global', 'Notre Dame Hospital', 'H&ocirc;pital Notre Dame'),
('saint luc hospital', 'global', 'Saint Luc Hospital', 'H&ocirc;pital Saint Luc'),
('hotel dieu hospital', 'global', 'H&ocirc;tel-Dieu Hospital', 'H&ocirc;pital H&ocirc;tel-Dieu'),

('bank participant identifier', 'global', 'Participant ''Bank Lab No''', '''Bank Lab No'' du participant'),

('inconnue', 'global', 'Inconnue', 'Inconnue'),
('lise portelance', 'global', 'Lise Portelance', 'Lise Portelance'),
('chantale auger', 'global', 'Chantale Auger', 'Chantale Auger'),
('jason madore', 'global', 'Jason Madore', 'Jason Madore'),
('julie desgagnes', 'global', 'Julie Desgagn&eacute;s', 'Julie Desgagn&eacute;s'),
('karine normandin', 'global', 'Karine Normandin', 'Karine Normandin'),
('isabelle letourneau', 'global', 'Isabelle L&eacute;tourneau', 'Isabelle L&eacute;tourneau'),
('josh levin', 'global', 'Josh Levin', 'Josh Levin'),
('liliane meunier', 'global', 'Liliane Meunier', 'Liliane Meunier'),
('manon de ladurantaye', 'global', 'Manon de Ladurantaye', 'Manon de Ladurantaye'),
('magdalena zietarska', 'global', 'Magdalena Zietarska', 'Magdalena Zietarska'),
('nathalie delvoye', 'global', 'Nathalie Delvoye', 'Nathalie Delvoye'),
('patrick kibangou bondza', 'global', 'Patrick Kibangou Bondza', 'Patrick Kibangou Bondza'),
('urszula krzemien', 'global', 'Urszula Krzemien', 'Urszula Krzemien'),
('valerie forest', 'global', 'Val&eacute;rie Forest', 'Val&eacute;rie Forest'),
('veronique barres', 'global', 'V&eacute;ronique Barr&eagrave;s', 'V&eacute;ronique Barr&eagrave;s'),
('labo externe', 'global', 'Labo externe', 'Labo externe'),
('pathologie', 'global', 'Pathologie', 'Pathologie'),
('christine abaji', 'global', 'Christine Abaji', 'Christine Abaji'),
('elsa', 'global', 'Elsa', 'Elsa'),
('emilio, johanne et phil', 'global', '&Eacute;milio, Johanne et Phil', '&Eacute;milio, Johanne et Phil'),
('hafida lounis', 'global', 'Hafida Lounis', 'Hafida Lounis'),
('jessica godin ethier', 'global', 'Jessica Godin Ethier', 'Jessica Godin Ethier'),
('kevin gu', 'global', 'Kevin Gu', 'Kevin Gu'),
('louise champoux', 'global', 'Louise Champoux', 'Louise Champoux'),
('marie-andree forget', 'global', 'Marie-Andr&eacute;e Forget', 'Marie-Andr&eacute;e Forget'),
('marie-josee milot', 'global', 'Marie-Jos&eacute;e Milot', 'Marie-Jos&eacute;e Milot'),
('marie-line puiffe', 'global', 'Marie-Line Puiffe', 'Marie-Line Puiffe'),
('marise roy', 'global', 'Marise Roy', 'Marise Roy'),
('matthew starek', 'global', 'Matthew Starek', 'Matthew Starek'),
('mona alam', 'global', 'Mona Alam', 'Mona Alam'),
('stephanie lepage', 'global', 'St&eacute;phanie Lepage', 'St&eacute;phanie Lepage'),
('veronique ouellet', 'global', 'V&eacute;ronique Ouellet', 'V&eacute;ronique Ouellet'),
('yuan chang', 'global', 'Yuan Chang', 'Yuan Chang'),
('aurore pierrard', 'global', 'Aurore Pierrard', 'Aurore Pierrard'),
('jennifer kendall-dupont', 'global', 'Jennifer Kendall-Dupont', 'Jennifer Kendall-Dupont'),
('autre', 'global', 'Autre', 'Autre');

-- ---------------------------------------------------------------------
--
-- SAMPLE
--
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- SAMPLE : lab_type_laterality_match
-- ---------------------------------------------------------------------

-- 
-- Table - `i18n`
-- 

-- Action: DELETE
-- Comments:

DELETE FROM `i18n`
WHERE `id` IN (
'the selected type code does not match sample type', 
'no type code can currently be selected for the studied specimen type',
'the selected type code and labo laterality combination is not supported'
);



-- Action: INSERT
-- Comments:

INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES
('the selected type code does not match sample type', 'global', 'The selected type code can not be attached to the sample type!', 'Le code du type ne peut &ecirc;tre utilis&eacute; pour le type de l''&eacute;chantillon!'), 
('no type code can currently be selected for the studied specimen type', 'global', 'No type code can currently be selected for the studied specimen type!', 'Aucun code du type ne peut actuellement &ecirc;tre s&eacute;lectionn&eacute; pour le type de l''&eacute;chantillon!'), 
('the selected type code and labo laterality combination is not supported', 'global', 'The selected ''type code'' and ''labo laterality'' combination is not supported for the sample type ''Tissue''!', 'La combinaison ''code du type'' et ''lat&eacute;ralit&eacute;'' s&eacute;lectionn&eacute;e n''est pas support&eacute;e pour le type de l''&eacute;chantillon ''Tissu''!');

-- ---------------------------------------------------------------------
-- SAMPLE : master
-- ---------------------------------------------------------------------

-- 
-- Table - `i18n`
-- 

-- Action: DELETE
-- Comments:

DELETE FROM `i18n`
WHERE `id` IN (
'Labo Dr Mes-Masson',
'Labo Dr Maugard',
'Labo Dr Santos',
'Labo Dr Tonin',

'biological sample taking center',
'breast clinic',
'external clinic',
'family cancer center',
'preoperative checkup',
'gynaecology/oncology clinic',

'sample label'
);

-- Action: INSERT
-- Comments:

INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES
('Labo Dr Mes-Masson', 'global', 'Labo Dr Mes-Masson', 'Labo Dr Mes-Masson'),
('Labo Dr Maugard', 'global', 'Labo Dr Maugard', 'Labo Dr Maugard'),
('Labo Dr Santos', 'global', 'Labo Dr Santos', 'Labo Dr Santos'),
('Labo Dr Tonin', 'global', 'Labo Dr Tonin', 'Labo Dr Tonin'),

('biological sample taking center', 'global', 'Biological Sample Taking Center', ''),
('external clinic', 'global', 'External Clinic', 'Clinique externe'),
('breast clinic', 'global', 'Breast Clinic', 'Clinique du sein'),
('family cancer center', 'global', 'Family Cancer Center', 'Clinique des cancers familiaux'),
('preoperative checkup', 'global', 'Preoperative Checkup', 'Bilan pr&eacute;op&eacute;ratoire'),
('gynaecology/oncology clinic', 'global', 'Gynaec/Onco Clinic', 'Clinique Gyneco/Onco'),

('sample label', 'global', 'Sample Label', 'Identifiant de l''&eacute;chantillon');

-- ---------------------------------------------------------------------
-- SAMPLE : For undetailed specimens (fields also used by all other 
--          specimen types)
-- ---------------------------------------------------------------------

-- 
-- Table - `i18n`
-- 

-- Action: DELETE
-- Comments:

DELETE FROM `i18n`
WHERE `id` IN (
'labo type code',
'sequence number',

'TOV type code',
'BOV type code',
'NOV type code',
'OV type code',
'S type code',
'TR type code',
'UT type code',
'MOV type code',
'BR type code',
'L type code',
'LK type code',
'LP type code',
'LA type code',
'U type code',
'PR type code',
'T type code',
'N type code',

'sequence should be an integer'
);

-- Action: INSERT
-- Comments:

INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES
('labo type code', 'global', 'Type Code (Labo Defintion)', 'Code du type (D&eacute;finition du labo)'), 
('sequence number', 'global', 'Sequence number', 'Num&eacute;ro de s&eacute;quence'), 

('TOV type code', 'global', 'TOV', 'TOV'), 
('BOV type code', 'global', 'BOV', 'BOV'), 
('NOV type code', 'global', 'NOV', 'NOV'), 
('OV type code', 'global', 'OV', 'OV'), 
('S type code', 'global', 'S', 'S'), 
('TR type code', 'global', 'TR', 'TR'), 
('UT type code', 'global', 'UT', 'UT'), 
('MOV type code', 'global', 'MOV', 'MOV'), 
('BR type code', 'global', 'BR', 'BR'), 
('L type code', 'global', 'L', 'L'), 
('LK type code', 'global', 'LK', 'LK'), 
('LP type code', 'global', 'LP', 'LP'), 
('LA type code', 'global', 'LA', 'LA'), 
('U type code', 'global', 'U', 'U'), 
('PR type code', 'global', 'PR', 'PR'), 
('T type code', 'global', 'T', 'T'), 
('N type code', 'global', 'N', 'N'),

('sequence should be an integer', 'global', 'The sequence number should be a positive integer!', 'Le num&eacute;ro de s&eacute;quence doit &ecirc;tre un entier positif!');

-- ---------------------------------------------------------------------
-- SAMPLE : For tissue specimens
-- ---------------------------------------------------------------------

-- 
-- Table - `i18n`
-- 

-- Action: DELETE
-- Comments:

DELETE FROM `i18n`
WHERE `id` IN (
'labo tissue laterality',

'lab laterality D',
'lab laterality EP',
'lab laterality G',
'lab laterality M',
'lab laterality PT',
'lab laterality TR',
'lab laterality TRD',
'lab laterality TRG',
'lab laterality UniLat NS'
);

-- Action: INSERT
-- Comments:

INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES
('labo tissue laterality', 'global', 'Laterality (Labo Defintion)', 'Lat&eacute;ralit&eacute; (D&eacute;finition du labo)'),

('lab laterality D', 'global', 'D', 'D'),
('lab laterality EP', 'global', 'EP', 'EP'),
('lab laterality G', 'global', 'G', 'G'),
('lab laterality M', 'global', 'M', 'M'),
('lab laterality PT', 'global', 'PT', 'PT'),
('lab laterality TR', 'global', 'TR', 'TR'),
('lab laterality TRD', 'global', 'TRD', 'TRD'),
('lab laterality TRG', 'global', 'TRG', 'TRG'),
('lab laterality UniLat NS', 'global', 'UniLateral unspecified', 'UniLat&eacute; non sp&eacute;cifi&eacute;');

-- ---------------------------------------------------------------------
-- SAMPLE : For DNA derivatives
-- ---------------------------------------------------------------------

-- 
-- Table - `i18n`
-- 

-- Action: DELETE
-- Comments:

DELETE FROM `i18n`
WHERE `id` IN (
'source cell passage number',
'source storage temperature'
);

-- Action: INSERT
-- Comments:

INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES
('source cell passage number', 'global', 'Source Cell Passage Number', 'Nomber de passages cellulaires de la source'),
('source storage temperature', 'global', 'Source Storage Temperature', 'Temp&eacute;rature d''entreposage de la Source');

-- ---------------------------------------------------------------------
--
-- ALIQUOT
--
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- ALIQUOT : master
-- ---------------------------------------------------------------------

-- 
-- Table - `i18n`
-- 

-- Action: DELETE
-- Comments:

DELETE FROM `i18n`
WHERE `id` IN (
'aliquot label',
'aliquot label is required',
'aliquot label size is limited',
'accident', 
'see consent', 
'quality problem',
'injected to mice'
);

-- Action: INSERT
-- Comments:

INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES
('accident', 'global', 'Accident', 'Accident'),
('see consent', 'global', 'See Consent', 'Voir consentement'),
('quality problem', 'global', 'Quality Problem', 'Mauvaise qualit&eacute;'),
('aliquot label', 'global', 'Aliquot Label', '&Eacute;tiquette de l''aliquot'),
('injected to mice', 'global', 'Injected to Mice', 'Inj&eacute;t&eacute; &agrave; une souris'),
('aliquot label size is limited', 'global', 'Aliquot label size is limited!', 'La taille de l''&eacute;tiquette de l''aliquot est limit&eacute;e!'),
('aliquot label is required', 'global', 'Aliquot label is required!', '&Eacute;tiquette de l''aliquot est requis!');

-- ---------------------------------------------------------------------
-- ALIQUOT : For specimen tissue block
-- ---------------------------------------------------------------------

-- 
-- Table - `i18n`
-- 

-- Action: DELETE
-- Comments:

DELETE FROM `i18n`
WHERE `id` IN (
'position code',
'path report code'
);

-- Action: INSERT
-- Comments:

INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES
('position code', 'global', 'Position Code', 'Code de position'),
('path report code', 'global', 'Path Report Code', 'Code de rapport de pathologie');

-- ---------------------------------------------------------------------
-- ALIQUOT : For cell tube including volume and cell passage number
-- ---------------------------------------------------------------------

-- 
-- Table - `i18n`
-- 

-- Action: DELETE
-- Comments:

DELETE FROM `i18n`
WHERE `id` IN (
'cell passage number',
'threw'
);

-- Action: INSERT
-- Comments:

INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES
('threw', 'global', 'Threw', 'Jeté'),
('cell passage number', 'global', 'Cell Passage number', 'Nombre de passages cellulaires');

-- ---------------------------------------------------------------------
--
-- QUALITY CONTROL
--
-- ---------------------------------------------------------------------

-- 
-- Table - `i18n`
-- 

-- Action: DELETE
-- Comments:

DELETE FROM `i18n`
WHERE `id` IN (
'degraded',
'partially degraded',
'very good',
'chip model',
'nano',
'pico',	 
'reference',
'pimary'
);

-- Action: INSERT
-- Comments:

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('degraded', 'global', 'Degraded', 'D&eacute;grad&eacute;'),
('partially degraded', 'global', 'Partially Degraded', 'Partiellement d&eacute;grad&eacute;'),
('very good', 'global', 'Very good', 'Tr&eacute;s bon'),

('chip model', 'global', 'Chip Model', 'Model de puce'),
('nano', 'global', 'Nano', 'Nano'),
('pico', 'global', 'Pico', 'Pico'),
('reference', 'global', 'Reference', 'R&eacute;f&eacute;rence'),
('pimary', 'global', 'Primary', 'Primaire');

-- ---------------------------------------------------------------------
-- CTRApp - inventory management - Temporary Quebec Customization
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- GENERAL: MENU
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- GENERAL: SIDEBARS
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- COLLECTION
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
--
-- SAMPLE
--
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- SAMPLE : For tissue specimens
-- ---------------------------------------------------------------------

-- 
-- Table - `i18n`
-- 

-- Action: DELETE
-- Comments:

DELETE FROM `i18n`
WHERE `id` IN (
'tmp buffer use',
'tmp on ice'
);

-- Action: INSERT
-- Comments:

INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES
('tmp on ice', 'global', 'On Ice (tmp)', 'Sur Glace (tmp)'),
('tmp buffer use', 'global', 'Bufferer Use (tmp)', 'Utilisation de Tampon (tmp)');

-- ---------------------------------------------------------------------
-- SAMPLE : For pbmc specimens
-- ---------------------------------------------------------------------

-- 
-- Table - `i18n`
-- 

-- Action: DELETE
-- Comments:

DELETE FROM `i18n`
WHERE `id` IN (
'tmp blood cell solution'
);

-- Action: INSERT
-- Comments:

INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES
('tmp blood cell solution', 'global', 'Solution (tmp)', 'Solution (tmp)');

-- ---------------------------------------------------------------------
-- SAMPLE : For cell culture derivatives
-- ---------------------------------------------------------------------

-- 
-- Table - `i18n`
-- 

-- Action: DELETE
-- Comments:

DELETE FROM `i18n`
WHERE `id` IN (
'tmp collection method',
'tmp culture solution',
'tmp percentage of oxygen',
'tmp percentage of serum',
'tmp hormon',

'centrifugation',
'collagenase',
'mechanic',
'scratching',
'tissue section',
'trypsin',
'scissors',
'clone',
'spheroides',

'OSE',
'DMEM',
'CSF-C100(CHO)',

'egf+bpe+insulin+hydrocortisone',
'b-estradiol',
'progesterone',
'b-estradiol+progesterone'
);

-- Action: INSERT
-- Comments:

INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES
('tmp collection method', 'global', 'Collection Method (tmp)', 'M&eacute;thode de pr&eacute;l&egrave;vement (tmp)'),
('tmp culture solution', 'global', 'Culture Solution (tmp)', 'Milieu de Culture (tmp)'),
('tmp percentage of oxygen', 'global', 'Oxygen Percentage (tmp)', 'Pourcentage d''oxyg&egrave;ne (tmp)'),
('tmp percentage of serum', 'global', 'Serum Percentage (tmp)', 'Pourcentage de S&eacute;rum (tmp)'),
('tmp hormon', 'global', 'Hormon (tmp)', 'Hormone (tmp)'),

('centrifugation', 'global', 'Centrifugation', 'Centrifugation'),
('collagenase', 'global', 'Collagenase', 'Collag&eacute;nase'),
('mechanic', 'global', 'Mechanic', 'M&eacute;canique'),
('scratching', 'global', 'Scratching', 'Grattage'),
('trypsin', 'global', 'Trypsin', 'Trypsine'),
('tissue section', 'global', 'Tissue Section', 'Bouts de tissu'),
('scissors', 'global', 'Scissors', 'Ciseaux'),
('clone', 'global', 'Clone', 'Clone'),
('spheroides', 'global', 'Spheroides', 'Sph&eacute;ro&iuml;des'),

('OSE', 'global', 'OSE', 'OSE'),
('DMEM', 'global', 'DMEM', 'DMEM'),
('CSF-C100(CHO)', 'global', 'CSF-C100(CHO)', 'CSF-C100(CHO)'),

('egf+bpe+insulin+hydrocortisone', 'global', 'EGF+BPE+Insulin+Hydrocortisone', 'EGF+BPE+Insuline+Hydrocortisone'),
('b-estradiol', 'global', 'B-estradiol', 'B-estradiol'),
('progesterone', 'global', 'Progesterone', 'Progest&eacute;rone'),
('b-estradiol+progesterone', 'global', 'B-estradiol+Progesterone', 'B-estradiol+Progest&eacute;rone');

-- ---------------------------------------------------------------------
-- SAMPLE : For DNA derivatives
-- ---------------------------------------------------------------------

-- 
-- Table - `i18n`
-- 

-- Action: DELETE
-- Comments:

DELETE FROM `i18n`
WHERE `id` IN (
'tmp source storage solution', 
'tmp source storage method',
'tmp dna extraction method',

'phenol Chloroform',
'flexigene DNA kit',

'flash freeze',

'oct solution', 
'isopentane', 
'isopentane + oct', 
'flash freeze',
'RNA later',
'paraffin',

'cell culture medium',

'DMSO',
'DMSO + serum',
'trizol',
'serum'
);

-- Action: INSERT
-- Comments:

INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES
('tmp source storage solution', 'global', 'Source Storage Medium (tmp)', 'Milieu d''Entreposage de la Source (tmp)'),
('tmp source storage method', 'global', 'Source Storage Method (tmp)', 'M&eacute;thode d''Entreposage de la Source (tmp)'),
('tmp dna extraction method', 'global', 'DNA Extraction Method (tmp)', 'M&eacute;thode d''Extraction de l''ADN (tmp)'),

('phenol Chloroform', 'global', 'Phenol Chloroform', 'Ph&eacute;nol/Chloroforme'),
('flexigene DNA kit', 'global', 'Flexigene DNA Kit', 'Kit ''Flexigene DNA'''),

('flash freeze', 'global', 'Flash Freeze', 'Flash Freeze'),

('oct solution', 'global', 'OCT', 'OCT'),
('isopentane', 'global', 'Isopentane', 'Isopentane'),
('isopentane + oct', 'global', 'Isopentane + OCT', 'Isopentane + OCT'),
('RNA later', 'global', 'RNA later', 'RNA later'),
('paraffin', 'global', 'Paraffin', 'Paraffine'),

('cell culture medium', 'global', 'Cell Culture Medium', 'Milieu de culture'),

('DMSO', 'global', 'DMSO', 'DMSO'),
('DMSO + serum', 'global', 'DMSO + Serum', 'DMSO + S&eacute;rum'),
('trizol', 'global', 'Trizol', 'Trizol'),
('serum', 'global', 'Serum', 'S&eacute;rum');

-- ---------------------------------------------------------------------
-- SAMPLE : For RNA derivatives
-- ---------------------------------------------------------------------

DELETE FROM `i18n`
WHERE `id` in (
'tmp rna extraction method', 
'paxgene blood RNA kit', 
'quiagen rneasy kit'
);

-- Insert

INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES 
('tmp rna extraction method', 'global', 'RNA Extraction Method (tmp)', 'M&eacute;thode d''Extraction de l''ARN (tmp)'),
('paxgene blood RNA kit', 'global', 'Paxgene Blood RNA Kit', 'Kit ''Paxgene Blood RNA'''),
('quiagen rneasy kit', 'global', 'Quiagen RNeasy Kit', 'Kit ''Quiagen RNeasy Kit''');

-- ---------------------------------------------------------------------
-- SAMPLE : For amplified RNA derivatives
-- ---------------------------------------------------------------------

DELETE FROM `i18n`
WHERE `id` in (
'tmp rna amplification method',
'alethia-ramp', 
'alethia-arcturus',
'tmp rna amplification number');

-- Insert

INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES 
('tmp rna amplification number', 'global', 'RNA Amplification Number (tmp)', 'Num&eacute;ro de l''Amplification (tmp)'),
('tmp rna amplification method', 'global', 'RNA Amplification Method (tmp)', 'M&eacute;thode d''Amplification de l''ARN (tmp)'),
('alethia-ramp', 'global', 'Alethia-Ramp', 'Al&eacute;thia-Ramp'),
('alethia-arcturus', 'global', 'Alethia-Arcturus', 'Al&eacute;thia-Arcturus');

-- ---------------------------------------------------------------------
--
-- ALIQUOT
--
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- ALIQUOT : For specimen tissue block
-- ---------------------------------------------------------------------

DELETE FROM `i18n`
WHERE `id` in (
'tmp gleason score',
'primary grade',
'secondary grade',

'tmp tissue description',
'primary',
'secondary',

'stroma',
'tumor',
'hyperplasia',
'PIN',
'HBP',
'prostatitis'
);

-- Insert

INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES 
('tmp gleason score', 'global', 'Gleason Score (tmp)', 'Grade de Gleason (tmp)'),
('primary grade', 'global', 'Primary Grade', 'Grade primaire'),
('secondary grade', 'global', 'Secondary Grade', 'Grade secondaire'),

('tmp tissue description', 'global', 'Tissue Description (tmp)', 'Description du tissu (tmp)'),
('primary', 'global', 'Primary', 'Primaire'),
('secondary', 'global', 'Secondary', 'Secondaire'),

('PIN', 'global', 'PIN', 'PIN'),
('HBP', 'global', 'HBP', 'HBP'),
('prostatitis', 'global', 'Prostatitis', 'prostatite'),

('stroma', 'global', 'Stroma', 'Stroma'),
('tumor', 'global', 'Tumor', 'Tumeur'),
('hyperplasia', 'global', 'Hyperplasia', 'Hyperplasie');

-- ---------------------------------------------------------------------
-- ALIQUOT : For tissue tubes
-- ---------------------------------------------------------------------

DELETE FROM `i18n`
WHERE `id` in (
'tmp storage solution',
'tmp storage method',
'culture medium'
);

-- Insert

INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES 
('tmp storage solution', 'global', 'Storage Solution (tmp)', 'Solution d''Entreposage (tmp)'),
('culture medium', 'global', 'Culture medium', 'Milieu de culture'),
('tmp storage method', 'global', 'Storage Method (tmp)', 'M&eacute;thode d''Entreposage (tmp)');

-- ---------------------------------------------------------------------
-- ALIQUOT : For dna rna tubes
-- ---------------------------------------------------------------------

DELETE FROM `i18n`
WHERE `id` in (
'H2O',
'TE buffer'
);

-- Insert

INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES 
('H2O', 'global', 'H2O', 'H2O'),
('TE buffer', 'global', 'TE Buffer', 'Tampon TE');

-- ---------------------------------------------------------------------
-- CTRApp - order
-- ---------------------------------------------------------------------

-- 
-- Table - `i18n`
-- 

-- Action: DELETE
-- Comments:

DELETE FROM `i18n`
WHERE `id` IN (
'microarray',
'chip',
'shipping name'
);

-- Action: INSERT
-- Comments:

INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES
('microarray', 'global', 'Microarray', 'Bio-puce'),
('chip', 'global', 'Chip', 'Puce'),
('shipping name', 'global', 'Shipping Name', 'Nom d''envoi');

-- ---------------------------------------------------------------------
-- CTRApp - drug and protocol 
-- ---------------------------------------------------------------------

-- 
-- Table - `i18n`
-- 

-- Action: DELETE
-- Comments:

DELETE FROM `i18n`
WHERE `id` IN (
'chemotherapy',
'hormonotherapy',
'immunotherapy',
'growth factor therapy',
'drug'
);

-- Action: INSERT
-- Comments:

INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES 
('chemotherapy', 'global', 'Chemotherapy', 'Hormonoth&eacute;rapie'),
('hormonotherapy', 'global', 'Hormonotherapy', 'Hormonoth&eacute;rapie'),
('immunotherapy', 'global', 'Immunotherapy', 'Immunoth&eacute;rapie'),
('growth factor therapy', 'global', 'Growth Factor Therapy', ''),
('drug', 'global', 'Drug', 'M&eacute;dicament');

-- ---------------------------------------------------------------------
-- CTRApp - storage management
-- ---------------------------------------------------------------------

-- 
-- Table - `i18n`
-- 

-- Action: DELETE
-- Comments:

DELETE FROM `i18n`
WHERE `id` IN (
'rack',
'box100',
'box27'
);

-- Action: INSERT
-- Comments:

INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES
('rack', 'global', 'Rack', 'Ratelier'),
('box27', 'global', 'Box27 1-27', 'Bo&icirc;te27 1-27'),
('box100', 'global', 'Box100 1-100', 'Bo&icirc;te100 1-100');

-- ------------------------------------------------------------------------------------------------
--
-- VERSION: AFTER PROD
--
-- ------------------------------------------------------------------------------------------------

-- ------------------------------------------------------------------------------------------------
--
-- VERSION: 1.5
--
-- ------------------------------------------------------------------------------------------------

-- ------------------------------------------------------------------------------------------------
--
-- VERSION: 1.5.1
--
-- ------------------------------------------------------------------------------------------------

DELETE FROM `i18n`
WHERE `id` IN (
'box49 1A-7G'
);

INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES
('box49 1A-7G', 'global', 'Box49 1A-7G', 'Bo&icirc;te49 1A-7G');

-- ------------------------------------------------------------------------------------------------
--
-- VERSION: 1.6.0
--
-- ------------------------------------------------------------------------------------------------

DELETE FROM `i18n`
WHERE `id` IN (
'box49 1A-7G',
'box49',
'DMSO + FBS'
);

INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES
('box49', 'global', 'Box49 1-49', 'Bo&icirc;te49 1-49'),
('DMSO + FBS', 'global', 'DMSO + FBS', 'DMSO + FBS');

DELETE FROM `i18n`
WHERE `id` IN ('no item has been selected!');

INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES
('no item has been selected!', 'global', 'No item has been selected!', 'Aucun item n''a &eacute;t&eacute; selectionn&eacute;!');




