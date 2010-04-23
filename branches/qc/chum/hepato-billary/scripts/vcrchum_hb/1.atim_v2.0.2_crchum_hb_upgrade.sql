-- -------------------------------------------------------------------
--
-- SCRIPT to customize ATiM fro CRCHMU Hepato-Bil Bank
--	Note:
--		- To run after tmp_v2.0.2_upgrade.sql
-- -------------------------------------------------------------------

-- General

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('core_appname', 'global', 'ATiM.v2 - CHUM Hep-bil', 'ATiM.v2 - CHUM Hep-bil'),
('CTRApp', 'global', 'ATiM.v2 - CHUM Hep-bil', 'ATiM.v2 - CHUM Hep-bil');

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- CLINICAL ANNOTATION
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

-- *** PROFILE *********************************************************

-- Participant identifer : Read only & Label changed to 'Participant Code'

UPDATE `structure_formats`
SET `flag_add` = '0',
`flag_add_readonly` = '0',
`flag_edit_readonly` = '1',
`flag_datagrid_readonly` = '1',
`flag_override_label` = '1',
`language_label` = 'participant code'
WHERE 
structure_id = (SELECT id FROM structures WHERE alias = 'participants')
AND structure_field_id = (
	SELECT id FROM structure_fields 
	WHERE plugin = 'Clinicalannotation' 
	AND model = 'Participant' 
	AND tablename = 'participants' 
	AND field = 'participant_identifier'
);

DELETE FROM `i18n` WHERE `id` IN ('participant code');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('participant code', 'global', 'Code', 'Code');

-- Participant title + middle name : Hidden

UPDATE `structure_formats`
SET `flag_add` = '0',
`flag_add_readonly` = '0',
`flag_edit` = '0',
`flag_edit_readonly` = '0',
`flag_search` = '0',
`flag_search_readonly` = '0',
`flag_edit_readonly` = '0',
`flag_datagrid` = '0',
`flag_datagrid_readonly` = '0',
`flag_index` = '0',
`flag_detail` = '0'
WHERE structure_field_id IN (
	SELECT id FROM structure_fields 
	WHERE plugin = 'Clinicalannotation' 
	AND model = 'Participant' 
	AND tablename = 'participants' 
	AND field IN ('middle_name', 'title')
);

-- Participant first name / last name : Required & Add tags
UPDATE `structure_formats`
SET 
`flag_override_label` = '1',
`language_label` = 'first name',
`flag_override_tag` = '0',
`language_tag` = ''
WHERE 
structure_id = (SELECT id FROM structures WHERE alias = 'participants')
AND structure_field_id = (
	SELECT id FROM structure_fields 
	WHERE plugin = 'Clinicalannotation' 
	AND model = 'Participant' 
	AND tablename = 'participants' 
	AND field = 'first_name'
);

