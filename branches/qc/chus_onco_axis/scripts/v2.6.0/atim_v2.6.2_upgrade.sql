-- ------------------------------------------------------
-- ATiM v2.6.2 Upgrade Script
-- version: 2.6.2
--
-- For more information: 
--    http://www.ctrnet.ca/mediawiki/index.php/Main_Page
-- ------------------------------------------------------

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue#3039: Display of signs as percentage, lower than, etc in language_label, drop down list, etc 
-- -----------------------------------------------------------------------------------------------------------------------------------

REPLACE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('viability (%)', '', 'Viability (&#37;)', 'Viabilité (&#37;)'),
('in situ percentage', '', 'IS&#37;', 'IS&#37;'),
('invasive percentage', '', 'INV&#37;', 'INV&#37;'),
('necrosis inv percentage', '', 'Nec &#37; INV', 'Nec &#37; INV'),
('necrosis is percentage', '', 'Nec &#37; IS', 'Nec &#37; IS'),
('stroma percentage', '', 'STR&#37;', 'STR&#37;'),
('normal percentage', '', 'N&#37;', 'N&#37;'),
('3%-20% Ki67-positive cells', '', '3&#37;-20&#37; Ki67-Positive Cells', '3&#37;-20&#37; cellules Ki67 positives'),
('great than 20% Ki67-positive cells', '', '&gt;20&#37; Ki67-Positive Cells', '&gt;20&#37; cellules Ki67 positives'),
('less or equal 2% Ki67-positive cells', '', '&lt;=2&#37; Ki67-Positive Cells', '&lt;=2&#37; cellules Ki67 positives');

REPLACE INTO `i18n` (`id`, `en`, `fr`) 
VALUES
('mucinous adenocarcinoma (greater than 50% mucinous)', 'Mucinous adenocarcinoma (greater than 50% mucinous)', 'Adénocarcinome mucineux (composante mucineuse à plus de 50%)'),
('signet-ring cell carcinoma (greater than 50% signet-ring cells)', 'Signet-ring cell carcinoma (greater than 50% signet ring cells)', 'Carcinome a cellules en bague (cellules en bague à plus de 50%)');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Versions table
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO `versions` (version_number, date_installed, trunk_build_number, branch_build_number) 
VALUES('2.6.2', NOW(),'5710','n/a');
