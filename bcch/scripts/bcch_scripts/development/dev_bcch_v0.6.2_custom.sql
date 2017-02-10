-- BCCH Customization Script
-- Version 0.6.2
-- ATiM Version: 2.6.7

use atim_ccbr_dev;

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', "BCCH Biobank - BCCH v0.6.2", '');

-- ============================================================================
-- BB-193
-- Upgrade the Oncology Diagnosis Form
-- ============================================================================

-- Create a new ICD-O-3 Code Reference Table with Groupings in ATIM Database

RENAME TABLE coding_icd_o_3_morphology TO coding_icd_o_3_morphology_old;

DROP TABLE IF EXISTS coding_icd_o_3_morphology_2016;
CREATE TABLE coding_icd_o_3_morphology(
   primary_category  VARCHAR(255) DEFAULT NULL
  ,secondary_category VARCHAR(255) DEFAULT NULL
  ,tertiary_category VARCHAR(255) DEFAULT NULL
  ,id                    INT UNSIGNED DEFAULT NULL
  ,en_description        VARCHAR(255) DEFAULT NULL
  ,fr_description        VARCHAR(255) DEFAULT NULL
  ,translated            TINYINT UNSIGNED DEFAULT NULL
  ,source                VARCHAR(20) DEFAULT NULL
);

INSERT INTO coding_icd_o_3_morphology(`primary_category`,`secondary_category`,`tertiary_category`,`id`,`en_description`,`fr_description`,`translated`,`source`) VALUES
 ('Neoplasms, NOS',NULL,NULL,80000,'Neoplasm, benign','Tumeur b̩nigne',1,'WHO')