INSERT INTO `structure_validations` 
(`id`, `structure_field_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, (SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'Participant' AND tablename = 'participants' AND field = 'first_name'), 'notEmpty', '0', '0', '', 'first name and last name are required', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
	
UPDATE `structure_formats`
SET 
`flag_override_label` = '1',
`language_label` = 'last name',
`flag_override_tag` = '0',
`language_tag` = ''
WHERE 
structure_id = (SELECT id FROM structures WHERE alias = 'participants')
AND structure_field_id = (
	SELECT id FROM structure_fields 
	WHERE plugin = 'Clinicalannotation' 
	AND model = 'Participant' 
	AND tablename = 'participants' 
	AND field = 'last_name'
);
 
INSERT INTO `structure_validations` 
(`id`, `structure_field_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, (SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'Participant' AND tablename = 'participants' AND field = 'last_name'), 'notEmpty', '0', '0', '', 'first name and last name are required', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
 
DELETE FROM `i18n` WHERE `id` IN ('first name and last name are required');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('first name and last name are required', 'global', 'First name and last name are required!', 'Le nom et prénom sont requis!');

-- Participant race : Hidden
UPDATE `structure_formats`
SET `flag_add` = '0',
`flag_add_readonly` = '0',
`flag_edit` = '0',
`flag_edit_readonly` = '0',
`flag_search` = '0',
`flag_search_readonly` = '0',
`flag_edit_readonly` = '0',
`flag_datagrid` = '0',
`flag_datagrid_readonly` = '0',
`flag_index` = '0',
`flag_detail` = '0'
WHERE 
structure_id = (SELECT id FROM structures WHERE alias = 'participants')
AND structure_field_id = (
	SELECT id FROM structure_fields 
	WHERE plugin = 'Clinicalannotation' 
	AND model = 'Participant' 
	AND tablename = 'participants' 
	AND field = 'race'
);

-- secondary_cod_icd10_code + cod_confirmation_source : Hidden
UPDATE `structure_formats`
SET `flag_add` = '0',
`flag_add_readonly` = '0',
`flag_edit` = '0',
`flag_edit_readonly` = '0',
`flag_search` = '0',
`flag_search_readonly` = '0',
`flag_edit_readonly` = '0',
`flag_datagrid` = '0',
`flag_datagrid_readonly` = '0',
`flag_index` = '0',
`flag_detail` = '0'
WHERE 
structure_id = (SELECT id FROM structures WHERE alias = 'participants')
AND structure_field_id IN (
	SELECT id FROM structure_fields 
	WHERE plugin = 'Clinicalannotation' 
	AND model = 'Participant' 
	AND tablename = 'participants' 
	AND field IN ('secondary_cod_icd10_code', 'cod_confirmation_source')
);

-- *** IDENTIFIER ******************************************************

DELETE FROM `misc_identifier_controls`;
INSERT INTO `misc_identifier_controls` 
(`id`, `misc_identifier_name`, `misc_identifier_name_abbrev`, `flag_active`, `display_order`, `autoincrement_name`, `misc_identifier_format`) 
VALUES
(null, 'health_insurance_card', 'RAMQ', '1', 0, '', ''),
(null, 'saint_luc_hospital_nbr', 'ID HSL', '1', 1, '', ''),
(null, 'hepato_bil_bank_participant_id', 'HB-PartID', '1', 3, 'hepato_bil_bank_participant_id', 'HB-P%%key_increment%%');

DELETE FROM `key_increments`;
INSERT INTO `key_increments` (`key_name`, `key_value`) VALUES
('hepato_bil_bank_participant_id', 1);

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('health_insurance_card', 'global', 'Health Insurance Card', 'Carte d''assurance maladie'),
('saint_luc_hospital_nbr', 'global', 'St Luc Hospital Number', 'No Hôpital St Luc'),
('hepato_bil_bank_participant_id', 'global', 'H.B. Bank Participant Id', 'Numéro participant banque H.B.'),
('this identifier has already been created for your participant', '', 'This identifier has already been created for your participant!', 'Cet identification a déjà été créée pour ce participant!');

-- *** CONTACT *********************************************************

-- Other Contact Type : Hidden
UPDATE `structure_formats`
SET `flag_add` = '0',
`flag_add_readonly` = '0',
`flag_edit` = '0',
`flag_edit_readonly` = '0',
`flag_search` = '0',
`flag_search_readonly` = '0',
`flag_edit_readonly` = '0',
`flag_datagrid` = '0',
`flag_datagrid_readonly` = '0',
`flag_index` = '0',
`flag_detail` = '0'
WHERE 
structure_id = (SELECT id FROM structures WHERE alias = 'participantcontacts')
AND structure_field_id IN (
	SELECT id FROM structure_fields 
	WHERE plugin = 'Clinicalannotation' 
	AND model = 'ParticipantContact' 
	AND tablename = 'participant_contacts' 
	AND field IN ('other_contact_type')
);
 	 	 	
-- Other Contact Type : text box
UPDATE `structure_fields` SET `type` = 'input', `setting` = 'size=30' 
WHERE plugin = 'Clinicalannotation' 
AND model = 'ParticipantContact' 
AND tablename = 'participant_contacts' 
AND field IN ('contact_type');

-- *** ANNOTATION ******************************************************

DELETE FROM `event_masters`;
DELETE FROM `event_controls` ;

-- ... SCREENING .......................................................

UPDATE `menus` SET `flag_active` = '0' WHERE `menus`.`id` = 'clin_CAN_27' ;

-- ... STUDY ...........................................................

UPDATE `menus` SET `flag_active` =  '0' WHERE `menus`.`id` = 'clin_CAN_33' ;

-- ... CLINIC: presentation ............................................

DELETE FROM `menus` WHERE `id` IN ('clin_qc_hb_31', 'clin_qc_hb_32', 'clin_qc_hb_33');
INSERT INTO `menus` (`id`, `parent_id`, `is_root`, `display_order`, `language_title`, `language_description`, `use_link`, `use_params`, `use_summary`, `flag_active`, `created`, `created_by`, `modified`, `modified_by`) VALUES
('clin_qc_hb_31', 'clin_CAN_31', 0, 1, 'annotation clinical details', 'annotation clinical details', '/clinicalannotation/event_masters/listall/clinical/%%Participant.id%%//', '', '', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('clin_qc_hb_33', 'clin_CAN_31', 0, 2, 'annotation clinical reports', 'annotation clinical reports', '/clinicalannotation/event_masters/imageryReport/%%Participant.id%%/', '', '', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

TRUNCATE `acos`;
INSERT INTO `acos` (`id`, `parent_id`, `model`, `foreign_key`, `alias`, `lft`, `rght`) VALUES
(1, NULL, NULL, NULL, 'controllers', 1, 932),
(2, 1, NULL, NULL, 'Administrate', 2, 111),
(3, 2, NULL, NULL, 'Announcements', 3, 14),
(4, 3, NULL, NULL, 'add', 4, 5),
(5, 3, NULL, NULL, 'index', 6, 7),
(6, 3, NULL, NULL, 'detail', 8, 9),
(7, 3, NULL, NULL, 'edit', 10, 11),
(8, 3, NULL, NULL, 'delete', 12, 13),
(9, 2, NULL, NULL, 'Banks', 15, 26),
(10, 9, NULL, NULL, 'add', 16, 17),
(11, 9, NULL, NULL, 'index', 18, 19),
(12, 9, NULL, NULL, 'detail', 20, 21),
(13, 9, NULL, NULL, 'edit', 22, 23),
(14, 9, NULL, NULL, 'delete', 24, 25),
(15, 2, NULL, NULL, 'Groups', 27, 38),
(16, 15, NULL, NULL, 'index', 28, 29),
(17, 15, NULL, NULL, 'detail', 30, 31),
(18, 15, NULL, NULL, 'add', 32, 33),
(19, 15, NULL, NULL, 'edit', 34, 35),
(20, 15, NULL, NULL, 'delete', 36, 37),
(21, 2, NULL, NULL, 'Menus', 39, 48),
(22, 21, NULL, NULL, 'index', 40, 41),
(23, 21, NULL, NULL, 'detail', 42, 43),
(24, 21, NULL, NULL, 'edit', 44, 45),
(25, 21, NULL, NULL, 'add', 46, 47),
(26, 2, NULL, NULL, 'Passwords', 49, 52),
(27, 26, NULL, NULL, 'index', 50, 51),
(28, 2, NULL, NULL, 'Permissions', 53, 66),
(29, 28, NULL, NULL, 'index', 54, 55),
(30, 28, NULL, NULL, 'regenerate', 56, 57),
(31, 28, NULL, NULL, 'update', 58, 59),
(32, 28, NULL, NULL, 'updatePermission', 60, 61),
(33, 28, NULL, NULL, 'tree', 62, 63),
(34, 28, NULL, NULL, 'addPermissionStateToThreadedData', 64, 65),
(35, 2, NULL, NULL, 'Preferences', 67, 72),
(36, 35, NULL, NULL, 'index', 68, 69),
(37, 35, NULL, NULL, 'edit', 70, 71),
(38, 2, NULL, NULL, 'StructureFormats', 73, 82),
(39, 38, NULL, NULL, 'listall', 74, 75),
(40, 38, NULL, NULL, 'detail', 76, 77),
(41, 38, NULL, NULL, 'edit', 78, 79),
(42, 38, NULL, NULL, 'add', 80, 81),
(43, 2, NULL, NULL, 'Structures', 83, 92),
(44, 43, NULL, NULL, 'index', 84, 85),
(45, 43, NULL, NULL, 'detail', 86, 87),
(46, 43, NULL, NULL, 'edit', 88, 89),
(47, 43, NULL, NULL, 'add', 90, 91),
(48, 2, NULL, NULL, 'UserLogs', 93, 96),
(49, 48, NULL, NULL, 'index', 94, 95),
(50, 2, NULL, NULL, 'Users', 97, 106),
(51, 50, NULL, NULL, 'listall', 98, 99),
(52, 50, NULL, NULL, 'detail', 100, 101),
(53, 50, NULL, NULL, 'add', 102, 103),
(54, 50, NULL, NULL, 'edit', 104, 105),
(55, 2, NULL, NULL, 'Versions', 107, 110),
(56, 55, NULL, NULL, 'detail', 108, 109),
(57, 1, NULL, NULL, 'App', 112, 153),
(58, 57, NULL, NULL, 'Groups', 113, 124),
(59, 58, NULL, NULL, 'index', 114, 115),
(60, 58, NULL, NULL, 'view', 116, 117),
(61, 58, NULL, NULL, 'add', 118, 119),
(62, 58, NULL, NULL, 'edit', 120, 121),
(63, 58, NULL, NULL, 'delete', 122, 123),
(64, 57, NULL, NULL, 'Menus', 125, 130),
(65, 64, NULL, NULL, 'index', 126, 127),
(66, 64, NULL, NULL, 'update', 128, 129),
(67, 57, NULL, NULL, 'Pages', 131, 134),
(68, 67, NULL, NULL, 'display', 132, 133),
(69, 57, NULL, NULL, 'Posts', 135, 146),
(70, 69, NULL, NULL, 'index', 136, 137),
(71, 69, NULL, NULL, 'view', 138, 139),
(72, 69, NULL, NULL, 'add', 140, 141),
(73, 69, NULL, NULL, 'edit', 142, 143),
(74, 69, NULL, NULL, 'delete', 144, 145),
(75, 57, NULL, NULL, 'Users', 147, 152),
(76, 75, NULL, NULL, 'login', 148, 149),
(77, 75, NULL, NULL, 'logout', 150, 151),
(78, 1, NULL, NULL, 'Clinicalannotation', 154, 335),
(79, 78, NULL, NULL, 'ClinicalCollectionLinks', 155, 168),
(80, 79, NULL, NULL, 'listall', 156, 157),
(81, 79, NULL, NULL, 'detail', 158, 159),
(82, 79, NULL, NULL, 'add', 160, 161),
(83, 79, NULL, NULL, 'edit', 162, 163),
(84, 79, NULL, NULL, 'delete', 164, 165),
(85, 79, NULL, NULL, 'allowClinicalCollectionLinkDeletion', 166, 167),
(86, 78, NULL, NULL, 'ConsentMasters', 169, 182),
(87, 86, NULL, NULL, 'listall', 170, 171),
(88, 86, NULL, NULL, 'detail', 172, 173),
(89, 86, NULL, NULL, 'add', 174, 175),
(90, 86, NULL, NULL, 'edit', 176, 177),
(91, 86, NULL, NULL, 'delete', 178, 179),
(92, 86, NULL, NULL, 'allowConsentDeletion', 180, 181),
(93, 78, NULL, NULL, 'DiagnosisMasters', 183, 198),
(94, 93, NULL, NULL, 'listall', 184, 185),
(95, 93, NULL, NULL, 'detail', 186, 187),
(96, 93, NULL, NULL, 'add', 188, 189),
(97, 93, NULL, NULL, 'edit', 190, 191),
(98, 93, NULL, NULL, 'delete', 192, 193),
(99, 93, NULL, NULL, 'allowDiagnosisDeletion', 194, 195),
(100, 93, NULL, NULL, 'buildAndSetExistingDx', 196, 197),
(101, 78, NULL, NULL, 'EventMasters', 199, 214),
(102, 101, NULL, NULL, 'listall', 200, 201),
(103, 101, NULL, NULL, 'detail', 202, 203),
(104, 101, NULL, NULL, 'add', 204, 205),
(105, 101, NULL, NULL, 'edit', 206, 207),
(106, 101, NULL, NULL, 'delete', 208, 209),
(107, 101, NULL, NULL, 'allowEventDeletion', 210, 211),
(108, 78, NULL, NULL, 'FamilyHistories', 215, 228),
(109, 108, NULL, NULL, 'listall', 216, 217),
(110, 108, NULL, NULL, 'detail', 218, 219),
(111, 108, NULL, NULL, 'add', 220, 221),
(112, 108, NULL, NULL, 'edit', 222, 223),
(113, 108, NULL, NULL, 'delete', 224, 225),
(114, 108, NULL, NULL, 'allowFamilyHistoryDeletion', 226, 227),
(115, 78, NULL, NULL, 'MiscIdentifiers', 229, 246),
(116, 115, NULL, NULL, 'index', 230, 231),
(117, 115, NULL, NULL, 'search', 232, 233),
(118, 115, NULL, NULL, 'listall', 234, 235),
(119, 115, NULL, NULL, 'detail', 236, 237),
(120, 115, NULL, NULL, 'add', 238, 239),
(121, 115, NULL, NULL, 'edit', 240, 241),
(122, 115, NULL, NULL, 'delete', 242, 243),
(123, 115, NULL, NULL, 'allowMiscIdentifierDeletion', 244, 245),
(124, 78, NULL, NULL, 'ParticipantContacts', 247, 260),
(125, 124, NULL, NULL, 'listall', 248, 249),
(126, 124, NULL, NULL, 'detail', 250, 251),
(127, 124, NULL, NULL, 'add', 252, 253),
(128, 124, NULL, NULL, 'edit', 254, 255),
(129, 124, NULL, NULL, 'delete', 256, 257),
(130, 124, NULL, NULL, 'allowParticipantContactDeletion', 258, 259),
(131, 78, NULL, NULL, 'ParticipantMessages', 261, 274),
(132, 131, NULL, NULL, 'listall', 262, 263),
(133, 131, NULL, NULL, 'detail', 264, 265),
(134, 131, NULL, NULL, 'add', 266, 267),
(135, 131, NULL, NULL, 'edit', 268, 269),
(136, 131, NULL, NULL, 'delete', 270, 271),
(137, 131, NULL, NULL, 'allowParticipantMessageDeletion', 272, 273),
(138, 78, NULL, NULL, 'Participants', 275, 292),
(139, 138, NULL, NULL, 'index', 276, 277),
(140, 138, NULL, NULL, 'search', 278, 279),
(141, 138, NULL, NULL, 'profile', 280, 281),
(142, 138, NULL, NULL, 'add', 282, 283),
(143, 138, NULL, NULL, 'edit', 284, 285),
(144, 138, NULL, NULL, 'delete', 286, 287),
(145, 138, NULL, NULL, 'allowParticipantDeletion', 288, 289),
(146, 138, NULL, NULL, 'chronology', 290, 291),
(147, 78, NULL, NULL, 'ProductMasters', 293, 296),
(148, 147, NULL, NULL, 'productsTreeView', 294, 295),
(149, 78, NULL, NULL, 'ReproductiveHistories', 297, 310),
(150, 149, NULL, NULL, 'listall', 298, 299),
(151, 149, NULL, NULL, 'detail', 300, 301),
(152, 149, NULL, NULL, 'add', 302, 303),
(153, 149, NULL, NULL, 'edit', 304, 305),
(154, 149, NULL, NULL, 'delete', 306, 307),
(155, 149, NULL, NULL, 'allowReproductiveHistoryDeletion', 308, 309),
(156, 78, NULL, NULL, 'TreatmentExtends', 311, 322),
(157, 156, NULL, NULL, 'listall', 312, 313),
(158, 156, NULL, NULL, 'detail', 314, 315),
(159, 156, NULL, NULL, 'add', 316, 317),
(160, 156, NULL, NULL, 'edit', 318, 319),
(161, 156, NULL, NULL, 'delete', 320, 321),
(162, 78, NULL, NULL, 'TreatmentMasters', 323, 334),
(163, 162, NULL, NULL, 'listall', 324, 325),
(164, 162, NULL, NULL, 'detail', 326, 327),
(165, 162, NULL, NULL, 'edit', 328, 329),
(166, 162, NULL, NULL, 'add', 330, 331),
(167, 162, NULL, NULL, 'delete', 332, 333),
(168, 1, NULL, NULL, 'Codingicd10', 336, 343),
(169, 168, NULL, NULL, 'CodingIcd10s', 337, 342),
(170, 169, NULL, NULL, 'tool', 338, 339),
(171, 169, NULL, NULL, 'autoComplete', 340, 341),
(172, 1, NULL, NULL, 'Customize', 344, 367),
(173, 172, NULL, NULL, 'Announcements', 345, 350),
(174, 173, NULL, NULL, 'index', 346, 347),
(175, 173, NULL, NULL, 'detail', 348, 349),
(176, 172, NULL, NULL, 'Passwords', 351, 354),
(177, 176, NULL, NULL, 'index', 352, 353),
(178, 172, NULL, NULL, 'Preferences', 355, 360),
(179, 178, NULL, NULL, 'index', 356, 357),
(180, 178, NULL, NULL, 'edit', 358, 359),
(181, 172, NULL, NULL, 'Profiles', 361, 366),
(182, 181, NULL, NULL, 'index', 362, 363),
(183, 181, NULL, NULL, 'edit', 364, 365),
(184, 1, NULL, NULL, 'Datamart', 368, 417),
(185, 184, NULL, NULL, 'AdhocSaved', 369, 382),
(186, 185, NULL, NULL, 'index', 370, 371),
(187, 185, NULL, NULL, 'add', 372, 373),
(188, 185, NULL, NULL, 'search', 374, 375),
(189, 185, NULL, NULL, 'results', 376, 377),
(190, 185, NULL, NULL, 'edit', 378, 379),
(191, 185, NULL, NULL, 'delete', 380, 381),
(192, 184, NULL, NULL, 'Adhocs', 383, 398),
(193, 192, NULL, NULL, 'index', 384, 385),
(194, 192, NULL, NULL, 'favourite', 386, 387),
(195, 192, NULL, NULL, 'unfavourite', 388, 389),
(196, 192, NULL, NULL, 'search', 390, 391),
(197, 192, NULL, NULL, 'results', 392, 393),
(198, 192, NULL, NULL, 'process', 394, 395),
(199, 192, NULL, NULL, 'csv', 396, 397),
(200, 184, NULL, NULL, 'BatchSets', 399, 416),
(201, 200, NULL, NULL, 'index', 400, 401),
(202, 200, NULL, NULL, 'listall', 402, 403),
(203, 200, NULL, NULL, 'add', 404, 405),
(204, 200, NULL, NULL, 'edit', 406, 407),
(205, 200, NULL, NULL, 'delete', 408, 409),
(206, 200, NULL, NULL, 'process', 410, 411),
(207, 200, NULL, NULL, 'remove', 412, 413),
(208, 200, NULL, NULL, 'csv', 414, 415),
(209, 1, NULL, NULL, 'Drug', 418, 435),
(210, 209, NULL, NULL, 'Drugs', 419, 434),
(211, 210, NULL, NULL, 'index', 420, 421),
(212, 210, NULL, NULL, 'search', 422, 423),
(213, 210, NULL, NULL, 'listall', 424, 425),
(214, 210, NULL, NULL, 'add', 426, 427),
(215, 210, NULL, NULL, 'edit', 428, 429),
(216, 210, NULL, NULL, 'detail', 430, 431),
(217, 210, NULL, NULL, 'delete', 432, 433),
(218, 1, NULL, NULL, 'Inventorymanagement', 436, 561),
(219, 218, NULL, NULL, 'AliquotMasters', 437, 492),
(220, 219, NULL, NULL, 'index', 438, 439),
(221, 219, NULL, NULL, 'search', 440, 441),
(222, 219, NULL, NULL, 'listAll', 442, 443),
(223, 219, NULL, NULL, 'add', 444, 445),
(224, 219, NULL, NULL, 'detail', 446, 447),
(225, 219, NULL, NULL, 'edit', 448, 449),
(226, 219, NULL, NULL, 'removeAliquotFromStorage', 450, 451),
(227, 219, NULL, NULL, 'delete', 452, 453),
(228, 219, NULL, NULL, 'addAliquotUse', 454, 455),
(229, 219, NULL, NULL, 'editAliquotUse', 456, 457),
(230, 219, NULL, NULL, 'deleteAliquotUse', 458, 459),
(231, 219, NULL, NULL, 'addSourceAliquots', 460, 461),
(232, 219, NULL, NULL, 'listAllSourceAliquots', 462, 463),
(233, 219, NULL, NULL, 'defineRealiquotedChildren', 464, 465),
(234, 219, NULL, NULL, 'listAllRealiquotedParents', 466, 467),
(235, 219, NULL, NULL, 'getStudiesList', 468, 469),
(236, 219, NULL, NULL, 'getSampleBlocksList', 470, 471),
(237, 219, NULL, NULL, 'getSampleGelMatricesList', 472, 473),
(238, 219, NULL, NULL, 'getDefaultAliquotStorageDate', 474, 475),
(239, 219, NULL, NULL, 'isDuplicatedAliquotBarcode', 476, 477),
(240, 219, NULL, NULL, 'formatAliquotFieldDecimalData', 478, 479),
(241, 219, NULL, NULL, 'validateAliquotStorageData', 480, 481),
(242, 219, NULL, NULL, 'allowAliquotDeletion', 482, 483),
(243, 219, NULL, NULL, 'getDefaultRealiquotingDate', 484, 485),
(244, 219, NULL, NULL, 'formatPreselectedStoragesForDisplay', 486, 487),
(245, 219, NULL, NULL, 'formatBlocksForDisplay', 488, 489),
(246, 219, NULL, NULL, 'formatGelMatricesForDisplay', 490, 491),
(247, 218, NULL, NULL, 'Collections', 493, 508),
(248, 247, NULL, NULL, 'index', 494, 495),
(249, 247, NULL, NULL, 'search', 496, 497),
(250, 247, NULL, NULL, 'detail', 498, 499),
(251, 247, NULL, NULL, 'add', 500, 501),
(252, 247, NULL, NULL, 'edit', 502, 503),
(253, 247, NULL, NULL, 'delete', 504, 505),
(254, 247, NULL, NULL, 'allowCollectionDeletion', 506, 507),
(255, 218, NULL, NULL, 'PathCollectionReviews', 509, 510),
(256, 218, NULL, NULL, 'QualityCtrls', 511, 530),
(257, 256, NULL, NULL, 'listAll', 512, 513),
(258, 256, NULL, NULL, 'add', 514, 515),
(259, 256, NULL, NULL, 'detail', 516, 517),
(260, 256, NULL, NULL, 'edit', 518, 519),
(261, 256, NULL, NULL, 'if', 520, 521),
(262, 256, NULL, NULL, 'delete', 522, 523),
(263, 256, NULL, NULL, 'addTestedAliquots', 524, 525),
(264, 256, NULL, NULL, 'allowQcDeletion', 526, 527),
(265, 256, NULL, NULL, 'createQcCode', 528, 529),
(266, 218, NULL, NULL, 'ReviewMasters', 531, 532),
(267, 218, NULL, NULL, 'SampleMasters', 533, 560),
(268, 267, NULL, NULL, 'index', 534, 535),
(269, 267, NULL, NULL, 'search', 536, 537),
(270, 267, NULL, NULL, 'contentTreeView', 538, 539),
(271, 267, NULL, NULL, 'listAll', 540, 541),
(272, 267, NULL, NULL, 'detail', 542, 543),
(273, 267, NULL, NULL, 'add', 544, 545),
(274, 267, NULL, NULL, 'edit', 546, 547),
(275, 267, NULL, NULL, 'delete', 548, 549),
(276, 267, NULL, NULL, 'createSampleCode', 550, 551),
(277, 267, NULL, NULL, 'allowSampleDeletion', 552, 553),
(278, 267, NULL, NULL, 'getTissueSourceList', 554, 555),
(279, 267, NULL, NULL, 'formatSampleFieldDecimalData', 556, 557),
(280, 267, NULL, NULL, 'formatParentSampleDataForDisplay', 558, 559),
(281, 1, NULL, NULL, 'Material', 562, 579),
(282, 281, NULL, NULL, 'Materials', 563, 578),
(283, 282, NULL, NULL, 'index', 564, 565),
(284, 282, NULL, NULL, 'search', 566, 567),
(285, 282, NULL, NULL, 'listall', 568, 569),
(286, 282, NULL, NULL, 'add', 570, 571),
(287, 282, NULL, NULL, 'edit', 572, 573),
(288, 282, NULL, NULL, 'detail', 574, 575),
(289, 282, NULL, NULL, 'delete', 576, 577),
(290, 1, NULL, NULL, 'Order', 580, 651),
(291, 290, NULL, NULL, 'OrderItems', 581, 594),
(292, 291, NULL, NULL, 'listall', 582, 583),
(293, 291, NULL, NULL, 'add', 584, 585),
(294, 291, NULL, NULL, 'addAliquotsInBatch', 586, 587),
(295, 291, NULL, NULL, 'edit', 588, 589),
(296, 291, NULL, NULL, 'delete', 590, 591),
(297, 291, NULL, NULL, 'allowOrderItemDeletion', 592, 593),
(298, 290, NULL, NULL, 'OrderLines', 595, 610),
(299, 298, NULL, NULL, 'listall', 596, 597),
(300, 298, NULL, NULL, 'add', 598, 599),
(301, 298, NULL, NULL, 'edit', 600, 601),
(302, 298, NULL, NULL, 'detail', 602, 603),
(303, 298, NULL, NULL, 'delete', 604, 605),
(304, 298, NULL, NULL, 'generateSampleAliquotControlList', 606, 607),
(305, 298, NULL, NULL, 'allowOrderLineDeletion', 608, 609),
(306, 290, NULL, NULL, 'Orders', 611, 628),
(307, 306, NULL, NULL, 'index', 612, 613),
(308, 306, NULL, NULL, 'search', 614, 615),
(309, 306, NULL, NULL, 'add', 616, 617),
(310, 306, NULL, NULL, 'detail', 618, 619),
(311, 306, NULL, NULL, 'edit', 620, 621),
(312, 306, NULL, NULL, 'delete', 622, 623),
(313, 306, NULL, NULL, 'getStudiesList', 624, 625),
(314, 306, NULL, NULL, 'allowOrderDeletion', 626, 627),
(315, 290, NULL, NULL, 'Shipments', 629, 650),
(316, 315, NULL, NULL, 'listall', 630, 631),
(317, 315, NULL, NULL, 'add', 632, 633),
(318, 315, NULL, NULL, 'edit', 634, 635),
(319, 315, NULL, NULL, 'if', 636, 637),
(320, 315, NULL, NULL, 'detail', 638, 639),
(321, 315, NULL, NULL, 'delete', 640, 641),
(322, 315, NULL, NULL, 'addToShipment', 642, 643),
(323, 315, NULL, NULL, 'deleteFromShipment', 644, 645),
(324, 315, NULL, NULL, 'allowShipmentDeletion', 646, 647),
(325, 315, NULL, NULL, 'allowItemRemoveFromShipment', 648, 649),
(326, 1, NULL, NULL, 'Protocol', 652, 681),
(327, 326, NULL, NULL, 'ProtocolExtends', 653, 664),
(328, 327, NULL, NULL, 'listall', 654, 655),
(329, 327, NULL, NULL, 'detail', 656, 657),
(330, 327, NULL, NULL, 'add', 658, 659),
(331, 327, NULL, NULL, 'edit', 660, 661),
(332, 327, NULL, NULL, 'delete', 662, 663),
(333, 326, NULL, NULL, 'ProtocolMasters', 665, 680),
(334, 333, NULL, NULL, 'index', 666, 667),
(335, 333, NULL, NULL, 'search', 668, 669),
(336, 333, NULL, NULL, 'listall', 670, 671),
(337, 333, NULL, NULL, 'add', 672, 673),
(338, 333, NULL, NULL, 'detail', 674, 675),
(339, 333, NULL, NULL, 'edit', 676, 677),
(340, 333, NULL, NULL, 'delete', 678, 679),
(341, 1, NULL, NULL, 'Provider', 682, 699),
(342, 341, NULL, NULL, 'Providers', 683, 698),
(343, 342, NULL, NULL, 'index', 684, 685),
(344, 342, NULL, NULL, 'search', 686, 687),
(345, 342, NULL, NULL, 'listall', 688, 689),
(346, 342, NULL, NULL, 'add', 690, 691),
(347, 342, NULL, NULL, 'detail', 692, 693),
(348, 342, NULL, NULL, 'edit', 694, 695),
(349, 342, NULL, NULL, 'delete', 696, 697),
(350, 1, NULL, NULL, 'Rtbform', 700, 715),
(351, 350, NULL, NULL, 'Rtbforms', 701, 714),
(352, 351, NULL, NULL, 'index', 702, 703),
(353, 351, NULL, NULL, 'search', 704, 705),
(354, 351, NULL, NULL, 'profile', 706, 707),
(355, 351, NULL, NULL, 'add', 708, 709),
(356, 351, NULL, NULL, 'edit', 710, 711),
(357, 351, NULL, NULL, 'delete', 712, 713),
(358, 1, NULL, NULL, 'Sop', 716, 741),
(359, 358, NULL, NULL, 'SopExtends', 717, 728),
(360, 359, NULL, NULL, 'listall', 718, 719),
(361, 359, NULL, NULL, 'detail', 720, 721),
(362, 359, NULL, NULL, 'add', 722, 723),
(363, 359, NULL, NULL, 'edit', 724, 725),
(364, 359, NULL, NULL, 'delete', 726, 727),
(365, 358, NULL, NULL, 'SopMasters', 729, 740),
(366, 365, NULL, NULL, 'listall', 730, 731),
(367, 365, NULL, NULL, 'add', 732, 733),
(368, 365, NULL, NULL, 'detail', 734, 735),
(369, 365, NULL, NULL, 'edit', 736, 737),
(370, 365, NULL, NULL, 'delete', 738, 739),
(371, 1, NULL, NULL, 'Storagelayout', 742, 817),
(372, 371, NULL, NULL, 'StorageCoordinates', 743, 756),
(373, 372, NULL, NULL, 'listAll', 744, 745),
(374, 372, NULL, NULL, 'add', 746, 747),
(375, 372, NULL, NULL, 'delete', 748, 749),
(376, 372, NULL, NULL, 'allowStorageCoordinateDeletion', 750, 751),
(377, 372, NULL, NULL, 'isDuplicatedValue', 752, 753),
(378, 372, NULL, NULL, 'isDuplicatedOrder', 754, 755),
(379, 371, NULL, NULL, 'StorageMasters', 757, 798),
(380, 379, NULL, NULL, 'index', 758, 759),
(381, 379, NULL, NULL, 'search', 760, 761),
(382, 379, NULL, NULL, 'detail', 762, 763),
(383, 379, NULL, NULL, 'add', 764, 765),
(384, 379, NULL, NULL, 'edit', 766, 767),
(385, 379, NULL, NULL, 'editStoragePosition', 768, 769),
(386, 379, NULL, NULL, 'delete', 770, 771),
(387, 379, NULL, NULL, 'contentTreeView', 772, 773),
(388, 379, NULL, NULL, 'completeStorageContent', 774, 775),
(389, 379, NULL, NULL, 'storageLayout', 776, 777),
(390, 379, NULL, NULL, 'setStorageCoordinateValues', 778, 779),
(391, 379, NULL, NULL, 'allowStorageDeletion', 780, 781),
(392, 379, NULL, NULL, 'getStorageSelectionLabel', 782, 783),
(393, 379, NULL, NULL, 'updateChildrenStorageSelectionLabel', 784, 785),
(394, 379, NULL, NULL, 'createSelectionLabel', 786, 787),
(395, 379, NULL, NULL, 'IsDuplicatedStorageBarCode', 788, 789),
(396, 379, NULL, NULL, 'createStorageCode', 790, 791),
(397, 379, NULL, NULL, 'updateChildrenSurroundingTemperature', 792, 793),
(398, 379, NULL, NULL, 'updateAndSaveDataArray', 794, 795),
(399, 379, NULL, NULL, 'buildChildrenArray', 796, 797),
(400, 371, NULL, NULL, 'TmaSlides', 799, 816),
(401, 400, NULL, NULL, 'listAll', 800, 801),
(402, 400, NULL, NULL, 'add', 802, 803),
(403, 400, NULL, NULL, 'detail', 804, 805),
(404, 400, NULL, NULL, 'edit', 806, 807),
(405, 400, NULL, NULL, 'delete', 808, 809),
(406, 400, NULL, NULL, 'isDuplicatedTmaSlideBarcode', 810, 811),
(407, 400, NULL, NULL, 'allowTMASlideDeletion', 812, 813),
(408, 400, NULL, NULL, 'formatPreselectedStoragesForDisplay', 814, 815),
(409, 1, NULL, NULL, 'Study', 818, 931),
(410, 409, NULL, NULL, 'StudyContacts', 819, 832),
(411, 410, NULL, NULL, 'listall', 820, 821),
(412, 410, NULL, NULL, 'detail', 822, 823),
(413, 410, NULL, NULL, 'add', 824, 825),
(414, 410, NULL, NULL, 'edit', 826, 827),
(415, 410, NULL, NULL, 'delete', 828, 829),
(416, 410, NULL, NULL, 'allowStudyContactDeletion', 830, 831),
(417, 409, NULL, NULL, 'StudyEthicsBoards', 833, 846),
(418, 417, NULL, NULL, 'listall', 834, 835),
(419, 417, NULL, NULL, 'detail', 836, 837),
(420, 417, NULL, NULL, 'add', 838, 839),
(421, 417, NULL, NULL, 'edit', 840, 841),
(422, 417, NULL, NULL, 'delete', 842, 843),
(423, 417, NULL, NULL, 'allowStudyEthicsBoardDeletion', 844, 845),
(424, 409, NULL, NULL, 'StudyFundings', 847, 860),
(425, 424, NULL, NULL, 'listall', 848, 849),
(426, 424, NULL, NULL, 'detail', 850, 851),
(427, 424, NULL, NULL, 'add', 852, 853),
(428, 424, NULL, NULL, 'edit', 854, 855),
(429, 424, NULL, NULL, 'delete', 856, 857),
(430, 424, NULL, NULL, 'allowStudyFundingDeletion', 858, 859),
(431, 409, NULL, NULL, 'StudyInvestigators', 861, 874),
(432, 431, NULL, NULL, 'listall', 862, 863),
(433, 431, NULL, NULL, 'detail', 864, 865),
(434, 431, NULL, NULL, 'add', 866, 867),
(435, 431, NULL, NULL, 'edit', 868, 869),
(436, 431, NULL, NULL, 'delete', 870, 871),
(437, 431, NULL, NULL, 'allowStudyInvestigatorDeletion', 872, 873),
(438, 409, NULL, NULL, 'StudyRelated', 875, 888),
(439, 438, NULL, NULL, 'listall', 876, 877),
(440, 438, NULL, NULL, 'detail', 878, 879),
(441, 438, NULL, NULL, 'add', 880, 881),
(442, 438, NULL, NULL, 'edit', 882, 883),
(443, 438, NULL, NULL, 'delete', 884, 885),
(444, 438, NULL, NULL, 'allowStudyRelatedDeletion', 886, 887),
(445, 409, NULL, NULL, 'StudyResults', 889, 902),
(446, 445, NULL, NULL, 'listall', 890, 891),
(447, 445, NULL, NULL, 'detail', 892, 893),
(448, 445, NULL, NULL, 'add', 894, 895),
(449, 445, NULL, NULL, 'edit', 896, 897),
(450, 445, NULL, NULL, 'delete', 898, 899),
(451, 445, NULL, NULL, 'allowStudyResultDeletion', 900, 901),
(452, 409, NULL, NULL, 'StudyReviews', 903, 916),
(453, 452, NULL, NULL, 'listall', 904, 905),
(454, 452, NULL, NULL, 'detail', 906, 907),
(455, 452, NULL, NULL, 'add', 908, 909),
(456, 452, NULL, NULL, 'edit', 910, 911),
(457, 452, NULL, NULL, 'delete', 912, 913),
(458, 452, NULL, NULL, 'allowStudyReviewDeletion', 914, 915),
(459, 409, NULL, NULL, 'StudySummaries', 917, 930),
(460, 459, NULL, NULL, 'listall', 918, 919),
(461, 459, NULL, NULL, 'detail', 920, 921),
(462, 459, NULL, NULL, 'add', 922, 923),
(463, 459, NULL, NULL, 'edit', 924, 925),
(464, 459, NULL, NULL, 'delete', 926, 927),
(465, 459, NULL, NULL, 'allowStudySummaryDeletion', 928, 929),
(466, 101, NULL, NULL, 'imageryReport', 212, 213);

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('add other clinical event', '', 'Add Other Data', 'Ajouter autres données'),
('add medical history', '', 'Add Medical History', 'Ajouter évenement clinique'),
('add medical imaging', '', 'Add Medical Imaging', 'Ajouter image médicale'),

('this type of event has already been created for your participant', '', 
  'This type of annotation has already been created for your participant!', 
  'Ce type d''annotation a déjà eacyte;té créée pour votre participant!'),

('annotation clinical details', '', 'Details', 'Détails'),
('annotation clinical reports', '', 'Reports', 'Rapports');

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`) VALUES
(null, 'hepatobiliary', 'clinical', 'presentation', '1', 'qc_hb_ed_hepatobiliary_clinical_presentation', 'qc_hb_ed_hepatobiliary_clinical_presentation', 0);

CREATE TABLE IF NOT EXISTS `qc_hb_ed_hepatobiliary_clinical_presentation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  
  `weight` decimal(7,3) DEFAULT NULL,
  `height` decimal(7,3) DEFAULT NULL,
  `bmi` decimal(10,3) DEFAULT NULL,
  `referral_hospital` varchar(50) DEFAULT NULL,
  `referral_physisian` varchar(50) DEFAULT NULL,
  `referral_physisian_speciality` varchar(50) DEFAULT NULL,
  `referral_physisian_2` varchar(50) DEFAULT NULL,
  `referral_physisian_speciality_2` varchar(50) DEFAULT NULL,
  `referral_physisian_3` varchar(50) DEFAULT NULL,
  `referral_physisian_speciality_3` varchar(50) DEFAULT NULL,
  `hbp_surgeon` varchar(50) DEFAULT NULL,
  `event_master_id` int(11) NOT NULL,
  
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `qc_hb_ed_hepatobiliary_clinical_presentation`
  ADD FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

CREATE TABLE IF NOT EXISTS `qc_hb_ed_hepatobiliary_clinical_presentation_revs` (
  `id` int(11) NOT NULL,
  
  `weight` decimal(7,3) DEFAULT NULL,
  `height` decimal(7,3) DEFAULT NULL,
  `bmi` decimal(10,3) DEFAULT NULL,
  `referral_hospital` varchar(50) DEFAULT NULL,
  `referral_physisian` varchar(50) DEFAULT NULL,
  `referral_physisian_speciality` varchar(50) DEFAULT NULL,
  `referral_physisian_2` varchar(50) DEFAULT NULL,
  `referral_physisian_speciality_2` varchar(50) DEFAULT NULL,
  `referral_physisian_3` varchar(50) DEFAULT NULL,
  `referral_physisian_speciality_3` varchar(50) DEFAULT NULL,
  `hbp_surgeon` varchar(50) DEFAULT NULL,
  `event_master_id` int(11) NOT NULL,
  
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO `structures` 
(`id`, `alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, 'qc_hb_ed_hepatobiliary_clinical_presentation', '', '', '1', '1', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`) VALUES ('qc_hb_specialty', '', '');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('general physician', 'general physician');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_specialty'),  (SELECT id FROM structure_permissible_values WHERE value='general physician' AND language_alias='general physician'), '', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('gastroenterologist', 'gastroenterologist');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_specialty'),  (SELECT id FROM structure_permissible_values WHERE value='gastroenterologist' AND language_alias='gastroenterologist'), '', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('surgeon', 'surgeon');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_specialty'),  (SELECT id FROM structure_permissible_values WHERE value='surgeon' AND language_alias='surgeon'), '', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('oncologist', 'oncologist');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_specialty'),  (SELECT id FROM structure_permissible_values WHERE value='oncologist' AND language_alias='oncologist'), '', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('other', 'other');

INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_specialty'),  (SELECT id FROM structure_permissible_values WHERE value='other' AND language_alias='other'), '', '1');
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`) VALUES ('qc_hb_hbp_surgeon_list', '', '');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('dagenais', 'dagenais');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_hbp_surgeon_list'),  (SELECT id FROM structure_permissible_values WHERE value='dagenais' AND language_alias='dagenais'), '', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('lapointe', 'lapointe');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_hbp_surgeon_list'),  (SELECT id FROM structure_permissible_values WHERE value='lapointe' AND language_alias='lapointe'), '', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('letourneau', 'letourneau');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_hbp_surgeon_list'),  (SELECT id FROM structure_permissible_values WHERE value='letourneau' AND language_alias='letourneau'), '', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('plasse', 'plasse');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_hbp_surgeon_list'),  (SELECT id FROM structure_permissible_values WHERE value='plasse' AND language_alias='plasse'), '', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('roy', 'roy');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_hbp_surgeon_list'),  (SELECT id FROM structure_permissible_values WHERE value='roy' AND language_alias='roy'), '', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('vanderbroucke-menu', 'vanderbroucke-menu');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_hbp_surgeon_list'),  (SELECT id FROM structure_permissible_values WHERE value='vanderbroucke-menu' AND language_alias='vanderbroucke-menu'), '', '1');

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('bmi', '', 'BMI', 'IMC'),

('general physician', '', 'General Physician', 'Médecin généraliste'),
('gastroenterologist', '', 'Gastro-Enterologist', 'Gastro-entérologue'),
('surgeon', '', 'Surgeon', 'Chirurgien'),
('oncologist', '', 'Oncologist', 'Oncologue'),

('dagenais', '', 'Dr. Dagenais', 'Dr. Dagenais'),
('letourneau', '', 'Dr. Létourneau', 'Dr. Létourneau'),
('lapointe', '', 'Dr. Lapointe', 'Dr. Lapointe'),
('plasse', '', 'Dr. Plasse', 'Dr. Plasse'),
('roy', '', 'Dr. Roy', 'Dr. Roy'),
('vanderbroucke-menu', '', 'Dr. Vanderbroucke-Menu', 'Dr. Vanderbroucke-Menu');

INSERT INTO `structure_fields` 
(`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, '', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_clinical_presentation', 'weight', 'weight', '', 'input', 'size=10', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_clinical_presentation', 'height', 'height', '', 'input', 'size=10', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_clinical_presentation', 'bmi', 'bmi', '', 'input', 'size=10', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_clinical_presentation', 'referral_hospital', 'referral hospital', '', 'input', 'size=30', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_clinical_presentation', 'referral_physisian', 'referral physisian', '', 'input', 'size=10', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_clinical_presentation', 'referral_physisian_speciality', '', 'referral physisian speciality', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_specialty'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_clinical_presentation', 'referral_physisian_2', 'referral physisian 2', '', 'input', 'size=10', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_clinical_presentation', 'referral_physisian_speciality_2', '', 'referral physisian speciality', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_specialty'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_clinical_presentation', 'referral_physisian_3', 'referral physisian 3', '', 'input', 'size=10', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_clinical_presentation', 'referral_physisian_speciality_3', '', 'referral physisian speciality', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_specialty'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_clinical_presentation', 'hbp_surgeon', 'hbp surgeron', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_hbp_surgeon_list'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('hbp surgeron', '', 'HBP Surgeron', 'Chirurgien HBP'),
('first consultation date', 'global', 'First Consultation Date', 'Date première consultation'),
('referral data', 'global', 'Referral', 'Référent'),
('referral hospital', 'global', 'Referral Hospital', 'Hôpital référent'),
('referral physisian', 'global', 'Referral Physisian', 'Medecin référent'),
('referral physisian 2', 'global', '2nd Referral Physisian', '2nd Medecin référent'),
('referral physisian 3', 'global', '3rd Referral Physisian', '3eme Medecin référent'),
('referral physisian speciality', 'global', 'Speciality', 'Spécialité');

SET @QC_HB_000001_structure_id = (SELECT id FROM structures WHERE alias = 'qc_hb_ed_hepatobiliary_clinical_presentation');
INSERT INTO `structure_formats` (`id`, `structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
-- first_consultation_date
(null, @QC_HB_000001_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventMaster' AND tablename = 'event_masters' AND field IN ('event_date')), 0, 1, '', '1', 'first consultation date', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

-- disease_site
(null, @QC_HB_000001_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventMaster' AND tablename = 'event_masters' AND field IN ('disease_site')), 0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- event_type
(null, @QC_HB_000001_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventMaster' AND tablename = 'event_masters' AND field IN ('event_type')), 0, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
	
-- hbp_surgeon
(null, @QC_HB_000001_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobiliary_clinical_presentation' AND field IN ('hbp_surgeon')), 0, 20, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

-- weight
(null, @QC_HB_000001_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobiliary_clinical_presentation' AND field IN ('weight')), 0, 10, '', '1', 'weight (kg)', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- height
(null, @QC_HB_000001_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobiliary_clinical_presentation' AND field IN ('height')), 0, 11, '', '1', 'height (cm)', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- bmi
(null, @QC_HB_000001_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobiliary_clinical_presentation' AND field IN ('bmi')), 0, 12, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

-- event_summary
(null, @QC_HB_000001_structure_id,
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventMaster' AND tablename = 'event_masters' AND field IN ('event_summary')), 0, 20, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

-- referral_hospital
(null, @QC_HB_000001_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobiliary_clinical_presentation' AND field IN ('referral_hospital')), 1, 30, 'referral data', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- referral_physisian 
(null, @QC_HB_000001_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobiliary_clinical_presentation' AND field IN ('referral_physisian')), 1, 31, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- referral_physisian_speciality
(null, @QC_HB_000001_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobiliary_clinical_presentation' AND field IN ('referral_physisian_speciality')), 1, 32, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- referral_physisian 2
(null, @QC_HB_000001_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobiliary_clinical_presentation' AND field IN ('referral_physisian_2')), 1, 33, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- referral_physisian_speciality 2
(null, @QC_HB_000001_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobiliary_clinical_presentation' AND field IN ('referral_physisian_speciality_2')), 1, 34, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- referral_physisian 3 
(null, @QC_HB_000001_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobiliary_clinical_presentation' AND field IN ('referral_physisian_3')), 1, 35, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- referral_physisian_speciality 3
(null, @QC_HB_000001_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobiliary_clinical_presentation' AND field IN ('referral_physisian_speciality_3')), 1, 36, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
  
INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, (SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobiliary_clinical_presentation' AND field IN ('weight')), 'custom,/^([0-9]+(\\.[0-9]+)?)?$/', '1', '0', '', 'weight should be a positif decimal', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, (SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobiliary_clinical_presentation' AND field IN ('height')), 'custom,/^([0-9]+(\\.[0-9]+)?)?$/', '1', '0', '', 'height should be a positif decimal', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES

('weight (kg)', 'global', 'Weight (kg)', 'Poids (kg)'),
('height (cm)', 'global', 'Height (cm)', 'Taille (cm)'),

('weight should be a positif decimal', 'global', 'Weight should be a positive decimal!', 'Le poids doit être un décimal positif!'),
('height should be a positif decimal', 'global', 'Height should be a positive decimal!', 'Le taille doit être un décimal positif!'),
('hepatobiliary', 'global', 'Hepatobiliary', 'Hépato-biliaire'),
('presentation', 'global', 'Presentation', 'Présentation');

-- ... CLINIC: medical_past_history ....................................

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`) 
VALUES
(null, 'hepatobiliary', 'clinical', 'asa medical past history', '1', 'qc_hb_ed_hepatobiliary_medical_past_history', 'qc_hb_ed_hepatobiliary_medical_past_history', 0),
(null, 'hepatobiliary', 'clinical', 'heart disease medical past history', '1', 'qc_hb_ed_hepatobiliary_medical_past_history', 'qc_hb_ed_hepatobiliary_medical_past_history', 0),
(null, 'hepatobiliary', 'clinical', 'vascular disease medical past history', '1', 'qc_hb_ed_hepatobiliary_medical_past_history', 'qc_hb_ed_hepatobiliary_medical_past_history', 0),
(null, 'hepatobiliary', 'clinical', 'respiratory disease medical past history', '1', 'qc_hb_ed_hepatobiliary_medical_past_history', 'qc_hb_ed_hepatobiliary_medical_past_history', 0),
(null, 'hepatobiliary', 'clinical', 'neural vascular disease medical past history', '1', 'qc_hb_ed_hepatobiliary_medical_past_history', 'qc_hb_ed_hepatobiliary_medical_past_history', 0),
(null, 'hepatobiliary', 'clinical', 'endocrine disease medical past history', '1', 'qc_hb_ed_hepatobiliary_medical_past_history', 'qc_hb_ed_hepatobiliary_medical_past_history', 0),
(null, 'hepatobiliary', 'clinical', 'urinary disease medical past history', '1', 'qc_hb_ed_hepatobiliary_medical_past_history', 'qc_hb_ed_hepatobiliary_medical_past_history', 0),
(null, 'hepatobiliary', 'clinical', 'gastro-intestinal disease medical past history', '1', 'qc_hb_ed_hepatobiliary_medical_past_history', 'qc_hb_ed_hepatobiliary_medical_past_history', 0),
(null, 'hepatobiliary', 'clinical', 'gynecologic disease medical past history', '1', 'qc_hb_ed_hepatobiliary_medical_past_history', 'qc_hb_ed_hepatobiliary_medical_past_history', 0),
(null, 'hepatobiliary', 'clinical', 'other disease medical past history', '1', 'qc_hb_ed_hepatobiliary_medical_past_history', 'qc_hb_ed_hepatobiliary_medical_past_history', 0);

CREATE TABLE IF NOT EXISTS `qc_hb_hepatobiliary_medical_past_history_ctrls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_control_id` int(11) NOT NULL,
  `disease_precision` varchar(250) NOT NULL,
  `display_order` int(2) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `event_control_id` (`event_control_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `qc_hb_hepatobiliary_medical_past_history_ctrls`
  ADD FOREIGN KEY (`event_control_id`) REFERENCES `event_controls` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;
  
-- TODO Section to delete: Has been set for example, waiting for real values.
INSERT INTO `qc_hb_hepatobiliary_medical_past_history_ctrls` 
(`id`, `event_control_id`, `disease_precision`, `display_order`)
VALUES 
(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'asa medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), '1', '1'),
(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'asa medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), '2', '2'),
(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'asa medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), '3', '3'),
(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'asa medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), '4', '4'),
(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'asa medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), '5', '5'),

(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'heart disease medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), 'to define (heart)', '1'),
(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'vascular disease medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), 'to define (vascular)', '1'),
(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'respiratory disease medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), 'to define (respiratory)', '1'),
(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'neural vascular disease medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), 'to define (neural)', '1'),
(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'endocrine disease medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), 'to define (endocrine)', '1'),
(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'urinary disease medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), 'to define (urinary)', '1'),
(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'gastro-intestinal disease medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), 'to define (gastro-intestinal)', '1'),
(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'gynecologic disease medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), 'to define (gynecologic)', '1'),
(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'other disease medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), 'to define (other)', '1');
-- TODO End todo

INSERT INTO `structures` 
(`id`, `alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, 'qc_hb_ed_hepatobiliary_medical_past_history', '', '', '1', '1', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

CREATE TABLE IF NOT EXISTS `qc_hb_ed_hepatobiliary_medical_past_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  
  `disease_precision` varchar(250) DEFAULT NULL,
  `event_master_id` int(11) NOT NULL,
  
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `qc_hb_ed_hepatobiliary_medical_past_history`
  ADD FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

CREATE TABLE IF NOT EXISTS `qc_hb_ed_hepatobiliary_medical_past_history_revs` (
  `id` int(11) NOT NULL,
  
  `disease_precision` varchar(250) DEFAULT NULL,
  `event_master_id` int(11) NOT NULL,
  
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO `structure_fields` 
(`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, '', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_medical_past_history', 'disease_precision', 'medical history precision', '', 'select', '', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
SET @last_structure_field_id = LAST_INSERT_ID();

SET @QC_HB_000004_structure_id = (SELECT id FROM structures WHERE alias = 'qc_hb_ed_hepatobiliary_medical_past_history');
INSERT INTO `structure_formats` (`id`, `structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
-- date
(null, @QC_HB_000004_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventMaster' AND tablename = 'event_masters' AND field IN ('event_date')), 0, 1, '', '1', 'diagnostic date', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

-- disease_site
(null, @QC_HB_000004_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventMaster' AND tablename = 'event_masters' AND field IN ('disease_site')), 0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- event_type
(null, @QC_HB_000004_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventMaster' AND tablename = 'event_masters' AND field IN ('event_type')), 0, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
	
-- precision
(null, @QC_HB_000004_structure_id, 
@last_structure_field_id, 0, 10, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

-- event_summary
(null, @QC_HB_000004_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventMaster' AND tablename = 'event_masters' AND field IN ('event_summary')), 0, 20, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
-- TODO tranlsation
('asa medical past history', '', 'ASA', ''),
-- TODO end todo
('heart disease medical past history', '', 'Heart Disease', 'Maladie du coeur'),
('vascular disease medical past history', '', 'Vascular Disease', 'Maladie vasculaire'),
('respiratory disease medical past history', '', 'Respiratory Disease', 'Maladie respiratoire'),
('neural vascular disease medical past history', '', 'Neural Vascular Disease', 'Maladie vasculaire cerebrale'),
('endocrine disease medical past history', '', 'Endocrine Disease', 'Maladie endocrine'),
('urinary disease medical past history', '', 'Urinary Disease', 'Maladie urinaire'),
('gastro-intestinal disease medical past history', '', 'Gastro-Intestinal Disease', 'Maladie gastro-intestinal'),
('gynecologic disease medical past history', '', 'Gynecologic Disease', 'Maladie gynecologique'),
('other disease medical past history', '', 'Other Disease', 'Autre maladie'),

('diagnostic date', '', 'Diagnostic Date', 'Date de diagnostic'),
('medical history precision', '', 'Precision', 'Précision'),

('detail exists for the deleted medical past history', '', 
'Your data cannot be deleted! <br>Detail exist for the deleted medical past history.', 
'Vos données ne peuvent être supprimées! Des détails existent pour votre historique clinique.');

-- ... LIFESTYLE : summary .............................................

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`) VALUES
(null, 'hepatobiliary', 'lifestyle', 'summary', '1', 'qc_hb_ed_hepatobiliary_lifestyle', 'qc_hb_ed_hepatobiliary_lifestyle', 0);

CREATE TABLE IF NOT EXISTS `qc_hb_ed_hepatobiliary_lifestyle` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  
  `active_tobacco` varchar(10) DEFAULT NULL,
  `active_alcohol` varchar(10) DEFAULT NULL,
  `event_master_id` int(11) NOT NULL,
  
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `qc_hb_ed_hepatobiliary_lifestyle`
  ADD FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;
  
CREATE TABLE IF NOT EXISTS `qc_hb_ed_hepatobiliary_lifestyle_revs` (
  `id` int(11) NOT NULL,
  
  `active_tobacco` varchar(10) DEFAULT NULL,
  `active_alcohol` varchar(10) DEFAULT NULL,
  `event_master_id` int(11) NOT NULL,
  
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO `structures` 
(`id`, `alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, 'qc_hb_ed_hepatobiliary_lifestyle', '', '', '1', '1', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

SET @yesno_domains_id = (SELECT id  FROM `structure_value_domains` WHERE `domain_name` LIKE 'yesno');

INSERT INTO `structure_fields` 
(`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, '', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_lifestyle', 'active_tobacco', 'active_tobacco', '', 'select', '', '', @yesno_domains_id, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
SET @QC_HB_0000010_structure_field_id = LAST_INSERT_ID();

INSERT INTO `structure_fields` 
(`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, '', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_lifestyle', 'active_alcohol', 'active_alcohol', '', 'select', '', '', @yesno_domains_id, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
SET @QC_HB_0000011_structure_field_id = LAST_INSERT_ID();

SET @QC_HB_000002_structure_id = (SELECT id FROM structures WHERE alias = 'qc_hb_ed_hepatobiliary_lifestyle');
INSERT INTO `structure_formats` (`id`, `structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
-- date
(null, @QC_HB_000002_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventMaster' AND tablename = 'event_masters' AND field IN ('event_date')), 0, 1, '', '1', 'last update date', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

-- disease_site
(null, @QC_HB_000002_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventMaster' AND tablename = 'event_masters' AND field IN ('disease_site')), 0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- event_type
(null, @QC_HB_000002_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventMaster' AND tablename = 'event_masters' AND field IN ('event_type')), 0, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
	
-- active_tobacco
(null, @QC_HB_000002_structure_id, @QC_HB_0000010_structure_field_id, 0, 10, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- active_alcohol
(null, @QC_HB_000002_structure_id, @QC_HB_0000011_structure_field_id, 0, 11, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- event_summary
(null, @QC_HB_000002_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventMaster' AND tablename = 'event_masters' AND field IN ('event_summary')), 0, 20, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('active_tobacco', 'global', 'Active Tobacco', 'Tabagisme actif'),
('active_alcohol', 'global', 'Active Alcohol', 'Alcolisme chronique'),
('last update date', 'global', 'Last Update date', 'Date de mise à jour');

-- ... CLINIC: medical_past_history revision control ...................

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`) 
VALUES
(null, 'hepatobiliary', 'clinical', 'medical past history record summary', '1', 'qc_hb_ed_hepatobiliary_med_hist_record_summary', 'qc_hb_ed_hepatobiliary_med_hist_record_summary', 0);

INSERT INTO `structures` 
(`id`, `alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, 'qc_hb_ed_hepatobiliary_med_hist_record_summary', '', '', '1', '1', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

CREATE TABLE IF NOT EXISTS `qc_hb_ed_hepatobiliary_med_hist_record_summary` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  
  `asa_value` varchar(10) DEFAULT NULL,
  `heart_disease` varchar(10) DEFAULT NULL,
  `respiratory_disease` varchar(10) DEFAULT NULL,
  `vascular_disease` varchar(10) DEFAULT NULL,
  `neural_vascular_disease` varchar(10) DEFAULT NULL,
  `endocrine_disease` varchar(10) DEFAULT NULL,
  `urinary_disease` varchar(10) DEFAULT NULL,
  `gastro_intestinal_disease` varchar(10) DEFAULT NULL,
  `gynecologic_disease` varchar(10) DEFAULT NULL,
  `other_disease` varchar(10) DEFAULT NULL,
  `event_master_id` int(11) DEFAULT NULL,
  
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `qc_hb_ed_hepatobiliary_med_hist_record_summary`
  ADD FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

CREATE TABLE IF NOT EXISTS `qc_hb_ed_hepatobiliary_med_hist_record_summary_revs` (
  `id` int(11) NOT NULL,
  
  `asa_value` varchar(10) DEFAULT NULL,
  `heart_disease` varchar(10) DEFAULT NULL,
  `respiratory_disease` varchar(10) DEFAULT NULL,
  `vascular_disease` varchar(10) DEFAULT NULL,
  `neural_vascular_disease` varchar(10) DEFAULT NULL,
  `endocrine_disease` varchar(10) DEFAULT NULL,
  `urinary_disease` varchar(10) DEFAULT NULL,
  `gastro_intestinal_disease` varchar(10) DEFAULT NULL,
  `gynecologic_disease` varchar(10) DEFAULT NULL,
  `other_disease` varchar(10) DEFAULT NULL,
  `event_master_id` int(11) DEFAULT NULL,
  
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO `structure_fields` 
(`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, '', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_med_hist_record_summary', 'asa_value', 'asa medical past history', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name`='yes_no_checkbox'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_med_hist_record_summary', 'heart_disease', 'heart disease medical past history', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yes_no_checkbox'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_med_hist_record_summary', 'respiratory_disease', 'respiratory disease medical past history', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yes_no_checkbox'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_med_hist_record_summary', 'vascular_disease', 'vascular disease medical past history', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yes_no_checkbox'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_med_hist_record_summary', 'neural_vascular_disease', 'neural vascular disease medical past history', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yes_no_checkbox'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_med_hist_record_summary', 'endocrine_disease', 'endocrine disease medical past history', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yes_no_checkbox'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_med_hist_record_summary', 'urinary_disease', 'urinary disease medical past history', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yes_no_checkbox'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_med_hist_record_summary', 'gastro_intestinal_disease', 'gastro-intestinal disease medical past history', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yes_no_checkbox'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_med_hist_record_summary', 'gynecologic_disease', 'gynecologic disease medical past history', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yes_no_checkbox'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_med_hist_record_summary', 'other_disease', 'other disease medical past history', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yes_no_checkbox'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
 
SET @QC_HB_000003_structure_id = (SELECT id FROM structures WHERE alias = 'qc_hb_ed_hepatobiliary_med_hist_record_summary');
INSERT INTO `structure_formats` (`id`, `structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
-- date
(null, @QC_HB_000003_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventMaster' AND tablename = 'event_masters' AND field IN ('event_date')), 0, 1, '', '1', 'last update date', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

-- disease_site
(null, @QC_HB_000003_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventMaster' AND tablename = 'event_masters' AND field IN ('disease_site')), 0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- event_type
(null, @QC_HB_000003_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventMaster' AND tablename = 'event_masters' AND field IN ('event_type')), 0, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
	
-- 
(null, @QC_HB_000003_structure_id,
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobiliary_med_hist_record_summary' AND field IN ('asa_value')), 1, 40, 'reviewed events', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- 
(null, @QC_HB_000003_structure_id,
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobiliary_med_hist_record_summary' AND field IN ('heart_disease')), 1, 41, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- 
(null,  @QC_HB_000003_structure_id,
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobiliary_med_hist_record_summary' AND field IN ('respiratory_disease')), 1, 42, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- 
(null, @QC_HB_000003_structure_id,
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobiliary_med_hist_record_summary' AND field IN ('vascular_disease')), 1, 43, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- 
(null, @QC_HB_000003_structure_id,
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobiliary_med_hist_record_summary' AND field IN ('neural_vascular_disease')), 1, 44, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- 
(null, @QC_HB_000003_structure_id,
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobiliary_med_hist_record_summary' AND field IN ('endocrine_disease')), 1, 45, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- 
(null, @QC_HB_000003_structure_id,
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobiliary_med_hist_record_summary' AND field IN ('urinary_disease')), 1, 46, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- 
(null, @QC_HB_000003_structure_id,
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobiliary_med_hist_record_summary' AND field IN ('gastro_intestinal_disease')), 1, 47, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- 
(null, @QC_HB_000003_structure_id,
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobiliary_med_hist_record_summary' AND field IN ('gynecologic_disease')), 1, 48, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- 
(null, @QC_HB_000003_structure_id,
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobiliary_med_hist_record_summary' AND field IN ('other_disease')), 1, 49, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

-- event_summary
(null, @QC_HB_000003_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventMaster' AND tablename = 'event_masters' AND field IN ('event_summary')), 0, 20, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('reviewed events', '', 'Reviewed Events', 'Évenements révisionnés'),
('medical past history record summary', '', 'Medcial History Review Checklist', 'Révision historique médicale - Liste de contrôle');

-- ... LAB: biology ....................................................

CREATE TABLE IF NOT EXISTS `qc_hb_ed_hepatobilary_lab_report_biology` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT, 
  `wbc` smallint(6) DEFAULT NULL,
  `rbc` smallint(6) DEFAULT NULL,
  `hb` smallint(6) DEFAULT NULL,
  `ht` smallint(6) DEFAULT NULL,
  `platelets` smallint(6) DEFAULT NULL,
  `ptt` smallint(6) DEFAULT NULL,
  `inr` smallint(6) DEFAULT NULL,
  `na` smallint(6) DEFAULT NULL,
  `k` smallint(6) DEFAULT NULL,
  `cl` smallint(6) DEFAULT NULL,
  `creatinine` smallint(6) DEFAULT NULL,
  `urea` smallint(6) DEFAULT NULL,
  `ca` smallint(6) DEFAULT NULL,
  `p` smallint(6) DEFAULT NULL,
  `mg` smallint(6) DEFAULT NULL,
  `protein` smallint(6) DEFAULT NULL,
  `uric_acid` smallint(6) DEFAULT NULL,
  `glycemia` smallint(6) DEFAULT NULL,
  `triglycerides` smallint(6) DEFAULT NULL,
  `cholesterol` smallint(6) DEFAULT NULL,
  `albumin` smallint(6) DEFAULT NULL,
  `total_bilirubin` smallint(6) DEFAULT NULL,
  `direct_bilirubin` smallint(6) DEFAULT NULL,
  `indirect_bilirubin` smallint(6) DEFAULT NULL,
  `ast` smallint(6) DEFAULT NULL,
  `alt` smallint(6) DEFAULT NULL,
  `alkaline_phosphatase` smallint(6) DEFAULT NULL,
  `amylase` smallint(6) DEFAULT NULL,
  `lipase` smallint(6) DEFAULT NULL,
  `a_fp` smallint(6) DEFAULT NULL,
  `cea` smallint(6) DEFAULT NULL,
  `ca_19_9` smallint(6) DEFAULT NULL,
  `chromogranine` smallint(6) DEFAULT NULL,
  `_5_HIAA` smallint(6) DEFAULT NULL,
  `ca_125` smallint(6) DEFAULT NULL,
  `ca_15_3` smallint(6) DEFAULT NULL,
  `b_hcg` smallint(6) DEFAULT NULL,
  `other_marker_1` smallint(6) DEFAULT NULL,
  `other_marker_2` smallint(6) DEFAULT NULL,
  `summary` text,
  `event_master_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `qc_hb_ed_hepatobilary_lab_report_biology`
  ADD FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

CREATE TABLE qc_hb_ed_hepatobilary_lab_report_biology_revs(
  `id` int(11) NOT NULL,
  `wbc` smallint(6) DEFAULT NULL,
  `rbc` smallint(6) DEFAULT NULL,
  `hb` smallint(6) DEFAULT NULL,
  `ht` smallint(6) DEFAULT NULL,
  `platelets` smallint(6) DEFAULT NULL,
  `ptt` smallint(6) DEFAULT NULL,
  `inr` smallint(6) DEFAULT NULL,
  `na` smallint(6) DEFAULT NULL,
  `k` smallint(6) DEFAULT NULL,
  `cl` smallint(6) DEFAULT NULL,
  `creatinine` smallint(6) DEFAULT NULL,
  `urea` smallint(6) DEFAULT NULL,
  `ca` smallint(6) DEFAULT NULL,
  `p` smallint(6) DEFAULT NULL,
  `mg` smallint(6) DEFAULT NULL,
  `protein` smallint(6) DEFAULT NULL,
  `uric_acid` smallint(6) DEFAULT NULL,
  `glycemia` smallint(6) DEFAULT NULL,
  `triglycerides` smallint(6) DEFAULT NULL,
  `cholesterol` smallint(6) DEFAULT NULL,
  `albumin` smallint(6) DEFAULT NULL,
  `total_bilirubin` smallint(6) DEFAULT NULL,
  `direct_bilirubin` smallint(6) DEFAULT NULL,
  `indirect_bilirubin` smallint(6) DEFAULT NULL,
  `ast` smallint(6) DEFAULT NULL,
  `alt` smallint(6) DEFAULT NULL,
  `alkaline_phosphatase` smallint(6) DEFAULT NULL,
  `amylase` smallint(6) DEFAULT NULL,
  `lipase` smallint(6) DEFAULT NULL,
  `a_fp` smallint(6) DEFAULT NULL,
  `cea` smallint(6) DEFAULT NULL,
  `ca_19_9` smallint(6) DEFAULT NULL,
  `chromogranine` smallint(6) DEFAULT NULL,
  `_5_HIAA` smallint(6) DEFAULT NULL,
  `ca_125` smallint(6) DEFAULT NULL,
  `ca_15_3` smallint(6) DEFAULT NULL,
  `b_hcg` smallint(6) DEFAULT NULL,
  `other_marker_1` smallint(6) DEFAULT NULL,
  `other_marker_2` smallint(6) DEFAULT NULL,
  `summary` text,
  `event_master_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO `event_controls` (`id` ,`disease_site` ,`event_group` ,`event_type` ,`flag_active` ,`form_alias` ,`detail_tablename` ,`display_order`) VALUES (NULL , 'hepatobillary', 'lab', 'biology', '1', 'ed_hepatobiliary_lab_report_biology', 'qc_hb_ed_hepatobilary_lab_report_biology', '0');

INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) 
VALUES ('ed_hepatobiliary_lab_report_biology', '', '', '1', '1', '0', '1');

INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES 
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'wbc', 'wbc', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'rbc', 'rbc', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'hb', 'hb', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'ht', 'ht', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'platelets', 'platelets', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'ptt', 'ptt', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'inr', 'inr', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'na', 'na', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'k', 'k', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'cl', 'cl', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'creatinine', 'creatinine', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'urea', 'urea', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'ca', 'ca', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'p', 'p', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'mg', 'mg', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'uric_acid', 'uric acid', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'glycemia', 'glycemia', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'triglycerides', 'triglycerides', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'cholesterol', 'cholesterol', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'protein', 'protein', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'albumin', 'albumin', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'total_bilirubin', 'total bilirubin', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'direct_bilirubin', 'direct bilirubin', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'indirect_bilirubin', 'indirec _bilirubin', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'ast', 'ast', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'alt', 'alt', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'alkaline_phosphatase', 'alkalin _phosphatase', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'amylase', 'amylase', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'lipase', 'lipase', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'a_fp', 'a fp', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'cea', 'cea', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'ca_19_9', 'ca 19 9', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'chromogranine', 'chromogranine', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', '_5_HIAA', '5 HIAA', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'ca_125', 'ca 125', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'ca_15_3', 'ca 15 3', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'b_hcg', 'b hcg', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'other_marker_1', 'other marker 1', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'other_marker_2', 'other marker 2', '', 'number', '', '', NULL, '', '', '', '');

SET @last_id = LAST_INSERT_ID();

SET @QC_HB_100001_structure_id = (SELECT id FROM structures WHERE alias = 'ed_hepatobiliary_lab_report_biology');
INSERT INTO `structure_formats` (`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) (SELECT @QC_HB_100001_structure_id, `id`, IF(id - @last_id <= 19, '0', '1'), (id - @last_id + 3), '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '1', '0000-00-00 00:00:00', '1', '0000-00-00 00:00:00', '1' FROM structure_fields WHERE id >= @last_id);

UPDATE structure_formats SET language_heading='blood formulae' WHERE structure_id = @QC_HB_100001_structure_id
AND structure_field_id = (
	SELECT id FROM structure_fields 
	WHERE plugin = 'Clinicalannotation' 
	AND model = 'EventDetail' 
	AND tablename = 'qc_hb_ed_hepatobilary_lab_report_biology' 
	AND field = 'wbc'
);
UPDATE structure_formats SET language_heading='coagulation' WHERE structure_id = @QC_HB_100001_structure_id
AND structure_field_id = (
	SELECT id FROM structure_fields 
	WHERE plugin = 'Clinicalannotation' 
	AND model = 'EventDetail' 
	AND tablename = 'qc_hb_ed_hepatobilary_lab_report_biology' 
	AND field = 'ptt'
);
UPDATE structure_formats SET language_heading='electrolyte' WHERE structure_id = @QC_HB_100001_structure_id
AND structure_field_id = (
	SELECT id FROM structure_fields 
	WHERE plugin = 'Clinicalannotation' 
	AND model = 'EventDetail' 
	AND tablename = 'qc_hb_ed_hepatobilary_lab_report_biology' 
	AND field = 'na'
);
UPDATE structure_formats SET language_heading='other' WHERE structure_id = @QC_HB_100001_structure_id
AND structure_field_id = (
	SELECT id FROM structure_fields 
	WHERE plugin = 'Clinicalannotation' 
	AND model = 'EventDetail' 
	AND tablename = 'qc_hb_ed_hepatobilary_lab_report_biology' 
	AND field = 'uric_acid'
);
UPDATE structure_formats SET language_heading='bilan hepatique' WHERE structure_id = @QC_HB_100001_structure_id
AND structure_field_id = (
	SELECT id FROM structure_fields 
	WHERE plugin = 'Clinicalannotation' 
	AND model = 'EventDetail' 
	AND tablename = 'qc_hb_ed_hepatobilary_lab_report_biology' 
	AND field = 'albumin'
);
UPDATE structure_formats SET language_heading='bilan pancreatique' WHERE structure_id = @QC_HB_100001_structure_id
AND structure_field_id = (
	SELECT id FROM structure_fields 
	WHERE plugin = 'Clinicalannotation' 
	AND model = 'EventDetail' 
	AND tablename = 'qc_hb_ed_hepatobilary_lab_report_biology' 
	AND field = 'amylase'
);
UPDATE structure_formats SET language_heading='bilan marqueur' WHERE structure_id = @QC_HB_100001_structure_id
AND structure_field_id = (
	SELECT id FROM structure_fields 
	WHERE plugin = 'Clinicalannotation' 
	AND model = 'EventDetail' 
	AND tablename = 'qc_hb_ed_hepatobilary_lab_report_biology' 
	AND field = 'a_fp'
);

INSERT INTO `structure_formats` (`id`, `structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
-- date
(null, @QC_HB_100001_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventMaster' AND tablename = 'event_masters' AND field IN ('event_date')), 0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- event_summary
(null, @QC_HB_100001_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventMaster' AND tablename = 'event_masters' AND field IN ('event_summary')), 1, 100, 'summary', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_formats` (`id`, `structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
-- disease_site
(null, @QC_HB_100001_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventMaster' AND tablename = 'event_masters' AND field IN ('disease_site')), 0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- event_type
(null, @QC_HB_100001_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventMaster' AND tablename = 'event_masters' AND field IN ('event_type')), 0, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
	
INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('hepatobillary', '', 'Hepatobillary', 'Hépato-Biliaire'),
('blood formulae', '', 'Blood Formulae', 'Formule sanguine'),
('coagulation', '', 'Coagulation', 'Coagulation'),
('electrolyte', '', 'Electrolyte', 'Électrolyte'),
('bilan hepatique', '', 'Hepatic Check-Up', 'Bilan hépatique'),
('bilan pancreatique', '', 'Pancreatic Check-Up', 'Bilan pancréatique'),
('bilan marqueur', '', 'Marker Check-Up', 'Bilan marqueur'),

-- TODO A confirmer
('wbc', '', 'WBC', 'NGB'),
('rbc', '', 'RBC', 'NGR'),
('hb', '', 'Hb', 'Hb'),
('ht', '', 'Ht', 'Ht'),
('platelets', '', 'Platelets', 'Plaquettes'),

('ptt', '', 'PTT', 'TCA'),
('inr', '', 'INR', 'INR'),

('na', '', 'Na', 'Na'),
('k', '', 'K', 'K'),
('cl', '', 'Cl', 'Cl'),
('creatinine', '', 'Creatinine', 'Créatinine'),
('urea', '', 'Urea', 'Urée'),
('ca', '', 'Ca', 'Ca'),
('p', '', 'P', 'P'),
('mg', '', 'Mg', 'Mg'),

('uric acid', '', 'Uric Acid', 'Acide urique'),
('glycemia', '', 'Glycemia', 'Glycémie'),
('triglycerides', '', 'Triglycerides', 'Triglycéride'),
('cholesterol', '', 'Cholesterol', 'Cholestérol'),

('albumin', '', 'Albumin', 'Albumine'),
('total bilirubin', '', 'Total Bilirubin', 'Bilirubine totale'),
('direct bilirubin', '', 'Firect Bilirubin', 'Bilirubine directe'),
('indirec _bilirubin', '', 'Indirect Bilirubin', 'Bilirubine indirecte'),

('ast', '', 'AST', 'AST'),
('alt', '', 'ALT', 'ALT'),
('alkalin _phosphatase', '', 'Alkalin Phosphatase', 'Phosphatase alcaline'),

('amylase', '', 'Amylase', 'Amylase'),
('lipase', '', 'Lipase', 'Lipase'),

('a fp', '', '&#945;-FP', '&#945;-FP'),
('cea', '', 'CEA', 'CEA'),
('ca 19 9', '', 'Ca 19-9', 'Ca 19-9'),
('chromogranine', '', 'Chromogranine', ''),
('5 HIAA', '', '5 HIAA', '5 HIAA'),
('ca 125', '', 'Ca 125', 'Ca 125'),
('ca 15 3', '', 'Ca 15-3', 'Ca 15-3'),
('b hcg', '', '&#223; HCG', '&#223; HCG'),
('other marker 1', '', 'Other marker 1', 'Autre marqueur 1'),
('other marker 2', '', 'Other marker 2', 'Autre marqueur 2');

-- TODO End todo A confirmer

-- ... CLINIC: medical_past_history revision control ...................

CREATE TABLE IF NOT EXISTS `qc_hb_ed_medical_imaging_record_summary` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `abdominal_ultrasound` varchar(5) DEFAULT NULL,
  `abdominal_ct_scan` varchar(5) DEFAULT NULL,
  `pelvic_ct_scan` varchar(5) DEFAULT NULL,
  `abdominal_mri` varchar(5) DEFAULT NULL,
  `pelvic_mri` varchar(5) DEFAULT NULL,
  `chest_x_ray` varchar(5) DEFAULT NULL,
  `chest_ct_scan` varchar(5) DEFAULT NULL,
  `tep_scan` varchar(5) DEFAULT NULL,
  `octreoscan` varchar(5) DEFAULT NULL,
  `contrast_enhanced_ultrasound` varchar(5) DEFAULT NULL,
  `doppler_ultrasound` varchar(5) DEFAULT NULL,
  `endoscopic_ultrasound` varchar(5) DEFAULT NULL,
  `colonoscopy` varchar(5) DEFAULT NULL,
  `contrast_enema` varchar(5) DEFAULT NULL,
  `ercp` varchar(5) DEFAULT NULL,
  `transhepatic_cholangiography` varchar(5) DEFAULT NULL,
  `hida_scan` varchar(5) DEFAULT NULL,  
  `event_master_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `qc_hb_ed_medical_imaging_record_summary`
  ADD FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;
  
CREATE TABLE IF NOT EXISTS `qc_hb_ed_medical_imaging_record_summary_revs` (
  `id` int(11) unsigned NOT NULL,
  `abdominal_ultrasound` varchar(5) DEFAULT NULL,
  `abdominal_ct_scan` varchar(5) DEFAULT NULL,
  `pelvic_ct_scan` varchar(5) DEFAULT NULL,
  `abdominal_mri` varchar(5) DEFAULT NULL,
  `pelvic_mri` varchar(5) DEFAULT NULL,
  `chest_x_ray` varchar(5) DEFAULT NULL,
  `chest_ct_scan` varchar(5) DEFAULT NULL,
  `tep_scan` varchar(5) DEFAULT NULL,
  `octreoscan` varchar(5) DEFAULT NULL,
  `contrast_enhanced_ultrasound` varchar(5) DEFAULT NULL,
  `doppler_ultrasound` varchar(5) DEFAULT NULL,
  `endoscopic_ultrasound` varchar(5) DEFAULT NULL,
  `colonoscopy` varchar(5) DEFAULT NULL,
  `contrast_enema` varchar(5) DEFAULT NULL,
  `ercp` varchar(5) DEFAULT NULL,
  `transhepatic_cholangiography` varchar(5) DEFAULT NULL,
  `hida_scan` varchar(5) DEFAULT NULL,  
  `event_master_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO `event_controls` (`id` ,`disease_site` ,`event_group` ,`event_type` ,`flag_active` ,`form_alias` ,`detail_tablename` ,`display_order`) VALUES 
(null, 'hepatobillary', 'clinical', 'medical imaging record summary', '1', 'qc_hb_ed_medical_imaging_record_summary', 'qc_hb_ed_medical_imaging_record_summary', '0');

INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) 
VALUES ('qc_hb_ed_medical_imaging_record_summary', '', '', '1', '1', '0', '1');

INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, 
`language_label`, `language_tag`, 
`type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES 
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_medical_imaging_record_summary', 'abdominal_ultrasound', 'medical imaging abdominal ultrasound', '', 'checkbox', '', '',  (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', 'open', 'open', 'open'),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_medical_imaging_record_summary', 'abdominal_ct_scan', 'medical imaging abdominal CT-scan', '', 'checkbox', '', '',  (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', 'open', 'open', 'open'),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_medical_imaging_record_summary', 'pelvic_ct_scan', 'medical imaging pelvic CT-scan', '', 'checkbox', '', '',  (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', 'open', 'open', 'open'),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_medical_imaging_record_summary', 'abdominal_mri', 'medical imaging abdominal MRI', '', 'checkbox', '', '',  (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', 'open', 'open', 'open'),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_medical_imaging_record_summary', 'pelvic_mri', 'medical imaging pelvic MRI', '', 'checkbox', '', '',  (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', 'open', 'open', 'open'),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_medical_imaging_record_summary', 'chest_x_ray', 'medical imaging chest X-ray', '', 'checkbox', '', '',  (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', 'open', 'open', 'open'),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_medical_imaging_record_summary', 'chest_ct_scan', 'medical imaging chest CT-scan', '', 'checkbox', '', '',  (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', 'open', 'open', 'open'),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_medical_imaging_record_summary', 'tep_scan', 'medical imaging TEP-scan', '', 'checkbox', '', '',  (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', 'open', 'open', 'open'),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_medical_imaging_record_summary', 'octreoscan', 'medical imaging octreoscan', '', 'checkbox', '', '',  (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', 'open', 'open', 'open'),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_medical_imaging_record_summary', 'contrast_enhanced_ultrasound', 'medical imaging contrast-enhanced ultrasound (CEUS)', '', 'checkbox', '', '',  (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', 'open', 'open', 'open'),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_medical_imaging_record_summary', 'doppler_ultrasound', 'medical imaging doppler ultrasound', '', 'checkbox', '', '',  (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', 'open', 'open', 'open'),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_medical_imaging_record_summary', 'endoscopic_ultrasound', 'medical imaging endoscopic ultrasound (EUS)', '', 'checkbox', '', '',  (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', 'open', 'open', 'open'),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_medical_imaging_record_summary', 'colonoscopy', 'medical imaging colonoscopy', '', 'checkbox', '', '',  (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', 'open', 'open', 'open'),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_medical_imaging_record_summary', 'contrast_enema', 'medical imaging contrast enema', '', 'checkbox', '', '',  (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', 'open', 'open', 'open'),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_medical_imaging_record_summary', 'ercp', 'medical imaging ERCP', '', 'checkbox', '', '',  (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', 'open', 'open', 'open'),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_medical_imaging_record_summary', 'transhepatic_cholangiography', 'medical imaging transhepatic cholangiography', '', 'checkbox', '', '',  (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', 'open', 'open', 'open'),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_medical_imaging_record_summary', 'hida_scan', 'medical imaging HIDA scan', '', 'checkbox', '', '',  (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', 'open', 'open', 'open');

SET @last_id = LAST_INSERT_ID();
SET @QC_HB_100041_structure_id = (SELECT id FROM structures WHERE alias = 'qc_hb_ed_medical_imaging_record_summary');
INSERT INTO `structure_formats` (`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) (SELECT @QC_HB_100041_structure_id, `id`, '1', (id - @last_id + 3), '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '1', '0000-00-00 00:00:00', '1', '0000-00-00 00:00:00', '1' FROM structure_fields WHERE id >= @last_id);

INSERT INTO `structure_formats` (`id`, `structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
-- date
(null, @QC_HB_100041_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventMaster' AND tablename = 'event_masters' AND field IN ('event_date')), 0, 1, '', '1', 'last update date', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

-- disease_site
(null, @QC_HB_100041_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventMaster' AND tablename = 'event_masters' AND field IN ('disease_site')), 0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- event_type
(null, @QC_HB_100041_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventMaster' AND tablename = 'event_masters' AND field IN ('event_type')), 0, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
	
-- event_summary
(null, @QC_HB_100041_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventMaster' AND tablename = 'event_masters' AND field IN ('event_summary')), 0, 100, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

UPDATE structure_formats SET language_heading='reviewed events' WHERE structure_id = @QC_HB_100041_structure_id
AND structure_field_id = (
	SELECT id FROM structure_fields 
	WHERE plugin = 'Clinicalannotation' 
	AND model = 'EventDetail' 
	AND tablename = 'qc_hb_ed_medical_imaging_record_summary' 
	AND field = 'abdominal_ultrasound'
);

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
-- TODO translation in french
('medical imaging abdominal ultrasound', '', 'Abdominal Ultrasound', 'Ultrason abdominal'),
('medical imaging abdominal CT-scan', '', 'Abdominal CT-Scan', 'CT-scan abdominal'),
('medical imaging pelvic CT-scan', '', 'Pelvic CT-Scan', 'CT-scan pelvien'),
('medical imaging abdominal MRI', '', 'Abdominal MRI', 'IRM abdominal'),
('medical imaging pelvic MRI', '', 'Pelvic MRI', 'IRM pelvien'),
('medical imaging chest X-ray', '', 'Chest X-Ray', 'Radiographie de la poitrine'),
('medical imaging chest CT-scan', '', 'Chest CT-Scan', 'CT-scan de la poitrine'),
('medical imaging TEP-scan', '', 'TEP-Scan', 'TEP-Scan'),
('medical imaging octreoscan', '', 'Octreoscan', 'Scintigraphie à l''Octreoscan'),
('medical imaging contrast-enhanced ultrasound (CEUS)', '', 'Contrast-Enhanced Ultrasound (CEUS)', 'Échographie de contraste (CEUS)'),
('medical imaging doppler ultrasound', '', 'Doppler Ultrasound', ''),
('medical imaging endoscopic ultrasound (EUS)', '', 'Endoscopic Ultrasound (EUS)', ''),
('medical imaging colonoscopy', '', 'Colonoscopy', 'Colonoscopie'),
('medical imaging contrast enema', '', 'Contrast Enema', 'Lavement baryté'),
('medical imaging ERCP', '', 'ERCP', 'ERCP'),
('medical imaging transhepatic cholangiography', '', 'Transhepatic Cholangiography', 'Cholangiographie transhépatique'),
('medical imaging HIDA scan', '', 'HIDA-Scan', 'HIDA-scan'),
('medical imaging record summary', '', 'Imaging Review Checklist', 'Révision imagerie médicale - Liste de contrôle');

-- ... CLINIC: medical imaging ...................

-- Add structure to set event date and summary
INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) VALUES 
('qc_hb_dateNSummary', '', '', '1', '1', '0', '1');
SET @last_structure_id = LAST_INSERT_ID();

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
(@last_structure_id, (SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventMaster' AND tablename = 'event_masters' AND field IN ('event_date')), '0', '0', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventMaster' AND tablename = 'event_masters' AND field IN ('event_summary')), '0', '1', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1');

-- Add event_controls
INSERT INTO `event_controls` (`id` ,`disease_site` ,`event_group` ,`event_type` ,`flag_active` ,`form_alias` ,`detail_tablename` ,`display_order`) VALUES 
(NULL , 'hepatobillary', 'clinical', 'medical imaging abdominal ultrasound', '1', 'qc_hb_imaging_segment_other', 'qc_hb_ed_hepatobilary_medical_imagings', '0'),
(NULL , 'hepatobillary', 'clinical', 'medical imaging abdominal CT-scan', '1', 'qc_hb_imaging_segment_other_pancreas_volumetry', 'qc_hb_ed_hepatobilary_medical_imagings', '0'),
(NULL , 'hepatobillary', 'clinical', 'medical imaging pelvic CT-scan', '1', 'qc_hb_imaging_other', 'qc_hb_ed_hepatobilary_medical_imagings', '0'),
(NULL , 'hepatobillary', 'clinical', 'medical imaging abdominal MRI', '1', 'qc_hb_imaging_segment_other_pancreas_volumetry', 'qc_hb_ed_hepatobilary_medical_imagings', '0'),
(NULL , 'hepatobillary', 'clinical', 'medical imaging pelvic MRI', '1', 'qc_hb_imaging_other', 'qc_hb_ed_hepatobilary_medical_imagings', '0'),
(NULL , 'hepatobillary', 'clinical', 'medical imaging chest X-ray', '1', 'qc_hb_imaging_other', 'qc_hb_ed_hepatobilary_medical_imagings', '0'),
(NULL , 'hepatobillary', 'clinical', 'medical imaging chest CT-scan', '1', 'qc_hb_imaging_other', 'qc_hb_ed_hepatobilary_medical_imagings', '0'),
(NULL , 'hepatobillary', 'clinical', 'medical imaging TEP-scan', '1', 'qc_hb_imaging_segment_other', 'qc_hb_ed_hepatobilary_medical_imagings', '0'),
(NULL , 'hepatobillary', 'clinical', 'medical imaging octreoscan', '1', 'qc_hb_imaging_segment_other_pancreas', 'qc_hb_ed_hepatobilary_medical_imagings', '0'),
(NULL , 'hepatobillary', 'clinical', 'medical imaging contrast-enhanced ultrasound (CEUS)', '1', 'qc_hb_imaging_segment', 'qc_hb_ed_hepatobilary_medical_imagings', '0'),
(NULL , 'hepatobillary', 'clinical', 'medical imaging doppler ultrasound', '1', 'qc_hb_imaging', 'qc_hb_ed_hepatobilary_medical_imagings', '0'),
(NULL , 'hepatobillary', 'clinical', 'medical imaging endoscopic ultrasound (EUS)', '1', 'qc_hb_imaging_other_pancreas', 'qc_hb_ed_hepatobilary_medical_imagings', '0'),
(NULL , 'hepatobillary', 'clinical', 'medical imaging colonoscopy', '1', 'qc_hb_imaging_other', 'qc_hb_ed_hepatobilary_medical_imagings', '0'),
(NULL , 'hepatobillary', 'clinical', 'medical imaging contrast enema', '1', 'qc_hb_imaging_other', 'qc_hb_ed_hepatobilary_medical_imagings', '0'),
(NULL , 'hepatobillary', 'clinical', 'medical imaging ERCP', '1', 'qc_hb_imaging', 'qc_hb_ed_hepatobilary_medical_imagings', '0'),
(NULL , 'hepatobillary', 'clinical', 'medical imaging transhepatic cholangiography', '1', 'qc_hb_imaging', 'qc_hb_ed_hepatobilary_medical_imagings', '0'),
(NULL , 'hepatobillary', 'clinical', 'medical imaging HIDA scan', '1', 'qc_hb_imaging', 'qc_hb_ed_hepatobilary_exams', '0');

CREATE TABLE IF NOT EXISTS `qc_hb_ed_hepatobilary_medical_imagings` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `event_master_id` int(11) NOT NULL,
  
  `segment_1_number` smallint(5) unsigned DEFAULT NULL,
  `segment_1_size` smallint(5) unsigned DEFAULT NULL,
  `segment_2_number` smallint(5) unsigned DEFAULT NULL,
  `segment_2_size` smallint(5) unsigned DEFAULT NULL,
  `segment_3_number` smallint(5) unsigned DEFAULT NULL,
  `segment_3_size` smallint(5) unsigned DEFAULT NULL,
  `segment_4a_number` smallint(5) unsigned DEFAULT NULL,
  `segment_4a_size` smallint(5) unsigned DEFAULT NULL,
  `segment_4b_number` smallint(5) unsigned DEFAULT NULL,
  `segment_4b_size` smallint(5) unsigned DEFAULT NULL,
  `segment_5_number` smallint(5) unsigned DEFAULT NULL,
  `segment_5_size` smallint(5) unsigned DEFAULT NULL,
  `segment_6_number` smallint(5) unsigned DEFAULT NULL,
  `segment_6_size` smallint(5) unsigned DEFAULT NULL,
  `segment_7_number` smallint(5) unsigned DEFAULT NULL,
  `segment_7_size` smallint(5) unsigned DEFAULT NULL,
  `segment_8_number` smallint(5) unsigned DEFAULT NULL,
  `segment_8_size` smallint(5) unsigned DEFAULT NULL,

  `lungs_number` smallint(5) unsigned DEFAULT NULL,
  `lungs_size` smallint(5) unsigned DEFAULT NULL,
  `lungs_laterality` varchar(20) DEFAULT NULL,
  `lymph_node_number` smallint(5) unsigned DEFAULT NULL,
  `lymph_node_size` smallint(5) unsigned DEFAULT NULL,
  `colon_number` smallint(5) unsigned DEFAULT NULL,
  `colon_size` smallint(5) unsigned DEFAULT NULL,
  `rectum_number` smallint(5) unsigned DEFAULT NULL,
  `rectum_size` smallint(5) unsigned DEFAULT NULL,
  `bones_number` smallint(5) unsigned DEFAULT NULL,
  `bones_size` smallint(5) unsigned DEFAULT NULL,
  `other_localisation_1` varchar(50) DEFAULT NULL,
  `other_localisation_1_number`  smallint(5) unsigned DEFAULT NULL,
  `other_localisation_1_size` smallint(5) unsigned DEFAULT NULL,
  `other_localisation_2` varchar(50) DEFAULT NULL,
  `other_localisation_2_number`  smallint(5) unsigned DEFAULT NULL,
  `other_localisation_2_size` smallint(5) unsigned DEFAULT NULL,
  `other_localisation_3` varchar(50) DEFAULT NULL,
  `other_localisation_3_number`  smallint(5) unsigned DEFAULT NULL,
  `other_localisation_3_size` smallint(5) unsigned DEFAULT NULL,
   
  `hepatic_artery` varchar(10) DEFAULT NULL,
  `coeliac_trunk` varchar(10) DEFAULT NULL,
  `splenic_artery` varchar(10) DEFAULT NULL,
  `superior_mesenteric_artery` varchar(10) DEFAULT NULL,
  `portal_vein` varchar(10) DEFAULT NULL,
  `superior_mesenteric_vein` varchar(10) DEFAULT NULL,
  `splenic_vein` varchar(10) DEFAULT NULL,
  `metastatic_lymph_nodes` varchar(10) DEFAULT NULL,

  `is_volumetry_post_pve` varchar(10) DEFAULT NULL,
  `total_liver_volume` smallint(5) unsigned DEFAULT NULL,
  `resected_liver_volume` smallint(5) unsigned DEFAULT NULL,
  `remnant_liver_volume` smallint(5) unsigned DEFAULT NULL,
  `tumoral_volume` smallint(5) unsigned DEFAULT NULL,
  `remnant_liver_percentage` float DEFAULT NULL,

  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `qc_hb_ed_hepatobilary_medical_imagings`
  ADD CONSTRAINT `qc_hb_ed_hepatobilary_medical_imagings_event_masters` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);

CREATE TABLE qc_hb_ed_hepatobilary_medical_imagings_revs(
  `id` int(11) unsigned NOT NULL,
  `event_master_id` int(11) NOT NULL,

  `segment_1_number` smallint(5) unsigned DEFAULT NULL,
  `segment_1_size` smallint(5) unsigned DEFAULT NULL,
  `segment_2_number` smallint(5) unsigned DEFAULT NULL,
  `segment_2_size` smallint(5) unsigned DEFAULT NULL,
  `segment_3_number` smallint(5) unsigned DEFAULT NULL,
  `segment_3_size` smallint(5) unsigned DEFAULT NULL,
  `segment_4a_number` smallint(5) unsigned DEFAULT NULL,
  `segment_4a_size` smallint(5) unsigned DEFAULT NULL,
  `segment_4b_number` smallint(5) unsigned DEFAULT NULL,
  `segment_4b_size` smallint(5) unsigned DEFAULT NULL,
  `segment_5_number` smallint(5) unsigned DEFAULT NULL,
  `segment_5_size` smallint(5) unsigned DEFAULT NULL,
  `segment_6_number` smallint(5) unsigned DEFAULT NULL,
  `segment_6_size` smallint(5) unsigned DEFAULT NULL,
  `segment_7_number` smallint(5) unsigned DEFAULT NULL,
  `segment_7_size` smallint(5) unsigned DEFAULT NULL,
  `segment_8_number` smallint(5) unsigned DEFAULT NULL,
  `segment_8_size` smallint(5) unsigned DEFAULT NULL,

  `lungs_number` smallint(5) unsigned DEFAULT NULL,
  `lungs_size` smallint(5) unsigned DEFAULT NULL,
  `lungs_laterality` varchar(20) DEFAULT NULL,
  `lymph_node_number` smallint(5) unsigned DEFAULT NULL,
  `lymph_node_size` smallint(5) unsigned DEFAULT NULL,
  `colon_number` smallint(5) unsigned DEFAULT NULL,
  `colon_size` smallint(5) unsigned DEFAULT NULL,
  `rectum_number` smallint(5) unsigned DEFAULT NULL,
  `rectum_size` smallint(5) unsigned DEFAULT NULL,
  `bones_number` smallint(5) unsigned DEFAULT NULL,
  `bones_size` smallint(5) unsigned DEFAULT NULL,
  `other_localisation_1` varchar(50) DEFAULT NULL,
  `other_localisation_1_number`  smallint(5) unsigned DEFAULT NULL,
  `other_localisation_1_size` smallint(5) unsigned DEFAULT NULL,
  `other_localisation_2` varchar(50) DEFAULT NULL,
  `other_localisation_2_number`  smallint(5) unsigned DEFAULT NULL,
  `other_localisation_2_size` smallint(5) unsigned DEFAULT NULL,
  `other_localisation_3` varchar(50) DEFAULT NULL,
  `other_localisation_3_number`  smallint(5) unsigned DEFAULT NULL,
  `other_localisation_3_size` smallint(5) unsigned DEFAULT NULL,
   
  `hepatic_artery` varchar(10) DEFAULT NULL,
  `coeliac_trunk` varchar(10) DEFAULT NULL,
  `splenic_artery` varchar(10) DEFAULT NULL,
  `superior_mesenteric_artery` varchar(10) DEFAULT NULL,
  `portal_vein` varchar(10) DEFAULT NULL,
  `superior_mesenteric_vein` varchar(10) DEFAULT NULL,
  `splenic_vein` varchar(10) DEFAULT NULL,
  `metastatic_lymph_nodes` varchar(10) DEFAULT NULL,

  `is_volumetry_post_pve` varchar(10) DEFAULT NULL,
  `total_liver_volume` smallint(5) unsigned DEFAULT NULL,
  `resected_liver_volume` smallint(5) unsigned DEFAULT NULL,
  `remnant_liver_volume` smallint(5) unsigned DEFAULT NULL,
  `tumoral_volume` smallint(5) unsigned DEFAULT NULL,
  `remnant_liver_percentage` float DEFAULT NULL,

  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 	qc_hb_segment
INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) VALUES 
('qc_hb_segment', '', '', '1', '1', '0', '1');
SET @last_structure_id = LAST_INSERT_ID();

INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES 
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'segment_1_number', 'number', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'segment_1_size', 'size', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'segment_2_number', 'number', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'segment_2_size', 'size', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'segment_3_number', 'number', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'segment_3_size', 'size', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'segment_4a_number', 'number', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'segment_4a_size', 'size', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'segment_4b_number', 'number', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'segment_4b_size', 'size', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'segment_5_number', 'number', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'segment_5_size', 'size', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'segment_6_number', 'number', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'segment_6_size', 'size', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'segment_7_number', 'number', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'segment_7_size', 'size', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'segment_8_number', 'number', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'segment_8_size', 'size', '', 'number', '', '', NULL, '', '', '', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) 
VALUES 
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'segment_1_number' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '0', '0', 'segment I', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'segment_1_size' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '0', '1', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'segment_2_number' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '0', '2', 'segment II', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'segment_2_size' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '0', '3', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'segment_3_number' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '0', '4', 'segment III', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'segment_3_size' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '0', '5', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'segment_4a_number' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '0', '6', 'segment IVa', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'segment_4a_size' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '0', '7', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'segment_4b_number' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '0', '8', 'segment IVb', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'segment_4b_size' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '0', '9', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'segment_5_number' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '1', '10', 'segment V', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'segment_5_size' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '1', '11', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'segment_6_number' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '1', '12', 'segment VI', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'segment_6_size' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '1', '13', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'segment_7_number' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '1', '14', 'segment VII', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'segment_7_size' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '1', '15', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'segment_8_number' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '1', '16', 'segment VIII', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'segment_8_size' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '1', '17', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1');

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('liver segments', '', 'Segments', 'Segments'),
('segment', '', 'Segment', 'Segment'),
('segment I', '', 'Segment I', 'Segment I'),
('segment II', '', 'Segment II', 'Segment II'),
('segment III', '', 'Segment III', 'Segment III'),
('segment IVa', '', 'Segment IVa', 'Segment IVa'),
('segment IVb', '', 'Segment IVb', 'Segment IVb'),
('segment V', '', 'Segment V', 'Segment V'),
('segment VI', '', 'Segment VI', 'Segment VI'),
('segment VII', '', 'Segment VII', 'Segment VII'),
('segment VIII', '', 'Segment VIII', 'Segment VIII'),

('size', '', 'Size', 'Taille');

-- 	qc_hb_other_localisations
INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) VALUES 
('qc_hb_other_localisations', '', '', '1', '1', '0', '1');
SET @last_structure_id = LAST_INSERT_ID();

INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES 
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'lungs_number', 'number', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'lungs_size', 'size', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'lungs_laterality', 'laterality', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='laterality'), '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'lymph_node_number', 'number', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'lymph_node_size', 'size', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'colon_number', 'number', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'colon_size', 'size', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'rectum_number', 'number', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'rectum_size', 'size', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'bones_number', 'number', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'bones_size', 'size', '', 'number', '', '', NULL, '', '', '', ''),

('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'other_localisation_1', 'other localisation precision', '', 'input', 'size=30', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'other_localisation_1_number', 'number', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'other_localisation_1_size', 'size', '', 'number', '', '', NULL, '', '', '', ''),

('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'other_localisation_2', 'other localisation precision', '', 'input', 'size=30', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'other_localisation_2_number', 'number', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'other_localisation_2_size', 'size', '', 'number', '', '', NULL, '', '', '', ''),

('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'other_localisation_3', 'other localisation precision', '', 'input', 'size=30', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'other_localisation_3_number', 'number', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'other_localisation_3_size', 'size', '', 'number', '', '', NULL, '', '', '', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'lungs_number' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '0', '1', 'lungs', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'lungs_size' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '0', '2', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'lungs_laterality' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '0', '3', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1'),

(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'lymph_node_number' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '0', '4', 'lymph node', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'lymph_node_size' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '0', '5', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),

(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'colon_number' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '0', '6', 'colon', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'colon_size' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '0', '7', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),

(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'rectum_number' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '0', '8', 'rectum', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'rectum_size' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '0', '9', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),

(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'bones_number' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '1', '10', 'bones', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'bones_size' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '1', '11', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),

(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'other_localisation_1' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '1', '12', 'other localisation 1', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'other_localisation_1_number' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '1', '13', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'other_localisation_1_size' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '1', '14', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),

(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'other_localisation_2' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '1', '15', 'other localisation 2', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'other_localisation_2_number' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '1', '16', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'other_localisation_2_size' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '1', '17', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),

(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'other_localisation_3' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '1', '18', 'other localisation 3', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'other_localisation_3_number' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '1', '19', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'other_localisation_3_size' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '1', '20', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1');

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('other localisations', '', 'Other Localisations', 'Autre Localisations'),
('lungs', '', 'Lungs', 'Poumons'),
('bones', '', 'Bones', 'Os'),
('lymph node', '', 'Lymph Nodes', 'Ganglions lymphatique'),
('colon', '', 'Colon', 'Colon'),
('rectum', '', 'Rectum', 'Rectum'),
('other localisation 1', '', 'Other (1)', 'Autre (1)'),
('other localisation 2', '', 'Other (2)', 'Autre (2)'),
('other localisation 3', '', 'Other (3)', 'Autre (3)'),
('other localisation precision', '', 'Precision', 'Précision');

-- 	qc_hb_pancreas
INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) VALUES 
('qc_hb_pancreas', '', '', '1', '1', '0', '1');
SET @last_structure_id = LAST_INSERT_ID();

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`) VALUES ('yes_no_suspicion', '', '');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('yes', 'yes');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='yes_no_suspicion'),  (SELECT id FROM structure_permissible_values WHERE value='yes' AND language_alias='yes'), '1', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('no', 'no');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='yes_no_suspicion'),  (SELECT id FROM structure_permissible_values WHERE value='no' AND language_alias='no'), '2', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('suspicion', 'suspicion');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='yes_no_suspicion'),  (SELECT id FROM structure_permissible_values WHERE value='suspicion' AND language_alias='suspicion'), '3', '1');

INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES 
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'hepatic_artery', 'hepatic artery', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_suspicion'), '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'coeliac_trunk', 'coeliac trunk', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_suspicion'), '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'splenic_artery', 'splenic artery', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_suspicion'), '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'superior_mesenteric_artery', 'superior mesenteric artery', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_suspicion'), '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'portal_vein', 'portal vein', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_suspicion'), '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'superior_mesenteric_vein', 'superior mesenteric vein', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_suspicion'), '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'splenic_vein', 'splenic vein', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_suspicion'), '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'metastatic_lymph_nodes', 'metastatic lymph nodes', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_suspicion'), '', '', '', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'hepatic_artery' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '0', '0', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'coeliac_trunk' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '0', '1', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'splenic_artery' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '0', '2', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'superior_mesenteric_artery' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '0', '3', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'portal_vein' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '1', '4', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'superior_mesenteric_vein' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '1', '5', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'splenic_vein' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '1', '6', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'metastatic_lymph_nodes' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '1', '7', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1');

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('pancreas', '', 'Pancreas', 'Pancréas'),
('hepatic artery', '', 'Hepatic Artery', 'Artère hépatique'),
('coeliac trunk', '', 'Coeliac Trunk', 'Tronc coeliaque'),
('splenic artery', '', 'Splenic artery', 'Artère splénique'),
('superior mesenteric artery', '', 'superior esenteric artery', 'Artère mésentérique superieur'),
('portal vein', '', 'Portal Vein', 'Veine porte'),
('superior mesenteric vein', '', 'superior mesenteric vein', 'Veine mésentérique superieur'),
('splenic vein', '', 'Splenic vein', 'Veine splénique'),
('metastatic lymph nodes', '', 'Metastatic Lymph Modes', 'Ganglions Lymphatiques Métastatiques'),
('suspicion', '', 'Suspicion', 'Soupçon');

-- qc_hb_volumetry
INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) 
VALUES ('qc_hb_volumetry', '', '', '1', '1', '0', '1');
SET @last_structure_id = LAST_INSERT_ID();

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`) VALUES ('qc_hb_yes_no_unknwon', '', '');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('yes', 'yes');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_yes_no_unknwon'),  (SELECT id FROM structure_permissible_values WHERE value='yes' AND language_alias='yes'), '1', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('no', 'no');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_yes_no_unknwon'),  (SELECT id FROM structure_permissible_values WHERE value='no' AND language_alias='no'), '2', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('unknwon', 'unknwon');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_yes_no_unknwon'),  (SELECT id FROM structure_permissible_values WHERE value='unknown' AND language_alias='unknown'), '3', '1');

INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'is_volumetry_post_pve', 'post pve', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_yes_no_unknwon'), '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'total_liver_volume', 'total liver volume', '', 'number', '', '', NULL, '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'resected_liver_volume', 'resected liver volume', '', 'number', '', '', NULL, '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'remnant_liver_volume', 'remnant liver volume', '', 'number', '', '', NULL, '', 'open', 'open', 'open'),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'tumoral_volume', 'tumoral volume', '', 'number', '', '', NULL, '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'remnant_liver_percentage', 'remnant liver percentage', '', 'number', '', '', NULL, '', 'open', 'open', 'open'); 

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'is_volumetry_post_pve' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '0', '1', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'total_liver_volume' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '0', '2', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'resected_liver_volume' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '0', '3', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'remnant_liver_volume' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '0', '4', '', '', '', '', '', '', '', '', '', '', '', '', '', '0', '0', '0', '0', '1', '0', '1', '0', '1', '1'),

(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'tumoral_volume' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '1', '5', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'remnant_liver_percentage' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '1', '6', '', '', '', '', '', '', '', '', '', '', '', '', '', '0', '0', '0', '0', '1', '0', '1', '0', '1', '1');

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('volumetry', '', 'Volumetry', 'Volumétrie'),
('post pve', '', 'Post PVE (Portal Vein Embolization)', 'Post PVE (Embolisation portale)'),
('remnant liver percentage', '', 'Remnant Liver Percentage', 'Pourcentage du foie restant'),
('remnant liver volume', '', 'Remnant Liver Volume', 'Volume du foie restant'),
('total liver volume', '', 'Total Liver Volume', 'Volume du foie total'),
('resected liver volume', '', 'Resected Liver Volume', 'Volume du foie réséqué'),
('tumoral volume', '', 'Tumoral Volume', 'Volume tumoral');

INSERT INTO `menus` (`id`, `parent_id`, `is_root`, `display_order`, `language_title`, `language_description`, `use_link`, `use_params`, `use_summary`, `flag_active`, `created`, `created_by`, `modified`, `modified_by`) VALUES ('clin_CAN_1_qc_hb_14', 'clin_CAN_1', '0', '14', 'score', NULL, '/clinicalannotation/event_masters/listall/scores/%%Participant.id%%', '', 'Clinicalannotation.Participant::summary', '1', '0000-00-00 00:00:00', '1', '0000-00-00 00:00:00', '1');
CREATE TABLE `ed_score_cirrhosis` (
`id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY ,
`event_master_id` INT UNSIGNED NOT NULL ,
`type_of_cirrhosis` VARCHAR( 255 ) NOT NULL ,
`esophageal_varices` VARCHAR( 3 ) NOT NULL ,
`gastric_varices` VARCHAR( 3 ) NOT NULL ,
`tips` VARCHAR( 3 ) NOT NULL ,
`portacaval_gradient` FLOAT NOT NULL ,
`portal_thrombosis` VARCHAR( 3 ) NOT NULL ,
`created` DATETIME NOT NULL ,
`created_by` INT UNSIGNED NOT NULL ,
`modified` DATETIME NOT NULL ,
`modified_by` INT UNSIGNED NOT NULL ,
`deleted` TINYINT UNSIGNED NOT NULL ,
`deleted_by` INT UNSIGNED NOT NULL,
INDEX `event_master_id` (`event_master_id`)
) ENGINE = InnoDB;
CREATE TABLE `ed_score_cirrhosis_revs` (
`id` INT UNSIGNED NOT NULL,
`event_master_id` INT UNSIGNED NOT NULL ,
`type_of_cirrhosis` VARCHAR( 255 ) NOT NULL ,
`esophageal_varices` VARCHAR( 3 ) NOT NULL ,
`gastric_varices` VARCHAR( 3 ) NOT NULL ,
`tips` VARCHAR( 3 ) NOT NULL ,
`portacaval_gradient` FLOAT NOT NULL ,
`portal_thrombosis` VARCHAR( 3 ) NOT NULL ,
`created` DATETIME NOT NULL ,
`created_by` INT UNSIGNED NOT NULL ,
`modified` DATETIME NOT NULL ,
`modified_by` INT UNSIGNED NOT NULL ,
`deleted` TINYINT UNSIGNED NOT NULL ,
`deleted_by` INT UNSIGNED NOT NULL,
`version_id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
`version_created` datetime NOT NULL
) ENGINE = InnoDB;



CREATE TABLE `ed_score_child_pugh` (
`id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY ,
`event_master_id` INT UNSIGNED NOT NULL,
`bilirubin` VARCHAR(255) NOT NULL,
`albumin` VARCHAR(255) NOT NULL,
`inr` VARCHAR(255) NOT NULL,
`encephalopathy` VARCHAR(255) NOT NULL,
`ascite` VARCHAR(255) NOT NULL,
`result` VARCHAR(10) NOT NULL DEFAULT '',
`created` DATETIME NOT NULL ,
`created_by` INT UNSIGNED NOT NULL ,
`modified` DATETIME NOT NULL ,
`modified_by` INT UNSIGNED NOT NULL ,
`deleted` TINYINT UNSIGNED NOT NULL ,
`deleted_by` INT UNSIGNED NOT NULL,
INDEX `event_master_id` (`event_master_id`)
) ENGINE = InnoDB;
CREATE TABLE `ed_score_child_pugh_revs` (
`id` INT UNSIGNED NOT NULL,
`event_master_id` INT UNSIGNED NOT NULL ,
`bilirubin` VARCHAR(255) NOT NULL,
`albumin` VARCHAR(255) NOT NULL,
`inr` VARCHAR(255) NOT NULL,
`encephalopathy` VARCHAR(255) NOT NULL,
`ascite` VARCHAR(255) NOT NULL,
`result` VARCHAR(10) NOT NULL DEFAULT '',
`created` DATETIME NOT NULL ,
`created_by` INT UNSIGNED NOT NULL ,
`modified` DATETIME NOT NULL ,
`modified_by` INT UNSIGNED NOT NULL ,
`deleted` TINYINT UNSIGNED NOT NULL ,
`deleted_by` INT UNSIGNED NOT NULL,
`version_id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
`version_created` datetime NOT NULL
) ENGINE = InnoDB;

CREATE TABLE `ed_score_okuda` (
`id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY ,
`event_master_id` INT UNSIGNED NOT NULL,
`bilirubin` VARCHAR(255) NOT NULL,
`albumin` VARCHAR(255) NOT NULL,
`ascite` VARCHAR(255) NOT NULL,
`tumor_size_ratio` VARCHAR(255) NOT NULL COMMENT '% of liver volume',
`result` VARCHAR(10) NOT NULL DEFAULT '',
`created` DATETIME NOT NULL ,
`created_by` INT UNSIGNED NOT NULL ,
`modified` DATETIME NOT NULL ,
`modified_by` INT UNSIGNED NOT NULL ,
`deleted` TINYINT UNSIGNED NOT NULL ,
`deleted_by` INT UNSIGNED NOT NULL,
INDEX `event_master_id` (`event_master_id`)
) ENGINE = InnoDB;
CREATE TABLE `ed_score_okuda_revs` (
`id` INT UNSIGNED NOT NULL,
`event_master_id` INT UNSIGNED NOT NULL,
`bilirubin` VARCHAR(255) NOT NULL,
`albumin` VARCHAR(255) NOT NULL,
`ascite` VARCHAR(255) NOT NULL,
`tumor_size_ratio` VARCHAR(255) NOT NULL COMMENT '% of liver volume',
`result` VARCHAR(10) NOT NULL DEFAULT '',
`created` DATETIME NOT NULL ,
`created_by` INT UNSIGNED NOT NULL ,
`modified` DATETIME NOT NULL ,
`modified_by` INT UNSIGNED NOT NULL ,
`deleted` TINYINT UNSIGNED NOT NULL ,
`deleted_by` INT UNSIGNED NOT NULL,
`version_id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
`version_created` datetime NOT NULL
) ENGINE = InnoDB;

CREATE TABLE `ed_score_barcelona` (
`id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY ,
`event_master_id` INT UNSIGNED NOT NULL,
`who` VARCHAR(255) NOT NULL,
`tumor_morphology` VARCHAR(255) NOT NULL,
`okuda_score` VARCHAR(255) NOT NULL,
`liver_function` VARCHAR(255) NOT NULL,
`result` VARCHAR(10) NOT NULL DEFAULT '',
`created` DATETIME NOT NULL ,
`created_by` INT UNSIGNED NOT NULL ,
`modified` DATETIME NOT NULL ,
`modified_by` INT UNSIGNED NOT NULL ,
`deleted` TINYINT UNSIGNED NOT NULL ,
`deleted_by` INT UNSIGNED NOT NULL,
INDEX `event_master_id` (`event_master_id`)
) ENGINE = InnoDB;
CREATE TABLE `ed_score_barcelona_revs` (
`id` INT UNSIGNED NOT NULL,
`event_master_id` INT UNSIGNED NOT NULL,
`who` VARCHAR(255) NOT NULL,
`tumor_morphology` VARCHAR(255) NOT NULL,
`okuda_score` VARCHAR(255) NOT NULL,
`liver_function` VARCHAR(255) NOT NULL,
`result` VARCHAR(10) NOT NULL DEFAULT '',
`created` DATETIME NOT NULL ,
`created_by` INT UNSIGNED NOT NULL ,
`modified` DATETIME NOT NULL ,
`modified_by` INT UNSIGNED NOT NULL ,
`deleted` TINYINT UNSIGNED NOT NULL ,
`deleted_by` INT UNSIGNED NOT NULL,
`version_id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
`version_created` datetime NOT NULL
) ENGINE = InnoDB;

CREATE TABLE `ed_score_clip` (
`id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY ,
`event_master_id` INT UNSIGNED NOT NULL,
`child_pugh_score` VARCHAR(255) NOT NULL,
`morphology_of_tumor` VARCHAR(255) NOT NULL,
`alpha_foetoprotein` VARCHAR(255) NOT NULL,
`portal_thrombosis` VARCHAR(255) NOT NULL,
`result` TINYINT(3) UNSIGNED NOT NULL,
`created` DATETIME NOT NULL ,
`created_by` INT UNSIGNED NOT NULL ,
`modified` DATETIME NOT NULL ,
`modified_by` INT UNSIGNED NOT NULL ,
`deleted` TINYINT UNSIGNED NOT NULL ,
`deleted_by` INT UNSIGNED NOT NULL,
INDEX `event_master_id` (`event_master_id`)
) ENGINE = InnoDB;
CREATE TABLE `ed_score_clip_revs` (
`id` INT UNSIGNED NOT NULL,
`event_master_id` INT UNSIGNED NOT NULL,
`child_pugh_score` VARCHAR(255) NOT NULL,
`morphology_of_tumor` VARCHAR(255) NOT NULL,
`alpha_foetoprotein` VARCHAR(255) NOT NULL,
`portal_thrombosis` VARCHAR(255) NOT NULL,
`result` TINYINT(3) UNSIGNED NOT NULL,
`created` DATETIME NOT NULL ,
`created_by` INT UNSIGNED NOT NULL ,
`modified` DATETIME NOT NULL ,
`modified_by` INT UNSIGNED NOT NULL ,
`deleted` TINYINT UNSIGNED NOT NULL ,
`deleted_by` INT UNSIGNED NOT NULL,
`version_id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
`version_created` datetime NOT NULL
) ENGINE = InnoDB;

CREATE TABLE `ed_score_gretch` (
`id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY ,
`event_master_id` INT UNSIGNED NOT NULL,
`kamofsky_index` VARCHAR(255) NOT NULL,
`bilirubin` VARCHAR(255) NOT NULL,
`alkaline_phosphatase` VARCHAR(255) NOT NULL,
`alpha_foetoprotein` VARCHAR(255) NOT NULL,
`portal_thrombosis` VARCHAR(255) NOT NULL,
`result` VARCHAR(10) NOT NULL DEFAULT '',
`created` DATETIME NOT NULL ,
`created_by` INT UNSIGNED NOT NULL ,
`modified` DATETIME NOT NULL ,
`modified_by` INT UNSIGNED NOT NULL ,
`deleted` TINYINT UNSIGNED NOT NULL ,
`deleted_by` INT UNSIGNED NOT NULL,
INDEX `event_master_id` (`event_master_id`)
) ENGINE = InnoDB;
CREATE TABLE `ed_score_gretch_revs` (
`id` INT UNSIGNED NOT NULL,
`event_master_id` INT UNSIGNED NOT NULL,
`kamofsky_index` VARCHAR(255) NOT NULL,
`bilirubin` VARCHAR(255) NOT NULL,
`alkaline_phosphatase` VARCHAR(255) NOT NULL,
`alpha_foetoprotein` VARCHAR(255) NOT NULL,
`portal_thrombosis` VARCHAR(255) NOT NULL,
`result` VARCHAR(10) NOT NULL DEFAULT '',
`created` DATETIME NOT NULL ,
`created_by` INT UNSIGNED NOT NULL ,
`modified` DATETIME NOT NULL ,
`modified_by` INT UNSIGNED NOT NULL ,
`deleted` TINYINT UNSIGNED NOT NULL ,
`deleted_by` INT UNSIGNED NOT NULL,
`version_id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
`version_created` datetime NOT NULL
) ENGINE = InnoDB;

CREATE TABLE `ed_score_fong` (
`id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY ,
`event_master_id` INT UNSIGNED NOT NULL,
`metastatic_lymph_nodes` VARCHAR(3) NOT NULL,
`interval_under_year` VARCHAR(3) NOT NULL,
`more_than_one_metastasis` VARCHAR(3) NOT NULL,
`metastasis_greater_five_cm` VARCHAR(3) NOT NULL,
`cea_greater_two_hundred` VARCHAR(3) NOT NULL,
`result` VARCHAR(10) NOT NULL DEFAULT '',
`created` DATETIME NOT NULL ,
`created_by` INT UNSIGNED NOT NULL ,
`modified` DATETIME NOT NULL ,
`modified_by` INT UNSIGNED NOT NULL ,
`deleted` TINYINT UNSIGNED NOT NULL ,
`deleted_by` INT UNSIGNED NOT NULL,
INDEX `event_master_id` (`event_master_id`)
) ENGINE = InnoDB;
CREATE TABLE `ed_score_fong_revs` (
`id` INT UNSIGNED NOT NULL,
`event_master_id` INT UNSIGNED NOT NULL,
`metastatic_lymph_nodes` VARCHAR(3) NOT NULL,
`interval_under_year` VARCHAR(3) NOT NULL,
`more_than_one_metastasis` VARCHAR(3) NOT NULL,
`metastasis_greater_five_cm` VARCHAR(3) NOT NULL,
`cea_greater_two_hundred` VARCHAR(3) NOT NULL,
`result` VARCHAR(10) NOT NULL DEFAULT '',
`created` DATETIME NOT NULL ,
`created_by` INT UNSIGNED NOT NULL ,
`modified` DATETIME NOT NULL ,
`modified_by` INT UNSIGNED NOT NULL ,
`deleted` TINYINT UNSIGNED NOT NULL ,
`deleted_by` INT UNSIGNED NOT NULL,
`version_id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
`version_created` datetime NOT NULL
) ENGINE = InnoDB;

CREATE TABLE `ed_score_meld` (
`id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY ,
`event_master_id` INT UNSIGNED NOT NULL,
`bilirubin` FLOAT UNSIGNED NOT NULL,
`inr` FLOAT UNSIGNED NOT NULL,
`creatinine` FLOAT UNSIGNED NOT NULL,
`dialysis` TINYINT(3) UNSIGNED NOT NULL,
`result` FLOAT UNSIGNED NOT NULL,
`created` DATETIME NOT NULL ,
`created_by` INT UNSIGNED NOT NULL ,
`modified` DATETIME NOT NULL ,
`modified_by` INT UNSIGNED NOT NULL ,
`deleted` TINYINT UNSIGNED NOT NULL ,
`deleted_by` INT UNSIGNED NOT NULL,
INDEX `event_master_id` (`event_master_id`)
) ENGINE = InnoDB;
CREATE TABLE `ed_score_meld_revs` (
`id` INT UNSIGNED NOT NULL,
`event_master_id` INT UNSIGNED NOT NULL,
`bilirubin` FLOAT UNSIGNED NOT NULL,
`inr` FLOAT UNSIGNED NOT NULL,
`creatinine` FLOAT UNSIGNED NOT NULL,
`dialysis` TINYINT(3) UNSIGNED NOT NULL,
`result` FLOAT UNSIGNED NOT NULL,
`created` DATETIME NOT NULL ,
`created_by` INT UNSIGNED NOT NULL ,
`modified` DATETIME NOT NULL ,
`modified_by` INT UNSIGNED NOT NULL ,
`deleted` TINYINT UNSIGNED NOT NULL ,
`deleted_by` INT UNSIGNED NOT NULL,
`version_id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
`version_created` datetime NOT NULL
) ENGINE = InnoDB;


INSERT INTO `atim_hepato`.`event_controls` (`id` ,`disease_site` ,`event_group` ,`event_type` ,`flag_active` ,`form_alias` ,`detail_tablename` ,`display_order`) VALUES 
(NULL , 'hepatobiliary', 'scores', 'cirrhosis', '1', 'ed_score_cirrhosis', 'ed_score_cirrhosis', '0'),
(NULL , 'hepatobiliary', 'scores', 'child pugh score', '1', 'ed_score_child_pugh', 'ed_score_child_pugh', '0'),
(NULL , 'hepatobiliary', 'scores', 'okuda score', '1', 'ed_score_okuda', 'ed_score_okuda', '0'),
(NULL , 'hepatobiliary', 'scores', 'barcelona score', '1', 'ed_score_barcelona', 'ed_score_barcelona', '0'),
(NULL , 'hepatobiliary', 'scores', 'clip', '1', 'ed_score_clip', 'ed_score_clip', '0'),
(NULL , 'hepatobiliary', 'scores', 'gretch', '1', 'ed_score_gretch', 'ed_score_gretch', '0'),
(NULL , 'hepatobiliary', 'scores', 'score de fong', '1', 'ed_score_fong', 'ed_score_fong', '0'),
(NULL , 'hepatobiliary', 'scores', 'meld score', '1', 'ed_score_meld', 'ed_score_meld', '0');

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`) VALUES ('yes_no_na', '', '');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='yes_no_na'),  (SELECT id FROM structure_permissible_values WHERE value='yes' AND language_alias='yes'), '1', '1');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='yes_no_na'),  (SELECT id FROM structure_permissible_values WHERE value='no' AND language_alias='no'), '2', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('n/a', 'n/a');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='yes_no_na'),  (SELECT id FROM structure_permissible_values WHERE value='n/a' AND language_alias='n/a'), '3', '1');

-- TODO: Fill cirrhosis_type
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`) VALUES ('cirrhosis_type', '', '');

