-- NPTTB Custom v0.12
-- ATiM Version: v2.6.3

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'Clark H. Smith NPTTB - v0.12', '');
	
-- ======================================================================================
-- Eventum ID: 3149 - Change box name (Cardboard -> Styrofoam)
-- ======================================================================================
UPDATE `storage_controls` SET `storage_type`='Styrofoam Box', `databrowser_label`='custom#storage types#Styrofoam Box' WHERE
 `storage_type`='Cardboard Box';

-- ======================================================================================
-- Eventum ID: 3148 - QC Score
-- ======================================================================================
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="1" WHERE svd.domain_name='quality_control_unit' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="260/280" AND language_alias="260/280");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='quality_control_unit' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="260/268" AND language_alias="260/268");
 
 
/*
-- Instantiate Nitrogen Tank
INSERT INTO `storage_masters` (`id`,`code`,`storage_control_id`,`parent_id`,`lft`,`rght`,`barcode`,`short_label`,`selection_label`,`storage_status`,`parent_storage_coord_x`,`parent_storage_coord_y`,`temperature`,`temp_unit`,`notes`,`created`,`created_by`,`modified`,`modified_by`,`deleted`) VALUES
(4,'4',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'Nitrogen Tank'),NULL,,58,NULL,'FR','FR','','','',-80.00,'celsius','','2014-11-04 22:53:33',6,'2014-11-04 22:53:33',6,0);

-- Create -80 Freezer 
INSERT INTO `storage_masters` (`id`,`code`,`storage_control_id`,`parent_id`,`lft`,`rght`,`barcode`,`short_label`,`selection_label`,`storage_status`,`parent_storage_coord_x`,`parent_storage_coord_y`,`temperature`,`temp_unit`,`notes`,`created`,`created_by`,`modified`,`modified_by`,`deleted`) VALUES
(32,'32',6,NULL,57,58,NULL,'FR','FR','','','',-80.00,'celsius','','2014-11-04 22:53:33',6,'2014-11-04 22:53:33',6,0);

INSERT INTO `std_freezers` (`storage_master_id`) VALUES (32);

INSERT INTO `storage_masters` (`id`,`code`,`storage_control_id`,`parent_id`,`lft`,`rght`,`barcode`,`short_label`,`selection_label`,`storage_status`,`parent_storage_coord_x`,`parent_storage_coord_y`,`temperature`,`temp_unit`,`notes`,`created`,`created_by`,`modified`,`modified_by`,`deleted`) VALUES
(5,'5',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'Rack (14)'),4,2,3,NULL,'R1','NT-R1','','1','',-120.00,'celsius','','2014-11-04 22:53:33',6,'2014-11-04 22:53:33',6,0),
(6,'6',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'Rack (14)'),4,4,5,NULL,'R2','NT-R2','','2','',-120.00,'celsius','','2014-11-04 22:54:19',6,'2014-11-04 22:54:50',6,0),
(7,'7',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'Rack (14)'),4,6,7,NULL,'R3','NT-R3','','3','',-120.00,'celsius','','2014-11-04 22:55:35',6,'2014-11-04 22:55:35',6,0),
(8,'8',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'Rack (14)'),4,8,9,NULL,'R4','NT-R4','','4','',-120.00,'celsius','','2014-11-04 22:56:12',6,'2014-11-04 22:56:12',6,0),
(9,'9',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'Rack (14)'),4,10,11,NULL,'R5','NT-R5','','5','',-120.00,'celsius','','2014-11-04 22:56:26',6,'2014-11-04 22:56:26',6,0),
(10,'10',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'Rack (14)'),4,12,13,NULL,'R6','NT-R6','','6','',-120.00,'celsius','','2014-11-04 22:57:55',6,'2014-11-04 22:57:55',6,0),
(11,'11',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'Rack (14)'),4,14,15,NULL,'R7','NT-R7','','7','',-120.00,'celsius','','2014-11-04 22:58:34',6,'2014-11-04 22:59:15',6,0),
(13,'13',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'Rack (14)'),4,16,17,NULL,'R8','NT-R8','','8','',-120.00,'celsius','','2014-11-04 22:59:56',6,'2014-11-04 22:59:56',6,0),
(14,'14',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'Rack (14)'),4,18,19,NULL,'R9','NT-R9','','9','',-120.00,'celsius','','2014-11-04 23:00:38',6,'2014-11-04 23:00:38',6,0),
(15,'15',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'Rack (14)'),4,20,21,NULL,'R10','NT-R10','','10','',-120.00,'celsius','','2014-11-04 23:01:01',6,'2014-11-04 23:01:01',6,0),
(16,'16',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'Rack (14)'),4,22,23,NULL,'R11','NT-R11','','11','',-120.00,'celsius','','2014-11-04 23:01:25',6,'2014-11-04 23:01:25',6,0),
(17,'17',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'Rack (14)'),4,24,25,NULL,'R12','NT-R12','','12','',-120.00,'celsius','','2014-11-04 23:01:38',6,'2014-11-04 23:01:38',6,0),
(18,'18',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'Rack (14)'),4,26,27,NULL,'R13','NT-R13','','13','',-120.00,'celsius','','2014-11-04 23:02:24',6,'2014-11-04 23:02:24',6,0),
(19,'19',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'Rack (14)'),4,28,29,NULL,'R14','NT-R14','','14','',-120.00,'celsius','','2014-11-04 23:02:44',6,'2014-11-04 23:06:25',6,0),
(20,'20',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'Rack (14)'),4,30,31,NULL,'R15','NT-R15','','15','',-120.00,'celsius','','2014-11-04 23:03:04',6,'2014-11-04 23:03:04',6,0),
(21,'21',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'Rack (14)'),4,32,33,NULL,'R16','NT-R16','','16','',-120.00,'celsius','','2014-11-04 23:03:18',6,'2014-11-04 23:03:18',6,0),
(22,'22',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'Rack (14)'),4,34,35,NULL,'R17','NT-R17','','17','',-120.00,'celsius','','2014-11-04 23:03:32',6,'2014-11-04 23:03:32',6,0),
(23,'23',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'Rack (14)'),4,36,37,NULL,'R18','NT-R18','','18','',-120.00,'celsius','','2014-11-04 23:03:49',6,'2014-11-04 23:03:49',6,0),
(24,'24',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'Rack (14)'),4,38,39,NULL,'R19','NT-R19','','19','',-120.00,'celsius','','2014-11-04 23:04:05',6,'2014-11-04 23:04:05',6,0),
(25,'25',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'Rack (14)'),4,40,41,NULL,'R20','NT-R20','','20','',-120.00,'celsius','','2014-11-04 23:04:19',6,'2014-11-04 23:04:19',6,0),
(26,'26',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'Rack (14)'),4,42,43,NULL,'R21','NT-R21','','21','',-120.00,'celsius','','2014-11-04 23:04:31',6,'2014-11-04 23:04:31',6,0),
(27,'27',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'Rack (14)'),4,44,45,NULL,'R22','NT-R22','','22','',-120.00,'celsius','','2014-11-04 23:04:46',6,'2014-11-04 23:04:46',6,0),
(28,'28',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'Rack (14)'),4,46,47,NULL,'R23','NT-R23','','23','',-120.00,'celsius','','2014-11-04 23:05:00',6,'2014-11-04 23:05:00',6,0),
(29,'29',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'Rack (14)'),4,48,49,NULL,'R24','NT-R24','','24','',-120.00,'celsius','','2014-11-04 23:05:21',6,'2014-11-04 23:05:21',6,0),
(30,'30',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'Rack (14)'),4,50,51,NULL,'R25','NT-R25','','25','',-120.00,'celsius','','2014-11-04 23:05:34',6,'2014-11-04 23:05:34',6,0),
(31,'31',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'Rack (14)'),4,52,53,NULL,'R26','NT-R26','','26','',-120.00,'celsius','','2014-11-04 23:05:47',6,'2014-11-04 23:05:47',6,0);

INSERT INTO `std_customs` (`storage_master_id`) VALUES 
(4),
(5),
(6),
(7),
(8),
(9),
(10),
(11),
(12),
(13),
(14),
(15),
(16),
(17),
(18),
(19),
(20),
(21),
(22),
(23),
(24),
(25),
(26),
(27),
(28),
(29),
(30),
(31);

-- Rack 1
INSERT INTO `storage_masters` (`id`,`code`,`storage_control_id`,`parent_id`,`lft`,`rght`,`barcode`,`short_label`,`selection_label`,`storage_status`,`parent_storage_coord_x`,`parent_storage_coord_y`,`temperature`,`temp_unit`,`notes`,`created`,`created_by`,`modified`,`modified_by`,`deleted`) VALUES
(33,'33',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'BloodUrine'),5,56,57,NULL,'BU86','NT-R1-BU86','','','',-120.00,'celsius','','2014-11-04 22:53:33',6,'2014-11-04 22:53:33',6,0),
(34,'34',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'BloodUrine'),5,58,59,NULL,'BU87','NT-R1-BU87','','','',-120.00,'celsius','','2014-11-04 22:53:33',6,'2014-11-04 22:53:33',6,0),
(35,'35',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'BloodUrine'),5,60,61,NULL,'BU88','NT-R1-BU88','','','',-120.00,'celsius','','2014-11-04 22:53:33',6,'2014-11-04 22:53:33',6,0),
(36,'36',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'BloodUrine'),5,62,63,NULL,'BU89','NT-R1-BU89','','','',-120.00,'celsius','','2014-11-04 22:53:33',6,'2014-11-04 22:53:33',6,0),
(37,'37',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'BloodUrine'),5,64,65,NULL,'BU90','NT-R1-BU90','','','',-120.00,'celsius','','2014-11-04 22:53:33',6,'2014-11-04 22:53:33',6,0),
(38,'38',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'BloodUrine'),5,66,67,NULL,'BU91','NT-R1-BU91','','','',-120.00,'celsius','','2014-11-04 22:53:33',6,'2014-11-04 22:53:33',6,0),
(39,'39',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'BloodUrine'),5,68,69,NULL,'BU92','NT-R1-BU92','','','',-120.00,'celsius','','2014-11-04 22:53:33',6,'2014-11-04 22:53:33',6,0),
(40,'40',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'BloodUrine'),5,70,71,NULL,'BU93','NT-R1-BU93','','','',-120.00,'celsius','','2014-11-04 22:53:33',6,'2014-11-04 22:53:33',6,0),
(41,'41',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'BloodUrine'),5,72,73,NULL,'BU94','NT-R1-BU94','','','',-120.00,'celsius','','2014-11-04 22:53:33',6,'2014-11-04 22:53:33',6,0),
(42,'42',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'BloodUrine'),5,74,75,NULL,'BU95','NT-R1-BU95','','','',-120.00,'celsius','','2014-11-04 22:53:33',6,'2014-11-04 22:53:33',6,0),
(43,'43',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'BloodUrine'),5,76,77,NULL,'BU96','NT-R1-BU96','','','',-120.00,'celsius','','2014-11-04 22:53:33',6,'2014-11-04 22:53:33',6,0),
(44,'44',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'BloodUrine'),5,78,79,NULL,'BU97','NT-R1-BU97','','','',-120.00,'celsius','','2014-11-04 22:53:33',6,'2014-11-04 22:53:33',6,0),
(45,'45',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'BloodUrine'),5,80,81,NULL,'BU98','NT-R1-BU98','','','',-120.00,'celsius','','2014-11-04 22:53:33',6,'2014-11-04 22:53:33',6,0),
(46,'46',(SELECT `id` FROM `storage_controls` WHERE `storage_type` = 'BloodUrine'),5,82,83,NULL,'BU99','NT-R1-BU99','','','',-120.00,'celsius','','2014-11-04 22:53:33',6,'2014-11-04 22:53:33',6,0);

INSERT INTO `std_customs` (`storage_master_id`) VALUES (33), (34), (35), (36), (37), (38), (39), (40), (41), (42), (43), (44), (45), (46);
*/	