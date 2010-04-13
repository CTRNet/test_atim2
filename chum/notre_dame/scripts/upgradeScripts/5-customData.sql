-- collection site
UPDATE structure_permissible_values SET language_alias='CHUQ', value='CHUQ' WHERE id=767;
UPDATE structure_permissible_values SET language_alias='CHUS', value='CHUS' WHERE id=768;
UPDATE structure_permissible_values SET language_alias='Fides external clinic', value='Fides external clinic' WHERE id=769;
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('hotel dieu hospital', 'hotel dieu hospital');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='custom_collection_site'),  (SELECT id FROM structure_permissible_values WHERE value='hotel dieu hospital' AND language_alias='hotel dieu hospital'), '', 'yes');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('notre dame hospital', 'notre dame hospital');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='custom_collection_site'),  (SELECT id FROM structure_permissible_values WHERE value='notre dame hospital' AND language_alias='notre dame hospital'), '', 'yes');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('saint luc hospital', 'saint luc hospital');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='custom_collection_site'),  (SELECT id FROM structure_permissible_values WHERE value='saint luc hospital' AND language_alias='saint luc hospital'), '', 'yes');

-- supplier departement
UPDATE structure_permissible_values SET language_alias='biological sample taking center', value='biological sample taking center' WHERE id=773;
UPDATE structure_permissible_values SET language_alias='breast clinic', value='breast clinic' WHERE id=774;
UPDATE structure_permissible_values SET language_alias='day surgery', value='day surgery' WHERE id=775;
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='custom_specimen_supplier_dept'),  (SELECT id FROM structure_permissible_values WHERE value='clinic' AND language_alias='clinic'), '0', 'yes');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('external clinic', 'external clinic');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='custom_specimen_supplier_dept'),  (SELECT id FROM structure_permissible_values WHERE value='external clinic' AND language_alias='external clinic'), '0', 'yes');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('gynaecology/oncology clinic', 'gynaecology/oncology clinic');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='custom_specimen_supplier_dept'),  (SELECT id FROM structure_permissible_values WHERE value='gynaecology/oncology clinic' AND language_alias='gynaecology/oncology clinic'), '0', 'yes');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('operating room', 'operating room');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='custom_specimen_supplier_dept'),  (SELECT id FROM structure_permissible_values WHERE value='operating room' AND language_alias='operating room'), '0', 'yes');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('other', 'other');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='custom_specimen_supplier_dept'),  (SELECT id FROM structure_permissible_values WHERE value='other' AND language_alias='other'), '0', 'yes');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('pathology dept', 'pathology dept');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='custom_specimen_supplier_dept'),  (SELECT id FROM structure_permissible_values WHERE value='pathology dept' AND language_alias='pathology dept'), '0', 'yes');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('preoperative checkup', 'preoperative checkup');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='custom_specimen_supplier_dept'),  (SELECT id FROM structure_permissible_values WHERE value='preoperative checkup' AND language_alias='preoperative checkup'), '0', 'yes');

-- custom_laboratory_staff by
UPDATE structure_permissible_values SET language_alias='Manon de Ladurantaye', value='Manon de Ladurantaye' WHERE id=770;
UPDATE structure_permissible_values SET language_alias='Jennifer Kendall-Dupont', value='Jennifer Kendall-Dupont' WHERE id=771;
UPDATE structure_permissible_values SET language_alias='Lise Portelance', value='Lise Portelance' WHERE id=772;
INSERT IGNORE INTO structure_permissible_values(`value`, `language_alias`) VALUES
('aurore pierrard','aurore pierrard'),
('Autre','Autre'),
('chantale auger','chantale auger'),
('christine abaji','christine abaji'),
('emilio, johanne et p','emilio, johanne et p'),
('guillaume cardin','guillaume cardin'),
('inconnue','inconnue'),
('jessica godin ethier','jessica godin ethier'),
('julie desgagnes','julie desgagnes'),
('Karine','Karine'),
('karine normandin','karine normandin'),
('katia caceres','katia caceres'),
('labo externe','labo externe'),
('liliane meunier','liliane meunier'),
('Lise','Lise'),
('Louise','Louise'),
('louise champoux','louise champoux'),
('Lu-Lin Wang','Lu-Lin Wang'),
('Magdalena','Magdalena'),
('magdalena zietarska','magdalena zietarska'),
('Manon','Manon'),
('marie-andree forget','marie-andree forget'),
('marie-josee milot','marie-josee milot'),
('Marie-Line','Marie-Line'),
('marie-line puiffe','marie-line puiffe'),
('Marise','Marise'),
('marise roy','marise roy'),
('matthew starek','matthew starek'),
('nathalie delvoye','nathalie delvoye'),
('pathologie','pathologie'),
('patrick kibangou bon','patrick kibangou bon'),
('Stéphanie','Stéphanie'),
('stephanie lepage','stephanie lepage'),
('teodora yaneva','teodora yaneva'),
('urszula krzemien','urszula krzemien'),
('Véronique Barres','Véronique Barres'),
('Véronique Ouellet','Véronique Ouellet'),
('veronique barres','veronique barres'),
('veronique ouellet','veronique ouellet'),
('yuan chang','yuan chang');

INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `active`) 
(SELECT '174', id, '0', 'yes' FROM structure_permissible_values WHERE
(`value`='aurore pierrard' AND language_alias='aurore pierrard') OR
(`value`='Autre' AND language_alias='Autre') OR
(`value`='chantale auger' AND language_alias='chantale auger') OR
(`value`='christine abaji' AND language_alias='christine abaji') OR
(`value`='emilio, johanne et p' AND language_alias='emilio, johanne et p') OR
(`value`='guillaume cardin' AND language_alias='guillaume cardin') OR
(`value`='inconnue' AND language_alias='inconnue') OR
(`value`='jessica godin ethier' AND language_alias='jessica godin ethier') OR
(`value`='julie desgagnes' AND language_alias='julie desgagnes') OR
(`value`='Karine' AND language_alias='Karine') OR
(`value`='karine normandin' AND language_alias='karine normandin') OR
(`value`='katia caceres' AND language_alias='katia caceres') OR
(`value`='labo externe' AND language_alias='labo externe') OR
(`value`='liliane meunier' AND language_alias='liliane meunier') OR
(`value`='Lise' AND language_alias='Lise') OR
(`value`='Louise' AND language_alias='Louise') OR
(`value`='louise champoux' AND language_alias='louise champoux') OR
(`value`='Lu-Lin Wang' AND language_alias='Lu-Lin Wang') OR
(`value`='Magdalena' AND language_alias='Magdalena') OR
(`value`='magdalena zietarska' AND language_alias='magdalena zietarska') OR
(`value`='Manon' AND language_alias='Manon') OR
(`value`='marie-andree forget' AND language_alias='marie-andree forget') OR
(`value`='marie-josee milot' AND language_alias='marie-josee milot') OR
(`value`='Marie-Line' AND language_alias='Marie-Line') OR
(`value`='marie-line puiffe' AND language_alias='marie-line puiffe') OR
(`value`='Marise' AND language_alias='Marise') OR
(`value`='marise roy' AND language_alias='marise roy') OR
(`value`='matthew starek' AND language_alias='matthew starek') OR
(`value`='nathalie delvoye' AND language_alias='nathalie delvoye') OR
(`value`='pathologie' AND language_alias='pathologie') OR
(`value`='patrick kibangou bon' AND language_alias='patrick kibangou bon') OR
(`value`='Stéphanie' AND language_alias='Stéphanie') OR
(`value`='stephanie lepage' AND language_alias='stephanie lepage') OR
(`value`='teodora yaneva' AND language_alias='teodora yaneva') OR
(`value`='urszula krzemien' AND language_alias='urszula krzemien') OR
(`value`='Véronique Barres' AND language_alias='Véronique Barres') OR
(`value`='Véronique Ouellet' AND language_alias='Véronique Ouellet') OR
(`value`='veronique barres' AND language_alias='veronique barres') OR
(`value`='veronique ouellet' AND language_alias='veronique ouellet') OR
(`value`='yuan chang' AND language_alias='yuan chang'));




-- custom_laboratory_site
UPDATE structure_permissible_values SET language_alias='Labo Dr Maugard', value='Labo Dr Maugard' WHERE id=820;
UPDATE structure_permissible_values SET language_alias='Labo Dr Mes-Masson', value='Labo Dr Mes-Masson' WHERE id=821;
UPDATE structure_permissible_values SET language_alias='Labo Sein', value='Labo Sein' WHERE id=822;
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_site'),  (SELECT id FROM structure_permissible_values WHERE value='other' AND language_alias='other'), '0', 'yes');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('u', 'unknown');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='date_accuracy'),  (SELECT id FROM structure_permissible_values WHERE value='u' AND language_alias='unknown'), '0', 'yes');


//TODO: copy data to revs tables