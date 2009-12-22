ALTER TABLE participants ADD
FOREIGN KEY (cod_icd10_code) REFERENCES coding_icd10 (id),
FOREIGN KEY (secondary_cod_icd10_code) REFERENCES coding_icd10 (id);

ALTER TABLE diagnosis_masters ADD
FOREIGN KEY (primary_icd10_code) REFERENCES coding_icd10 (id);

ALTER TABLE family_histories ADD
FOREIGN KEY (primary_icd10_code) REFERENCES coding_icd10 (id);

INSERT INTO `structure_validations` (
`id` ,
`old_id` ,
`structure_field_id` ,
`structure_field_old_id` ,
`rule` ,
`flag_empty` ,
`flag_required` ,
`on_action` ,
`language_message` ,
`created` ,
`created_by` ,
`modified` ,
`modifed_by`
)
VALUES (
NULL , 'CANM-00019', '501', 'CAN-999-999-000-999-24', 'validateIcd10Code', '0', '0', '', 'invalid cause of death code', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(NULL , 'CANM-00020', '570', 'CAN-999-999-000-999-31', 'validateIcd10Code', '0', '0', '', 'invalid primary disease code', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(NULL , 'CANM-00021', '817', 'CAN-999-999-000-999-72', 'validateIcd10Code', '0', '0', '', 'invalid primary disease code', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(NULL , 'CANM-00022', '895', 'CAN-895', 'validateIcd10Code', '0', '0', '', 'invalid secondary cause of death code', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''
);

INSERT INTO `i18n` (
`id` ,
`page_id` ,
`en` ,
`fr`
)
VALUES (
'invalid cause of death code', 'global', 'Invalid cause of death code', 'Code de cause du décès invalide'
), (
'invalid secondary cause of death code', 'global', 'Invalid secondary cause of death code', 'Code de cause secondaire du décès invalide'
), (
'invalid primary disease code', 'global', 'Invalid primary disease code', 'Code de maladie primaire invalide'
);
