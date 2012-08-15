
-- ---------------------------------------------------------------------------
-- TNM Clean Up
-- ---------------------------------------------------------------------------

-- small intestine

SELECT 'cap report sm intestines revision' AS msg;

SELECT p.id AS participant_id, p.participant_identifier AS no_bank, ed.tumour_grade AS tumour_grade_to_review
FROM participants AS p
INNER JOIN event_masters AS em ON em.participant_id = p.id AND em.deleted <> 1
INNER JOIN ed_cap_report_smintestines as ed ON ed.event_master_id = em.id
WHERE ed.tumour_grade IS NOT NULL AND ed.tumour_grade NOT LIKE '';

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', '', 'tumour_grade', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='histologic_grade') , '0', '', '', '', 'histologic grade', '');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='tumour_grade' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='histologic_grade') ) WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_cap_report_smintestines') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='tumour_grade' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='histologic_grade_c') AND `flag_confidential`='0');

-- perihilar bile duct

SELECT 'cap report peri hilar bile ducts revision' AS msg;

SELECT p.id AS participant_id, p.participant_identifier AS no_bank, ed.tumour_grade AS tumour_grade_to_review, ed.path_tstage AS ath_tstage_to_review, ed.path_nstage AS ath_nstage_to_review, ed.path_mstage AS ath_mstage_to_review
FROM participants AS p
INNER JOIN event_masters AS em ON em.participant_id = p.id AND em.deleted <> 1
INNER JOIN ed_cap_report_perihilarbileducts as ed ON ed.event_master_id = em.id
WHERE (ed.tumour_grade IS NOT NULL AND ed.tumour_grade NOT LIKE '')
OR (ed.path_tstage IS NOT NULL AND ed.path_tstage NOT LIKE '')
OR (ed.path_nstage IS NOT NULL AND ed.path_nstage NOT LIKE '')
OR (ed.path_mstage IS NOT NULL AND ed.path_mstage NOT LIKE '');

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

SELECT 'pancreas exo' AS msg;

SELECT p.id AS participant_id, p.participant_identifier AS no_bank, ed.tumour_grade AS tumour_grade_to_review, ed.path_tstage AS ath_tstage_to_review, ed.path_nstage AS ath_nstage_to_review, ed.path_mstage AS ath_mstage_to_review
FROM participants AS p
INNER JOIN event_masters AS em ON em.participant_id = p.id AND em.deleted <> 1
INNER JOIN ed_cap_report_pancreasexos as ed ON ed.event_master_id = em.id
WHERE (ed.tumour_grade IS NOT NULL AND ed.tumour_grade NOT LIKE '')
OR (ed.path_tstage IS NOT NULL AND ed.path_tstage NOT LIKE '')
OR (ed.path_nstage IS NOT NULL AND ed.path_nstage NOT LIKE '')
OR (ed.path_mstage IS NOT NULL AND ed.path_mstage NOT LIKE '');

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

SELECT 'pancreas endo' AS msg;

SELECT p.id AS participant_id, p.participant_identifier AS no_bank, ed.tumour_grade AS tumour_grade_to_review, ed.path_tstage AS ath_tstage_to_review, ed.path_nstage AS ath_nstage_to_review, ed.path_mstage AS ath_mstage_to_review
FROM participants AS p
INNER JOIN event_masters AS em ON em.participant_id = p.id AND em.deleted <> 1
INNER JOIN ed_cap_report_pancreasendos as ed ON ed.event_master_id = em.id
WHERE (ed.path_tstage IS NOT NULL AND ed.path_tstage NOT LIKE '')
OR (ed.path_nstage IS NOT NULL AND ed.path_nstage NOT LIKE '')
OR (ed.path_mstage IS NOT NULL AND ed.path_mstage NOT LIKE '');

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

SELECT 'intra hepato bile duct' AS msg;

SELECT p.id AS participant_id, p.participant_identifier AS no_bank, ed.tumour_grade AS tumour_grade_to_review, ed.path_tstage AS ath_tstage_to_review, ed.path_nstage AS ath_nstage_to_review, ed.path_mstage AS ath_mstage_to_review
FROM participants AS p
INNER JOIN event_masters AS em ON em.participant_id = p.id AND em.deleted <> 1
INNER JOIN ed_cap_report_intrahepbileducts as ed ON ed.event_master_id = em.id
WHERE (ed.tumour_grade IS NOT NULL AND ed.tumour_grade NOT LIKE '')
OR (ed.path_tstage IS NOT NULL AND ed.path_tstage NOT LIKE '')
OR (ed.path_nstage IS NOT NULL AND ed.path_nstage NOT LIKE '')
OR (ed.path_mstage IS NOT NULL AND ed.path_mstage NOT LIKE '');

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