,('Neoplasms, NOS',NULL,NULL,80001,'Neoplasm, uncertain whether benign or malignant','Tumeur, type non d̩termin̩ (b̩nin ou malin)',1,'WHO')
,('Neoplasms, NOS',NULL,NULL,80003,'Neoplasm, malignant','Tumeur maligne',1,'WHO')
,('Neoplasms, NOS',NULL,NULL,80006,'Neoplasm, metastatic','Tumeur m̩tastatique',1,'WHO')
,('Neoplasms, NOS',NULL,NULL,80009,'Neoplasm, malignant, uncertain whether primary or metastatic','Tumeur maligne de nature primaire ou secondaire non assur����e',1,'WHO')
,('Neoplasms, NOS',NULL,NULL,80010,'Tumor cells, benign','Cellules tumorales b����nignes',1,'WHO')
,('Neoplasms, NOS',NULL,NULL,80011,'Tumor cells, uncertain whether benign or malignant','Cellules tumorales de b����nignit���� ou  de malignit���� non assur����e',1,'WHO')
,('Neoplasms, NOS',NULL,NULL,80013,'Tumor cells, malignant','Cellules tumorales malignes',1,'WHO')
,('Neoplasms, NOS',NULL,NULL,80023,'Malignant tumor, small cell type','����Tumeur maligne ���� petites cellules',1,'WHO')
,('Neoplasms, NOS',NULL,NULL,80033,'Malignant tumor, giant cell type','Tumeur maligne ���� grandes cellules',1,'WHO')
,('Neoplasms, NOS',NULL,NULL,80043,'Malignant tumor, spindle cell type','Tumeur maligne ���� cellules fusiformes',1,'WHO')
,('Neoplasms, NOS',NULL,NULL,80050,'Clear cell tumor, NOS','Tumeur ���� cellules claires',1,'WHO')
,('Neoplasms, NOS',NULL,NULL,80053,'Malignant tumor, clear cell type','Tumeur maligne ���� cellules claires',1,'WHO')
,('Epithelial Neoplasms, NOS',NULL,NULL,80100,'Epithelial tumor, benign','Tumeur ����pith����liale b����nigne',1,'WHO')
,('Epithelial Neoplasms, NOS',NULL,NULL,80102,'Carcinoma in situ, NOS','Carcinome in situ',1,'WHO')
,('Epithelial Neoplasms, NOS',NULL,NULL,80103,'Carcinoma, NOS','Carcinome',1,'WHO')
,('Epithelial Neoplasms, NOS',NULL,NULL,80106,'Carcinoma, metastatic, NOS','Carcinome m����tastatique',1,'WHO')
,('Epithelial Neoplasms, NOS',NULL,NULL,80109,'Carcinomatosis','Carcinomatose',1,'WHO')
,('Epithelial Neoplasms, NOS',NULL,NULL,80110,'Epithelioma, benign','��pith̩lioma b̩nin',1,'WHO')
,('Epithelial Neoplasms, NOS',NULL,NULL,80113,'Epithelioma, malignant','��pith̩lioma malin',1,'WHO')
,('Epithelial Neoplasms, NOS',NULL,NULL,80123,'Large cell carcinoma, NOS','Carcinome ���� grandes cellules',1,'WHO')
,('Epithelial Neoplasms, NOS',NULL,NULL,80133,'Large cell neuroendocrine carcinoma','Carcinome neuroendocrinien ���� grandes cellules',1,'WHO')
,('Epithelial Neoplasms, NOS',NULL,NULL,80143,'Large cell carcinoma with rhabdoid phenotype','Carcinome ���� grandes cellules avec un ph����notype rhabdo����de',1,'WHO')
,('Epithelial Neoplasms, NOS',NULL,NULL,80153,'Glassy cell carcinoma','Carcinome ���� cellules hyalines',1,'WHO')
,('Epithelial Neoplasms, NOS',NULL,NULL,80203,'Carcinoma, undifferentiated, NOS','Carcinome indiff����renci����',1,'WHO')
,('Epithelial Neoplasms, NOS',NULL,NULL,80213,'Carcinoma, anaplastic, NOS','Carcinome anaplasique',1,'WHO')
,('Epithelial Neoplasms, NOS',NULL,NULL,80223,'Pleomorphic carcinoma','Carcinome pl̩omorphe',1,'WHO')
,('Epithelial Neoplasms, NOS',NULL,NULL,80303,'Giant cell and spindle cell carcinoma','Carcinome �� cellules g̩antes et �� cellules fusiformes',1,'WHO')
,('Epithelial Neoplasms, NOS',NULL,NULL,80313,'Giant cell carcinoma','Carcinome �� cellules g̩antes',1,'WHO')
,('Epithelial Neoplasms, NOS',NULL,NULL,80323,'Spindle cell carcinoma, NOS','Carcinome ���� cellules fusiformes',1,'WHO')
,('Epithelial Neoplasms, NOS',NULL,NULL,80333,'Pseudosarcomatous carcinoma','Carcinome pseudosarcomateux',1,'WHO')
,('Epithelial Neoplasms, NOS',NULL,NULL,80343,'Polygonal cell carcinoma','Carcinome �� cellules polygonales',1,'WHO')
,('Epithelial Neoplasms, NOS',NULL,NULL,80353,'Carcinoma with osteoclast-like giant cells','Carcinome ���� cellules g����antes ost����oclastiformes',1,'WHO')
,('Epithelial Neoplasms, NOS',NULL,NULL,80400,'Tumorlet, benign','Tumorlet b����nin',1,'WHO')
,('Epithelial Neoplasms, NOS',NULL,NULL,80401,'Tumorlet, NOS','Tumorlet',1,'WHO')
,('Epithelial Neoplasms, NOS',NULL,NULL,80413,'Small cell carcinoma, NOS','Carcinome ���� petites cellules',1,'WHO')
,('Epithelial Neoplasms, NOS',NULL,NULL,80423,'Oat cell carcinoma','Carcinome �� cellules en grain d''avoine',1,'WHO')
,('Epithelial Neoplasms, NOS',NULL,NULL,80433,'Small cell carcinoma, fusiform cell','Carcinome �� petites cellules (anaplasique), type fusiforme',1,'WHO')
,('Epithelial Neoplasms, NOS',NULL,NULL,80443,'Small cell carcinoma, intermediate cell','Carcinome ���� petites cellules interm����diaires',1,'WHO')
,('Epithelial Neoplasms, NOS',NULL,NULL,80453,'Combined small cell carcinoma','Carcinome mixte ���� petites cellules',1,'WHO')
,('Epithelial Neoplasms, NOS',NULL,NULL,80463,'Non-small cell carcinoma','Carcinome non ���� petites cellules',1,'WHO')
,('Squamous cell neoplasms',NULL,NULL,80500,'Papilloma, NOS','Papillome',1,'WHO')
,('Squamous cell neoplasms',NULL,NULL,80502,'Papillary carcinoma in situ','Carcinome papillaire in situ',1,'WHO')
,('Squamous cell neoplasms',NULL,NULL,80503,'Papillary carcinoma, NOS','Carcinome papillaire',1,'WHO')
,('Squamous cell neoplasms',NULL,NULL,80510,'Verrucous papilloma','Papillome verruqueux',1,'WHO')
,('Squamous cell neoplasms',NULL,NULL,80513,'Verrucous carcinoma, NOS','Carcinome verruqueux',1,'WHO')
,('Squamous cell neoplasms',NULL,NULL,80520,'Squamous cell papilloma, NOS','Papillome spinocellulaire',1,'WHO')
,('Squamous cell neoplasms',NULL,NULL,80522,'Papillary squamous cell carcinoma,  non-invasive','Carcinome ����pidermo����de papillaire non invasif',1,'WHO')
,('Squamous cell neoplasms',NULL,NULL,80523,'Papillary squamous cell carcinoma','Carcinome ̩pidermo��de papillaire',1,'WHO')
,('Squamous cell neoplasms',NULL,NULL,80530,'Squamous cell papilloma, inverted','Papillome ����pidermo����de invers����',1,'WHO')
,('Squamous cell neoplasms',NULL,NULL,80600,'Squamous papillomatosis','Papillomatose ����pidermo����de',1,'WHO')
,('Squamous cell neoplasms',NULL,NULL,80702,'Squamous cell carcinoma in situ, NOS','Carcinome ����pidermo����de in situ',1,'WHO')
,('Squamous cell neoplasms',NULL,NULL,80703,'Squamous cell carcinoma, NOS','Carcinome ����pidermo����de',1,'WHO')
,('Squamous cell neoplasms',NULL,NULL,80706,'Squamous cell carcinoma, metastatic, NOS','Carcinome ����pidermo����de m����tastatique',1,'WHO')
,('Squamous cell neoplasms',NULL,NULL,80713,'Squamous cell carcinoma, keratinizing, NOS','Carcinome ����pidermo����de k����ratinisant',1,'WHO')
,('Squamous cell neoplasms',NULL,NULL,80723,'Squamous cell carcinoma, large cell, nonkeratinizing, NOS','Carcinome ����pidermo����de non k����ratinisant, ���� grandes cellules',1,'WHO')
,('Squamous cell neoplasms',NULL,NULL,80733,'Squamous cell carcinoma, small cell, nonkeratinizing','Carcinome ̩pidermo��de, �� petites cellules, non k̩ratinisant',1,'WHO')
,('Squamous cell neoplasms',NULL,NULL,80743,'Squamous cell carcinoma, spindle cell','Carcinome ̩pidermo��de, �� cellules fusiformes',1,'WHO')
,('Squamous cell neoplasms',NULL,NULL,80753,'Squamous cell carcinoma, adenoid','Carcinome ����pidermo����de pseudo-glandulaire',1,'WHO')
,('Squamous cell neoplasms',NULL,NULL,80762,'Squamous cell carcinoma in situ with questionable stromal invasion','Carcinome ̩pidermo��de in situ avec envahissement stromal discutable',1,'WHO')
,('Squamous cell neoplasms',NULL,NULL,80763,'Squamous cell carcinoma, microinvasive','Carcinome ̩pidermo��de micro-invasif',1,'WHO')
,('Squamous cell neoplasms',NULL,NULL,80772,'Squamous intraepithelial neoplasia, grade III','N����oplasie intra����pith����liale, grade III',1,'WHO')
,('Squamous cell neoplasms',NULL,NULL,80783,'Squamous cell carcinoma with horn formation','Carcinome ����pidermo����de avec formation d''une corne cutan����e',1,'WHO')
,('Squamous cell neoplasms',NULL,NULL,80802,'Queyrat erythroplasia','�ĉۡrythroplasie de Queyrat',1,'WHO')
,('Squamous cell neoplasms',NULL,NULL,80812,'Bowen disease','Maladie de Bowen',1,'WHO')
,('Squamous cell neoplasms',NULL,NULL,80823,'Lymphoepithelial carcinoma','Carcinome lympho-̩pith̩lial',1,'WHO')
,('Squamous cell neoplasms',NULL,NULL,80833,'Basaloid squamous cell carcinoma','Carcinome ����pidermo����de basalo����de',1,'WHO')
,('Squamous cell neoplasms',NULL,NULL,80843,'Squamous cell carcinoma, clear cell type','Carcinome ����pidermo����de ���� cellules claires',1,'WHO')
,('Basal cell neoplasms',NULL,NULL,80901,'Basal cell tumor','Tumeur basocellulaire',1,'WHO')
,('Basal cell neoplasms',NULL,NULL,80903,'Basal cell carcinoma, NOS','Carcinome basocellulaire',1,'WHO')
,('Basal cell neoplasms',NULL,NULL,80913,'Multifocal superficial basal cell carcinoma','Carcinome basocellulaire superficiel multifocal',1,'WHO')
,('Basal cell neoplasms',NULL,NULL,80923,'Infiltrating basal cell carcinoma, NOS','Carcinome basocellulaire infiltrant',1,'WHO')
,('Basal cell neoplasms',NULL,NULL,80933,'Basal cell carcinoma, fibroepithelial','Carcinome basocellulaire (pigment̩), type fibro-̩pith̩lial',1,'WHO')
,('Basal cell neoplasms',NULL,NULL,80943,'Basosquamous carcinoma','Carcinome baso-spinocellulaire, mixte',1,'WHO')
,('Basal cell neoplasms',NULL,NULL,80953,'Metatypical carcinoma','Carcinome m̩tatypique',1,'WHO')
,('Basal cell neoplasms',NULL,NULL,80960,'Intraepidermal epithelioma of Jadassohn','��pith̩lioma intra-̩pidermique de Jadassohn',1,'WHO')
,('Basal cell neoplasms',NULL,NULL,80973,'Basal cell carcinoma, nodular','Carcinome basocellulaire nodulaire',1,'WHO')
,('Basal cell neoplasms',NULL,NULL,80983,'Adenoid basal carcinoma','Carcinome basocellulaire ad����no����de',1,'WHO')
,('Basal cell neoplasms',NULL,NULL,81000,'Trichoepithelioma','Tricho-̩pith̩liome',1,'WHO')
,('Basal cell neoplasms',NULL,NULL,81010,'Trichofolliculoma','Trichofolliculome',1,'WHO')
,('Basal cell neoplasms',NULL,NULL,81020,'Trichilemmoma','Trichilemmome',1,'WHO')
,('Basal cell neoplasms',NULL,NULL,81023,'Trichilemmocarcinoma','Trichilemmocarcinome',1,'WHO')
,('Basal cell neoplasms',NULL,NULL,81030,'Pilar tumor','Tumeur pilaire',1,'WHO')
,('Basal cell neoplasms',NULL,NULL,81100,'Pilomatrixoma, NOS','Pilomatrixome',1,'WHO')
,('Basal cell neoplasms',NULL,NULL,81103,'Pilomatrix carcinoma','Carcinome pilomatrix',1,'WHO')
,('transitional cell papillomas and carcinomas',NULL,NULL,81200,'Transitional cell papilloma, benign','Papillome b����nin ���� cellules transitionnelles',1,'WHO')
,('transitional cell papillomas and carcinomas',NULL,NULL,81201,'Urothelial papilloma, NOS','Papillome ���� cellules transitionnelles',1,'WHO')
,('transitional cell papillomas and carcinomas',NULL,NULL,81202,'Transitional cell carcinoma in situ','Carcinome in situ �� cellules transitionnelles',1,'WHO')
,('transitional cell papillomas and carcinomas',NULL,NULL,81203,'Transitional cell carcinoma, NOS','Carcinome ���� cellules transitionnelles',1,'WHO')
,('transitional cell papillomas and carcinomas',NULL,NULL,81210,'Schneiderian papilloma, NOS','Papillome schneid����rien',1,'WHO')
,('transitional cell papillomas and carcinomas',NULL,NULL,81211,'Transitional cell papilloma, inverted, NOS','Papillome transitionnel invers����',1,'WHO')
,('transitional cell papillomas and carcinomas',NULL,NULL,81213,'Schneiderian carcinoma','Carcinome schneid̩rien',1,'WHO')
,('transitional cell papillomas and carcinomas',NULL,NULL,81223,'Transitional cell carcinoma, spindle cell','Carcinome �� cellules transitionnelles, type fusiforme',1,'WHO')
,('transitional cell papillomas and carcinomas',NULL,NULL,81233,'Basaloid carcinoma','Carcinome basalo��de',1,'WHO')
,('transitional cell papillomas and carcinomas',NULL,NULL,81243,'Cloacogenic carcinoma','Carcinome cloacog̩nique',1,'WHO')
,('transitional cell papillomas and carcinomas',NULL,NULL,81301,'Papillary transitional cell neoplasm of low malignant potential','Tumeur transitionnelle papillaire ���� faible potentiel malin',1,'WHO')
,('transitional cell papillomas and carcinomas',NULL,NULL,81302,'Papillary transitional cell carcinoma,  non-invasive','Carcinome transitionnel papillaire non invasif',1,'WHO')
,('transitional cell papillomas and carcinomas',NULL,NULL,81303,'Papillary transitional cell carcinoma','Carcinome papillaire, �� cellules transitionnelles',1,'WHO')
,('transitional cell papillomas and carcinomas',NULL,NULL,81313,'Transitional cell carcinoma, micropapillary','Carcinome transitionnel micropapillaire',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,81400,'Adenoma, NOS','Ad����nome',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,81401,'Atypical adenoma','Ad����nome atypique',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,81402,'Adenocarcinoma in situ, NOS','Ad����nocarcinome in situ',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,81403,'Adenocarcinoma, NOS','Ad����nocarcinome',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,81406,'Adenocarcinoma, metastatic, NOS','Ad����nocarcinome m����tastatique',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,81413,'Scirrhous adenocarcinoma','Ad̩nocarcinome squirrheux',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,81423,'Linitis plastica','Linite plastique',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,81433,'Superficial spreading adenocarcinoma','Ad̩nocarcinome �� diffusion superficielle',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,81443,'Adenocarcinoma, intestinal type','Ad̩nocarcinome, type intestinal',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,81453,'Carcinoma, diffuse type','Carcinome, type diffus',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,81460,'Monomorphic adenoma','Ad̩nome monomorphe',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,81470,'Basal cell adenoma','Ad̩nome basocellulaire',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,81473,'Basal cell adenocarcinoma','Ad̩nocarcinome basocellulaire',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,81482,'Glandular intraepithelial neoplasia, grade III','N����oplasie glandulaire intra����pith����liale, grade III',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,81490,'Canalicular adenoma','Ad����nome canaliculaire',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,81500,'Islet cell adenoma','Ad̩nome insulaire (actif)',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,81501,'Islet cell tumor, NOS','Tumeur ���� cellules insulaires',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,81503,'Islet cell carcinoma','Carcinome insulaire',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,81510,'Insulinoma, NOS','Insulinome',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,81513,'Insulinoma, malignant','Insulinome malin',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,81521,'Glucagonoma, NOS','Glucagonome',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,81523,'Glucagonoma, malignant','Glucagonome malin',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,81531,'Gastrinoma, NOS','Gastrinome',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,81533,'Gastrinoma, malignant','Gastrinome malin',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,81543,'Mixed islet cell and exocrine adenocarcinoma','Ad̩nocarcinome insulaire et exocrine, mixte',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,81551,'Vipoma, NOS','Vipome',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,81553,'Vipoma, malignant','Vipome malin',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,81561,'Somatostatinoma, NOS','Somatostatinome',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,81563,'Somatostatinoma, malignant','Somatostatinome malin',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,81571,'Enteroglucagonoma, NOS','Ent����roglucagonome',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,81573,'Enteroglucagonoma, malignant','Ent����roglucagonome malin',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,81600,'Bile duct adenoma','Ad̩nome des voies biliaires',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,81603,'Cholangiocarcinoma','Cholangiocarcinome',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,81610,'Bile duct cystadenoma','Cystad̩nome biliaire',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,81613,'Bile duct cystadenocarcinoma','Cystad̩nocarcinome biliaire',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,81623,'Klatskin tumor','Tumeur de Klatskin',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,81700,'Liver cell adenoma','Ad̩nome �� cellules h̩patiques',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,81703,'Hepatocellular carcinoma, NOS','Carcinome h����patocellulaire',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,81713,'Hepatocellular carcinoma, fibrolamellar','Carcinome h̩patocellulaire, type fibrolamellaire',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,81723,'Hepatocellular carcinoma, scirrhous','Carcinome h����patocellulaire squirrheux',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,81733,'Hepatocellular carcinoma, spindle cell variant','Carcinome h����patocellulaire, variante ���� cellules fusiformes',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,81743,'Hepatocellular carcinoma, clear cell type','Carcinome h����patocellulaire ���� cellules claires',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,81753,'Hepatocellular carcinoma, pleomorphic type','Carcinome h����patocellulaire pl����omorphe',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,81803,'Combined hepatocellular carcinoma and cholangiocarcinoma','Carcinome h����patocellulaire et cholangiocarcinome combin����s',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,81900,'Trabecular adenoma','Ad̩nome trab̩culaire',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,81903,'Trabecular adenocarcinoma','Ad̩nocarcinome trab̩culaire',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,81910,'Embryonal adenoma','Ad̩nome embryonnaire',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82000,'Eccrine dermal cylindroma','Cylindrome eccrine dermique',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82003,'Adenoid cystic carcinoma','Carcinome ad̩no��de kystique',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82012,'Cribriform carcinoma in situ','Carcinome cribiforme intra����pith����lial',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82013,'Cribriform carcinoma, NOS','Carcinome cribiforme',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82020,'Microcystic adenoma','Ad̩nome microkystique',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82040,'Lactating adenoma','Ad����nome de lactation',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82100,'Adenomatous polyp, NOS','Polype ad����nomateux',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82102,'Adenocarcinoma in situ in adenomatous polyp','Ad̩nocarcinome in situ sur polype ad̩nomateux',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82103,'Adenocarcinoma in adenomatous polyp','Ad̩nocarcinome sur polype ad̩nomateux',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82110,'Tubular adenoma, NOS','Ad����nome tubuleux',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82113,'Tubular adenocarcinoma','Ad̩nocarcinome tubuleux',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82120,'Flat adenoma','Ad����nome plat',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82130,'Serrated adenoma','Ad����nome dentel����',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82143,'Parietal cell carcinoma','Carcinome ���� cellules pari����tales',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82153,'Adenocarcinoma of anal glands','Ad����nocarcinome des glandes anales',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82200,'Adenomatous polyposis coli','Polypose ad̩nomateuse du c̫lon',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82203,'Adenocarcinoma in adenomatous polyposis coli','Ad̩nocarcinome sur polypose ad̩nomateuse du c̫lon',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82210,'Multiple adenomatous polyps','Polypes ad̩nomateux multiples',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82213,'Adenocarcinoma in multiple adenomatous polyps','Ad̩nocarcinome sur polypes ad̩nomateux multiples',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82302,'Ductal carcinoma in situ, solid type','Carcinome canalaire intra����pith����lial solide',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82303,'Solid carcinoma, NOS','Carcinome solide',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82313,'Carcinoma simplex','Carcinome simplex',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82401,'Carcinoid tumor of uncertain malignant potential','Tumeur carcino����de de potentiel malin incertain',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82403,'Carcinoid tumor, NOS','Tumeur carcino����de',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82413,'Enterochromaffin cell carcinoid','Carcino����de malin ���� cellules ent����rochromaffines',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82421,'Enterochromaffin-like cell carcinoid, NOS','Carcino����de ���� cellules ent����rochromaffino����des',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82423,'Enterochromaffin-like cell tumor, malignant','Carcino����de malin ���� cellules ent����rochromaffino����des',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82433,'Goblet cell carcinoid','Carcino��de �� cellules caliciformes',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82443,'Composite carcinoid','Carcino��de composite',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82451,'Tubular carcinoid','Carcino����de tubuleux',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82453,'Adenocarcinoid tumor','Tumeur ad����nocarcino����de',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82463,'Neuroendocrine carcinoma, NOS','Carcinome neuroendocrinien',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82473,'Merkel cell carcinoma','Carcinome �� cellules de Merkel',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82481,'Apudoma','Apudome',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82493,'Atypical carcinoid tumor','Tumeur carcino����de maligne atypique',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82501,'Pulmonary adenomatosis','Ad̩nomatose pulmonaire',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82503,'Bronchiolo-alveolar adenocarcinoma, NOS','Ad����nocarcinome bronchioloalv����olaire',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82510,'Alveolar adenoma','Ad̩nome alv̩olaire',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82513,'Alveolar adenocarcinoma','Ad̩nocarcinome alv̩olaire',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82523,'Bronchiolo-alveolar carcinoma, non- mucinous','Carcinome bronchioloalv����olaire non mucineux',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82533,'Bronchiolo-alveolar carcinoma, mucinous','Carcinome bronchioloalv����olaire mucineux',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82543,'Bronchiolo-alveolar carcinoma, mixed mucinous and non-mucinous','Carcinome bronchioloalv����olaire mixte mucineux et non mucineux',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82553,'Adenocarcinoma with mixed subtypes','Ad����nocarcinome avec sous-types mixtes',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82600,'Papillary adenoma, NOS','Ad����nome papillaire',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82603,'Papillary adenocarcinoma, NOS','Ad����nocarcinome papillaire',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82610,'Villous adenoma, NOS','Ad����nome villeux',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82612,'Adenocarcinoma in situ in villous adenoma','Ad����nocarcinome in situ sur ad����nome villeux',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82613,'Adenocarcinoma in villous adenoma','Ad̩nocarcinome sur ad̩nome villeux',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82623,'Villous adenocarcinoma','Ad̩nocarcinome villeux',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82630,'Tubulovillous adenoma, NOS','Ad����nome tubulovilleux',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82632,'Adenocarcinoma in situ in tubulovillous adenoma','Ad̩nocarcinome in situ sur ad̩nome tubulovilleux',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82633,'Adenocarcinoma in tubulovillous adenoma','Ad̩nocarcinome sur ad̩nome tubulovilleux',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82640,'Papillomatosis, glandular','Papillomatose glandulaire',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82700,'Chromophobe adenoma','Ad̩nome chromophobe',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82703,'Chromophobe carcinoma','Carcinome chromophobe',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82710,'Prolactinoma','Prolactinome',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82720,'Pituitary adenoma, NOS','Ad����nome pituitaire',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82723,'Pituitary carcinoma, NOS','Carcinome pituitaire',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82800,'Acidophil adenoma','Ad̩nome acidophile',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82803,'Acidophil carcinoma','Carcinome acidophile',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82810,'Mixed acidophil-basophil adenoma','Ad̩nome acidophile et basophile, mixte',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82813,'Mixed acidophil-basophil carcinoma','Carcinome acidophile et basophile, mixte',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82900,'Oxyphilic adenoma','Ad̩nome oxyphile',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,82903,'Oxyphilic adenocarcinoma','Ad̩nocarcinome oxyphile',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83000,'Basophil adenoma','Ad̩nome basophile',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83003,'Basophil carcinoma','Carcinome basophile',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83100,'Clear cell adenoma','Ad̩nome �� cellules claires',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83103,'Clear cell adenocarcinoma, NOS','Ad����nocarcinome ���� cellules claires',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83111,'Hypernephroid tumor','Tumeur hypern����phro����de',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83123,'Renal cell carcinoma, NOS','Carcinome ���� cellules r����nales',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83130,'Clear cell adenofibroma','Ad̩nofibrome �� cellules claires',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83131,'Clear cell adenofibroma of borderline malignancy','Ad����nofibrome ���� cellules claires ���� la limite de la malignit����',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83133,'Clear cell adenocarcinofibroma','Ad����nocarcinofibrome ���� cellules claires',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83143,'Lipid-rich carcinoma','Carcinome riche en lipides',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83153,'Glycogen-rich carcinoma','Carcinome riche en glycog̬ne',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83163,'Cyst-associated renal cell carcinoma','Carcinome ���� cellules r����nales associ���� ���� un kyste',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83173,'Renal cell carcinoma, chromophobe type','Carcinome ���� cellules r����nales chromophobes',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83183,'Renal cell carcinoma, sarcomatoid','Carcinome ���� cellules r����nales sarcomato����de',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83193,'Collecting duct carcinoma','Carcinome des tubes droits du rein',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83203,'Granular cell carcinoma','Carcinome �� cellules granuleuses',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83210,'Chief cell adenoma','Ad̩nome �� cellules principales',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83220,'Water-clear cell adenoma','Ad̩nome �� cellules eau de roche',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83223,'Water-clear cell adenocarcinoma','Ad̩nocarcinome �� cellules eau de roche',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83230,'Mixed cell adenoma','Ad̩nome �� cellules mixtes (�� cellules principales et �� cellules eau de roche)',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83233,'Mixed cell adenocarcinoma','Ad̩nocarcinome �� cellules mixtes',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83240,'Lipoadenoma','Lipo-ad̩nome',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83250,'Metanephric adenoma','Ad����nome m����tan����phrique',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83300,'Follicular adenoma','Ad̩nome folliculaire',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83301,'Atypical follicular adenoma','Ad����nome v����siculaire atypique',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83303,'Follicular adenocarcinoma, NOS','Ad����nocarcinome v����siculaire',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83313,'Follicular adenocarcinoma, well differentiated','Ad̩nocarcinome v̩siculaire, bien diff̩renci̩',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83323,'Follicular adenocarcinoma, trabecular','Ad̩nocarcinome v̩siculaire, type trab̩culaire',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83330,'Microfollicular adenoma, NOS','Ad����nome microv����siculaire',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83333,'Fetal adenocarcinoma','Ad����nocarcinome f�ɉ��tal',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83340,'Macrofollicular adenoma','Ad̩nome macrov̩siculaire',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83353,'Follicular carcinoma, minimally invasive','Carcinome v����siculaire microinvasif',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83360,'Hyalinizing trabecular adenoma','Ad����nome trab����culaire hyalinisant',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83373,'Insular carcinoma','Carcinome insulaire',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83403,'Papillary carcinoma, follicular variant','Carcinome papillaire, �� variante v̩siculaire',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83413,'Papillary microcarcinoma','Microcarcinome papillaire',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83423,'Papillary carcinoma, oxyphilic cell','Carcinome papillaire ���� cellules oxyphile',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83433,'Papillary carcinoma, encapsulated','Carcinome papillaire encapsul����',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83443,'Papillary carcinoma, columnar cell','Carcinome papillaire ���� cellules cylindriques',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83453,'Medullary carcinoma with amyloid stroma','Carcinome m̩dullaire �� stroma amylo��de',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83463,'Mixed medullary-follicular carcinoma','Carcinome mixte m����dullaire et v����siculaire',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83473,'Mixed medullary-papillary carcinoma','Carcinome mixte m����dullaire et papillaire',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83503,'Nonencapsulated sclerosing carcinoma','Carcinome scl̩rosant non encapsul̩',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83601,'Multiple endocrine adenomas','Ad̩nome endocrinien multiple',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83610,'Juxtaglomerular tumor','Tumeur juxtaglom����rulaire',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83700,'Adrenal cortical adenoma, NOS','Ad����nome corticosurr����nalien',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83703,'Adrenal cortical carcinoma','Carcinome corticosurr̩nalien',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83710,'Adrenal cortical adenoma, compact cell','Ad����nome corticosurr����nalien ���� cellules compactes',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83720,'Adrenal cortical adenoma, pigmented','Ad����nome corticosurr����nalien pigment����',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83730,'Adrenal cortical adenoma, clear cell','Ad̩nome corticosurr̩nalien, �� cellules claires',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83740,'Adrenal cortical adenoma, glomerulosa cell','Ad̩nome corticosurr̩nalien, �� cellules glom̩rulaires',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83750,'Adrenal cortical adenoma, mixed cell','Ad̩nome corticosurr̩nalien, �� cellules mixtes',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83800,'Endometrioid adenoma, NOS','Ad����nome endom����trio����de',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83801,'Endometrioid adenoma, borderline malignancy','Ad̩nome endom̩trio��de, �� la limite de la malignit̩',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83803,'Endometrioid adenocarcinoma, NOS','Ad����nocarcinome endom����trio����de',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83810,'Endometrioid adenofibroma, NOS','Ad����nofibrome endom����trio����de',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83811,'Endometrioid adenofibroma, borderline malignancy','Ad̩nofibrome endom̩trio��de, �� la limite de la malignit̩',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83813,'Endometrioid adenofibroma, malignant','Ad̩nofibrome endom̩trio��de, malin',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83823,'Endometrioid adenocarcinoma, secretory variant','Ad����nocarcinome endom����trio����de, variante s����cr����toire',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83833,'Endometrioid adenocarcinoma, ciliated cell variant','Ad����nocarcinome endom����trio����de, variante ���� cellules cili����es',1,'WHO')
,('adenomas and adenocarcinomas',NULL,NULL,83843,'Adenocarcinoma, endocervical type','Ad����nocarcinome de type endocervical',1,'WHO')
,('Adnexal and skin appendage neoplasms',NULL,NULL,83900,'Skin appendage adenoma','Ad̩nome des annexes cutan̩es',1,'WHO')
,('Adnexal and skin appendage neoplasms',NULL,NULL,83903,'Skin appendage carcinoma','Carcinome des annexes cutan̩es',1,'WHO')
,('Adnexal and skin appendage neoplasms',NULL,NULL,83910,'Follicular fibroma','Fibrome folliculaire',1,'WHO')
,('Adnexal and skin appendage neoplasms',NULL,NULL,83920,'Syringofibroadenoma','Syringofibroad����nome',1,'WHO')
,('Adnexal and skin appendage neoplasms',NULL,NULL,84000,'Sweat gland adenoma','Ad̩nome des glandes sudoripares',1,'WHO')
,('Adnexal and skin appendage neoplasms',NULL,NULL,84001,'Sweat gland tumor, NOS','Tumeur de glandes sudoripares',1,'WHO')
,('Adnexal and skin appendage neoplasms',NULL,NULL,84003,'Sweat gland adenocarcinoma','Ad̩nocarcinome des glandes sudoripares',1,'WHO')
,('Adnexal and skin appendage neoplasms',NULL,NULL,84010,'Apocrine adenoma','Ad̩nome apocrine',1,'WHO')
,('Adnexal and skin appendage neoplasms',NULL,NULL,84013,'Apocrine adenocarcinoma','Ad̩nocarcinome apocrine',1,'WHO')
,('Adnexal and skin appendage neoplasms',NULL,NULL,84020,'Nodular hidradenoma','Hidrad����nome nodulaire',1,'WHO')
,('Adnexal and skin appendage neoplasms',NULL,NULL,84023,'Nodular hidradenoma, malignant','Hidrad����nome nodulaire malin',1,'WHO')
,('Adnexal and skin appendage neoplasms',NULL,NULL,84030,'Eccrine spiradenoma','Spirad̩nome eccrine',1,'WHO')
,('Adnexal and skin appendage neoplasms',NULL,NULL,84033,'Malignant eccrine spiradenoma','Spirad����nome eccrine malin',1,'WHO')
,('Adnexal and skin appendage neoplasms',NULL,NULL,84040,'Hidrocystoma','Hidrocystome',1,'WHO')
,('Adnexal and skin appendage neoplasms',NULL,NULL,84050,'Papillary hidradenoma','Hidrad̩nome papillaire',1,'WHO')
,('Adnexal and skin appendage neoplasms',NULL,NULL,84060,'Papillary syringadenoma','Syringo-ad̩nome papillaire',1,'WHO')
,('Adnexal and skin appendage neoplasms',NULL,NULL,84070,'Syringoma, NOS','Syringome',1,'WHO')
,('Adnexal and skin appendage neoplasms',NULL,NULL,84073,'Sclerosing sweat duct carcinoma','Carcinome scl����rosant d''un canal sudorif����re',1,'WHO')
,('Adnexal and skin appendage neoplasms',NULL,NULL,84080,'Eccrine papillary adenoma','Ad̩nome eccrine papillaire',1,'WHO')
,('Adnexal and skin appendage neoplasms',NULL,NULL,84081,'Aggressive digital papillary adenoma','Ad����nome papillaire digital agressif',1,'WHO')
,('Adnexal and skin appendage neoplasms',NULL,NULL,84083,'Eccrine papillary adenocarcinoma','Ad����nocarcinome papillaire eccrine',1,'WHO')
,('Adnexal and skin appendage neoplasms',NULL,NULL,84090,'Eccrine poroma','Porome eccrine',1,'WHO')
,('Adnexal and skin appendage neoplasms',NULL,NULL,84093,'Eccrine poroma, malignant','Porome eccrine malin',1,'WHO')
,('Adnexal and skin appendage neoplasms',NULL,NULL,84100,'Sebaceous adenoma','Ad̩nome s̩bac̩',1,'WHO')
,('Adnexal and skin appendage neoplasms',NULL,NULL,84103,'Sebaceous adenocarcinoma','Ad̩nocarcinome s̩bac̩',1,'WHO')
,('Adnexal and skin appendage neoplasms',NULL,NULL,84133,'Eccrine adenocarcinoma','Ad����nocarcinome eccrine',1,'WHO')
,('Adnexal and skin appendage neoplasms',NULL,NULL,84200,'Ceruminous adenoma','Ad̩nome c̩rumineux',1,'WHO')
,('Adnexal and skin appendage neoplasms',NULL,NULL,84203,'Ceruminous adenocarcinoma','Ad̩nocarcinome c̩rumineux',1,'WHO')
,('Mucoepidermoid neoplasms',NULL,NULL,84301,'Mucoepidermoid tumor','Tumeur muco-����pidermo����de',1,'WHO')
,('Mucoepidermoid neoplasms',NULL,NULL,84303,'Mucoepidermoid carcinoma','Carcinome muco-̩pidermo��de',1,'WHO')
,('Cystic, mucinous and serous neoplasms',NULL,NULL,84400,'Cystadenoma, NOS','Cystad����nome',1,'WHO')
,('Cystic, mucinous and serous neoplasms',NULL,NULL,84403,'Cystadenocarcinoma, NOS','Cystad����nocarcinome',1,'WHO')
,('Cystic, mucinous and serous neoplasms',NULL,NULL,84410,'Serous cystadenoma, NOS','Cystad����nome s����reux',1,'WHO')
,('Cystic, mucinous and serous neoplasms',NULL,NULL,84413,'Serous cystadenocarcinoma, NOS','Cystad����nocarcinome s����reux',1,'WHO')
,('Cystic, mucinous and serous neoplasms',NULL,NULL,84421,'Serous cystadenoma, borderline malignancy','Cystad̩nome s̩reux, �� la limite de la malignit̩',1,'WHO')
,('Cystic, mucinous and serous neoplasms',NULL,NULL,84430,'Clear cell cystadenoma','Cystad����nome ���� cellules claires',1,'WHO')
,('Cystic, mucinous and serous neoplasms',NULL,NULL,84441,'Clear cell cystic tumor of borderline malignancy','Tumeur kystique ���� cellules claires ���� la limite de la malignit����',1,'WHO')
,('Cystic, mucinous and serous neoplasms',NULL,NULL,84500,'Papillary cystadenoma, NOS','Cystad����nome papillaire',1,'WHO')
,('Cystic, mucinous and serous neoplasms',NULL,NULL,84503,'Papillary cystadenocarcinoma, NOS','Cystad����nocarcinome papillaire',1,'WHO')
,('Cystic, mucinous and serous neoplasms',NULL,NULL,84511,'Papillary cystadenoma, borderline malignancy','Cystad����nome papillaire ���� la limite de la malignit����',1,'WHO')
,('Cystic, mucinous and serous neoplasms',NULL,NULL,84521,'Solid pseudopapillary tumor','Tumeur pseudopapillaire solide',1,'WHO')
,('Cystic, mucinous and serous neoplasms',NULL,NULL,84523,'Solid pseudopapillary carcinoma','Carcinome pseudopapillaire solide',1,'WHO')
,('Cystic, mucinous and serous neoplasms',NULL,NULL,84530,'Intraductal papillary-mucinous adenoma','Ad����nome intracanalaire mucineux et papillaire',1,'WHO')
,('Cystic, mucinous and serous neoplasms',NULL,NULL,84531,'Intraductal papillary-mucinous tumor with moderate dysplasia','Tumeur intracanalaire mucineuse et papillaire avec dysplasie mod����r����e',1,'WHO')
,('Cystic, mucinous and serous neoplasms',NULL,NULL,84532,'Intraductal papillary-mucinous carcinoma, non-invasive','Carcinome intracanalaire mucineux et papillaire non invasif',1,'WHO')
,('Cystic, mucinous and serous neoplasms',NULL,NULL,84533,'Intraductal papillary-mucinous carcinoma, invasive','Carcinome intracanalaire mucineux et papillaire invasif',1,'WHO')
,('Cystic, mucinous and serous neoplasms',NULL,NULL,84540,'Cystic tumor of atrio-ventricular node','Tumeur kystique du n�ɉ��ud auriculo-ventriculaire',1,'WHO')
,('Cystic, mucinous and serous neoplasms',NULL,NULL,84600,'Papillary serous cystadenoma, NOS','Cystad����nome s����reux papillaire',1,'WHO')
,('Cystic, mucinous and serous neoplasms',NULL,NULL,84603,'Papillary serous cystadenocarcinoma','Cystad̩nocarcinome papillaire s̩reux',1,'WHO')
,('Cystic, mucinous and serous neoplasms',NULL,NULL,84610,'Serous surface papilloma','Papillome s̩reux de surface',1,'WHO')
,('Cystic, mucinous and serous neoplasms',NULL,NULL,84613,'Serous surface papillary carcinoma','Carcinome papillaire s̩reux de surface',1,'WHO')
,('Cystic, mucinous and serous neoplasms',NULL,NULL,84621,'Serous papillary cystic tumor of borderline malignancy','Tumeur kystique s����reuse papillaire ���� la limite de la malignit����',1,'WHO')
,('Cystic, mucinous and serous neoplasms',NULL,NULL,84631,'Serous surface papillary tumor of borderline malignancy','Tumeur s����reuse papillaire de surface ���� la limite de la malignit����',1,'WHO')
,('Cystic, mucinous and serous neoplasms',NULL,NULL,84700,'Mucinous cystadenoma, NOS','Cystad����nome mucineux',1,'WHO')
,('Cystic, mucinous and serous neoplasms',NULL,NULL,84701,'Mucinous cystic tumor with moderate dysplasia','Tumeur kystique mucineuse avec dysplasie mod����r����e',1,'WHO')
,('Cystic, mucinous and serous neoplasms',NULL,NULL,84702,'Mucinous cystadenocarcinoma, non-invasive','Cystad����nocarcinome mucineux non invasif',1,'WHO')
,('Cystic, mucinous and serous neoplasms',NULL,NULL,84703,'Mucinous cystadenocarcinoma, NOS','Cystad����nocarcinome mucineux',1,'WHO')
,('Cystic, mucinous and serous neoplasms',NULL,NULL,84710,'Papillary mucinous cystadenoma, NOS','Cystad����nome papillaire mucineux',1,'WHO')
,('Cystic, mucinous and serous neoplasms',NULL,NULL,84713,'Papillary mucinous cystadenocarcinoma','Cystad̩nocarcinome papillaire mucineux',1,'WHO')
,('Cystic, mucinous and serous neoplasms',NULL,NULL,84721,'Mucinous cystic tumor of borderline malignancy','Tumeur kystique mucineuse ���� la limite de la malignit����',1,'WHO')
,('Cystic, mucinous and serous neoplasms',NULL,NULL,84731,'Papillary mucinous cystadenoma, borderline malignancy','Cystad̩nome papillaire mucineux, �� faible potentiel malin',1,'WHO')
,('Cystic, mucinous and serous neoplasms',NULL,NULL,84800,'Mucinous adenoma','Ad̩nome mucineux',1,'WHO')
,('Cystic, mucinous and serous neoplasms',NULL,NULL,84803,'Mucinous adenocarcinoma','Ad̩nocarcinome mucineux',1,'WHO')
,('Cystic, mucinous and serous neoplasms',NULL,NULL,84806,'Pseudomyxoma peritonei','Pseudomyxome du p����ritoine',1,'WHO')
,('Cystic, mucinous and serous neoplasms',NULL,NULL,84813,'Mucin-producing adenocarcinoma','Ad̩nocarcinome mucos̩cr̩tant',1,'WHO')
,('Cystic, mucinous and serous neoplasms',NULL,NULL,84823,'Mucinous adenocarcinoma, endocervical type','Ad����nocarcinome mucineux de type endocervical',1,'WHO')
,('Cystic, mucinous and serous neoplasms',NULL,NULL,84903,'Signet ring cell carcinoma','Carcinome �� cellules en bague �� chaton',1,'WHO')
,('Cystic, mucinous and serous neoplasms',NULL,NULL,84906,'Metastatic signet ring cell carcinoma','Carcinome �� cellules en bague �� chaton, m̩tastatique',1,'WHO')
,('Ductal and lobular neoplasms',NULL,NULL,85002,'Intraductal carcinoma, noninfiltrating, NOS','Carcinome intracanalaire non infiltrant',1,'WHO')
,('Ductal and lobular neoplasms',NULL,NULL,85003,'Infiltrating duct carcinoma, NOS','Ad����nocarcinome canalaire infiltrant',1,'WHO')
,('Ductal and lobular neoplasms',NULL,NULL,85012,'Comedocarcinoma, noninfiltrating','Com̩docarcinome, non infiltrant',1,'WHO')
,('Ductal and lobular neoplasms',NULL,NULL,85013,'Comedocarcinoma, NOS','Com����docarcinome',1,'WHO')
,('Ductal and lobular neoplasms',NULL,NULL,85023,'Secretory carcinoma of breast','Carcinome juv����nile du sein',1,'WHO')
,('Ductal and lobular neoplasms',NULL,NULL,85030,'Intraductal papilloma','Papillome intracanalaire',1,'WHO')
,('Ductal and lobular neoplasms',NULL,NULL,85032,'Noninfiltrating intraductal papillary adenocarcinoma','Ad̩nocarcinome intracanalaire, non infiltrant, papillaire',1,'WHO')
,('Ductal and lobular neoplasms',NULL,NULL,85033,'Intraductal papillary adenocarcinoma with invasion','Ad̩nocarcinome intracanalaire, papillaire, invasif',1,'WHO')
,('Ductal and lobular neoplasms',NULL,NULL,85040,'Intracystic papillary adenoma','Ad̩nome intrakystique papillaire',1,'WHO')
,('Ductal and lobular neoplasms',NULL,NULL,85042,'Noninfiltrating intracystic carcinoma','Carcinome intrakystique non infiltrant',1,'WHO')
,('Ductal and lobular neoplasms',NULL,NULL,85043,'Intracystic carcinoma, NOS','Carcinome intrakystique',1,'WHO')
,('Ductal and lobular neoplasms',NULL,NULL,85050,'Intraductal papillomatosis, NOS','Papillomatose intracanalaire',1,'WHO')
,('Ductal and lobular neoplasms',NULL,NULL,85060,'Adenoma of nipple','Ad̩nome du mamelon',1,'WHO')
,('Ductal and lobular neoplasms',NULL,NULL,85072,'Intraductal micropapillary carcinoma','Carcinome intracanalaire micropapillaire',1,'WHO')
,('Ductal and lobular neoplasms',NULL,NULL,85083,'Cystic hypersecretory carcinoma','Carcinome hypers����cr����toire kystique',1,'WHO')
,('Ductal and lobular neoplasms',NULL,NULL,85103,'Medullary carcinoma, NOS','Carcinome m����dullaire',1,'WHO')
,('Ductal and lobular neoplasms',NULL,NULL,85123,'Medullary carcinoma with lymphoid stroma','Carcinome m����dullaire ���� stroma lympho����de',1,'WHO')
,('Ductal and lobular neoplasms',NULL,NULL,85133,'Atypical medullary carcinoma','Carcinome m����dullaire atypique',1,'WHO')
,('Ductal and lobular neoplasms',NULL,NULL,85143,'Duct carcinoma, desmoplastic type','Carcinome canalaire de type desmoplasique',1,'WHO')
,('Ductal and lobular neoplasms',NULL,NULL,85202,'Lobular carcinoma in situ, NOS','Carcinome lobulaire in situ',1,'WHO')
,('Ductal and lobular neoplasms',NULL,NULL,85203,'Lobular carcinoma, NOS','Carcinome lobulaire',1,'WHO')
,('Lipomatous neoplasms',NULL,NULL,88510,'Fibrolipoma','Fibrolipome',1,'WHO')
,('Lipomatous neoplasms',NULL,NULL,88513,'Liposarcoma, well differentiated','Liposarcome bien diff̩renci̩',1,'WHO')
,('Lipomatous neoplasms',NULL,NULL,88520,'Fibromyxolipoma','Fibromyxolipome',1,'WHO')
,('Lipomatous neoplasms',NULL,NULL,88523,'Myxoid liposarcoma','Liposarcome myxo��de',1,'WHO')
,('Lipomatous neoplasms',NULL,NULL,88533,'Round cell liposarcoma','Liposarcome �� cellules rondes',1,'WHO')
,('Lipomatous neoplasms',NULL,NULL,88540,'Pleomorphic lipoma','Lipome polymorphe',1,'WHO')
,('Lipomatous neoplasms',NULL,NULL,88543,'Pleomorphic liposarcoma','Liposarcome polymorphe',1,'WHO')
,('Lipomatous neoplasms',NULL,NULL,88553,'Mixed liposarcoma','Liposarcome �� cellularit̩ mixte',1,'WHO')
,('Lipomatous neoplasms',NULL,NULL,88560,'Intramuscular lipoma','Lipome intramusculaire',1,'WHO')
,('Lipomatous neoplasms',NULL,NULL,88570,'Spindle cell lipoma','Lipome �� cellules fusiformes',1,'WHO')
,('Lipomatous neoplasms',NULL,NULL,88573,'Fibroblastic liposarcoma','Liposarcome fibroblastique',1,'WHO')
,('Lipomatous neoplasms',NULL,NULL,88583,'Dedifferentiated liposarcoma','Liposarcome d̩diff̩renci̩',1,'WHO')
,('Lipomatous neoplasms',NULL,NULL,88600,'Angiomyolipoma','Angiomyolipome',1,'WHO')
,('Lipomatous neoplasms',NULL,NULL,88610,'Angiolipoma, NOS','Angiolipome',1,'WHO')
,('Lipomatous neoplasms',NULL,NULL,88620,'Chondroid lipoma','Lipome chondro����de',1,'WHO')
,('Lipomatous neoplasms',NULL,NULL,88700,'Myelolipoma','My̩lolipome',1,'WHO')
,('Lipomatous neoplasms',NULL,NULL,88800,'Hibernoma','Hibernome',1,'WHO')
,('Lipomatous neoplasms',NULL,NULL,88810,'Lipoblastomatosis','Lipoblastomatose',1,'WHO')
,('Myomatous neoplasms',NULL,NULL,88900,'Leiomyoma, NOS','L����iomyome',1,'WHO')
,('Myomatous neoplasms',NULL,NULL,88901,'Leiomyomatosis, NOS','L����iomyomatose',1,'WHO')
,('Myomatous neoplasms',NULL,NULL,88903,'Leiomyosarcoma, NOS','L����iomyosarcome',1,'WHO')
,('Myomatous neoplasms',NULL,NULL,88910,'Epithelioid leiomyoma','L̩iomyome ̩pith̩lio��de',1,'WHO')
,('Myomatous neoplasms',NULL,NULL,88913,'Epithelioid leiomyosarcoma','L̩iomyosarcome ̩pith̩lio��de',1,'WHO')
,('Myomatous neoplasms',NULL,NULL,88920,'Cellular leiomyoma','L̩iomyome cellulaire',1,'WHO')
,('Myomatous neoplasms',NULL,NULL,88930,'Bizarre leiomyoma','L̩iomyome bizarre',1,'WHO')
,('Myomatous neoplasms',NULL,NULL,88940,'Angiomyoma','Angiomyome',1,'WHO')
,('Myomatous neoplasms',NULL,NULL,88943,'Angiomyosarcoma','Angiomyosarcome',1,'WHO')
,('Myomatous neoplasms',NULL,NULL,88950,'Myoma','Myome',1,'WHO')
,('Myomatous neoplasms',NULL,NULL,88953,'Myosarcoma','Myosarcome',1,'WHO')
,('Myomatous neoplasms',NULL,NULL,88963,'Myxoid leiomyosarcoma','L̩iomyosarcome myxo��de',1,'WHO')
,('Myomatous neoplasms',NULL,NULL,88971,'Smooth muscle tumor of uncertain malignant potential','Tumeur des muscles lisses ���� potentiel malin incertain',1,'WHO')
,('Myomatous neoplasms',NULL,NULL,88981,'Metastasizing leiomyoma','L����iomyome m����tastasant',1,'WHO')
,('Myomatous neoplasms',NULL,NULL,89000,'Rhabdomyoma, NOS','Rhabdomyome',1,'WHO')
,('Myomatous neoplasms',NULL,NULL,89003,'Rhabdomyosarcoma, NOS','Rhabdomyosarcome',1,'WHO')
,('Myomatous neoplasms',NULL,NULL,89013,'Pleomorphic rhabdomyosarcoma, adult type','Rhabdomyosarcome pl����omorphe de type adulte',1,'WHO')
,('Myomatous neoplasms',NULL,NULL,89023,'Mixed type rhabdomyosarcoma','Rhabdomyosarcome �� cellularit̩ mixte',1,'WHO')
,('Myomatous neoplasms',NULL,NULL,89030,'Fetal rhabdomyoma','Rhabdomyome foetal',1,'WHO')
,('Myomatous neoplasms',NULL,NULL,89040,'Adult rhabdomyoma','Rhabdomyome adulte',1,'WHO')
,('Myomatous neoplasms',NULL,NULL,89050,'Genital rhabdomyoma','Rhabdomyome g����nital',1,'WHO')
,('Myomatous neoplasms',NULL,NULL,89103,'Embryonal rhabdomyosarcoma, NOS','Embryonal rhabdomyosarcoma, NOS',0,'WHO')
,('Myomatous neoplasms',NULL,NULL,89123,'Spindle cell rhabdomyosarcoma','Spindle cell rhabdomyosarcoma',0,'WHO')
,('Myomatous neoplasms',NULL,NULL,89203,'Alveolar rhabdomyosarcoma','Rhabdomyosarcome alv̩olaire',1,'WHO')
,('Myomatous neoplasms',NULL,NULL,89213,'Rhabdomyosarcoma with ganglionic differentiation','Rhabdomyosarcoma with ganglionic differentiation',0,'WHO')
,('Complex mixed and stromal neoplasms',NULL,NULL,89300,'Endometrial stromal nodule','Nodule du chorion cytog̬ne',1,'WHO')
,('Complex mixed and stromal neoplasms',NULL,NULL,89303,'Endometrial stromal sarcoma, NOS','Sarcome du stroma endom����trial',1,'WHO')
,('Complex mixed and stromal neoplasms',NULL,NULL,89313,'Endometrial stromal sarcoma, low grade','Endometrial stromal sarcoma, low grade',0,'WHO')
,('Complex mixed and stromal neoplasms',NULL,NULL,89320,'Adenomyoma','Ad̩nomyome',1,'WHO')
,('Complex mixed and stromal neoplasms',NULL,NULL,89333,'Adenosarcoma','Ad̩nosarcome',1,'WHO')
,('Complex mixed and stromal neoplasms',NULL,NULL,89343,'Carcinofibroma','Carcinofibrome',1,'WHO')
,('Complex mixed and stromal neoplasms',NULL,NULL,89350,'Stromal tumor, benign','Tumeur stromale b����nigne',1,'WHO')
,('Complex mixed and stromal neoplasms',NULL,NULL,89351,'Stromal tumor, NOS','Tumeur stromale',1,'WHO')
,('Complex mixed and stromal neoplasms',NULL,NULL,89353,'Stromal sarcoma, NOS','Sarcome stromal',1,'WHO')
,('Odontogenic tumors',NULL,NULL,93000,'Adenomatoid odontogenic tumor','Adenomatoid odontogenic tumor',0,'WHO')
,('Odontogenic tumors',NULL,NULL,93010,'Calcifying odontogenic cyst','Kyste odontog̩nique calcifiant',1,'WHO')
,('Odontogenic tumors',NULL,NULL,93020,'Odontogenic ghost cell tumor','Odontogenic ghost cell tumor',0,'WHO')
,('Odontogenic tumors',NULL,NULL,93100,'Ameloblastoma, NOS','Ameloblastoma, NOS',0,'WHO')
,('Odontogenic tumors',NULL,NULL,93103,'Ameloblastoma, malignant','Am̩loblastome malin',1,'WHO')
,('Odontogenic tumors',NULL,NULL,93110,'Odontoameloblastoma','Odonto-am̩loblastome',1,'WHO')
,('Odontogenic tumors',NULL,NULL,93120,'Squamous odontogenic tumor','Squamous odontogenic tumor',0,'WHO')
,('Odontogenic tumors',NULL,NULL,93200,'Odontogenic myxoma','Myxome odontog̬ne',1,'WHO')
,('Odontogenic tumors',NULL,NULL,93210,'Central odontogenic fibroma','Fibrome odontog̬ne central',1,'WHO')
,('Odontogenic tumors',NULL,NULL,93220,'Peripheral odontogenic fibroma','Fibrome odontog̬ne p̩riph̩rique',1,'WHO')
,('Odontogenic tumors',NULL,NULL,93300,'Ameloblastic fibroma','Fibrome am̩loblastique',1,'WHO')
,('Odontogenic tumors',NULL,NULL,93303,'Ameloblastic fibrosarcoma','Fibrosarcome am̩loblastique',1,'WHO')
,('Odontogenic tumors',NULL,NULL,93400,'Calcifying epithelial odontogenic tumor','Calcifying epithelial odontogenic tumor',0,'WHO')
,('Odontogenic tumors',NULL,NULL,93411,'Clear cell odontogenic tumor','Clear cell odontogenic tumor',0,'WHO')
,('Odontogenic tumors',NULL,NULL,93423,'Odontogenic carcinosarcoma','Odontogenic carcinosarcoma',0,'WHO')
,('Miscellaneous tumors',NULL,NULL,93501,'Craniopharyngioma','Craniopharyngiome',1,'WHO')
,('Miscellaneous tumors',NULL,NULL,93511,'Craniopharyngioma, adamantinomatous','Craniopharyngioma, adamantinomatous',0,'WHO')
,('Miscellaneous tumors',NULL,NULL,93521,'Craniopharyngioma, papillary','Craniopharyngioma, papillary',0,'WHO')
,('Miscellaneous tumors',NULL,NULL,93601,'Pinealoma','Pin̩alome',1,'WHO')
,('Miscellaneous tumors',NULL,NULL,93611,'Pineocytoma','Pin̩ocytome',1,'WHO')
,('Miscellaneous tumors',NULL,NULL,93623,'Pineoblastoma','Pin̩oblastome',1,'WHO')
,('Miscellaneous tumors',NULL,NULL,93630,'Melanotic neuroectodermal tumor','Melanotic neuroectodermal tumor',0,'WHO')
,('Miscellaneous tumors',NULL,NULL,93643,'Peripheral neuroectodermal tumor','Peripheral neuroectodermal tumor',0,'WHO')
,('Miscellaneous tumors',NULL,NULL,93653,'Askin tumor','Askin tumor',0,'WHO')
,('Miscellaneous tumors',NULL,NULL,93703,'Chordoma, NOS','Chordoma, NOS',0,'WHO')
,('Miscellaneous tumors',NULL,NULL,93713,'Chondroid chordoma','Chondroid chordoma',0,'WHO')
,('Miscellaneous tumors',NULL,NULL,93723,'Dedifferentiated chordoma','Dedifferentiated chordoma',0,'WHO')
,('Miscellaneous tumors',NULL,NULL,93730,'Parachordoma','Parachordoma',0,'WHO')
,('Gliomas',NULL,NULL,93803,'Glioma, malignant','Gliome malin',1,'WHO')
,('Gliomas',NULL,NULL,93813,'Gliomatosis cerebri','Gliomatose du cerveau',1,'WHO')
,('Gliomas',NULL,NULL,93823,'Mixed glioma','Gliome mixte',1,'WHO')
,('Gliomas',NULL,NULL,93831,'Subependymoma','Subependymoma',0,'WHO')
,('Gliomas',NULL,NULL,93841,'Subependymal giant cell astrocytoma','Astrocytome sous-̩pendymaire �� cellules g̩antes',1,'WHO')
,('Gliomas',NULL,NULL,93900,'Choroid plexus papilloma, NOS','Choroid plexus papilloma, NOS',0,'WHO')
,('Gliomas',NULL,NULL,93901,'Atypical choroid plexus papilloma','Atypical choroid plexus papilloma',0,'WHO')
,('Gliomas',NULL,NULL,93903,'Choroid plexus carcinoma','Choroid plexus carcinoma',0,'WHO')
,('Gliomas',NULL,NULL,93913,'Ependymoma, NOS','Ependymoma, NOS',0,'WHO')
,('Ductal and lobular neoplasms',NULL,NULL,85213,'Infiltrating ductular carcinoma','Carcinome canaliculaire, infiltrant',1,'WHO')
,('Ductal and lobular neoplasms',NULL,NULL,85222,'Intraductal carcinoma and lobular carcinoma in situ','Carcinome intracanalaire et carcinome lobulaire in situ',1,'WHO')
,('Ductal and lobular neoplasms',NULL,NULL,85223,'Infiltrating duct and lobular carcinoma','Carcinome canalaire infiltrant avec carcinome lobulaire (in situ)',1,'WHO')
,('Ductal and lobular neoplasms',NULL,NULL,85233,'Infiltrating duct mixed with other types of carcinoma','Carcinome canalaire infiltrant avec autres types de carcinomes',1,'WHO')
,('Ductal and lobular neoplasms',NULL,NULL,85243,'Infiltrating lobular mixed with other types of carcinoma','Carcinome lobulaire infiltrant avec autres types de carcinomes',1,'WHO')
,('Ductal and lobular neoplasms',NULL,NULL,85253,'Polymorphous low grade adenocarcinoma','Polymorphous low grade adenocarcinoma',0,'WHO')
,('Ductal and lobular neoplasms',NULL,NULL,85303,'Inflammatory carcinoma','Carcinome inflammatoire',1,'WHO')
,('Ductal and lobular neoplasms',NULL,NULL,85403,'Paget disease, mammary','Paget disease, mammary',0,'WHO')
,('Ductal and lobular neoplasms',NULL,NULL,85413,'Paget disease and infiltrating duct carcinoma of breast','Paget disease and infiltrating duct carcinoma of breast',0,'WHO')
,('Ductal and lobular neoplasms',NULL,NULL,85423,'Paget disease, extramammary','Paget disease, extramammary',0,'WHO')
,('Ductal and lobular neoplasms',NULL,NULL,85433,'Paget disease and intraductal carcinoma of breast','Paget disease and intraductal carcinoma of breast',0,'WHO')
,('Acinar cell neoplasms',NULL,NULL,85500,'Acinar cell adenoma','Ad̩nome �� cellules acineuses',1,'WHO')
,('Acinar cell neoplasms',NULL,NULL,85501,'Acinar cell tumor','Acinar cell tumor',0,'WHO')
,('Acinar cell neoplasms',NULL,NULL,85503,'Acinar cell carcinoma','Carcinome �� cellules acineuses',1,'WHO')
,('Acinar cell neoplasms',NULL,NULL,85513,'Acinar cell cystadenocarcinoma','Acinar cell cystadenocarcinoma',0,'WHO')
,('Complex epithelial neoplasms',NULL,NULL,85600,'Mixed squamous cell and glandular papilloma','Mixed squamous cell and glandular papilloma',0,'WHO')
,('Complex epithelial neoplasms',NULL,NULL,85603,'Adenosquamous carcinoma','Carcinome ad̩nosquameux',1,'WHO')
,('Complex epithelial neoplasms',NULL,NULL,85610,'Adenolymphoma','Ad̩nolymphome',1,'WHO')
,('Complex epithelial neoplasms',NULL,NULL,85623,'Epithelial-myoepithelial carcinoma','Carcinome ̩pith̩lial et myo̩pith̩lial',1,'WHO')
,('Complex epithelial neoplasms',NULL,NULL,85703,'Adenocarcinoma with squamous metaplasia','Ad̩no-acanthome',1,'WHO')
,('Complex epithelial neoplasms',NULL,NULL,85713,'Adenocarcinoma with cartilaginous and osseous metaplasia','Adenocarcinoma with cartilaginous and osseous metaplasia',0,'WHO')
,('Complex epithelial neoplasms',NULL,NULL,85723,'Adenocarcinoma with spindle cell metaplasia','Ad̩nocarcinome avec m̩taplasie fusocellulaire',1,'WHO')
,('Complex epithelial neoplasms',NULL,NULL,85733,'Adenocarcinoma with apocrine metaplasia','Ad̩nocarcinome avec m̩taplasie apocrine',1,'WHO')
,('Complex epithelial neoplasms',NULL,NULL,85743,'Adenocarcinoma with neuroendocrine differentiation','Adenocarcinoma with neuroendocrine differentiation',0,'WHO')
,('Complex epithelial neoplasms',NULL,NULL,85753,'Metaplastic carcinoma, NOS','Carcinome m����taplasique',1,'WHO')
,('Complex epithelial neoplasms',NULL,NULL,85763,'Hepatoid adenocarcinoma','Hepatoid adenocarcinoma',0,'WHO')
,('Thymic epithelial neoplasms',NULL,NULL,85800,'Thymoma, benign','Thymome b̩nin',1,'WHO')
,('Thymic epithelial neoplasms',NULL,NULL,85801,'Thymoma, NOS','Thymoma, NOS',0,'WHO')
,('Thymic epithelial neoplasms',NULL,NULL,85803,'Thymoma, malignant, NOS','Thymoma, malignant, NOS',0,'WHO')
,('Thymic epithelial neoplasms',NULL,NULL,85811,'Thymoma, type A, NOS','Thymoma, type A, NOS',0,'WHO')
,('Thymic epithelial neoplasms',NULL,NULL,85813,'Thymoma, type A, malignant','Thymoma, type A, malignant',0,'WHO')
,('Thymic epithelial neoplasms',NULL,NULL,85821,'Thymoma, type AB, NOS','Thymoma, type AB, NOS',0,'WHO')
,('Thymic epithelial neoplasms',NULL,NULL,85823,'Thymoma, type AB, malignant','Thymoma, type AB, malignant',0,'WHO')
,('Thymic epithelial neoplasms',NULL,NULL,85831,'Thymoma, type B1, NOS','Thymoma, type B1, NOS',0,'WHO')
,('Thymic epithelial neoplasms',NULL,NULL,85833,'Thymoma, type B1, malignant','Thymoma, type B1, malignant',0,'WHO')
,('Thymic epithelial neoplasms',NULL,NULL,85841,'Thymoma, type B2, NOS','Thymoma, type B2, NOS',0,'WHO')
,('Thymic epithelial neoplasms',NULL,NULL,85843,'Thymoma, type B2, malignant','Thymoma, type B2, malignant',0,'WHO')
,('Thymic epithelial neoplasms',NULL,NULL,85851,'Thymoma, type B3, NOS','Thymoma, type B3, NOS',0,'WHO')
,('Thymic epithelial neoplasms',NULL,NULL,85853,'Thymoma, type B3, malignant','Thymoma, type B3, malignant',0,'WHO')
,('Thymic epithelial neoplasms',NULL,NULL,85863,'Thymic carcinoma, NOS','Thymic carcinoma, NOS',0,'WHO')
,('Thymic epithelial neoplasms',NULL,NULL,85870,'Ectopic hamartomatous thymoma','Ectopic hamartomatous thymoma',0,'WHO')
,('Thymic epithelial neoplasms',NULL,NULL,85883,'Spindle epithelial tumor with thymus-like element','Spindle epithelial tumor with thymus-like element',0,'WHO')
,('Thymic epithelial neoplasms',NULL,NULL,85893,'Carcinoma showing thymus-like element','Carcinoma showing thymus-like element',0,'WHO')
,('Specialized gonadal neoplasms',NULL,NULL,85901,'Sex cord-gonadal stromal tumor, NOS','Tumeur des cordons sexuels et du stroma gonadique',1,'WHO')
,('Specialized gonadal neoplasms',NULL,NULL,85911,'Sex cord-gonadal stromal tumor, incompletely differentiated','Tumeur des cordons sexuels et du stroma gonadique partiellement diff����renci����e',1,'WHO')
,('Specialized gonadal neoplasms',NULL,NULL,85921,'Sex cord-gonadal stromal tumor, mixed forms','Tumeur des cordons sexuels et du stroma gonadique, forme mixtes',1,'WHO')
,('Specialized gonadal neoplasms',NULL,NULL,85931,'Stromal tumor with minor sex cord elements','Tumeur du stroma gonadique avec peu d''����l����ments des cordons sexuels',1,'WHO')
,('Specialized gonadal neoplasms',NULL,NULL,86000,'Thecoma, NOS','Th����come',1,'WHO')
,('Specialized gonadal neoplasms',NULL,NULL,86003,'Thecoma, malignant','Th̩come malin',1,'WHO')
,('Specialized gonadal neoplasms',NULL,NULL,86010,'Thecoma, luteinized','Th̩come lut̩inis̩',1,'WHO')
,('Specialized gonadal neoplasms',NULL,NULL,86020,'Sclerosing stromal tumor','Tumeur stromale scl����rosante',1,'WHO')
,('Specialized gonadal neoplasms',NULL,NULL,86100,'Luteoma, NOS','Lut����ome',1,'WHO')
,('Specialized gonadal neoplasms',NULL,NULL,86201,'Granulosa cell tumor, adult type','Tumeur de la granulosa de type adulte',1,'WHO')
,('Specialized gonadal neoplasms',NULL,NULL,86203,'Granulosa cell tumor, malignant','Tumeur maligne de la granulosa',1,'WHO')
,('Specialized gonadal neoplasms',NULL,NULL,86211,'Granulosa cell-theca cell tumor','Tumeur de la granulosa et de la th����que',1,'WHO')
,('Specialized gonadal neoplasms',NULL,NULL,86221,'Granulosa cell tumor, juvenile','Tumeur de la granulosa juv����nile',1,'WHO')
,('Specialized gonadal neoplasms',NULL,NULL,86231,'Sex cord tumor with annular tubules','Tumeur des cordons sexuels avec tubules annulaires',1,'WHO')
,('Specialized gonadal neoplasms',NULL,NULL,86300,'Androblastoma, benign','Androblastome b̩nin',1,'WHO')
,('Specialized gonadal neoplasms',NULL,NULL,86301,'Androblastoma, NOS','Androblastome',1,'WHO')
,('Specialized gonadal neoplasms',NULL,NULL,86303,'Androblastoma, malignant','Androblastome malin',1,'WHO')
,('Specialized gonadal neoplasms',NULL,NULL,86310,'Sertoli-Leydig cell tumor, well differentiated','Tumeur ���� cellules de Sertoli-Leydig bien diff����renci����e',1,'WHO')
,('Specialized gonadal neoplasms',NULL,NULL,86311,'Sertoli-Leydig cell tumor of intermediate differentiation','Tumeur ���� cellules de Sertoli-Leydig de diff����renciation interm����diaire',1,'WHO')
,('Specialized gonadal neoplasms',NULL,NULL,86313,'Sertoli-Leydig cell tumor, poorly differentiated','Tumeur ���� cellules de Sertoli-Leydig peu diff����renci����e',1,'WHO')
,('Specialized gonadal neoplasms',NULL,NULL,86321,'Gynandroblastoma','Gynandroblastome',1,'WHO')
,('Specialized gonadal neoplasms',NULL,NULL,86331,'Sertoli-Leydig cell tumor, retiform','Tumeur r����tiforme ���� cellules de Sertoli-Leydig',1,'WHO')
,('Specialized gonadal neoplasms',NULL,NULL,86341,'Sertoli-Leydig cell tumor, intermediate differentiation, with heterologous elements','Tumeur ���� cellules de Sertoli-Leydig, diff. inter. avec ����l����ments h����t����rologues',1,'WHO')
,('Specialized gonadal neoplasms',NULL,NULL,86343,'Sertoli-Leydig cell tumor, poorly differentiated, with heterologous elements','Tumeur ���� cellules de Sertoli-Leydig, peu diff. avec ����l����ments h����t����rologues',1,'WHO')
,('Specialized gonadal neoplasms',NULL,NULL,86401,'Sertoli cell tumor, NOS','Tumeur ���� cellules de Sertoli',1,'WHO')
,('Specialized gonadal neoplasms',NULL,NULL,86403,'Sertoli cell carcinoma','Carcinome �� cellules de Sertoli',1,'WHO')
,('Specialized gonadal neoplasms',NULL,NULL,86410,'Sertoli cell tumor with lipid storage','Tumeur ���� cellules de Sertoli lipidiques',1,'WHO')
,('Specialized gonadal neoplasms',NULL,NULL,86421,'Large cell calcifying Sertoli cell tumor','Androblastome calcifiant ���� grandes cellules',1,'WHO')
,('Specialized gonadal neoplasms',NULL,NULL,86500,'Leydig cell tumor, benign','Tumeur b����nigne ���� cellules de Leydig',1,'WHO')
,('Specialized gonadal neoplasms',NULL,NULL,86501,'Leydig cell tumor, NOS','Tumeur ���� cellules de Leydig',1,'WHO')
,('Specialized gonadal neoplasms',NULL,NULL,86503,'Leydig cell tumor, malignant','Tumeur maligne ���� cellules de Leydig',1,'WHO')
,('Specialized gonadal neoplasms',NULL,NULL,86600,'Hilus cell tumor','Tumeur ���� cellules du hile',1,'WHO')
,('Specialized gonadal neoplasms',NULL,NULL,86700,'Lipid cell tumor of ovary','Tumeur ���� cellules lipo����diques de l''ovaire',1,'WHO')
,('Specialized gonadal neoplasms',NULL,NULL,86703,'Steroid cell tumor, malignant','Tumeur maligne ���� cellules st����ro����diennes',1,'WHO')
,('Specialized gonadal neoplasms',NULL,NULL,86710,'Adrenal rest tumor','Tumeur des vestiges surr����naliens',1,'WHO')
,('Paragangliomas and glomus tumors',NULL,NULL,86800,'Paraganglioma, benign','Paragangliome b����nin',1,'WHO')
,('Paragangliomas and glomus tumors',NULL,NULL,86801,'Paraganglioma, NOS','Paragangliome',1,'WHO')
,('Paragangliomas and glomus tumors',NULL,NULL,86803,'Paraganglioma, malignant','Paragangliome malin',1,'WHO')
,('Paragangliomas and glomus tumors',NULL,NULL,86811,'Sympathetic paraganglioma','Paragangliome sympathique',1,'WHO')
,('Paragangliomas and glomus tumors',NULL,NULL,86821,'Parasympathetic paraganglioma','Paragangliome parasympathique',1,'WHO')
,('Paragangliomas and glomus tumors',NULL,NULL,86830,'Gangliocytic paraganglioma','Paragangliome gangliocytaire',1,'WHO')
,('Paragangliomas and glomus tumors',NULL,NULL,86901,'Glomus jugulare tumor, NOS','Glomus jugulare tumor, NOS',0,'WHO')
,('Paragangliomas and glomus tumors',NULL,NULL,86911,'Aortic body tumor','Aortic body tumor',0,'WHO')
,('Paragangliomas and glomus tumors',NULL,NULL,86921,'Carotid body tumor','Carotid body tumor',0,'WHO')
,('Paragangliomas and glomus tumors',NULL,NULL,86931,'Extra-adrenal paraganglioma, NOS','Extra-adrenal paraganglioma, NOS',0,'WHO')
,('Paragangliomas and glomus tumors',NULL,NULL,86933,'Extra-adrenal paraganglioma, malignant','Paragangliome extrasurr̩nalien malin',1,'WHO')
,('Paragangliomas and glomus tumors',NULL,NULL,87000,'Pheochromocytoma, NOS','Pheochromocytoma, NOS',0,'WHO')
,('Paragangliomas and glomus tumors',NULL,NULL,87003,'Pheochromocytoma, malignant','Pheochromocytoma, malignant',0,'WHO')
,('Paragangliomas and glomus tumors',NULL,NULL,87103,'Glomangiosarcoma','Glomangiosarcome',1,'WHO')
,('Paragangliomas and glomus tumors',NULL,NULL,87110,'Glomus tumor, NOS','Glomus tumor, NOS',0,'WHO')
,('Paragangliomas and glomus tumors',NULL,NULL,87113,'Glomus tumor, malignant','Glomus tumor, malignant',0,'WHO')
,('Paragangliomas and glomus tumors',NULL,NULL,87120,'Glomangioma','Glomangiome',1,'WHO')
,('Paragangliomas and glomus tumors',NULL,NULL,87130,'Glomangiomyoma','Glomangiomyome',1,'WHO')
,('Nevi and melanomas',NULL,NULL,87200,'Pigmented nevus, NOS','Pigmented nevus, NOS',0,'WHO')
,('Nevi and melanomas',NULL,NULL,87202,'Melanoma in situ','M̩lanome in situ',1,'WHO')
,('Nevi and melanomas',NULL,NULL,87203,'Malignant melanoma, NOS','M����lanome malin',1,'WHO')
,('Nevi and melanomas',NULL,NULL,87213,'Nodular melanoma','M̩lanome nodulaire',1,'WHO')
,('Nevi and melanomas',NULL,NULL,87220,'Balloon cell nevus','Balloon cell nevus',0,'WHO')
,('Nevi and melanomas',NULL,NULL,87223,'Balloon cell melanoma','M̩lanome �� cellules ballonnisantes, ballonnis̩es',1,'WHO')
,('Nevi and melanomas',NULL,NULL,87230,'Halo nevus','Halo nevus',0,'WHO')
,('Nevi and melanomas',NULL,NULL,87233,'Malignant melanoma, regressing','M̩lanome malin en voie de r̩gression',1,'WHO')
,('Nevi and melanomas',NULL,NULL,87250,'Neuronevus','Neuronevus',0,'WHO')
,('Nevi and melanomas',NULL,NULL,87260,'Magnocellular nevus','Magnocellular nevus',0,'WHO')
,('Nevi and melanomas',NULL,NULL,87270,'Dysplastic nevus','Dysplastic nevus',0,'WHO')
,('Nevi and melanomas',NULL,NULL,87280,'Diffuse melanocytosis','Diffuse melanocytosis',0,'WHO')
,('Nevi and melanomas',NULL,NULL,87281,'Meningeal melanocytoma','Meningeal melanocytoma',0,'WHO')
,('Nevi and melanomas',NULL,NULL,87283,'Meningeal melanomatosis','Meningeal melanomatosis',0,'WHO')
,('Nevi and melanomas',NULL,NULL,87300,'Nonpigmented nevus','Nonpigmented nevus',0,'WHO')
,('Nevi and melanomas',NULL,NULL,87303,'Amelanotic melanoma','M̩lanome achromique',1,'WHO')
,('Nevi and melanomas',NULL,NULL,87400,'Junctional nevus, NOS','Junctional nevus, NOS',0,'WHO')
,('Nevi and melanomas',NULL,NULL,87403,'Malignant melanoma in junctional nevus','Malignant melanoma in junctional nevus',0,'WHO')
,('Nevi and melanomas',NULL,NULL,87412,'Precancerous melanosis, NOS','Precancerous melanosis, NOS',0,'WHO')
,('Nevi and melanomas',NULL,NULL,87413,'Malignant melanoma in precancerous melanosis','Malignant melanoma in precancerous melanosis',0,'WHO')
,('Nevi and melanomas',NULL,NULL,87422,'Lentigo maligna','Lentigo maligna',0,'WHO')
,('Nevi and melanomas',NULL,NULL,87423,'Lentigo maligna melanoma','Lentigo maligna melanoma',0,'WHO')
,('Nevi and melanomas',NULL,NULL,87433,'Superficial spreading melanoma','M̩lanome �� extension superficielle',1,'WHO')
,('Nevi and melanomas',NULL,NULL,87443,'Acral lentiginous melanoma, malignant','M̩lanome lentigineux malin des extr̩mit̩s',1,'WHO')
,('Nevi and melanomas',NULL,NULL,87453,'Desmoplastic melanoma, malignant','M̩lanome desmoplasique, malin',1,'WHO')
,('Nevi and melanomas',NULL,NULL,87463,'Mucosal lentiginous melanoma','Mucosal lentiginous melanoma',0,'WHO')
,('Nevi and melanomas',NULL,NULL,87500,'Intradermal nevus','Intradermal nevus',0,'WHO')
,('Nevi and melanomas',NULL,NULL,87600,'Compound nevus','Compound nevus',0,'WHO')
,('Nevi and melanomas',NULL,NULL,87610,'Small congenital nevus','Small congenital nevus',0,'WHO')
,('Nevi and melanomas',NULL,NULL,87611,'Giant pigmented nevus, NOS','Giant pigmented nevus, NOS',0,'WHO')
,('Nevi and melanomas',NULL,NULL,87613,'Malignant melanoma in giant pigmented nevus','Malignant melanoma in giant pigmented nevus',0,'WHO')
,('Nevi and melanomas',NULL,NULL,87621,'Proliferative dermal lesion in congenital nevus','Proliferative dermal lesion in congenital nevus',0,'WHO')
,('Nevi and melanomas',NULL,NULL,87700,'Epithelioid and spindle cell nevus','Epithelioid and spindle cell nevus',0,'WHO')
,('Nevi and melanomas',NULL,NULL,87703,'Mixed epithelioid and spindle cell melanoma','Mixed epithelioid and spindle cell melanoma',0,'WHO')
,('Nevi and melanomas',NULL,NULL,87710,'Epithelioid cell nevus','Epithelioid cell nevus',0,'WHO')
,('Nevi and melanomas',NULL,NULL,87713,'Epithelioid cell melanoma','M̩lanome �� cellules ̩pith̩lio��des',1,'WHO')
,('Nevi and melanomas',NULL,NULL,87720,'Spindle cell nevus, NOS','Spindle cell nevus, NOS',0,'WHO')
,('Nevi and melanomas',NULL,NULL,87723,'Spindle cell melanoma, NOS','Spindle cell melanoma, NOS',0,'WHO')
,('Nevi and melanomas',NULL,NULL,87733,'Spindle cell melanoma, type A','M̩lanome �� cellules fusiformes, type A',1,'WHO')
,('Nevi and melanomas',NULL,NULL,87743,'Spindle cell melanoma, type B','M̩lanome �� cellules fusiformes, type B',1,'WHO')
,('Nevi and melanomas',NULL,NULL,87800,'Blue nevus, NOS','Blue nevus, NOS',0,'WHO')
,('Nevi and melanomas',NULL,NULL,87803,'Blue nevus, malignant','Blue nevus, malignant',0,'WHO')
,('Nevi and melanomas',NULL,NULL,87900,'Cellular blue nevus','Cellular blue nevus',0,'WHO')
,('Soft tissue tumors and sarcomas, NOS',NULL,NULL,88000,'Soft tissue tumor, benign','Soft tissue tumor, benign',0,'WHO')
,('Soft tissue tumors and sarcomas, NOS',NULL,NULL,88003,'Sarcoma, NOS','Sarcome',1,'WHO')
,('Soft tissue tumors and sarcomas, NOS',NULL,NULL,88009,'Sarcomatosis, NOS','Sarcomatose',1,'WHO')
,('Soft tissue tumors and sarcomas, NOS',NULL,NULL,88013,'Spindle cell sarcoma','Sarcome �� cellules fusiformes',1,'WHO')
,('Soft tissue tumors and sarcomas, NOS',NULL,NULL,88023,'Giant cell sarcoma','Sarcome �� cellules g̩antes (�� l''exception de l''os)',1,'WHO')
,('Soft tissue tumors and sarcomas, NOS',NULL,NULL,88033,'Small cell sarcoma','Sarcome �� petites cellules',1,'WHO')
,('Soft tissue tumors and sarcomas, NOS',NULL,NULL,88043,'Epithelioid sarcoma','Sarcome �� cellules ̩pith̩lio��des',1,'WHO')
,('Soft tissue tumors and sarcomas, NOS',NULL,NULL,88053,'Undifferentiated sarcoma','Sarcome indiff����renci����',1,'WHO')
,('Soft tissue tumors and sarcomas, NOS',NULL,NULL,88063,'Desmoplastic small round cell tumor','Tumeur desmoplasique ���� petites cellules rondes',1,'WHO')
,('Fibromatous neoplasms',NULL,NULL,88100,'Fibroma, NOS','Fibrome',1,'WHO')
,('Fibromatous neoplasms',NULL,NULL,88101,'Cellular fibroma','Fibrome cellulaire',1,'WHO')
,('Fibromatous neoplasms',NULL,NULL,88103,'Fibrosarcoma, NOS','Fibrosarcome',1,'WHO')
,('Fibromatous neoplasms',NULL,NULL,88110,'Fibromyxoma','Fibromyxome',1,'WHO')
,('Fibromatous neoplasms',NULL,NULL,88113,'Fibromyxosarcoma','Fibromyxosarcome',1,'WHO')
,('Fibromatous neoplasms',NULL,NULL,88120,'Periosteal fibroma','Fibrome p̩riost̩al',1,'WHO')
,('Fibromatous neoplasms',NULL,NULL,88123,'Periosteal fibrosarcoma','Fibrosarcome p̩riost̩al',1,'WHO')
,('Fibromatous neoplasms',NULL,NULL,88130,'Fascial fibroma','Fibrome apon̩vrotique',1,'WHO')
,('Fibromatous neoplasms',NULL,NULL,88133,'Fascial fibrosarcoma','Fibrosarcome apon̩vrotique',1,'WHO')
,('Fibromatous neoplasms',NULL,NULL,88143,'Infantile fibrosarcoma','Fibrosarcome infantile',1,'WHO')
,('Fibromatous neoplasms',NULL,NULL,88150,'Solitary fibrous tumor','Solitary fibrous tumor',0,'WHO')
,('Fibromatous neoplasms',NULL,NULL,88153,'Solitary fibrous tumor, malignant','Solitary fibrous tumor, malignant',0,'WHO')
,('Fibromatous neoplasms',NULL,NULL,88200,'Elastofibroma','��lastofibrome',1,'WHO')
,('Fibromatous neoplasms',NULL,NULL,88211,'Aggressive fibromatosis','Fibromatose agressive',1,'WHO')
,('Fibromatous neoplasms',NULL,NULL,88221,'Abdominal fibromatosis','Fibromatose abdominale',1,'WHO')
,('Fibromatous neoplasms',NULL,NULL,88230,'Desmoplastic fibroma','Fibrome desmoplasique',1,'WHO')
,('Fibromatous neoplasms',NULL,NULL,88240,'Myofibroma','Myofibrome',1,'WHO')
,('Fibromatous neoplasms',NULL,NULL,88241,'Myofibromatosis','Myofibromatose',1,'WHO')
,('Fibromatous neoplasms',NULL,NULL,88250,'Myofibroblastoma','Myofibroblastome',1,'WHO')
,('Fibromatous neoplasms',NULL,NULL,88251,'Myofibroblastic tumor, NOS','Tumeur myofibroblastique',1,'WHO')
,('Fibromatous neoplasms',NULL,NULL,88260,'Angiomyofibroblastoma','Angiomyofibroblastome',1,'WHO')
,('Fibromatous neoplasms',NULL,NULL,88271,'Myofibroblastic tumor, peribronchial','Tumeur myofibroblastique p����ribronchique',1,'WHO')
,('Fibromatous neoplasms',NULL,NULL,88300,'Benign fibrous histiocytoma','Benign fibrous histiocytoma',0,'WHO')
,('Fibromatous neoplasms',NULL,NULL,88301,'Atypical fibrous histiocytoma','Histiocytome fibreux atypique',1,'WHO')
,('Fibromatous neoplasms',NULL,NULL,88303,'Malignant fibrous histiocytoma','Malignant fibrous histiocytoma',0,'WHO')
,('Fibromatous neoplasms',NULL,NULL,88310,'Histiocytoma, NOS','Histiocytoma, NOS',0,'WHO')
,('Fibromatous neoplasms',NULL,NULL,88320,'Dermatofibroma, NOS','Dermatofibroma, NOS',0,'WHO')
,('Fibromatous neoplasms',NULL,NULL,88323,'Dermatofibrosarcoma, NOS','Dermatofibrosarcoma, NOS',0,'WHO')
,('Fibromatous neoplasms',NULL,NULL,88333,'Pigmented dermatofibrosarcoma protuberans','Dermatofibrosarcome protub̩rant pigment̩',1,'WHO')
,('Fibromatous neoplasms',NULL,NULL,88341,'Giant cell fibroblastoma','Giant cell fibroblastoma',0,'WHO')
,('Fibromatous neoplasms',NULL,NULL,88351,'Plexiform fibrohistiocytic tumor','Plexiform fibrohistiocytic tumor',0,'WHO')
,('Fibromatous neoplasms',NULL,NULL,88361,'Angiomatoid fibrous histiocytoma','Angiomatoid fibrous histiocytoma',0,'WHO')
,('Myxomatous neoplasms',NULL,NULL,88400,'Myxoma, NOS','Myxome',1,'WHO')
,('Myxomatous neoplasms',NULL,NULL,88403,'Myxosarcoma','Myxosarcome',1,'WHO')
,('Myxomatous neoplasms',NULL,NULL,88411,'Angiomyxoma','Angiomyxome',1,'WHO')
,('Myxomatous neoplasms',NULL,NULL,88420,'Ossifying fibromyxoid tumor','Tumeur fibromyxo����de ossifiante',1,'WHO')
,('Lipomatous neoplasms',NULL,NULL,88500,'Lipoma, NOS','Lipome',1,'WHO')
,('Lipomatous neoplasms',NULL,NULL,88501,'Atypical lipoma/j','Lipome atypique',1,'WHO')
,('Lipomatous neoplasms',NULL,NULL,88503,'Liposarcoma, NOS','Liposarcome',1,'WHO')
,('Complex mixed and stromal neoplasms',NULL,NULL,89360,'Gastrointestinal stromal tumor, benign','Tumeur b����nigne du stroma gastro intestinal',1,'WHO')
,('Complex mixed and stromal neoplasms',NULL,NULL,89361,'Gastrointestinal stromal tumor, NOS','Tumeur du stroma gastro intestinal',1,'WHO')
,('Complex mixed and stromal neoplasms',NULL,NULL,89363,'Gastrointestinal stromal sarcoma','Sarcome du stroma gastro intestinal',1,'WHO')
,('Complex mixed and stromal neoplasms',NULL,NULL,89400,'Pleomorphic adenoma','Ad̩nome pl̩omorphe',1,'WHO')
,('Complex mixed and stromal neoplasms',NULL,NULL,89403,'Mixed tumor, malignant, NOS','Tumeur mixte maligne',1,'WHO')
,('Complex mixed and stromal neoplasms',NULL,NULL,89413,'Carcinoma in pleomorphic adenoma','Carcinome sur ad̩nome pl̩omorphe',1,'WHO')
,('Complex mixed and stromal neoplasms',NULL,NULL,89503,'Mullerian mixed tumor','Mulleroblastome',1,'WHO')
,('Complex mixed and stromal neoplasms',NULL,NULL,89513,'Mesodermal mixed tumor','Tumeur mixte m����sodermique',1,'WHO')
,('Complex mixed and stromal neoplasms',NULL,NULL,89590,'Benign cystic nephroma','N����phrome kystique b����nin',1,'WHO')
,('Complex mixed and stromal neoplasms',NULL,NULL,89591,'Cystic partially differentiated nephroblastoma','N����phrome kystique partiellement diff����renci����',1,'WHO')
,('Complex mixed and stromal neoplasms',NULL,NULL,89593,'Malignant cystic nephroma','N����phrome kystique malin',1,'WHO')
,('Complex mixed and stromal neoplasms',NULL,NULL,89601,'Mesoblastic nephroma','N̩phrome m̩soblastique',1,'WHO')
,('Complex mixed and stromal neoplasms',NULL,NULL,89603,'Nephroblastoma, NOS','N����phroblastome',1,'WHO')
,('Complex mixed and stromal neoplasms',NULL,NULL,89633,'Malignant rhabdoid tumor','Tumeur rhabdo����de maligne',1,'WHO')
,('Complex mixed and stromal neoplasms',NULL,NULL,89643,'Clear cell sarcoma of kidney','Sarcome �� cellules claires du rein',1,'WHO')
,('Complex mixed and stromal neoplasms',NULL,NULL,89650,'Nephrogenic adenofibroma','Ad����nofibrome n����phrog����ne',1,'WHO')
,('Complex mixed and stromal neoplasms',NULL,NULL,89660,'Renomedullary interstitial cell tumor','Tumeur ���� cellules interstitielles r����nom����dulaires',1,'WHO')
,('Complex mixed and stromal neoplasms',NULL,NULL,89670,'Ossifying renal tumor','Tumeur r����nale ossifiante',1,'WHO')
,('Complex mixed and stromal neoplasms',NULL,NULL,89703,'Hepatoblastoma','H̩patoblastome',1,'WHO')
,('Complex mixed and stromal neoplasms',NULL,NULL,89713,'Pancreatoblastoma','Pancr̩atoblastome',1,'WHO')
,('Complex mixed and stromal neoplasms',NULL,NULL,89723,'Pulmonary blastoma','Blastome pulmonaire',1,'WHO')
,('Complex mixed and stromal neoplasms',NULL,NULL,89733,'Pleuropulmonary blastoma','Blastome pleuropulmonaire',1,'WHO')
,('Complex mixed and stromal neoplasms',NULL,NULL,89741,'Sialoblastoma','Sialoblastome',1,'WHO')
,('Complex mixed and stromal neoplasms',NULL,NULL,89803,'Carcinosarcoma, NOS','Carcinosarcome',1,'WHO')
,('Complex mixed and stromal neoplasms',NULL,NULL,89813,'Carcinosarcoma, embryonal','Carcinosarcome embryonnaire',1,'WHO')
,('Complex mixed and stromal neoplasms',NULL,NULL,89820,'Myoepithelioma','Myo-̩pith̩liome',1,'WHO')
,('Complex mixed and stromal neoplasms',NULL,NULL,89823,'Malignant myoepithelioma','Myo����pith����liome malin',1,'WHO')
,('Complex mixed and stromal neoplasms',NULL,NULL,89830,'Adenomyoepithelioma','Ad����nomyo����pith����liome',1,'WHO')
,('Complex mixed and stromal neoplasms',NULL,NULL,89900,'Mesenchymoma, benign','M̩senchymome b̩nin',1,'WHO')
,('Complex mixed and stromal neoplasms',NULL,NULL,89901,'Mesenchymoma, NOS','M����senchymome',1,'WHO')
,('Complex mixed and stromal neoplasms',NULL,NULL,89903,'Mesenchymoma, malignant','M̩senchymome malin',1,'WHO')
,('Complex mixed and stromal neoplasms',NULL,NULL,89913,'Embryonal sarcoma','Sarcome embryonnaire',1,'WHO')
,('Fibroepithelial neoplasms',NULL,NULL,90000,'Brenner tumor, NOS','Tumeur de Brenner',1,'WHO')
,('Fibroepithelial neoplasms',NULL,NULL,90001,'Brenner tumor, borderline malignancy','Tumeur de Brenner ���� la limite de la malignit����',1,'WHO')
,('Fibroepithelial neoplasms',NULL,NULL,90003,'Brenner tumor, malignant','Tumeur de Brenner maligne',1,'WHO')
,('Fibroepithelial neoplasms',NULL,NULL,90100,'Fibroadenoma, NOS','Fibroad����nome',1,'WHO')
,('Fibroepithelial neoplasms',NULL,NULL,90110,'Intracanalicular fibroadenoma','Fibroad̩nome intracanaliculaire',1,'WHO')
,('Fibroepithelial neoplasms',NULL,NULL,90120,'Pericanalicular fibroadenoma','Fibroad̩nome p̩ricanaliculaire',1,'WHO')
,('Fibroepithelial neoplasms',NULL,NULL,90130,'Adenofibroma, NOS','Ad����nofibrome',1,'WHO')
,('Fibroepithelial neoplasms',NULL,NULL,90140,'Serous adenofibroma, NOS','Ad����nofibrome s����reux',1,'WHO')
,('Fibroepithelial neoplasms',NULL,NULL,90141,'Serous adenofibroma of borderline malignancy','Ad����nofibrome s����reux ���� la limite de la malignit����',1,'WHO')
,('Fibroepithelial neoplasms',NULL,NULL,90143,'Serous adenocarcinofibroma','Ad����nocarcinofibrome s����reux',1,'WHO')
,('Fibroepithelial neoplasms',NULL,NULL,90150,'Mucinous adenofibroma, NOS','Ad����nofibrome mucineux',1,'WHO')
,('Fibroepithelial neoplasms',NULL,NULL,90151,'Mucinous adenofibroma of borderline malignancy','Ad����nofibrome mucineux ���� la limite de la malignit����',1,'WHO')
,('Fibroepithelial neoplasms',NULL,NULL,90153,'Mucinous adenocarcinofibroma','Ad����nocarcinofibrome mucineux',1,'WHO')
,('Fibroepithelial neoplasms',NULL,NULL,90160,'Giant fibroadenoma','Fibro-ad̩nome g̩ant',1,'WHO')
,('Fibroepithelial neoplasms',NULL,NULL,90200,'Phyllodes tumor, benign','Phyllodes tumor, benign',0,'WHO')
,('Fibroepithelial neoplasms',NULL,NULL,90201,'Phyllodes tumor, borderline','Phyllodes tumor, borderline',0,'WHO')
,('Fibroepithelial neoplasms',NULL,NULL,90203,'Phyllodes tumor, malignant','Phyllodes tumor, malignant',0,'WHO')
,('Fibroepithelial neoplasms',NULL,NULL,90300,'Juvenile fibroadenoma','Fibro-ad̩nome juv̩nile',1,'WHO')
,('Synovial-like neoplasms',NULL,NULL,90400,'Synovioma, benign','Synoviome b̩nin',1,'WHO')
,('Synovial-like neoplasms',NULL,NULL,90403,'Synovial sarcoma, NOS','Sarcome synovial',1,'WHO')
,('Synovial-like neoplasms',NULL,NULL,90413,'Synovial sarcoma, spindle cell','Sarcome synovial, �� cellules fusiformes',1,'WHO')
,('Synovial-like neoplasms',NULL,NULL,90423,'Synovial sarcoma, epithelioid cell','Sarcome synovial, �� cellules ̩pith̩lio��des',1,'WHO')
,('Synovial-like neoplasms',NULL,NULL,90433,'Synovial sarcoma, biphasic','Sarcome synovial, de type biphasique',1,'WHO')
,('Synovial-like neoplasms',NULL,NULL,90443,'Clear cell sarcoma, NOS','Sarcome ���� cellules claires',1,'WHO')
,('Mesothelial neoplasms',NULL,NULL,90500,'Mesothelioma, benign','M̩soth̩liome b̩nin',1,'WHO')
,('Mesothelial neoplasms',NULL,NULL,90503,'Mesothelioma, malignant','M̩soth̩liome malin',1,'WHO')
,('Mesothelial neoplasms',NULL,NULL,90510,'Fibrous mesothelioma, benign','M̩soth̩liome fibreux b̩nin',1,'WHO')
,('Mesothelial neoplasms',NULL,NULL,90513,'Fibrous mesothelioma, malignant','M̩soth̩liome fibreux malin',1,'WHO')
,('Mesothelial neoplasms',NULL,NULL,90520,'Epithelioid mesothelioma, benign','M̩soth̩liome ̩pith̩lio��de b̩nin',1,'WHO')
,('Mesothelial neoplasms',NULL,NULL,90523,'Epithelioid mesothelioma, malignant','M̩soth̩liome ̩pith̩lio��de malin',1,'WHO')
,('Mesothelial neoplasms',NULL,NULL,90533,'Mesothelioma, biphasic, malignant','M̩soth̩liome biphasique malin',1,'WHO')
,('Mesothelial neoplasms',NULL,NULL,90540,'Adenomatoid tumor, NOS','Tumeur ad����nomato����de',1,'WHO')
,('Mesothelial neoplasms',NULL,NULL,90550,'Multicystic mesothelioma, benign','M����soth����liome polykystique b����nin',1,'WHO')
,('Mesothelial neoplasms',NULL,NULL,90551,'Cystic mesothelioma, NOS','M����soth����liome kystique',1,'WHO')
,('Germ cell neoplasms',NULL,NULL,90603,'Dysgerminoma','Dysgerminome',1,'WHO')
,('Germ cell neoplasms',NULL,NULL,90613,'Seminoma, NOS','S����minome',1,'WHO')
,('Germ cell neoplasms',NULL,NULL,90623,'Seminoma, anaplastic','S̩minome anaplasique',1,'WHO')
,('Germ cell neoplasms',NULL,NULL,90633,'Spermatocytic seminoma','S̩minome spermatocytaire',1,'WHO')
,('Germ cell neoplasms',NULL,NULL,90642,'Intratubular malignant germ cells','Cellules germinales intratubulaires malignes',1,'WHO')
,('Germ cell neoplasms',NULL,NULL,90643,'Germinoma','Germinome',1,'WHO')
,('Germ cell neoplasms',NULL,NULL,90653,'Germ cell tumor, nonseminomatous','Tumeur ���� cellules germinales, non s����minomateuse',1,'WHO')
,('Germ cell neoplasms',NULL,NULL,90703,'Embryonal carcinoma, NOS','Carcinome embryonnaire',1,'WHO')
,('Germ cell neoplasms',NULL,NULL,90713,'Yolk sac tumor','Tumeur vitelline',1,'WHO')
,('Germ cell neoplasms',NULL,NULL,90723,'Polyembryoma','Polyembryome',1,'WHO')
,('Germ cell neoplasms',NULL,NULL,90731,'Gonadoblastoma','Gonadoblastome',1,'WHO')
,('Germ cell neoplasms',NULL,NULL,90800,'Teratoma, benign','T̩ratome b̩nin',1,'WHO')
,('Germ cell neoplasms',NULL,NULL,90801,'Teratoma, NOS','T����ratome',1,'WHO')
,('Germ cell neoplasms',NULL,NULL,90803,'Teratoma, malignant, NOS','T����ratome malin',1,'WHO')
,('Germ cell neoplasms',NULL,NULL,90813,'Teratocarcinoma','T̩ratocarcinome',1,'WHO')
,('Germ cell neoplasms',NULL,NULL,90823,'Malignant teratoma, undifferentiated','T̩ratome malin de type indiff̩renci̩',1,'WHO')
,('Germ cell neoplasms',NULL,NULL,90833,'Malignant teratoma, intermediate','T̩ratome malin de type interm̩diaire',1,'WHO')
,('Germ cell neoplasms',NULL,NULL,90840,'Dermoid cyst, NOS','Kyste dermo����de',1,'WHO')
,('Germ cell neoplasms',NULL,NULL,90843,'Teratoma with malignant transformation','T̩ratome avec transformation maligne',1,'WHO')
,('Germ cell neoplasms',NULL,NULL,90853,'Mixed germ cell tumor','Tumeur mixte des cellules germinales',1,'WHO')
,('Germ cell neoplasms',NULL,NULL,90900,'Struma ovarii, NOS','Goitre ovarien',1,'WHO')
,('Germ cell neoplasms',NULL,NULL,90903,'Struma ovarii, malignant','Goitre ovarien malin',1,'WHO')
,('Trophoblastic neoplasms',NULL,NULL,90911,'Strumal carcinoid','Carcino��de ovarien',1,'WHO')
,('Trophoblastic neoplasms',NULL,NULL,91000,'Hydatidiform mole, NOS','M����le hydatiforme',1,'WHO')
,('Trophoblastic neoplasms',NULL,NULL,91001,'Invasive hydatidiform mole','M̫le hydatidiforme invasive',1,'WHO')
,('Trophoblastic neoplasms',NULL,NULL,91003,'Choriocarcinoma, NOS','Choriocarcinome',1,'WHO')
,('Trophoblastic neoplasms',NULL,NULL,91013,'Choriocarcinoma combined with other germ cell elements','Choriocarcinome associ̩ �� d''autres ̩l̩ments �� cellules germinales',1,'WHO')
,('Trophoblastic neoplasms',NULL,NULL,91023,'Malignant teratoma, trophoblastic','T̩ratome malin trophoblastique',1,'WHO')
,('Trophoblastic neoplasms',NULL,NULL,91030,'Partial hydatidiform mole','M̫le hydatidiforme partielle',1,'WHO')
,('Trophoblastic neoplasms',NULL,NULL,91041,'Placental site trophoblastic tumor','Tumeur trophoblastique du site placentaire',1,'WHO')
,('Trophoblastic neoplasms',NULL,NULL,91053,'Trophoblastic tumor, epithelioid','Tumeur trophoblastique ����pith����lio����de',1,'WHO')
,('Mesonephromas',NULL,NULL,91100,'Mesonephroma, benign','M̩son̩phrome b̩nin',1,'WHO')
,('Mesonephromas',NULL,NULL,91101,'Mesonephric tumor, NOS','Tumeur m����son����phrique',1,'WHO')
,('Mesonephromas',NULL,NULL,91103,'Mesonephroma, malignant','M̩son̩phrome malin',1,'WHO')
,('Blood vessel tumors',NULL,NULL,91200,'Hemangioma, NOS','H����mangiome',1,'WHO')
,('Blood vessel tumors',NULL,NULL,91203,'Hemangiosarcoma','H����mangiosarcome',1,'WHO')
,('Blood vessel tumors',NULL,NULL,91210,'Cavernous hemangioma','H����mangiome caverneux',1,'WHO')
,('Blood vessel tumors',NULL,NULL,91220,'Venous hemangioma','H����mangiome veineux',1,'WHO')
,('Blood vessel tumors',NULL,NULL,91230,'Racemose hemangioma','H����mangiome rac����meux',1,'WHO')
,('Blood vessel tumors',NULL,NULL,91243,'Kupffer cell sarcoma','Sarcome des cellules de Kupffer',1,'WHO')
,('Blood vessel tumors',NULL,NULL,91250,'Epithelioid hemangioma','H����mangiome ����pith����lio����de',1,'WHO')
,('Blood vessel tumors',NULL,NULL,91300,'Hemangioendothelioma, benign','H����mangioendoth����liome b����nin',1,'WHO')
,('Blood vessel tumors',NULL,NULL,91301,'Hemangioendothelioma, NOS','H����mangioendoth����liome',1,'WHO')
,('Blood vessel tumors',NULL,NULL,91303,'Hemangioendothelioma, malignant','H����mangioendoth����liome malin',1,'WHO')
,('Blood vessel tumors',NULL,NULL,91310,'Capillary hemangioma','H����mangiome capillaire',1,'WHO')
,('Blood vessel tumors',NULL,NULL,91320,'Intramuscular hemangioma','H����mangiome intramusculaire',1,'WHO')
,('Blood vessel tumors',NULL,NULL,91331,'Epithelioid hemangioendothelioma, NOS','H����mangioendoth����liome ����pith����lio����de',1,'WHO')
,('Blood vessel tumors',NULL,NULL,91333,'Epithelioid hemangioendothelioma, malignant','H����mangioendoth����liome ����pith����lio����de malin',1,'WHO')
,('Blood vessel tumors',NULL,NULL,91351,'Endovascular papillary angioendothelioma','Angioendoth����liome papillaire endovasculaire',1,'WHO')
,('Blood vessel tumors',NULL,NULL,91361,'Spindle cell hemangioendothelioma','H����mangioendoth����liome ���� cellules fusiformes',1,'WHO')
,('Blood vessel tumors',NULL,NULL,91403,'Kaposi sarcoma','Sarcome de Kaposi',1,'WHO')
,('Blood vessel tumors',NULL,NULL,91410,'Angiokeratoma','Angiok̩ratome',1,'WHO')
,('Blood vessel tumors',NULL,NULL,91420,'Verrucous keratotic hemangioma','H����mangiome verruqueux k����ratosique',1,'WHO')
,('Blood vessel tumors',NULL,NULL,91500,'Hemangiopericytoma, benign','H����mangiop����ricytome b����nin',1,'WHO')
,('Blood vessel tumors',NULL,NULL,91501,'Hemangiopericytoma, NOS','H����mangiop����ricytome',1,'WHO')
,('Blood vessel tumors',NULL,NULL,91503,'Hemangiopericytoma, malignant','H����mangiop����ricytome malin',1,'WHO')
,('Blood vessel tumors',NULL,NULL,91600,'Angiofibroma, NOS','Angiofibrome',1,'WHO')
,('Blood vessel tumors',NULL,NULL,91610,'Acquired tufted hemangioma','H����mangiome pelotonn���� acquis',1,'WHO')
,('Blood vessel tumors',NULL,NULL,91611,'Hemangioblastoma','H����mangioblastome',1,'WHO')
,('Lymphatic vessel tumors',NULL,NULL,91700,'Lymphangioma, NOS','Lymphangiome',1,'WHO')
,('Lymphatic vessel tumors',NULL,NULL,91703,'Lymphangiosarcoma','Lymphangiosarcome',1,'WHO')
,('Lymphatic vessel tumors',NULL,NULL,91710,'Capillary lymphangioma','Lymphangiome capillaire',1,'WHO')
,('Lymphatic vessel tumors',NULL,NULL,91720,'Cavernous lymphangioma','Lymphangiome caverneux',1,'WHO')
,('Lymphatic vessel tumors',NULL,NULL,91730,'Cystic lymphangioma','Lymphangiome kystique',1,'WHO')
,('Lymphatic vessel tumors',NULL,NULL,91740,'Lymphangiomyoma','Lymphangiomyome',1,'WHO')
,('Lymphatic vessel tumors',NULL,NULL,91741,'Lymphangiomyomatosis','Lymphangiomyomatose',1,'WHO')
,('Lymphatic vessel tumors',NULL,NULL,91750,'Hemolymphangioma','H����molymphangiome',1,'WHO')
,('Osseous and chondromatous neoplasms',NULL,NULL,91800,'Osteoma, NOS','Ost����ome',1,'WHO')
,('Osseous and chondromatous neoplasms',NULL,NULL,91803,'Osteosarcoma, NOS','Ost����osarcome',1,'WHO')
,('Osseous and chondromatous neoplasms',NULL,NULL,91813,'Chondroblastic osteosarcoma','Ost̩osarcome chondroblastique',1,'WHO')
,('Osseous and chondromatous neoplasms',NULL,NULL,91823,'Fibroblastic osteosarcoma','Ost̩osarcome fibroblastique',1,'WHO')
,('Osseous and chondromatous neoplasms',NULL,NULL,91833,'Telangiectatic osteosarcoma','Ost̩osarcome t̩langiectasique',1,'WHO')
,('Osseous and chondromatous neoplasms',NULL,NULL,91843,'Osteosarcoma in Paget disease of bone','Ost����osarcome sur maladie de Paget de l''os',1,'WHO')
,('Osseous and chondromatous neoplasms',NULL,NULL,91853,'Small cell osteosarcoma','Ost̩osarcome �� petites cellules',1,'WHO')
,('Osseous and chondromatous neoplasms',NULL,NULL,91863,'Central osteosarcoma','Ost����osarcome central',1,'WHO')
,('Osseous and chondromatous neoplasms',NULL,NULL,91873,'Intraosseous well differentiated osteosarcoma','Ost����osarcome intraosseux bien diff����renci����',1,'WHO')
,('Osseous and chondromatous neoplasms',NULL,NULL,91910,'Osteoid osteoma, NOS','Ost����ome ost����o����de',1,'WHO')
,('Osseous and chondromatous neoplasms',NULL,NULL,91923,'Parosteal osteosarcoma','Ost����osarcome parost����al',1,'WHO')
,('Osseous and chondromatous neoplasms',NULL,NULL,91933,'Periosteal osteosarcoma','Ost����osarcome p����riost����',1,'WHO')
,('Osseous and chondromatous neoplasms',NULL,NULL,91943,'High grade surface osteosarcoma','Ost����osarcome de surface de haut grade',1,'WHO')
,('Osseous and chondromatous neoplasms',NULL,NULL,91953,'Intracortical osteosarcoma','Ost����osarcome intra cortical',1,'WHO')
,('Osseous and chondromatous neoplasms',NULL,NULL,92000,'Osteoblastoma, NOS','Ost����oblastome',1,'WHO')
,('Osseous and chondromatous neoplasms',NULL,NULL,92001,'Aggressive osteoblastoma','Ost̩oblastome agressif',1,'WHO')
,('Osseous and chondromatous neoplasms',NULL,NULL,92100,'Osteochondroma','Ost̩ochondrome',1,'WHO')
,('Osseous and chondromatous neoplasms',NULL,NULL,92101,'Osteochondromatosis, NOS','Ost����oblastome agressif',1,'WHO')
,('Osseous and chondromatous neoplasms',NULL,NULL,92200,'Chondroma, NOS','Chondrome',1,'WHO')
,('Osseous and chondromatous neoplasms',NULL,NULL,92201,'Chondromatosis, NOS','Chondromatose',1,'WHO')
,('Osseous and chondromatous neoplasms',NULL,NULL,92203,'Chondrosarcoma, NOS','Chondrosarcome',1,'WHO')
,('Osseous and chondromatous neoplasms',NULL,NULL,92210,'Juxtacortical chondroma','Chondrome juxtacortical',1,'WHO')
,('Osseous and chondromatous neoplasms',NULL,NULL,92213,'Juxtacortical chondrosarcoma','Chondrosarcome juxtacortical',1,'WHO')
,('Osseous and chondromatous neoplasms',NULL,NULL,92300,'Chondroblastoma, NOS','Chondroblastome',1,'WHO')
,('Osseous and chondromatous neoplasms',NULL,NULL,92303,'Chondroblastoma, malignant','Chondroblastome malin',1,'WHO')
,('Osseous and chondromatous neoplasms',NULL,NULL,92313,'Myxoid chondrosarcoma','Chondrosarcome myxo��de',1,'WHO')
,('Osseous and chondromatous neoplasms',NULL,NULL,92403,'Mesenchymal chondrosarcoma','Chondrosarcome m̩senchymateux',1,'WHO')
,('Osseous and chondromatous neoplasms',NULL,NULL,92410,'Chondromyxoid fibroma','Fibrome chondromyxo��de',1,'WHO')
,('Osseous and chondromatous neoplasms',NULL,NULL,92423,'Clear cell chondrosarcoma','Chondrosarcome ���� cellules claires',1,'WHO')
,('Osseous and chondromatous neoplasms',NULL,NULL,92433,'Dedifferentiated chondrosarcoma','Chondrosarcome d����diff����renci����',1,'WHO')
,('Giant cell tumors',NULL,NULL,92501,'Giant cell tumor of bone, NOS','Tumeur ���� cellules g����antes de l''os',1,'WHO')
,('Giant cell tumors',NULL,NULL,92503,'Giant cell tumor of bone, malignant','Tumeur maligne ���� cellules g����antes de l''os',1,'WHO')
,('Giant cell tumors',NULL,NULL,92511,'Giant cell tumor of soft parts, NOS','Tumeur ���� cellules g����antes des tissus mous',1,'WHO')
,('Giant cell tumors',NULL,NULL,92513,'Malignant giant cell tumor of soft parts','Tumeur maligne ���� cellules g����antes des tissus mous',1,'WHO')
,('Giant cell tumors',NULL,NULL,92520,'Tenosynovial giant cell tumor','Tumeur t����nosynoviale ���� cellules g����antes',1,'WHO')
,('Giant cell tumors',NULL,NULL,92523,'Malignant tenosynovial giant cell tumor','Tumeur t����nosynoviale maligne ���� cellules g����antes',1,'WHO')
,('Odontogenic tumors',NULL,NULL,92603,'Ewing sarcoma','Sarcome d''Ewing',1,'WHO')
,('Odontogenic tumors',NULL,NULL,92613,'Adamantinoma of long bones','Adamantinome des os longs',1,'WHO')
,('Odontogenic tumors',NULL,NULL,92620,'Ossifying fibroma','Fibrome ossifiant',1,'WHO')
,('Odontogenic tumors',NULL,NULL,92700,'Odontogenic tumor, benign','Tumeur odontog����ne b����nigne',1,'WHO')
,('Odontogenic tumors',NULL,NULL,92701,'Odontogenic tumor, NOS','Tumeur odontog����ne',1,'WHO')
,('Odontogenic tumors',NULL,NULL,92703,'Odontogenic tumor, malignant','Tumeur odontog����ne maligne',1,'WHO')
,('Odontogenic tumors',NULL,NULL,92710,'Ameloblastic fibrodentinoma','Fibrodentinome am����loblastique',1,'WHO')
,('Odontogenic tumors',NULL,NULL,92720,'Cementoma, NOS','C����mentome',1,'WHO')
,('Odontogenic tumors',NULL,NULL,92730,'Cementoblastoma, benign','C̩mentoblastome b̩nin',1,'WHO')
,('Odontogenic tumors',NULL,NULL,92740,'Cementifying fibroma','Fibrome c̩mentifiant',1,'WHO')
,('Odontogenic tumors',NULL,NULL,92750,'Gigantiform cementoma','C̩mentome g̩ant',1,'WHO')
,('Odontogenic tumors',NULL,NULL,92800,'Odontoma, NOS','Odontome',1,'WHO')
,('Odontogenic tumors',NULL,NULL,92810,'Compound odontoma','Odontome compos̩',1,'WHO')
,('Odontogenic tumors',NULL,NULL,92820,'Complex odontoma','Odontome complexe',1,'WHO')
,('Odontogenic tumors',NULL,NULL,92900,'Ameloblastic fibro-odontoma','Fibro-odontome am̩loblastique',1,'WHO')
,('Odontogenic tumors',NULL,NULL,92903,'Ameloblastic odontosarcoma','Odontosarcome am̩loblastique',1,'WHO')
,('Gliomas',NULL,NULL,93923,'Ependymoma, anaplastic','��pendymome anaplasique',1,'WHO')
,('Gliomas',NULL,NULL,93933,'Papillary ependymoma','��pendymome papillaire',1,'WHO')
,('Gliomas',NULL,NULL,93941,'Myxopapillary ependymoma','��pendymome myxopapillaire',1,'WHO')
,('Gliomas',NULL,NULL,94003,'Astrocytoma, NOS','Astrocytome',1,'WHO')
,('Gliomas',NULL,NULL,94013,'Astrocytoma, anaplastic','Astrocytome anaplasique',1,'WHO')
,('Gliomas',NULL,NULL,94103,'Protoplasmic astrocytoma','Astrocytome protoplasmique',1,'WHO')
,('Gliomas',NULL,NULL,94113,'Gemistocytic astrocytoma','Astrocytome g̩mistocytique',1,'WHO')
,('Gliomas',NULL,NULL,94121,'Desmoplastic infantile astrocytoma','Astrocytome desmoplastique infantile',1,'WHO')
,('Gliomas',NULL,NULL,94130,'Dysembryoplastic neuroepithelial tumor','Dysembryoplastic neuroepithelial tumor',0,'WHO')
,('Gliomas',NULL,NULL,94203,'Fibrillary astrocytoma','Astrocytome fibrillaire',1,'WHO')
,('Gliomas',NULL,NULL,94211,'Pilocytic astrocytoma','Astrocytome pilocytique',1,'WHO')
,('Gliomas',NULL,NULL,94233,'Polar spongioblastoma','Polar spongioblastoma',0,'WHO')
,('Gliomas',NULL,NULL,94243,'Pleomorphic xanthoastrocytoma','Xanthoastrocytome pl̩omorphe',1,'WHO')
,('Gliomas',NULL,NULL,94303,'Astroblastoma','Astroblastome',1,'WHO')
,('Gliomas',NULL,NULL,94403,'Glioblastoma, NOS','Glioblastoma, NOS',0,'WHO')
,('Gliomas',NULL,NULL,94413,'Giant cell glioblastoma','Glioblastome �� cellules g̩antes',1,'WHO')
,('Gliomas',NULL,NULL,94421,'Gliofibroma','Gliofibroma',0,'WHO')
,('Gliomas',NULL,NULL,94423,'Gliosarcoma','Gliosarcome',1,'WHO')
,('Gliomas',NULL,NULL,94441,'Chordoid glioma','Gliome chondro����de',1,'WHO')
,('Gliomas',NULL,NULL,94503,'Oligodendroglioma, NOS','Oligodendroglioma, NOS',0,'WHO')
,('Gliomas',NULL,NULL,94513,'Oligodendroglioma, anaplastic','Oligodendrogliome anaplasique',1,'WHO')
,('Gliomas',NULL,NULL,94603,'Oligodendroblastoma','Oligodendroblastome',1,'WHO')
,('Gliomas',NULL,NULL,94703,'Medulloblastoma, NOS','M����dulloblastome',1,'WHO')
,('Gliomas',NULL,NULL,94713,'Desmoplastic nodular medulloblastoma','M����dulloblastome nodulaire desmoplastique',1,'WHO')
,('Gliomas',NULL,NULL,94723,'Medullomyoblastoma','M̩dullomyoblastome',1,'WHO')
,('Gliomas',NULL,NULL,94733,'Primitive neuroectodermal tumor, NOS','Primitive neuroectodermal tumor, NOS',0,'WHO')
,('Gliomas',NULL,NULL,94743,'Large cell medulloblastoma','Large cell medulloblastoma',0,'WHO')
,('Gliomas',NULL,NULL,94803,'Cerebellar sarcoma, NOS','Sarcome c����r����belleux',1,'WHO')
,('Neuroepitheliomatous neoplasms',NULL,NULL,94900,'Ganglioneuroma','Ganglioneurome',1,'WHO')
,('Neuroepitheliomatous neoplasms',NULL,NULL,94903,'Ganglioneuroblastoma','Ganglioneuroblastome',1,'WHO')
,('Neuroepitheliomatous neoplasms',NULL,NULL,94910,'Ganglioneuromatosis','Ganglioneuromatose',1,'WHO')
,('Neuroepitheliomatous neoplasms',NULL,NULL,94920,'Gangliocytoma','Gangliocytome',1,'WHO')
,('Neuroepitheliomatous neoplasms',NULL,NULL,94930,'Dysplastic gangliocytoma of cerebellum (Lhermitte-Duclos)','Gangliocytome dysplasique du cervelet',1,'WHO')
,('Neuroepitheliomatous neoplasms',NULL,NULL,95003,'Neuroblastoma, NOS','Neuroblastome',1,'WHO')
,('Neuroepitheliomatous neoplasms',NULL,NULL,95010,'Medulloepithelioma, benign','Medulloepithelioma, benign',0,'WHO')
,('Neuroepitheliomatous neoplasms',NULL,NULL,95013,'Medulloepithelioma, NOS','Medulloepithelioma, NOS',0,'WHO')
,('Neuroepitheliomatous neoplasms',NULL,NULL,95020,'Teratoid medulloepithelioma, benign','Teratoid medulloepithelioma, benign',0,'WHO')
,('Neuroepitheliomatous neoplasms',NULL,NULL,95023,'Teratoid medulloepithelioma','M̩dullo-̩pith̩liome t̩rato��de',1,'WHO')
,('Neuroepitheliomatous neoplasms',NULL,NULL,95033,'Neuroepithelioma, NOS','Neuroepithelioma, NOS',0,'WHO')
,('Neuroepitheliomatous neoplasms',NULL,NULL,95043,'Spongioneuroblastoma','Spongioneuroblastome',1,'WHO')
,('Neuroepitheliomatous neoplasms',NULL,NULL,95051,'Ganglioglioma, NOS','Gangliogliome',1,'WHO')
,('Neuroepitheliomatous neoplasms',NULL,NULL,95053,'Ganglioglioma, anaplastic','Gangliogliome anaplasique',1,'WHO')
,('Neuroepitheliomatous neoplasms',NULL,NULL,95061,'Central neurocytoma','Neurocytome central',1,'WHO')
,('Neuroepitheliomatous neoplasms',NULL,NULL,95070,'Pacinian tumor','Tumeur des corpuscules de Pacini',1,'WHO')
,('Neuroepitheliomatous neoplasms',NULL,NULL,95083,'Atypical teratoid/rhabdoid tumor','Tumeur rhabdo����de/t����rato����de atypique',1,'WHO')
,('Neuroepitheliomatous neoplasms',NULL,NULL,95100,'Retinocytoma','Retinocytoma',0,'WHO')
,('Neuroepitheliomatous neoplasms',NULL,NULL,95103,'Retinoblastoma, NOS','Retinoblastoma, NOS',0,'WHO')
,('Neuroepitheliomatous neoplasms',NULL,NULL,95113,'Retinoblastoma, differentiated','R̩tinoblastome diff̩renci̩',1,'WHO')
,('Neuroepitheliomatous neoplasms',NULL,NULL,95123,'Retinoblastoma, undifferentiated','R̩tinoblastome indiff̩renci̩',1,'WHO')
,('Neuroepitheliomatous neoplasms',NULL,NULL,95133,'Retinoblastoma, diffuse','Retinoblastoma, diffuse',0,'WHO')
,('Neuroepitheliomatous neoplasms',NULL,NULL,95141,'Retinoblastoma, spontaneously regressed','Retinoblastoma, spontaneously regressed',0,'WHO')
,('Neuroepitheliomatous neoplasms',NULL,NULL,95203,'Olfactory neurogenic tumor','Olfactory neurogenic tumor',0,'WHO')
,('Neuroepitheliomatous neoplasms',NULL,NULL,95213,'Olfactory neurocytoma','Olfactory neurocytoma',0,'WHO')
,('Neuroepitheliomatous neoplasms',NULL,NULL,95223,'Olfactory neuroblastoma','Olfactory neuroblastoma',0,'WHO')
,('Neuroepitheliomatous neoplasms',NULL,NULL,95233,'Olfactory neuroepithelioma','Olfactory neuroepithelioma',0,'WHO')
,('Meningiomas',NULL,NULL,95300,'Meningioma, NOS','M����ningiome',1,'WHO')
,('Meningiomas',NULL,NULL,95301,'Meningiomatosis, NOS','M����ningiomatose',1,'WHO')
,('Meningiomas',NULL,NULL,95303,'Meningioma, malignant','M̩ningiome malin',1,'WHO')
,('Meningiomas',NULL,NULL,95310,'Meningothelial meningioma','Meningothelial meningioma',0,'WHO')
,('Meningiomas',NULL,NULL,95320,'Fibrous meningioma','M̩ningiome fibreux',1,'WHO')
,('Meningiomas',NULL,NULL,95330,'Psammomatous meningioma','M̩ningiome psammomateux',1,'WHO')
,('Meningiomas',NULL,NULL,95340,'Angiomatous meningioma','M̩ningiome angiomateux',1,'WHO')
,('Meningiomas',NULL,NULL,95350,'Hemangioblastic meningioma','Hemangioblastic meningioma',0,'WHO')
,('Meningiomas',NULL,NULL,95370,'Transitional meningioma','M̩ningiome transitionnel',1,'WHO')
,('Meningiomas',NULL,NULL,95381,'Clear cell meningioma','Clear cell meningioma',0,'WHO')
,('Meningiomas',NULL,NULL,95383,'Papillary meningioma','M̩ningiome papillaire',1,'WHO')
,('Meningiomas',NULL,NULL,95391,'Atypical meningioma','Atypical meningioma',0,'WHO')
,('Meningiomas',NULL,NULL,95393,'Meningeal sarcomatosis','Sarcomatose m̩ning̩e',1,'WHO')
,('Nerve sheath tumor',NULL,NULL,95400,'Neurofibroma, NOS','Neurofibrome',1,'WHO')
,('Nerve sheath tumor',NULL,NULL,95401,'Neurofibromatosis, NOS','Neurofibromatosis, NOS',0,'WHO')
,('Nerve sheath tumor',NULL,NULL,95403,'Malignant peripheral nerve sheath tumor','Malignant peripheral nerve sheath tumor',0,'WHO')
,('Nerve sheath tumor',NULL,NULL,95410,'Melanotic neurofibroma','Neurofibrome m̩lanique',1,'WHO')
,('Nerve sheath tumor',NULL,NULL,95500,'Plexiform neurofibroma','Neurofibrome plexiforme',1,'WHO')
,('Nerve sheath tumor',NULL,NULL,95600,'Neurilemoma, NOS','Neurilemmome',1,'WHO')
,('Nerve sheath tumor',NULL,NULL,95601,'Neurinomatosis','Neurinomatose',1,'WHO')
,('Nerve sheath tumor',NULL,NULL,95603,'Neurilemoma, malignant','Neurilemoma, malignant',0,'WHO')
,('Nerve sheath tumor',NULL,NULL,95613,'Malignant peripheral nerve sheath tumor with rhabdomyoblastic differentiation','Malignant peripheral nerve sheath tumor with rhabdomyoblastic differentiation',0,'WHO')
,('Nerve sheath tumor',NULL,NULL,95620,'Neurothekeoma','Neuroth̩come',1,'WHO')
,('Nerve sheath tumor',NULL,NULL,95700,'Neuroma, NOS','N����vrome',1,'WHO')
,('Nerve sheath tumor',NULL,NULL,95710,'Perineurioma, NOS','Perineurioma, NOS',0,'WHO')
,('Nerve sheath tumor',NULL,NULL,95713,'Perineurioma, malignant','Perineurioma, malignant',0,'WHO')
,('Granular cell tumors and alveolar soft part sarcomas',NULL,NULL,95800,'Granular cell tumor, NOS','Tumeur ���� cellules granuleuses',1,'WHO')
,('Granular cell tumors and alveolar soft part sarcomas',NULL,NULL,95803,'Granular cell tumor, malignant','Granular cell tumor, malignant',0,'WHO')
,('Granular cell tumors and alveolar soft part sarcomas',NULL,NULL,95813,'Alveolar soft part sarcoma','Sarcome alv̩olaire des tissus mous',1,'WHO')
,('Granular cell tumors and alveolar soft part sarcomas',NULL,NULL,95820,'Granular cell tumor of the sellar region','Granular cell tumor of the sellar region',0,'WHO')
,('Hodgkin and non-Hodgkin lymphomas','Malignant lymphomas, NOS or diffuse',NULL,95903,'Malignant lymphoma, NOS','Lymphome malin',1,'WHO')
,('Hodgkin and non-Hodgkin lymphomas','Malignant lymphomas, NOS or diffuse',NULL,95913,'Malignant lymphoma, non-Hodgkin, NOS','Malignant lymphoma, non-Hodgkin, NOS',0,'WHO')
,('Hodgkin and non-Hodgkin lymphomas','Malignant lymphomas, NOS or diffuse',NULL,95963,'Composite Hodgkin and non-Hodgkin lymphoma','Composite Hodgkin and non-Hodgkin lymphoma',0,'WHO')
,('Hodgkin and non-Hodgkin lymphomas','Hodgkin lymphoma',NULL,96503,'Hodgkin lymphoma, NOS','Hodgkin lymphoma, NOS',0,'WHO')
,('Hodgkin and non-Hodgkin lymphomas','Hodgkin lymphoma',NULL,96513,'Hodgkin lymphoma, lymphocyte-rich','Hodgkin lymphoma, lymphocyte-rich',0,'WHO')
,('Hodgkin and non-Hodgkin lymphomas','Hodgkin lymphoma',NULL,96523,'Hodgkin lymphoma, mixed cellularity, NOS','Hodgkin lymphoma, mixed cellularity, NOS',0,'WHO')
,('Hodgkin and non-Hodgkin lymphomas','Hodgkin lymphoma',NULL,96533,'Hodgkin lymphoma, lymphocyte depletion, NOS','Hodgkin lymphoma, lymphocyte depletion, NOS',0,'WHO')
,('Hodgkin and non-Hodgkin lymphomas','Hodgkin lymphoma',NULL,96543,'Hodgkin lymphoma, lymphocyte depletion, diffuse fibrosis','Hodgkin lymphoma, lymphocyte depletion, diffuse fibrosis',0,'WHO')
,('Hodgkin and non-Hodgkin lymphomas','Hodgkin lymphoma',NULL,96553,'Hodgkin lymphoma, lymphocyte depletion, reticular','Hodgkin lymphoma, lymphocyte depletion, reticular',0,'WHO')
,('Hodgkin and non-Hodgkin lymphomas','Hodgkin lymphoma',NULL,96593,'Hodgkin lymphoma, nodular lymphocyte predominance','Hodgkin lymphoma, nodular lymphocyte predominance',0,'WHO')
,('Hodgkin and non-Hodgkin lymphomas','Hodgkin lymphoma',NULL,96613,'Hodgkin granuloma','Hodgkin granuloma',0,'WHO')
,('Hodgkin and non-Hodgkin lymphomas','Hodgkin lymphoma',NULL,96623,'Hodgkin sarcoma','Hodgkin sarcoma',0,'WHO')
,('Hodgkin and non-Hodgkin lymphomas','Hodgkin lymphoma',NULL,96633,'Hodgkin lymphoma, nodular sclerosis, NOS','Hodgkin lymphoma, nodular sclerosis, NOS',0,'WHO')
,('Hodgkin and non-Hodgkin lymphomas','Hodgkin lymphoma',NULL,96643,'Hodgkin lymphoma, nodular sclerosis, cellular phase','Hodgkin lymphoma, nodular sclerosis, cellular phase',0,'WHO')
,('Hodgkin and non-Hodgkin lymphomas','Hodgkin lymphoma',NULL,96653,'Hodgkin lymphoma, nodular sclerosis,  grade 1','Hodgkin lymphoma, nodular sclerosis,  grade 1',0,'WHO')
,('Hodgkin and non-Hodgkin lymphomas','Hodgkin lymphoma',NULL,96673,'Hodgkin lymphoma, nodular sclerosis,  grade 2','Hodgkin lymphoma, nodular sclerosis,  grade 2',0,'WHO')
,('Hodgkin and non-Hodgkin lymphomas','Non-hodgkin lymphomas','Mature B-cell lymphomas',96703,'Malignant lymphoma, small B lymphocytic, NOS','Malignant lymphoma, small B lymphocytic, NOS',0,'WHO')
,('Hodgkin and non-Hodgkin lymphomas','Non-hodgkin lymphomas','Mature B-cell lymphomas',96713,'Malignant lymphoma, lymphoplasmacytic','Lymphome malin, lymphoplasmocytaire',1,'WHO')
,('Hodgkin and non-Hodgkin lymphomas','Non-hodgkin lymphomas','Mature B-cell lymphomas',96733,'Mantle cell lymphoma','Mantle cell lymphoma',0,'WHO')
,('Hodgkin and non-Hodgkin lymphomas','Non-hodgkin lymphomas','Mature B-cell lymphomas',96753,'Malignant lymphoma, mixed small and large cell, diffuse','Lymphome malin, mixte, �� petites cellules et grandes cellules, diffus',1,'WHO')
,('Hodgkin and non-Hodgkin lymphomas','Non-hodgkin lymphomas','Mature B-cell lymphomas',96783,'Primary effusion lymphoma','Primary effusion lymphoma',0,'WHO')
,('Hodgkin and non-Hodgkin lymphomas','Non-hodgkin lymphomas','Mature B-cell lymphomas',96793,'Mediastinal large B-cell lymphoma','Mediastinal large B-cell lymphoma',0,'WHO')
,('Hodgkin and non-Hodgkin lymphomas','Non-hodgkin lymphomas','Mature B-cell lymphomas',96803,'Malignant lymphoma, large B-cell, diffuse, NOS','Malignant lymphoma, large B-cell, diffuse, NOS',0,'WHO')
,('Hodgkin and non-Hodgkin lymphomas','Non-hodgkin lymphomas','Mature B-cell lymphomas',96843,'Malignant lymphoma, large B-cell, diffuse, immunoblastic, NOS','Malignant lymphoma, large B-cell, diffuse, immunoblastic, NOS',0,'WHO')
,('Hodgkin and non-Hodgkin lymphomas','Non-hodgkin lymphomas','Mature B-cell lymphomas',96873,'Burkitt lymphoma, NOS','Burkitt lymphoma, NOS',0,'WHO')
,('Hodgkin and non-Hodgkin lymphomas','Non-hodgkin lymphomas','Mature B-cell lymphomas',96893,'Splenic marginal zone B-cell lymphoma','Splenic marginal zone B-cell lymphoma',0,'WHO')
,('Hodgkin and non-Hodgkin lymphomas','Non-hodgkin lymphomas','Mature B-cell lymphomas',96903,'Follicular lymphoma, NOS','Follicular lymphoma, NOS',0,'WHO')
,('Hodgkin and non-Hodgkin lymphomas','Non-hodgkin lymphomas','Mature B-cell lymphomas',96913,'Follicular lymphoma, grade 2','Follicular lymphoma, grade 2',0,'WHO')
,('Hodgkin and non-Hodgkin lymphomas','Non-hodgkin lymphomas','Mature B-cell lymphomas',96953,'Follicular lymphoma, grade 1','Follicular lymphoma, grade 1',0,'WHO')
,('Hodgkin and non-Hodgkin lymphomas','Non-hodgkin lymphomas','Mature B-cell lymphomas',96983,'Follicular lymphoma, grade 3','Follicular lymphoma, grade 3',0,'WHO')
,('Hodgkin and non-Hodgkin lymphomas','Non-hodgkin lymphomas','Mature B-cell lymphomas',96993,'Marginal zone B-cell lymphoma, NOS','Marginal zone B-cell lymphoma, NOS',0,'WHO')
,('Hodgkin and non-Hodgkin lymphomas','Non-hodgkin lymphomas','Mature T- and NK-cell lymphomas',97003,'Mycosis fungoides','Mycosis fongo��de',1,'WHO')
,('Hodgkin and non-Hodgkin lymphomas','Non-hodgkin lymphomas','Mature T- and NK-cell lymphomas',97013,'Sezary syndrome','Sezary syndrome',0,'WHO')
,('Hodgkin and non-Hodgkin lymphomas','Non-hodgkin lymphomas','Mature T- and NK-cell lymphomas',97023,'Mature T-cell lymphoma, NOS','Mature T-cell lymphoma, NOS',0,'WHO')
,('Hodgkin and non-Hodgkin lymphomas','Non-hodgkin lymphomas','Mature T- and NK-cell lymphomas',97053,'Angioimmunoblastic T-cell lymphoma','Angioimmunoblastic T-cell lymphoma',0,'WHO')
,('Hodgkin and non-Hodgkin lymphomas','Non-hodgkin lymphomas','Mature T- and NK-cell lymphomas',97083,'Subcutaneous panniculitis-like T-cell lymphoma','Subcutaneous panniculitis-like T-cell lymphoma',0,'WHO')
,('Hodgkin and non-Hodgkin lymphomas','Non-hodgkin lymphomas','Mature T- and NK-cell lymphomas',97093,'Cutaneous T-cell lymphoma, NOS','Cutaneous T-cell lymphoma, NOS',0,'WHO')
,('Hodgkin and non-Hodgkin lymphomas','Non-hodgkin lymphomas','Mature T- and NK-cell lymphomas',97143,'Anaplastic large cell lymphoma, T cell and Null cell type','Anaplastic large cell lymphoma, T cell and Null cell type',0,'WHO')
,('Hodgkin and non-Hodgkin lymphomas','Non-hodgkin lymphomas','Mature T- and NK-cell lymphomas',97163,'Hepatosplenic  (gamma-delta) cell lymphoma','Hepatosplenic  (gamma-delta) cell lymphoma',0,'WHO')
,('Hodgkin and non-Hodgkin lymphomas','Non-hodgkin lymphomas','Mature T- and NK-cell lymphomas',97173,'Intestinal T-cell lymphoma','Intestinal T-cell lymphoma',0,'WHO')
,('Hodgkin and non-Hodgkin lymphomas','Non-hodgkin lymphomas','Mature T- and NK-cell lymphomas',97183,'Primary cutaneous CD30+ T-cell lymphoproliferative disorder','Primary cutaneous CD30+ T-cell lymphoproliferative disorder',0,'WHO')
,('Hodgkin and non-Hodgkin lymphomas','Non-hodgkin lymphomas','Mature T- and NK-cell lymphomas',97193,'NK/T-cell lymphoma, nasal and nasal-type','NK/T-cell lymphoma, nasal and nasal-type',0,'WHO')
,('Hodgkin and non-Hodgkin lymphomas','Non-hodgkin lymphomas','Precursor cell lymphoblastic lymphoma',97273,'Precursor cell lymphoblastic lymphoma, NOS','Precursor cell lymphoblastic lymphoma, NOS',0,'WHO')
,('Hodgkin and non-Hodgkin lymphomas','Non-hodgkin lymphomas','Precursor cell lymphoblastic lymphoma',97283,'Precursor B-cell lymphoblastic lymphoma','Precursor B-cell lymphoblastic lymphoma',0,'WHO')
,('Hodgkin and non-Hodgkin lymphomas','Non-hodgkin lymphomas','Precursor cell lymphoblastic lymphoma',97293,'Precursor T-cell lymphoblastic lymphoma','Precursor T-cell lymphoblastic lymphoma',0,'WHO')
,('Plasma cell tumors',NULL,NULL,97313,'Plasmacytoma, NOS','Plasmacytoma, NOS',0,'WHO')
,('Plasma cell tumors',NULL,NULL,97323,'Multiple myeloma','My̩lome multiple',1,'WHO')
,('Plasma cell tumors',NULL,NULL,97333,'Plasma cell leukemia','Plasma cell leukemia',0,'WHO')
,('Plasma cell tumors',NULL,NULL,97343,'Plasmacytoma, extramedullary (not occurring in bone)','Plasmacytoma, extramedullary (not occurring in bone)',0,'WHO')
,('Mast cell tumors',NULL,NULL,97401,'Mastocytoma, NOS','Mastocytoma, NOS',0,'WHO')
,('Mast cell tumors',NULL,NULL,97403,'Mast cell sarcoma','Sarcome �� mastocytes',1,'WHO')
,('Mast cell tumors',NULL,NULL,97413,'Malignant mastocytosis','Mastocytose maligne',1,'WHO')
,('Mast cell tumors',NULL,NULL,97423,'Mast cell leukemia','Mast cell leukemia',0,'WHO')
,('Neoplasms of histiocytes and accessory lymphoid cells',NULL,NULL,97503,'Malignant histiocytosis','Histiocytose maligne',1,'WHO')
,('Neoplasms of histiocytes and accessory lymphoid cells',NULL,NULL,97511,'Langerhans cell histiocytosis, NOS','Langerhans cell histiocytosis, NOS',0,'WHO')
,('Neoplasms of histiocytes and accessory lymphoid cells',NULL,NULL,97521,'Langerhans cell histiocytosis, unifocal','Langerhans cell histiocytosis, unifocal',0,'WHO')
,('Neoplasms of histiocytes and accessory lymphoid cells',NULL,NULL,97531,'Langerhans cell histiocytosis, multifocal','Langerhans cell histiocytosis, multifocal',0,'WHO')
,('Neoplasms of histiocytes and accessory lymphoid cells',NULL,NULL,97543,'Langerhans cell histiocytosis, disseminated','Langerhans cell histiocytosis, disseminated',0,'WHO')
,('Neoplasms of histiocytes and accessory lymphoid cells',NULL,NULL,97553,'Histiocytic sarcoma','Histiocytic sarcoma',0,'WHO')
,('Neoplasms of histiocytes and accessory lymphoid cells',NULL,NULL,97563,'Langerhans cell sarcoma','Langerhans cell sarcoma',0,'WHO')
,('Neoplasms of histiocytes and accessory lymphoid cells',NULL,NULL,97573,'Interdigitating dendritic cell sarcoma','Interdigitating dendritic cell sarcoma',0,'WHO')
,('Neoplasms of histiocytes and accessory lymphoid cells',NULL,NULL,97583,'Follicular dendritic cell sarcoma','Follicular dendritic cell sarcoma',0,'WHO')
,('Immunoproliferative diseases',NULL,NULL,97603,'Immunoproliferative disease, NOS','Immunoproliferative disease, NOS',0,'WHO')
,('Immunoproliferative diseases',NULL,NULL,97613,'Waldenstrom macroglobulinemia','Waldenstrom macroglobulinemia',0,'WHO')
,('Immunoproliferative diseases',NULL,NULL,97623,'Heavy chain disease, NOS','Heavy chain disease, NOS',0,'WHO')
,('Immunoproliferative diseases',NULL,NULL,97643,'Immunoproliferative small intestinal  disease','Immunoproliferative small intestinal  disease',0,'WHO')
,('Immunoproliferative diseases',NULL,NULL,97651,'Monoclonal gammopathy of undetermined significance','Monoclonal gammopathy of undetermined significance',0,'WHO')
,('Immunoproliferative diseases',NULL,NULL,97661,'Angiocentric immunoproliferative lesion','L̩sion immunoprolif̩rative angiocentrique',1,'WHO')
,('Immunoproliferative diseases',NULL,NULL,97671,'Angioimmunoblastic lymphadenopathy (AIC)','Angioimmunoblastic lymphadenopathy (AIC)',0,'WHO')
,('Immunoproliferative diseases',NULL,NULL,97681,'T-gamma lymphoproliferative disease','Maladie lymphoprolif̩rative, type T-gamma',1,'WHO')
,('Immunoproliferative diseases',NULL,NULL,97691,'Immunoglobulin deposition disease','Immunoglobulin deposition disease',0,'WHO')
,('Leukemias','Leukemias, NOS',NULL,98003,'Leukemia, NOS','Leuc����mie',1,'WHO')
,('Leukemias','Leukemias, NOS',NULL,98013,'Acute leukemia, NOS','Acute leukemia, NOS',0,'WHO')
,('Leukemias','Leukemias, NOS',NULL,98053,'Acute biphenotypic leukemia','Acute biphenotypic leukemia',0,'WHO')
,('Leukemias','Lymphoid leukemias',NULL,98203,'Lymphoid leukemia, NOS','Lymphoid leukemia, NOS',0,'WHO')
,('Leukemias','Lymphoid leukemias',NULL,98233,'B-cell chronic lymphocytic leukemia/small lymphocytic lymphoma','B-cell chronic lymphocytic leukemia/small lymphocytic lymphoma',0,'WHO')
,('Leukemias','Lymphoid leukemias',NULL,98263,'Burkitt cell leukemia','Burkitt cell leukemia',0,'WHO')
,('Leukemias','Lymphoid leukemias',NULL,98273,'Adult T-cell leukemia/lymphoma (HTLV-1 positive)','Adult T-cell leukemia/lymphoma (HTLV-1 positive)',0,'WHO')
,('Leukemias','Lymphoid leukemias',NULL,98311,'T-cell large granular lymphocytic leukemia','T-cell large granular lymphocytic leukemia',0,'WHO')
,('Leukemias','Lymphoid leukemias',NULL,98323,'Prolymphocytic leukemia, NOS','Prolymphocytic leukemia, NOS',0,'WHO')
,('Leukemias','Lymphoid leukemias',NULL,98333,'Prolymphocytic leukemia, B-cell type','Prolymphocytic leukemia, B-cell type',0,'WHO')
,('Leukemias','Lymphoid leukemias',NULL,98343,'Prolymphocytic leukemia, T-cell type','Prolymphocytic leukemia, T-cell type',0,'WHO')
,('Leukemias','Lymphoid leukemias',NULL,98353,'Precursor cell lymphoblastic leukemia, NOS','Precursor cell lymphoblastic leukemia, NOS',0,'WHO')
,('Leukemias','Lymphoid leukemias',NULL,98363,'Precursor B-cell lymphoblastic leukemia','Precursor B-cell lymphoblastic leukemia',0,'WHO')
,('Leukemias','Lymphoid leukemias',NULL,98373,'Precursor T-cell lymphoblastic leukemia','Precursor T-cell lymphoblastic leukemia',0,'WHO')
,('Leukemias','Myeloid leukemias',NULL,98403,'Acute myeloid leukemia, M6 type','Acute myeloid leukemia, M6 type',0,'WHO')
,('Leukemias','Myeloid leukemias',NULL,98603,'Myeloid leukemia, NOS','Myeloid leukemia, NOS',0,'WHO')
,('Leukemias','Myeloid leukemias',NULL,98613,'Acute myeloid leukemia, NOS','Acute myeloid leukemia, NOS',0,'WHO')
,('Leukemias','Myeloid leukemias',NULL,98633,'Chronic myeloid leukemia, NOS','Chronic myeloid leukemia, NOS',0,'WHO')
,('Leukemias','Myeloid leukemias',NULL,98663,'Acute promyelocytic leukemia','Acute promyelocytic leukemia',0,'WHO')
,('Leukemias','Myeloid leukemias',NULL,98673,'Acute myelomonocytic leukemia','Acute myelomonocytic leukemia',0,'WHO')
,('Leukemias','Myeloid leukemias',NULL,98703,'Acute basophilic leukemia','Acute basophilic leukemia',0,'WHO')
,('Leukemias','Myeloid leukemias',NULL,98713,'Acute myeloid leukemia with abnormal marrow eosinophils','Acute myeloid leukemia with abnormal marrow eosinophils',0,'WHO')
,('Leukemias','Myeloid leukemias',NULL,98723,'Acute myeloid leukemia, minimal differentiation','Acute myeloid leukemia, minimal differentiation',0,'WHO')
,('Leukemias','Myeloid leukemias',NULL,98733,'Acute myeloid leukemia without maturation','Acute myeloid leukemia without maturation',0,'WHO')
,('Leukemias','Myeloid leukemias',NULL,98743,'Acute myeloid leukemia with maturation','Acute myeloid leukemia with maturation',0,'WHO')
,('Leukemias','Myeloid leukemias',NULL,98753,'Chronic myelogenous leukemia, BCR/ABL  positive','Chronic myelogenous leukemia, BCR/ABL  positive',0,'WHO')
,('Leukemias','Myeloid leukemias',NULL,98763,'Atypical chronic myeloid leukemia, BCR/ABL negative','Atypical chronic myeloid leukemia, BCR/ABL negative',0,'WHO')
,('Leukemias','Myeloid leukemias',NULL,98913,'Acute monocytic leukemia','Acute monocytic leukemia',0,'WHO')
,('Leukemias','Myeloid leukemias',NULL,98953,'Acute myeloid leukemia with multilineage dysplasia','Acute myeloid leukemia with multilineage dysplasia',0,'WHO')
,('Leukemias','Myeloid leukemias',NULL,98963,'Acute myeloid leukemia, t(8','Acute myeloid leukemia, t(8',0,'WHO')
,('Leukemias','Myeloid leukemias',NULL,98973,'Acute myeloid leukemia, 11q23 abnormalities','Acute myeloid leukemia, 11q23 abnormalities',0,'WHO')
,('Leukemias','Myeloid leukemias',NULL,99103,'Acute megakaryoblastic leukemia','Acute megakaryoblastic leukemia',0,'WHO')
,('Leukemias','Myeloid leukemias',NULL,99203,'Therapy-related acute myeloid leukemia, NOS','Therapy-related acute myeloid leukemia, NOS',0,'WHO')
,('Leukemias','Myeloid leukemias',NULL,99303,'Myeloid sarcoma','Sarcome my̩lo��de',1,'WHO')
,('Leukemias','Myeloid leukemias',NULL,99313,'Acute panmyelosis with myelofibrosis','Acute panmyelosis with myelofibrosis',0,'WHO')
,('Leukemias','Other leukemias',NULL,99403,'Hairy cell leukemia','Hairy cell leukemia',0,'WHO')
,('Leukemias','Other leukemias',NULL,99453,'Chronic myelomonocytic leukemia, NOS','Chronic myelomonocytic leukemia, NOS',0,'WHO')
,('Leukemias','Other leukemias',NULL,99463,'Juvenile myelomonocytic leukemia','Juvenile myelomonocytic leukemia',0,'WHO')
,('Leukemias','Other leukemias',NULL,99483,'Aggressive NK-cell leukemia','Aggressive NK-cell leukemia',0,'WHO')
,('Chronic myeloproliferative disorders',NULL,NULL,99503,'Polycythemia vera','Polycythemia vera',0,'WHO')
,('Chronic myeloproliferative disorders',NULL,NULL,99603,'Chronic myeloproliferative disease, NOS','Chronic myeloproliferative disease, NOS',0,'WHO')
,('Chronic myeloproliferative disorders',NULL,NULL,99613,'Myelosclerosis with myeloid metaplasia','My̩loscl̩rose avec m̩taplasie my̩lo��de',1,'WHO')
,('Chronic myeloproliferative disorders',NULL,NULL,99623,'Essential thrombocythemia','Essential thrombocythemia',0,'WHO')
,('Chronic myeloproliferative disorders',NULL,NULL,99633,'Chronic neutrophilic leukemia','Chronic neutrophilic leukemia',0,'WHO')
,('Chronic myeloproliferative disorders',NULL,NULL,99643,'Hypereosinophilic syndrome','Hypereosinophilic syndrome',0,'WHO')
,('Other hematologic disorders',NULL,NULL,99701,'Lymphoproliferative disorder, NOS','Lymphoproliferative disorder, NOS',0,'WHO')
,('Other hematologic disorders',NULL,NULL,99751,'Myeloproliferative disease, NOS','Myeloproliferative disease, NOS',0,'WHO')
,('Myelodysplastic syndromes',NULL,NULL,99803,'Refractory anemia','Refractory anemia',0,'WHO')
,('Myelodysplastic syndromes',NULL,NULL,99823,'Refractory anemia with sideroblasts','Refractory anemia with sideroblasts',0,'WHO')
,('Myelodysplastic syndromes',NULL,NULL,99833,'Refractory anemia with excess blasts','Refractory anemia with excess blasts',0,'WHO')
,('Myelodysplastic syndromes',NULL,NULL,99843,'Refractory anemia with excess blasts in transformation','Refractory anemia with excess blasts in transformation',0,'WHO')
,('Myelodysplastic syndromes',NULL,NULL,99853,'Refractory cytopenia with multilineage dysplasia','Refractory cytopenia with multilineage dysplasia',0,'WHO')
,('Myelodysplastic syndromes',NULL,NULL,99863,'Myelodysplastic syndrome with 5q deletion (5q-) syndrome','Myelodysplastic syndrome with 5q deletion (5q-) syndrome',0,'WHO')
,('Myelodysplastic syndromes',NULL,NULL,99873,'Therapy-related myelodysplastic syndrome, NOS','Therapy-related myelodysplastic syndrome, NOS',0,'WHO')
,('Myelodysplastic syndromes',NULL,NULL,99893,'Myelodysplastic syndrome, NOS','Myelodysplastic syndrome, NOS',0,'WHO')
,('Squamous cell neoplasms',NULL,NULL,80712,'Sq. cell carcinoma, keratinizing, NOS, in situ','Sq. cell carcinoma, keratinizing, NOS, in situ',0,'SEER')
,('Squamous cell neoplasms',NULL,NULL,80722,'Sq. cell carcinoma, lg. cell, non-ker., in situ','Sq. cell carcinoma, lg. cell, non-ker., in situ',0,'SEER')
,('Adenomas and adenocarcinomas',NULL,NULL,82202,'Adenocarcinoma in situ in familial polyp. coli','Adenocarcinoma in situ in familial polyp. coli',0,'SEER')
,('Adenomas and adenocarcinomas',NULL,NULL,82212,'Adenocarc. in situ in mult. adenomatous polyps','Adenocarc. in situ in mult. adenomatous polyps',0,'SEER')
,('Ductal and lobular neoplasms',NULL,NULL,85232,'Infiltr. duct mixed with other types of carcinoma, in situ','Infiltr. duct mixed with other types of carcinoma, in situ',0,'SEER')
,('Complex epithelial neoplasms',NULL,NULL,85613,'Warthin tumor, malignant','Warthin tumor, malignant',0,'SEER')
,('Specialized gonadal neoplasms',NULL,NULL,85903,'Ovarian stromal tumor, mal.','Tumeur maligne des cordons sexuels et du stroma gonadique',1,'SEER')
,('Specialized gonadal neoplasms',NULL,NULL,86213,'Granulosa cell-theca cell tumor, mal.','Tumeur maligne de la granulosa et de la th����que',1,'SEER')
,('Specialized gonadal neoplasms',NULL,NULL,86323,'Gynandroblastoma, malignant','Gynandroblastome malin',1,'SEER')
,('Paragangliomas and glomus tumors',NULL,NULL,86913,'Aortic body tumor, malignant','Tumeur maligne du corpuscule aortique',1,'SEER')
,('Paragangliomas and glomus tumors',NULL,NULL,86923,'Carotid body tumor, malignant','Tumeur maligne du corpuscule carotidien',1,'SEER')
,('Nevi and melanomas',NULL,NULL,87432,'Superficial spreading melanoma, in situ','M����lanome ���� extension superficielle in situ',1,'SEER')
,('Trophoblastic neoplasms',NULL,NULL,91043,'Malignant placental site trophoblastic tumor','Tumeur trophoblastique maligne du site placentaire',1,'SEER')
,('Gliomas',NULL,NULL,94213,'Pilocytic astrocytoma','Pilocytic astrocytoma',0,'SEER')
,('Hodgkin and non-Hodgkin lymphomas','Malignant lymphomas, NOS or diffuse',NULL,95973,'Primary Cutaneous follicle centre lymphoma','Primary Cutaneous follicle centre lymphoma',0,'SEER')
,('Hodgkin and non-Hodgkin lymphomas','Non-hodgkin lymphomas','Mature B-cell lymphomas',96883,'T-cell histiocyte rich large B-cell lymphoma','T-cell histiocyte rich large B-cell lymphoma',0,'SEER')
,('Hodgkin and non-Hodgkin lymphomas','Non-hodgkin lymphomas','Mature T- and NK-cell lymphomas',97123,'Intravascular large B-cell lymphoma','Intravascular large B-cell lymphoma',0,'SEER')
,('Hodgkin and non-Hodgkin lymphomas','Non-hodgkin lymphomas','Precursor cell lymphoblastic lymphoma',97243,'SystemicEBV pos. T-cell lymphoproliferative disease of childhood','SystemicEBV pos. T-cell lymphoproliferative disease of childhood',0,'SEER')
,('Hodgkin and non-Hodgkin lymphomas','Non-hodgkin lymphomas','Precursor cell lymphoblastic lymphoma',97253,'Hydroa vacciniforme-like lymphoma','Hydroa vacciniforme-like lymphoma',0,'SEER')
,('Hodgkin and non-Hodgkin lymphomas','Non-hodgkin lymphomas','Precursor cell lymphoblastic lymphoma',97263,'Primary Cutaneous gamma-delta T-cell lymphoma','Primary Cutaneous gamma-delta T-cell lymphoma',0,'SEER')
,('Plasma cell tumors',NULL,NULL,97353,'Plasmablastic lymphoma','Plasmablastic lymphoma',0,'SEER')
,('Plasma cell tumors',NULL,NULL,97373,'ALK positive large B-cell lymphoma','ALK positive large B-cell lymphoma',0,'SEER')
,('Plasma cell tumors',NULL,NULL,97383,'Lrg B-cell lymphoma in HHV8-assoc. multicentric Castleman DZ','Lrg B-cell lymphoma in HHV8-assoc. multicentric Castleman DZ',0,'SEER')
,('Neoplasms of histiocytes and accessory lymphoid cells',NULL,NULL,97513,'Langerhans cell histiocytosis, NOS','Langerhans cell histiocytosis, NOS',0,'SEER')
,('Neoplasms of histiocytes and accessory lymphoid cells',NULL,NULL,97593,'Fibroblastic reticular cell tumor','Fibroblastic reticular cell tumor',0,'SEER')
,('Leukemias','Leukemias, NOS',NULL,98063,'Mixed phenotype acute leukemia with t(9;22)(q34;q11.2);BCR-ABL1','Mixed phenotype acute leukemia with t(9;22)(q34;q11.2);BCR-ABL1',0,'SEER')
,('Leukemias','Leukemias, NOS',NULL,98073,'Mixed phenotype acute leukemia with t(v;11q23);MLL rearranged','Mixed phenotype acute leukemia with t(v;11q23);MLL rearranged',0,'SEER')
,('Leukemias','Leukemias, NOS',NULL,98083,'Mixed phenotype acute leukemia, B/myeloid, NOS','Mixed phenotype acute leukemia, B/myeloid, NOS',0,'SEER')
,('Leukemias','Leukemias, NOS',NULL,98093,'Mixed phenotype acute leukemia, T/myeloid, NOS','Mixed phenotype acute leukemia, T/myeloid, NOS',0,'SEER')
,('Leukemias','Lymphoid leukemias',NULL,98113,'B lymphoblastic leukemia/lymphoma, NOS','B lymphoblastic leukemia/lymphoma, NOS',0,'SEER')
,('Leukemias','Lymphoid leukemias',NULL,98123,'Leukemia/lymphoma with t(9;22)(q34;q11.2);BCR-ABL1','Leukemia/lymphoma with t(9;22)(q34;q11.2);BCR-ABL1',0,'SEER')
,('Leukemias','Lymphoid leukemias',NULL,98133,'Leukemia/lymphoma with t(v;11q23);MLL rearranged','Leukemia/lymphoma with t(v;11q23);MLL rearranged',0,'SEER')
,('Leukemias','Lymphoid leukemias',NULL,98143,'Leukemia/lymphoma with t(12;21)(p13;q22);TEL-AML1(ETV6-RUNX1)','Leukemia/lymphoma with t(12;21)(p13;q22);TEL-AML1(ETV6-RUNX1)',0,'SEER')
,('Leukemias','Lymphoid leukemias',NULL,98153,'B lymphoblastic leukemia/lymphoma with hyperdiploidy','B lymphoblastic leukemia/lymphoma with hyperdiploidy',0,'SEER')
,('Leukemias','Lymphoid leukemias',NULL,98163,'Leukemia/lymphoma with hypodiploidy (hypodiploid ALL)','Leukemia/lymphoma with hypodiploidy (hypodiploid ALL)',0,'SEER')
,('Leukemias','Lymphoid leukemias',NULL,98173,'B lymphblastic leukemia/lymphoma with t(5;14)(q31;q32);IL3-IGH','B lymphblastic leukemia/lymphoma with t(5;14)(q31;q32);IL3-IGH',0,'SEER')
,('Leukemias','Lymphoid leukemias',NULL,98183,'Leukemia/lymphoma with t(1;19)(q23;p13.3); E2A PBX1 (TCF3 PBX1)','Leukemia/lymphoma with t(1;19)(q23;p13.3); E2A PBX1 (TCF3 PBX1)',0,'SEER')
,('Leukemias','Lymphoid leukemias',NULL,98283,'Acute lymphoblastic leukemia, L2 type, NOS','Acute lymphoblastic leukemia, L2 type, NOS',0,'SEER')
,('Leukemias','Lymphoid leukemias',NULL,98313,'T-cell large granular lymphocytic leukemia','T-cell large granular lymphocytic leukemia',0,'SEER')
,('Leukemias','Myeloid leukemias',NULL,98653,'Acute myeloid leukemia with t(6;9)(p23;q34) DEK-NUP214','Acute myeloid leukemia with t(6;9)(p23;q34) DEK-NUP214',0,'SEER')
,('Leukemias','Myeloid leukemias',NULL,98693,'Acute myeloid leukemia with inv(3)(q21q26.2) or t(3;3)(q21;q26.2);RPN1EVI1','Acute myeloid leukemia with inv(3)(q21q26.2) or t(3;3)(q21;q26.2);RPN1EVI1',0,'SEER')
,('Leukemias','Myeloid leukemias',NULL,98983,'Myeloid leukemia associated with Down Syndrome','Myeloid leukemia associated with Down Syndrome',0,'SEER')
,('Leukemias','Myeloid leukemias',NULL,99113,'Acute myeloid leukemia (megakaryoblastic) with t(1;22)(p13;q13);RBM15-MLK1','Acute myeloid leukemia (megakaryoblastic) with t(1;22)(p13;q13);RBM15-MLK1',0,'SEER')
,('Chronic myeloproliferative disorders',NULL,NULL,99653,'Myeloid and lymphoid neoplasms with PDGFRB rearrangement','Myeloid and lymphoid neoplasms with PDGFRB rearrangement',0,'SEER')
,('Chronic myeloproliferative disorders',NULL,NULL,99663,'Myeloid and lymphoid neoplasms with PDGFRB re arrangement','Myeloid and lymphoid neoplasms with PDGFRB re arrangement',0,'SEER')
,('Chronic myeloproliferative disorders',NULL,NULL,99673,'Myeloid and lymphoid neoplasm with FGFR1 abnormalities','Myeloid and lymphoid neoplasm with FGFR1 abnormalities',0,'SEER')
,('Other hematologic disorders',NULL,NULL,99713,'Polymorphic PTLD','Polymorphic PTLD',0,'SEER')
,('Other hematologic disorders',NULL,NULL,99753,'Myelodysplastic/Myeloproliferative neoplasm, unclassifiable','Myelodysplastic/Myeloproliferative neoplasm, unclassifiable',0,'SEER')
,('Myelodysplastic syndromes',NULL,NULL,99913,'Refractory neutropenia','Refractory neutropenia',0,'SEER')
,('Myelodysplastic syndromes',NULL,NULL,99923,'Refractory thrombocytopenia','Refractory thrombocytopenia',0,'SEER')
,(NULL,NULL,NULL,0,'Other','Autre',1,'CFRI');

