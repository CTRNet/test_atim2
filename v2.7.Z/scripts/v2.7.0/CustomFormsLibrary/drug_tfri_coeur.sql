-- ------------------------------------------------------
-- ATiM ... Data Script
-- version: 2.7.2
-- ------------------------------------------------------

-- user id to define

SET @user_id = (SELECT id FROM users WHERE username LIKE '%' AND id LIKE '1');

-- --------------------------------------------------------------------------------
-- TFRI COEUR Drugs
-- ................................................................................
-- List of drugs created to capture data of ovary cancer 
-- for the central ATiM of the Canadian Ovarian Experimental Unified Resource 
-- (COEUR). Project of the Terry Fox Research Institute (TFRI).
-- --------------------------------------------------------------------------------

DROP TABLE IF EXISTS `drugs_tmp`;
CREATE TABLE IF NOT EXISTS `drugs_tmp` (
  `generic_name` varchar(50) NOT NULL DEFAULT '',
  `trade_name` varchar(50) NOT NULL DEFAULT '',
  `type` varchar(50) DEFAULT NULL,
  `to_delete` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `drugs_tmp` (`generic_name`, `trade_name`, `type`) 
VALUES
('cisplatinum', 'cisplatinum', 'chemotherapy'),
('carboplatinum', 'carboplatinum', 'chemotherapy'),
('oxaliplatinum', 'oxaliplatinum', 'chemotherapy'),
('paclitaxel', 'paclitaxel', 'chemotherapy'),
('topotecan', 'topotecan', 'chemotherapy'),
('ectoposide', 'ectoposide', 'chemotherapy'),
('tamoxifen', 'tamoxifen', 'chemotherapy'),
('doxetaxel', 'doxetaxel', 'chemotherapy'),
('doxorubicin', 'doxorubicin', 'chemotherapy'),
('other', 'other', 'chemotherapy'),
('etoposide', 'etoposide', 'chemotherapy'),
('gemcitabine', 'gemcitabine', 'chemotherapy'),
('procytox', 'procytox', 'chemotherapy'),
('vinorelbine', 'vinorelbine', 'chemotherapy'),
('cyclophosphamide', 'cyclophosphamide', 'chemotherapy'),
('olaparib', '', 'chemotherapy');

UPDATE drugs_tmp, drugs
SET drugs_tmp.to_delete = 1
WHERE drugs.deleted <> 1
AND drugs.generic_name = drugs_tmp.generic_name
AND drugs.type = drugs_tmp.type;

INSERT INTO `drugs` (`generic_name`, `trade_name`, `type`, `created`, `created_by`, `modified`, `modified_by`) 
(SELECT `generic_name`, `trade_name`, `type`, NOW(), @user_id, NOW(), @user_id FROM drugs_tmp WHERE to_delete = 0);