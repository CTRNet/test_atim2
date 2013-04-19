UPDATE `versions` SET branch_build_number = 'xxx' WHERE version_number = '2.5.4';

UPDATE structure_formats SET `margin`='2' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='ld_lymph_dx_lymphomas') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_lymphomas' AND `field` IN ('baseline_b_symp_fever', 'baseline_b_symp_night_sweating', 'baseline_b_symp_weight_loss'));
REPLACE INTO i18n (id,en) VALUES 
('b symptoms : fever', 'Fever (B Sympt.)'), 
('b symptoms : night sweating', 'Night Sweating (B Sympt.)'), 
('b symptoms : weight loss', 'Weight loss (B Sympt.)');
INSERT INTO i18n (id,en) VALUES ('unable to add a lymphoma secondary to a lymphoma primary','Unable to add a Lymphoma Secondary to a Lymphoma Primary');






