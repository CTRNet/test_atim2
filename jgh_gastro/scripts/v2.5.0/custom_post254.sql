
UPDATE `versions` SET branch_build_number = '5158' WHERE version_number = '2.5.4';

UPDATE event_controls SET detail_tablename = 'qc_gastro_ed_cap_report_lungs' WHERE detail_tablename = 'qc_gastro_dxd_cap_lungs';
UPDATE event_controls SET detail_tablename = 'qc_gastro_ed_cap_report_melanomas' WHERE detail_tablename = 'qc_gastro_dxd_cap_melanomas';
UPDATE event_controls SET detail_tablename = 'qc_gastro_ed_cap_report_kidneys' WHERE detail_tablename = 'qc_gastro_dxd_cap_kidneys';
UPDATE event_controls SET detail_tablename = 'qc_gastro_ed_cap_report_testis' WHERE detail_tablename = 'qc_gastro_dxd_cap_testis';
UPDATE event_controls SET detail_tablename = 'qc_gastro_ed_cap_report_bladders' WHERE detail_tablename = 'qc_gastro_dxd_cap_bladders';
UPDATE event_controls SET detail_tablename = 'qc_gastro_ed_cap_report_prostate_needles' WHERE detail_tablename = 'qc_gastro_dxd_cap_prostate_needles';
UPDATE event_controls SET detail_tablename = 'qc_gastro_ed_cap_report_prostate_radicals' WHERE detail_tablename = 'qc_gastro_dxd_cap_prostate_radicals';
UPDATE event_controls SET detail_tablename = 'qc_gastro_ed_cap_report_larynx' WHERE detail_tablename = 'qc_gastro_dxd_cap_larynx';
UPDATE event_controls SET detail_tablename = 'qc_gastro_ed_cap_report_pharynx' WHERE detail_tablename = 'qc_gastro_dxd_cap_pharynx';
UPDATE event_controls SET detail_tablename = 'qc_gastro_ed_cap_report_lip_oral' WHERE detail_tablename = 'qc_gastro_dxd_cap_lip_oral';
UPDATE event_controls SET detail_tablename = 'qc_gastro_ed_cap_report_sal_glands' WHERE detail_tablename = 'qc_gastro_dxd_cap_sal_glands';
UPDATE event_controls SET detail_tablename = 'qc_gastro_ed_cap_report_nas_sinus' WHERE detail_tablename = 'qc_gastro_dxd_cap_nas_sinus';
UPDATE event_controls SET detail_tablename = 'qc_gastro_ed_cap_report_thyroid' WHERE detail_tablename = 'qc_gastro_dxd_cap_thyroid';

UPDATE structure_fields SET tablename = 'qc_gastro_ed_cap_report_lungs' WHERE tablename = 'qc_gastro_dxd_cap_lungs';
UPDATE structure_fields SET tablename = 'qc_gastro_ed_cap_report_melanomas' WHERE tablename = 'qc_gastro_dxd_cap_melanomas';
UPDATE structure_fields SET tablename = 'qc_gastro_ed_cap_report_kidneys' WHERE tablename = 'qc_gastro_dxd_cap_kidneys';
UPDATE structure_fields SET tablename = 'qc_gastro_ed_cap_report_testis' WHERE tablename = 'qc_gastro_dxd_cap_testis';
UPDATE structure_fields SET tablename = 'qc_gastro_ed_cap_report_bladders' WHERE tablename = 'qc_gastro_dxd_cap_bladders';
UPDATE structure_fields SET tablename = 'qc_gastro_ed_cap_report_prostate_needles' WHERE tablename = 'qc_gastro_dxd_cap_prostate_needles';
UPDATE structure_fields SET tablename = 'qc_gastro_ed_cap_report_prostate_radicals' WHERE tablename = 'qc_gastro_dxd_cap_prostate_radicals';
UPDATE structure_fields SET tablename = 'qc_gastro_ed_cap_report_larynx' WHERE tablename = 'qc_gastro_dxd_cap_larynx';
UPDATE structure_fields SET tablename = 'qc_gastro_ed_cap_report_pharynx' WHERE tablename = 'qc_gastro_dxd_cap_pharynx';
UPDATE structure_fields SET tablename = 'qc_gastro_ed_cap_report_lip_oral' WHERE tablename = 'qc_gastro_dxd_cap_lip_oral';
UPDATE structure_fields SET tablename = 'qc_gastro_ed_cap_report_sal_glands' WHERE tablename = 'qc_gastro_dxd_cap_sal_glands';
UPDATE structure_fields SET tablename = 'qc_gastro_ed_cap_report_nas_sinus' WHERE tablename = 'qc_gastro_dxd_cap_nas_sinus';
UPDATE structure_fields SET tablename = 'qc_gastro_ed_cap_report_thyroid' WHERE tablename = 'qc_gastro_dxd_cap_thyroid';

