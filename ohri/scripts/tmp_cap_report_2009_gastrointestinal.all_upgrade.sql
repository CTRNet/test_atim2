-- Fix issue 1178: Mismatch between main tables and revs tables

ALTER TABLE dxd_cap_report_ampullas MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE dxd_cap_report_colon_biopsies MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE dxd_cap_report_colon_rectum_resections MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE dxd_cap_report_distalexbileducts MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE dxd_cap_report_gallbladders MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE dxd_cap_report_hepatocellular_carcinomas MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE dxd_cap_report_intrahepbileducts MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE dxd_cap_report_pancreasendos MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE dxd_cap_report_pancreasexos MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE dxd_cap_report_perihilarbileducts MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE dxd_cap_report_smintestines MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE dxd_cap_report_ampullas_revs ADD `version_created` datetime NOT NULL AFTER `version_id`;
ALTER TABLE dxd_cap_report_colon_biopsies_revs ADD `version_created` datetime NOT NULL AFTER `version_id`;
ALTER TABLE dxd_cap_report_colon_rectum_resections_revs ADD `version_created` datetime NOT NULL AFTER `version_id`;
ALTER TABLE dxd_cap_report_distalexbileducts_revs ADD `version_created` datetime NOT NULL AFTER `version_id`;
ALTER TABLE dxd_cap_report_gallbladders_revs ADD `version_created` datetime NOT NULL AFTER `version_id`;
ALTER TABLE dxd_cap_report_hepatocellular_carcinomas_revs ADD `version_created` datetime NOT NULL AFTER `version_id`;
ALTER TABLE dxd_cap_report_intrahepbileducts_revs ADD `version_created` datetime NOT NULL AFTER `version_id`;
ALTER TABLE dxd_cap_report_pancreasendos_revs ADD `version_created` datetime NOT NULL AFTER `version_id`;
ALTER TABLE dxd_cap_report_pancreasexos_revs ADD `version_created` datetime NOT NULL AFTER `version_id`;
ALTER TABLE dxd_cap_report_perihilarbileducts_revs ADD `version_created` datetime NOT NULL AFTER `version_id`;
ALTER TABLE dxd_cap_report_smintestines_revs ADD `version_created` datetime NOT NULL AFTER `version_id`;
