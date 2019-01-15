-- Set variables for any data update.
-- ### TODO # Please update user id if required

SET @modifiedBy = (SELECT id FROM users WHERE id = 1);
SET @modified = (SELECT NOW() FROM users WHERE id = 1);

-- ---------------------------------------------------------------------------------------------------------------
-- Database tables clean up based on ATiM Tool Database Validation Script
-- --------------------------------------------------------------------------------------------------------------- 

ALTER TABLE cd_breasts DROP COLUMN id,
DROP COLUMN created,
DROP COLUMN created_by,
DROP COLUMN modified,
DROP COLUMN modified_by,
DROP COLUMN deleted;
ALTER TABLE cd_clls DROP COLUMN id,
DROP COLUMN created,
DROP COLUMN created_by,
DROP COLUMN modified,
DROP COLUMN modified_by,
DROP COLUMN deleted;
ALTER TABLE cd_headnecks DROP COLUMN id,
DROP COLUMN created,
DROP COLUMN created_by,
DROP COLUMN modified,
DROP COLUMN modified_by,
DROP COLUMN deleted;
ALTER TABLE cd_lungs DROP COLUMN id,
DROP COLUMN created,
DROP COLUMN created_by,
DROP COLUMN modified,
DROP COLUMN modified_by,
DROP COLUMN deleted;
ALTER TABLE cd_mmys DROP COLUMN id,
DROP COLUMN created,
DROP COLUMN created_by,
DROP COLUMN modified,
DROP COLUMN modified_by,
DROP COLUMN deleted;
ALTER TABLE cd_ovarians DROP COLUMN id,
DROP COLUMN created,
DROP COLUMN created_by,
DROP COLUMN modified,
DROP COLUMN modified_by,
DROP COLUMN deleted;
ALTER TABLE cd_prostates DROP COLUMN id,
DROP COLUMN created,
DROP COLUMN created_by,
DROP COLUMN modified,
DROP COLUMN modified_by,
DROP COLUMN deleted;

UPDATE ed_all_clinical_comorbidities SET related_surgery_date = null WHERE CAST(related_surgery_date AS CHAR(10)) = '0000-00-00';
ALTER TABLE ed_all_clinical_comorbidities
MODIFY `related_surgery_date` date DEFAULT NULL,
DROP COLUMN id,
DROP COLUMN created,
DROP COLUMN created_by,
DROP COLUMN modified,
DROP COLUMN modified_by,
DROP COLUMN deleted;

ALTER TABLE ed_all_cptp_biosamplesurveys DROP COLUMN id,
DROP COLUMN created,
DROP COLUMN created_by,
DROP COLUMN modified,
DROP COLUMN modified_by,
DROP COLUMN deleted;
ALTER TABLE ed_all_cptp_physicalmeasures DROP COLUMN id,
DROP COLUMN created,
DROP COLUMN created_by,
DROP COLUMN modified,
DROP COLUMN modified_by,
DROP COLUMN deleted;

UPDATE ed_breast_clinical_followups SET cht_checked = null WHERE CAST(cht_checked AS CHAR(10)) = '0000-00-00';
UPDATE ed_breast_clinical_followups SET dod = null WHERE CAST(dod AS CHAR(10)) = '0000-00-00';
UPDATE ed_breast_clinical_followups SET banked_date = null WHERE CAST(banked_date AS CHAR(10)) = '0000-00-00';
UPDATE ed_breast_clinical_followups SET last_seen = null WHERE CAST(last_seen AS CHAR(10)) = '0000-00-00';
UPDATE ed_breast_clinical_followups SET dx_date = null WHERE CAST(dx_date AS CHAR(20)) = '0000-00-00 00:00:00';
ALTER TABLE ed_breast_clinical_followups 
MODIFY `cht_checked` date DEFAULT NULL,
DROP COLUMN id,
DROP COLUMN created,
DROP COLUMN created_by,
DROP COLUMN modified,
DROP COLUMN modified_by,
DROP COLUMN deleted;

UPDATE ed_breast_clinical_presentations SET date_noticed = null WHERE CAST(date_noticed AS CHAR(10)) = '0000-00-00';
UPDATE ed_breast_clinical_presentations SET first_consult_date = null WHERE CAST(first_consult_date AS CHAR(10)) = '0000-00-00';
ALTER TABLE ed_breast_clinical_presentations 
MODIFY `date_noticed` date DEFAULT NULL,
MODIFY `first_consult_date` date DEFAULT NULL,
DROP COLUMN id,
DROP COLUMN created,
DROP COLUMN created_by,
DROP COLUMN modified,
DROP COLUMN modified_by,
DROP COLUMN deleted;
  
UPDATE ed_cll_clinical_comorbidities SET cll_surgery_date = null WHERE CAST(cll_surgery_date AS CHAR(10)) = '0000-00-00';
ALTER TABLE ed_cll_clinical_comorbidities 
MODIFY `cll_surgery_date` date DEFAULT NULL,
DROP COLUMN id,
DROP COLUMN created,
DROP COLUMN created_by,
DROP COLUMN modified,
DROP COLUMN modified_by,
DROP COLUMN deleted;

ALTER TABLE ed_cll_clinical_complications DROP COLUMN id,
DROP COLUMN created,
DROP COLUMN created_by,
DROP COLUMN modified,
DROP COLUMN modified_by,
DROP COLUMN deleted;
ALTER TABLE ed_cll_clinical_controlfus DROP COLUMN id,
DROP COLUMN created,
DROP COLUMN created_by,
DROP COLUMN modified,
DROP COLUMN modified_by,
DROP COLUMN deleted;

