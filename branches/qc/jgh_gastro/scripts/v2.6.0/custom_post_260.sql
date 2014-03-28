DROP TABLE txe_radiations; DROP TABLE txe_radiations_revs;

 -- -------------------------------------------------------------------------------------
 -- Remove Cap Report
 -- -------------------------------------------------------------------------------------

UPDATE event_controls SET flag_active = 0 WHERE event_group = 'lab' AND event_type LIKE 'cap report%';
UPDATE event_masters SET deleted = 1 WHERE event_control_id IN (SELECT ID FROM event_controls WHERE event_group = 'lab' AND event_type LIKE 'cap report%');
UPDATE structure_permissible_values_custom_controls SET flag_active = 0 WHERE name LIKE 'cap %';
 
-- -------------------------------------------------------------------------------------
-- UPDATE structure_permissible_values_custom_controls
-- -------------------------------------------------------------------------------------

UPDATE structure_permissible_values_custom_controls SET category = 'inventory' WHERE name = 'qc_gastro tissue source list';
UPDATE structure_permissible_values_custom_controls SET category = 'clinical - treatment' WHERE name = 'qc_gastro surgeons';
UPDATE structure_permissible_values_custom_controls SET category = 'clinical - diagnosis' WHERE name = 'diagnosis method';
UPDATE structure_permissible_values_custom_controls SET category = 'clinical - diagnosis' WHERE name = 'tumour grade';
UPDATE structure_permissible_values_custom_controls SET category = 'clinical - treatment' WHERE name = 'surgical procedure';
UPDATE structure_permissible_values_custom_controls SET category = 'inventory' WHERE name = 'tissue collection method';