-- Add three read only fields in the oncology diagnosis form 

ALTER TABLE dxd_bcch_oncology
	ADD COLUMN `final_diagnosis_primary_category` VARCHAR(255) DEFAULT NULL AFTER `diagnosis_department`,
	ADD COLUMN `final_diagnosis_secondary_category` VARCHAR(255) DEFAULT NULL AFTER `final_diagnosis_primary_category`,
	ADD COLUMN `final_diagnosis_tertiary_category` VARCHAR(255) DEFAULT NULL AFTER `final_diagnosis_secondary_category`;

ALTER TABLE dxd_bcch_oncology_revs
	ADD COLUMN `final_diagnosis_primary_category` VARCHAR(255) DEFAULT NULL AFTER `diagnosis_department`,
	ADD COLUMN `final_diagnosis_secondary_category` VARCHAR(255) DEFAULT NULL AFTER `final_diagnosis_primary_category`,
	ADD COLUMN `final_diagnosis_tertiary_category` VARCHAR(255) DEFAULT NULL AFTER `final_diagnosis_secondary_category`;

INSERT INTO structure_fields
(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcch_oncology', 'final_diagnosis_primary_category','Primary Category of Final Diagnosis', '', 'input', '', NULL, 'Primary Category according to ICD-O-3 Third Edition', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcch_oncology', 'final_diagnosis_secondary_category','Secondary Category of Final Diagnosis', '', 'input', '', NULL, 'Secondary Category according to ICD-O-3 Third Edition', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcch_oncology', 'final_diagnosis_tertiary_category','Tertiary Category of Final Diagnosis', '', 'input', '', NULL, 'Tertiary Category according to ICD-O-3 Third Edition', 'open', 'open', 'open', 0);

-- Move the Final Diagnosis Field to the bottom, but before the Notes

UPDATE structure_formats
SET `display_order` = 30
WHERE structure_id = (SELECT `id` FROM structures WHERE `alias` = 'dx_bcch_oncology')
AND structure_field_id = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` ='DiagnosisDetail' AND `tablename` = 'dxd_bcch_oncology' AND `field` = 'final_diagnosis' AND `type` = 'autocomplete');

INSERT INTO structure_formats
(`structure_id`, `structure_field_id`,
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `flag_override_tag`, `flag_override_help`,
`flag_override_type`, `flag_override_setting`, `flag_override_default`, `default`,
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_editgrid`, `flag_editgrid_readonly`,
`flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcch_oncology'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcch_oncology' AND `field` = 'final_diagnosis_primary_category' AND `type`='input'),
1, 24, '', 0, 0, 0,
0, 0, 0, '',
0, 1, 0, 1, 1, 0, 0, 0,
0, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcch_oncology'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcch_oncology' AND `field` = 'final_diagnosis_secondary_category' AND `type`='input'),
1, 26, '', 0, 0, 0,
0, 0, 0, '',
0, 1, 0, 1, 1, 0, 0, 0,
0, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcch_oncology'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcch_oncology' AND `field` = 'final_diagnosis_tertiary_category' AND `type`='input'),
1, 28, '', 0, 0, 0,
0, 0, 0, '',
0, 1, 0, 1, 1, 0, 0, 0,
0, 0, 0, 1, 1, 0, 0);

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('Primary Category of Final Diagnosis', 'Primary Category of Final Diagnosis', ''),
('Secondary Category of Final Diagnosis', 'Secondary Category of Final Diagnosis', ''),
('Tertiary Category of Final Diagnosis', 'Tertiary Category of Final Diagnosis', '');

-- ============================================================================
-- BB-136
-- ============================================================================

-- Make the consent form version mandatory
INSERT INTO structure_validations
(`structure_field_id`, `rule`, `language_message`)
VALUES
((SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model` = 'ConsentMaster' AND `tablename`='consent_masters' AND `field` = 'form_version' AND `type` = 'select'), 'notEmpty', 'Consent Form Version is required');