-- Structure ed_score_cirrhosis
INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) VALUES ('ed_score_cirrhosis', '', '', '1', '1', '1', '1');
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES('', 'Clinicalannotation', 'EventDetail', 'ed_score_cirrhosis', 'portacaval_gradient', 'portacaval gradient', '', 'number', '', '', NULL, '', 'open', 'open', 'open'), ('', 'Clinicalannotation', 'EventDetail', 'ed_score_cirrhosis', 'portal_thrombosis', 'portal thrombosis', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_na'), '', 'open', 'open', 'open'), ('', 'Clinicalannotation', 'EventDetail', 'ed_score_cirrhosis', 'tips', 'tips', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_na'), '', 'open', 'open', 'open'), ('', 'Clinicalannotation', 'EventDetail', 'ed_score_cirrhosis', 'gastric_varices', 'gastric varices', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_na'), '', 'open', 'open', 'open'), ('', 'Clinicalannotation', 'EventDetail', 'ed_score_cirrhosis', 'esophageal_varices', 'esophageal varices', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_na'), '', 'open', 'open', 'open'), ('', 'Clinicalannotation', 'EventDetail', 'ed_score_cirrhosis', 'type_of_cirrhosis', 'type of cirrhosis', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='cirrhosis_type'), '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_cirrhosis'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `structure_value_domain`  IS NULL  ), '1', '1', '', 1, 'event date', 1, '', 1, '', 1, 'date', 1, '', 1, '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ;
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_cirrhosis'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  ), '1', '2', '', 0, '', 0, '', 0, '', 0, '', 0, '', 1, '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ;
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_cirrhosis'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_score_cirrhosis' AND `field`='portacaval_gradient' AND `structure_value_domain`  IS NULL  ), '1', '7', '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ;
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_cirrhosis'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_score_cirrhosis' AND `field`='portal_thrombosis' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_na')  ), '1', '6', '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ;
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_cirrhosis'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_score_cirrhosis' AND `field`='tips' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_na')  ), '1', '6', '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ;
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_cirrhosis'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_score_cirrhosis' AND `field`='gastric_varices' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_na')  ), '1', '5', '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ;
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_cirrhosis'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_score_cirrhosis' AND `field`='esophageal_varices' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_na')  ), '1', '4', '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ;
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_cirrhosis'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_score_cirrhosis' AND `field`='type_of_cirrhosis' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='cirrhosis_type')  ), '1', '3', '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ;