UPDATE ed_cll_clinical_followups SET cll_dod = null WHERE CAST(cll_dod AS CHAR(10)) = '0000-00-00';
UPDATE ed_cll_clinical_followups SET cll_lab_report_date = null WHERE CAST(cll_lab_report_date AS CHAR(10)) = '0000-00-00';
UPDATE ed_cll_clinical_followups SET cll_sample_received_date = null WHERE CAST(cll_sample_received_date AS CHAR(10)) = '0000-00-00';
ALTER TABLE ed_cll_clinical_followups 
MODIFY `cll_sample_received_date` date DEFAULT NULL,
MODIFY `cll_dod` date DEFAULT NULL,
MODIFY `cll_lab_report_date` date DEFAULT NULL,
DROP COLUMN id,
DROP COLUMN created,
DROP COLUMN created_by,
DROP COLUMN modified,
DROP COLUMN modified_by,
DROP COLUMN deleted;

UPDATE ed_cll_clinical_presentations SET cll_lab_report_date = null WHERE CAST(cll_lab_report_date AS CHAR(10)) = '0000-00-00';
UPDATE ed_cll_clinical_presentations SET cll_sample_received_date = null WHERE CAST(cll_sample_received_date AS CHAR(10)) = '0000-00-00';
ALTER TABLE ed_cll_clinical_presentations DROP COLUMN id,
MODIFY `cll_sample_received_date` date DEFAULT NULL,
MODIFY `cll_lab_report_date` date DEFAULT NULL,
DROP COLUMN created,
DROP COLUMN created_by,
DROP COLUMN modified,
DROP COLUMN modified_by,
DROP COLUMN deleted;

UPDATE ed_cll_lab_reports SET cll_lab_report_date = null WHERE CAST(cll_lab_report_date AS CHAR(10)) = '0000-00-00';
UPDATE ed_cll_lab_reports SET cll_sample_received_date = null WHERE CAST(cll_sample_received_date AS CHAR(10)) = '0000-00-00';
ALTER TABLE ed_cll_lab_reports DROP COLUMN id,
MODIFY `cll_sample_received_date` date DEFAULT NULL,
MODIFY `cll_lab_report_date` date DEFAULT NULL,
DROP COLUMN created,
DROP COLUMN created_by,
DROP COLUMN modified,
DROP COLUMN modified_by,
DROP COLUMN deleted;

ALTER TABLE ed_lung_clinical_followups DROP COLUMN created,
DROP COLUMN created_by,
DROP COLUMN modified,
DROP COLUMN modified_by,
DROP COLUMN deleted;
ALTER TABLE ed_lung_clinical_presentations DROP COLUMN created,
DROP COLUMN created_by,
DROP COLUMN modified,
DROP COLUMN modified_by,
DROP COLUMN deleted;
ALTER TABLE ed_lung_lab_pathologies DROP COLUMN created,
DROP COLUMN created_by,
DROP COLUMN modified,
DROP COLUMN modified_by,
DROP COLUMN deleted;
ALTER TABLE ed_mmy_clinical_followups DROP COLUMN id,
DROP COLUMN created,
DROP COLUMN created_by,
DROP COLUMN modified,
DROP COLUMN modified_by,
DROP COLUMN deleted;
ALTER TABLE ed_mmy_clinical_presentations DROP COLUMN id,
DROP COLUMN created,
DROP COLUMN created_by,
DROP COLUMN modified,
DROP COLUMN modified_by,
DROP COLUMN deleted;
ALTER TABLE ed_mmy_imaging_skeletalsurveys DROP COLUMN id,
DROP COLUMN created,
DROP COLUMN created_by,
DROP COLUMN modified,
DROP COLUMN modified_by,
DROP COLUMN deleted;
ALTER TABLE ed_mmy_lab_reports DROP COLUMN id,
DROP COLUMN created,
DROP COLUMN created_by,
DROP COLUMN modified,
DROP COLUMN modified_by,
DROP COLUMN deleted;

UPDATE ed_ovarian_clinical_followups SET cht_checked = null WHERE CAST(cht_checked AS CHAR(10)) = '0000-00-00';
ALTER TABLE ed_ovarian_clinical_followups DROP COLUMN id,
MODIFY `cht_checked` date DEFAULT NULL,
DROP COLUMN created,
DROP COLUMN created_by,
DROP COLUMN modified,
DROP COLUMN modified_by,
DROP COLUMN deleted;

UPDATE ed_ovarian_clinical_presentations SET initial_ca125_date = null WHERE CAST(initial_ca125_date AS CHAR(10)) = '0000-00-00';
UPDATE ed_ovarian_clinical_presentations SET date_noticed = null WHERE CAST(date_noticed AS CHAR(10)) = '0000-00-00';
UPDATE ed_ovarian_clinical_presentations SET first_consult_date = null WHERE CAST(first_consult_date AS CHAR(10)) = '0000-00-00';
ALTER TABLE ed_ovarian_clinical_presentations DROP COLUMN id,
MODIFY `initial_ca125_date` date DEFAULT NULL,
MODIFY `date_noticed` date DEFAULT NULL,
MODIFY `first_consult_date` date DEFAULT NULL,
DROP COLUMN created,
DROP COLUMN created_by,
DROP COLUMN modified,
DROP COLUMN modified_by,
DROP COLUMN deleted;