-- Add the version number
UPDATE structure_permissible_values_custom_controls
SET `values_max_length` = 100, `values_used_as_input_counter` = 3, `values_counter` = 6
WHERE `name` = 'Consent Form Versions';

INSERT INTO structure_permissible_values_customs 
(`control_id`, `value`, `en`, `fr`, `display_order`, `use_as_input`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Consent Form Versions'), 'BCCHB Children’s Consent Form Nov 2 2015', 'BCCHB Children’s Consent Form Nov 2 2015', 'BCCHB Children’s Consent Form Nov 2 2015', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Consent Form Versions'), 'BCCHB Womens’s Consent Form Nov 14 2014', 'BCCHB Womens’s Consent Form Nov 14 2014', 'BCCHB Womens’s Consent Form Nov 14 2014', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Consent Form Versions'), 'BCCHB Maternal Consent Form April 8 2015', 'BCCHB Maternal Consent Form April 8 2015', 'BCCHB Maternal Consent Form April 8 2015', 0, 0, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Consent Form Versions'), 'BCCHB Maternal Consent Form April 9 2015', 'BCCHB Maternal Consent Form April 9 2015', 'BCCHB Maternal Consent Form April 9 2015', 0, 0, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Consent Form Versions'), 'BCCHB Maternal Consent Form Dec 10 2015', 'BCCHB Maternal Consent Form Dec 10 2015', 'BCCHB Maternal Consent Form Dec 10 2015', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Consent Form Versions'), 'CCBR Consent Form', 'CCBR Consent Form', 'CCBR Consent Form', 0, 0, NOW(), 1, NOW(), 1, 0);

