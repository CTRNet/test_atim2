-- Add any new DB changes here

--Add deleted and deleted_by columns to the correct tables

ALTER TABLE `ad_blocks`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `ad_cell_cores`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `ad_cell_slides`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `ad_cell_tubes`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `ad_gel_matrices`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `ad_tissue_cores`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `ad_tissue_slides`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `ad_tubes`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `ad_whatman_papers`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `aliquot_masters`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `aliquot_uses`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `banks`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `clinical_collection_links`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `coding_adverse_events`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `coding_icd10`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `collections`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `consents`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `derivative_details`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `diagnosess`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `drugs`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `ed_all_adverse_events_adverse_event`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `ed_all_clinical_followup`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `ed_all_clinical_presentation`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `ed_all_lifestyle_base`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `ed_all_protocol_followup`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `ed_all_study_research`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `ed_allsolid_lab pathology`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `ed_breast_lab_pathology`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `ed_breast_screening_mammogram`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `event_masters`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `family_histories`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `global_lookups`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `groups`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `i18n`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `materials`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `misc_identifiers`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `order_items`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `order_lines`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `orders`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `participant_contacts`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `participants_messages`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `participants`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `path_collection_reviews`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `pd_chemos`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `pe_chemos`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `permissions`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `protocol_masters`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `qc_tested_aliquots`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `rd_blood_cells`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `rd_bloodcellcount`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `rd_breast_cancers`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `rd_breastcancertypes`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `rd_coloncancertypes`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `rd_genericcancertypes`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `rd_ovarianuteruscancertypes`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `realiquoting`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `reproductive_histories`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `review_masters`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `rtbforms`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `sample_masters`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `sd_der_cell_cultures`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `sd_der_plasmas`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `sd_spe_ascites`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `sd_spe_bloods`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `sd_spe_cystic_fluids`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `sd_spe_other_fluids`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `sd_spe_paritoneal_washes`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `sd_spe_tissues`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `sd_spe_urines`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `shelves`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `shipments`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `sop_masters`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `sopd_general_all`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `sope_general_all`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `source_aliquots`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `specimen_details`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `std_incubators`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `std_rooms`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `std_tma_blocks`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `storage_controls`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `storage_coordinates`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `storage_masters`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `study_contacts`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `study_ethicsboards`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `study_fundings`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `study_investigators`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `study_related`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `study_results`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `study_reviews`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `study_summaries`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `tma_slides`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `towers`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `tx_controls`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `tx_masters`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `txd_chemos`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `txd_combos`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `txd_radiations`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;

