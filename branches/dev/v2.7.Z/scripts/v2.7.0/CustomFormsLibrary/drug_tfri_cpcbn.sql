-- ------------------------------------------------------
-- ATiM ... Data Script
-- version: 2.7.2
-- ------------------------------------------------------

-- user id to define

SET @user_id = (SELECT id FROM users WHERE username LIKE '%' AND id LIKE '1');

-- --------------------------------------------------------------------------------
-- TFRI COEUR Drugs
-- ................................................................................
-- List of drugs created to capture data of prostat cancer 
-- for the central ATiM of the Canadian Prostate Cancer Biomarker Network (CPCBN).
-- Project of the Terry Fox Research Institute (TFRI).
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
('5-ARI', '', 'hormonal'),
('6 months', '', 'hormonal'),
('abiraterone', '', 'hormonal'),
('acide zoledronique', '', 'bone'),
('Agoniste LHEH', '', 'hormonal'),
('Agoniste LHRH', '', 'hormonal'),
('Analogue de la LHRH', '', 'hormonal'),
('androcure', '', 'hormonal'),
('atrasentan', '', 'HR'),
('avodart (5-alpha reductase inhibitor) ', '', 'hormonal'),
('bicatulamide', '', 'hormonal'),
('busereline', '', 'hormonal'),
('Cabazitaxel', '', 'chemotherapy'),
('carboplatin pour autre cancer', '', 'chemotherapy'),
('CARBOPLATIN', '', 'chemotherapy'),
('casodex - tamoxifene', '', 'hormonal'),
('Casodex 150', '', 'hormonal'),
('Casodex 50', '', 'hormonal'),
('casodex and lupron', '', 'hormonal'),
('casodex and trelstar', '', 'hormonal'),
('casodex', '', 'hormonal'),
('casodex/placebo', '', 'hormonal'),
('Casodex-Tamoxifene', '', 'hormonal'),
('cyproterone acetate', '', 'hormonal'),
('cyproterone', '', 'hormonal'),
('dasatinib', '', 'chemotherapy'),
('degarelix', '', 'hormonal'),
('denosumab', '', 'bone'),
('dexamethasone', '', 'chemotherapy'),
('docetaxel', '', 'chemotherapy'),
('eligard', '', 'hormonal'),
('Enzalutamide', '', 'hormonal'),
('enzastaurin', '', 'chemotherapy'),
('finasteride', '', 'hormonal'),
('firmagon', '', 'hormonal'),
('flomax', '', 'hormonal'),
('fluorouracil pour autre cancer', '', 'chemotherapy'),
('flutamide', '', 'hormonal'),
('gosereline', '', 'hormonal'),
('iressa', '', 'chemotherapy'),
('leuprolide acetate', '', 'hormonal'),
('leuprolide', '', 'hormonal'),
('lh inhibitor', '', 'hormonal'),
('LHRH agonist', '', 'hormonal'),
('LHRH', '', 'hormonal'),
('LHRH+', '', 'hormonal'),
('LHRH-a', '', 'hormonal'),
('LUPRON', '', 'hormonal'),
('methotrexate', '', 'chemotherapy'),
('mitoxantrone', '', 'chemotherapy'),
('nilandron', '', 'hormonal'),
('nitulamide', '', 'hormonal'),
('ogx-11(curstisen = cabazitaxel)', '', 'chemotherapy'),
('olaparib', '', 'chemotherapy'),
('orchiectomie', '', 'hormonal'),
('orteronel', '', 'HR'),
('patupilone', '', 'chemotherapy'),
('PI3 Kinase inhibitor-Inv Drug', '', 'bone'),
('placebo vs dasatinib', '', 'chemotherapy'),
('pr-13 +6 months adt', '', 'hormonal'),
('prednisone', '', 'chemotherapy'),
('Prednisone', '', 'hormonal'),
('prednisone', '', 'HR'),
('proscar', '', 'hormonal'),
('radium223', '', 'bone'),
('risedronate', '', 'bone'),
('suprefact', '', 'hormonal'),
('tamoxifen', '', 'hormonal'),
('taxotere', '', 'chemotherapy'),
('trelstar', '', 'hormonal'),
('triptoreline', '', 'hormonal'),
('Xgeva (Denosumab)', '', 'bone'),
('Xgeva', '', 'bone'),
('zoladex', '', 'hormonal'),
('Zoladex+Casodex', '', 'hormonal'),
('zoledronate', '', 'bone'),
('zoledronic acid', '', 'bone'),
('Zometa', '', 'bone');

UPDATE drugs_tmp, drugs
SET drugs_tmp.to_delete = 1
WHERE drugs.deleted <> 1
AND drugs.generic_name = drugs_tmp.generic_name
AND drugs.type = drugs_tmp.type;

INSERT INTO `drugs` (`generic_name`, `trade_name`, `type`, `created`, `created_by`, `modified`, `modified_by`) 
(SELECT `generic_name`, `trade_name`, `type`, NOW(), @user_id, NOW(), @user_id FROM drugs_tmp WHERE to_delete = 0);