-- value domain qc_hb_bilirubin_child_pugh
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`) VALUES ('qc_hb_bilirubin_child_pugh', '', '');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('<34µmol/l', '<34µmol/l');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_bilirubin_child_pugh'),  (SELECT id FROM structure_permissible_values WHERE value='<34µmol/l' AND language_alias='<34µmol/l'), '1', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('34 - 50µmol/l', '34 - 50µmol/l');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_bilirubin_child_pugh'),  (SELECT id FROM structure_permissible_values WHERE value='34 - 50µmol/l' AND language_alias='34 - 50µmol/l'), '2', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('>50µmol/l', '>50µmol/l');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_bilirubin_child_pugh'),  (SELECT id FROM structure_permissible_values WHERE value='>50µmol/l' AND language_alias='>50µmol/l'), '3', '1');

-- value domain qc_hb_albumin_child_pugh
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`) VALUES ('qc_hb_albumin_child_pugh', '', '');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('<28g/l', '<28g/l');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_albumin_child_pugh'),  (SELECT id FROM structure_permissible_values WHERE value='<28g/l' AND language_alias='<28g/l'), '1', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('28 - 35g/l', '28 - 35g/l');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_albumin_child_pugh'),  (SELECT id FROM structure_permissible_values WHERE value='28 - 35g/l' AND language_alias='28 - 35g/l'), '2', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('>35g/l', '>35g/l');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_albumin_child_pugh'),  (SELECT id FROM structure_permissible_values WHERE value='>35g/l' AND language_alias='>35g/l'), '3', '1');