ALTER TABLE qc_gastro_ed_cap_report_thyroid_revs 
  CHANGE `adenoma` `add_path_adenoma` char(1) NOT NULL DEFAULT '',
  CHANGE `adenomatoid_nodule` `add_path_adenomatoid_nodule` char(1) NOT NULL DEFAULT '',
  CHANGE `diffuse_hyperplasia` `add_path_diffuse_hyperplasia` char(1) NOT NULL DEFAULT '',
  CHANGE `thyroiditis` `add_path_thyroiditis` char(1) NOT NULL DEFAULT '',
  CHANGE `thyroiditis_advanced` `add_path_thyroiditis_advanced` char(1) NOT NULL DEFAULT '',
  CHANGE `thyroiditis_focal` `add_path_thyroiditis_focal` char(1) NOT NULL DEFAULT '',
  CHANGE `thyroiditis_palpation` `add_path_thyroiditis_palpation` char(1) NOT NULL DEFAULT '',
  CHANGE `thyroiditis_other` `add_path_thyroiditis_other` char(1) NOT NULL DEFAULT '',
  CHANGE `thyroiditis_other_specify` `add_path_thyroiditis_other_specify` varchar(50) NOT NULL DEFAULT '',
  CHANGE `parathyroid_gland` `add_path_parathyroid_gland` char(1) NOT NULL DEFAULT '',
  CHANGE `parathyroid_gland_within_normal_limits` `add_path_parathyroid_gland_within_normal_limits` char(1) NOT NULL DEFAULT '',
  CHANGE `parathyroid_gland_hypercellular` `add_path_parathyroid_gland_hypercellular` char(1) NOT NULL DEFAULT '',
  CHANGE `parathyroid_gland_other` `add_path_parathyroid_gland_other` char(1) NOT NULL DEFAULT '',
  CHANGE `parathyroid_gland_other_specify` `add_path_parathyroid_gland_other_specify` varchar(50) NOT NULL DEFAULT '',
  CHANGE `c_cell_hyperplasia` `add_path_c_cell_hyperplasia` char(1) NOT NULL DEFAULT '',
  CHANGE `none_identified` `add_path_none_identified` char(1) NOT NULL DEFAULT '',
  CHANGE `other` `add_path_other` char(1) NOT NULL DEFAULT '',
  CHANGE `other_specify` `add_path_other_specify` varchar(50) NOT NULL DEFAULT '';

ALTER TABLE qc_gastro_ed_cap_report_pharynx_revs 
  ADD COLUMN `tumor_laterality_left` char(1) NOT NULL DEFAULT '',
  ADD COLUMN `tumor_laterality_right` char(1) NOT NULL DEFAULT '',
  ADD COLUMN `tumor_laterality_bilateral` char(1) NOT NULL DEFAULT '',
  ADD COLUMN `tumor_laterality_midline` char(1) NOT NULL DEFAULT '',
  ADD COLUMN `tumor_laterality_not_specified` char(1) NOT NULL DEFAULT '';

ALTER TABLE  qc_gastro_ed_cap_report_larynx_revs MODIFY  `version_id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE  qc_gastro_ed_cap_report_lip_oral_revs MODIFY  `version_id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE  qc_gastro_ed_cap_report_nas_sinus_revs MODIFY  `version_id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE  qc_gastro_ed_cap_report_pharynx_revs MODIFY  `version_id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE  qc_gastro_ed_cap_report_sal_glands_revs MODIFY  `version_id` int(11) NOT NULL AUTO_INCREMENT;

-- --------------------------------------------------------------------------------------------------------
-- Add serum + ctad to blood type 2013-06-16
-- --------------------------------------------------------------------------------------------------------

INSERT INTO structure_permissible_values (value, language_alias) VALUES("serum", "serum");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="blood_type"), (SELECT id FROM structure_permissible_values WHERE value="serum" AND language_alias="serum"), "4", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("CTAD", "CTAD");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="blood_type"), (SELECT id FROM structure_permissible_values WHERE value="CTAD" AND language_alias="CTAD"), "4", "1");
INSERT INTO i18n (id,en,fr) VALUES ('CTAD','CTAD','CTAD');
UPDATE versions SET permissions_regenerated = 0;
UPDATE versions SET branch_build_number = '5288' WHERE version_number = '2.5.4';
















