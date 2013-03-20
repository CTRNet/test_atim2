UPDATE `versions` SET branch_build_number = '5161' WHERE version_number = '2.5.4';

UPDATE templates SET created_by = 14 WHERE name IN ('prostate-blood','prostate-urine','prostate-tissu');

SET @coll_id = (SELECT id FROM datamart_structures WHERE model = 'ViewCollection');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE id1 =  @coll_id AND id2 IN (SELECT id FROM datamart_structures WHERE model IN ('DiagnosisMaster','TreatmentMaster','EventMaster'));
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE id2 =  @coll_id AND id1 IN (SELECT id FROM datamart_structures WHERE model IN ('DiagnosisMaster','TreatmentMaster','EventMaster'));

UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='consent_type_list') ,  `language_label`='consent' WHERE model='ConsentMaster' AND tablename='consent_masters' AND field='consent_control_id' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='consent_type_list');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisControl' AND `tablename`='diagnosis_controls' AND `field`='category' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='diagnosis_category') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisControl' AND `tablename`='diagnosis_controls' AND `field`='controls_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='diagnosis_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='topography' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_label`='0', `language_label`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='consent_type_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentControl' AND `tablename`='treatment_controls' AND `field`='tx_method' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_method_site_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentControl' AND `tablename`='treatment_controls' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_disease_site_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='start_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_tag`='0', `language_tag`='', `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='event_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_type_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_tag`='0', `language_tag`='', `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_disease_site_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- SARDO TABLE DELETION

-- event

DROP TABLE qc_nd_ed_biopsy;
DROP TABLE qc_nd_ed_cytology;
DROP TABLE qc_nd_ed_ca125s;
DROP TABLE qc_nd_ed_pathologies;
DROP TABLE qc_nd_ed_observations;
DROP TABLE qc_nd_ed_patho_prostates;
DROP TABLE qc_nd_ed_aps_prostates;
DROP TABLE qc_nd_ed_ovary_pathologies;

DROP TABLE qc_nd_ed_biopsy_revs;
DROP TABLE qc_nd_ed_cytology_revs;
DROP TABLE qc_nd_ed_ca125s_revs;
DROP TABLE qc_nd_ed_pathologies_revs;
DROP TABLE qc_nd_ed_observations_revs;
DROP TABLE qc_nd_ed_patho_prostates_revs;
DROP TABLE qc_nd_ed_aps_prostates_revs;
DROP TABLE qc_nd_ed_ovary_pathologies_revs;

DELETE FROM structure_formats WHERE structure_id IN (SELECT id FROM structures WHERE alias IN ('qc_nd_ed_biopsy', 'qc_nd_ed_cytology', 'qc_nd_ed_common','qc_nd_ed_cytology,qc_nd_ed_common','qc_nd_ed_ca125','qc_nd_ed_pathologies','qc_nd_ed_patho_prostates','qc_nd_ed_ovary_pathologies'));
DELETE FROM structures WHERE alias IN ('qc_nd_ed_biopsy', 'qc_nd_ed_cytology', 'qc_nd_ed_common','qc_nd_ed_cytology,qc_nd_ed_common','qc_nd_ed_ca125','qc_nd_ed_pathologies','qc_nd_ed_patho_prostates','qc_nd_ed_ovary_pathologies');
DELETE FROM structure_fields WHERE tablename IN ('qc_nd_ed_biopsy', 
'qc_nd_ed_cytology', 
'qc_nd_ed_ca125s', 
'qc_nd_ed_pathologies', 
'qc_nd_ed_observations', 
'qc_nd_ed_patho_prostates', 
'qc_nd_ed_aps_prostates', 
'qc_nd_ed_ovary_pathologies');

DELETE FROM event_masters WHERE event_control_id IN (SELECT id FROM event_controls WHERE flag_active = 0);
DELETE FROM event_masters_revs WHERE event_control_id IN (SELECT id FROM event_controls WHERE flag_active = 0);
DELETE FROM event_controls WHERE flag_active = 0;

-- treatment

DROP TABLE qc_nd_txd_hormonotherapies;
DROP TABLE qc_nd_txd_medications;
DROP TABLE qc_nd_txd_immunotherapy;
DROP TABLE qc_nd_txd_unclassifieds;

DROP TABLE qc_nd_txd_hormonotherapies_revs;
DROP TABLE qc_nd_txd_medications_revs;
DROP TABLE qc_nd_txd_immunotherapy_revs;
DROP TABLE qc_nd_txd_unclassifieds_revs;

DELETE FROM structure_formats WHERE structure_id IN (SELECT id FROM structures WHERE alias IN (
'qc_nd_txd_hormonotherapies',
'qc_nd_txd_medications',
'qc_nd_txd_ovary_surgery',
'qc_nd_txd_prostate_surgery',
'qc_nd_txd_breast_surgery',
'qc_nd_txd_immunotherapy'
));
DELETE FROM structures WHERE alias IN (
'qc_nd_txd_hormonotherapies',
'qc_nd_txd_medications',
'qc_nd_txd_ovary_surgery',
'qc_nd_txd_prostate_surgery',
'qc_nd_txd_breast_surgery',
'qc_nd_txd_immunotherapy'
);
DELETE FROM structure_fields WHERE tablename IN ('qc_nd_txd_hormonotherapies','qc_nd_txd_medications','qc_nd_txd_immunotherapy','qc_nd_txd_unclassifieds');

DELETE FROM treatment_masters WHERE treatment_control_id IN (SELECT id FROM treatment_controls WHERE flag_active = 0 AND id > 4);
DELETE FROM treatment_masters_revs WHERE treatment_control_id IN (SELECT id FROM treatment_controls WHERE flag_active = 0 AND id > 4);
DELETE FROM treatment_controls WHERE flag_active = 0 AND id > 4;

-- protocol

DROP TABLE IF EXISTS qc_nd_pd_sardo_radiations;
DROP TABLE IF EXISTS qc_nd_pd_sardo_chemotherapies;
DROP TABLE IF EXISTS qc_nd_proto_hormonotherapies;
DROP TABLE IF EXISTS qc_nd_proto_radiotherapies;
DROP TABLE IF EXISTS qc_nd_proto_mixes;

DROP TABLE IF EXISTS qc_nd_pd_sardo_radiations_revs;
DROP TABLE IF EXISTS qc_nd_pd_sardo_chemotherapies_revs;
DROP TABLE IF EXISTS qc_nd_proto_hormonotherapies_revs;
DROP TABLE IF EXISTS qc_nd_proto_radiotherapies_revs;
DROP TABLE IF EXISTS qc_nd_proto_mixes_revs;

DELETE FROM structure_formats WHERE structure_id IN (SELECT id FROM structures WHERE alias IN ('qc_nd_pd_sardo_radiations','qc_nd_pd_sardo_chemotherapies'));
DELETE FROM structures WHERE alias IN ('qc_nd_pd_sardo_radiations','qc_nd_pd_sardo_chemotherapies');
DELETE FROM structure_fields WHERE tablename IN ('qc_nd_pd_sardo_radiations','qc_nd_pd_sardo_chemotherapies','qc_nd_proto_hormonotherapies','qc_nd_proto_radiotherapies','qc_nd_proto_mixes');

DELETE FROM protocol_masters;
DELETE FROM protocol_masters_revs;
DELETE FROM protocol_controls WHERE id > 2;

-- diagnosis

DROP TABLE IF EXISTS qc_nd_dxd_primary_sardos;
DROP TABLE IF EXISTS qc_nd_dxd_primary_sardos_revs;
DROP TABLE IF EXISTS qc_nd_dx_progression_sardos;
DROP TABLE IF EXISTS qc_nd_dx_progression_sardos_revs; 
DROP TABLE IF EXISTS qc_nd_dx_primary_sardo;
DROP TABLE IF EXISTS qc_nd_dx_primary_sardo_revs; 

DELETE FROM structure_formats WHERE structure_id IN (SELECT id FROM structures WHERE alias IN ('qc_nd_dxd_primary_sardos', 'qc_nd_dx_primary_sardo', 'qc_nd_dx_progression_sardos'));
DELETE FROM structures WHERE alias IN ('qc_nd_dxd_primary_sardos', 'qc_nd_dx_primary_sardo', 'qc_nd_dx_progression_sardos');
DELETE FROM structure_fields WHERE tablename IN ('qc_nd_dxd_primary_sardos', 'qc_nd_dx_primary_sardo', 'qc_nd_dx_progression_sardos');

DELETE FROM diagnosis_masters WHERE diagnosis_control_id IN (SELECT id FROM diagnosis_controls WHERE flag_active = 0 AND id > 18);
DELETE FROM diagnosis_masters_revs WHERE diagnosis_control_id IN (SELECT id FROM diagnosis_controls WHERE flag_active = 0 AND id > 18);
DELETE FROM diagnosis_controls WHERE flag_active = 0 AND id > 18;

-- other

DROP TABLE IF EXISTS qc_nd_protocol_behaviors;
DROP TABLE IF EXISTS qc_nd_sardo_conflicts;
DROP TABLE IF EXISTS qc_nd_sardo_tx_conf_surgeries;

DROP TABLE IF EXISTS qc_nd_protocol_behaviors_revs;
DROP TABLE IF EXISTS qc_nd_sardo_conflicts_revs;
DROP TABLE IF EXISTS qc_nd_sardo_tx_conf_surgeries_revs;