SELECT 'hepatocellular carcinomas' AS msg;

SELECT p.id AS participant_id, p.participant_identifier AS no_bank, ed.tumour_grade AS tumour_grade_to_review, ed.path_tstage AS ath_tstage_to_review, ed.path_nstage AS ath_nstage_to_review, ed.path_mstage AS ath_mstage_to_review
FROM participants AS p
INNER JOIN event_masters AS em ON em.participant_id = p.id AND em.deleted <> 1
INNER JOIN ed_cap_report_hepatocellular_carcinomas as ed ON ed.event_master_id = em.id
WHERE (ed.tumour_grade IS NOT NULL AND ed.tumour_grade NOT LIKE '')
OR (ed.path_tstage IS NOT NULL AND ed.path_tstage NOT LIKE '')
OR (ed.path_nstage IS NOT NULL AND ed.path_nstage NOT LIKE '')
OR (ed.path_mstage IS NOT NULL AND ed.path_mstage NOT LIKE '');

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

SELECT 'gallbladders' AS msg;

SELECT p.id AS participant_id, p.participant_identifier AS no_bank, ed.tumour_grade AS tumour_grade_to_review, ed.path_tstage AS ath_tstage_to_review, ed.path_nstage AS ath_nstage_to_review, ed.path_mstage AS ath_mstage_to_review
FROM participants AS p
INNER JOIN event_masters AS em ON em.participant_id = p.id AND em.deleted <> 1
INNER JOIN ed_cap_report_gallbladders as ed ON ed.event_master_id = em.id
WHERE (ed.tumour_grade IS NOT NULL AND ed.tumour_grade NOT LIKE '')
OR (ed.path_tstage IS NOT NULL AND ed.path_tstage NOT LIKE '')
OR (ed.path_nstage IS NOT NULL AND ed.path_nstage NOT LIKE '')
OR (ed.path_mstage IS NOT NULL AND ed.path_mstage NOT LIKE '');

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

SELECT 'distal ex bile ducts' AS msg;

SELECT p.id AS participant_id, p.participant_identifier AS no_bank, ed.tumour_grade AS tumour_grade_to_review, ed.path_tstage AS ath_tstage_to_review, ed.path_nstage AS ath_nstage_to_review, ed.path_mstage AS ath_mstage_to_review
FROM participants AS p
INNER JOIN event_masters AS em ON em.participant_id = p.id AND em.deleted <> 1
INNER JOIN ed_cap_report_distalexbileducts as ed ON ed.event_master_id = em.id
WHERE (ed.tumour_grade IS NOT NULL AND ed.tumour_grade NOT LIKE '')
OR (ed.path_tstage IS NOT NULL AND ed.path_tstage NOT LIKE '')
OR (ed.path_nstage IS NOT NULL AND ed.path_nstage NOT LIKE '')
OR (ed.path_mstage IS NOT NULL AND ed.path_mstage NOT LIKE '');

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

SELECT 'ampullas' AS msg;

SELECT p.id AS participant_id, p.participant_identifier AS no_bank, ed.tumour_grade AS tumour_grade_to_review, ed.path_tstage AS ath_tstage_to_review, ed.path_nstage AS ath_nstage_to_review, ed.path_mstage AS ath_mstage_to_review
FROM participants AS p
INNER JOIN event_masters AS em ON em.participant_id = p.id AND em.deleted <> 1
INNER JOIN ed_cap_report_ampullas as ed ON ed.event_master_id = em.id
WHERE (ed.tumour_grade IS NOT NULL AND ed.tumour_grade NOT LIKE '')
OR (ed.path_tstage IS NOT NULL AND ed.path_tstage NOT LIKE '')
OR (ed.path_nstage IS NOT NULL AND ed.path_nstage NOT LIKE '')
OR (ed.path_mstage IS NOT NULL AND ed.path_mstage NOT LIKE '');

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

SELECT 'ed_cap_report_colon_rectum_resections' AS msg;