-- value domain qc_hb_inr
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`) VALUES ('qc_hb_inr', '', '');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('<1.7', '<1.7');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_inr'),  (SELECT id FROM structure_permissible_values WHERE value='<1.7' AND language_alias='<1.7'), '1', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('1.7 - 2.2', '1.7 - 2.2');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_inr'),  (SELECT id FROM structure_permissible_values WHERE value='1.7 - 2.2' AND language_alias='1.7 - 2.2'), '2', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('>2.2', '>2.2');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_inr'),  (SELECT id FROM structure_permissible_values WHERE value='>2.2' AND language_alias='>2.2'), '3', '1');

-- value domain qc_hb_encephalopathy
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`) VALUES ('qc_hb_encephalopathy', '', '');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('none', 'none');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_encephalopathy'),  (SELECT id FROM structure_permissible_values WHERE value='none' AND language_alias='none'), '1', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('grade I-II', 'grade I-II');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_encephalopathy'),  (SELECT id FROM structure_permissible_values WHERE value='grade I-II' AND language_alias='grade I-II'), '2', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('grade III-IV', 'grade III-IV');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_encephalopathy'),  (SELECT id FROM structure_permissible_values WHERE value='grade III-IV' AND language_alias='grade III-IV'), '3', '1');

-- value domain qc_hb_ascite_child_pugh
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`) VALUES ('qc_hb_ascite_child_pugh', '', '');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('none', 'none');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_ascite_child_pugh'),  (SELECT id FROM structure_permissible_values WHERE value='none' AND language_alias='none'), '1', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('mild', 'mild');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_ascite_child_pugh'),  (SELECT id FROM structure_permissible_values WHERE value='mild' AND language_alias='mild'), '2', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('severe', 'severe');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_ascite_child_pugh'),  (SELECT id FROM structure_permissible_values WHERE value='severe' AND language_alias='severe'), '3', '1');

-- value domain qc_hb_bilirubin_okuda
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`) VALUES ('qc_hb_bilirubin_okuda', '', '');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('<50µmol/l', '<50µmol/l');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_bilirubin_okuda'),  (SELECT id FROM structure_permissible_values WHERE value='<50µmol/l' AND language_alias='<50µmol/l'), '1', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('>=50µmol/l', '>=50µmol/l');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_bilirubin_okuda'),  (SELECT id FROM structure_permissible_values WHERE value='>=50µmol/l' AND language_alias='>=50µmol/l'), '2', '1');