ALTER TABLE ed_prostate_clinical_followups DROP COLUMN created,
DROP COLUMN created_by,
DROP COLUMN modified,
DROP COLUMN modified_by,
DROP COLUMN deleted;
ALTER TABLE ed_prostate_lab_pathologies DROP COLUMN created,
DROP COLUMN created_by,
DROP COLUMN modified,
DROP COLUMN modified_by,
DROP COLUMN deleted;
ALTER TABLE ed_prostate_lab_tests DROP COLUMN created,
DROP COLUMN created_by,
DROP COLUMN modified,
DROP COLUMN modified_by,
DROP COLUMN deleted;
ALTER TABLE pd_hormos DROP COLUMN id,
DROP COLUMN created,
DROP COLUMN created_by,
DROP COLUMN modified,
DROP COLUMN modified_by,
DROP COLUMN deleted;
ALTER TABLE pd_others DROP COLUMN id,
DROP COLUMN created,
DROP COLUMN created_by,
DROP COLUMN modified,
DROP COLUMN modified_by,
DROP COLUMN deleted;
ALTER TABLE std_cabinets DROP COLUMN id,
DROP COLUMN deleted;
ALTER TABLE std_tiers DROP COLUMN id,
DROP COLUMN deleted;
ALTER TABLE txd_brachytherapies DROP COLUMN id,
DROP COLUMN created,
DROP COLUMN created_by,
DROP COLUMN modified,
DROP COLUMN modified_by,
DROP COLUMN deleted;
ALTER TABLE txd_hormonals DROP COLUMN id,
 DROP COLUMN created,
 DROP COLUMN created_by,
 DROP COLUMN modified,
 DROP COLUMN modified_by,
 DROP COLUMN deleted;
ALTER TABLE txd_immunos DROP COLUMN id,
DROP COLUMN created,
DROP COLUMN created_by,
DROP COLUMN modified,
DROP COLUMN modified_by,
DROP COLUMN deleted;
ALTER TABLE txd_others DROP COLUMN id,
DROP COLUMN created,
DROP COLUMN created_by,
DROP COLUMN modified,
DROP COLUMN modified_by,
DROP COLUMN deleted;

ALTER TABLE cd_breasts MODIFY consent_master_id int(11) NOT NULL;
ALTER TABLE cd_breasts ADD CONSTRAINT FK_cd_breasts_consent_masters FOREIGN KEY (consent_master_id) REFERENCES consent_masters (id);
ALTER TABLE cd_clls MODIFY consent_master_id int(11) NOT NULL;
ALTER TABLE cd_clls ADD CONSTRAINT FK_cd_clls_consent_masters FOREIGN KEY (consent_master_id) REFERENCES consent_masters (id);
ALTER TABLE cd_headnecks MODIFY consent_master_id int(11) NOT NULL;
ALTER TABLE cd_headnecks ADD CONSTRAINT FK_cd_headnecks_consent_masters FOREIGN KEY (consent_master_id) REFERENCES consent_masters (id);
ALTER TABLE cd_lungs MODIFY consent_master_id int(11) NOT NULL;
ALTER TABLE cd_lungs ADD CONSTRAINT FK_cd_lungs_consent_masters FOREIGN KEY (consent_master_id) REFERENCES consent_masters (id);
ALTER TABLE cd_mmys MODIFY consent_master_id int(11) NOT NULL;
ALTER TABLE cd_mmys ADD CONSTRAINT FK_cd_mmys_consent_masters FOREIGN KEY (consent_master_id) REFERENCES consent_masters (id);
ALTER TABLE cd_prostates MODIFY consent_master_id int(11) NOT NULL;
ALTER TABLE cd_prostates ADD CONSTRAINT FK_cd_prostates_consent_masters FOREIGN KEY (consent_master_id) REFERENCES consent_masters (id);
ALTER TABLE ed_all_clinical_comorbidities MODIFY event_master_id int(11) NOT NULL;
ALTER TABLE ed_all_cptp_biosamplesurveys MODIFY event_master_id int(11) NOT NULL;
ALTER TABLE ed_all_cptp_biosamplesurveys ADD CONSTRAINT FK_ed_all_cptp_biosamplesurveys_event_masters FOREIGN KEY (event_master_id) REFERENCES event_masters (id);
ALTER TABLE ed_all_cptp_physicalmeasures MODIFY event_master_id int(11) NOT NULL;
ALTER TABLE ed_all_cptp_physicalmeasures ADD CONSTRAINT FK_ed_all_cptp_physicalmeasures_event_masters FOREIGN KEY (event_master_id) REFERENCES event_masters (id);
ALTER TABLE ed_breast_clinical_followups MODIFY event_master_id int(11) NOT NULL;
ALTER TABLE ed_breast_clinical_presentations MODIFY event_master_id int(11) NOT NULL;
ALTER TABLE ed_cll_clinical_comorbidities MODIFY event_master_id int(11) NOT NULL;
ALTER TABLE ed_cll_clinical_complications MODIFY event_master_id int(11) NOT NULL;
ALTER TABLE ed_cll_clinical_controlfus MODIFY event_master_id int(11) NOT NULL;
ALTER TABLE ed_cll_clinical_followups MODIFY event_master_id int(11) NOT NULL;
ALTER TABLE ed_cll_clinical_presentations MODIFY event_master_id int(11) NOT NULL;
ALTER TABLE ed_cll_lab_reports MODIFY event_master_id int(11) NOT NULL;
ALTER TABLE ed_lung_clinical_followups MODIFY event_master_id int(11) NOT NULL;
ALTER TABLE ed_lung_clinical_presentations MODIFY event_master_id int(11) NOT NULL;
ALTER TABLE ed_lung_lab_pathologies MODIFY event_master_id int(11) NOT NULL;
ALTER TABLE ed_mmy_clinical_followups MODIFY event_master_id int(11) NOT NULL;
ALTER TABLE ed_mmy_clinical_followups ADD CONSTRAINT FK_ed_mmy_clinical_followups_event_masters FOREIGN KEY (event_master_id) REFERENCES event_masters (id);
ALTER TABLE ed_mmy_clinical_presentations MODIFY event_master_id int(11) NOT NULL;
ALTER TABLE ed_mmy_clinical_presentations ADD CONSTRAINT FK_ed_mmy_clinical_presentations_event_masters FOREIGN KEY (event_master_id) REFERENCES event_masters (id);
ALTER TABLE ed_mmy_imaging_skeletalsurveys MODIFY event_master_id int(11) NOT NULL;
ALTER TABLE ed_mmy_imaging_skeletalsurveys ADD CONSTRAINT FK_ed_mmy_imaging_skeletalsurveys_event_masters FOREIGN KEY (event_master_id) REFERENCES event_masters (id);
ALTER TABLE ed_mmy_lab_reports MODIFY event_master_id int(11) NOT NULL;
ALTER TABLE ed_ovarian_clinical_followups MODIFY event_master_id int(11) NOT NULL;
ALTER TABLE ed_ovarian_clinical_presentations MODIFY event_master_id int(11) NOT NULL;
ALTER TABLE ed_prostate_clinical_followups MODIFY event_master_id int(11) NOT NULL;
ALTER TABLE ed_prostate_lab_pathologies MODIFY event_master_id int(11) NOT NULL;
ALTER TABLE ed_prostate_lab_tests MODIFY event_master_id int(11) NOT NULL;
ALTER TABLE pd_hormos MODIFY protocol_master_id int(11) NOT NULL;
ALTER TABLE pd_others MODIFY protocol_master_id int(11) NOT NULL;
ALTER TABLE pd_others ADD CONSTRAINT FK_pd_others_protocol_masters FOREIGN KEY (protocol_master_id) REFERENCES protocol_masters (id);
ALTER TABLE std_cabinets MODIFY storage_master_id int(11) NOT NULL;
ALTER TABLE std_tiers MODIFY storage_master_id int(11) NOT NULL;
ALTER TABLE txd_hormonals MODIFY treatment_master_id int(11) NOT NULL;
ALTER TABLE txd_others MODIFY treatment_master_id int(11) NOT NULL;