-- Disable the old options
UPDATE structure_permissible_values_customs
SET `use_as_input` = 0
WHERE `control_id` = (SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Consent Form Versions')
AND (`value` = '1.0' OR `value` = '2.0' OR `value` = '3.0'); 

-- Remove the old options from database to avoid confusion in configuration

DELETE FROM structure_permissible_values_customs WHERE `control_id` = (SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Consent Form Versions') 
AND (`value` = '1.0' OR `value` = '2.0' OR `value` = '3.0');

-- Unsafe statement warning

-- Assign all CCBR Consent Form into one version
UPDATE consent_masters
SET `form_version` = 'CCBR Consent Form'
WHERE `consent_control_id` = (SELECT `id` FROM consent_controls WHERE `controls_type` = 'ccbr consent');

UPDATE consent_masters_revs
SET `form_version` = 'CCBR Consent Form'
WHERE `consent_control_id` = (SELECT `id` FROM consent_controls WHERE `controls_type` = 'ccbr consent');

-- All BCCH Children form has only one version at the moment
UPDATE consent_masters
SET `form_version` = 'BCCHB Children’s Consent Form Nov 2 2015'
WHERE `consent_control_id` = (SELECT `id` FROM consent_controls WHERE `controls_type` = 'BCCH Consent');

UPDATE consent_masters_revs
SET `form_version` = 'BCCHB Children’s Consent Form Nov 2 2015'
WHERE `consent_control_id` = (SELECT `id` FROM consent_controls WHERE `controls_type` = 'BCCH Consent');

-- For BCWH Women
-- C01653 has a 2.0 form. the rest are 1.0

UPDATE consent_masters
SET `form_version` = 'BCCHB Womens’s Consent Form Nov 14 2014'
WHERE `consent_control_id` = (SELECT `id` FROM consent_controls WHERE `controls_type` = 'BCWH Consent');

UPDATE consent_masters_revs
SET `form_version` = 'BCCHB Womens’s Consent Form Nov 14 2014'
WHERE `consent_control_id` = (SELECT `id` FROM consent_controls WHERE `controls_type` = 'BCWH Consent');

-- For BCWH Maternal
-- 1.0 vs 2.0

UPDATE consent_masters
SET `form_version` = 'BCCHB Maternal Consent Form April 9 2015'
WHERE `consent_control_id` = (SELECT `id` FROM consent_controls WHERE `controls_type` = 'BCWH Maternal Consent')
AND `form_version` = '1.0';

UPDATE consent_masters_revs
SET `form_version` = 'BCCHB Maternal Consent Form April 9 2015'
WHERE `consent_control_id` = (SELECT `id` FROM consent_controls WHERE `controls_type` = 'BCWH Maternal Consent')
AND `form_version` = '1.0';

UPDATE consent_masters
SET `form_version` = 'BCCHB Maternal Consent Form Dec 10 2015'
WHERE `consent_control_id` = (SELECT `id` FROM consent_controls WHERE `controls_type` = 'BCWH Maternal Consent')
AND `form_version` = '2.0';

UPDATE consent_masters_revs
SET `form_version` = 'BCCHB Maternal Consent Form Dec 10 2015'
WHERE `consent_control_id` = (SELECT `id` FROM consent_controls WHERE `controls_type` = 'BCWH Maternal Consent')
AND `form_version` = '2.0';


-- ============================================================================
-- BB-200
-- ============================================================================

-- Remove 86913, 86923, 86213, 86323, 85613, 85232 from the coding dictionary
-- Confirmed it is not in the current en_bcch_dx_codes table

DELETE FROM coding_icd_o_3_morphology
WHERE `id` IN (86913, 86923, 86213, 86323, 85613, 85232);

-- Add 9971/1

INSERT INTO coding_icd_o_3_morphology
(`primary_category`, `id`, `en_description`, `fr_description`)
VALUES
('Other hematologic disorders', 99711, 'Post transplant lymphoproliferative disorder, NOS', 'Post transplant lymphoproliferative disorder, NOS');

-- Remove 97511, 91043, 94213, 87432, 98311, 80712, 80722
-- Attention: 98311

DELETE FROM coding_icd_o_3_morphology
WHERE `id` IN (97511, 91043, 94213, 87432, 98311, 80712, 80722);

-- Update the text of 99663, 99653, 99713, 97243 to match the WHO book

UPDATE coding_icd_o_3_morphology
SET `en_description` = 'Myeloid and lymphoid neoplasms with PDGFRB rearrangement', `source` = 'WHO'
WHERE `en_description` = 'Myeloid and lymphoid neoplasms with PDGFRB re arrangement' AND `id` = '99663';

UPDATE coding_icd_o_3_morphology
SET `en_description` = 'Myeloid and lymphoid neoplasms with PDGFRA rearrangement', `source` = 'WHO'
WHERE `en_description` = 'Myeloid and lymphoid neoplasms with PDGFRB rearrangement' AND `id` = '99653';

UPDATE coding_icd_o_3_morphology
SET `en_description` = 'Polymorphic post transplant lymphoproliferative disorder', `source` = 'WHO'
WHERE `en_description` = 'Polymorphic PTLD' AND `id` = '99713';

UPDATE coding_icd_o_3_morphology
SET `en_description` = 'Systemic EBV positive T-cell lymphoproliferative disease of childhood', `source` = 'WHO'
WHERE `en_description` = 'SystemicEBV pos. T-cell lymphoproliferative disease of childhood' AND `id` = '97243';


-- 90911 should be germ cell neoplasms
UPDATE coding_icd_o_3_morphology
SET `primary_category` = 'Germ cell neoplasms'
WHERE `en_description` = 'Strumal carcinoid' AND `id` = 90911;


-- 97593, 97253, 97123, 97513, 98133, 98123, 98183, 98143, 98163, 97383, 98063, 98073, 98083, 98093, 99753, 99673, 99663, 97353, 95973, 97263, 99913, 99923, 98313, 85613 should be WHO instead of SEER 

UPDATE coding_icd_o_3_morphology
SET `source` = 'WHO'
WHERE `id` IN (97593, 97253, 97123, 97513, 98133, 98123, 98183, 98143, 98163, 97383, 98063, 98073, 98083, 98093, 99753, 99673, 99663, 97353, 95973, 97263, 99913, 99923, 98313, 85613);

-- 98963 description is incorrect

UPDATE coding_icd_o_3_morphology
SET `en_description` = 'Acute myeloid leukemia, t(8;21)(q22;q22)', `fr_description` = 'Acute myeloid leukemia, t(8;21)(q22;q22)'
WHERe `id` = 98963;

-- Need to update final diagnosis and code description of 98311 in ed_bcch_dx_codes
-- Change it to 98313

UPDATE ed_bcch_dx_codes
SET `code_value` = 98313
WHERE `code_value` = 98311 AND `code_type` = 'icd-o-3';

UPDATE ed_bcch_dx_codes_revs
SET `code_value` = 98313
WHERE `code_value` = 98311 AND `code_type` = 'icd-o-3';
 
-- Remove 98311 entry from the reference and set 98313 to WHO 

DELETE FROM coding_icd_o_3_morphology WHERE `id` = 98311 AND `en_description` = 'T-cell large granular lymphocytic leukemia';

UPDATE coding_icd_o_3_morphology
SET `source` = 'WHO'
WHERE `id` = 98313 AND `en_description` = 'T-cell large granular lymphocytic leukemia';

-- Attention: Pilocytic astrocytoma, remove the entry 94213 from the reference

DELETE FROM coding_icd_o_3_morphology WHERE `id` = 94213 AND `en_description` = 'Pilocytic astrocytoma';

-- Attention: Langerhans cell histiocytosis, NOS, remove 97511

DELETE FROM coding_icd_o_3_morphology WHERE `id` = 97511 AND `en_description` = 'Langerhans cell histiocytosis, NOS';

UPDATE coding_icd_o_3_morphology
SET `source` = 'WHO'
WHERE `id` = 97513 AND `en_description` = 'Langerhans cell histiocytosis, NOS';

-- Update the old Oncology diagnosis data fields

UPDATE dxd_bcch_oncology, coding_icd_o_3_morphology
SET dxd_bcch_oncology.final_diagnosis_primary_category = coding_icd_o_3_morphology.primary_category,
dxd_bcch_oncology.final_diagnosis_secondary_category = coding_icd_o_3_morphology.secondary_category,
dxd_bcch_oncology.final_diagnosis_tertiary_category = coding_icd_o_3_morphology.tertiary_category
WHERE dxd_bcch_oncology.final_diagnosis = coding_icd_o_3_morphology.en_description;

-- ============================================================================
-- BB-201
-- ============================================================================

ALTER TABLE participants
	ADD COLUMN `participant_category` VARCHAR(45) AFTER `ccbr_referral_clinic`;

ALTER TABLE participants_revs
	ADD COLUMN `participant_category` VARCHAR(45) AFTER `ccbr_referral_clinic`;	

INSERT INTO structure_value_domains (`domain_name`, `override`, `source`) VALUES
('participant_category', 'open', NULL);

INSERT INTO structure_permissible_values (`value`, `language_alias`) VALUES
('Biobank Only', 'Biobank Only'),
('Study Only', 'Study Only'),
('Biobank and Study', 'Biobank and Study');

INSERT INTO structure_value_domains_permissible_values
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`)
VALUES
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'participant_category'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'Biobank Only'), 1, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'participant_category'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'Study Only'), 2, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'participant_category'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'Biobank and Study'), 3, 1, 1);

INSERT INTO structure_fields
(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'participant_category','Participant Category', '', 'select', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'participant_category'), 'Identify if a participant is a biobank or study participant', 'open', 'open', 'open', 0);


INSERT INTO structure_formats
(`structure_id`, `structure_field_id`,
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `flag_override_tag`, `flag_override_help`,
`flag_override_type`, `flag_override_setting`, `flag_override_default`, `default`,
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_editgrid`, `flag_editgrid_readonly`,
`flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias` = 'participants'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='Participant' AND `tablename`='participants' AND `field` = 'participant_category' AND `type`='select'),
1, 0, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
0, 0, 0, 1, 1, 0, 0);