-- value domain qc_hb_albumin_okuda
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`) VALUES ('qc_hb_albumin_okuda', '', '');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('>=30g/l', '>=30g/l');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_albumin_okuda'),  (SELECT id FROM structure_permissible_values WHERE value='>=30g/l' AND language_alias='>=30g/l'), '1', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('<30g/l', '<30g/l');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_albumin_okuda'),  (SELECT id FROM structure_permissible_values WHERE value='<30g/l' AND language_alias='<30g/l'), '2', '1');

-- value domain qc_hb_tumor_size_okuda
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`) VALUES ('qc_hb_tumor_size_okuda', '', '');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('< 50%', '< 50%');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_tumor_size_okuda'),  (SELECT id FROM structure_permissible_values WHERE value='< 50%' AND language_alias='< 50%'), '1', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('>=50%', '>=50%');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_tumor_size_okuda'),  (SELECT id FROM structure_permissible_values WHERE value='>=50%' AND language_alias='>=50%'), '2', '1');

-- value domain qc_hb_who_barcelona
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`) VALUES ('qc_hb_who_barcelona', '', '');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('0', '0');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_who_barcelona'),  (SELECT id FROM structure_permissible_values WHERE value='0' AND language_alias='0'), '1', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('1', '1');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_who_barcelona'),  (SELECT id FROM structure_permissible_values WHERE value='1' AND language_alias='1'), '1', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('2', '2');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_who_barcelona'),  (SELECT id FROM structure_permissible_values WHERE value='2' AND language_alias='2'), '1', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('3', '3');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_who_barcelona'),  (SELECT id FROM structure_permissible_values WHERE value='3' AND language_alias='3'), '1', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('4', '4');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_who_barcelona'),  (SELECT id FROM structure_permissible_values WHERE value='4' AND language_alias='4'), '1', '1');

-- value domain qc_hb_tumor_morphology_barcelona
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`) VALUES ('qc_hb_tumor_morphology_barcelona', '', '');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('unique, < 5cm', 'unique, < 5cm');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_tumor_morphology_barcelona'),  (SELECT id FROM structure_permissible_values WHERE value='unique, < 5cm' AND language_alias='unique, < 5cm'), '1', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('3 tumors, < 3 cm', '3 tumors, < 3 cm');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_tumor_morphology_barcelona'),  (SELECT id FROM structure_permissible_values WHERE value='3 tumors, < 3 cm' AND language_alias='3 tumors, < 3 cm'), '2', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('multinodular', 'multinodular');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_tumor_morphology_barcelona'),  (SELECT id FROM structure_permissible_values WHERE value='multinodular' AND language_alias='multinodular'), '3', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('vascular invasion', 'vascular invasion');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_tumor_morphology_barcelona'),  (SELECT id FROM structure_permissible_values WHERE value='vascular invasion' AND language_alias='vascular invasion'), '4', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('metastasis', 'metastasis');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_tumor_morphology_barcelona'),  (SELECT id FROM structure_permissible_values WHERE value='metastasis' AND language_alias='metastasis'), '5', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('indifferent', 'indifferent');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_tumor_morphology_barcelona'),  (SELECT id FROM structure_permissible_values WHERE value='indifferent' AND language_alias='indifferent'), '6', '1');



