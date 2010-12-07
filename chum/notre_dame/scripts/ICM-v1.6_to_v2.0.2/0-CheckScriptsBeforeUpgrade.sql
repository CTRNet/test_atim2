-- check #0 : Check sample aliquot control link
select created_link
FROM (select distinct concat(sm.sample_control_id,'->',am.aliquot_control_id) as created_link
from sample_masters as sm 
inner join aliquot_masters as am on am.sample_master_id = sm.id) cre
WHERE cre.created_link NOT IN (select distinct concat(sm.sample_control_id,'->',link.aliquot_control_id) as defined_link
from sample_masters as sm 
inner join sample_aliquot_control_links as link on link.sample_control_id = sm.sample_control_id 
where status = 'active');
-- -> res = empty.

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
WHERE `received_volume` != `collected_volume`;
-- -> 0 records

-- check #9 : Test unused collection fields that will be dropped
SELECT DISTINCT `title` , confirmation_source , status, date_status, icd10_id, `middle_name` , `confirmation_source` , `ethnicity`, death_certificate_ident
FROM `participants`;
-- -> 0 records

-- check #10 : Test existing identifiers
SELECT DISTINCT `name` FROM `misc_identifiers`;
-- -> ovary bank no lab
-- -> notre-dame id nbr
-- -> ramq nbr
-- -> hotel-dieu id nbr
-- -> breast bank no lab
-- -> prostate bank no lab
-- -> code-barre
-- -> saint-luc id nbr
-- -> old bank no lab
-- -> other center id nbr
-- -> other center patient number
-- -> kidney bank no lab
-- -> head and neck bank no lab
-- -> participant patho identifier 

-- check #11 : Check issue on consent
SELECT id, form_version, consent_type, consent_version_date, consent_language FROM `consents` WHERE `consent_type` IS NULL OR `consent_type` LIKE '';
-- -> 4363	| FRSQ_fr_2008-03-26	| NULL	| NULL

-- check #11 : Check unused consents fields that will be dropped
SELECT DISTINCT surgeon, contact_method, operation_date, facility,
use_of_tissue,contact_future_research,access_medical_information,
facility_other,acquisition_id,diagnosis_id,consent_id FROM consents;
-- -> 0 records

-- check #12 : Check unused diagnoses fields that will be dropped
SELECT DISTINCT dx_method ,dx_nature ,
sequence_nbr ,information_source,age_at_dx_status ,clinical_stage ,collaborative_stage 
tstage ,nstage ,mstage ,stage_grouping,is_cause_of_death 
FROM diagnoses;
-- -> 0 records

-- check #13 : Check diagnoses survival_unit
SELECT DISTINCT survival_unit FROM `diagnoses`;
-- -> months

-- check #14 : Check unused family_histories fields that will be dropped
SELECT DISTINCT `relation` , `domain` , `dx_date_status` , `age_at_dx`
FROM `family_histories`;
-- -> 0 records

-- check #15 : Check unused reproductive_histories fields that will be dropped
SELECT DISTINCT `date_captured` , `age_at_menopause` , `menopause_age_certainty`  , `hrt_years_on` , `hrt_use` , `hysterectomy_age` , `hysterectomy_age_certainty`  , `hysterectomy` , `first_ovary_out_age` , `first_ovary_certainty`  , `second_ovary_out_age`  , `second_ovary_certainty`  , `first_ovary_out` , `second_ovary_out` , `gravida` , `aborta` , `para` , `age_at_first_parturition`  , `first_parturition_certainty`  , `age_at_last_parturition`  , `last_parturition_certainty`  , `age_at_menarche` , `age_at_menarche_certainty`  , `oralcontraceptive_use`  , `years_on_oralcontraceptives`
FROM reproductive_histories;
-- -> 0 records

-- check #16 : Check no source block has been defined
SELECT DISTINCT `ad_block_id` FROM `ad_tissue_slides`;
-- -> 0 records
-- NOTE: 4 records exist now. Keep in mind and rebuild relation in prod.

-- check #17 : Check no error into the derivative sample label creation
SELECT spec.id AS spec_sample_master_id, spec.collection_id AS spec_collection_id, CONCAT('%',spec.sample_label,'%') AS spec_sample_label, 
deriv.id  AS derivsample_master_id, deriv.collection_id AS deriv_collection_id, deriv.sample_label  AS deriv_sample_label
FROM sample_masters AS spec 
INNER JOIN sample_masters AS deriv ON deriv.initial_specimen_sample_id = spec.id AND deriv.sample_category = 'derivative' AND spec.sample_category = 'specimen'
WHERE deriv.sample_label NOT LIKE CONCAT('%',spec.sample_label,'%');
-- -> 0 records

-- check #18 : No derivative for LB
select * from sample_masters where parent_id IN (SELECT sample_master_id FROM aliquot_masters WHERE aliquot_label LIKE 'LB-PBMC%');
-- -> 0 records

-- check #19 : No LB-PBMC having storage_solution
select distinct pbmc.tmp_solution
from sd_der_pbmcs as pbmc
INNER JOIN sample_masters AS samp ON samp.id = pbmc.sample_master_id
INNER JOIN aliquot_masters AS aliq ON samp.id = aliq.sample_master_id 
WHERE aliq.aliquot_label LIKE 'LB-PBMC%';
-- -> All NULL.