UPDATE structure_formats
SET `flag_index` = 0
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'participants')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='Participant' AND `tablename`='participants' AND `field` = 'ccbr_age_at_death' AND `type`='integer');

-- Make the Participant category field mandatory

INSERT INTO structure_validations
(`structure_field_id`, `rule`, `language_message`)
VALUES
((SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='Participant' AND `tablename`='participants' AND `field` = 'participant_category' AND `type`='select'), 'notEmpty', 'Participant Category is required');


REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('Participant Category', 'Participant Category', ''),
('Biobank Only', 'Biobank Only', ''),
('Study Only', 'Study Only', ''),
('Biobank and Study', 'Biobank and Study', ''),
('Participant category is required', 'Participant category is required', '');

-- ============================================================================
-- BB-202
-- ============================================================================

UPDATE structure_formats
SET `flag_override_label` = 1, `language_label` = 'order_application number'
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'orders')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'Order' AND `model` = 'Order' AND `tablename` = 'orders' AND `field` = 'order_number' AND `type` = 'input');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('order_application number', 'Order Application Number', '');

INSERT INTO structure_validations
(`structure_field_id`, `rule`, `language_message`)
VALUES
((SELECT `id` FROM structure_fields WHERE `plugin`='Order' AND `model`='Order' AND `tablename`='orders' AND `field` = 'order_number' AND `type`='input'), 'custom,/^[A-Z]{7}[0-9]{3}$/', 'Order Application Number must begin with 7 letters and follow by 3 numbers'),
((SELECT `id` FROM structure_fields WHERE `plugin`='Order' AND `model`='Order' AND `tablename`='orders' AND `field` = 'order_number' AND `type`='input'), 'isUnique', 'Order Application Number must be unique');