-- value domain qc_hb_okuda_barcelona
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`) VALUES ('qc_hb_okuda_barcelona', '', '');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('I', 'I');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_okuda_barcelona'),  (SELECT id FROM structure_permissible_values WHERE value='I' AND language_alias='I'), '1', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('II', 'II');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_okuda_barcelona'),  (SELECT id FROM structure_permissible_values WHERE value='II' AND language_alias='II'), '2', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('III', 'III');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_okuda_barcelona'),  (SELECT id FROM structure_permissible_values WHERE value='III' AND language_alias='III'), '3', '1');

-- value domain qc_hb_liver_function_barcelona
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`) VALUES ('qc_hb_liver_function_barcelona', '', '');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('no HTP & bilirubin N', 'no HTP & bilirubin N');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_liver_function_barcelona'),  (SELECT id FROM structure_permissible_values WHERE value='no HTP & bilirubin N' AND language_alias='no HTP & bilirubin N'), '1', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('HTP, bilirubin N', 'HTP, bilirubin N');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_liver_function_barcelona'),  (SELECT id FROM structure_permissible_values WHERE value='HTP, bilirubin N' AND language_alias='HTP, bilirubin N'), '2', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('HTP, hyperbilirubinemia', 'HTP, hyperbilirubinemia');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_liver_function_barcelona'),  (SELECT id FROM structure_permissible_values WHERE value='HTP, hyperbilirubinemia' AND language_alias='HTP, hyperbilirubinemia'), '3', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('child-pugh A', 'child-pugh A');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_liver_function_barcelona'),  (SELECT id FROM structure_permissible_values WHERE value='child-pugh A' AND language_alias='child-pugh A'), '4', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('child-pugh B', 'child-pugh B');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_liver_function_barcelona'),  (SELECT id FROM structure_permissible_values WHERE value='child-pugh B' AND language_alias='child-pugh B'), '5', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('child-pugh C', 'child-pugh C');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_liver_function_barcelona'),  (SELECT id FROM structure_permissible_values WHERE value='child-pugh C' AND language_alias='child-pugh C'), '6', '1');