SELECT p.id AS participant_id, p.participant_identifier AS no_bank, ed.tumour_grade AS tumour_grade_to_review, ed.path_tstage AS ath_tstage_to_review, ed.path_nstage AS ath_nstage_to_review, ed.path_mstage AS ath_mstage_to_review
FROM participants AS p
INNER JOIN event_masters AS em ON em.participant_id = p.id AND em.deleted <> 1
INNER JOIN ed_cap_report_colon_rectum_resections as ed ON ed.event_master_id = em.id
WHERE (ed.tumour_grade IS NOT NULL AND ed.tumour_grade NOT LIKE '')
OR (ed.path_tstage IS NOT NULL AND ed.path_tstage NOT LIKE '')
OR (ed.path_nstage IS NOT NULL AND ed.path_nstage NOT LIKE '')
OR (ed.path_mstage IS NOT NULL AND ed.path_mstage NOT LIKE '');

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
-- End TNM Clean Up
-- ---------------------------------------------------------------------------

-- rubbia-brants and blazer

INSERT INTO `structure_value_domains` VALUES 
(null,'qc_hb_rubbia_brandt_values','open','',NULL),
(null,'qc_hb_blazer_values','open','',NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES 
("1","1"),("2","2"),("3","3"),("4","4"),("5","5"),
("complete","complete"),("major","major"),("minor","minor");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="qc_hb_blazer_values"),  
(SELECT id FROM structure_permissible_values WHERE value="complete" AND language_alias="complete"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_hb_blazer_values"),  
(SELECT id FROM structure_permissible_values WHERE value="major" AND language_alias="major"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_hb_blazer_values"),  
(SELECT id FROM structure_permissible_values WHERE value="minor" AND language_alias="minor"), "3", "1"),

((SELECT id FROM structure_value_domains WHERE domain_name="qc_hb_rubbia_brandt_values"),  
(SELECT id FROM structure_permissible_values WHERE value="1" AND language_alias="1"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_hb_rubbia_brandt_values"),  
(SELECT id FROM structure_permissible_values WHERE value="2" AND language_alias="2"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_hb_rubbia_brandt_values"),  
(SELECT id FROM structure_permissible_values WHERE value="3" AND language_alias="3"), "3", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_hb_rubbia_brandt_values"),  
(SELECT id FROM structure_permissible_values WHERE value="4" AND language_alias="4"), "4", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_hb_rubbia_brandt_values"),  
(SELECT id FROM structure_permissible_values WHERE value="5" AND language_alias="5"), "5", "1");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventDetail', 'qc_hb_ed_lab_report_liver_metastases', 'rubbia_brandt', 'select',  (SELECT id FROM structure_value_domains WHERE domain_name="qc_hb_rubbia_brandt_values"), '0', '', '', '', 'rubbia brandt', ''), 
('Clinicalannotation', 'EventDetail', 'qc_hb_ed_lab_report_liver_metastases', 'blazer', 'select',  (SELECT id FROM structure_value_domains WHERE domain_name="qc_hb_blazer_values") , '0', '', '', '', 'blazer', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_hb_ed_lab_report_liver_metastases'), (SELECT id FROM structure_fields WHERE `tablename`='qc_hb_ed_lab_report_liver_metastases' AND `field`='rubbia_brandt'), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_ed_lab_report_liver_metastases'), (SELECT id FROM structure_fields WHERE `tablename`='qc_hb_ed_lab_report_liver_metastases' AND `field`='blazer'), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

ALTER TABLE qc_hb_ed_lab_report_liver_metastases 
  ADD COLUMN rubbia_brandt varchar(20) DEFAULT NULL AFTER necrosis_perc_list,
  ADD COLUMN blazer varchar(20) DEFAULT NULL AFTER rubbia_brandt;

ALTER TABLE qc_hb_ed_lab_report_liver_metastases_revs
  ADD COLUMN rubbia_brandt varchar(20) DEFAULT NULL AFTER necrosis_perc_list,
  ADD COLUMN blazer varchar(20) DEFAULT NULL AFTER rubbia_brandt;

-- ---------------------------------------------------------------------------------------------------
-- CAP report 
-- ---------------------------------------------------------------------------------------------------

-- CAP report field clean up (added to trunk)
-- Hepatocellular Carcinoma
REPLACE INTO i18n (id,en) VALUES
('lymph vascular large vessel invasion','Macroscopic Venous (Large Vessel) Invasion (V)'),
('lymph vascular small vessel invasion','Microscopic (Small Vessel) Invasion (L)');
UPDATE structure_formats SET language_heading = 'perineural invasion' WHERE structure_id = (SELECT id FROM structures WHERE alias='ed_cap_report_hepatocellular_carcinomas') AND structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'perineural_invasion');
-- Pancreas endo & exo
ALTER TABLE  `ed_cap_report_pancreasendos` CHANGE `promimal_pancreatic_margin` `proximal_pancreatic_margin` tinyint(1) DEFAULT '0';
ALTER TABLE  `ed_cap_report_pancreasendos_revs` CHANGE `promimal_pancreatic_margin` `proximal_pancreatic_margin` tinyint(1) DEFAULT '0';
ALTER TABLE  `ed_cap_report_pancreasexos` CHANGE `promimal_pancreatic_margin` `proximal_pancreatic_margin` tinyint(1) DEFAULT '0';
ALTER TABLE  `ed_cap_report_pancreasexos_revs` CHANGE `promimal_pancreatic_margin` `proximal_pancreatic_margin` tinyint(1) DEFAULT '0';
UPDATE structure_fields SET field = 'proximal_pancreatic_margin', language_label = 'proximal pancreatic margin' WHERE field = 'promimal_pancreatic_margin';
INSERT IGNORE INTO i18n (id,en) VALUE ('proximal pancreatic margin','Proximal Pancreatic Margin');

-- ---------------------------------------------------------------------------------------------------
-- End Cap Report
-- ---------------------------------------------------------------------------------------------------

REPLACE INTO i18n (id,en,fr) VALUES ('other localisations','Other Locations','Autre Localisations');

UPDATE event_controls SET form_alias = CONCAT(form_alias, ',qc_hb_pancreas') WHERE event_type IN ('medical imaging abdominal ultrasound','medical imaging TEP-scan');
SET @last_structure_id = (SELECT id FROM structures WHERE alias = 'qc_hb_other_localisations');
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES 
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'bile_ducts_number', 'bile ducts', 'number', 'integer_positive', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'bile_ducts_size', '', 'size', 'float_positive', '', '', NULL, '', '', '', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
(@last_structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_hepatobilary_medical_imagings' AND `field`='bile_ducts_number'), '1', '61', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1'), 
(@last_structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_hepatobilary_medical_imagings' AND `field`='bile_ducts_size'), '1', '61', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1');
ALTER TABLE `qc_hb_ed_hepatobilary_medical_imagings` 
  ADD COLUMN `bile_ducts_number` smallint(5) unsigned DEFAULT NULL AFTER rectum_size,
  ADD COLUMN `bile_ducts_size` decimal(6,2) DEFAULT NULL AFTER bile_ducts_number;
ALTER TABLE `qc_hb_ed_hepatobilary_medical_imagings_revs` 
  ADD COLUMN `bile_ducts_number` smallint(5) unsigned DEFAULT NULL AFTER rectum_size,
  ADD COLUMN `bile_ducts_size` decimal(6,2) DEFAULT NULL AFTER bile_ducts_number;
INSERT INTO i18n (id,en,fr) VALUES ('bile ducts','Bile Ducts','Voies biliaires');

INSERT INTO `protocol_controls` (`id`, `tumour_group`, `type`, `detail_tablename`, `form_alias`, `extend_tablename`, `extend_form_alias`, `created`, `created_by`, `modified`, `modified_by`, `flag_active`) VALUES
(null, 'all', 'radiotherapy', 'qc_hb_pd_radios', 'qc_hb_pd_radios', NULL, NULL, NULL, 0, NULL, 0, 1);
INSERT INTO structures (`alias`) VALUES ('qc_hb_pd_radios');
SET @last_structure_id = (SELECT id FROM structures WHERE alias = 'qc_hb_pd_radios');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) 
(SELECT @last_structure_id, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary` FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias = 'pd_surgeries')); 
CREATE TABLE IF NOT EXISTS `qc_hb_pd_radios` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `protocol_master_id` int(11) DEFAULT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `FK_qc_hb_pd_radios_protocol_masters` (`protocol_master_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=45 ;
CREATE TABLE IF NOT EXISTS `qc_hb_pd_radios_revs` (
  `id` int(11) NOT NULL,
  `protocol_master_id` int(11) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=47 ;
ALTER TABLE `qc_hb_pd_radios`
  ADD CONSTRAINT `FK_qc_hb_pd_radios_protocol_masters` FOREIGN KEY (`protocol_master_id`) REFERENCES `protocol_masters` (`id`);
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('radiotherapy','Radiotherapy','Radio-thérapie');

INSERT INTO `protocol_controls` (`id`, `tumour_group`, `type`, `detail_tablename`, `form_alias`, `extend_tablename`, `extend_form_alias`, `created`, `created_by`, `modified`, `modified_by`, `flag_active`) VALUES
(null, 'all', 'other', 'qc_hb_pd_others', 'qc_hb_pd_others', NULL, NULL, NULL, 0, NULL, 0, 1);
INSERT INTO structures (`alias`) VALUES ('qc_hb_pd_others');
SET @last_structure_id = (SELECT id FROM structures WHERE alias = 'qc_hb_pd_others');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) 
(SELECT @last_structure_id, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary` FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias = 'pd_surgeries')); 
CREATE TABLE IF NOT EXISTS `qc_hb_pd_others` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `protocol_master_id` int(11) DEFAULT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `FK_qc_hb_pd_others_protocol_masters` (`protocol_master_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=45 ;
CREATE TABLE IF NOT EXISTS `qc_hb_pd_others_revs` (
  `id` int(11) NOT NULL,
  `protocol_master_id` int(11) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=47 ;
ALTER TABLE `qc_hb_pd_others`
  ADD CONSTRAINT `FK_qc_hb_pd_others_protocol_masters` FOREIGN KEY (`protocol_master_id`) REFERENCES `protocol_masters` (`id`);
UPDATE structure_formats SET `flag_add`='0', `flag_add_readonly`='0', `flag_edit`='0', `flag_edit_readonly`='0', `flag_search`='0', `flag_search_readonly`='0', `flag_addgrid`='0', `flag_addgrid_readonly`='0', `flag_editgrid`='0', `flag_editgrid_readonly`='0', `flag_batchedit`='0', `flag_batchedit_readonly`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE model = 'ProtocolControl' AND field = 'tumour_group');

INSERT INTO `treatment_controls` (`id`, `tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `form_alias`, `extend_tablename`, `extend_form_alias`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`) VALUES
(null, 'radiotherapy', 'other', 1, 'qc_hb_txd_others', 'treatmentmasters,qc_hb_txd_others', NULL, NULL, 0, NULL, NULL, 'other|radiotherapy');
UPDATE treatment_controls SET form_alias = CONCAT(form_alias, ',qc_hb_txd_other_protocols') WHERE disease_site = 'other' AND tx_method IN ('chemotherapy','treatment','radiotherapy');
INSERT INTO structures (`alias`) VALUES ('qc_hb_txd_other_protocols');
SET @last_structure_id = (SELECT id FROM structures WHERE alias = 'qc_hb_txd_other_protocols');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) 
(SELECT @last_structure_id, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary` FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias = 'qc_hb_tx_chemos') AND structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'protocol_master_id')); 
UPDATE treatment_controls SET applied_protocol_control_id = (SELECT id FROM protocol_controls WHERE type = 'chemotherapy') WHERE tx_method = 'chemotherapy' AND disease_site = 'other';
UPDATE treatment_controls SET applied_protocol_control_id = (SELECT id FROM protocol_controls WHERE type = 'radiotherapy') WHERE tx_method = 'radiotherapy' AND disease_site = 'other';
UPDATE treatment_controls SET applied_protocol_control_id = (SELECT id FROM protocol_controls WHERE type = 'other') WHERE tx_method = 'treatment' AND disease_site = 'other';
UPDATE treatment_controls SET applied_protocol_control_id = (SELECT id FROM protocol_controls WHERE type = 'chemotherapy') WHERE tx_method = 'chemotherapy' AND disease_site = 'hepatobiliary';
UPDATE treatment_controls SET applied_protocol_control_id = (SELECT id FROM protocol_controls WHERE type = 'chemotherapy') WHERE tx_method = 'chemo-embolization' AND disease_site = 'hepatobiliary';
UPDATE treatment_controls SET extend_tablename = 'txe_chemos', extend_form_alias = 'txe_chemos', extended_data_import_process = 'importDrugFromChemoProtocol' WHERE applied_protocol_control_id = (SELECT id FROM protocol_controls WHERE type = 'chemotherapy');

ALTER TABLE `qc_hb_txd_surgery_pancreas` CHANGE `wisung_diameter` `wirsung_diameter` smallint(5) unsigned DEFAULT NULL;
ALTER TABLE `qc_hb_txd_surgery_pancreas_revs` CHANGE `wisung_diameter` `wirsung_diameter` smallint(5) unsigned DEFAULT NULL;
UPDATE structure_fields SET field = 'wirsung_diameter', language_label = 'wirsung diameter' WHERE field = 'wisung_diameter';
INSERT INTO i18n (id,en,fr) VALUES ('wirsung diameter','Wirsung Diameter','Diam. Wirsung');