-- ============================================================================
-- BB-205
-- ============================================================================

CREATE TABLE dxd_bcch_orthopedics (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`diagnosis_department` varchar(100) DEFAULT NULL,
	`diagnosis` varchar(40) DEFAULT NULL,
	`other_conditions_status` varchar(20) DEFAULT NULL,
	`other_conditions_desc` varchar(100) DEFAULT NULL,
	`diagnosis_master_id` int(11) DEFAULT NULL,
	PRIMARY KEY(`id`),
	CONSTRAINT `FK_dxd_bcch_orthopedics_diagnosis_masters` FOREIGN KEY(`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE dxd_bcch_orthopedics_revs (
	`id` int(11) NOT NULL,
	`diagnosis_department` varchar(100) DEFAULT NULL,
	`diagnosis` varchar(40) DEFAULT NULL,
	`other_conditions_status` varchar(20) DEFAULT NULL,
	`other_conditions_desc` varchar(100) DEFAULT NULL,
	`diagnosis_master_id` int(11) DEFAULT NULL,
	`version_id` int(11) AUTO_INCREMENT,
	`version_created` datetime NOT NULL,
	PRIMARY KEY(`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO structures (`alias`, `description`) VALUES
('dx_bcch_orthopedics', NULL);

INSERT INTO structure_value_domains (`domain_name`, `override`, `source`) VALUES
('orthopedics_diagnosis', 'open', 'StructurePermissibleValuesCustom::getCustomDropdown(''Orthopedics Diagnosis'')');

INSERT INTO structure_permissible_values_custom_controls
(`name`, `flag_active`, `values_max_length`, `category`, `values_used_as_input_counter`, `values_counter`)
VALUES
('Orthopedics Diagnosis', 1, 50, 'Clinical - Diagnosis', 2, 2);

INSERT INTO structure_permissible_values_customs
(`control_id`, `value`, `en`, `fr`, `display_order`, `use_as_input`, `created`, `created_by`, `modified`, `modified_by`, `deleted`)
VALUES
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Orthopedics Diagnosis'), 'Idiopathic Scoliosis', 'Idiopathic Scoliosis', '', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Orthopedics Diagnosis'), 'Non-Idiopathic Scoliosis', 'Non-Idiopathic Scoliosis', '', 0, 1, NOW(), 1, NOW(), 1, 0);