-- value domain qc_hb_chil_pugh_score_clip
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`) VALUES ('qc_hb_chil_pugh_score_clip', '', '');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('A', 'A');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_chil_pugh_score_clip'),  (SELECT id FROM structure_permissible_values WHERE value='A' AND language_alias='A'), '1', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('B', 'B');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_chil_pugh_score_clip'),  (SELECT id FROM structure_permissible_values WHERE value='B' AND language_alias='B'), '2', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('C', 'C');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_chil_pugh_score_clip'),  (SELECT id FROM structure_permissible_values WHERE value='C' AND language_alias='C'), '3', '1');

-- value domain qc_hb_tumor_morphology_clip
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`) VALUES ('qc_hb_tumor_morphology_clip', '', '');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('unique nodule & < 50%', 'unique nodule & < 50%');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_tumor_morphology_clip'),  (SELECT id FROM structure_permissible_values WHERE value='unique nodule & < 50%' AND language_alias='unique nodule & < 50%'), '1', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('multiple nodules & < 50%', 'multiple nodules & < 50%');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_tumor_morphology_clip'),  (SELECT id FROM structure_permissible_values WHERE value='multiple nodules & < 50%' AND language_alias='multiple nodules & < 50%'), '2', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('massive or >= 50%', 'massive or >= 50%');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_tumor_morphology_clip'),  (SELECT id FROM structure_permissible_values WHERE value='massive or >= 50%' AND language_alias='massive or >= 50%'), '3', '1');

-- value domain qc_hb_alpha_foetoprotein_clip
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`) VALUES ('qc_hb_alpha_foetoprotein_clip', '', '');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('< 400 g/L', '< 400 g/L');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_alpha_foetoprotein_clip'),  (SELECT id FROM structure_permissible_values WHERE value='< 400 g/L' AND language_alias='< 400 g/L'), '1', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('>= 400 g/L', '>= 400 g/L');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_alpha_foetoprotein_clip'),  (SELECT id FROM structure_permissible_values WHERE value='>= 400 g/L' AND language_alias='>= 400 g/L'), '2', '1');

-- value domain qc_hb_karnofsky_index_gretch
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`) VALUES ('qc_hb_karnofsky_index_gretch', '', '');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('> 80%', '> 80%');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_karnofsky_index_gretch'),  (SELECT id FROM structure_permissible_values WHERE value='> 80%' AND language_alias='> 80%'), '1', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('<= 80%', '<= 80%');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_karnofsky_index_gretch'),  (SELECT id FROM structure_permissible_values WHERE value='<= 80%' AND language_alias='<= 80%'), '2', '1');

-- value domain qc_hb_alkaline_phosphatase_gretch
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`) VALUES ('qc_hb_alkaline_phosphatase_gretch', '', '');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('< 2N', '< 2N');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_alkaline_phosphatase_gretch'),  (SELECT id FROM structure_permissible_values WHERE value='< 2N' AND language_alias='< 2N'), '1', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('>= 2N', '>= 2N');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_alkaline_phosphatase_gretch'),  (SELECT id FROM structure_permissible_values WHERE value='>= 2N' AND language_alias='>= 2N'), '2', '1');

-- value domain qc_hb_alpha_foetoprotein_gretch
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`) VALUES ('qc_hb_alpha_foetoprotein_gretch', '', '');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('< 35 µg/L', '< 35 µg/L');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_alpha_foetoprotein_gretch'),  (SELECT id FROM structure_permissible_values WHERE value='< 35 µg/L' AND language_alias='< 35 µg/L'), '1', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('>= 35 µg/L', '>= 35 µg/L');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_alpha_foetoprotein_gretch'),  (SELECT id FROM structure_permissible_values WHERE value='>= 35 µg/L' AND language_alias='>= 35 µg/L'), '1', '1');

-- structure score child pugh
INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) VALUES ('ed_score_child_pugh', '', '', '1', '1', '1', '1');
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES('', 'Clinicalannotation', 'EventDetail', 'ed_score_child_pugh', 'bilirubin', 'bilirubin', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_bilirubin_child_pugh') , '', 'open', 'open', 'open'), ('', 'Clinicalannotation', 'EventDetail', 'ed_score_child_pugh', 'albumin', 'albumin', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_albumin_child_pugh') , '', 'open', 'open', 'open'), ('', 'Clinicalannotation', 'EventDetail', 'ed_score_child_pugh', 'inr', 'inr', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_inr') , '', 'open', 'open', 'open'), ('', 'Clinicalannotation', 'EventDetail', 'ed_score_child_pugh', 'encephalopathy', 'encephalopathy', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_encephalopathy') , '', 'open', 'open', 'open'), ('', 'Clinicalannotation', 'EventDetail', 'ed_score_child_pugh', 'ascite', 'ascite', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_ascite_child_pugh') , '', 'open', 'open', 'open'), ('', 'Clinicalannotation', 'EventDetail', 'ed_score_child_pugh', 'result', 'result', '', 'input', '', '',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_child_pugh'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `structure_value_domain`  IS NULL  ), '1', '1', '', 1, 'event date', 1, '', 1, '', 1, 'date', 1, '', 1, '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ;
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_child_pugh'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  ), '1', '2', '', 1, 'event summary', 1, '', 1, '', 1, 'textarea', 1, '', 1, '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ;
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_child_pugh'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_score_child_pugh' AND `field`='bilirubin' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_bilirubin_child_pugh')  ), '1', '3', '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ;
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_child_pugh'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_score_child_pugh' AND `field`='albumin' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_albumin_child_pugh')  ), '1', '4', '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ;
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_child_pugh'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_score_child_pugh' AND `field`='inr' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_inr')  ), '1', '5', '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ;
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_child_pugh'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_score_child_pugh' AND `field`='encephalopathy' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_encephalopathy')  ), '1', '6', '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ;
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_child_pugh'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_score_child_pugh' AND `field`='ascite' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_ascite_child_pugh')  ), '1', '7', '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ;
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_child_pugh'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_score_child_pugh' AND `field`='result' AND `structure_value_domain`  IS NULL  ), '1', '8', '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1') ;

-- structure score okuda
INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) VALUES ('ed_score_okuda', '', '', '1', '1', '1', '1');
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES('', 'Clinicalannotation', 'EventDetail', 'ed_score_okuda', 'bilirubin', 'bilirubin', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_bilirubin_okuda') , '', 'open', 'open', 'open'), ('', 'Clinicalannotation', 'EventDetail', 'ed_score_okuda', 'albumin', 'albumin', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_albumin_okuda') , '', 'open', 'open', 'open'), ('', 'Clinicalannotation', 'EventDetail', 'ed_score_okuda', 'ascite', 'ascite', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), ('', 'Clinicalannotation', 'EventDetail', 'ed_score_okuda', 'tumor_size_ratio', 'tumor size ratio', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_tumor_size_okuda') , '', 'open', 'open', 'open'), ('', 'Clinicalannotation', 'EventDetail', 'ed_score_okuda', 'result', 'stade', '', 'input', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_tumor_size_okuda') , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_okuda'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `structure_value_domain`  IS NULL  ), '1', '1', '', 1, 'event date', 1, '', 1, '', 1, 'date', 1, '', 1, '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ;
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_okuda'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  ), '1', '2', '', 1, 'event summary', 1, '', 1, '', 1, 'textarea', 1, '', 1, '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ;
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_okuda'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_score_okuda' AND `field`='bilirubin' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_bilirubin_okuda')  ), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ;
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_okuda'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_score_okuda' AND `field`='albumin' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_albumin_okuda')  ), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ;
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_okuda'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_score_okuda' AND `field`='ascite' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  ), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ;
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_okuda'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_score_okuda' AND `field`='tumor_size_ratio' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_tumor_size_okuda')  ), '1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ;
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_okuda'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_score_okuda' AND `field`='result' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_tumor_size_okuda')  ), '1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1') ;

-- structure score barcelona
INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) VALUES ('ed_score_barcelona', '', '', '1', '1', '1', '1');
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES('', 'Clinicalannotation', 'EventDetail', 'ed_score_barcelona', 'who', 'who', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_who_barcelona') , '', 'open', 'open', 'open'), ('', 'Clinicalannotation', 'EventDetail', 'ed_score_barcelona', 'tumor_morphology', 'tumor morphology', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_tumor_morphology_barcelona') , '', 'open', 'open', 'open'), ('', 'Clinicalannotation', 'EventDetail', 'ed_score_barcelona', 'okuda_score', 'okuda score', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_okuda_barcelona') , '', 'open', 'open', 'open'), ('', 'Clinicalannotation', 'EventDetail', 'ed_score_barcelona', 'liver_function', 'liver function', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_liver_function_barcelona') , '', 'open', 'open', 'open'), ('', 'Clinicalannotation', 'EventDetail', 'ed_score_barcelona', 'result', 'result', '', 'input', '', '',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_barcelona'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `structure_value_domain`  IS NULL  ), '1', '1', '', 1, 'event date', 1, '', 1, '', 1, 'date', 1, '', 1, '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ;
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_barcelona'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  ), '1', '2', '', 1, 'event summary', 1, '', 1, '', 1, 'textarea', 1, '', 1, '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ;
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_barcelona'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_score_barcelona' AND `field`='who' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_who_barcelona')  ), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ;
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_barcelona'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_score_barcelona' AND `field`='tumor_morphology' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_tumor_morphology_barcelona')  ), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ;
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_barcelona'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_score_barcelona' AND `field`='okuda_score' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_okuda_barcelona')  ), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ;
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_barcelona'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_score_barcelona' AND `field`='liver_function' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_liver_function_barcelona')  ), '1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ;
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_barcelona'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_score_barcelona' AND `field`='result' AND `structure_value_domain`  IS NULL  ), '1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1') ;

-- structure score clip
INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) VALUES ('ed_score_clip', '', '', '1', '1', '1', '1');
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES('', 'Clinicalannotation', 'EventDetail', 'ed_score_clip', 'child_pugh_score', 'child pugh score', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_chil_pugh_score_clip') , '', 'open', 'open', 'open'), ('', 'Clinicalannotation', 'EventDetail', 'ed_score_clip', 'morphology_of_tumor', 'morphology of tumor', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_tumor_morphology_clip') , '', 'open', 'open', 'open'), ('', 'Clinicalannotation', 'EventDetail', 'ed_score_clip', 'alpha_foetoprotein', 'alpha foetoprotein', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_alpha_foetoprotein_clip') , '', 'open', 'open', 'open'), ('', 'Clinicalannotation', 'EventDetail', 'ed_score_clip', 'portal_thrombosis', 'portal thrombosis', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_clip'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `structure_value_domain`  IS NULL  ), '1', '1', '', 1, 'event date', 1, '', 1, '', 1, 'date', 1, '', 1, '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ;
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_clip'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  ), '1', '2', '', 1, 'event summary', 1, '', 1, '', 1, 'textarea', 1, '', 1, '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ;
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_clip'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_score_clip' AND `field`='child_pugh_score' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_chil_pugh_score_clip')  ), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ;
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_clip'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_score_clip' AND `field`='morphology_of_tumor' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_tumor_morphology_clip')  ), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ;
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_clip'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_score_clip' AND `field`='alpha_foetoprotein' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_alpha_foetoprotein_clip')  ), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ;
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_clip'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_score_clip' AND `field`='portal_thrombosis' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  ), '1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ;
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES('', 'Clinicalannotation', 'EventDetail', 'ed_score_clip', 'result', 'result', '', 'number', '', '',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_clip'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_score_clip' AND `field`='result' AND `structure_value_domain`  IS NULL  ), '1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1') ;



-- structure score gretch
INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) VALUES ('ed_score_gretch', '', '', '1', '1', '1', '1');
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES('', 'Clinicalannotation', 'EventDetail', 'ed_score_gretch', 'kamofsky_index', 'kamofsky index', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_karnofsky_index_gretch') , '', 'open', 'open', 'open'), ('', 'Clinicalannotation', 'EventDetail', 'ed_score_gretch', 'bilirubin', 'bilirubin', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_bilirubin_okuda') , '', 'open', 'open', 'open'), ('', 'Clinicalannotation', 'EventDetail', 'ed_score_gretch', 'alkaline_phosphatase', 'alkaline phosphatase', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_alkaline_phosphatase_gretch') , '', 'open', 'open', 'open'), ('', 'Clinicalannotation', 'EventDetail', 'ed_score_gretch', 'alpha_foetoprotein', 'alpha foetoprotein', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_alpha_foetoprotein_gretch') , '', 'open', 'open', 'open'), ('', 'Clinicalannotation', 'EventDetail', 'ed_score_gretch', 'portal_thrombosis', 'portal thrombosis', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), ('', 'Clinicalannotation', 'EventDetail', 'ed_score_gretch', 'result', 'group', '', 'input', '', '',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_gretch'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `structure_value_domain`  IS NULL  ), '1', '1', '', 1, 'event date', 1, '', 1, '', 1, 'date', 1, '', 1, '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ;
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_gretch'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  ), '1', '2', '', 1, 'event summary', 1, '', 1, '', 1, 'textarea', 1, '', 1, '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ;
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_gretch'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_score_gretch' AND `field`='kamofsky_index' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_karnofsky_index_gretch')  ), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ;
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_gretch'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_score_gretch' AND `field`='bilirubin' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_bilirubin_okuda')  ), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ;
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_gretch'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_score_gretch' AND `field`='alkaline_phosphatase' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_alkaline_phosphatase_gretch')  ), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ;
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_gretch'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_score_gretch' AND `field`='alpha_foetoprotein' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_alpha_foetoprotein_gretch')  ), '1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ;
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_gretch'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_score_gretch' AND `field`='portal_thrombosis' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  ), '1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ;
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_gretch'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_score_gretch' AND `field`='result' AND `structure_value_domain`  IS NULL  ), '1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1') ;

-- Structure score fong
INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) VALUES ('ed_score_fong', '', '', '1', '1', '1', '1');
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES('', 'Clinicalannotation', 'EventDetail', 'ed_score_fong', 'metastatic_lymph_nodes', 'metastatic lymph nodes', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), ('', 'Clinicalannotation', 'EventDetail', 'ed_score_fong', 'interval_under_year', 'interval under a year', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), ('', 'Clinicalannotation', 'EventDetail', 'ed_score_fong', 'more_than_one_metastasis', 'more than one metastasis', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), ('', 'Clinicalannotation', 'EventDetail', 'ed_score_fong', 'metastasis_greater_five_cm', 'metastasis > 5cm', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), ('', 'Clinicalannotation', 'EventDetail', 'ed_score_fong', 'cea_greater_two_hundred', 'cea > 200', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), ('', 'Clinicalannotation', 'EventDetail', 'ed_score_fong', 'result', 'result', '', 'input', '', '',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_fong'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `structure_value_domain`  IS NULL  ), '1', '1', '', 1, 'event date', 1, '', 1, '', 1, 'date', 1, '', 1, '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ;
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_fong'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  ), '1', '2', '', 1, 'event summary', 1, '', 1, '', 1, 'textarea', 1, '', 1, '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ;
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_fong'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_score_fong' AND `field`='metastatic_lymph_nodes' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  ), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ;
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_fong'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_score_fong' AND `field`='interval_under_year' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  ), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ;
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_fong'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_score_fong' AND `field`='more_than_one_metastasis' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  ), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ;
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_fong'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_score_fong' AND `field`='metastasis_greater_five_cm' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  ), '1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ;
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_fong'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_score_fong' AND `field`='cea_greater_two_hundred' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  ), '1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ;
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_fong'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_score_fong' AND `field`='result' AND `structure_value_domain`  IS NULL  ), '1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1') ;

-- Structure score meld
INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) VALUES ('ed_score_meld', '', '', '1', '1', '1', '1');
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES('', 'Clinicalannotation', 'EventMaster', 'ed_score_meld', 'bilirubin', 'bilirubin', '', 'number', '', '',  NULL , '', 'open', 'open', 'open'), ('', 'Clinicalannotation', 'EventMaster', 'ed_score_meld', 'inr', 'inr', '', 'number', '', '',  NULL , '', 'open', 'open', 'open'), ('', 'Clinicalannotation', 'EventMaster', 'ed_score_meld', 'creatinine', 'creatinine', '', 'number', '', '',  NULL , '', 'open', 'open', 'open'), ('', 'Clinicalannotation', 'EventMaster', 'ed_score_meld', 'dialysis', 'dialysis', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), ('', 'Clinicalannotation', 'EventMaster', 'ed_score_meld', 'result', 'result', '', 'number', '', '',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_meld'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `structure_value_domain`  IS NULL  ), '1', '1', '', 1, 'event date', 1, '', 1, '', 1, 'date', 1, '', 1, '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ;
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_meld'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  ), '1', '2', '', 1, 'event summary', 1, '', 1, '', 1, 'textarea', 1, '', 1, '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ;
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_meld'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='ed_score_meld' AND `field`='bilirubin' AND `structure_value_domain`  IS NULL  ), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ;
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_meld'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='ed_score_meld' AND `field`='inr' AND `structure_value_domain`  IS NULL  ), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ;
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_meld'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='ed_score_meld' AND `field`='creatinine' AND `structure_value_domain`  IS NULL  ), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ;
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_meld'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='ed_score_meld' AND `field`='dialysis' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  ), '1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ;
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ((SELECT id FROM structures WHERE alias='ed_score_meld'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='ed_score_meld' AND `field`='result' AND `structure_value_domain`  IS NULL  ), '1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1') ;

-- TODO should all field be smallint????? In case we keep smallinf, add validation.

