/*** PROCURE CUSM ******************************************************************************************/
INSERT IGNORE INTO 
	i18n (id,en,fr)
VALUES(
	"Download data", 
	"Download data", 
	"Télécharger les données");

-- -----------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET permissions_regenerated = 0;
INSERT INTO `versions` (version_number, date_installed, trunk_build_number, branch_build_number) 
VALUES
('2.6.8', NOW(),'6922','n/a');

/*** END PROCURE CUSM ******************************************************************************************/ 