ALTER TABLE `txd_surgeries`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_by` datetime default NULL;
--Create New Tables

CREATE TABLE `acos` (
  `id` int(10) NOT NULL auto_increment,
  `parent_id` int(10) default NULL,
  `model` varchar(255) character set latin1 default NULL,
  `foreign_key` int(10) default NULL,
  `alias` varchar(255) character set latin1 default NULL,
  `lft` int(10) default NULL,
  `rght` int(10) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci ;

INSERT INTO `acos` (`id`, `parent_id`, `model`, `foreign_key`, `alias`, `lft`, `rght`) VALUES
(263, NULL, NULL, NULL, 'controllers', 1, 870),
(264, 263, NULL, NULL, 'Pages', 2, 5),
(265, 264, NULL, NULL, 'display', 3, 4),
(266, 263, NULL, NULL, 'Users', 6, 11),
(267, 266, NULL, NULL, 'login', 7, 8),
(268, 266, NULL, NULL, 'logout', 9, 10),
(269, 263, NULL, NULL, 'Order', 12, 93),
(270, 269, NULL, NULL, 'OrderLines', 13, 28),
(271, 270, NULL, NULL, 'listall', 14, 15),
(272, 270, NULL, NULL, 'add', 16, 17),
(273, 270, NULL, NULL, 'edit', 18, 19),
(274, 270, NULL, NULL, 'detail', 20, 21),
(275, 270, NULL, NULL, 'delete', 22, 23),
(276, 270, NULL, NULL, 'process_add_aliquots', 24, 25),
(277, 270, NULL, NULL, 'allowOrderLineDeletion', 26, 27),
(278, 269, NULL, NULL, 'Shipments', 29, 46),
(279, 278, NULL, NULL, 'listall', 30, 31),
(280, 278, NULL, NULL, 'add', 32, 33),
(281, 278, NULL, NULL, 'edit', 34, 35),
(282, 278, NULL, NULL, 'detail', 36, 37),
(283, 278, NULL, NULL, 'delete', 38, 39),
(284, 278, NULL, NULL, 'allowShipmentDeletion', 40, 41),
(285, 278, NULL, NULL, 'updateShippedAliquotUses', 42, 43),
(286, 278, NULL, NULL, 'updateAliquotUseDetailAndDate', 44, 45),
(287, 269, NULL, NULL, 'OrderItems', 47, 72),
(288, 287, NULL, NULL, 'listall', 48, 49),
(289, 287, NULL, NULL, 'obsolete_datagrid', 50, 51),
(290, 287, NULL, NULL, 'manageUnshippedItems', 52, 53),
(291, 287, NULL, NULL, 'manageShipments', 54, 55),
(292, 287, NULL, NULL, 'add', 56, 57),
(293, 287, NULL, NULL, 'edit', 58, 59),
(294, 287, NULL, NULL, 'detail', 60, 61),
(295, 287, NULL, NULL, 'delete', 62, 63),
(296, 287, NULL, NULL, 'shipment_items', 64, 65),
(297, 287, NULL, NULL, 'process_add_aliquots', 66, 67),
(298, 287, NULL, NULL, 'deleteFromShipment', 68, 69),
(299, 287, NULL, NULL, 'allowOrderItemDeletion', 70, 71),
(300, 269, NULL, NULL, 'Orders', 73, 92),
(301, 300, NULL, NULL, 'listall', 74, 75),
(302, 300, NULL, NULL, 'add', 76, 77),
(303, 300, NULL, NULL, 'edit', 78, 79),
(304, 300, NULL, NULL, 'detail', 80, 81),
(305, 300, NULL, NULL, 'delete', 82, 83),
(306, 300, NULL, NULL, 'index', 84, 85),
(307, 300, NULL, NULL, 'search', 86, 87),
(308, 300, NULL, NULL, 'allowOrderDeletion', 88, 89),
(309, 300, NULL, NULL, 'process_add_aliquots', 90, 91),
(310, 263, NULL, NULL, 'Drug', 94, 109),
(311, 310, NULL, NULL, 'Drugs', 95, 108),
(312, 311, NULL, NULL, 'listall', 96, 97),
(313, 311, NULL, NULL, 'add', 98, 99),
(314, 311, NULL, NULL, 'edit', 100, 101),
(315, 311, NULL, NULL, 'detail', 102, 103),
(316, 311, NULL, NULL, 'delete', 104, 105),
(317, 311, NULL, NULL, 'allowDrugDeletion', 106, 107),
(318, 263, NULL, NULL, 'Study', 110, 209),
(319, 318, NULL, NULL, 'StudyRelated', 111, 122),
(320, 319, NULL, NULL, 'listall', 112, 113),
(321, 319, NULL, NULL, 'add', 114, 115),
(322, 319, NULL, NULL, 'edit', 116, 117),
(323, 319, NULL, NULL, 'detail', 118, 119),
(324, 319, NULL, NULL, 'delete', 120, 121),
(325, 318, NULL, NULL, 'StudyEthicsboards', 123, 134),
(326, 325, NULL, NULL, 'listall', 124, 125),
(327, 325, NULL, NULL, 'add', 126, 127),
(328, 325, NULL, NULL, 'edit', 128, 129),
(329, 325, NULL, NULL, 'detail', 130, 131),
(330, 325, NULL, NULL, 'delete', 132, 133),
(331, 318, NULL, NULL, 'StudyFundings', 135, 146),
(332, 331, NULL, NULL, 'listall', 136, 137),
(333, 331, NULL, NULL, 'add', 138, 139),
(334, 331, NULL, NULL, 'edit', 140, 141),
(335, 331, NULL, NULL, 'detail', 142, 143),
(336, 331, NULL, NULL, 'delete', 144, 145),
(337, 318, NULL, NULL, 'StudyInvestigators', 147, 158),
(338, 337, NULL, NULL, 'listall', 148, 149),
(339, 337, NULL, NULL, 'add', 150, 151),
(340, 337, NULL, NULL, 'edit', 152, 153),
(341, 337, NULL, NULL, 'detail', 154, 155),
(342, 337, NULL, NULL, 'delete', 156, 157),
(343, 318, NULL, NULL, 'StudyReviews', 159, 170),
(344, 343, NULL, NULL, 'listall', 160, 161),
(345, 343, NULL, NULL, 'add', 162, 163),
(346, 343, NULL, NULL, 'edit', 164, 165),
(347, 343, NULL, NULL, 'detail', 166, 167),
(348, 343, NULL, NULL, 'delete', 168, 169),
(349, 318, NULL, NULL, 'StudySummaries', 171, 184),
(350, 349, NULL, NULL, 'listall', 172, 173),
(351, 349, NULL, NULL, 'add', 174, 175),
(352, 349, NULL, NULL, 'edit', 176, 177),
(353, 349, NULL, NULL, 'detail', 178, 179),
(354, 349, NULL, NULL, 'delete', 180, 181),
(355, 349, NULL, NULL, 'allowStudyDeletion', 182, 183),
(356, 318, NULL, NULL, 'StudyContacts', 185, 196),
(357, 356, NULL, NULL, 'listall', 186, 187),
(358, 356, NULL, NULL, 'add', 188, 189),
(359, 356, NULL, NULL, 'edit', 190, 191),
(360, 356, NULL, NULL, 'detail', 192, 193),
(361, 356, NULL, NULL, 'delete', 194, 195),
(362, 318, NULL, NULL, 'StudyResults', 197, 208),
(363, 362, NULL, NULL, 'listall', 198, 199),
(364, 362, NULL, NULL, 'add', 200, 201),
(365, 362, NULL, NULL, 'edit', 202, 203),
(366, 362, NULL, NULL, 'detail', 204, 205),
(367, 362, NULL, NULL, 'delete', 206, 207),
(368, 263, NULL, NULL, 'Administrate', 210, 303),
(369, 368, NULL, NULL, 'Users', 211, 226),
(370, 369, NULL, NULL, 'listall', 212, 213),
(371, 369, NULL, NULL, 'detail', 214, 215),
(372, 369, NULL, NULL, 'index', 216, 217),
(373, 369, NULL, NULL, 'add', 218, 219),
(374, 369, NULL, NULL, 'edit', 220, 221),
(375, 369, NULL, NULL, 'delete', 222, 223),
(376, 369, NULL, NULL, 'view', 224, 225),
(377, 368, NULL, NULL, 'Announcements', 227, 238),
(378, 377, NULL, NULL, 'index', 228, 229),
(379, 377, NULL, NULL, 'detail', 230, 231),
(380, 377, NULL, NULL, 'edit', 232, 233),
(381, 377, NULL, NULL, 'add', 234, 235),
(382, 377, NULL, NULL, 'delete', 236, 237),
(383, 368, NULL, NULL, 'Menus', 239, 248),
(384, 383, NULL, NULL, 'index', 240, 241),
(385, 383, NULL, NULL, 'detail', 242, 243),
(386, 383, NULL, NULL, 'add', 244, 245),
(387, 383, NULL, NULL, 'edit', 246, 247),
(388, 368, NULL, NULL, 'Preferences', 249, 254),
(389, 388, NULL, NULL, 'index', 250, 251),
(390, 388, NULL, NULL, 'edit', 252, 253),
(391, 368, NULL, NULL, 'Groups', 255, 266),
(392, 391, NULL, NULL, 'index', 256, 257),
(393, 391, NULL, NULL, 'detail', 258, 259),
(394, 391, NULL, NULL, 'add', 260, 261),
(395, 391, NULL, NULL, 'edit', 262, 263),
(396, 391, NULL, NULL, 'delete', 264, 265),
(397, 368, NULL, NULL, 'StructureFormats', 267, 276),
(398, 397, NULL, NULL, 'listall', 268, 269),
(399, 397, NULL, NULL, 'detail', 270, 271),
(400, 397, NULL, NULL, 'edit', 272, 273),
(401, 397, NULL, NULL, 'add', 274, 275),
(402, 368, NULL, NULL, 'UserLogs', 277, 280),
(403, 402, NULL, NULL, 'index', 278, 279),
(404, 368, NULL, NULL, 'Banks', 281, 292),
(405, 404, NULL, NULL, 'index', 282, 283),
(406, 404, NULL, NULL, 'detail', 284, 285),
(407, 404, NULL, NULL, 'edit', 286, 287),
(408, 404, NULL, NULL, 'delete', 288, 289),
(409, 404, NULL, NULL, 'add', 290, 291),
(410, 368, NULL, NULL, 'Structures', 293, 302),
(411, 410, NULL, NULL, 'index', 294, 295),
(412, 410, NULL, NULL, 'detail', 296, 297),
(413, 410, NULL, NULL, 'edit', 298, 299),
(414, 410, NULL, NULL, 'add', 300, 301),
(415, 263, NULL, NULL, 'Inventorymanagement', 304, 461),
(416, 415, NULL, NULL, 'Collections', 305, 320),
(417, 416, NULL, NULL, 'index', 306, 307),
(418, 416, NULL, NULL, 'search', 308, 309),
(419, 416, NULL, NULL, 'detail', 310, 311),
(420, 416, NULL, NULL, 'add', 312, 313),
(421, 416, NULL, NULL, 'edit', 314, 315),
(422, 416, NULL, NULL, 'delete', 316, 317),
(423, 416, NULL, NULL, 'allowCollectionDeletion', 318, 319),
(424, 415, NULL, NULL, 'QualityControls', 321, 342),
(425, 424, NULL, NULL, 'listAllQualityControls', 322, 323),
(426, 424, NULL, NULL, 'detail', 324, 325),
(427, 424, NULL, NULL, 'add', 326, 327),
(428, 424, NULL, NULL, 'edit', 328, 329),
(429, 424, NULL, NULL, 'delete', 330, 331),
(430, 424, NULL, NULL, 'allowQcDeletion', 332, 333),
(431, 424, NULL, NULL, 'listTestedAliquots', 334, 335),
(432, 424, NULL, NULL, 'addTestedAliquotInBatch', 336, 337),
(433, 424, NULL, NULL, 'deleteTestedAliquot', 338, 339),
(434, 424, NULL, NULL, 'updateTestedAliquotUses', 340, 341),
(435, 415, NULL, NULL, 'ReviewMasters', 343, 356),
(436, 435, NULL, NULL, 'index', 344, 345),
(437, 435, NULL, NULL, 'listall', 346, 347),
(438, 435, NULL, NULL, 'detail', 348, 349),
(439, 435, NULL, NULL, 'add', 350, 351),
(440, 435, NULL, NULL, 'edit', 352, 353),
(441, 435, NULL, NULL, 'delete', 354, 355),
(442, 415, NULL, NULL, 'SampleMasters', 357, 384),
(443, 442, NULL, NULL, 'index', 358, 359),
(444, 442, NULL, NULL, 'search', 360, 361),
(445, 442, NULL, NULL, 'tree', 362, 363),
(446, 442, NULL, NULL, 'changeSampleListFormat', 364, 365),
(447, 442, NULL, NULL, 'listall', 366, 367),
(448, 442, NULL, NULL, 'add', 368, 369),
(449, 442, NULL, NULL, 'detailSampleFromId', 370, 371),
(450, 442, NULL, NULL, 'detail', 372, 373),
(451, 442, NULL, NULL, 'edit', 374, 375),
(452, 442, NULL, NULL, 'delete', 376, 377),
(453, 442, NULL, NULL, 'createSampleCode', 378, 379),
(454, 442, NULL, NULL, 'allowSampleDeletion', 380, 381),
(455, 442, NULL, NULL, 'updateSourceAliquotUses', 382, 383),
(456, 415, NULL, NULL, 'PathCollectionReviews', 385, 400),
(457, 456, NULL, NULL, 'index', 386, 387),
(458, 456, NULL, NULL, 'listall', 388, 389),
(459, 456, NULL, NULL, 'detail', 390, 391),
(460, 456, NULL, NULL, 'add', 392, 393),
(461, 456, NULL, NULL, 'edit', 394, 395),
(462, 456, NULL, NULL, 'delete', 396, 397),
(463, 456, NULL, NULL, 'allowSampleDeletion', 398, 399),
(464, 415, NULL, NULL, 'AliquotMasters', 401, 460),
(465, 464, NULL, NULL, 'index', 402, 403),
(466, 464, NULL, NULL, 'search', 404, 405),
(467, 464, NULL, NULL, 'listAllSampleAliquots', 406, 407),
(468, 464, NULL, NULL, 'addAliquot', 408, 409),
(469, 464, NULL, NULL, 'addAliquotDispatcher', 410, 411),
(470, 464, NULL, NULL, 'addAliquotInBatch', 412, 413),
(471, 464, NULL, NULL, 'detailAliquotFromId', 414, 415),
(472, 464, NULL, NULL, 'detailAliquot', 416, 417),
(473, 464, NULL, NULL, 'editAliquot', 418, 419),
(474, 464, NULL, NULL, 'deleteAliquotStorageData', 420, 421),
(475, 464, NULL, NULL, 'deleteAliquot', 422, 423),
(476, 464, NULL, NULL, 'listSourceAliquots', 424, 425),
(477, 464, NULL, NULL, 'addSourceAliquotInBatch', 426, 427),
(478, 464, NULL, NULL, 'deleteSourceAliquot', 428, 429),
(479, 464, NULL, NULL, 'listRealiquotedParents', 430, 431),
(480, 464, NULL, NULL, 'addRealiquotedParentInBatch', 432, 433),
(481, 464, NULL, NULL, 'deleteRealiquotedParent', 434, 435),
(482, 464, NULL, NULL, 'listAliquotUses', 436, 437),
(483, 464, NULL, NULL, 'detailAliquotUse', 438, 439),
(484, 464, NULL, NULL, 'addAliquotUse', 440, 441),
(485, 464, NULL, NULL, 'editAliquotUse', 442, 443),
(486, 464, NULL, NULL, 'deleteAliquotUse', 444, 445),
(487, 464, NULL, NULL, 'getAllowedAdditionalAliqUses', 446, 447),
(488, 464, NULL, NULL, 'validateAliquotBarcode', 448, 449),
(489, 464, NULL, NULL, 'obslolete_updateAliquotCurrentVolume', 450, 451),
(490, 464, NULL, NULL, 'allowAliquotDeletion', 452, 453),
(491, 464, NULL, NULL, 'process_add_aliquots', 454, 455),
(492, 464, NULL, NULL, 'validateStorageIdAndSelectionLabel', 456, 457),
(493, 464, NULL, NULL, 'validateStorageCoordinates', 458, 459),
(494, 263, NULL, NULL, 'Protocol', 462, 493),
(495, 494, NULL, NULL, 'ProtocolExtends', 463, 476),
(496, 495, NULL, NULL, 'index', 464, 465),
(497, 495, NULL, NULL, 'listall', 466, 467),
(498, 495, NULL, NULL, 'detail', 468, 469),
(499, 495, NULL, NULL, 'add', 470, 471),
(500, 495, NULL, NULL, 'edit', 472, 473),
(501, 495, NULL, NULL, 'delete', 474, 475),
(502, 494, NULL, NULL, 'ProtocolMasters', 477, 492),
(503, 502, NULL, NULL, 'index', 478, 479),
(504, 502, NULL, NULL, 'listall', 480, 481),
(505, 502, NULL, NULL, 'detail', 482, 483),
(506, 502, NULL, NULL, 'add', 484, 485),
(507, 502, NULL, NULL, 'edit', 486, 487),
(508, 502, NULL, NULL, 'delete', 488, 489),
(509, 502, NULL, NULL, 'allowProtocolDeletion', 490, 491),
(510, 263, NULL, NULL, 'Sop', 494, 525),
(511, 510, NULL, NULL, 'SopMasters', 495, 510),
(512, 511, NULL, NULL, 'listall', 496, 497),
(513, 511, NULL, NULL, 'detail', 498, 499),
(514, 511, NULL, NULL, 'add', 500, 501),
(515, 511, NULL, NULL, 'edit', 502, 503),
(516, 511, NULL, NULL, 'index', 504, 505),
(517, 511, NULL, NULL, 'delete', 506, 507),
(518, 511, NULL, NULL, 'getSOPList', 508, 509),
(519, 510, NULL, NULL, 'SopExtends', 511, 524),
(520, 519, NULL, NULL, 'listall', 512, 513),
(521, 519, NULL, NULL, 'detail', 514, 515),
(522, 519, NULL, NULL, 'add', 516, 517),
(523, 519, NULL, NULL, 'edit', 518, 519),
(524, 519, NULL, NULL, 'index', 520, 521),
(525, 519, NULL, NULL, 'delete', 522, 523),
(526, 263, NULL, NULL, 'Storagelayout', 526, 619),
(527, 526, NULL, NULL, 'StorageCoordinates', 527, 542),
(528, 527, NULL, NULL, 'listAll', 528, 529),
(529, 527, NULL, NULL, 'add', 530, 531),
(530, 527, NULL, NULL, 'detail', 532, 533),
(531, 527, NULL, NULL, 'delete', 534, 535),
(532, 527, NULL, NULL, 'allowCustomCoordinates', 536, 537),
(533, 527, NULL, NULL, 'allowStorageCoordinateDeletion', 538, 539),
(534, 527, NULL, NULL, 'duplicatedValue', 540, 541),
(535, 526, NULL, NULL, 'StorageMasters', 543, 602),
(536, 535, NULL, NULL, 'index', 544, 545),
(537, 535, NULL, NULL, 'listChildrenStorages', 546, 547),
(538, 535, NULL, NULL, 'search', 548, 549),
(539, 535, NULL, NULL, 'add', 550, 551),
(540, 535, NULL, NULL, 'edit', 552, 553),
(541, 535, NULL, NULL, 'editStoragePosition', 554, 555),
(542, 535, NULL, NULL, 'detail', 556, 557),
(543, 535, NULL, NULL, 'seeStorageLayout', 558, 559),
(544, 535, NULL, NULL, 'delete', 560, 561),
(545, 535, NULL, NULL, 'searchStorageAliquots', 562, 563),
(546, 535, NULL, NULL, 'editAliquotPosition', 564, 565),
(547, 535, NULL, NULL, 'editAliquotPositionInBatch', 566, 567),
(548, 535, NULL, NULL, 'setStorageCoordinateValues', 568, 569),
(549, 535, NULL, NULL, 'createStorageCode', 570, 571),
(550, 535, NULL, NULL, 'IsDuplicatedStorageBarCode', 572, 573),
(551, 535, NULL, NULL, 'manageStoragePathcode', 574, 575),
(552, 535, NULL, NULL, 'updateChildrenStoragePathcode', 576, 577),
(553, 535, NULL, NULL, 'getStoragesList', 578, 579),
(554, 535, NULL, NULL, 'deleteChildrenFromTheList', 580, 581),
(555, 535, NULL, NULL, 'allowStorageDeletion', 582, 583),
(556, 535, NULL, NULL, 'buildAllowedStoragePosition', 584, 585),
(557, 535, NULL, NULL, 'getStoragePath', 586, 587),
(558, 535, NULL, NULL, 'updateChildrenSurroundingTemperature', 588, 589),
(559, 535, NULL, NULL, 'isPositionSelectionAvailable', 590, 591),
(560, 535, NULL, NULL, 'validateStoragePosition', 592, 593),
(561, 535, NULL, NULL, 'getStorageMatchingSelectLabel', 594, 595),
(562, 535, NULL, NULL, 'getStorageCode', 596, 597),
(563, 535, NULL, NULL, 'getStorageData', 598, 599),
(564, 535, NULL, NULL, 'getTmaSopsArray', 600, 601),
(565, 526, NULL, NULL, 'TmaSlides', 603, 618),
(566, 565, NULL, NULL, 'listAll', 604, 605),
(567, 565, NULL, NULL, 'add', 606, 607),
(568, 565, NULL, NULL, 'detail', 608, 609),
(569, 565, NULL, NULL, 'edit', 610, 611),
(570, 565, NULL, NULL, 'delete', 612, 613),
(571, 565, NULL, NULL, 'isDuplicatedTmaSlideBarcode', 614, 615),
(572, 565, NULL, NULL, 'getTmaSlideSopsArray', 616, 617),
(573, 263, NULL, NULL, 'Datamart', 620, 663),
(574, 573, NULL, NULL, 'Adhocs', 621, 632),
(575, 574, NULL, NULL, 'index', 622, 623),
(576, 574, NULL, NULL, 'favourite', 624, 625),
(577, 574, NULL, NULL, 'unfavourite', 626, 627),
(578, 574, NULL, NULL, 'search', 628, 629),
(579, 574, NULL, NULL, 'results', 630, 631),
(580, 573, NULL, NULL, 'BatchSets', 633, 650),
(581, 580, NULL, NULL, 'index', 634, 635),
(582, 580, NULL, NULL, 'listall', 636, 637),
(583, 580, NULL, NULL, 'add', 638, 639),
(584, 580, NULL, NULL, 'edit', 640, 641),
(585, 580, NULL, NULL, 'remove', 642, 643),
(586, 580, NULL, NULL, 'delete', 644, 645),
(587, 580, NULL, NULL, 'process', 646, 647),
(588, 580, NULL, NULL, 'csv', 648, 649),
(589, 573, NULL, NULL, 'AdhocSaved', 651, 662),
(590, 589, NULL, NULL, 'index', 652, 653),
(591, 589, NULL, NULL, 'add', 654, 655),
(592, 589, NULL, NULL, 'edit', 656, 657),
(593, 589, NULL, NULL, 'delete', 658, 659),
(594, 589, NULL, NULL, 'search', 660, 661),
(595, 263, NULL, NULL, 'Customize', 664, 687),
(596, 595, NULL, NULL, 'Passwords', 665, 668),
(597, 596, NULL, NULL, 'index', 666, 667),
(598, 595, NULL, NULL, 'Announcements', 669, 674),
(599, 598, NULL, NULL, 'index', 670, 671),
(600, 598, NULL, NULL, 'detail', 672, 673),
(601, 595, NULL, NULL, 'Preferences', 675, 680),
(602, 601, NULL, NULL, 'index', 676, 677),
(603, 601, NULL, NULL, 'edit', 678, 679),
(604, 595, NULL, NULL, 'Profiles', 681, 686),
(605, 604, NULL, NULL, 'index', 682, 683),
(606, 604, NULL, NULL, 'edit', 684, 685),
(607, 263, NULL, NULL, 'Clinicalannotation', 688, 835),
(608, 607, NULL, NULL, 'Diagnoses', 689, 704),
(609, 608, NULL, NULL, 'listall', 690, 691),
(610, 608, NULL, NULL, 'detail', 692, 693),
(611, 608, NULL, NULL, 'add', 694, 695),
(612, 608, NULL, NULL, 'edit', 696, 697),
(613, 608, NULL, NULL, 'delete', 698, 699),
(614, 608, NULL, NULL, 'allowDiagnosisDeletion', 700, 701),
(615, 608, NULL, NULL, 'index', 702, 703),
(616, 607, NULL, NULL, 'Participants', 705, 720),
(617, 616, NULL, NULL, 'index', 706, 707),
(618, 616, NULL, NULL, 'search', 708, 709),
(619, 616, NULL, NULL, 'profile', 710, 711),
(620, 616, NULL, NULL, 'add', 712, 713),
(621, 616, NULL, NULL, 'edit', 714, 715),
(622, 616, NULL, NULL, 'delete', 716, 717),
(623, 616, NULL, NULL, 'allowParticipantDeletion', 718, 719),
(624, 607, NULL, NULL, 'MiscIdentifiers', 721, 734),
(625, 624, NULL, NULL, 'listall', 722, 723),
(626, 624, NULL, NULL, 'detail', 724, 725),
(627, 624, NULL, NULL, 'add', 726, 727),
(628, 624, NULL, NULL, 'edit', 728, 729),
(629, 624, NULL, NULL, 'index', 730, 731),
(630, 624, NULL, NULL, 'delete', 732, 733),
(631, 607, NULL, NULL, 'ClinicalCollectionLinks', 735, 750),
(632, 631, NULL, NULL, 'listall', 736, 737),
(633, 631, NULL, NULL, 'detail', 738, 739),
(634, 631, NULL, NULL, 'add', 740, 741),
(635, 631, NULL, NULL, 'edit', 742, 743),
(636, 631, NULL, NULL, 'index', 744, 745),
(637, 631, NULL, NULL, 'delete', 746, 747),
(638, 631, NULL, NULL, 'allowClinicalCollectionLinkDeletion', 748, 749),
(639, 607, NULL, NULL, 'ReproductiveHistories', 751, 764),
(640, 639, NULL, NULL, 'listall', 752, 753),
(641, 639, NULL, NULL, 'detail', 754, 755),
(642, 639, NULL, NULL, 'add', 756, 757),
(643, 639, NULL, NULL, 'edit', 758, 759),
(644, 639, NULL, NULL, 'index', 760, 761),
(645, 639, NULL, NULL, 'delete', 762, 763),
(646, 607, NULL, NULL, 'FamilyHistories', 765, 780),
(647, 646, NULL, NULL, 'listall', 766, 767),
(648, 646, NULL, NULL, 'detail', 768, 769),
(649, 646, NULL, NULL, 'add', 770, 771),
(650, 646, NULL, NULL, 'edit', 772, 773),
(651, 646, NULL, NULL, 'datagrid', 774, 775),
(652, 646, NULL, NULL, 'delete', 776, 777),
(653, 646, NULL, NULL, 'allowFamilyHistoryDeletion', 778, 779),
(654, 607, NULL, NULL, 'ParticipantMessages', 781, 794),
(655, 654, NULL, NULL, 'listall', 782, 783),
(656, 654, NULL, NULL, 'detail', 784, 785),
(657, 654, NULL, NULL, 'add', 786, 787),
(658, 654, NULL, NULL, 'edit', 788, 789),
(659, 654, NULL, NULL, 'index', 790, 791),
(660, 654, NULL, NULL, 'delete', 792, 793),
(661, 607, NULL, NULL, 'Consents', 795, 806),
(662, 661, NULL, NULL, 'listall', 796, 797),
(663, 661, NULL, NULL, 'detail', 798, 799),
(664, 661, NULL, NULL, 'add', 800, 801),
(665, 661, NULL, NULL, 'edit', 802, 803),
(666, 661, NULL, NULL, 'delete', 804, 805),
(667, 607, NULL, NULL, 'ParticipantContacts', 807, 818),
(668, 667, NULL, NULL, 'listall', 808, 809),
(669, 667, NULL, NULL, 'detail', 810, 811),
(670, 667, NULL, NULL, 'add', 812, 813),
(671, 667, NULL, NULL, 'edit', 814, 815),
(672, 667, NULL, NULL, 'delete', 816, 817),
(673, 607, NULL, NULL, 'EventMasters', 819, 834),
(674, 673, NULL, NULL, 'index', 820, 821),
(675, 673, NULL, NULL, 'listall', 822, 823),
(676, 673, NULL, NULL, 'detail', 824, 825),
(677, 673, NULL, NULL, 'add', 826, 827),
(678, 673, NULL, NULL, 'edit', 828, 829),
(679, 673, NULL, NULL, 'delete', 830, 831),
(680, 673, NULL, NULL, 'allowEventDeletion', 832, 833),
(681, 263, NULL, NULL, 'Material', 836, 853),
(682, 681, NULL, NULL, 'Materials', 837, 852),
(683, 682, NULL, NULL, 'listall', 838, 839),
(684, 682, NULL, NULL, 'detail', 840, 841),
(685, 682, NULL, NULL, 'add', 842, 843),
(686, 682, NULL, NULL, 'edit', 844, 845),
(687, 682, NULL, NULL, 'index', 846, 847),
(688, 682, NULL, NULL, 'search', 848, 849),
(689, 682, NULL, NULL, 'delete', 850, 851),
(690, 263, NULL, NULL, 'Rtbform', 854, 869),
(691, 690, NULL, NULL, 'Rtbforms', 855, 868),
(692, 691, NULL, NULL, 'index', 856, 857),
(693, 691, NULL, NULL, 'search', 858, 859),
(694, 691, NULL, NULL, 'profile', 860, 861),
(695, 691, NULL, NULL, 'add', 862, 863),
(696, 691, NULL, NULL, 'edit', 864, 865),
(697, 691, NULL, NULL, 'delete', 866, 867);

CREATE TABLE `aros` (
  `id` int(10) NOT NULL auto_increment,
  `parent_id` int(10) default NULL,
  `model` varchar(255) character set latin1 default NULL,
  `foreign_key` int(10) default NULL,
  `alias` varchar(255) character set latin1 default NULL,
  `lft` int(10) default NULL,
  `rght` int(10) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci AUTO_INCREMENT=8 ;

INSERT INTO `aros` (`id`, `parent_id`, `model`, `foreign_key`, `alias`, `lft`, `rght`) VALUES 
(1, NULL, 'Group', 1, 'Group::1', 1, 4),
(2, NULL, 'Group', 2, 'Group::2', 5, 8),
(3, NULL, 'Group', 3, 'Group::3', 9, 12),
(4, 1, 'User', 1, 'User::1', 2, 3),
(5, 2, 'User', 2, 'User::2', 6, 7),
(6, 3, 'User', 3, 'User::3', 10, 11);

CREATE TABLE `aros_acos` (
  `id` int(10) NOT NULL auto_increment,
  `aro_id` int(10) NOT NULL,
  `aco_id` int(10) NOT NULL,
  `_create` varchar(2) character set latin1 NOT NULL default '0',
  `_read` varchar(2) character set latin1 NOT NULL default '0',
  `_update` varchar(2) character set latin1 NOT NULL default '0',
  `_delete` varchar(2) character set latin1 NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `ARO_ACO_KEY` (`aro_id`,`aco_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci ;

INSERT INTO `aros_acos` (`id`, `aro_id`, `aco_id`, `_create`, `_read`, `_update`, `_delete`) VALUES (4, 1, 263, '1', '1', '1', '1'),
(5, 2, 263, '1', '1', '1', '1'),
(6, 3, 263, '1', '1', '1', '1');

--Delete Unnecessary Tables

--Create Revisions tables

--Change alias field in structures for study tables