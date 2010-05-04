-- check #1 : Test unused aliquot_control_ids that will be deleted
SELECT * FROM aliquot_masters WHERE aliquot_control_id IN ('3', '7', '9');
-- -> res = empty.

-- check #2 : Test unused aliquot_masters fields that will be dropped
SELECT distinct received, received_datetime, received_from, received_id FROM `aliquot_masters` WHERE 1;
-- -> All NULL.

-- check #3 : Test unused order_lines fields that will be dropped
SELECT DISTINCT `cancer_type` , `quantity_UM` , `min_qty_UM` , `base_price` , `discount_id` , `product_id`
FROM `order_lines`;
-- -> All NULL.

-- check #4 : Test unused order_items fields that will be dropped
SELECT DISTINCT `base_price` FROM `order_items`;
-- -> All NULL.

-- check #5 : Test no amplified dna exists
SELECT id FROM sample_masters WHERE sample_control_id = (SELECT id FROM `sample_controls` WHERE `sample_type` LIKE 'amplified dna');    
-- -> 0 records

-- check #6 : Test no b cell
SELECT id FROM sample_masters WHERE sample_control_id = (SELECT id FROM `sample_controls` WHERE `sample_type` LIKE 'b cell'); 
-- -> 0 records

-- check #7 : Test other fluid
SELECT id, sample_type, notes FROM `sample_masters` WHERE `sample_control_id` =105 AND `sample_type` LIKE 'other fluid';
-- -> 	id		| sample_type	| notes
-- -> 	3323	| other fluid	| 	Ã‰chantillon importÃ© de FileMaker Pro FileMaker Pro : 
-- -> 			| 				| liquide pÃ©ricardique Notes : mort au P6, pas d'ARN
-- -> 	3327	| other fluid	| 	Ã‰chantillon importÃ© de FileMaker Pro FileMaker Pro : 
-- -> 			| 				| Liquide pleural Notes : Cellules nÃ©oplasiques suggestives d'un adÃ©nocarcinome mÃ©tastatique culture ne s'Ã©tablit pas
-- -> 	4677	| other fluid	| 	Ã‰chantillon importÃ© de FileMaker Pro FileMaker Pro : 
-- -> 			| 				| Liquide pleural Stade 4, Grade 3-4 Notes : post-chimio, cellules nÃ©oplasiques suggestives d'un adÃ©nocarcinome mÃ©tastatique
-- -> 	5861	| other fluid	| 	Ã‰chantillon importÃ© de FileMaker Pro FileMaker Pro : 
-- -> 			| 				| ascite-endomÃ©trioÃ¯de Grade 1-2 Notes : Ce n'Ã©tait pas vraiment de l'ascite mais un morceau visqueux dans un liquide sanguinolant. J'ai quand mÃªme ajoutÃ© de la collagÃ©nase o/n pour le dÃ©faire. Culture arrÃªtÃ©e au P5 Cas de cystadÃ©nocarcinome de type endomÃ©trioÃ¯de
-- -> 	14328	| other fluid	| 	Ã‰chantillon importÃ© de FileMaker Pro FileMaker Pro : 
-- -> 			| 				| Liquide pleural Grade 3 Notes : Rien dans le rapport de patho sur ce prÃ©lÃ¨vement. Culture s'est rendue au P4

-- check #8 : Test unused urine fields that will be dropped
SELECT sample_label, received_volume, collected_volume 
FROM sample_masters 
INNER JOIN `sd_spe_urines` ON sample_masters.id = sd_spe_urines.sample_master_id
WHERE `received_volume` != `collected_volume` 
-- -> 0 records

-- check #9 : Test unused collection fields that will be dropped
SELECT DISTINCT `title` , confirmation_source , status, date_status, icd10_id, `middle_name` , `confirmation_source` , `ethnicity`, death_certificate_ident
FROM `participants`;
-- -> 0 records