INSERT INTO diagnosis_controls (`category`, `controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_compare_with_cap`)
VALUES
('primary', 'orthopedics', 1, 'dx_primary,dx_bcch_orthopedics', 'dxd_bcch_orthopedics', 0, 'primary|orthopedics', 1);

INSERT INTO structure_fields
(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcch_orthopedics', 'diagnosis_department', 'diagnosis department', '', 'select', '', (SELECT id FROM structure_value_domains WHERE `domain_name` = 'bcch_departments'), '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcch_orthopedics', 'diagnosis', 'diagnosis', '', 'select', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'orthopedics_diagnosis'), '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcch_orthopedics', 'other_conditions_status', 'other known existing conditions', '', 'select', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'ccbr_yesnounknown'), '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcch_orthopedics', 'other_conditions_desc', '', 'description of conditions', 'input', '', NULL, '', 'open', 'open', 'open', 0);

INSERT INTO structure_formats
(`structure_id`, `structure_field_id`,
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `flag_override_tag`, `language_tag`, `flag_override_help`,
`flag_override_type`, `flag_override_setting`, `flag_override_default`, `default`,
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_editgrid`, `flag_editgrid_readonly`,
`flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcch_orthopedics'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field` = 'dx_date' AND `type`='date'),
1, 3, '', 0, 0, '', 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcch_orthopedics'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcch_orthopedics' AND `field` = 'diagnosis_department' AND `type`='select'),
1, 5, '', 0, 0, '', 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
0, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcch_orthopedics'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcch_orthopedics' AND `field` = 'diagnosis' AND `type`='select'),
1, 7, '', 0, 0, '', 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
0, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcch_orthopedics'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcch_orthopedics' AND `field` = 'other_conditions_status' AND `type`='select'),
1, 9, '', 0, 0, '', 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
0, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcch_orthopedics'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcch_orthopedics' AND `field` = 'other_conditions_desc' AND `type`='input'),
1, 11, '', 0, 1, 'if yes', 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
0, 0, 0, 0, 1, 0, 0);

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('orthopedics', 'Orthopedics', '');


-- ============================================================================
-- BB-206
-- ============================================================================

CREATE TABLE dxd_bcch_ent (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`diagnosis_department` varchar(100) DEFAULT NULL,
	`diagnosis` varchar(40) DEFAULT NULL,
	`other_conditions_status` varchar(20) DEFAULT NULL,
	`other_conditions_desc` varchar(100) DEFAULT NULL,
	`diagnosis_master_id` int(11) DEFAULT NULL,
	PRIMARY KEY(`id`),
	CONSTRAINT `FK_dxd_bcch_ent_diagnosis_masters` FOREIGN KEY(`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE dxd_bcch_ent_revs (
	`id` int(11) NOT NULL,
	`diagnosis_department` varchar(100) DEFAULT NULL,
	`diagnosis` varchar(40) DEFAULT NULL,
	`other_conditions_status` varchar(20) DEFAULT NULL,
	`other_conditions_desc` varchar(100) DEFAULT NULL,
	`diagnosis_master_id` int(11) DEFAULT NULL,
	`version_id` int(11) AUTO_INCREMENT,
	`version_created` datetime NOT NULL,
	PRIMARY KEY(`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO structures (`alias`, `description`) VALUES
('dx_bcch_ent', NULL);

INSERT INTO structure_value_domains (`domain_name`, `override`, `source`) VALUES
('ent_diagnosis', 'open', 'StructurePermissibleValuesCustom::getCustomDropdown(''ENT Diagnosis'')');

INSERT INTO structure_permissible_values_custom_controls
(`name`, `flag_active`, `values_max_length`, `category`, `values_used_as_input_counter`, `values_counter`)
VALUES
('ENT Diagnosis', 1, 50, 'Clinical - Diagnosis', 2, 2);

INSERT INTO structure_permissible_values_customs
(`control_id`, `value`, `en`, `fr`, `display_order`, `use_as_input`, `created`, `created_by`, `modified`, `modified_by`, `deleted`)
VALUES
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'ENT Diagnosis'), 'Sleep Apnea', 'Sleep Apnea', '', 0, 1, NOW(), 1, NOW(), 1, 0);

INSERT INTO diagnosis_controls (`category`, `controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_compare_with_cap`)
VALUES
('primary', 'ent', 1, 'dx_primary,dx_bcch_ent', 'dxd_bcch_ent', 0, 'primary|ent', 1);

INSERT INTO structure_fields
(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcch_ent', 'diagnosis_department', 'diagnosis department', '', 'select', '', (SELECT id FROM structure_value_domains WHERE `domain_name` = 'bcch_departments'), '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcch_ent', 'diagnosis', 'diagnosis', '', 'select', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'ent_diagnosis'), '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcch_ent', 'other_conditions_status', 'other known existing conditions', '', 'select', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'ccbr_yesnounknown'), '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcch_ent', 'other_conditions_desc', '', 'description of conditions', 'input', '', NULL, '', 'open', 'open', 'open', 0);


INSERT INTO structure_formats
(`structure_id`, `structure_field_id`,
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `flag_override_tag`, `language_tag`, `flag_override_help`,
`flag_override_type`, `flag_override_setting`, `flag_override_default`, `default`,
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_editgrid`, `flag_editgrid_readonly`,
`flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcch_ent'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field` = 'dx_date' AND `type`='date'),
1, 3, '', 0, 0, '', 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcch_ent'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcch_ent' AND `field` = 'diagnosis_department' AND `type`='select'),
1, 5, '', 0, 0, '', 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
0, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcch_ent'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcch_ent' AND `field` = 'diagnosis' AND `type`='select'),
1, 7, '', 0, 0, '', 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
0, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcch_ent'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcch_ent' AND `field` = 'other_conditions_status' AND `type`='select'),
1, 9, '', 0, 0, '', 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
0, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcch_ent'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcch_ent' AND `field` = 'other_conditions_desc' AND `type`='input'),
1, 11, '', 0, 1, 'if yes', 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
0, 0, 0, 0, 1, 0, 0);

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('ent', 'ENT', ''),
('diagnosis department', 'Diagnosis Department', ''),
('if yes', 'If Yes', ''),
('other known existing conditions', 'Other Known Existing Conditions', '');

-- ============================================================================
-- BB-211
-- ============================================================================

INSERT INTO structure_permissible_values 
(`value`, `language_alias`) VALUES
('not obtained', 'not obtained');

INSERT INTo structure_value_domains_permissible_values
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`)
VALUES
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'consent_status'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'not obtained'), 6, 1, 1);

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('not obtained', 'Not Obtained', '');

-- ============================================================================
-- BB-213
-- ============================================================================

CREATE TABLE txe_radiations (
	`dose_cgy` VARCHAR(45) DEFAULT NULL,
	`ccbr_rad_site` VARCHAR(100),
	`treatment_extend_master_id` int(11) NOT NULL,
	CONSTRAINT `FK_txe_radiations_treatment_extend_masters` FOREIGN KEY(`treatment_extend_master_id`) REFERENCES `treatment_extend_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE txe_radiations_revs (
	`dose_cgy` VARCHAR(45)  DEFAULT NULL,
	`ccbr_rad_site` VARCHAR(100),
	`version_id` int(11) AUTO_INCREMENT,
	`version_created` datetime NOT NULL,
	`treatment_extend_master_id` int(11) NOT NULL,
	PRIMARY KEY(`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO structure_fields 
(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES
('ClinicalAnnotation', 'TreatmentExtendDetail', 'txe_radiations', 'ccbr_rad_site', 'ccbr rad site', '', 'select', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'ccbr_treatment_site'), '', 'open', 'open', 'open', 0);

INSERT INTO structure_formats
(`structure_id`, `structure_field_id`,
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `flag_override_tag`, `language_tag`, `flag_override_help`,
`flag_override_type`, `flag_override_setting`, `flag_override_default`, `default`,
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`,
`flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias` = 'txe_radiations'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='TreatmentExtendDetail' AND `tablename`='txe_radiations' AND `field` = 'ccbr_rad_site' AND `type`='select'),
1, 2, '', 0, 0, '', 0,
0, 0, 0, '',
0, 0, 1, 0, 1, 0, 
1, 0, 0, 0,
1, 0, 0, 1, 0, 0, 0);

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('Radiation Site', 'Radiation Site', ''),
('general', 'General', '');

-- Size update for final diagnosis field in Oncology

UPDATE structure_fields
SET `setting` = 'size=40,url=/CodingIcd/CodingIcdo3s/autocomplete/morpho'
WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'DiagnosisDetail' AND `tablename` = 'dxd_bcch_oncology' AND `field` = 'final_diagnosis' AND `type` = 'autocomplete';

-- Demonliazation

-- Participant Table --

-- First Name --

UPDATE `participants` SET `first_name` = cast(SHA1(`first_name`) AS CHAR(20) CHARACTER SET utf8);

-- Middle Name --

UPDATE `participants` SET `middle_name` = cast(SHA1(`middle_name`) AS CHAR(20) CHARACTER SET utf8);

-- Last Name --

UPDATE `participants` SET `last_name` = cast(SHA1(`last_name`) AS CHAR(20) CHARACTER SET utf8);

-- Date of Birth --

UPDATE `participants` SET `date_of_birth` = DATE_ADD(`date_of_birth`, INTERVAL FLOOR(1000*RAND()) DAY);

-- Parent or Guardian Name --

UPDATE `participants` SET `ccbr_parent_guardian_name` = cast(SHA1(`ccbr_parent_guardian_name`) AS CHAR(20) CHARACTER SET utf8);

-- Participant log tables --

UPDATE `participants`, `participants_revs`
SET `participants_revs`.`first_name` = `participants`.`first_name`,
`participants_revs`.`middle_name` = `participants`.`middle_name`,
`participants_revs`.`last_name` = `participants`.`last_name`,
`participants_revs`.`date_of_birth` = `participants`.`date_of_birth`,
`participants_revs`.`ccbr_parent_guardian_name` = `participants`.`ccbr_parent_guardian_name`
WHERE `participants`.`id` = `participants_revs`.`id`;

-- Identifiers Table --

-- COG --

UPDATE `misc_identifiers` SET `identifier_value` = CAST(SHA1(`identifier_value`) AS CHAR(6) CHARACTER SET UTF8)
WHERE `misc_identifier_control_id` = (SELECT `id` FROM `misc_identifier_controls` WHERE `misc_identifier_name` = 'COG Registration');

-- MRN --

UPDATE `misc_identifiers` SET `identifier_value` = FLOOR(10000000*RAND())
WHERE `misc_identifier_control_id` = (SELECT `id` FROM misc_identifier_controls WHERE `misc_identifier_name` = 'MRN');

-- PHN --

UPDATE `misc_identifiers` SET `identifier_value` = CONCAT(FLOOR(1000*RAND()), ' ', FLOOR(1000*RAND()), ' ', FLOOR(10000*RAND()))
WHERE `misc_identifier_control_id` = (SELECT `id` FROM misc_identifier_controls WHERE `misc_identifier_name` = 'PHN');

UPDATE `misc_identifiers` SET `identifier_value` = CONCAT(FLOOR(10*RAND()), FLOOR(10*RAND()), FLOOR(10*RAND()), FLOOR(10*RAND()), ' ', FLOOR(10*RAND()), FLOOR(10*RAND()), FLOOR(10*RAND()), ' ', FLOOR(10*RAND()), FLOOR(10*RAND()), FLOOR(10*RAND()))
WHERE `misc_identifier_control_id` = (SELECT `id` FROM misc_identifier_controls WHERE `misc_identifier_name` = 'PHN');

-- Identifiers Revs Table --

UPDATE `misc_identifiers`, `misc_identifiers_revs`
SET `misc_identifiers_revs`.`identifier_value` = `misc_identifiers`.`identifier_value`
WHERE `misc_identifiers`.`id` = `misc_identifiers_revs`.`id`;

-- Participants Contact Information --

-- Contact Name


UPDATE `participant_contacts` SET `contact_name` = cast(SHA1(`contact_name`) AS CHAR(50) CHARACTER SET utf8);


-- Email Address

UPDATE `participant_contacts` SET `ccbr_email` = cast(SHA1(`ccbr_email`) AS CHAR(45) CHARACTER SET utf8);


-- Street

UPDATE `participant_contacts` SET `street` = cast(SHA1(`street`) AS CHAR(50) CHARACTER SET utf8);

-- City

UPDATE `participant_contacts` SET `locality` = cast(SHA1(`locality`) AS CHAR(50) CHARACTER SET utf8);

-- Postal Code

UPDATE `participant_contacts` SET `mail_code` = cast(SHA1(`mail_code`) AS CHAR(10) CHARACTER SET utf8);

-- Primary Phone Number

UPDATE `participant_contacts` SET `phone` = cast(SHA1(`phone`) AS CHAR(15) CHARACTER SET utf8);

-- Secondary Phone Number

UPDATE `participant_contacts` SET `phone_secondary` = cast(SHA1(`phone_secondary`) AS CHAR(30) CHARACTER SET utf8);

-- Participants Contact Log Table --

UPDATE `participant_contacts`, `participant_contacts_revs`
SET `participant_contacts_revs`.`contact_name` = `participant_contacts`.`contact_name`,
`participant_contacts_revs`.`ccbr_email` = `participant_contacts`.`ccbr_email`,
`participant_contacts_revs`.`street` = `participant_contacts`.`street`,
`participant_contacts_revs`.`locality` = `participant_contacts`.`locality`,
`participant_contacts_revs`.`mail_code` = `participant_contacts`.`mail_code`,
`participant_contacts_revs`.`phone` = `participant_contacts`.`phone`,
`participant_contacts_revs`.`phone_secondary` = `participant_contacts`.`phone_secondary`
WHERE `participant_contacts_revs`.`id` = `participant_contacts`.`id`;    