CREATE TABLE `pd_others_revs` (
  `protocol_master_id` int(11) NOT NULL,
  `other_num_cycles` int(11) DEFAULT NULL,
  `other_length_cycles` int(11) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

SELECT "Deleted record unlinked to a consent_masters record into cd_ovarians : consent_master_id = 20956" AS 'To Validate';
DELETE FROM cd_ovarians WHERE consent_master_id = 20956;
ALTER TABLE cd_ovarians MODIFY consent_master_id int(11) NOT NULL;
ALTER TABLE cd_ovarians ADD CONSTRAINT FK_cd_ovarians_consent_masters FOREIGN KEY (consent_master_id) REFERENCES consent_masters (id);

ALTER TABLE cd_breasts_revs DROP COLUMN id, DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by,DROP COLUMN deleted;
ALTER TABLE cd_clls_revs DROP COLUMN id, DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by,DROP COLUMN deleted;
ALTER TABLE cd_headnecks_revs DROP COLUMN id, DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by,DROP COLUMN deleted;
ALTER TABLE cd_lungs_revs DROP COLUMN id, DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by,DROP COLUMN deleted;
ALTER TABLE cd_mmys_revs DROP COLUMN id, DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by,DROP COLUMN deleted;
ALTER TABLE cd_ovarians_revs DROP COLUMN id, DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by,DROP COLUMN deleted;
ALTER TABLE cd_prostates_revs DROP COLUMN id, DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by,DROP COLUMN deleted;

UPDATE ed_all_clinical_comorbidities_revs SET related_surgery_date = null WHERE CAST(related_surgery_date AS CHAR(10)) = '0000-00-00';
ALTER TABLE ed_all_clinical_comorbidities_revs MODIFY `related_surgery_date` date DEFAULT NULL, DROP COLUMN id, DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by,DROP COLUMN deleted;

ALTER TABLE ed_all_cptp_biosamplesurveys_revs DROP COLUMN id, DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by,DROP COLUMN deleted;
ALTER TABLE ed_all_cptp_physicalmeasures_revs DROP COLUMN id, DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by,DROP COLUMN deleted;

UPDATE ed_breast_clinical_followups_revs SET cht_checked = null WHERE CAST(cht_checked AS CHAR(10)) = '0000-00-00';
ALTER TABLE ed_breast_clinical_followups_revs  MODIFY `cht_checked` date DEFAULT NULL, DROP COLUMN id, DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by,DROP COLUMN deleted;

UPDATE ed_breast_clinical_presentations_revs SET date_noticed = null WHERE CAST(date_noticed AS CHAR(10)) = '0000-00-00';
UPDATE ed_breast_clinical_presentations_revs SET first_consult_date = null WHERE CAST(first_consult_date AS CHAR(10)) = '0000-00-00';
ALTER TABLE ed_breast_clinical_presentations_revs MODIFY `first_consult_date` date DEFAULT NULL, MODIFY `date_noticed` date DEFAULT NULL, DROP COLUMN id, DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by,DROP COLUMN deleted;

UPDATE ed_cll_clinical_comorbidities_revs SET cll_surgery_date = null WHERE CAST(cll_surgery_date AS CHAR(10)) = '0000-00-00';
ALTER TABLE ed_cll_clinical_comorbidities_revs MODIFY `cll_surgery_date` date DEFAULT NULL, DROP COLUMN id, DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by,DROP COLUMN deleted;
ALTER TABLE ed_cll_clinical_complications_revs DROP COLUMN id, DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by,DROP COLUMN deleted;
ALTER TABLE ed_cll_clinical_controlfus_revs DROP COLUMN id, DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by,DROP COLUMN deleted;
ALTER TABLE ed_cll_clinical_followups_revs DROP COLUMN id, DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by,DROP COLUMN deleted;
ALTER TABLE ed_cll_clinical_presentations_revs DROP COLUMN id, DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by,DROP COLUMN deleted;

UPDATE ed_cll_lab_reports_revs SET cll_sample_received_date = null WHERE CAST(cll_sample_received_date AS CHAR(10)) = '0000-00-00'; 
ALTER TABLE ed_cll_lab_reports_revs MODIFY `cll_sample_received_date` date DEFAULT NULL,DROP COLUMN id, DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by,DROP COLUMN deleted;

ALTER TABLE ed_lung_clinical_followups_revs DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by,DROP COLUMN deleted;
ALTER TABLE ed_lung_clinical_presentations_revs DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by,DROP COLUMN deleted;
ALTER TABLE ed_lung_lab_pathologies_revs DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by,DROP COLUMN deleted;
ALTER TABLE ed_mmy_clinical_followups_revs DROP COLUMN id, DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by,DROP COLUMN deleted;
ALTER TABLE ed_mmy_clinical_presentations_revs DROP COLUMN id, DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by,DROP COLUMN deleted;

ALTER TABLE ed_mmy_imaging_skeletalsurveys_revs DROP COLUMN id, DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by,DROP COLUMN deleted;
ALTER TABLE ed_mmy_lab_reports_revs DROP COLUMN id, DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by,DROP COLUMN deleted;

UPDATE ed_ovarian_clinical_followups_revs SET cht_checked = null WHERE CAST(cht_checked AS CHAR(10)) = '0000-00-00'; 
ALTER TABLE ed_ovarian_clinical_followups_revs MODIFY `cht_checked` date DEFAULT NULL,DROP COLUMN id, DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by,DROP COLUMN deleted;

UPDATE ed_ovarian_clinical_presentations_revs SET initial_ca125_date = null WHERE CAST(initial_ca125_date AS CHAR(10)) = '0000-00-00'; 
UPDATE ed_ovarian_clinical_presentations_revs SET date_noticed = null WHERE CAST(date_noticed AS CHAR(10)) = '0000-00-00'; 
UPDATE ed_ovarian_clinical_presentations_revs SET first_consult_date = null WHERE CAST(first_consult_date AS CHAR(10)) = '0000-00-00'; 
ALTER TABLE ed_ovarian_clinical_presentations_revs MODIFY first_consult_date date DEFAULT NULL, MODIFY date_noticed  date DEFAULT NULL, MODIFY `initial_ca125_date` date DEFAULT NULL, DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by,DROP COLUMN deleted;

ALTER TABLE ed_prostate_clinical_followups_revs DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by,DROP COLUMN deleted;
ALTER TABLE ed_prostate_lab_pathologies_revs DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by,DROP COLUMN deleted;
ALTER TABLE ed_prostate_lab_tests_revs DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by,DROP COLUMN deleted;

ALTER TABLE pd_hormos_revs DROP COLUMN id, DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by,DROP COLUMN deleted;
ALTER TABLE pe_hormos_revs DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN deleted;
ALTER TABLE pe_others_revs DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN deleted;
ALTER TABLE std_cabinets_revs DROP COLUMN id;
ALTER TABLE std_tiers_revs DROP COLUMN id;

ALTER TABLE txd_brachytherapies_revs DROP COLUMN id, DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by,DROP COLUMN deleted;
ALTER TABLE txd_hormonals_revs DROP COLUMN id, DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by,DROP COLUMN deleted;
ALTER TABLE txd_immunos_revs DROP COLUMN id, DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by,DROP COLUMN deleted;
ALTER TABLE txd_others_revs DROP COLUMN id, DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by,DROP COLUMN deleted;

ALTER TABLE txe_hormonals_revs DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN deleted;
ALTER TABLE txe_immunos_revs DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN deleted;
ALTER TABLE txe_others_revs DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN deleted;

ALTER TABLE txd_brachytherapies_revs 
   ADD COLUMN treatment_master_id int(11) NOT NULL;

ALTER TABLE collections_revs MODIFY banked_date date DEFAULT NULL;

ALTER TABLE consent_masters_revs 
ADD COLUMN mb_consent_date_accuracy varchar(50) NOT NULL,
ADD COLUMN mb_dor_date_accuracy varchar(50) NOT NULL,
ADD COLUMN mb_dof_date_accuracy varchar(50) NOT NULL,
ADD COLUMN mb_dcs_date_accuracy varchar(50) NOT NULL;

ALTER TABLE pd_chemos_revs 
ADD COLUMN num_cycles  int(11) DEFAULT NULL,
ADD COLUMN length_cycles  int(11) DEFAULT NULL;
ALTER TABLE pd_hormos_revs
ADD COLUMN num_cycles  int(11) DEFAULT NULL,
ADD COLUMN length_cycles  int(11) DEFAULT NULL;

ALTER TABLE pd_others_revs ADD COLUMN deleted_date datetime DEFAULT NULL;

ALTER TABLE sample_masters_revs 
ADD COLUMN `total_num` int(11) DEFAULT NULL,
ADD COLUMN `box_letter` varchar(15) DEFAULT NULL,
ADD COLUMN `box_num` varchar(15) DEFAULT NULL,
ADD COLUMN `box_position` varchar(50) DEFAULT NULL;

ALTER TABLE txd_ancillaries_revs ADD COLUMN `ancillary_completed` varchar(50) DEFAULT NULL;

ALTER TABLE ed_all_clinical_comorbidities_revs DROP INDEX event_master_id;
ALTER TABLE ed_breast_clinical_followups_revs DROP INDEX event_master_id;
ALTER TABLE ed_breast_clinical_presentations_revs DROP INDEX event_master_id;
ALTER TABLE ed_breast_lab_pathologies_revs DROP INDEX event_master_id;
ALTER TABLE ed_cll_clinical_comorbidities_revs DROP INDEX event_master_id;
ALTER TABLE ed_cll_clinical_complications_revs DROP INDEX event_master_id;
ALTER TABLE ed_cll_clinical_controlfus_revs DROP INDEX event_master_id;
ALTER TABLE ed_cll_clinical_followups_revs DROP INDEX event_master_id;
ALTER TABLE ed_cll_clinical_presentations_revs DROP INDEX event_master_id;
ALTER TABLE ed_cll_lab_reports_revs DROP INDEX event_master_id;
ALTER TABLE ed_lung_clinical_followups_revs DROP INDEX event_master_id;
ALTER TABLE ed_lung_clinical_presentations_revs DROP INDEX event_master_id;
ALTER TABLE ed_lung_lab_pathologies_revs DROP INDEX event_master_id;
ALTER TABLE ed_mmy_lab_reports_revs DROP INDEX event_master_id;
ALTER TABLE ed_ovarian_clinical_followups_revs DROP INDEX event_master_id;
ALTER TABLE ed_ovarian_clinical_presentations_revs DROP INDEX event_master_id;
ALTER TABLE ed_ovarian_lab_pathologies_revs DROP INDEX event_master_id;
ALTER TABLE ed_prostate_clinical_followups_revs DROP INDEX event_master_id;
ALTER TABLE ed_prostate_lab_pathologies_revs DROP INDEX event_master_id;
ALTER TABLE ed_prostate_lab_tests_revs DROP INDEX event_master_id;

ALTER TABLE ed_all_clinical_comorbidities_revs MODIFY event_master_id int(11) NOT NULL;
ALTER TABLE ed_all_cptp_biosamplesurveys_revs MODIFY event_master_id int(11) NOT NULL;
ALTER TABLE ed_all_cptp_physicalmeasures_revs MODIFY event_master_id int(11) NOT NULL;
ALTER TABLE ed_breast_clinical_followups_revs MODIFY event_master_id int(11) NOT NULL;
ALTER TABLE ed_breast_clinical_presentations_revs MODIFY event_master_id int(11) NOT NULL;
ALTER TABLE ed_cll_clinical_comorbidities_revs MODIFY event_master_id int(11) NOT NULL;
ALTER TABLE ed_cll_clinical_complications_revs MODIFY event_master_id int(11) NOT NULL;
ALTER TABLE ed_cll_clinical_controlfus_revs MODIFY event_master_id int(11) NOT NULL;
ALTER TABLE ed_cll_clinical_followups_revs MODIFY event_master_id int(11) NOT NULL;
ALTER TABLE ed_cll_clinical_presentations_revs MODIFY event_master_id int(11) NOT NULL;
ALTER TABLE ed_cll_lab_reports_revs MODIFY event_master_id int(11) NOT NULL;
ALTER TABLE ed_lung_clinical_followups_revs MODIFY event_master_id int(11) NOT NULL;
ALTER TABLE ed_lung_clinical_presentations_revs MODIFY event_master_id int(11) NOT NULL;
ALTER TABLE ed_lung_lab_pathologies_revs MODIFY event_master_id int(11) NOT NULL;
ALTER TABLE ed_mmy_clinical_followups_revs MODIFY event_master_id int(11) NOT NULL;
ALTER TABLE ed_mmy_clinical_presentations_revs MODIFY event_master_id int(11) NOT NULL;
ALTER TABLE ed_mmy_imaging_skeletalsurveys_revs MODIFY event_master_id int(11) NOT NULL;
ALTER TABLE ed_mmy_lab_reports_revs MODIFY event_master_id int(11) NOT NULL;
ALTER TABLE ed_ovarian_clinical_followups_revs MODIFY event_master_id int(11) NOT NULL;
ALTER TABLE ed_ovarian_clinical_presentations_revs MODIFY event_master_id int(11) NOT NULL;
ALTER TABLE ed_prostate_clinical_followups_revs MODIFY event_master_id int(11) NOT NULL;
ALTER TABLE ed_prostate_lab_pathologies_revs MODIFY event_master_id int(11) NOT NULL;
ALTER TABLE ed_prostate_lab_tests_revs MODIFY event_master_id int(11) NOT NULL;
ALTER TABLE pd_hormos_revs MODIFY protocol_master_id int(11) NOT NULL;
ALTER TABLE std_cabinets_revs MODIFY storage_master_id int(11) NOT NULL;
ALTER TABLE std_tiers_revs MODIFY storage_master_id int(11) NOT NULL;
ALTER TABLE txd_immunos_revs MODIFY treatment_master_id int(11) NOT NULL;
ALTER TABLE txd_others_revs MODIFY treatment_master_id int(11) NOT NULL;

DELETE FROM txd_hormonals_revs WHERE treatment_master_id IS NULL;
ALTER TABLE txd_hormonals_revs MODIFY treatment_master_id int(11) NOT NULL;

ALTER TABLE ed_ovarian_clinical_presentations_revs DROP COLUMN id;

ALTER TABLE storage_masters_revs MODIFY `selection_label`  varchar(60) DEFAULT '';

ALTER TABLE txd_ancillaries_revs DROP COLUMN chemo_completed;
ALTER TABLE txd_brachytherapies_revs DROP COLUMN tx_master_id;

-- ---------------------------------------------------------------------------------------------------------------
-- Clinical Annotation
-- --------------------------------------------------------------------------------------------------------------- 

-- Profile
-- ------------------------------------------------------

-- Replace wrong participants.sex values (Female to 'f', Male to 'm')

UPDATE participants SET sex = 'f', modified = @modified, modified_by = @modifiedBy WHERE sex= 'Female';
UPDATE participants SET sex = 'm', modified = @modified, modified_by = @modifiedBy WHERE sex= 'Male';
INSERT INTO participants_revs (id, title, first_name, middle_name, last_name, date_of_birth, date_of_birth_accuracy, marital_status, language_preferred, sex, race, 
vital_status, notes, date_of_death, date_of_death_accuracy, cod_icd10_code, secondary_cod_icd10_code, cod_confirmation_source, 
participant_identifier, last_chart_checked_date, last_chart_checked_date_accuracy, last_modification, last_modification_ds_id, 
death_certificate_ident, other_last_name, last_chart_checked_date_certainty, time_to_death, underlying_death_icd9, secondary_death_icd9, 
modified_by, version_created)
(SELECT id, title, first_name, middle_name, last_name, date_of_birth, date_of_birth_accuracy, marital_status, language_preferred, sex, race, 
vital_status, notes, date_of_death, date_of_death_accuracy, cod_icd10_code, secondary_cod_icd10_code, cod_confirmation_source, 
participant_identifier, last_chart_checked_date, last_chart_checked_date_accuracy, last_modification, last_modification_ds_id, 
death_certificate_ident, other_last_name, last_chart_checked_date_certainty, time_to_death, underlying_death_icd9, secondary_death_icd9, 
modified_by, modified
FROM participants WHERE modified = @modified AND modified_by = @modifiedBy);

INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('gender', 'Gender', 'Sex');

-- Change participants.time_to_death to read only plus add warning messages

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='time_to_death' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT IGNORE INTO i18n (id,en,fr)
VALUES
("'time to death' cannot be calculated because dates are not chronological", "'Age at Death' cannot be calculated because dates are not chronological", ''),
("'time to death' has been calculated with at least one inaccurate date", "'Age at Death' has been calculated with at least one inaccurate date", '');

-- MiscIdentifier
-- ------------------------------------------------------

-- display effective dates in index view

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='effective_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='expiry_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Consent
-- ------------------------------------------------------

ALTER TABLE `consent_masters`
  MODIFY `mb_consent_date_accuracy` varchar(50) NOT NULL DEFAULT '',
  MODIFY `mb_dor_date_accuracy` varchar(50) NOT NULL DEFAULT '',
  MODIFY `mb_dof_date_accuracy` varchar(50) NOT NULL DEFAULT '',
  MODIFY `mb_dcs_date_accuracy` varchar(50) NOT NULL DEFAULT '';

-- Diagnosis
-- ------------------------------------------------------

-- Age at dx must be read only

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_index`='1' WHERE structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT IGNORE INTO i18n (id,en,fr)
VALUES
("'age at dx' cannot be calculated because dates are not chronological", "'Age at dx' cannot be calculated because dates are not chronological.", ''),
("'age at dx' has been calculated with at least one inaccurate date", "'Age at dx' has been calculated with at least one inaccurate date.", '');
 
 -- Hide unused 'Origin' field
 
UPDATE structure_formats SET `flag_add`='0', `flag_add_readonly`='0', `flag_edit`='0', `flag_edit_readonly`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' 
WHERE structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_origin' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='origin') AND `flag_confidential`='0');
    
-- Treatment
-- ------------------------------------------------------
 
-- Remove disease_site = 'General' to simplify treatment name

UPDATE treatment_controls SET disease_site = '' WHERE flag_active = 1;

-- Display treatment in index view

UPDATE treatment_controls SET use_detail_form_for_index = 1 WHERE flag_active= 1;

-- Replaced the drug drop down list to both an autocomplete field and a text field plus moved drug_id field to Master model

UPDATE treatment_extend_masters Master, txe_hormonals Detail SET Master.drug_id = Detail.drug_id WHERE Master.id = Detail.treatment_extend_master_id;
UPDATE treatment_extend_masters_revs Master, txe_hormonals_revs Detail SET Master.drug_id = Detail.drug_id WHERE Master.id = Detail.treatment_extend_master_id AND CAST(Master.version_created AS DATE) = CAST(Detail.version_created AS DATE);
ALTER TABLE `txe_hormonals` DROP FOREIGN KEY `FK_txe_hormonals_drugs`;
ALTER TABLE txe_hormonals DROP COLUMN drug_id;
ALTER TABLE txe_hormonals_revs DROP COLUMN drug_id;

UPDATE treatment_extend_masters Master, txe_others Detail SET Master.drug_id = Detail.drug_id WHERE Master.id = Detail.treatment_extend_master_id AND Detail.drug_id NOT LIKE '';
UPDATE treatment_extend_masters_revs Master, txe_others_revs Detail SET Master.drug_id = Detail.drug_id WHERE Master.id = Detail.treatment_extend_master_id AND CAST(Master.version_created AS DATE) = CAST(Detail.version_created AS DATE) AND Detail.drug_id NOT LIKE '';
ALTER TABLE `txe_others` DROP FOREIGN KEY `FK_txe_others_drugs`;
ALTER TABLE txe_others DROP COLUMN drug_id;
ALTER TABLE txe_others_revs DROP COLUMN drug_id;

UPDATE treatment_extend_masters Master, txe_immunos Detail SET Master.drug_id = Detail.drug_id WHERE Master.id = Detail.treatment_extend_master_id;
UPDATE treatment_extend_masters_revs Master, txe_immunos_revs Detail SET Master.drug_id = Detail.drug_id WHERE Master.id = Detail.treatment_extend_master_id AND CAST(Master.version_created AS DATE) = CAST(Detail.version_created AS DATE);
ALTER TABLE `txe_immunos` DROP FOREIGN KEY `FK_txe_immunos_drugs`;
ALTER TABLE txe_immunos DROP COLUMN drug_id;
ALTER TABLE txe_immunos_revs DROP COLUMN drug_id;

UPDATE treatment_extend_masters Master, txe_ancillaries Detail SET Master.drug_id = Detail.drug_id WHERE Master.id = Detail.treatment_extend_master_id;
UPDATE treatment_extend_masters_revs Master, txe_ancillaries_revs Detail SET Master.drug_id = Detail.drug_id WHERE Master.id = Detail.treatment_extend_master_id AND CAST(Master.version_created AS DATE) = CAST(Detail.version_created AS DATE);
ALTER TABLE `txe_ancillaries` DROP FOREIGN KEY `FK_txe_ancillaries_drugs`;
ALTER TABLE txe_ancillaries DROP COLUMN drug_id;
ALTER TABLE txe_ancillaries_revs DROP COLUMN drug_id;

-- Message
-- ------------------------------------------------------

-- Created funtion 'Create message (applied to all)'. 

UPDATE datamart_structure_functions SET flag_active = 1 WHERE label = 'create participant message (applied to all)';

-- ---------------------------------------------------------------------------------------------------------------
-- Inventory Management
-- --------------------------------------------------------------------------------------------------------------- 

-- Hide Collection Protocols

UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='collection_protocol_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_protocols') AND `flag_confidential`='0');

UPDATE structure_formats SET `language_heading`='collection' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `language_heading`='', `flag_index`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_protocol_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_protocols') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='collections_for_collection_tree_view') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_protocol_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_protocols') AND `flag_confidential`='0');
 
-- Created 'tisue block' to 'tissue block' realiquoting link

UPDATE realiquoting_controls SET flag_active=true WHERE id IN('48');

-- ---------------------------------------------------------------------------------------------------------------
-- Study
-- --------------------------------------------------------------------------------------------------------------- 

-- ---------------------------------------------------------------------------------------------------------------
-- LabBook	
-- --------------------------------------------------------------------------------------------------------------- 

UPDATE menus SET flag_active = 0 WHERE use_link LIKE '%LabBook%';

-- ---------------------------------------------------------------------------------------------------------------
-- Storage Master		
-- --------------------------------------------------------------------------------------------------------------- 

-- ---------------------------------------------------------------------------------------------------------------
-- Protocol		
-- --------------------------------------------------------------------------------------------------------------- 

-- Replaced the drug drop down list to both an 
-- autocomplete field and a text field plus moved drug_id 
-- field to Master model
-- ------------------------------------------------------

UPDATE protocol_extend_masters Master, pe_others Detail SET Master.drug_id = Detail.drug_id WHERE Master.id = Detail.protocol_extend_master_id;
UPDATE protocol_extend_masters_revs Master, pe_others_revs Detail SET Master.drug_id = Detail.drug_id WHERE Master.id = Detail.protocol_extend_master_id AND CAST(Master.version_created AS DATE) = CAST(Detail.version_created AS DATE);
ALTER TABLE pe_others DROP COLUMN drug_id;
ALTER TABLE pe_others_revs DROP COLUMN drug_id;

UPDATE protocol_extend_masters Master, pe_hormos Detail SET Master.drug_id = Detail.drug_id WHERE Master.id = Detail.protocol_extend_master_id;
UPDATE protocol_extend_masters_revs Master, pe_hormos_revs Detail SET Master.drug_id = Detail.drug_id WHERE Master.id = Detail.protocol_extend_master_id AND CAST(Master.version_created AS DATE) = CAST(Detail.version_created AS DATE);
ALTER TABLE pe_hormos DROP FOREIGN KEY `FK_pe_hormos_drugs`;
ALTER TABLE pe_hormos DROP COLUMN drug_id;
ALTER TABLE pe_hormos_revs DROP COLUMN drug_id;

UPDATE protocol_extend_masters Master, pe_ancillaries Detail SET Master.drug_id = Detail.drug_id WHERE Master.id = Detail.protocol_extend_master_id;
UPDATE protocol_extend_masters_revs Master, pe_ancillaries_revs Detail SET Master.drug_id = Detail.drug_id WHERE Master.id = Detail.protocol_extend_master_id AND CAST(Master.version_created AS DATE) = CAST(Detail.version_created AS DATE);
ALTER TABLE pe_ancillaries DROP FOREIGN KEY `FK_pe_ancillaries_drugs`;
ALTER TABLE pe_ancillaries DROP COLUMN drug_id;
ALTER TABLE pe_ancillaries_revs DROP COLUMN drug_id;

-- Tumour Group & Type fields should be read-only

UPDATE structure_formats SET `flag_add_readonly`='1', `flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='protocolmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ProtocolControl' AND `tablename`='protocol_controls' AND `field`='tumour_group' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='protocol tumour group') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add_readonly`='1', `flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='protocolmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ProtocolControl' AND `tablename`='protocol_controls' AND `field`='type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='protocol type') AND `flag_confidential`='0');

-- ---------------------------------------------------------------------------------------------------------------
-- Datamart & report
-- --------------------------------------------------------------------------------------------------------------- 

UPDATE datamart_browsing_controls set flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 WHERE (id1 = 26 AND id2 =22) OR (id1 = 22 AND id2 =26);
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 WHERE (id1 = 16 AND id2 =26) OR (id1 = 26 AND id2 =16);
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 WHERE (id1 = 26 AND id2 =25) OR (id1 = 25 AND id2 =26);

UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'ViewSample' AND label = 'initial specimens display';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'ViewSample' AND label = 'all derivatives display';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'NonTmaBlockStorage' AND label = 'list all children storages';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'DiagnosisMaster' AND label = 'list all related diagnosis';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'Participant' AND label = 'list all related diagnosis';

-- ---------------------------------------------------------------------------------------------------------------
-- versions		
-- --------------------------------------------------------------------------------------------------------------- 

UPDATE versions SET branch_build_number = '7538' WHERE version_number = '2.7.1';
