-- Install 2.2.2
-- run this custom script

-- Under Annotation, delete Follow-up.
UPDATE event_controls SET flag_active=false WHERE id=20;

-- Under Treatment > Chemotherapy, remove Treatment Facility and Surgery Without Extend.
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0'WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='TreatmentMaster'AND tablename='tx_masters'AND field='facility'AND type='select'AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='facility'));

-- Under Treatment > Radiation, remove Treatment Facility and Surgery Without Extend.
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0'WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_radiations') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='TreatmentMaster'AND tablename='tx_masters'AND field='facility'AND type='select'AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='facility'));

-- Under Treatment > Surgery, remove Treatment Facility and Surgery Without Extend.
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0'WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_surgeries') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='TreatmentMaster'AND tablename='tx_masters'AND field='facility'AND type='select'AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='facility'));

-- Delete Contacts.
-- Delete Message.
UPDATE menus SET flag_active=false WHERE id IN('clin_CAN_25','clin_CAN_26');

-- Under Inventory, rename Participant Identifier to “RAMQ”.
-- UPDATE structure_fields SET language_label='ramq#'WHERE id IN(925, 955);
-- UPDATE structure_formats SET flag_override_label='0', language_label=''WHERE id=2531;

-- Under Inventory, rename Acquisition Label to “Biobank ID”.
-- UPDATE structure_fields SET language_label='biobank id'WHERE id IN(152, 910);

-- Under Inventory, remove Bank, Collection Site, and Collection SOP.
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_index`='0', `flag_summary`='0'WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Collection'AND tablename='collections'AND field='bank_id'AND type='select'AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='banks'));
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_index`='0', `flag_summary`='0'WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Collection'AND tablename='collections'AND field='collection_site'AND type='select'AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='custom_collection_site'));
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0'WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Collection'AND tablename='collections'AND field='sop_master_id'AND type='select'AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='collection_sop_list'));

-- Under Inventory > Blood, remove Sample SOP and list Supplier Department and Taken Delivery By.
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0'WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='SampleMaster'AND tablename='sample_masters'AND field='sop_master_id'AND type='select'AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='sample_sop_list'));
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_detail`='0'WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='SpecimenDetail'AND tablename=''AND field='supplier_dept'AND type='select'AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='custom_specimen_supplier_dept'));
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_detail`='0'WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='SpecimenDetail'AND tablename=''AND field='reception_by'AND type='select'AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff'));

-- Under Inventory > Blood > Aliquot > Tube, remove Aliquot SOP and add a field, “Tube ID” (which will be formatted in a similar fashion to “Y-10-001-ser1”, hence a text field).
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_detail`='0'WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotMaster'AND tablename='aliquot_masters'AND field='sop_master_id'AND type='select'AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_sop_list'));

-- Under Inventory > Tissue > Aliquot > Block, remove PathoCode
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_detail`='0'WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotDetail'AND tablename=''AND field='patho_dpt_block_code'AND type='input'AND structure_value_domain  IS NULL );

-- Under Inventory > Tissue > Aliquot > Block, add new searchable field, “Mold ID” (which will be formatted in a similar fashion to “Y-10-001-m2”, hence a text field).
ALTER TABLE ad_blocks 
 ADD qc_gastro_mold_id VARCHAR(50) NOT NULL DEFAULT''AFTER patho_dpt_block_code;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Inventorymanagement','AliquotDetail','ad_blocks','qc_gastro_mold_id','mold id','','input','','',  NULL ,'');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail'AND `tablename`='ad_blocks'AND `field`='qc_gastro_mold_id'AND `language_label`='mold id'AND `language_tag`=''AND `type`='input'AND `setting`=''AND `default`=''AND `structure_value_domain`  IS NULL  AND `language_help`=''),'1','65','','0','','0','','0','','0','','0','','0','','1','0','1','0','1','0','1','0','1','0','0','0','1','1','1');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_detail`='0'WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotDetail'AND tablename=''AND field='patho_dpt_block_code'AND type='input'AND structure_value_domain  IS NULL );

INSERT INTO misc_identifier_controls(misc_identifier_name, misc_identifier_name_abbrev, flag_active, display_order, autoincrement_name, misc_identifier_format, flag_once_per_participant) VALUES
("régime d'assurance maladie du québec",'RAMQ', 1, 4,'','', 1),
("hospital number", "hospital #", 1, 4,'','', 1);

REPLACE INTO i18n (id, en, fr) VALUES
('acquisition label is required','The Biobank ID is required!','Le''Biobank ID''est requis!'),
('acquisition_label','Biobank ID','Biobank ID'),
('ramq#','RAMQ #','# RAMQ'),
('mold id','Mold ID','Mold ID'),
("régime d'assurance maladie du québec", "Régime d'Assurance Maladie du Québec", "Régime d'Assurance Maladie du Québec"), 
('core_installname','JGH - Central Biobank','JGH - Biobanque centrale'),
("anterior", "Anterior", "Antérieur"),
("posterior", "Posterior", "Postérieur"),
("transversal", "Transversal", "Transversal"),
("participant system code", "Participant system code", "Code système du participant"),
("you must either select a race and leave the other field blank or select other and fill the other field",
 "You must either select a race and leave the other field blank or select other and fill the other field",
 "Vous devez soit sélectionner une race et laisser le champ autre vide, ou sélectionner autre et remplir le champ autre"),
("you must either select a cancer type and leave the other field blank or select other and fill the other field",
 "You must either select a cancer type and leave the other field blank or select other and fill the other field",
 "Vous devez soit sélectionner une type de cancer et laisser le champ autre vide, ou sélectionner autre et remplir le champ autre"),
("colorectal", "Colorectal", "Colorectal"),
("cm or", "cm or", "cm ou"),
("kg", "Kg", "Kg"),
("pounds", "Pounds", "Livres"),
("do you smoke", "Do you smoke?", "Fumez-vous?"),
("what did (do) you smoke", "What did (do) you smoke?", "Qu'avez-vous/que fumez-vous?"),
("how much did (do) you smoke a day", "How much did (do) you smoke a day", "Combien fumiez-vous/fumez-vous par jour?"),
("how long have you been smoking", "How long have you been smoking?", "Pour combien de temps avez-vous fumé?"),
("if youve quit, when", "If you've quit, when?", "Si vous avez cessé, il y a combien de temps?"),
("did one or both of you parents smoke when you were a child", "Did one or both of you parents smoke when you were a child?", "Est-ce qu'au moins un de vos parents fumait lorsque vous étiez enfant?"),
("did your mother smoke when she was pregnant with you", "did your mother smoke when she was pregnant with you?", "Est-ce que votre mère fumait lorsqu'elle était enceinte de vous?"),
("drinking", "Drinking", "Consommation d'alcool"),
("qc_gastro_lifestyle_how_many_drinks_at_one_time",
 "How many drinks do you usually drink at one time? (1 drink = 1 beer or 5oz. of wine or 1½oz. of liquor)",
 "Combien de consommations buvez-vous normalement en une fois? (1 consommation = 1 bière ou 5oz. ou 1½oz. de liqueur)"),
("how many alcholic beverages do you drink in a typical week",
 "How many alcholic beverages do you drink in a typical week?",
 "Combien de consommations alcoolisées buvez-vous dans une semaine typique?"),
("sport", "Sport", "Sport"),
("qc_gastro_lifestyle_sport_nb_days_per_week", "How many days per week do you participate in some form of sport or recreational activity for 30 minutes or more (such as walk, golf, dancing, volleyball, bowling, etc.)?",
 "Combien de jours par semaine participez-vous à une forme de sport ou d'activité récréationelle pour 30 minutes ou plus (tel que la marche, la dance, le volleyball, les quilles, etc.)?"),
("eating", "Eating", "Nourriture"),
("qc_gastro_food_fat_nb_days_per_week",
 "How many days per week do you eat foods that are high in fat and cholesterol, such as fatty meat, cheese, fried foods, eggs?",
 "Combien de jours par semaine mangez-vous de la nourriture à forte teneur en gras et en cholestérol tel que la viande grasse, le fromage, la nourriture frite, des oeufs?"),
("qc_gastro_food_fiber_nb_days_per_week",
 "How many days per week do you eat foods that are high in fiber, including grain products, fresh fruits and vegetables?",
 "Combien de jours par semaine mangez-vous de la nourriture à forte teneur en fibres, incluant les produits du grain, les fruits frais et les légumes?"),
("qc_gastro_food_smoked_salted_nb_days_per_week",
 "How many days per week do you eat foods that have been smoked and/or salt-pickled? Examples are: ham, bacon, smoked fish, hot dogs, many'cold cuts'.",
 "Combien de jours par semaine mangez-vous de la nourriture qui a été fumée et/ou marinée au sel? Des exemples sont: Jambon, bacon, poisson fumé, hot dogs, plusieurs'viandes froides'."),
("qc_gastro_food_charbroiled_nb_days_per_week",
 "How many days per week do you eat foods that are charbroiled (cooked on an open flame)?",
 "Combien de jours par semaine mangez-vous de la nourriture qui a été cuite directement sur la flâme?"),
("qc_gastro_can_digest_milk",
 "Are you able to diget milk and milk products without any problem?",
 "Êtes-vous capable de digérer le lait et les produitsdu lait sans aucun problème?"),
("qc_gastro_taking_calcium_supplement",
 "Are you currently takin a calcium supplement? (Do not include calcium from multi-vitamins.) Calcium supplements usually contain at least 500mg of calcium. (For example: Viactiv, Caltrate, Oscal.)",
 "Présentement, prennez-vous des suppléments de calcium? (N'incluez pas le calcium en provenance des multi-vitamines.) Le suppléments de calcium contienent généralement au moins 500mg de calcium. (Par exemple: Viactiv, Celtrate, Oscal.)"),
("qc_gastro_taking_vitamin_d_supplement",
 "Are you currently taking a vitamin D supplement (as part of a calcium supplement or separately)?",
 "Présentement, prennez-vous un supplément de vitamine D (faisant partie d'un supplément de calcium ou séparémment)?"),
("qc_gastro_lifestyle_sibling_has_cancer",
 "Has a parent, sibling or child related to you by blood ever been diagnosed with cancer?",
 "Est-ce qu'un parent, frère, soeur ou enfant lié à vous par le sang a déjà été diagnostiqué d'un cancer?"),
 
 
("parent/sibling/child having cancer", "Parent/sibling/child having cancer", "Parent/frère/soeur/enfant ayant le cancer"),
("smoking qty/day", "Smoking qty/day", "Qty fumée par jour"),
("smoking for how long", "Smoking for how long", "Fumeur pour quelle durée"),
("quitted when", "Quitted when", "Quitté quand"),
("when child, smoking parents", "When child, smoking parents", "Lorsqu'enfant, parent fumeur"),
("smoking mother while pregnant with you", "Smoking mother while pregnant with you", "Mère fumeuse lorsqu'enceint de vous"),
("drinks/time", "Drinks/time", "Consommations/fois"),
("qty/week", "Qty/week", "Qte/semaine"),
("sport days/week", "Sport days/week", "Sport jours/semaine"),
("fat food days/week", "Fat food days/week", "Nourriture grasse jours/semaine"),
("fiber food days/week", "Fiber food days/week", "Nourriture fibreuse jours/semaine"),
("smoked/salted food days/week", "Smoked/salted food days/week", "Nourriture fumée/sallée jours/semaine"),
("charboiled food days/week", "Charboiled food days/week", "Nourriture cuite sur la flâme jours/semaine"),
("can digest milk", "Can digest milk", "Peut digérer le lait"),
("multi-vitamins", "Multi-vitamins", "Multi-vitamines"),
("calcium supplement", "Calcium supplements", "Suppléments de calcium"),
("vitamin d supplement", "Vitamin D supplement", "Suppléments de vitamine D"),

("form language", "Form language", "Langue du formulaire"),
("acceptance", "Acceptance", "Acceptation"),
("access to medical file", "Access to medical file", "Accès au dossier médical"),
("biological material storage and use", "Biological material storage and use", "Entreposage et utilisation de matériel biologique"),
("blood collection", "Blood collection", "Collection de sang"),
("saliva collection", "Saliva collection", "Collection de salive"),
("micro-rna", "Micro-RNA", "Micro-ARN"),
("ficol use", "Ficol use", "Utilisation de ficol"); 
 

UPDATE diagnosis_controls SET flag_active=0 WHERE id IN (1, 2);

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_gastro_tissue_precision','','', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("anterior", "anterior");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_gastro_tissue_precision"),  (SELECT id FROM structure_permissible_values WHERE value="anterior" AND language_alias="anterior"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("posterior", "posterior");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_gastro_tissue_precision"),  (SELECT id FROM structure_permissible_values WHERE value="posterior" AND language_alias="posterior"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("transversal", "transversal");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_gastro_tissue_precision"),  (SELECT id FROM structure_permissible_values WHERE value="transversal" AND language_alias="transversal"), "1", "1");

INSERT INTO structures(`alias`) VALUES ('qc_gastro_dx_other');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation','DiagnosisDetail','dxd_tissues','qc_gastro_tissue_source','select', (SELECT id FROM structure_value_domains WHERE domain_name='tissue_source_list') ,'0','','','','tissue source',''), 
('Clinicalannotation','DiagnosisDetail','dxd_tissues','qc_gastro_precision','select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_tissue_precision') ,'0','','','','','precision');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_gastro_dx_other'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster'AND `tablename`='diagnosis_masters'AND `field`='dx_identifier'AND `type`='input'AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'AND `setting`='size=4'AND `default`=''AND `language_help`='help_dx identifier'AND `language_label`='diagnosis identifier'AND `language_tag`=''),'1','1','','0','','0','','0','','0','','0','','0','','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dx_other'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster'AND `tablename`='diagnosis_masters'AND `field`='primary_icd10_code'AND `type`='autocomplete'AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'AND `setting`='size=10,url=/codingicd/CodingIcd10s/autocomplete,tool=/codingicd/CodingIcd10s/tool/who'AND `default`=''AND `language_help`='help_primary code'AND `language_label`='primary disease code'AND `language_tag`=''),'2','1','coding','0','','0','','0','','0','','0','','0','','1','0','1','0','1','0','0','0','0','0','0','0','1','1','1'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dx_other'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster'AND `tablename`='diagnosis_masters'AND `field`='primary_number'AND `type`='input'AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'AND `setting`='size=10'AND `default`=''AND `language_help`='help_primary number'AND `language_label`='primary_number'AND `language_tag`=''),'1','2','','0','','0','','0','','0','','0','','0','','0','0','0','0','0','0','0','0','0','0','0','0','1','1','1'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dx_other'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster'AND `tablename`='diagnosis_masters'AND `field`='previous_primary_code_system'AND `type`='input'AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'AND `setting`='size=10'AND `default`=''AND `language_help`='help_previous primary code system'AND `language_label`='previous disease code system'AND `language_tag`=''),'2','2','','0','','0','','0','','0','','0','','0','','0','0','0','0','0','0','0','0','0','0','0','0','0','1','0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dx_other'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster'AND `tablename`='diagnosis_masters'AND `field`='dx_origin'AND `type`='select'AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='origin')  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`='help_dx origin'AND `language_label`='origin'AND `language_tag`=''),'1','3','','0','','0','','0','','0','','0','','0','','1','0','1','0','1','0','0','0','0','0','0','0','1','1','1'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dx_other'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster'AND `tablename`='diagnosis_masters'AND `field`='previous_primary_code'AND `type`='input'AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'AND `setting`='size=10'AND `default`=''AND `language_help`='help_previous primary code'AND `language_label`=''AND `language_tag`='code'),'2','3','','0','','0','','0','','0','','0','','0','','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dx_other'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster'AND `tablename`='diagnosis_masters'AND `field`='dx_date'AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'),'1','4','','0','','0','','1','','0','','0','','0','','1','0','1','0','1','0','0','0','0','0','0','0','1','1','1'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dx_other'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster'AND `tablename`='diagnosis_masters'AND `field`='dx_date_accuracy'AND `type`='select'AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='date_accuracy')  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`=''AND `language_label`=''AND `language_tag`=''),'1','5','','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','0','1','0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dx_other'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster'AND `tablename`='diagnosis_masters'AND `field`='age_at_dx'AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'),'1','6','','0','','0','','1','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','0','1','0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dx_other'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster'AND `tablename`='diagnosis_masters'AND `field`='topography'AND `type`='autocomplete'AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'AND `setting`='size=10,url=/codingicd/CodingIcdo3s/autocomplete/topo,tool=/codingicd/CodingIcdo3s/tool/topo'AND `default`=''AND `language_help`='help_topography'AND `language_label`='topography'AND `language_tag`=''),'2','6','','0','','0','','0','','0','','0','','0','','1','0','1','0','1','0','0','0','0','0','0','0','0','1','0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dx_other'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster'AND `tablename`='diagnosis_masters'AND `field`='morphology'AND `type`='autocomplete'AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'AND `setting`='size=10,url=/codingicd/CodingIcdo3s/autocomplete/morpho,tool=/codingicd/CodingIcdo3s/tool/morpho'AND `default`=''AND `language_help`='help_morphology'AND `language_label`='morphology'AND `language_tag`=''),'2','7','','0','','0','','0','','0','','0','','0','','1','0','1','0','1','0','0','0','0','0','0','0','0','1','0'), 

((SELECT id FROM structures WHERE alias='qc_gastro_dx_other'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster'AND `tablename`='diagnosis_masters'AND `field`='age_at_dx_accuracy'AND `type`='select'AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='age_accuracy')  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`=''AND `language_label`=''AND `language_tag`=''),'1','7','','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','0','1','0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dx_other'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster'AND `tablename`='diagnosis_masters'AND `field`='dx_nature'AND `type`='select'AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='dx_nature')  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`='help_dx nature'AND `language_label`='dx nature'AND `language_tag`=''),'1','8','','0','','0','','0','','0','','0','','0','','1','0','1','0','1','0','0','0','0','0','0','0','1','1','1'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dx_other'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster'AND `tablename`='diagnosis_masters'AND `field`='dx_method'AND `type`='select'AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='dx_method')  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`='help_dx method'AND `language_label`='dx_method'AND `language_tag`=''),'1','9','','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','1','1','1'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dx_other'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster'AND `tablename`='diagnosis_masters'AND `field`='tumour_grade'AND `type`='select'AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tumour grade')  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`='help_tumour grade'AND `language_label`='tumour grade'AND `language_tag`=''),'1','10','','0','','0','','0','','0','','0','','0','','1','0','1','0','1','0','0','0','0','0','0','0','0','1','0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dx_other'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster'AND `tablename`='diagnosis_masters'AND `field`='survival_time_months'AND `type`='integer_positive'AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'AND `setting`='size=5'AND `default`=''AND `language_help`='help_survival time'AND `language_label`='survival time months'AND `language_tag`=''),'1','11','','0','','0','','0','','0','','0','','0','','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dx_other'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster'AND `tablename`='diagnosis_masters'AND `field`='information_source'AND `type`='select'AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='information_source')  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`='help_information_source'AND `language_label`='information_source'AND `language_tag`=''),'1','12','','0','','0','','0','','0','','0','','0','','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dx_other'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster'AND `tablename`='diagnosis_masters'AND `field`='notes'AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'),'1','13','','0','','0','','1','help_memo','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','0','1','0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dx_other'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster'AND `tablename`='diagnosis_masters'AND `field`='collaborative_staged'AND `type`='select'AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno')  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`='help_collaborative staged'AND `language_label`='collaborative staged'AND `language_tag`=''),'2','14','staging','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','0','1','0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dx_other'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster'AND `tablename`='diagnosis_masters'AND `field`='ajcc_edition'AND `type`='select'AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ajcc edition')  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`='help_ajcc edition'AND `language_label`='ajcc edition'AND `language_tag`=''),'2','16','','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','0','1','0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dx_other'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster'AND `tablename`='diagnosis_masters'AND `field`='clinical_tstage'AND `type`='input'AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'AND `setting`='size=1,maxlength=3'AND `default`=''AND `language_help`=''AND `language_label`='clinical stage'AND `language_tag`='t stage'),'2','19','','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','0','1','0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dx_other'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster'AND `tablename`='diagnosis_masters'AND `field`='clinical_nstage'AND `type`='input'AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'AND `setting`='size=1,maxlength=3'AND `default`=''AND `language_help`=''AND `language_label`=''AND `language_tag`='n stage'),'2','20','','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','0','1','0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dx_other'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster'AND `tablename`='diagnosis_masters'AND `field`='clinical_mstage'AND `type`='input'AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'AND `setting`='size=1,maxlength=3'AND `default`=''AND `language_help`=''AND `language_label`=''AND `language_tag`='m stage'),'2','21','','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','0','1','0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dx_other'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster'AND `tablename`='diagnosis_masters'AND `field`='clinical_stage_summary'AND `type`='input'AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'AND `setting`='size=1,maxlength=3'AND `default`=''AND `language_help`='help_clinical_stage_summary'AND `language_label`=''AND `language_tag`='summary'),'2','22','','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','0','1','0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dx_other'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster'AND `tablename`='diagnosis_masters'AND `field`='path_tstage'AND `type`='input'AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'AND `setting`='size=1,maxlength=3'AND `default`=''AND `language_help`=''AND `language_label`='pathological stage'AND `language_tag`='t stage'),'2','23','','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','0','1','0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dx_other'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster'AND `tablename`='diagnosis_masters'AND `field`='path_nstage'AND `type`='input'AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'AND `setting`='size=1,maxlength=3'AND `default`=''AND `language_help`=''AND `language_label`=''AND `language_tag`='n stage'),'2','24','','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','0','1','0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dx_other'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster'AND `tablename`='diagnosis_masters'AND `field`='path_mstage'AND `type`='input'AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'AND `setting`='size=1,maxlength=3'AND `default`=''AND `language_help`=''AND `language_label`=''AND `language_tag`='m stage'),'2','24','','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','0','1','0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dx_other'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster'AND `tablename`='diagnosis_masters'AND `field`='path_stage_summary'AND `type`='input'AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'AND `setting`='size=1, maxlength=3'AND `default`=''AND `language_help`='help_path_stage_summary'AND `language_label`=''AND `language_tag`='summary'),'2','25','','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','0','1','0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dx_other'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail'AND `tablename`='dxd_tissues'AND `field`='laterality'AND `type`='select'AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='laterality')  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`='dx_laterality'AND `language_label`='laterality'AND `language_tag`=''),'2','99','tissue specific','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','0','1','0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dx_other'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail'AND `tablename`='dxd_tissues'AND `field`='qc_gastro_tissue_source'AND `type`='select'AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tissue_source_list')  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`=''AND `language_label`='tissue source'AND `language_tag`=''),'2','100','','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','0','1','0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dx_other'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail'AND `tablename`='dxd_tissues'AND `field`='qc_gastro_precision'AND `type`='select'AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_tissue_precision')  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`=''AND `language_label`=''AND `language_tag`='precision'),'2','101','','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','0','1','0');

ALTER TABLE dxd_tissues 
 ADD COLUMN qc_gastro_tissue_source VARCHAR(50) NOT NULL DEFAULT'',
 ADD COLUMN qc_gastro_precision  VARCHAR(50) NOT NULL DEFAULT'';
ALTER TABLE dxd_tissues_revs 
 ADD COLUMN qc_gastro_tissue_source VARCHAR(50) NOT NULL DEFAULT'',
 ADD COLUMN qc_gastro_precision  VARCHAR(50) NOT NULL DEFAULT'';

INSERT INTO diagnosis_controls(controls_type, flag_active, form_alias, detail_tablename, display_order, databrowser_label) 
(SELECT'other', 1,'qc_gastro_dx_other', detail_tablename, display_order,'other'FROM diagnosis_controls WHERE id=2);

UPDATE structure_formats SET `flag_detail`='0'WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_gastro_dx_other') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster'AND `tablename`='diagnosis_masters'AND `field`='previous_primary_code_system'AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

ALTER TABLE aliquot_internal_uses
 ADD COLUMN qc_gastro_number_of_slices INT DEFAULT NULL AFTER study_summary_id;
ALTER TABLE aliquot_internal_uses_revs
 ADD COLUMN qc_gastro_number_of_slices INT DEFAULT NULL AFTER study_summary_id; 
 
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement','AliquotInternalUse','aliquot_internal_uses','qc_gastro_number_of_slices','integer_positive',  NULL ,'0','','','','number of slices','');

ALTER TABLE aliquot_internal_uses
 ADD COLUMN qc_gastro_thickness DECIMAL(10,5) DEFAULT NULL AFTER qc_gastro_number_of_slices;
ALTER TABLE aliquot_internal_uses_revs
 ADD COLUMN qc_gastro_thickness DECIMAL(10,5) DEFAULT NULL AFTER qc_gastro_number_of_slices; 

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement','AliquotInternalUse','aliquot_internal_uses','qc_gastro_thickness','float',  NULL ,'0','size=5','','','thickness (um)','');

INSERT INTO structures (alias) VALUES ('qc_gastro_tissueinternaluses');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_gastro_tissueinternaluses'), 
(SELECT id FROM structure_fields WHERE `model`='AliquotInternalUse'AND `tablename`='aliquot_internal_uses'AND `field`='qc_gastro_number_of_slices'AND `type`='integer_positive'AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`=''AND `language_label`='number of slices'AND `language_tag`=''),'0','12','','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','1','1','0'),
((SELECT id FROM structures WHERE alias='qc_gastro_tissueinternaluses'), 
(SELECT id FROM structure_fields WHERE `model`='AliquotInternalUse'AND `tablename`='aliquot_internal_uses'AND `field`='qc_gastro_thickness'),'0','13','','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','1','1','0');

INSERT IGNORE INTO i18n (id,en,fr) VALUES
('number of slices','Number of Slices','Nombre de tranches'),
('thickness (um)','Thickness (um)','Épaisseur (um)');

-- inventory configureation
UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(137, 25, 3, 142, 143, 141, 144, 140);
UPDATE sample_to_aliquot_controls SET flag_active=false WHERE id IN(3, 7, 41, 8);


-- participants ethnicity other input field
ALTER TABLE participants
 ADD COLUMN qc_gastro_race_other VARCHAR(50) NOT NULL DEFAULT''AFTER race;
ALTER TABLE participants_revs
 ADD COLUMN qc_gastro_race_other VARCHAR(50) NOT NULL DEFAULT''AFTER race;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation','Participant','participants','qc_gastro_race_other','input',  NULL ,'0','','','','','other');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant'AND `tablename`='participants'AND `field`='qc_gastro_race_other'AND `type`='input'AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`=''AND `language_label`=''AND `language_tag`='other'),'1','6','','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','0','1','0');

-- fam. histories
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_gastro_cancer_type','','', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("breast", "breast");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_gastro_cancer_type"),  (SELECT id FROM structure_permissible_values WHERE value="breast" AND language_alias="breast"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("lung", "lung");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_gastro_cancer_type"),  (SELECT id FROM structure_permissible_values WHERE value="lung" AND language_alias="lung"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("colon or rectal", "colon or rectal");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_gastro_cancer_type"),  (SELECT id FROM structure_permissible_values WHERE value="colon or rectal" AND language_alias="colon or rectal"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("other", "other");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_gastro_cancer_type"),  (SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="other"), "1", "1");

ALTER TABLE family_histories
 ADD COLUMN qc_gastro_cancer_type VARCHAR(50) NOT NULL DEFAULT''AFTER participant_id,
 ADD COLUMN qc_gastro_cancer_type_other VARCHAR(50) NOT NULL DEFAULT''AFTER qc_gastro_cancer_type;
ALTER TABLE family_histories_revs
 ADD COLUMN qc_gastro_cancer_type VARCHAR(50) NOT NULL DEFAULT''AFTER participant_id,
 ADD COLUMN qc_gastro_cancer_type_other VARCHAR(50) NOT NULL DEFAULT''AFTER qc_gastro_cancer_type;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation','FamilyHistory','family_histories','qc_gastro_cancer_type','select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cancer_type') ,'0','','','','cancer type',''), 
('Clinicalannotation','FamilyHistory','family_histories','qc_gastro_cancer_type_other','input',  NULL ,'0','','','','','other');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='familyhistories'), (SELECT id FROM structure_fields WHERE `model`='FamilyHistory'AND `tablename`='family_histories'AND `field`='qc_gastro_cancer_type'AND `type`='select'AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cancer_type')  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`=''AND `language_label`='cancer type'AND `language_tag`=''),'1','3','','0','','0','','0','','0','','0','','0','','1','0','1','0','1','0','1','0','1','0','0','0','1','1','1'), 
((SELECT id FROM structures WHERE alias='familyhistories'), (SELECT id FROM structure_fields WHERE `model`='FamilyHistory'AND `tablename`='family_histories'AND `field`='qc_gastro_cancer_type_other'AND `type`='input'AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`=''AND `language_label`=''AND `language_tag`='other'),'1','3','','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','1','0','1','0','0','0','0','1','1');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0'WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FamilyHistory'AND `tablename`='family_histories'AND `field`='previous_primary_code'AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_detail`='0'WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FamilyHistory'AND `tablename`='family_histories'AND `field`='previous_primary_code_system'AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='4'WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FamilyHistory'AND `tablename`='family_histories'AND `field`='primary_icd10_code'AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- lifestyle
INSERT INTO event_controls (disease_site, event_group, event_type, flag_active, form_alias, detail_tablename, display_order, databrowser_label) VALUES
('colorectal','lifestyle','lifestyle', 1,'qc_gastro_lifestyle','qc_gastro_ed_lifestyle', 0,'lifestyle|colorectal');

CREATE TABLE qc_gastro_ed_lifestyle(
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 event_master_id INT NOT NULL,
 height_cm FLOAT UNSIGNED DEFAULT NULL,
 height_feet TINYINT UNSIGNED DEFAULT NULL,
 height_inches FLOAT UNSIGNED DEFAULT NULL,
 weight FLOAT UNSIGNED DEFAULT NULL,
 weight_unit VARCHAR(6) DEFAULT'',
 sibling_has_cancer BOOLEAN DEFAULT NULL,
 do_you_smoke VARCHAR(10) DEFAULT'',
 smoke_what VARCHAR(20) DEFAULT'',
 smoke_per_day VARCHAR(40) DEFAULT'',
 smoke_how_long VARCHAR(40) DEFAULT'',
 smoke_quit_when VARCHAR(40) DEFAULT'',
 smoke_parent BOOLEAN DEFAULT NULL,
 smoke_mother_pregnant BOOLEAN DEFAULT NULL,
 drink_per_time VARCHAR(40) DEFAULT'',
 drink_per_week VARCHAR(40) DEFAULT'',
 sport_nb_days_per_week TINYINT DEFAULT NULL,
 food_fat_nb_days_per_week TINYINT DEFAULT NULL,
 food_fiber_nb_days_per_week TINYINT DEFAULT NULL,
 food_smoked_salted_nb_days_per_week TINYINT DEFAULT NULL,
 food_charbroiled_nb_days_per_week TINYINT DEFAULT NULL,
 food_milk_nb_days_per_week TINYINT DEFAULT NULL,
 can_digest_milk BOOLEAN DEFAULT NULL,
 taking_multi_vitamins BOOLEAN DEFAULT NULL,
 taking_calcium_supplement BOOLEAN DEFAULT NULL,
 taking_vitamin_d_supplement BOOLEAN DEFAULT NULL
)Engine=InnoDb;
CREATE TABLE qc_gastro_ed_lifestyle_revs(
 id INT UNSIGNED NOT NULL,
 event_master_id INT NOT NULL,
 height_cm FLOAT UNSIGNED DEFAULT NULL,
 height_feet TINYINT UNSIGNED DEFAULT NULL,
 height_inches FLOAT UNSIGNED DEFAULT NULL,
 weight FLOAT UNSIGNED DEFAULT NULL,
 weight_unit VARCHAR(6) DEFAULT'',
 sibling_has_cancer BOOLEAN DEFAULT NULL,
 do_you_smoke VARCHAR(10) DEFAULT'',
 smoke_what VARCHAR(20) DEFAULT'',
 smoke_per_day VARCHAR(40) DEFAULT'',
 smoke_how_long VARCHAR(40) DEFAULT'',
 smoke_quit_when VARCHAR(40) DEFAULT'',
 smoke_parent BOOLEAN DEFAULT NULL,
 smoke_mother_pregnant BOOLEAN DEFAULT NULL,
 drink_per_time VARCHAR(40) DEFAULT'',
 drink_per_week VARCHAR(40) DEFAULT'',
 sport_nb_days_per_week TINYINT DEFAULT NULL,
 food_fat_nb_days_per_week TINYINT DEFAULT NULL,
 food_fiber_nb_days_per_week TINYINT DEFAULT NULL,
 food_smoked_salted_nb_days_per_week TINYINT DEFAULT NULL,
 food_charbroiled_nb_days_per_week TINYINT DEFAULT NULL,
 food_milk_nb_days_per_week TINYINT DEFAULT NULL,
 can_digest_milk BOOLEAN DEFAULT NULL,
 taking_multi_vitamins BOOLEAN DEFAULT NULL,
 taking_calcium_supplement BOOLEAN DEFAULT NULL,
 taking_vitamin_d_supplement BOOLEAN DEFAULT NULL,
 `version_id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `version_created` datetime NOT NULL
)Engine=InnoDb;
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_gastro_weight_unit','','', null);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("kg", "kg");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_gastro_weight_unit"),  (SELECT id FROM structure_permissible_values WHERE value="kg" AND language_alias="kg"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("pounds", "pounds");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_gastro_weight_unit"),  (SELECT id FROM structure_permissible_values WHERE value="pounds" AND language_alias="pounds"), "1", "1");

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_gastro_do_you_smoke','','', null);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("yes", "yes");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_gastro_do_you_smoke"),  (SELECT id FROM structure_permissible_values WHERE value="yes" AND language_alias="yes"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("quit", "quit");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_gastro_do_you_smoke"),  (SELECT id FROM structure_permissible_values WHERE value="quit" AND language_alias="quit"), "2", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("never", "never");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_gastro_do_you_smoke"),  (SELECT id FROM structure_permissible_values WHERE value="never" AND language_alias="never"), "3", "1");

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_gastro_smoking_type','','', null);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("cigarettes", "cigarettes");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_gastro_smoking_type"),  (SELECT id FROM structure_permissible_values WHERE value="cigarettes" AND language_alias="cigarettes"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("cigars", "cigars");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_gastro_smoking_type"),  (SELECT id FROM structure_permissible_values WHERE value="cigars" AND language_alias="cigars"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("pipe", "pipe");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_gastro_smoking_type"),  (SELECT id FROM structure_permissible_values WHERE value="pipe" AND language_alias="pipe"), "1", "1");

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_gastro_smoke_per_day','','', null);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("1-5", "once to five times");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_gastro_smoke_per_day"),  (SELECT id FROM structure_permissible_values WHERE value="1-5" AND language_alias="once to five times"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("6-20", "six to twenty times");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_gastro_smoke_per_day"),  (SELECT id FROM structure_permissible_values WHERE value="6-20" AND language_alias="six to twenty times"), "2", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("> 20", "more than twenty times");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_gastro_smoke_per_day"),  (SELECT id FROM structure_permissible_values WHERE value="> 20" AND language_alias="more than twenty times"), "3", "1");

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_gastro_smoke_how_long','','', null);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("< 1", "less than a year");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_gastro_smoke_how_long"),  (SELECT id FROM structure_permissible_values WHERE value="< 1" AND language_alias="less than a year"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("1-5", "one to five year(s)");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_gastro_smoke_how_long"),  (SELECT id FROM structure_permissible_values WHERE value="1-5" AND language_alias="one to five year(s)"), "2", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("> 5", "more than five years");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_gastro_smoke_how_long"),  (SELECT id FROM structure_permissible_values WHERE value="> 5" AND language_alias="more than five years"), "3", "1");

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_gastro_drinking_qty','','', null);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("0", "zero");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_gastro_drinking_qty"),  (SELECT id FROM structure_permissible_values WHERE value="0" AND language_alias="zero"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("1-2", "one to two");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_gastro_drinking_qty"),  (SELECT id FROM structure_permissible_values WHERE value="1-2" AND language_alias="one to two"), "2", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("3-4", "three to four");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_gastro_drinking_qty"),  (SELECT id FROM structure_permissible_values WHERE value="3-4" AND language_alias="three to four"), "3", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("> 4", "five or more");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_gastro_drinking_qty"),  (SELECT id FROM structure_permissible_values WHERE value="> 4" AND language_alias="five or more"), "4", "1");

INSERT INTO structures(`alias`) VALUES ('qc_gastro_lifestyle');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation','EventDetail','qc_gastro_ed_lifestyle','height_feet','integer_positive',  NULL ,'0','','','','height (feet/inches)',''), 
('Clinicalannotation','EventDetail','qc_gastro_ed_lifestyle','height_inches','float_positive',  NULL ,'0','','','','','height (inches)'), 
('Clinicalannotation','EventDetail','qc_gastro_ed_lifestyle','weight','float_positive',  NULL ,'0','','','','weight',''), 
('Clinicalannotation','EventDetail','qc_gastro_ed_lifestyle','weight_unit','select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_weight_unit') ,'0','','','','',''), 
('Clinicalannotation','EventDetail','qc_gastro_ed_lifestyle','do_you_smoke','select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_do_you_smoke') ,'0','','','','do you smoke',''), 
('Clinicalannotation','EventDetail','qc_gastro_ed_lifestyle','sibling_has_cancer','checkbox',  NULL ,'0','','','','qc_gastro_lifestyle_sibling_has_cancer',''), 
('Clinicalannotation','EventDetail','qc_gastro_ed_lifestyle','smoke_what','select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_smoking_type') ,'0','','','','what did (do) you smoke',''), 
('Clinicalannotation','EventDetail','qc_gastro_ed_lifestyle','smoke_per_day','select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_smoke_per_day') ,'0','','','','how much did (do) you smoke a day',''), 
('Clinicalannotation','EventDetail','qc_gastro_ed_lifestyle','smoke_how_long','select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_smoke_how_long') ,'0','','','','how long have you been smoking',''), 
('Clinicalannotation','EventDetail','qc_gastro_ed_lifestyle','smoke_quit_when','select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_smoke_how_long') ,'0','','','','if youve quit, when',''), 
('Clinicalannotation','EventDetail','qc_gastro_ed_lifestyle','smoke_parent','checkbox',  NULL ,'0','','','','did one or both of you parents smoke when you were a child',''), 
('Clinicalannotation','EventDetail','qc_gastro_ed_lifestyle','smoke_mother_pregnant','checkbox',  NULL ,'0','','','','did your mother smoke when she was pregnant with you',''), 
('Clinicalannotation','EventDetail','qc_gastro_ed_lifestyle','drink_per_week','select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_drinking_qty') ,'0','','','','how many alcholic beverages do you drink in a typical week',''), 
('Clinicalannotation','EventDetail','qc_gastro_ed_lifestyle','food_fiber_nb_days_per_week','integer',  NULL ,'0','','','','qc_gastro_food_fiber_nb_days_per_week',''), 
('Clinicalannotation','EventDetail','qc_gastro_ed_lifestyle','food_smoked_salted_nb_days_per_week','integer',  NULL ,'0','','','','qc_gastro_food_smoked_salted_nb_days_per_week',''), 
('Clinicalannotation','EventDetail','qc_gastro_ed_lifestyle','food_charbroiled_nb_days_per_week','integer',  NULL ,'0','','','','qc_gastro_food_charbroiled_nb_days_per_week',''), 
('Clinicalannotation','EventDetail','qc_gastro_ed_lifestyle','can_digest_milk','checkbox',  NULL ,'0','','','','qc_gastro_can_digest_milk',''), 
('Clinicalannotation','EventDetail','qc_gastro_ed_lifestyle','taking_multi_vitamins','checkbox',  NULL ,'0','','','','qc_gastro_taking_multi_vitamins',''), 
('Clinicalannotation','EventDetail','qc_gastro_ed_lifestyle','taking_calcium_supplement','checkbox',  NULL ,'0','','','','qc_gastro_taking_calcium_supplement',''), 
('Clinicalannotation','EventDetail','qc_gastro_ed_lifestyle','taking_vitamin_d_supplement','checkbox',  NULL ,'0','','','','qc_gastro_taking_vitamin_d_supplement',''), 
('Clinicalannotation','EventDetail','qc_gastro_ed_lifestyle','height_cm','float_positive',  NULL ,'0','','','','height (cm)',''), 
('Clinicalannotation','EventDetail','qc_gastro_ed_lifestyle','sport_nb_days_per_week','integer',  NULL ,'0','','','','qc_gastro_lifestyle_sport_nb_days_per_week',''), 
('Clinicalannotation','EventDetail','qc_gastro_ed_lifestyle','drink_per_time','select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_drinking_qty') ,'0','','','','qc_gastro_lifestyle_how_many_drinks_at_one_time',''), 
('Clinicalannotation','EventDetail','qc_gastro_ed_lifestyle','food_fat_nb_days_per_week','integer',  NULL ,'0','','','','qc_gastro_food_fat_nb_days_per_week','');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_gastro_lifestyle'), (SELECT id FROM structure_fields WHERE `model`='EventDetail'AND `tablename`='qc_gastro_ed_lifestyle'AND `field`='height_feet'AND `type`='integer_positive'AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`=''),'1','2','','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','0','1','0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_lifestyle'), (SELECT id FROM structure_fields WHERE `model`='EventDetail'AND `tablename`='qc_gastro_ed_lifestyle'AND `field`='height_inches'AND `type`='float_positive'AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`=''),'1','3','','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','0','1','0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_lifestyle'), (SELECT id FROM structure_fields WHERE `model`='EventDetail'AND `tablename`='qc_gastro_ed_lifestyle'AND `field`='weight'AND `type`='float_positive'AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`=''AND `language_label`='weight'AND `language_tag`=''),'1','4','','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','0','1','0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_lifestyle'), (SELECT id FROM structure_fields WHERE `model`='EventDetail'AND `tablename`='qc_gastro_ed_lifestyle'AND `field`='weight_unit'AND `type`='select'AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_weight_unit')  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`=''AND `language_label`=''AND `language_tag`=''),'1','5','','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','0','1','0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_lifestyle'), (SELECT id FROM structure_fields WHERE `model`='EventDetail'AND `tablename`='qc_gastro_ed_lifestyle'AND `field`='do_you_smoke'AND `type`='select'AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_do_you_smoke')  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`=''AND `language_label`='do you smoke'AND `language_tag`=''),'1','7','smoking history','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','0','1','0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_lifestyle'), (SELECT id FROM structure_fields WHERE `model`='EventDetail'AND `tablename`='qc_gastro_ed_lifestyle'AND `field`='sibling_has_cancer'AND `type`='checkbox'AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`=''AND `language_label`='qc_gastro_lifestyle_sibling_has_cancer'AND `language_tag`=''),'1','6','','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','0','1','0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_lifestyle'), (SELECT id FROM structure_fields WHERE `model`='EventDetail'AND `tablename`='qc_gastro_ed_lifestyle'AND `field`='smoke_what'AND `type`='select'AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_smoking_type')  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`=''AND `language_label`='what did (do) you smoke'AND `language_tag`=''),'1','8','','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','0','1','0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_lifestyle'), (SELECT id FROM structure_fields WHERE `model`='EventDetail'AND `tablename`='qc_gastro_ed_lifestyle'AND `field`='smoke_per_day'AND `type`='select'AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_smoke_per_day')  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`=''AND `language_label`='how much did (do) you smoke a day'AND `language_tag`=''),'1','9','','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','0','1','0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_lifestyle'), (SELECT id FROM structure_fields WHERE `model`='EventDetail'AND `tablename`='qc_gastro_ed_lifestyle'AND `field`='smoke_how_long'AND `type`='select'AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_smoke_how_long')  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`=''AND `language_label`='how long have you been smoking'AND `language_tag`=''),'1','10','','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','0','1','0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_lifestyle'), (SELECT id FROM structure_fields WHERE `model`='EventDetail'AND `tablename`='qc_gastro_ed_lifestyle'AND `field`='smoke_quit_when'AND `type`='select'AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_smoke_how_long')  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`=''AND `language_label`='if youve quit, when'AND `language_tag`=''),'1','11','','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','0','1','0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_lifestyle'), (SELECT id FROM structure_fields WHERE `model`='EventDetail'AND `tablename`='qc_gastro_ed_lifestyle'AND `field`='smoke_parent'AND `type`='checkbox'AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`=''AND `language_label`='did one or both of you parents smoke when you were a child'AND `language_tag`=''),'1','12','','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','0','1','0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_lifestyle'), (SELECT id FROM structure_fields WHERE `model`='EventDetail'AND `tablename`='qc_gastro_ed_lifestyle'AND `field`='smoke_mother_pregnant'AND `type`='checkbox'AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`=''AND `language_label`='did your mother smoke when she was pregnant with you'AND `language_tag`=''),'1','13','','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','0','1','0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_lifestyle'), (SELECT id FROM structure_fields WHERE `model`='EventDetail'AND `tablename`='qc_gastro_ed_lifestyle'AND `field`='drink_per_week'AND `type`='select'AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_drinking_qty')  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`=''AND `language_label`='how many alcholic beverages do you drink in a typical week'AND `language_tag`=''),'2','2','','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','0','1','0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_lifestyle'), (SELECT id FROM structure_fields WHERE `model`='EventDetail'AND `tablename`='qc_gastro_ed_lifestyle'AND `field`='food_fiber_nb_days_per_week'AND `type`='integer'AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`=''AND `language_label`='qc_gastro_food_fiber_nb_days_per_week'AND `language_tag`=''),'2','5','','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','0','1','0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_lifestyle'), (SELECT id FROM structure_fields WHERE `model`='EventDetail'AND `tablename`='qc_gastro_ed_lifestyle'AND `field`='food_smoked_salted_nb_days_per_week'AND `type`='integer'AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`=''AND `language_label`='qc_gastro_food_smoked_salted_nb_days_per_week'AND `language_tag`=''),'2','6','','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','0','1','0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_lifestyle'), (SELECT id FROM structure_fields WHERE `model`='EventDetail'AND `tablename`='qc_gastro_ed_lifestyle'AND `field`='food_charbroiled_nb_days_per_week'AND `type`='integer'AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`=''AND `language_label`='qc_gastro_food_charbroiled_nb_days_per_week'AND `language_tag`=''),'2','7','','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','0','1','0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_lifestyle'), (SELECT id FROM structure_fields WHERE `model`='EventDetail'AND `tablename`='qc_gastro_ed_lifestyle'AND `field`='can_digest_milk'AND `type`='checkbox'AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`=''AND `language_label`='qc_gastro_can_digest_milk'AND `language_tag`=''),'2','8','','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','0','1','0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_lifestyle'), (SELECT id FROM structure_fields WHERE `model`='EventDetail'AND `tablename`='qc_gastro_ed_lifestyle'AND `field`='taking_multi_vitamins'AND `type`='checkbox'AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`=''AND `language_label`='qc_gastro_taking_multi_vitamins'AND `language_tag`=''),'2','9','','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','0','1','0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_lifestyle'), (SELECT id FROM structure_fields WHERE `model`='EventDetail'AND `tablename`='qc_gastro_ed_lifestyle'AND `field`='taking_calcium_supplement'AND `type`='checkbox'AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`=''AND `language_label`='qc_gastro_taking_calcium_supplement'AND `language_tag`=''),'2','10','','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','0','1','0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_lifestyle'), (SELECT id FROM structure_fields WHERE `model`='EventDetail'AND `tablename`='qc_gastro_ed_lifestyle'AND `field`='taking_vitamin_d_supplement'AND `type`='checkbox'AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`=''AND `language_label`='qc_gastro_taking_vitamin_d_supplement'AND `language_tag`=''),'2','11','','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','0','1','0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_lifestyle'), (SELECT id FROM structure_fields WHERE `model`='EventDetail'AND `tablename`='qc_gastro_ed_lifestyle'AND `field`='height_cm'AND `type`='float_positive'AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`=''),'1','1','general','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','0','1','0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_lifestyle'), (SELECT id FROM structure_fields WHERE `model`='EventDetail'AND `tablename`='qc_gastro_ed_lifestyle'AND `field`='sport_nb_days_per_week'AND `type`='integer'AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`=''AND `language_label`='qc_gastro_lifestyle_sport_nb_days_per_week'AND `language_tag`=''),'2','3','sport','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','0','1','0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_lifestyle'), (SELECT id FROM structure_fields WHERE `model`='EventDetail'AND `tablename`='qc_gastro_ed_lifestyle'AND `field`='drink_per_time'AND `type`='select'AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_drinking_qty')  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`=''AND `language_label`='qc_gastro_lifestyle_how_many_drinks_at_one_time'AND `language_tag`=''),'2','1','drinking','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','0','1','0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_lifestyle'), (SELECT id FROM structure_fields WHERE `model`='EventDetail'AND `tablename`='qc_gastro_ed_lifestyle'AND `field`='food_fat_nb_days_per_week'AND `type`='integer'AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`=''AND `language_label`='qc_gastro_food_fat_nb_days_per_week'AND `language_tag`=''),'2','4','eating','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','0','1','0');
UPDATE structure_fields SET  `language_label`='smoking'WHERE model='EventDetail'AND tablename='qc_gastro_ed_lifestyle'AND field='do_you_smoke'AND `type`='select'AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_do_you_smoke');
UPDATE structure_fields SET  `language_help`='qc_gastro_lifestyle_sibling_has_cancer',  `language_label`='parent/sibling/child having cancer'WHERE model='EventDetail'AND tablename='qc_gastro_ed_lifestyle'AND field='sibling_has_cancer'AND `type`='checkbox'AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `language_help`='how much did (do) you smoke a day',  `language_label`='smoking qty/day'WHERE model='EventDetail'AND tablename='qc_gastro_ed_lifestyle'AND field='smoke_per_day'AND `type`='select'AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_smoke_per_day');
UPDATE structure_fields SET  `language_label`='smoking for how long'WHERE model='EventDetail'AND tablename='qc_gastro_ed_lifestyle'AND field='smoke_how_long'AND `type`='select'AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_smoke_how_long');
UPDATE structure_fields SET  `language_label`='quitted when'WHERE model='EventDetail'AND tablename='qc_gastro_ed_lifestyle'AND field='smoke_quit_when'AND `type`='select'AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_smoke_how_long');
UPDATE structure_fields SET  `language_help`='did one or both of you parents smoke when you were a child',  `language_label`='when child, smoking parents'WHERE model='EventDetail'AND tablename='qc_gastro_ed_lifestyle'AND field='smoke_parent'AND `type`='checkbox'AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `language_help`='did you mother smoke when she was pregnant with you',  `language_label`='smoking mother while pregnant with you'WHERE model='EventDetail'AND tablename='qc_gastro_ed_lifestyle'AND field='smoke_mother_pregnant'AND `type`='checkbox'AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `language_help`='how many alcholic beverages do you drink in a typical week',  `language_label`='qty/week'WHERE model='EventDetail'AND tablename='qc_gastro_ed_lifestyle'AND field='drink_per_week'AND `type`='select'AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_drinking_qty');
UPDATE structure_fields SET  `language_help`='qc_gastro_food_charbroiled_nb_days_per_week',  `language_label`='charboiled food days/week'WHERE model='EventDetail'AND tablename='qc_gastro_ed_lifestyle'AND field='food_charbroiled_nb_days_per_week'AND `type`='integer'AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `language_help`='qc_gastro_can_digest_milk',  `language_label`='can digest milk'WHERE model='EventDetail'AND tablename='qc_gastro_ed_lifestyle'AND field='can_digest_milk'AND `type`='checkbox'AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `language_help`='',  `language_label`='multi-vitamins'WHERE model='EventDetail'AND tablename='qc_gastro_ed_lifestyle'AND field='taking_multi_vitamins'AND `type`='checkbox'AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `language_help`='qc_gastro_taking_calcium_supplement',  `language_label`='calcium supplement'WHERE model='EventDetail'AND tablename='qc_gastro_ed_lifestyle'AND field='taking_calcium_supplement'AND `type`='checkbox'AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `language_help`='qc_gastro_taking_vitamin_d_supplement',  `language_label`='vitamin d supplement'WHERE model='EventDetail'AND tablename='qc_gastro_ed_lifestyle'AND field='taking_vitamin_d_supplement'AND `type`='checkbox'AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `language_help`='qc_gastro_lifestyle_sport_nb_days_per_week',  `language_label`='sport days/week'WHERE model='EventDetail'AND tablename='qc_gastro_ed_lifestyle'AND field='sport_nb_days_per_week'AND `type`='integer'AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `language_help`='qc_gastro_lifestyle_how_many_drinks_at_one_time',  `language_label`='drinks/time'WHERE model='EventDetail'AND tablename='qc_gastro_ed_lifestyle'AND field='drink_per_time'AND `type`='select'AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_drinking_qty');
UPDATE structure_fields SET  `language_help`='qc_gastro_food_fiber_nb_days_per_week',  `language_label`='fiber food days/week'WHERE model='EventDetail'AND tablename='qc_gastro_ed_lifestyle'AND field='food_fiber_nb_days_per_week'AND `type`='integer'AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `language_help`='qc_gastro_food_smoked_salted_nb_days_per_week',  `language_label`='smoked/salted food days/week'WHERE model='EventDetail'AND tablename='qc_gastro_ed_lifestyle'AND field='food_smoked_salted_nb_days_per_week'AND `type`='integer'AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `language_help`='qc_gastro_food_fat_nb_days_per_week',  `language_label`='fat food days/week'WHERE model='EventDetail'AND tablename='qc_gastro_ed_lifestyle'AND field='food_fat_nb_days_per_week'AND `type`='integer'AND structure_value_domain  IS NULL ;




-- quality control score moved to grid
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0'WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='QualityCtrl'AND `tablename`='quality_ctrls'AND `field`='score'AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0'WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='QualityCtrl'AND `tablename`='quality_ctrls'AND `field`='unit'AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='quality_control_unit') AND `flag_confidential`='0');

CREATE TABLE qc_gastro_qc_scores(
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 quality_ctrl_id INT NOT NULL,
 score VARCHAR(30) NOT NULL DEFAULT'',
 unit VARCHAR(30) NOT NULL DEFAULT'',
 created DATETIME NOT NULL,
 created_by INT UNSIGNED NOT NULL,
 modified DATETIME NOT NULL,
 modified_by INT UNSIGNED NOT NULL,
 deleted BOOLEAN NOT NULL DEFAULT 0,
 deleted_date DATETIME DEFAULT NULL 
)Engine=InnoDb;
CREATE TABLE qc_gastro_qc_scores_revs(
 id INT UNSIGNED NOT NULL,
 quality_ctrl_id INT NOT NULL,
 score VARCHAR(30) NOT NULL DEFAULT'',
 unit VARCHAR(30) NOT NULL DEFAULT'',
 created DATETIME NOT NULL,
 created_by INT UNSIGNED NOT NULL,
 modified DATETIME NOT NULL,
 modified_by INT UNSIGNED NOT NULL,
 deleted BOOLEAN NOT NULL DEFAULT 0,
 deleted_date DATETIME DEFAULT NULL,
 version_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 version_created DATETIME NOT NULL 
)Engine=InnoDb;
INSERT INTO structures(`alias`) VALUES ('qc_gastro_qc_scores');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement','QcGastroQcScore','qc_gastro_qc_scores','score','input',  NULL ,'0','','','','score',''), 
('Inventorymanagement','QcGastroQcScore','qc_gastro_qc_scores','unit','select', (SELECT id FROM structure_value_domains WHERE domain_name='quality_control_unit') ,'0','','','','','');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_gastro_qc_scores'), (SELECT id FROM structure_fields WHERE `model`='QcGastroQcScore'AND `tablename`='qc_gastro_qc_scores'AND `field`='score'AND `type`='input'AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`=''AND `language_label`='score'AND `language_tag`=''),'1','1','','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','1','0','1','0','0','0','1','0','0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_qc_scores'), (SELECT id FROM structure_fields WHERE `model`='QcGastroQcScore'AND `tablename`='qc_gastro_qc_scores'AND `field`='unit'AND `type`='select'AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='quality_control_unit')  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`=''AND `language_label`=''AND `language_tag`=''),'1','2','','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','1','0','1','0','0','0','1','0','0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement','QcGastroQcScore','qc_gastro_qc_scores','id','hidden',  NULL ,'0','','','','','');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_gastro_qc_scores'), (SELECT id FROM structure_fields WHERE `model`='QcGastroQcScore'AND `tablename`='qc_gastro_qc_scores'AND `field`='id'AND `type`='hidden'AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`=''AND `language_label`=''AND `language_tag`=''),'1','3','','0','','0','','0','','0','','0','','0','','0','0','1','0','0','0','0','0','0','0','0','0','0','0','0');
UPDATE structure_formats SET `flag_editgrid`='1'WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_gastro_qc_scores') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='QcGastroQcScore'AND `tablename`='qc_gastro_qc_scores'AND `field`='id'AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- rna micro-rna checkbox
ALTER TABLE sd_der_rnas
 ADD COLUMN qc_gastro_micro_rna BOOLEAN DEFAULT NULL AFTER sample_master_id;
ALTER TABLE sd_der_rnas_revs
 ADD COLUMN qc_gastro_micro_rna BOOLEAN DEFAULT NULL AFTER sample_master_id;

INSERT INTO structures(`alias`) VALUES ('qc_gastro_sd_rna');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement','SampleDetail','sd_der_rnas','qc_gastro_micro_rna','checkbox',  NULL ,'0','','','','micro-rna','');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_gastro_sd_rna'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail'AND `tablename`='sd_der_rnas'AND `field`='qc_gastro_micro_rna'AND `type`='checkbox'AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`=''AND `language_label`='micro-rna'AND `language_tag`=''),'1','29','','0','','0','','0','','0','','0','','0','','1','0','1','0','1','0','0','0','0','0','0','0','0','1','0');

UPDATE sample_controls SET form_alias='sample_masters,sd_undetailed_derivatives,derivative_lab_book,qc_gastro_sd_rna'WHERE id=13;

-- pbmc ficol use
ALTER TABLE sd_der_pbmcs
 ADD COLUMN qc_gastro_ficol BOOLEAN DEFAULT NULL AFTER sample_master_id;
ALTER TABLE sd_der_rnas_revs
 ADD COLUMN qc_gastro_ficol BOOLEAN DEFAULT NULL AFTER sample_master_id;

INSERT INTO structures(`alias`) VALUES ('qc_gastro_sd_pbmc');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement','SampleDetail','sd_der_pbmcs','qc_gastro_ficol','checkbox',  NULL ,'0','','','','ficol use','');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_gastro_sd_pbmc'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail'AND `tablename`='sd_der_pbmcs'AND `field`='qc_gastro_ficol'AND `type`='checkbox'AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`=''AND `language_label`='ficol use'AND `language_tag`=''),'1','29','','0','','0','','0','','0','','0','','0','','1','0','1','0','1','0','0','0','0','0','0','0','0','1','0');

UPDATE sample_controls SET form_alias='sample_masters,sd_undetailed_derivatives,derivative_lab_book,qc_gastro_sd_pbmc'WHERE id=8;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_add ='0', sfo.flag_add_readonly ='0', 
sfo.flag_edit ='1', sfo.flag_edit_readonly ='1',
sfo.flag_search ='1', sfo.flag_search_readonly ='0',
sfo.flag_index ='1', sfo.flag_detail ='1',
language_heading ='system data',
sfo.display_column ='3', sfo.display_order ='98'WHERE sfi.field IN ('participant_identifier') 
AND str.alias IN ('participants')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

INSERT IGNORE INTO i18n (id,en,fr) VALUES
('system data','System Data','Données système'),
('tissue source','Source','Source'),
('hospital number','Hospital Number','Numéro d''Hôpital');

REPLACE INTO i18n (id, en, fr) VALUES
('participant identifier','Participant System Code','Code système participant'); 

UPDATE structure_formats SET `language_heading`='clin_demographics'WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Participant'AND tablename='participants'AND field='title'AND type='select'AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='person title'));

INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `on_action`, `language_message`) VALUES
(null, (SELECT id FROM structure_fields WHERE `model`='Participant'AND `field`='first_name'),'notEmpty','','value is required'),
(null, (SELECT id FROM structure_fields WHERE `model`='Participant'AND `field`='last_name'),'notEmpty','','value is required');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0'WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Participant'AND tablename='participants'AND field='middle_name'AND type='input'AND structure_value_domain  IS NULL );

UPDATE structure_formats SET `flag_add`='0', `flag_add_readonly`='0', `flag_edit`='0', `flag_edit_readonly`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0'WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE model='MiscIdentifier'AND tablename='misc_identifiers'AND field IN ('notes','effective_date','identifier_abrv','expiry_date'));

UPDATE misc_identifier_controls SET misc_identifier_name = misc_identifier_name_abbrev WHERE misc_identifier_name_abbrev ='RAMQ';

CREATE TABLE IF NOT EXISTS `qc_gastro_cd_consents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `consent_master_id` int(11) NOT NULL,
  
  `qc_gastro_language` VARCHAR (20) NOT NULL,
  `qc_gastro_access_med_file` BOOLEAN DEFAULT NULL,
  `qc_gastro_bio_material` BOOLEAN DEFAULT NULL,
  `qc_gastro_blood_col` BOOLEAN DEFAULT NULL,
  `qc_gastro_saliva_col` BOOLEAN DEFAULT NULL,
 
  `created` datetime NOT NULL DEFAULT'0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT'0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `consent_master_id` (`consent_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `qc_gastro_cd_consents_revs` (
  `id` int(11) NOT NULL,
  `consent_master_id` int(11) NOT NULL,
  
  `qc_gastro_language` VARCHAR (20) NOT NULL,
  `qc_gastro_access_med_file` BOOLEAN DEFAULT NULL,
  `qc_gastro_bio_material` BOOLEAN DEFAULT NULL,
  `qc_gastro_blood_col` BOOLEAN DEFAULT NULL,
  `qc_gastro_saliva_col` BOOLEAN DEFAULT NULL,
  
  `created` datetime NOT NULL DEFAULT'0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT'0',
  `deleted_date` datetime DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;


ALTER TABLE `qc_gastro_cd_consents`
  ADD CONSTRAINT `qc_gastro_cd_consents_ibfk_1` FOREIGN KEY (`consent_master_id`) REFERENCES `consent_masters` (`id`);

INSERT INTO `consent_controls` (`id`, `controls_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
(null,'consent ld gastro', 1,'qc_gastro_cd_consents','qc_gastro_cd_consents', 0,'consent ld gastro');

UPDATE consent_controls SET flag_active ='0'WHERE id = 1;

INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) VALUES
('qc_gastro tissue source list', 1, 50),
('qc_gastro consent version', 1, 50);
UPDATE structure_value_domains SET source="StructurePermissibleValuesCustom::getCustomDropdown('qc_gastro tissue source list')" WHERE domain_name='tissue_source_list';
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES 
('qc_gastro consent version','','', "StructurePermissibleValuesCustom::getCustomDropdown('qc_gastro consent version')");
UPDATE structure_fields SET structure_value_domain=(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro consent version'), type='select', setting=''WHERE id='775';

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation','ConsentDetail','qc_gastro_cd_consents','qc_gastro_language','select', (SELECT id FROM structure_value_domains WHERE domain_name='lang') ,'0','','','','form language',''), 
('Clinicalannotation','ConsentDetail','qc_gastro_cd_consents','qc_gastro_access_med_file','checkbox',  NULL ,'0','','','','access to medical file',''), 
('Clinicalannotation','ConsentDetail','qc_gastro_cd_consents','qc_gastro_access_med_file','checkbox',  NULL ,'0','','','','biological material storage and use',''), 
('Clinicalannotation','ConsentDetail','qc_gastro_cd_consents','qc_gastro_blood_col','checkbox',  NULL ,'0','','','','blood collection',''), 
('Clinicalannotation','ConsentDetail','qc_gastro_cd_consents','qc_gastro_saliva_col','checkbox',  NULL ,'0','','','','saliva collection','');

INSERT INTO structures(`alias`) VALUES ('qc_gastro_cd_consents');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_gastro_cd_consents'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentMaster'AND `tablename`='consent_masters'AND `field`='status_date'AND `language_label`='status date'AND `language_tag`=''AND `type`='date'AND `setting`=''AND `default`='NULL'AND `structure_value_domain`  IS NULL  AND `language_help`='help_status_date'),'1','9','','0','','0','','0','','0','','0','','0','','1','0','1','0','1','0','0','0','0','0','0','0','1','1','1'), 
((SELECT id FROM structures WHERE alias='qc_gastro_cd_consents'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentMaster'AND `tablename`='consent_masters'AND `field`='form_version'AND `language_label`='form_version'AND `language_tag`=''AND `type`='select'AND `setting`=''AND `default`=''AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro consent version')  AND `language_help`='help_form_version'),'1','5','','0','','0','','0','','0','','0','','0','','1','0','1','0','1','0','0','0','0','0','0','0','1','1','1'), 
((SELECT id FROM structures WHERE alias='qc_gastro_cd_consents'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentMaster'AND `tablename`='consent_masters'AND `field`='reason_denied'AND `language_label`='reason denied or withdrawn'AND `language_tag`=''AND `type`='textarea'AND `setting`='cols=35,rows=6'AND `default`=''AND `structure_value_domain`  IS NULL  AND `language_help`='help_reason_denied'),'1','15','','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','0','1','0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_cd_consents'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentMaster'AND `tablename`='consent_masters'AND `field`='consent_status'AND `language_label`='consent status'AND `language_tag`=''AND `type`='select'AND `setting`=''AND `default`=''AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='consent_status')  AND `language_help`='help_consent_status'),'1','8','','0','','0','','0','','0','','0','','0','','1','0','1','0','1','0','0','0','0','0','0','0','1','1','1'), 
((SELECT id FROM structures WHERE alias='qc_gastro_cd_consents'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentMaster'AND `tablename`='consent_masters'AND `field`='consent_signed_date'AND `language_label`='consent signed date'AND `language_tag`=''AND `type`='date'AND `setting`=''AND `default`=''AND `structure_value_domain`  IS NULL  AND `language_help`='help_consent_signed_date'),'1','10','','0','','0','','0','','0','','0','','0','','1','0','1','0','1','0','0','0','0','0','0','0','1','1','1'), 
((SELECT id FROM structures WHERE alias='qc_gastro_cd_consents'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentMaster'AND `tablename`='consent_masters'AND `field`='notes'AND `language_label`='notes'AND `language_tag`=''AND `type`='textarea'AND `setting`='rows=3,cols=30'AND `default`=''AND `structure_value_domain`  IS NULL  AND `language_help`='help_notes'),'2','50','','0','','0','','0','','0','','0','','0','','0','0','0','0','0','0','0','0','0','0','0','0','0','1','0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_cd_consents'), 

(SELECT id FROM structure_fields WHERE `model`='ConsentDetail'AND `tablename`='qc_gastro_cd_consents'AND `field`='qc_gastro_language'AND `language_label`='form language'AND `language_tag`=''AND `type`='select'AND `setting`=''AND `default`=''AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='lang')  AND `language_help`=''),'1','6','','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','0','1','0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_cd_consents'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentDetail'AND `tablename`='qc_gastro_cd_consents'AND `field`='qc_gastro_access_med_file'AND `language_label`='access to medical file'AND `language_tag`=''AND `type`='checkbox'AND `setting`=''AND `default`=''AND `structure_value_domain`  IS NULL  AND `language_help`=''),'2','1','acceptance','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','0','1','0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_cd_consents'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentDetail'AND `tablename`='qc_gastro_cd_consents'AND `field`='qc_gastro_access_med_file'AND `language_label`='biological material storage and use'AND `language_tag`=''AND `type`='checkbox'AND `setting`=''AND `default`=''AND `structure_value_domain`  IS NULL  AND `language_help`=''),'2','2','','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','0','1','0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_cd_consents'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentDetail'AND `tablename`='qc_gastro_cd_consents'AND `field`='qc_gastro_blood_col'AND `language_label`='blood collection'AND `language_tag`=''AND `type`='checkbox'AND `setting`=''AND `default`=''AND `structure_value_domain`  IS NULL  AND `language_help`=''),'2','3','','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','0','1','0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_cd_consents'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentDetail'AND `tablename`='qc_gastro_cd_consents'AND `field`='qc_gastro_saliva_col'AND `language_label`='saliva collection'AND `language_tag`=''AND `type`='checkbox'AND `setting`=''AND `default`=''AND `structure_value_domain`  IS NULL  AND `language_help`=''),'2','4','','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','0','1','0');

UPDATE event_controls SET flag_active ='0'WHERE detail_tablename !='qc_gastro_ed_lifestyle';

UPDATE menus SET flag_active ='0'WHERE use_link LIKE'/clinicalannotation/event_masters/%'AND id NOT IN ('clin_CAN_30','clin_CAN_4');

UPDATE `menus` SET `use_link` ='/clinicalannotation/event_masters/listall/lifestyle/%%Participant.id%%'WHERE `id` ='clin_CAN_4';

INSERT IGNORE INTO i18n (id,en,fr) VALUES
('height (feet/inches)','Height (Feet/Inches)','Taille (Pieds/Pouces)'),
('height (inches)','-','-'),
('smoking history','Smoking History','Antécédents de tabagisme'),
('height (cm)','Height (cm)','Taille (cm)'),
('consent ld gastro','JGH Central Biobank','JGH Biobanque centrale'),
('participant_ramq','RAMQ','RAMQ'),
('cigars','Cigars','Cigares'),
('did you mother smoke when she was pregnant with you','Did you mother smoke when she was pregnant with you?','Vore mère fumait elle lorsque elle était enceinte de vous?'),
('five or more','Five or more','Cinq ou plus'),
('less than a year','Less than a year','Moins d''un an'),
('more than five years','More than five years','Plus de cinq ans'),
('more than twenty times','More than twenty times','Plus de vingt fois'),
('never','Never','Jamais'),
('once to five times','Once to five times','Une à cinq fois'),
('one to five year(s)','One to five year(s)','Un à cinq an(s)'),
('one to two','one to two','Un(e) à deux'),
('quit','Quit','À cessé'),
('six to twenty times','Six to twenty times','Six à vingt fois'),
('three to four','Three to four','Trois à quatre'),
('cancer type','Cancer Type','Type de cancer'),
('colon and rectal','Colon and Rectal','Colon ou rectale'),
('zero','Zero','Zéro');

UPDATE structure_formats SET `flag_detail`='0'WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_gastro_cd_consents') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='ConsentMaster'AND tablename='consent_masters'AND field='notes'AND type='textarea'AND structure_value_domain  IS NULL );

UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0'WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='ConsentMaster'AND tablename='consent_masters'AND field='process_status'AND type='select'AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0'WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='ConsentMaster'AND tablename='consent_masters'AND field='date_first_contact'AND type='date'AND structure_value_domain  IS NULL );

UPDATE tx_controls SET flag_active ='0'WHERE tx_method LIKE'surgery without extend';
UPDATE tx_controls SET extend_tablename = null,	extend_form_alias = null WHERE tx_method !='chemotherapy';

UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0'WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='ViewCollection'AND tablename=''AND field='collection_site'AND type='select'AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='custom_collection_site'));
UPDATE structure_formats SET `flag_detail`='0'WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='ViewCollection'AND tablename=''AND field='sop_master_id'AND type='select'AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='collection_sop_list'));

UPDATE users SET flag_active = 1 WHERE username ='administrator';

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0'WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Collection'AND tablename='collections'AND field='collection_site'AND type='select'AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='custom_collection_site'));
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0'WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Collection'AND tablename='collections'AND field='sop_master_id'AND type='select'AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='collection_sop_list'));

UPDATE `banks` SET `name` ='LD-Gastro'WHERE `banks`.`id` = 1;

DROP VIEW IF EXISTS view_collections;
CREATE VIEW `view_collections` AS SELECT `col`.`id` AS `collection_id`,`col`.`bank_id` AS `bank_id`,`col`.`sop_master_id` AS `sop_master_id`,
`link`.`participant_id` AS `participant_id`,`link`.`diagnosis_master_id` AS `diagnosis_master_id`,`link`.`consent_master_id` AS `consent_master_id`,
`part`.`participant_identifier` AS `participant_identifier`,`col`.`acquisition_label` AS `acquisition_label`,`col`.`collection_site` AS `collection_site`,
`col`.`collection_datetime` AS `collection_datetime`,`col`.`collection_datetime_accuracy` AS `collection_datetime_accuracy`,
`col`.`collection_property` AS `collection_property`,`col`.`collection_notes` AS `collection_notes`,`col`.`deleted` AS `deleted`,`banks`.`name` AS `bank_name`,
`col`.`created` AS `created` , identifier.identifier_value AS participant_ramq
FROM (((`collections` `col` left join `clinical_collection_links` `link` on(((`col`.`id` = `link`.`collection_id`) and (`link`.`deleted` <> 1)))) 
LEFT JOIN `participants` `part` ON(((`link`.`participant_id` = `part`.`id`) AND (`part`.`deleted` <> 1)))) 
LEFT JOIN `banks` ON(((`col`.`bank_id` = `banks`.`id`) AND (`banks`.`deleted` <> 1)))) 
LEFT JOIN `misc_identifiers` `identifier` ON `link`.`participant_id` = `identifier`.`participant_id` AND `identifier`.`deleted` <> 1 AND identifier.identifier_name='RAMQ'WHERE (`col`.`deleted` <> 1);

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Inventorymanagement','ViewCollection','','participant_ramq','participant_ramq','','input','size=30','',  NULL ,'');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection'AND `tablename`=''AND `field`='participant_ramq'AND `language_label`='participant_ramq'AND `language_tag`=''AND `type`='input'AND `setting`='size=30'AND `default`=''AND `structure_value_domain`  IS NULL  AND `language_help`=''),'0','1','','0','','0','','0','','0','','0','','0','','0','0','0','0','1','0','0','0','0','0','0','0','1','1','1');

INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `on_action`, `language_message`) VALUES
(null, (SELECT id FROM structure_fields WHERE `model`='Collection'AND `field`='bank_id'),'notEmpty','','value is required'),
(null, (SELECT id FROM structure_fields WHERE `model`='ViewCollection'AND `field`='bank_id'),'notEmpty','','value is required');

UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_index`='1', `flag_summary`='1'WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Collection'AND tablename='collections'AND field='bank_id'AND type='select'AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='banks'));

UPDATE menus SET flag_active ='0'WHERE use_link LIKE'/material/%'OR use_link LIKE'/sop/%'; 

UPDATE menus SET flag_active ='0'WHERE `use_link` LIKE'/study/%'AND `use_link` NOT LIKE'/study/study_summaries%';

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_add ='0', sfo.flag_add_readonly ='0', 
sfo.flag_edit ='0', sfo.flag_edit_readonly ='0',
sfo.flag_search ='0', sfo.flag_search_readonly ='0',
sfo.flag_index ='0', sfo.flag_detail ='0'WHERE sfi.field NOT IN ('title','summary') 
AND str.alias ='studysummaries'AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE realiquoting_controls SET flag_active=false WHERE id IN(3);
UPDATE sample_to_aliquot_controls SET flag_active=true WHERE id IN(7, 8);
UPDATE realiquoting_controls SET flag_active=false WHERE id IN(8);

UPDATE structure_formats SET `flag_summary`='0'WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Participant'AND tablename='participants'AND field='marital_status'AND type='select'AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='marital_status'));
UPDATE structure_formats SET `flag_summary`='0'WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Participant'AND tablename='participants'AND field='title'AND type='select'AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='person title'));
UPDATE structure_formats SET `flag_summary`='0'WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Participant'AND tablename='participants'AND field='date_of_birth'AND type='date'AND structure_value_domain  IS NULL );

ALTER TABLE collections
 ADD COLUMN project VARCHAR(20) NOT NULL DEFAULT''AFTER acquisition_label;
ALTER TABLE collections_revs
 ADD COLUMN project VARCHAR(20) NOT NULL DEFAULT''AFTER acquisition_label;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Inventorymanagement','Collection','collections','project','project','','input','size=10','',  NULL ,'');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='collections'), (SELECT id FROM structure_fields WHERE `model`='Collection'AND `tablename`='collections'AND `field`='project'AND `language_label`='project'AND `language_tag`=''AND `type`='input'AND `setting`='size=10'AND `default`=''AND `structure_value_domain`  IS NULL  AND `language_help`=''),'0','2','','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','1','0','1');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0'WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Collection'AND tablename='collections'AND field='acquisition_label'AND type='input'AND structure_value_domain  IS NULL );

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='linked_collections'), (SELECT id FROM structure_fields WHERE `model`='Collection'AND `tablename`='collections'AND `field`='project'AND `language_label`='project'AND `language_tag`=''AND `type`='input'AND `setting`='size=10'AND `default`=''AND `structure_value_domain`  IS NULL  AND `language_help`=''),'0','2','','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','0','0','0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0'WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Collection'AND tablename='collections'AND field='acquisition_label'AND type='input'AND structure_value_domain  IS NULL );

INSERT IGNORE INTO i18n (id,en,fr) VALUES
('project','Project','Projet');

REPLACE INTO i18n (id, en, fr) VALUES
('acquisition_label','Biobank ID - Prefix','Biobank ID - Préfixe');

ALTER TABLE specimen_details
 ADD COLUMN specimen_biobank_id VARCHAR(20) NOT NULL DEFAULT''AFTER sample_master_id;
ALTER TABLE specimen_details_revs
 ADD COLUMN specimen_biobank_id VARCHAR(20) NOT NULL DEFAULT''AFTER sample_master_id;
 
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Inventorymanagement','SpecimenDetail','specimen_details','specimen_biobank_id','specimen biobank id','','input','size=10','',  NULL ,'');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='sd_spe_bloods'), (SELECT id FROM structure_fields WHERE `model`='SpecimenDetail'AND `tablename`='specimen_details'AND `field`='specimen_biobank_id'AND `language_label`='specimen biobank id'AND `language_tag`=''AND `type`='input'AND `setting`='size=10'AND `default`=''AND `structure_value_domain`  IS NULL  AND `language_help`=''),'1','29','','0','','0','','0','','0','','0','','0','','1','0','1','0','1','0','0','0','0','0','0','0','1','1','1');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='sd_spe_tissues'), (SELECT id FROM structure_fields WHERE `model`='SpecimenDetail'AND `tablename`='specimen_details'AND `field`='specimen_biobank_id'AND `language_label`='specimen biobank id'AND `language_tag`=''AND `type`='input'AND `setting`='size=10'AND `default`=''AND `structure_value_domain`  IS NULL  AND `language_help`=''),'1','29','','0','','0','','0','','0','','0','','0','','1','0','1','0','1','0','0','0','0','0','0','0','1','1','1');

INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `language_message`) VALUES
(NULL, (SELECT id FROM structure_fields WHERE `model`='Collection'AND `tablename`='collections'AND `field`='project'),'between,0,10','value limited to 10 characters');
INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `language_message`) VALUES
(NULL, (SELECT id FROM structure_fields WHERE `model`='SpecimenDetail'AND `tablename`='specimen_details'AND `field`='specimen_biobank_id'AND `language_label`='specimen biobank id'AND `language_tag`=''AND `type`='input'AND `setting`='size=10'AND `default`=''AND `structure_value_domain`  IS NULL  AND `language_help`=''),'custom,/^[0-9][0-9][0-9][TNB]$/','the format expected is defined as follow : 000T, 000N, 000B');

INSERT IGNORE INTO i18n (id,en,fr) VALUES
('value limited to 10 characters','The value is limited to 10 characters.','La valeur est limitée à 10 caractères.'),
('specimen biobank id','Spec-Biobank ID','Spec-Biobank ID'),
('the format expected is defined as follow : 000T, 000N, 000B','The format expected is defined as follow : 000T, 000N, 000B.','Le format attendu est défini comme suit : 000T, 000N, 000B');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0',
`flag_addgrid`='0', `flag_editgrid`='0', `flag_batchedit`='0',  `flag_index`='0', 
`flag_detail`='0'WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE model='SampleMaster'AND tablename='sample_masters'AND field='sop_master_id');

INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `on_action`, `language_message`) VALUES
(null, (SELECT id FROM structure_fields WHERE `model`='SpecimenDetail'AND `field`='specimen_biobank_id'),'notEmpty','','value is required');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0',
`flag_addgrid`='0', `flag_editgrid`='0', `flag_batchedit`='0',  `flag_index`='0', 
`flag_detail`='0'WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE model='AliquotMaster'AND tablename='aliquot_masters'AND field='sop_master_id');

UPDATE structure_fields SET language_label ='jgh gastro barcode'WHERE field ='barcode'and model LIKE'%Aliquot%';

INSERT IGNORE INTO i18n (id,en,fr) VALUES
('jgh gastro barcode','Biobank ID','Biobank ID'),
('jgh gastro barcode is required','Biobank ID is required!','Le''Biobank ID''est requis!');

UPDATE structure_validations
SET language_message ='jgh gastro barcode is required'WHERE language_message ='barcode is required'AND structure_field_id in (SELECT id FROM structure_fields WHERE field ='barcode'and model LIKE'%Aliquot%');

REPLACE INTO i18n (id,en,fr) VALUES
('the barcode [%s] has already been recorded','The Biobank ID [%s] has already been recorded!','Le Biobank ID [%s] a déjà été enregistré!'),
('you can not record barcode [%s] twice','You can not record Biobank ID [%s] twice!','Vous ne pouvez enregistrer le Biobank ID [%s] deux fois!');

INSERT INTO `storage_controls` (`id`, `storage_type`, `storage_type_code`, `coord_x_title`, `coord_x_type`, `coord_x_size`, `coord_y_title`, `coord_y_type`, `coord_y_size`, `display_x_size`, `display_y_size`, `reverse_x_numbering`, `reverse_y_numbering`, `horizontal_increment`, `set_temperature`, `is_tma_block`, `flag_active`, `form_alias`, `detail_tablename`, `databrowser_label`) VALUES
(null,'box100','B100','position','integer', 100, NULL, NULL, NULL, 10, 10, 0, 0, 1,'FALSE','FALSE', 1,'std_undetail_stg_with_surr_tmp','std_boxs','box100');

INSERT IGNORE INTO i18n (id,en,fr) VALUES
('box100','Box100 1-100','Boîte100 1-100'),
('qc gastro block cut thickness','Thickness','Épaisseur');

UPDATE storage_controls SET flag_active ='0'WHERE is_tma_block ='TRUE';

UPDATE sample_controls SET form_alias=REPLACE(form_alias,',derivative_lab_book','') WHERE form_alias LIKE'%derivative_lab_book%';

UPDATE lab_book_controls SET flag_active ='0'WHERE book_type !='slide creation';

ALTER TABLE lbd_slide_creations
 ADD COLUMN qc_gastro_block_cut_thickness int(10) NULL AFTER sections_nbr;
ALTER TABLE lbd_slide_creations_revs
 ADD COLUMN qc_gastro_block_cut_thickness int(10) NULL AFTER sections_nbr;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Labbook','LabBookDetail','lbd_slide_creations','qc_gastro_block_cut_thickness','qc gastro block cut thickness','','integer','size=3','',  NULL ,'');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='lbd_slide_creations'), (SELECT id FROM structure_fields WHERE `model`='LabBookDetail'AND `tablename`='lbd_slide_creations'AND `field`='qc_gastro_block_cut_thickness'AND `language_label`='qc gastro block cut thickness'AND `language_tag`=''AND `type`='integer'AND `setting`='size=3'AND `default`=''AND `structure_value_domain`  IS NULL  AND `language_help`=''),'0','10','','0','','0','','0','','0','','0','','0','','1','0','1','0','1','0','0','0','0','0','0','0','1','1','0');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0',
`flag_addgrid`='0', `flag_editgrid`='0', `flag_batchedit`='0',  `flag_index`='0', 
`flag_detail`='0'WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE model='Collection'AND field='collection_site');

UPDATE structure_formats SET `display_order`='14', `language_heading`='system data'WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='ViewCollection'AND tablename=''AND field='participant_identifier'AND type='input'AND structure_value_domain  IS NULL );

UPDATE structure_formats SET `display_order`='15'WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='ViewCollection'AND tablename='view_collections'AND field='created'AND type='datetime'AND structure_value_domain  IS NULL );

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Inventorymanagement','ViewSample','','participant_ramq','participant_ramq','','input','size=30','',  NULL ,'');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='view_sample_joined_to_collection'), 
(SELECT id FROM structure_fields WHERE `model`='ViewSample'AND `tablename`=''AND `field`='participant_ramq'AND `language_label`='participant_ramq'AND `language_tag`=''AND `type`='input'AND `setting`='size=30'AND `default`=''AND `structure_value_domain`  IS NULL  AND `language_help`=''),'0','1','','0','','0','','0','','0','','0','','0','','0','0','0','0','1','0','0','0','0','0','0','0','1','1','1');

UPDATE structure_formats SET `display_order`='15', `language_heading`='system data'WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='ViewSample'AND tablename=''AND field='participant_identifier'AND type='input'AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `display_order`='2'WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='ViewSample'AND tablename=''AND field='participant_ramq'AND type='input'AND structure_value_domain  IS NULL );

DROP VIEW IF EXISTS view_samples;
CREATE VIEW view_samples AS 
SELECT 
samp.id AS sample_master_id,
samp.parent_id AS parent_sample_id,
samp.initial_specimen_sample_id,
samp.collection_id AS collection_id,

col.bank_id, 
col.sop_master_id, 
link.participant_id, 
link.diagnosis_master_id, 
link.consent_master_id,

part.participant_identifier, 

col.acquisition_label, 

specimen.sample_type AS initial_specimen_sample_type,
specimen.sample_control_id AS initial_specimen_sample_control_id,
specimen_detail.specimen_biobank_id,
parent_samp.sample_type AS parent_sample_type,
parent_samp.sample_control_id AS parent_sample_control_id,
samp.sample_type,
samp.sample_control_id,
samp.sample_code,
samp.sample_category,
samp.deleted, 
identifier.identifier_value AS participant_ramq

FROM sample_masters as samp
INNER JOIN collections AS col ON col.id = samp.collection_id AND col.deleted != 1
LEFT JOIN sample_masters as specimen ON samp.initial_specimen_sample_id = specimen.id AND specimen.deleted != 1
LEFT JOIN specimen_details as specimen_detail ON specimen.id = specimen_detail.sample_master_id AND specimen_detail.deleted != 1
LEFT JOIN sample_masters as parent_samp ON samp.parent_id = parent_samp.id AND parent_samp.deleted != 1
LEFT JOIN clinical_collection_links AS link ON col.id = link.collection_id AND link.deleted != 1
LEFT JOIN participants AS part ON link.participant_id = part.id AND part.deleted != 1
LEFT JOIN `misc_identifiers` `identifier` ON `link`.`participant_id` = `identifier`.`participant_id` AND `identifier`.`deleted` <> 1 AND identifier.identifier_name='RAMQ'WHERE samp.deleted != 1;

DROP VIEW IF EXISTS view_aliquots;
CREATE VIEW view_aliquots AS 
SELECT 
al.id AS aliquot_master_id,
al.sample_master_id AS sample_master_id,
al.collection_id AS collection_id, 
col.bank_id, 
al.storage_master_id AS storage_master_id,
link.participant_id, 
link.diagnosis_master_id, 
link.consent_master_id,

part.participant_identifier, 

col.acquisition_label, 

specimen.sample_type AS initial_specimen_sample_type,
specimen.sample_control_id AS initial_specimen_sample_control_id,
parent_samp.sample_type AS parent_sample_type,
parent_samp.sample_control_id AS parent_sample_control_id,
samp.sample_type,
samp.sample_control_id,

al.barcode,
al.aliquot_type,
al.aliquot_control_id,
al.in_stock,

stor.code,
stor.selection_label,
al.storage_coord_x,
al.storage_coord_y,

stor.temperature,
stor.temp_unit,

al.created,
al.deleted, 
identifier.identifier_value AS participant_ramq

FROM aliquot_masters as al
INNER JOIN sample_masters as samp ON samp.id = al.sample_master_id AND samp.deleted != 1
INNER JOIN collections AS col ON col.id = samp.collection_id AND col.deleted != 1
LEFT JOIN sample_masters as specimen ON samp.initial_specimen_sample_id = specimen.id AND specimen.deleted != 1
LEFT JOIN sample_masters as parent_samp ON samp.parent_id = parent_samp.id AND parent_samp.deleted != 1
LEFT JOIN clinical_collection_links AS link ON col.id = link.collection_id AND link.deleted != 1
LEFT JOIN participants AS part ON link.participant_id = part.id AND part.deleted != 1
LEFT JOIN storage_masters AS stor ON stor.id = al.storage_master_id AND stor.deleted != 1
LEFT JOIN `misc_identifiers` `identifier` ON `link`.`participant_id` = `identifier`.`participant_id` AND `identifier`.`deleted` <> 1 AND identifier.identifier_name='RAMQ'WHERE al.deleted != 1;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Inventorymanagement','ViewAliquot','','participant_ramq','participant_ramq','','input','size=30','',  NULL ,'');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection'), 
(SELECT id FROM structure_fields WHERE `model`='ViewAliquot'AND `tablename`=''AND `field`='participant_ramq'AND `language_label`='participant_ramq'AND `language_tag`=''AND `type`='input'AND `setting`='size=30'AND `default`=''AND `structure_value_domain`  IS NULL  AND `language_help`=''),'0','1','','0','','0','','0','','0','','0','','0','','0','0','0','0','1','0','0','0','0','0','0','0','1','1','1');

UPDATE structure_formats SET `flag_summary`='0'WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters_for_search_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Collection'AND tablename='collections'AND field='acquisition_label'AND type='input'AND structure_value_domain  IS NULL );

UPDATE structure_formats SET `display_order`='31'WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='ViewAliquot'AND tablename='view_aliquots'AND field='created'AND type='datetime'AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `display_order`='30', `language_heading`='system data'WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='ViewAliquot'AND tablename=''AND field='participant_identifier'AND type='input'AND structure_value_domain  IS NULL );

INSERT IGNORE INTO i18n (id,en,fr) VALUES
('colon or rectal','Colon or Rectal','Côlon ou Rectum');

UPDATE structure_fields SET flag_confidential = 1 WHERE model ='Participant'AND field IN ('first_name','last_name','date_of_birth');
UPDATE structure_fields SET flag_confidential = 1 WHERE field IN ('participant_ramq');

UPDATE structure_formats SET `flag_addgrid`='1', `flag_index`='1'WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_gastro_sd_pbmc') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='SampleDetail'AND tablename='sd_der_pbmcs'AND field='qc_gastro_ficol'AND type='checkbox'AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_addgrid`='1', `flag_index`='1'WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_gastro_sd_rna') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='SampleDetail'AND tablename='sd_der_rnas'AND field='qc_gastro_micro_rna'AND type='checkbox'AND structure_value_domain  IS NULL );

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Inventorymanagement','ViewSample','','specimen_biobank_id','specimen biobank id','','input','size=10','',  NULL ,'');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='view_sample_joined_to_collection'), 
(SELECT id FROM structure_fields WHERE `model`='ViewSample'AND `field`='specimen_biobank_id'),'0','3','','0','','0','','0','','0','','0','','0','','0','0','0','0','1','0','0','0','0','0','0','0','1','0','0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='view_sample_joined_to_parent'), 
(SELECT id FROM structure_fields WHERE `model`='ViewSample'AND `field`='specimen_biobank_id'),'0','2','','0','','0','','0','','0','','0','','0','','0','0','0','0','0','0','0','0','0','0','0','0','1','0','0');

UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_search`='1', `flag_addgrid`='1', `flag_detail`='1'WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='SpecimenDetail'AND tablename=''AND field='supplier_dept'AND type='select'AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='custom_specimen_supplier_dept'));
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_search`='1', `flag_addgrid`='1', `flag_detail`='1'WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='SpecimenDetail'AND tablename=''AND field='reception_by'AND type='select'AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff'));

UPDATE structure_formats 
SET `flag_override_label`='1', `language_label`='reception date in laboratory'WHERE structure_id IN (SELECT id FROM structures WHERE alias IN ('sd_spe_bloods','sd_spe_tissues')) 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail'AND `tablename`=''AND `field`='reception_datetime'AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats 
SET `flag_override_label`='1', `language_label`='tube code'WHERE structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail'AND `field`='lot_number');

INSERT INTO `storage_controls` (`storage_type`, `storage_type_code`, `coord_x_title`, `coord_x_type`, `coord_x_size`, `coord_y_title`, `coord_y_type`, `coord_y_size`, `display_x_size`, `display_y_size`, `reverse_x_numbering`, `reverse_y_numbering`, `horizontal_increment`, `set_temperature`, `is_tma_block`, `flag_active`, `form_alias`, `detail_tablename`, `databrowser_label`) VALUES
('box100 1A-10J','B2D100','column','integer', 10,'row','alphabetical', 10, 0, 0, 0, 0, 1,'FALSE','FALSE', 1,'std_undetail_stg_with_surr_tmp','std_boxs','box100 1A-10J');

INSERT IGNORE INTO i18n (id,en,fr) VALUES
('reception date in laboratory','Reception Date in Lab.','Date de réception dans le labo'),
('tube code','Tube Code','Code du tube'),
('box100 1A-20E','Box100 1A-10J','Boîte100 1A-10J');

UPDATE structure_formats 
SET `flag_add`='0', `flag_add_readonly`='0', `flag_edit`='0', `flag_edit_readonly`='0', 
`flag_search`='0', `flag_search_readonly`='0', `flag_addgrid`='0', `flag_addgrid_readonly`='0', `flag_editgrid`='0', 
`flag_editgrid_readonly`='0', `flag_batchedit`='0', `flag_batchedit_readonly`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0'WHERE structure_field_id=(SELECT id FROM structure_fields WHERE field LIKE'barcode'AND model LIKE'StorageMaster');










-- CAP reports
CREATE TABLE qc_gastro_dxd_cap_lungs(
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 diagnosis_master_id INT NOT NULL,
 specimen VARCHAR(50) NOT NULL DEFAULT'',
 m_procedure VARCHAR(50) NOT NULL DEFAULT'',
 specimen_laterality VARCHAR(10) NOT NULL DEFAULT'',
 tumor_site VARCHAR(50) NOT NULL DEFAULT'',
 tumor_size_cannot_determine VARCHAR(6) NOT NULL DEFAULT'', 
 tumor_size_greatest_cm FLOAT UNSIGNED DEFAULT NULL,
 tumor_size_add1_cm FLOAT UNSIGNED DEFAULT NULL,
 tumor_size_add2_cm FLOAT UNSIGNED DEFAULT NULL,
 histologic_type VARCHAR(250) NOT NULL DEFAULT'',
 histologic_type_precision VARCHAR(250) NOT NULL DEFAULT'',
 histologic_grade VARCHAR(50) NOT NULL DEFAULT'',
 lymph_vascular_invasion VARCHAR(50) NOT NULL DEFAULT'',
 ptmn_m VARCHAR(6) NOT NULL DEFAULT'', 
 ptmn_r VARCHAR(6) NOT NULL DEFAULT'', 
 ptmn_y VARCHAR(6) NOT NULL DEFAULT'',
 created DATETIME NOT NULL,
 created_by INT UNSIGNED NOT NULL,
 modified DATETIME NOT NULL,
 modified_by INT UNSIGNED NOT NULL,
 deleted BOOLEAN NOT NULL DEFAULT 0,
 deleted_date DATETIME DEFAULT NULL,
 FOREIGN KEY (`diagnosis_master_id`) REFERENCES diagnosis_masters(id)
)Engine=InnoDb;
CREATE TABLE qc_gastro_dxd_cap_lungs_revs(
 id INT UNSIGNED NOT NULL,
 diagnosis_master_id INT NOT NULL,
 specimen VARCHAR(50) NOT NULL DEFAULT'',
 m_procedure VARCHAR(50) NOT NULL DEFAULT'',
 specimen_laterality VARCHAR(10) NOT NULL DEFAULT'',
 tumor_site VARCHAR(50) NOT NULL DEFAULT'',
 tumor_size_cannot_determine VARCHAR(6) NOT NULL DEFAULT'', 
 tumor_size_greatest_cm FLOAT UNSIGNED DEFAULT NULL,
 tumor_size_add1_cm FLOAT UNSIGNED DEFAULT NULL,
 tumor_size_add2_cm FLOAT UNSIGNED DEFAULT NULL,
 histologic_type VARCHAR(50) NOT NULL DEFAULT'',
 histologic_type_precision VARCHAR(250) NOT NULL DEFAULT'',
 histologic_grade VARCHAR(250) NOT NULL DEFAULT'',
 lymph_vascular_invasion VARCHAR(50) NOT NULL DEFAULT'',
 ptmn_m VARCHAR(6) NOT NULL DEFAULT'', 
 ptmn_r VARCHAR(6) NOT NULL DEFAULT'', 
 ptmn_y VARCHAR(6) NOT NULL DEFAULT'',
 created DATETIME NOT NULL,
 created_by INT UNSIGNED NOT NULL,
 modified DATETIME NOT NULL,
 modified_by INT UNSIGNED NOT NULL,
 deleted BOOLEAN NOT NULL DEFAULT 0,
 deleted_date DATETIME DEFAULT NULL,
 version_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 version_created DATETIME NOT NULL
)Engine=InnoDb;

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_gastro_cap_lung_specimen','','', "StructurePermissibleValuesCustom::getCustomDropdown('cap lung specimen')");
INSERT INTO structure_permissible_values_custom_controls(name, flag_active, values_max_length) VALUES ('cap lung specimen', 1, 50);
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_gastro_cap_lung_procedure','','', "StructurePermissibleValuesCustom::getCustomDropdown('cap lung procedure')");
INSERT INTO structure_permissible_values_custom_controls(name, flag_active, values_max_length) VALUES ('cap lung procedure', 1, 50);
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_gastro_cap_lung_tumor_site','','', "StructurePermissibleValuesCustom::getCustomDropdown('cap lung tumor site')");
INSERT INTO structure_permissible_values_custom_controls(name, flag_active, values_max_length) VALUES ('cap lung tumor site', 1, 50);
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_gastro_cap_lung_histologic_grade','','', "StructurePermissibleValuesCustom::getCustomDropdown('cap lung histologic grade')");
INSERT INTO structure_permissible_values_custom_controls(name, flag_active, values_max_length) VALUES ('cap lung histologic grade', 1, 50);

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_gastro_cap_lung_histologic_type','','', NULL);
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_gastro_not_id_pres_indet','','', NULL);

INSERT INTO structures(`alias`) VALUES ('qc_gastro_dxd_cap_lungs');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation','DiagnosisDetail','qc_gastro_dxd_cap_lungs','specimen_laterality','select',  (SELECT id FROM structure_value_domains WHERE domain_name='laterality') ,'0','','','','specimen laterality',''), 
('Clinicalannotation','DiagnosisDetail','qc_gastro_dxd_cap_lungs','specimen','select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_lung_specimen') ,'0','','','','specimen',''), 
('Clinicalannotation','DiagnosisDetail','qc_gastro_dxd_cap_lungs','m_procedure','select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_lung_procedure') ,'0','','','','procedure',''), 
('Clinicalannotation','DiagnosisDetail','qc_gastro_dxd_cap_lungs','tumor_site','select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_lung_tumor_site') ,'0','','','','tumor site',''), 
('Clinicalannotation','DiagnosisDetail','qc_gastro_dxd_cap_lungs','tumor_size_cannot_determine','checkbox',  NULL ,'0','','','','cannot be determined',''), 
('Clinicalannotation','DiagnosisDetail','qc_gastro_dxd_cap_lungs','tumor_size_greatest_cm','float_positive',  NULL ,'0','','','','greatest dimension (cm)',''), 
('Clinicalannotation','DiagnosisDetail','qc_gastro_dxd_cap_lungs','tumor_size_add1_cm','float_positive',  NULL ,'0','','','','additional dimensions (cm)',''), 
('Clinicalannotation','DiagnosisDetail','qc_gastro_dxd_cap_lungs','tumor_size_add2_cm','float_positive',  NULL ,'0','','','','','x'), 
('Clinicalannotation','DiagnosisDetail','qc_gastro_dxd_cap_lungs','histologic_type','select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_lung_histologic_type') ,'0','','','','histologic type',''), 
('Clinicalannotation','DiagnosisDetail','qc_gastro_dxd_cap_lungs','histologic_type_precision','input',  NULL ,'0','','','','precision (if any)',''), 
('Clinicalannotation','DiagnosisDetail','qc_gastro_dxd_cap_lungs','histologic_grade','select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_lung_histologic_grade') ,'0','','','','histologic grade',''), 
('Clinicalannotation','DiagnosisDetail','qc_gastro_dxd_cap_lungs','lymph_vascular_invasion','select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_not_id_pres_indet') ,'0','','','','lymph vascular invasion',''), 
('Clinicalannotation','DiagnosisDetail','qc_gastro_dxd_cap_lungs','ptmn_m','checkbox',  NULL ,'0','','','','m (multiple primary tumors)',''), 
('Clinicalannotation','DiagnosisDetail','qc_gastro_dxd_cap_lungs','ptmn_r','checkbox',  NULL ,'0','','','','r (recurrent)',''), 
('Clinicalannotation','DiagnosisDetail','qc_gastro_dxd_cap_lungs','ptmn_y','checkbox',  NULL ,'0','','','','y (post-treatment)','');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_lungs'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster'AND `tablename`='diagnosis_masters'AND `field`='dx_date'AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'),'1','1','','1','report date','0','','1','','0','','0','','0','','1','0','1','0','1','0','0','0','0','0','0','0','1','1','1'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_lungs'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail'AND `tablename`='qc_gastro_dxd_cap_lungs'AND `field`='specimen_laterality'AND `type`='select'AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='laterality')  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`=''AND `language_label`='specimen laterality'AND `language_tag`=''),'1','4','','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','1','1','1'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_lungs'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail'AND `tablename`='qc_gastro_dxd_cap_lungs'AND `field`='specimen'AND `type`='select'AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_lung_specimen')  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`=''AND `language_label`='specimen'AND `language_tag`=''),'1','2','','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','1','1','1'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_lungs'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail'AND `tablename`='qc_gastro_dxd_cap_lungs'AND `field`='m_procedure'AND `type`='select'AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_lung_procedure')  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`=''AND `language_label`='procedure'AND `language_tag`=''),'1','3','','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','1','1','1'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_lungs'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail'AND `tablename`='qc_gastro_dxd_cap_lungs'AND `field`='tumor_site'AND `type`='select'AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_lung_tumor_site')  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`=''AND `language_label`='tumor site'AND `language_tag`=''),'1','5','','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','1','1','1'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_lungs'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail'AND `tablename`='qc_gastro_dxd_cap_lungs'AND `field`='tumor_size_cannot_determine'AND `type`='checkbox'AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`=''AND `language_label`='cannot be determined'AND `language_tag`=''),'1','6','tumor size','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','1','1','1'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_lungs'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail'AND `tablename`='qc_gastro_dxd_cap_lungs'AND `field`='tumor_size_greatest_cm'AND `type`='float_positive'AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`=''AND `language_label`='greatest dimension (cm)'AND `language_tag`=''),'1','7','','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','1','1','1'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_lungs'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail'AND `tablename`='qc_gastro_dxd_cap_lungs'AND `field`='tumor_size_add1_cm'AND `type`='float_positive'AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`=''AND `language_label`='additional dimensions (cm)'AND `language_tag`=''),'1','8','','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','1','1','1'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_lungs'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail'AND `tablename`='qc_gastro_dxd_cap_lungs'AND `field`='tumor_size_add2_cm'AND `type`='float_positive'AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`=''AND `language_label`=''AND `language_tag`='x'),'1','9','','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','1','1','1'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_lungs'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail'AND `tablename`='qc_gastro_dxd_cap_lungs'AND `field`='histologic_type'AND `type`='select'AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_lung_histologic_type')  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`=''AND `language_label`='histologic type'AND `language_tag`=''),'2','1','histology','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','1','1','1'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_lungs'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail'AND `tablename`='qc_gastro_dxd_cap_lungs'AND `field`='histologic_type_precision'AND `type`='input'AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`=''AND `language_label`='precision (if any)'AND `language_tag`=''),'2','2','','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','1','1','1'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_lungs'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail'AND `tablename`='qc_gastro_dxd_cap_lungs'AND `field`='histologic_grade'AND `type`='select'AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_lung_histologic_grade')  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`=''AND `language_label`='histologic grade'AND `language_tag`=''),'2','3','','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','1','1','1'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_lungs'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail'AND `tablename`='qc_gastro_dxd_cap_lungs'AND `field`='lymph_vascular_invasion'AND `type`='select'AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_not_id_pres_indet')  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`=''AND `language_label`='lymph vascular invasion'AND `language_tag`=''),'2','4','lymph','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','1','1','1'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_lungs'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail'AND `tablename`='qc_gastro_dxd_cap_lungs'AND `field`='ptmn_m'AND `type`='checkbox'AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`=''AND `language_label`='m (multiple primary tumors)'AND `language_tag`=''),'2','5','pTNM','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','1','1','1'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_lungs'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail'AND `tablename`='qc_gastro_dxd_cap_lungs'AND `field`='ptmn_r'AND `type`='checkbox'AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`=''AND `language_label`='r (recurrent)'AND `language_tag`=''),'2','6','','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','1','1','1'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_lungs'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail'AND `tablename`='qc_gastro_dxd_cap_lungs'AND `field`='ptmn_y'AND `type`='checkbox'AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'AND `setting`=''AND `default`=''AND `language_help`=''AND `language_label`='y (post-treatment)'AND `language_tag`=''),'2','7','','0','','0','','0','','0','','0','','0','','1','0','1','0','0','0','0','0','0','0','0','0','1','1','1');

INSERT INTO diagnosis_controls (controls_type, flag_active, form_alias, detail_tablename, display_order, databrowser_label) VALUES
('cap report - lung: resection', 1,'qc_gastro_dxd_cap_lungs','qc_gastro_dxd_cap_lungs', 0,'cap report - lung: resection'); 

REPLACE INTO i18n (id, en, fr) VALUES
('specimen laterality','Specimen laterality', "Latéralité de l'échantillon"),
("cannot be determined", "Cannot be determined", "Ne peut pas être déterminée"), 
("greatest dimension (cm)", "Greatest dimension (cm)", "Plus grande dimension (cm)"),
("additional dimensions (cm)", "Additional dimensions (cm)", "Dimension additionnelle (cm)"),
("precision (if any)", "Precision (if any)", "Précision (s'il y en a)");


INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES
('Carcinoma, type cannot be determined','Carcinoma, type cannot be determined'),
('Non-small cell carcinoma, subtype cannot be determined','Non-small cell carcinoma, subtype cannot be determined'),
('Small cell carcinoma','Small cell carcinoma'),
('Combined small cell carcinoma (small cell carcinoma and non-small cell component) (specify type of non-small cell carcinoma component bellow)','Combined small cell carcinoma (small cell carcinoma and non-small cell component) (specify type of non-small cell carcinoma component bellow)'),
('Squamous cell carcinoma','Squamous cell carcinoma'),
('Squamous cell carcinoma, papillary variant','Squamous cell carcinoma, papillary variant'),
('Squamous cell carcinoma, clear cell variant','Squamous cell carcinoma, clear cell variant'),
('Squamous cell carcinoma, small cell variant','Squamous cell carcinoma, small cell variant'),
('Squamous cell carcinoma, basaloid variant','Squamous cell carcinoma, basaloid variant'),
('Adenocarcinoma','Adenocarcinoma'),
('Adenocarcinoma, mixed subtype','Adenocarcinoma, mixed subtype'),
('Acinar adenocarcinoma','Acinar adenocarcinoma'),
('Papillary adenocarcinoma','Papillary adenocarcinoma'),
('Bronchioloalveolar carcinoma','Bronchioloalveolar carcinoma'),
('Bronchioloalveolar carcinoma, nonmucinous','Bronchioloalveolar carcinoma, nonmucinous'),
('Bronchioloalveolar carcinoma, mucinous','Bronchioloalveolar carcinoma, mucinous'),
('Bronchioloalveolar carcinoma, mixed nonmucinous and mucinous','Bronchioloalveolar carcinoma, mixed nonmucinous and mucinous'),
('Solid adenocarcinoma','Solid adenocarcinoma'),
('Fetal adenocarcinoma','Fetal adenocarcinoma'),
('Mucinous (colloid) adenocarcinoma','Mucinous (colloid) adenocarcinoma'),
('Mucinous cystadenocarcinoma','Mucinous cystadenocarcinoma'),
('Signet ring adenocarcinoma','Signet ring adenocarcinoma'),
('Clear cell adenocarcinoma','Clear cell adenocarcinoma'),
('Large cell carcinoma','Large cell carcinoma'),
('Large cell neuroendocrine carcinoma','Large cell neuroendocrine carcinoma'),
('Combined large cell neuroendocrine carcinoma (specify type of other non-small cell carcinoma component bellow)','Combined large cell neuroendocrine carcinoma (specify type of other non-small cell carcinoma component bellow)'),
('Basaloid carcinoma','Basaloid carcinoma'),
('Lymphoepithelioma-like carcinoma','Lymphoepithelioma-like carcinoma'),
('Clear cell carcinoma','Clear cell carcinoma'),
('Large cell carcinoma with rhabdoid phenotype','Large cell carcinoma with rhabdoid phenotype'),
('Adenosquamous carcinoma','Adenosquamous carcinoma'),
('Sarcomatoid carcinoma','Sarcomatoid carcinoma'),
('Pleomorphic carcinoma','Pleomorphic carcinoma'),
('Spindle cell carcinoma','Spindle cell carcinoma'),
('Giant cell carcinoma','Giant cell carcinoma'),
('Carcinosarcoma','Carcinosarcoma'),
('Pulmonary blastoma','Pulmonary blastoma'),
('Typical carcinoid tumor','Typical carcinoid tumor'),
('Atypical carcinoid tumor','Atypical carcinoid tumor'),
('Mucoepidermoid carcinoma','Mucoepidermoid carcinoma'),
('Adenoid cystic carcinoma','Adenoid cystic carcinoma'),
('Epithelial-myoepithelial carcinoma','Epithelial-myoepithelial carcinoma'),
('Other (specify bellow)','Other (specify bellow)');

INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES
((SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_lung_histologic_type'), (SELECT id FROM structure_permissible_values WHERE value='Carcinoma, type cannot be determined'),	1	, 1),
((SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_lung_histologic_type'), (SELECT id FROM structure_permissible_values WHERE value='Non-small cell carcinoma, subtype cannot be determined'),	2	, 1),
((SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_lung_histologic_type'), (SELECT id FROM structure_permissible_values WHERE value='Small cell carcinoma'),	3	, 1),
((SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_lung_histologic_type'), (SELECT id FROM structure_permissible_values WHERE value='Combined small cell carcinoma (small cell carcinoma and non-small cell component) (specify type of non-small cell carcinoma component bellow)'),	4	, 1),
((SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_lung_histologic_type'), (SELECT id FROM structure_permissible_values WHERE value='Squamous cell carcinoma'),	5	, 1),
((SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_lung_histologic_type'), (SELECT id FROM structure_permissible_values WHERE value='Squamous cell carcinoma, papillary variant'),	6	, 1),
((SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_lung_histologic_type'), (SELECT id FROM structure_permissible_values WHERE value='Squamous cell carcinoma, clear cell variant'),	7	, 1),
((SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_lung_histologic_type'), (SELECT id FROM structure_permissible_values WHERE value='Squamous cell carcinoma, small cell variant'),	8	, 1),
((SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_lung_histologic_type'), (SELECT id FROM structure_permissible_values WHERE value='Squamous cell carcinoma, basaloid variant'),	9	, 1),
((SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_lung_histologic_type'), (SELECT id FROM structure_permissible_values WHERE value='Adenocarcinoma'),	10	, 1),
((SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_lung_histologic_type'), (SELECT id FROM structure_permissible_values WHERE value='Adenocarcinoma, mixed subtype'),	11	, 1),
((SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_lung_histologic_type'), (SELECT id FROM structure_permissible_values WHERE value='Acinar adenocarcinoma'),	12	, 1),
((SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_lung_histologic_type'), (SELECT id FROM structure_permissible_values WHERE value='Papillary adenocarcinoma'),	13	, 1),
((SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_lung_histologic_type'), (SELECT id FROM structure_permissible_values WHERE value='Bronchioloalveolar carcinoma'),	14	, 1),
((SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_lung_histologic_type'), (SELECT id FROM structure_permissible_values WHERE value='Bronchioloalveolar carcinoma, nonmucinous'),	15	, 1),
((SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_lung_histologic_type'), (SELECT id FROM structure_permissible_values WHERE value='Bronchioloalveolar carcinoma, mucinous'),	16	, 1),
((SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_lung_histologic_type'), (SELECT id FROM structure_permissible_values WHERE value='Bronchioloalveolar carcinoma, mixed nonmucinous and mucinous'),	17	, 1),
((SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_lung_histologic_type'), (SELECT id FROM structure_permissible_values WHERE value='Solid adenocarcinoma'),	18	, 1),
((SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_lung_histologic_type'), (SELECT id FROM structure_permissible_values WHERE value='Fetal adenocarcinoma'),	19	, 1),
((SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_lung_histologic_type'), (SELECT id FROM structure_permissible_values WHERE value='Mucinous (colloid) adenocarcinoma'),	20	, 1),
((SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_lung_histologic_type'), (SELECT id FROM structure_permissible_values WHERE value='Mucinous cystadenocarcinoma'),	21	, 1),
((SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_lung_histologic_type'), (SELECT id FROM structure_permissible_values WHERE value='Signet ring adenocarcinoma'),	22	, 1),
((SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_lung_histologic_type'), (SELECT id FROM structure_permissible_values WHERE value='Clear cell adenocarcinoma'),	23	, 1),
((SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_lung_histologic_type'), (SELECT id FROM structure_permissible_values WHERE value='Large cell carcinoma'),	24	, 1),
((SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_lung_histologic_type'), (SELECT id FROM structure_permissible_values WHERE value='Large cell neuroendocrine carcinoma'),	25	, 1),
((SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_lung_histologic_type'), (SELECT id FROM structure_permissible_values WHERE value='Combined large cell neuroendocrine carcinoma (specify type of other non-small cell carcinoma component bellow)'),	26	, 1),
((SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_lung_histologic_type'), (SELECT id FROM structure_permissible_values WHERE value='Basaloid carcinoma'),	27	, 1),
((SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_lung_histologic_type'), (SELECT id FROM structure_permissible_values WHERE value='Lymphoepithelioma-like carcinoma'),	28	, 1),
((SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_lung_histologic_type'), (SELECT id FROM structure_permissible_values WHERE value='Clear cell carcinoma'),	29	, 1),
((SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_lung_histologic_type'), (SELECT id FROM structure_permissible_values WHERE value='Large cell carcinoma with rhabdoid phenotype'),	30	, 1),
((SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_lung_histologic_type'), (SELECT id FROM structure_permissible_values WHERE value='Adenosquamous carcinoma'),	31	, 1),
((SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_lung_histologic_type'), (SELECT id FROM structure_permissible_values WHERE value='Sarcomatoid carcinoma'),	32	, 1),
((SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_lung_histologic_type'), (SELECT id FROM structure_permissible_values WHERE value='Pleomorphic carcinoma'),	33	, 1),
((SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_lung_histologic_type'), (SELECT id FROM structure_permissible_values WHERE value='Spindle cell carcinoma'),	34	, 1),
((SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_lung_histologic_type'), (SELECT id FROM structure_permissible_values WHERE value='Giant cell carcinoma'),	35	, 1),
((SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_lung_histologic_type'), (SELECT id FROM structure_permissible_values WHERE value='Carcinosarcoma'),	36	, 1),
((SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_lung_histologic_type'), (SELECT id FROM structure_permissible_values WHERE value='Pulmonary blastoma'),	37	, 1),
((SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_lung_histologic_type'), (SELECT id FROM structure_permissible_values WHERE value='Typical carcinoid tumor'),	38	, 1),
((SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_lung_histologic_type'), (SELECT id FROM structure_permissible_values WHERE value='Atypical carcinoid tumor'),	39	, 1),
((SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_lung_histologic_type'), (SELECT id FROM structure_permissible_values WHERE value='Mucoepidermoid carcinoma'),	40	, 1),
((SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_lung_histologic_type'), (SELECT id FROM structure_permissible_values WHERE value='Adenoid cystic carcinoma'),	41	, 1),
((SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_lung_histologic_type'), (SELECT id FROM structure_permissible_values WHERE value='Epithelial-myoepithelial carcinoma'),	42	, 1),
((SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_lung_histologic_type'), (SELECT id FROM structure_permissible_values WHERE value='Other (specify bellow)'),	43	, 1);

INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES
('Not identified', 'Not identified'), 
('Present', 'Present'),
('Indeterminate', 'Indeterminate');

INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES
((SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_not_id_pres_indet'), (SELECT id FROM structure_permissible_values WHERE value='Not identified'),	1	, 0),
((SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_not_id_pres_indet'), (SELECT id FROM structure_permissible_values WHERE value='Present'),	1	, 0),
((SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_not_id_pres_indet'), (SELECT id FROM structure_permissible_values WHERE value='Indeterminate'),	1	, 0);

INSERT INTO structure_permissible_values_customs (control_id, value, en, fr) VALUES
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap lung specimen'), 'lung', 'lung', 'poumon'),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap lung specimen'), 'not specified', 'not specified', 'non spécifié'),

((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap lung procedure'), 'Major airway resection', '', ''),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap lung procedure'), 'Wedge resection', '', ''),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap lung procedure'), 'Segmentectomy', '', ''),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap lung procedure'), 'Lobectomy', '', ''),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap lung procedure'), 'Bilobectomy', '', ''),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap lung procedure'), 'Pneumonectomy', '', ''),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap lung procedure'), 'not specified', 'not specified', 'non spécifié'),

((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap lung tumor site'), 'Upper lobe', '', ''),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap lung tumor site'), 'Middle lobe', '', ''),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap lung tumor site'), 'Lower lobe', '', ''),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap lung tumor site'), 'not specified', 'not specified', 'non spécifié'),

((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap lung histologic grade'), 'GX: Cannot be assessed', '', ''),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap lung histologic grade'), 'G1: Well differentiated', '', ''),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap lung histologic grade'), 'G2: Moderately differentiated', '', ''),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap lung histologic grade'), 'G3: Poorly differentiated', '', ''),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap lung histologic grade'), 'G4: Undifferentiated', '', ''),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap lung histologic grade'), 'not applicable', 'not applicable', 'non applicable');

CREATE TABLE qc_gastro_dxd_cap_melanomas(
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 diagnosis_master_id INT NOT NULL,
 specimen VARCHAR(50) NOT NULL DEFAULT '',
 procedure_bio_shave VARCHAR(6) NOT NULL DEFAULT '',
 procedure_bio_punch VARCHAR(6) NOT NULL DEFAULT '',
 procedure_bio_incisional VARCHAR(6) NOT NULL DEFAULT '',
 procedure_excision VARCHAR(6) NOT NULL DEFAULT '',
 procedure_reexcision VARCHAR(6) NOT NULL DEFAULT '',
 procedure_lymph_sentinel VARCHAR(6) NOT NULL DEFAULT '',
 procedure_lymph_regional VARCHAR(6) NOT NULL DEFAULT '',
 procedure_other VARCHAR(6) NOT NULL DEFAULT '',
 procedure_not_specified VARCHAR(6) NOT NULL DEFAULT '',
 procedure_precision VARCHAR(50) NOT NULL DEFAULT '',
 laterality VARCHAR(50) NOT NULL DEFAULT '',
 tumor_site VARCHAR(50) NOT NULL DEFAULT '',
 tumor_size_cannot_determine VARCHAR(6) NOT NULL DEFAULT'', 
 tumor_size_greatest_cm FLOAT UNSIGNED DEFAULT NULL,
 tumor_size_add1_cm FLOAT UNSIGNED DEFAULT NULL,
 tumor_size_add2_cm FLOAT UNSIGNED DEFAULT NULL,
 histologic_type VARCHAR(50) NOT NULL DEFAULT'',
 lymph_vascular_invasion VARCHAR(50) NOT NULL DEFAULT'',
 perineural_invasion VARCHAR(50) NOT NULL DEFAULT'',
 ptmn_m VARCHAR(6) NOT NULL DEFAULT'', 
 ptmn_r VARCHAR(6) NOT NULL DEFAULT'', 
 ptmn_y VARCHAR(6) NOT NULL DEFAULT'',
 created DATETIME NOT NULL,
 created_by INT UNSIGNED NOT NULL,
 modified DATETIME NOT NULL,
 modified_by INT UNSIGNED NOT NULL,
 deleted BOOLEAN NOT NULL DEFAULT 0,
 deleted_date DATETIME DEFAULT NULL,
 FOREIGN KEY (`diagnosis_master_id`) REFERENCES diagnosis_masters(id)
)Engine=InnoDb;
CREATE TABLE qc_gastro_dxd_cap_melanomas_revs(
 id INT UNSIGNED NOT NULL,
 diagnosis_master_id INT NOT NULL,
 specimen VARCHAR(50) NOT NULL DEFAULT '',
 procedure_bio_shave VARCHAR(6) NOT NULL DEFAULT '',
 procedure_bio_punch VARCHAR(6) NOT NULL DEFAULT '',
 procedure_bio_incisional VARCHAR(6) NOT NULL DEFAULT '',
 procedure_excision VARCHAR(6) NOT NULL DEFAULT '',
 procedure_reexcision VARCHAR(6) NOT NULL DEFAULT '',
 procedure_lymph_sentinel VARCHAR(6) NOT NULL DEFAULT '',
 procedure_lymph_regional VARCHAR(6) NOT NULL DEFAULT '',
 procedure_other VARCHAR(6) NOT NULL DEFAULT '',
 procedure_not_specified VARCHAR(6) NOT NULL DEFAULT '',
 procedure_precision VARCHAR(50) NOT NULL DEFAULT '',
 laterality VARCHAR(50) NOT NULL DEFAULT '',
 tumor_site VARCHAR(50) NOT NULL DEFAULT '',
 tumor_size_cannot_determine VARCHAR(6) NOT NULL DEFAULT'', 
 tumor_size_greatest_cm FLOAT UNSIGNED DEFAULT NULL,
 tumor_size_add1_cm FLOAT UNSIGNED DEFAULT NULL,
 tumor_size_add2_cm FLOAT UNSIGNED DEFAULT NULL,
 histologic_type VARCHAR(50) NOT NULL DEFAULT'',
 lymph_vascular_invasion VARCHAR(50) NOT NULL DEFAULT'',
 perineural_invasion VARCHAR(50) NOT NULL DEFAULT'',
 ptmn_m VARCHAR(6) NOT NULL DEFAULT'', 
 ptmn_r VARCHAR(6) NOT NULL DEFAULT'', 
 ptmn_y VARCHAR(6) NOT NULL DEFAULT'',
 created DATETIME NOT NULL,
 created_by INT UNSIGNED NOT NULL,
 modified DATETIME NOT NULL,
 modified_by INT UNSIGNED NOT NULL,
 deleted BOOLEAN NOT NULL DEFAULT 0,
 deleted_date DATETIME DEFAULT NULL,
 version_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 version_created DATETIME NOT NULL
)Engine=InnoDb;

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_gastro_cap_melanoma_specimen','','', "StructurePermissibleValuesCustom::getCustomDropdown('cap melanoma specimen')");
INSERT INTO structure_permissible_values_custom_controls(name, flag_active, values_max_length) VALUES ('cap melanoma specimen', 1, 50);

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_gastro_cap_melanoma_laterality','','', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("left", "left");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_gastro_cap_melanoma_laterality"),  (SELECT id FROM structure_permissible_values WHERE value="left" AND language_alias="left"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("right", "right");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_gastro_cap_melanoma_laterality"),  (SELECT id FROM structure_permissible_values WHERE value="right" AND language_alias="right"), "2", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("midline", "midline");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_gastro_cap_melanoma_laterality"),  (SELECT id FROM structure_permissible_values WHERE value="midline" AND language_alias="midline"), "3", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("not specified", "not specified");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_gastro_cap_melanoma_laterality"),  (SELECT id FROM structure_permissible_values WHERE value="not specified" AND language_alias="not specified"), "4", "1");

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_gastro_cap_melanoma_tumor_site','','', "StructurePermissibleValuesCustom::getCustomDropdown('cap melanoma tumor site')");
INSERT INTO structure_permissible_values_custom_controls(name, flag_active, values_max_length) VALUES ('cap melanoma tumor site', 1, 50);
INSERT INTO structure_permissible_values_customs (control_id, value, en, fr) VALUES
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma tumor site'), 'not specified', 'not specified', 'non spécifié');

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_gastro_cap_melanoma_histologic_type','','', "StructurePermissibleValuesCustom::getCustomDropdown('cap melanoma histologic type')");
INSERT INTO structure_permissible_values_custom_controls(name, flag_active, values_max_length) VALUES ('cap melanoma histologic type', 1, 50);
INSERT INTO structure_permissible_values_customs (control_id, value, en, fr) VALUES
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma histologic type'), 'Melanoma, not otherwise classified', '', ''),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma histologic type'), 'Superficial spreading melanoma', '', ''),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma histologic type'), 'Nodular melanoma', '', ''),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma histologic type'), 'Lentigo maligna melanoma', '', ''),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma histologic type'), 'Acral-lentiginous melanoma', '', ''),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma histologic type'), 'Desmoplastic and/or desmoplastic neurotropic melanoma', '', ''),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma histologic type'), 'Melanoma arising from blue nevus', '', ''),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma histologic type'), 'Melanoma arising in a giant congenital nevus', '', ''),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma histologic type'), 'Melanoma of childhood', '', ''),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma histologic type'), 'Nevoid melanoma', '', ''),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma histologic type'), 'Persistent melanoma', '', '');

INSERT INTO structures(`alias`) VALUES ('qc_gastro_dxd_cap_melanomas');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_melanomas', 'specimen', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_melanoma_specimen') , '0', '', '', '', 'specimen', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_melanomas', 'procedure_precision', 'input',  NULL , '0', '', '', '', 'procedure precision (if any)', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_melanomas', 'laterality', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_melanoma_laterality') , '0', '', '', '', 'specimen laterality', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_melanomas', 'tumor_site', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_melanoma_tumor_site') , '0', '', '', '', 'tumor site', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_melanomas', 'tumor_size_cannot_determine', 'checkbox',  NULL , '0', '', '', '', 'cannot determine', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_melanomas', 'tumor_size_greatest_cm', 'float_positive',  NULL , '0', '', '', '', 'greatest dimension (cm)', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_melanomas', 'tumor_size_add1_cm', 'float_positive',  NULL , '0', '', '', '', 'add dimmensions (cm)', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_melanomas', 'tumor_size_add2_cm', 'float_positive',  NULL , '0', '', '', '', '', 'x'), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_melanomas', 'histologic_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_melanoma_histologic_type') , '0', '', '', '', 'histologic type', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_melanomas', 'lymph_vascular_invasion', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_not_id_pres_indet') , '0', '', '', '', 'lymph vascular invasion', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_melanomas', 'perineural_invasion', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_not_id_pres_indet') , '0', '', '', '', 'perineural invasion', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_melanomas', 'ptmn_m', 'checkbox',  NULL , '0', '', '', '', 'm (multiple)', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_melanomas', 'ptmn_r', 'checkbox',  NULL , '0', '', '', '', 'r (recurrent)', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_melanomas', 'ptmn_y', 'checkbox',  NULL , '0', '', '', '', 'y (posttreatment)', ''),
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_melanomas', 'procedure_bio_punch', 'checkbox',  NULL , '0', '', '', '', 'biopsy, punch', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_melanomas', 'procedure_bio_incisional', 'checkbox',  NULL , '0', '', '', '', 'biopsy, incisional', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_melanomas', 'procedure_excision', 'checkbox',  NULL , '0', '', '', '', 'excision', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_melanomas', 'procedure_reexcision', 'checkbox',  NULL , '0', '', '', '', 're-excision', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_melanomas', 'procedure_lymph_sentinel', 'checkbox',  NULL , '0', '', '', '', 'lymphadenectomy, sentinel node(s)', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_melanomas', 'procedure_lymph_regional', 'checkbox',  NULL , '0', '', '', '', 'lymphadenectomy, regional nodes (specify)', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_melanomas', 'procedure_other', 'checkbox',  NULL , '0', '', '', '', 'other (specify)', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_melanomas', 'procedure_not_specified', 'checkbox',  NULL , '0', '', '', '', 'not specified', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_melanomas', 'procedure_bio_shave', 'checkbox',  NULL , '0', '', '', '', 'biopsy, shave', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_melanomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '1', '', '1', 'report date', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_melanomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_melanomas' AND `field`='specimen' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_melanoma_specimen')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='specimen' AND `language_tag`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_melanomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_melanomas' AND `field`='procedure_precision' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='procedure precision (if any)' AND `language_tag`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_melanomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_melanomas' AND `field`='laterality' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_melanoma_laterality')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='specimen laterality' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_melanomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_melanomas' AND `field`='tumor_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_melanoma_tumor_site')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tumor site' AND `language_tag`=''), '1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_melanomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_melanomas' AND `field`='tumor_size_cannot_determine' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='cannot determine' AND `language_tag`=''), '1', '7', 'tumor size', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_melanomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_melanomas' AND `field`='tumor_size_greatest_cm' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='greatest dimension (cm)' AND `language_tag`=''), '1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_melanomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_melanomas' AND `field`='tumor_size_add1_cm' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='add dimmensions (cm)' AND `language_tag`=''), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_melanomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_melanomas' AND `field`='tumor_size_add2_cm' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='x'), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_melanomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_melanomas' AND `field`='histologic_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_melanoma_histologic_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='histologic type' AND `language_tag`=''), '2', '11', 'histology', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_melanomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_melanomas' AND `field`='lymph_vascular_invasion' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_not_id_pres_indet')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='lymph vascular invasion' AND `language_tag`=''), '2', '12', 'lymph', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_melanomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_melanomas' AND `field`='perineural_invasion' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_not_id_pres_indet')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='perineural invasion' AND `language_tag`=''), '2', '13', 'perineural', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_melanomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_melanomas' AND `field`='ptmn_m' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='m (multiple)' AND `language_tag`=''), '2', '14', 'pTNM', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_melanomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_melanomas' AND `field`='ptmn_r' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='r (recurrent)' AND `language_tag`=''), '2', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_melanomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_melanomas' AND `field`='ptmn_y' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='y (posttreatment)' AND `language_tag`=''), '2', '16', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT INTO diagnosis_controls (controls_type, flag_active, form_alias, detail_tablename, display_order, databrowser_label) VALUES
('cap report - melanoma of the skin', 1,'qc_gastro_dxd_cap_melanomas','qc_gastro_dxd_cap_melanomas', 0,'cap report - melanoma of the skin'); 

UPDATE structure_formats SET display_order=display_order+15 WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_melanomas') AND display_order >= 4;

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_melanomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_melanomas' AND `field`='procedure_bio_punch' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='biopsy, punch' AND `language_tag`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_melanomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_melanomas' AND `field`='procedure_bio_incisional' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='biopsy, incisional' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_melanomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_melanomas' AND `field`='procedure_excision' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='excision' AND `language_tag`=''), '1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_melanomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_melanomas' AND `field`='procedure_reexcision' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='re-excision' AND `language_tag`=''), '1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_melanomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_melanomas' AND `field`='procedure_lymph_sentinel' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='lymphadenectomy, sentinel node(s)' AND `language_tag`=''), '1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_melanomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_melanomas' AND `field`='procedure_lymph_regional' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='lymphadenectomy, regional nodes (specify)' AND `language_tag`=''), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_melanomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_melanomas' AND `field`='procedure_other' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='other (specify)' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_melanomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_melanomas' AND `field`='procedure_not_specified' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='not specified' AND `language_tag`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_melanomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_melanomas' AND `field`='procedure_bio_shave' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='biopsy, shave' AND `language_tag`=''), '1', '3', 'procedure', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');






CREATE TABLE qc_gastro_dxd_cap_kidneys(
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 diagnosis_master_id INT NOT NULL,
 specimen VARCHAR(50) NOT NULL DEFAULT '',
 m_procedure VARCHAR(50) NOT NULL DEFAULT '',
 laterality VARCHAR(50) NOT NULL DEFAULT '',
 tumor_site_upper_pole VARCHAR(6) NOT NULL DEFAULT '',
 tumor_site_middle VARCHAR(6) NOT NULL DEFAULT '',
 tumor_site_lower_pole VARCHAR(6) NOT NULL DEFAULT '',
 tumor_site_other VARCHAR(6) NOT NULL DEFAULT '',
 tumor_site_not_specified VARCHAR(6) NOT NULL DEFAULT '',
 tumor_site_precision VARCHAR(50) NOT NULL DEFAULT '',
 tumor_size_cannot_determine VARCHAR(6) NOT NULL DEFAULT'', 
 tumor_size_greatest_cm FLOAT UNSIGNED DEFAULT NULL,
 tumor_size_add1_cm FLOAT UNSIGNED DEFAULT NULL,
 tumor_size_add2_cm FLOAT UNSIGNED DEFAULT NULL,
 histologic_type VARCHAR(50) NOT NULL DEFAULT'',
 histologic_grade VARCHAR(50) NOT NULL DEFAULT'',
 lymph_vascular_invasion VARCHAR(50) NOT NULL DEFAULT'',
 ptmn_m VARCHAR(6) NOT NULL DEFAULT'', 
 ptmn_r VARCHAR(6) NOT NULL DEFAULT'', 
 ptmn_y VARCHAR(6) NOT NULL DEFAULT'',
 created DATETIME NOT NULL,
 created_by INT UNSIGNED NOT NULL,
 modified DATETIME NOT NULL,
 modified_by INT UNSIGNED NOT NULL,
 deleted BOOLEAN NOT NULL DEFAULT 0,
 deleted_date DATETIME DEFAULT NULL,
 FOREIGN KEY (`diagnosis_master_id`) REFERENCES diagnosis_masters(id)
)Engine=InnoDb;
CREATE TABLE qc_gastro_dxd_cap_kidneys_revs(
 id INT UNSIGNED NOT NULL,
 diagnosis_master_id INT NOT NULL,
 specimen VARCHAR(50) NOT NULL DEFAULT '',
 m_procedure VARCHAR(50) NOT NULL DEFAULT '',
 laterality VARCHAR(50) NOT NULL DEFAULT '',
 tumor_site_upper_pole VARCHAR(6) NOT NULL DEFAULT '',
 tumor_site_middle VARCHAR(6) NOT NULL DEFAULT '',
 tumor_site_lower_pole VARCHAR(6) NOT NULL DEFAULT '',
 tumor_site_other VARCHAR(6) NOT NULL DEFAULT '',
 tumor_site_not_specified VARCHAR(6) NOT NULL DEFAULT '',
 tumor_site_precision VARCHAR(50) NOT NULL DEFAULT '',
 tumor_size_cannot_determine VARCHAR(6) NOT NULL DEFAULT'', 
 tumor_size_greatest_cm FLOAT UNSIGNED DEFAULT NULL,
 tumor_size_add1_cm FLOAT UNSIGNED DEFAULT NULL,
 tumor_size_add2_cm FLOAT UNSIGNED DEFAULT NULL,
 histologic_type VARCHAR(50) NOT NULL DEFAULT'',
 histologic_grade VARCHAR(50) NOT NULL DEFAULT'',
 lymph_vascular_invasion VARCHAR(50) NOT NULL DEFAULT'',
 ptmn_m VARCHAR(6) NOT NULL DEFAULT'', 
 ptmn_r VARCHAR(6) NOT NULL DEFAULT'', 
 ptmn_y VARCHAR(6) NOT NULL DEFAULT'',
 created DATETIME NOT NULL,
 created_by INT UNSIGNED NOT NULL,
 modified DATETIME NOT NULL,
 modified_by INT UNSIGNED NOT NULL,
 deleted BOOLEAN NOT NULL DEFAULT 0,
 deleted_date DATETIME DEFAULT NULL,
 version_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 version_created DATETIME NOT NULL
)Engine=InnoDb;

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_gastro_cap_kidney_specimen','','', "StructurePermissibleValuesCustom::getCustomDropdown('cap kidney specimen')");
INSERT INTO structure_permissible_values_custom_controls(name, flag_active, values_max_length) VALUES ('cap kidney specimen', 1, 50);

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_gastro_cap_kidney_procedure','','', "StructurePermissibleValuesCustom::getCustomDropdown('cap kidney procedure')");
INSERT INTO structure_permissible_values_custom_controls(name, flag_active, values_max_length) VALUES ('cap kidney procedure', 1, 50);
INSERT INTO structure_permissible_values_customs (control_id, value, en, fr) VALUES
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap kidney procedure'), 'Partial nephrectomy', '', ''),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap kidney procedure'), 'Radical nephrectomy', '', ''),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap kidney procedure'), 'Not specified', '', '');

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_gastro_cap_kidney_histologic_type','','', "StructurePermissibleValuesCustom::getCustomDropdown('cap kidney histologic type')");
INSERT INTO structure_permissible_values_custom_controls(name, flag_active, values_max_length) VALUES ('cap kidney histologic type', 1, 50);
INSERT INTO structure_permissible_values_customs (control_id, value, en, fr) VALUES
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap kidney histologic type'), 'Clear cell renal cell carcinoma', '', ''),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap kidney histologic type'), 'Multilocular clear cell renal cell carcinoma', '', ''),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap kidney histologic type'), 'Papillary renal cell carcinoma', '', ''),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap kidney histologic type'), 'Chromophobe renal cell carcinoma', '', ''),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap kidney histologic type'), 'Carcinoma of the collecting ducts of Bellini', '', ''),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap kidney histologic type'), 'Renal medullary carcinoma', '', ''),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap kidney histologic type'), 'Translocation carcinoma (Xp11 or others)', '', ''),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap kidney histologic type'), 'Carcinoma associated with neuroblastoma', '', ''),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap kidney histologic type'), 'Mucinous tubular and spindle cell carcinoma', '', ''),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap kidney histologic type'), 'Tubulocystic renal cell carcinoma', '', ''),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap kidney histologic type'), 'Renal cell carcinoma, unclassified', '', '');

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_gastro_cap_kidney_histologic_grade','','', "StructurePermissibleValuesCustom::getCustomDropdown('cap kidney histologic grade')");
INSERT INTO structure_permissible_values_custom_controls(name, flag_active, values_max_length) VALUES ('cap kidney histologic grade', 1, 50);
INSERT INTO structure_permissible_values_customs (control_id, value, en, fr) VALUES
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap kidney histologic grade'), 'Not applicable', '', ''),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap kidney histologic grade'), 'GX: Cannot be assessed', '', ''),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap kidney histologic grade'), 'G1: Nuclei round, uniform', 'G1: Nuclei round, uniform, approximately 10 μm; nucleoli inconspicuous or absent', 'G1: Nuclei round, uniform, approximately 10 μm; nucleoli inconspicuous or absent'),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap kidney histologic grade'), 'G2: Nuclei slightly irregular', 'G2: Nuclei slightly irregular, approximately 15 μm; nucleoli evident', 'G2: Nuclei slightly irregular, approximately 15 μm; nucleoli evident'),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap kidney histologic grade'), 'G3: Nuclei very irregular', 'G3: Nuclei very irregular, approximately 20 μm; nucleoli large and prominent', 'G3: Nuclei very irregular, approximately 20 μm; nucleoli large and prominent'),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap kidney histologic grade'), 'G4: Nuclei bizarre and multilobated', 'G4: Nuclei bizarre and multilobated, 20 μm or greater, nucleoli prominent, chromatin clumped', 'G4: Nuclei bizarre and multilobated, 20 μm or greater, nucleoli prominent, chromatin clumped');

INSERT INTO structures(`alias`) VALUES ('qc_gastro_dxd_cap_kidneys');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_kidneys', 'specimen', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_kidney_specimen') , '0', '', '', '', 'specimen', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_kidneys', 'm_procedure', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_kidney_procedure') , '0', '', '', '', 'm procedure', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_kidneys', 'laterality', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='laterality') , '0', '', '', '', 'laterality', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_kidneys', 'tumor_site_upper_pole', 'checkbox',  NULL , '0', '', '', '', 'upper pole', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_kidneys', 'tumor_site_middle', 'checkbox',  NULL , '0', '', '', '', 'middle', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_kidneys', 'tumor_site_lower_pole', 'checkbox',  NULL , '0', '', '', '', 'lower pole', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_kidneys', 'tumor_site_other', 'checkbox',  NULL , '0', '', '', '', 'other (specify)', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_kidneys', 'tumor_site_precision', 'input',  NULL , '0', '', '', '', 'precision (if any)', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_kidneys', 'tumor_size_cannot_determine', 'checkbox',  NULL , '0', '', '', '', 'cannot determine', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_kidneys', 'tumor_size_greatest_cm', 'float_positive',  NULL , '0', '', '', '', 'greatest dimension (cm)', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_kidneys', 'tumor_size_add1_cm', 'float_positive',  NULL , '0', '', '', '', 'additional dimensions (cm)', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_kidneys', 'tumor_size_add2_cm', 'float_positive',  NULL , '0', '', '', '', '', 'x'), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_kidneys', 'histologic_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_kidney_histologic_type') , '0', '', '', '', 'histologic type', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_kidneys', 'histologic_grade', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_kidney_histologic_grade') , '0', '', '', '', 'histologic grade', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_kidneys', 'perineural_invasion', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_not_id_pres_indet') , '0', '', '', '', 'perineural invasion', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_kidneys', 'ptmn_m', 'checkbox',  NULL , '0', '', '', '', 'm (multiple primary tumors)', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_kidneys', 'ptmn_r', 'checkbox',  NULL , '0', '', '', '', 'r (recurrent)', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_kidneys', 'ptmn_y', 'checkbox',  NULL , '0', '', '', '', 'y (posttreatment)', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_kidneys'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '1', '', '1', 'report date', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_kidneys'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_kidneys' AND `field`='specimen' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_kidney_specimen')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='specimen' AND `language_tag`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_kidneys'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_kidneys' AND `field`='m_procedure' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_kidney_procedure')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='m procedure' AND `language_tag`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_kidneys'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_kidneys' AND `field`='laterality' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='laterality')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='laterality' AND `language_tag`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_kidneys'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_kidneys' AND `field`='tumor_site_upper_pole' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='upper pole' AND `language_tag`=''), '1', '5', 'tumor site', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_kidneys'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_kidneys' AND `field`='tumor_site_middle' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='middle' AND `language_tag`=''), '1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_kidneys'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_kidneys' AND `field`='tumor_site_lower_pole' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='lower pole' AND `language_tag`=''), '1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_kidneys'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_kidneys' AND `field`='tumor_site_other' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='other (specify)' AND `language_tag`=''), '1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_kidneys'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_kidneys' AND `field`='tumor_site_precision' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='precision (if any)' AND `language_tag`=''), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_kidneys'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_kidneys' AND `field`='tumor_size_cannot_determine' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='cannot determine' AND `language_tag`=''), '1', '10', 'tumor size', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_kidneys'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_kidneys' AND `field`='tumor_size_greatest_cm' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='greatest dimension (cm)' AND `language_tag`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_kidneys'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_kidneys' AND `field`='tumor_size_add1_cm' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='additional dimensions (cm)' AND `language_tag`=''), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_kidneys'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_kidneys' AND `field`='tumor_size_add2_cm' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='x'), '1', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_kidneys'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_kidneys' AND `field`='histologic_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_kidney_histologic_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='histologic type' AND `language_tag`=''), '2', '14', 'histology', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_kidneys'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_kidneys' AND `field`='histologic_grade' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_kidney_histologic_grade')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='histologic grade' AND `language_tag`=''), '2', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_kidneys'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_kidneys' AND `field`='perineural_invasion' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_not_id_pres_indet')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='perineural invasion' AND `language_tag`=''), '2', '16', 'lymph', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_kidneys'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_kidneys' AND `field`='ptmn_m' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='m (multiple primary tumors)' AND `language_tag`=''), '2', '17', 'pTNM', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_kidneys'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_kidneys' AND `field`='ptmn_r' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='r (recurrent)' AND `language_tag`=''), '2', '18', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_kidneys'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_kidneys' AND `field`='ptmn_y' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='y (posttreatment)' AND `language_tag`=''), '2', '19', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT INTO diagnosis_controls (controls_type, flag_active, form_alias, detail_tablename, display_order, databrowser_label) VALUES
('cap report - kidney: Nephrectomy, Partial, Radical', 1,'qc_gastro_dxd_cap_kidneys','qc_gastro_dxd_cap_kidneys', 0,'cap report - kidney: Nephrectomy, Partial, Radical'); 



CREATE TABLE qc_gastro_dxd_cap_testis(
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 diagnosis_master_id INT NOT NULL,
 specimen VARCHAR(50) NOT NULL DEFAULT'',
 m_procedure VARCHAR(50) NOT NULL DEFAULT'',
 specimen_laterality VARCHAR(20) NOT NULL DEFAULT'',
 tumor_site VARCHAR(50) NOT NULL DEFAULT'',
 tumor_size_cannot_determine VARCHAR(6) NOT NULL DEFAULT'', 
 tumor_size_greatest_cm FLOAT UNSIGNED DEFAULT NULL,
 tumor_size_add1_cm FLOAT UNSIGNED DEFAULT NULL,
 tumor_size_add2_cm FLOAT UNSIGNED DEFAULT NULL,
 tumor_nodule1_greatest_dimension_cm FLOAT UNSIGNED DEFAULT NULL,
 tumor_nodule2_greatest_dimension_cm FLOAT UNSIGNED DEFAULT NULL,
 tumor_nodule3_greatest_dimension_cm FLOAT UNSIGNED DEFAULT NULL,
 tumor_nodule4_greatest_dimension_cm FLOAT UNSIGNED DEFAULT NULL,
 ht_intratubular VARCHAR(6) NOT NULL DEFAULT '',
 ht_seminoma_classic VARCHAR(6) NOT NULL DEFAULT '',
 ht_seminoma_scar VARCHAR(6) NOT NULL DEFAULT '',
 ht_seminoma_sync_cell VARCHAR(6) NOT NULL DEFAULT '',
 ht_mixed_germ VARCHAR(6) NOT NULL DEFAULT '',
 ht_mixed_germ_precision text NOT NULL DEFAULT '',
 ht_embryonal VARCHAR(6) NOT NULL DEFAULT '',
 ht_yolk VARCHAR(6) NOT NULL DEFAULT '',
 ht_chorio_biphasic VARCHAR(6) NOT NULL DEFAULT '',
 ht_chorio_monophasic VARCHAR(6) NOT NULL DEFAULT '',
 ht_plcental_site VARCHAR(6) NOT NULL DEFAULT '',
 ht_teratoma VARCHAR(6) NOT NULL DEFAULT '',
 ht_teratoma_w_secondary VARCHAR(6) NOT NULL DEFAULT '',
 ht_teratoma_w_secondary_precision VARCHAR(50) NOT NULL DEFAULT '',
 ht_monodermal_teratoma_carcinoid VARCHAR(6) NOT NULL DEFAULT '',
 ht_monodermal_teratoma_primitive VARCHAR(6) NOT NULL DEFAULT '',
 ht_monodermal_teratoma_other VARCHAR(6) NOT NULL DEFAULT '',
 ht_monodermal_teratoma_other_precision VARCHAR(50) NOT NULL DEFAULT '',
 ht_spermatocytic VARCHAR(6) NOT NULL DEFAULT '',
 ht_spermatocytic_w_sarcomatous VARCHAR(6) NOT NULL DEFAULT '',
 ht_mixed_germ_gonadoblastoma VARCHAR(6) NOT NULL DEFAULT '',
 ht_mixed_germ_others VARCHAR(6) NOT NULL DEFAULT '',
 ht_mixed_germ_others_precision VARCHAR(50) NOT NULL DEFAULT '',
 ht_testicular_scar VARCHAR(6) NOT NULL DEFAULT '',
 ht_testicular_scar_only VARCHAR(6) NOT NULL DEFAULT '',
 ht_testicular_scar_w_intratubular VARCHAR(6) NOT NULL DEFAULT '',
 ht_sex_cord VARCHAR(6) NOT NULL DEFAULT '',
 ht_sex_cord_leydig VARCHAR(6) NOT NULL DEFAULT '',
 ht_sex_cord_sertoli VARCHAR(6) NOT NULL DEFAULT '',
 ht_sex_cord_sertoli_classic VARCHAR(6) NOT NULL DEFAULT '',
 ht_sex_cord_sertoli_sclerosing VARCHAR(6) NOT NULL DEFAULT '',
 ht_sex_cord_sertoli_large VARCHAR(6) NOT NULL DEFAULT '',
 ht_sex_cord_granulosa VARCHAR(6) NOT NULL DEFAULT '',
 ht_sex_cord_granulosa_adult VARCHAR(6) NOT NULL DEFAULT '',
 ht_sex_cord_granulosa_juvenile VARCHAR(6) NOT NULL DEFAULT '',
 ht_sex_cord_mixed VARCHAR(6) NOT NULL DEFAULT '',
 ht_sex_cord_mixed_precision text NOT NULL DEFAULT '',
 ht_sex_cord_unclassified VARCHAR(6) NOT NULL DEFAULT '',
 ht_malignant VARCHAR(6) NOT NULL DEFAULT '',
 ht_other VARCHAR(6) NOT NULL DEFAULT '',
 ht_other_precision VARCHAR(6) NOT NULL DEFAULT '',
 lymph_vascular_invasion VARCHAR(50) NOT NULL DEFAULT'',
 ptmn_m VARCHAR(6) NOT NULL DEFAULT'', 
 ptmn_r VARCHAR(6) NOT NULL DEFAULT'', 
 ptmn_y VARCHAR(6) NOT NULL DEFAULT'',
 created DATETIME NOT NULL,
 created_by INT UNSIGNED NOT NULL,
 modified DATETIME NOT NULL,
 modified_by INT UNSIGNED NOT NULL,
 deleted BOOLEAN NOT NULL DEFAULT 0,
 deleted_date DATETIME DEFAULT NULL,
 FOREIGN KEY (`diagnosis_master_id`) REFERENCES diagnosis_masters(id)
)Engine=InnoDb;
CREATE TABLE qc_gastro_dxd_cap_testis_revs(
 id INT UNSIGNED NOT NULL,
 diagnosis_master_id INT NOT NULL,
 specimen VARCHAR(50) NOT NULL DEFAULT'',
 m_procedure VARCHAR(50) NOT NULL DEFAULT'',
 specimen_laterality VARCHAR(20) NOT NULL DEFAULT'',
 tumor_site VARCHAR(50) NOT NULL DEFAULT'',
 tumor_size_cannot_determine VARCHAR(6) NOT NULL DEFAULT'', 
 tumor_size_greatest_cm FLOAT UNSIGNED DEFAULT NULL,
 tumor_size_add1_cm FLOAT UNSIGNED DEFAULT NULL,
 tumor_size_add2_cm FLOAT UNSIGNED DEFAULT NULL,
 tumor_nodule1_greatest_dimension_cm FLOAT UNSIGNED DEFAULT NULL,
 tumor_nodule2_greatest_dimension_cm FLOAT UNSIGNED DEFAULT NULL,
 tumor_nodule3_greatest_dimension_cm FLOAT UNSIGNED DEFAULT NULL,
 turor_nodule4_greatest_dimension_cm FLOAT UNSIGNED DEFAULT NULL,
 ht_intratubular VARCHAR(6) NOT NULL DEFAULT '',
 ht_seminoma_classic VARCHAR(6) NOT NULL DEFAULT '',
 ht_seminoma_scar VARCHAR(6) NOT NULL DEFAULT '',
 ht_seminoma_sync_cell VARCHAR(6) NOT NULL DEFAULT '',
 ht_mixed_germ VARCHAR(6) NOT NULL DEFAULT '',
 ht_mixed_germ_precision text NOT NULL DEFAULT '',
 ht_embryonal VARCHAR(6) NOT NULL DEFAULT '',
 ht_yolk VARCHAR(6) NOT NULL DEFAULT '',
 ht_chorio_biphasic VARCHAR(6) NOT NULL DEFAULT '',
 ht_chorio_monophasic VARCHAR(6) NOT NULL DEFAULT '',
 ht_plcental_site VARCHAR(6) NOT NULL DEFAULT '',
 ht_teratoma VARCHAR(6) NOT NULL DEFAULT '',
 ht_teratoma_w_secondary VARCHAR(6) NOT NULL DEFAULT '',
 ht_teratoma_w_secondary_precision VARCHAR(50) NOT NULL DEFAULT '',
 ht_monodermal_teratoma_carcinoid VARCHAR(6) NOT NULL DEFAULT '',
 ht_monodermal_teratoma_primitive VARCHAR(6) NOT NULL DEFAULT '',
 ht_monodermal_teratoma_other VARCHAR(6) NOT NULL DEFAULT '',
 ht_monodermal_teratoma_other_precision VARCHAR(50) NOT NULL DEFAULT '',
 ht_spermatocytic VARCHAR(6) NOT NULL DEFAULT '',
 ht_spermatocytic_w_sarcomatous VARCHAR(6) NOT NULL DEFAULT '',
 ht_mixed_germ_gonadoblastoma VARCHAR(6) NOT NULL DEFAULT '',
 ht_mixed_germ_others VARCHAR(6) NOT NULL DEFAULT '',
 ht_mixed_germ_others_precision VARCHAR(50) NOT NULL DEFAULT '',
 ht_testicular_scar VARCHAR(6) NOT NULL DEFAULT '',
 ht_testicular_scar_only VARCHAR(6) NOT NULL DEFAULT '',
 ht_testicular_scar_w_intratubular VARCHAR(6) NOT NULL DEFAULT '',
 ht_sex_cord VARCHAR(6) NOT NULL DEFAULT '',
 ht_sex_cord_leydig VARCHAR(6) NOT NULL DEFAULT '',
 ht_sex_cord_sertoli VARCHAR(6) NOT NULL DEFAULT '',
 ht_sex_cord_sertoli_classic VARCHAR(6) NOT NULL DEFAULT '',
 ht_sex_cord_sertoli_sclerosing VARCHAR(6) NOT NULL DEFAULT '',
 ht_sex_cord_sertoli_large VARCHAR(6) NOT NULL DEFAULT '',
 ht_sex_cord_granulosa VARCHAR(6) NOT NULL DEFAULT '',
 ht_sex_cord_granulosa_adult VARCHAR(6) NOT NULL DEFAULT '',
 ht_sex_cord_granulosa_juvenile VARCHAR(6) NOT NULL DEFAULT '',
 ht_sex_cord_mixed VARCHAR(6) NOT NULL DEFAULT '',
 ht_sex_cord_mixed_precision text NOT NULL DEFAULT '',
 ht_sex_cord_unclassified VARCHAR(6) NOT NULL DEFAULT '',
 ht_malignant VARCHAR(6) NOT NULL DEFAULT '',
 ht_other VARCHAR(6) NOT NULL DEFAULT '',
 ht_other_precision VARCHAR(6) NOT NULL DEFAULT '',
 lymph_vascular_invasion VARCHAR(50) NOT NULL DEFAULT'',
 ptmn_m VARCHAR(6) NOT NULL DEFAULT'', 
 ptmn_r VARCHAR(6) NOT NULL DEFAULT'', 
 ptmn_y VARCHAR(6) NOT NULL DEFAULT'',
 created DATETIME NOT NULL,
 created_by INT UNSIGNED NOT NULL,
 modified DATETIME NOT NULL,
 modified_by INT UNSIGNED NOT NULL,
 deleted BOOLEAN NOT NULL DEFAULT 0,
 deleted_date DATETIME DEFAULT NULL,
 version_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 version_created DATETIME NOT NULL
)Engine=InnoDb;


INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_gastro_cap_testis_specimen','','', "StructurePermissibleValuesCustom::getCustomDropdown('cap testis specimen')");
INSERT INTO structure_permissible_values_custom_controls(name, flag_active, values_max_length) VALUES ('cap testis specimen', 1, 50);

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_gastro_cap_testis_procedure','','', "StructurePermissibleValuesCustom::getCustomDropdown('cap testis procedure')");
INSERT INTO structure_permissible_values_custom_controls(name, flag_active, values_max_length) VALUES ('cap testis procedure', 1, 50);

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_gastro_laterality_lrbu', '', '', null);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("left", "left");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_gastro_laterality_lrbu"),  (SELECT id FROM structure_permissible_values WHERE value="left" AND language_alias="left"), "0", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("right", "right");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_gastro_laterality_lrbu"),  (SELECT id FROM structure_permissible_values WHERE value="right" AND language_alias="right"), "0", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("both", "both");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_gastro_laterality_lrbu"),  (SELECT id FROM structure_permissible_values WHERE value="both" AND language_alias="both"), "0", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("not specified", "not specified");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_gastro_laterality_lrbu"),  (SELECT id FROM structure_permissible_values WHERE value="not specified" AND language_alias="not specified"), "0", "1");

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_gastro_cap_testis_tumor_site','','', "StructurePermissibleValuesCustom::getCustomDropdown('cap testis tumor site')");
INSERT INTO structure_permissible_values_custom_controls(name, flag_active, values_max_length) VALUES ('cap testis tumor site', 1, 50);

INSERT INTO structures(`alias`) VALUES ('qc_gastro_dxd_cap_testis');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_testis', 'specimen', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_testis_specimen') , '0', '', '', '', 'specimen', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_testis', 'm_procedure', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_testis_procedure') , '0', '', '', '', 'procedure', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_testis', 'specimen_laterality', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_laterality_lrbu') , '0', '', '', '', 'specimen laterality', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_testis', 'tumor_site', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_testis_tumor_site') , '0', '', '', '', 'tumor site', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_testis', 'tumor_size_cannot_determine', 'checkbox',  NULL , '0', '', '', '', 'tumor size cannot determine', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_testis', 'tumor_size_greatest_cm', 'float_positive',  NULL , '0', '', '', '', 'greatest dimension (cm)', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_testis', 'tumor_size_add1_cm', 'float_positive',  NULL , '0', '', '', '', 'additional dimensions (cm)', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_testis', 'tumor_size_add2_cm', 'float_positive',  NULL , '0', '', '', '', '', 'x'), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_testis', 'tumor_nodule1_greatest_dimension_cm', 'float_positive',  NULL , '0', '', '', '', 'nodule 1 greatest dimension (cm)', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_testis', 'tumor_nodule2_greatest_dimension_cm', 'float_positive',  NULL , '0', '', '', '', '', 'nodule 2'), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_testis', 'tumor_nodule3_greatest_dimension_cm', 'float_positive',  NULL , '0', '', '', '', '', 'nodule 3'), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_testis', 'tumor_nodule4_greatest_dimension_cm', 'float_positive',  NULL , '0', '', '', '', '', 'nodule 4'), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_testis', 'ht_intratubular', 'checkbox',  NULL , '0', '', '', '', 'Intratubular germ cell neoplasia, unclassified only', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_testis', 'ht_seminoma_classic', 'checkbox',  NULL , '0', '', '', '', 'Seminoma, classic type', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_testis', 'ht_seminoma_scar', 'checkbox',  NULL , '0', '', '', '', 'Seminoma with associated scar', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_testis', 'ht_seminoma_sync_cell', 'checkbox',  NULL , '0', '', '', '', 'Seminoma with syncytiotrophoblastic cells', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_testis', 'ht_embryonal', 'checkbox',  NULL , '0', '', '', '', 'Embryonal carcinoma', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_testis', 'ht_yolk', 'checkbox',  NULL , '0', '', '', '', 'Yolk sac tumor', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_testis', 'ht_chorio_biphasic', 'checkbox',  NULL , '0', '', '', '', 'Choriocarcinoma, biphasic', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_testis', 'ht_chorio_monophasic', 'checkbox',  NULL , '0', '', '', '', 'Choriocarcinoma, monophasic', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_testis', 'ht_plcental_site', 'checkbox',  NULL , '0', '', '', '', 'Placental site trophoblastic tumor', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_testis', 'ht_teratoma', 'checkbox',  NULL , '0', '', '', '', 'Teratoma', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_testis', 'ht_monodermal_teratoma_carcinoid', 'checkbox',  NULL , '0', '', '', '', 'Monodermal teratoma, carcinoid', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_testis', 'ht_monodermal_teratoma_primitive', 'checkbox',  NULL , '0', '', '', '', 'Monodermal teratoma, primitive neuroectodermal tumor', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_testis', 'ht_monodermal_teratoma_other', 'checkbox',  NULL , '0', '', '', '', 'Monodermal teratoma, other', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_testis', 'ht_teratoma_w_secondary', 'checkbox',  NULL , '0', '', '', '', 'Teratoma with a secondary somatic-type malignant component', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_testis', 'ht_teratoma_w_secondary_precision', 'input',  NULL , '0', '', '', '', '', 'specify type'), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_testis', 'ht_mixed_germ', 'checkbox',  NULL , '0', '', '', '', 'Mixed germ cell tumor', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_testis', 'ht_mixed_germ_precision', 'textarea',  NULL , '0', '', '', '', '', 'specify components and approximate percentages'), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_testis', 'ht_monodermal_teratoma_other_precision', 'input',  NULL , '0', '', '', '', '', 'specify'), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_testis', 'ht_spermatocytic', 'checkbox',  NULL , '0', '', '', '', 'Spermatocytic seminoma', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_testis', 'ht_spermatocytic_w_sarcomatous', 'checkbox',  NULL , '0', '', '', '', 'Spermatocytic seminoma with a sarcomatous component', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_testis', 'ht_mixed_germ_gonadoblastoma', 'checkbox',  NULL , '0', '', '', '', 'Mixed germ cell-sex cord-stromal tumor, gonadoblastoma', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_testis', 'ht_mixed_germ_others', 'checkbox',  NULL , '0', '', '', '', 'Mixed germ cell-sex cord-stromal tumor, others', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_testis', 'ht_mixed_germ_others_precision', 'input',  NULL , '0', '', '', '', '', 'specify'), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_testis', 'ht_testicular_scar', 'checkbox',  NULL , '0', '', '', '', 'Testicular scar', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_testis', 'ht_testicular_scar_only', 'checkbox',  NULL , '0', '', '', '', '-Scar only', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_testis', 'ht_testicular_scar_w_intratubular', 'checkbox',  NULL , '0', '', '', '', '-Scar with intratubular germ cell neoplasia', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_testis', 'ht_sex_cord', 'checkbox',  NULL , '0', '', '', '', 'Sex cord-stromal tumor', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_testis', 'ht_sex_cord_leydig', 'checkbox',  NULL , '0', '', '', '', '-Leydig cell tumor', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_testis', 'ht_sex_cord_sertoli', 'checkbox',  NULL , '0', '', '', '', '-Sertoli cell tumor', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_testis', 'ht_sex_cord_sertoli_classic', 'checkbox',  NULL , '0', '', '', '', '--Classic', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_testis', 'ht_sex_cord_sertoli_sclerosing', 'checkbox',  NULL , '0', '', '', '', '--Sclerosing', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_testis', 'ht_sex_cord_sertoli_large', 'checkbox',  NULL , '0', '', '', '', '--Large cell calcifying', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_testis', 'ht_sex_cord_granulosa', 'checkbox',  NULL , '0', '', '', '', '-Granulosa cell tumor', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_testis', 'ht_sex_cord_granulosa_adult', 'checkbox',  NULL , '0', '', '', '', '--Adult-type', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_testis', 'ht_sex_cord_granulosa_juvenile', 'checkbox',  NULL , '0', '', '', '', '--Juvenile-type', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_testis', 'ht_sex_cord_mixed', 'checkbox',  NULL , '0', '', '', '', '-Mixed, with components', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_testis', 'ht_sex_cord_mixed_precision', 'textarea',  NULL , '0', '', '', '', '', 'specify components and approximate percentages'), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_testis', 'ht_sex_cord_unclassified', 'checkbox',  NULL , '0', '', '', '', '-Unclassified', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_testis', 'ht_malignant', 'checkbox',  NULL , '0', '', '', '', 'Malignant neoplasm, type cannot be determined', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_testis', 'ht_other', 'checkbox',  NULL , '0', '', '', '', 'Other', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_testis', 'ht_other_precision', 'input',  NULL , '0', '', '', '', '', 'specify'), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_testis', 'lymph_vascular_invasion', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_not_id_pres_indet') , '0', '', '', '', 'lymph vascular invasion', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_testis', 'ptmn_m', 'checkbox',  NULL , '0', '', '', '', 'm (multiple)', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_testis', 'ptmn_r', 'checkbox',  NULL , '0', '', '', '', 'r (recurrent)', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_testis', 'ptmn_y', 'checkbox',  NULL , '0', '', '', '', 'y (post-treatment)', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_testis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '1', '', '1', 'report date', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_testis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_testis' AND `field`='specimen' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_testis_specimen')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='specimen' AND `language_tag`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_testis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_testis' AND `field`='m_procedure' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_testis_procedure')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='procedure' AND `language_tag`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_testis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_testis' AND `field`='specimen_laterality' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_laterality_lrbu')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='specimen laterality' AND `language_tag`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_testis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_testis' AND `field`='tumor_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_testis_tumor_site')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tumor site' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_testis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_testis' AND `field`='tumor_size_cannot_determine' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tumor size cannot determine' AND `language_tag`=''), '1', '6', 'tumor size', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_testis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_testis' AND `field`='tumor_size_greatest_cm' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='greatest dimension (cm)' AND `language_tag`=''), '1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_testis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_testis' AND `field`='tumor_size_add1_cm' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='additional dimensions (cm)' AND `language_tag`=''), '1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_testis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_testis' AND `field`='tumor_size_add2_cm' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='x'), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_testis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_testis' AND `field`='tumor_nodule1_greatest_dimension_cm' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='nodule 1 greatest dimension (cm)' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_testis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_testis' AND `field`='tumor_nodule2_greatest_dimension_cm' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='nodule 2'), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_testis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_testis' AND `field`='tumor_nodule3_greatest_dimension_cm' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='nodule 3'), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_testis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_testis' AND `field`='tumor_nodule4_greatest_dimension_cm' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='nodule 4'), '1', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_testis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_testis' AND `field`='ht_intratubular' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='Intratubular germ cell neoplasia, unclassified only' AND `language_tag`=''), '2', '14', 'histologic type', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_testis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_testis' AND `field`='ht_seminoma_classic' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='Seminoma, classic type' AND `language_tag`=''), '2', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_testis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_testis' AND `field`='ht_seminoma_scar' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='Seminoma with associated scar' AND `language_tag`=''), '2', '16', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_testis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_testis' AND `field`='ht_seminoma_sync_cell' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='Seminoma with syncytiotrophoblastic cells' AND `language_tag`=''), '2', '17', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_testis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_testis' AND `field`='ht_embryonal' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='Embryonal carcinoma' AND `language_tag`=''), '2', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_testis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_testis' AND `field`='ht_yolk' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='Yolk sac tumor' AND `language_tag`=''), '2', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_testis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_testis' AND `field`='ht_chorio_biphasic' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='Choriocarcinoma, biphasic' AND `language_tag`=''), '2', '22', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_testis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_testis' AND `field`='ht_chorio_monophasic' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='Choriocarcinoma, monophasic' AND `language_tag`=''), '2', '23', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_testis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_testis' AND `field`='ht_plcental_site' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='Placental site trophoblastic tumor' AND `language_tag`=''), '2', '24', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_testis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_testis' AND `field`='ht_teratoma' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='Teratoma' AND `language_tag`=''), '2', '25', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_testis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_testis' AND `field`='ht_monodermal_teratoma_carcinoid' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='Monodermal teratoma, carcinoid' AND `language_tag`=''), '2', '28', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_testis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_testis' AND `field`='ht_monodermal_teratoma_primitive' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='Monodermal teratoma, primitive neuroectodermal tumor' AND `language_tag`=''), '2', '29', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_testis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_testis' AND `field`='ht_monodermal_teratoma_other' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='Monodermal teratoma, other' AND `language_tag`=''), '2', '30', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_testis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_testis' AND `field`='ht_teratoma_w_secondary' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='Teratoma with a secondary somatic-type malignant component' AND `language_tag`=''), '2', '26', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_testis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_testis' AND `field`='ht_teratoma_w_secondary_precision' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='specify type'), '2', '27', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_testis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_testis' AND `field`='ht_mixed_germ' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='Mixed germ cell tumor' AND `language_tag`=''), '2', '18', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_testis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_testis' AND `field`='ht_mixed_germ_precision' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='specify components and approximate percentages'), '2', '19', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_testis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_testis' AND `field`='ht_monodermal_teratoma_other_precision' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='specify'), '2', '31', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_testis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_testis' AND `field`='ht_spermatocytic' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='Spermatocytic seminoma' AND `language_tag`=''), '2', '32', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_testis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_testis' AND `field`='ht_spermatocytic_w_sarcomatous' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='Spermatocytic seminoma with a sarcomatous component' AND `language_tag`=''), '2', '33', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_testis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_testis' AND `field`='ht_mixed_germ_gonadoblastoma' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='Mixed germ cell-sex cord-stromal tumor, gonadoblastoma' AND `language_tag`=''), '2', '34', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_testis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_testis' AND `field`='ht_mixed_germ_others' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='Mixed germ cell-sex cord-stromal tumor, others' AND `language_tag`=''), '2', '35', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_testis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_testis' AND `field`='ht_mixed_germ_others_precision' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='specify'), '2', '36', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_testis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_testis' AND `field`='ht_testicular_scar' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='Testicular scar' AND `language_tag`=''), '2', '37', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_testis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_testis' AND `field`='ht_testicular_scar_only' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='-Scar only' AND `language_tag`=''), '2', '38', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_testis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_testis' AND `field`='ht_testicular_scar_w_intratubular' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='-Scar with intratubular germ cell neoplasia' AND `language_tag`=''), '2', '39', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_testis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_testis' AND `field`='ht_sex_cord' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='Sex cord-stromal tumor' AND `language_tag`=''), '2', '40', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_testis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_testis' AND `field`='ht_sex_cord_leydig' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='-Leydig cell tumor' AND `language_tag`=''), '2', '41', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_testis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_testis' AND `field`='ht_sex_cord_sertoli' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='-Sertoli cell tumor' AND `language_tag`=''), '2', '42', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_testis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_testis' AND `field`='ht_sex_cord_sertoli_classic' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='--Classic' AND `language_tag`=''), '2', '43', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_testis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_testis' AND `field`='ht_sex_cord_sertoli_sclerosing' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='--Sclerosing' AND `language_tag`=''), '2', '44', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_testis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_testis' AND `field`='ht_sex_cord_sertoli_large' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='--Large cell calcifying' AND `language_tag`=''), '2', '45', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_testis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_testis' AND `field`='ht_sex_cord_granulosa' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='-Granulosa cell tumor' AND `language_tag`=''), '2', '46', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_testis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_testis' AND `field`='ht_sex_cord_granulosa_adult' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='--Adult-type' AND `language_tag`=''), '2', '47', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_testis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_testis' AND `field`='ht_sex_cord_granulosa_juvenile' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='--Juvenile-type' AND `language_tag`=''), '2', '48', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_testis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_testis' AND `field`='ht_sex_cord_mixed' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='-Mixed, with components' AND `language_tag`=''), '2', '49', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_testis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_testis' AND `field`='ht_sex_cord_mixed_precision' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='specify components and approximate percentages'), '2', '50', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_testis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_testis' AND `field`='ht_sex_cord_unclassified' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='-Unclassified' AND `language_tag`=''), '2', '51', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_testis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_testis' AND `field`='ht_malignant' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='Malignant neoplasm, type cannot be determined' AND `language_tag`=''), '2', '52', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_testis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_testis' AND `field`='ht_other' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='Other' AND `language_tag`=''), '2', '53', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_testis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_testis' AND `field`='ht_other_precision' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='specify'), '2', '54', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_testis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_testis' AND `field`='lymph_vascular_invasion' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_not_id_pres_indet')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='lymph vascular invasion' AND `language_tag`=''), '1', '55', 'lymph', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_testis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_testis' AND `field`='ptmn_m' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='m (multiple)' AND `language_tag`=''), '1', '56', 'pTNM', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_testis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_testis' AND `field`='ptmn_r' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='r (recurrent)' AND `language_tag`=''), '1', '57', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_testis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_testis' AND `field`='ptmn_y' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='y (post-treatment)' AND `language_tag`=''), '1', '58', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT INTO diagnosis_controls (controls_type, flag_active, form_alias, detail_tablename, display_order, databrowser_label) VALUES
('cap report - testis: radical orchiectomy', 1,'qc_gastro_dxd_cap_testis','qc_gastro_dxd_cap_testis', 0,'cap report - testis: radical orchiectomy');










CREATE TABLE qc_gastro_dxd_cap_bladders(
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 diagnosis_master_id INT NOT NULL,
 specimen VARCHAR(50) NOT NULL DEFAULT'',
 m_procedure VARCHAR(50) NOT NULL DEFAULT'',
 tumor_site_trigone BOOLEAN DEFAULT NULL,
 tumor_site_right_lateral BOOLEAN DEFAULT NULL,
 tumor_site_left_lateral BOOLEAN DEFAULT NULL,
 tumor_site_anterior BOOLEAN DEFAULT NULL,
 tumor_site_posterior BOOLEAN DEFAULT NULL,
 tumor_site_dome BOOLEAN DEFAULT NULL,
 tumor_site_other BOOLEAN DEFAULT NULL,
 tumor_site_other_specify VARCHAR(50) NOT NULL DEFAULT'',
 tumor_site_not_specified BOOLEAN DEFAULT NULL,
 tumor_size_cannot_determine VARCHAR(6) NOT NULL DEFAULT'', 
 tumor_size_greatest_cm FLOAT UNSIGNED DEFAULT NULL,
 tumor_size_add1_cm FLOAT UNSIGNED DEFAULT NULL,
 tumor_size_add2_cm FLOAT UNSIGNED DEFAULT NULL,
 histologic_type VARCHAR(250) NOT NULL DEFAULT'',
 histologic_type_precision VARCHAR(250) NOT NULL DEFAULT'',
 histologic_grade VARCHAR(50) NOT NULL DEFAULT'',
 lymph_vascular_invasion VARCHAR(50) NOT NULL DEFAULT'',
 ptmn_m VARCHAR(6) NOT NULL DEFAULT'', 
 ptmn_r VARCHAR(6) NOT NULL DEFAULT'', 
 ptmn_y VARCHAR(6) NOT NULL DEFAULT'',
 created DATETIME NOT NULL,
 created_by INT UNSIGNED NOT NULL,
 modified DATETIME NOT NULL,
 modified_by INT UNSIGNED NOT NULL,
 deleted BOOLEAN NOT NULL DEFAULT 0,
 deleted_date DATETIME DEFAULT NULL,
 FOREIGN KEY (`diagnosis_master_id`) REFERENCES diagnosis_masters(id)
)Engine=InnoDb;
CREATE TABLE qc_gastro_dxd_cap_bladders_revs(
 id INT UNSIGNED NOT NULL,
 diagnosis_master_id INT NOT NULL,
 specimen VARCHAR(50) NOT NULL DEFAULT'',
 m_procedure VARCHAR(50) NOT NULL DEFAULT'',
 specimen_laterality VARCHAR(10) NOT NULL DEFAULT'',
 tumor_site_trigone BOOLEAN DEFAULT NULL,
 tumor_site_right_lateral BOOLEAN DEFAULT NULL,
 tumor_site_left_lateral BOOLEAN DEFAULT NULL,
 tumor_site_anterior BOOLEAN DEFAULT NULL,
 tumor_site_posterior BOOLEAN DEFAULT NULL,
 tumor_site_dome BOOLEAN DEFAULT NULL,
 tumor_site_other BOOLEAN DEFAULT NULL,
 tumor_site_other_specify VARCHAR(50) NOT NULL DEFAULT'',
 tumor_site_not_specified BOOLEAN DEFAULT NULL,
 tumor_size_cannot_determine VARCHAR(6) NOT NULL DEFAULT'', 
 tumor_size_greatest_cm FLOAT UNSIGNED DEFAULT NULL,
 tumor_size_add1_cm FLOAT UNSIGNED DEFAULT NULL,
 tumor_size_add2_cm FLOAT UNSIGNED DEFAULT NULL,
 histologic_type VARCHAR(250) NOT NULL DEFAULT'',
 histologic_type_precision VARCHAR(250) NOT NULL DEFAULT'',
 histologic_grade VARCHAR(250) NOT NULL DEFAULT'',
 lymph_vascular_invasion VARCHAR(50) NOT NULL DEFAULT'',
 ptmn_m VARCHAR(6) NOT NULL DEFAULT'', 
 ptmn_r VARCHAR(6) NOT NULL DEFAULT'', 
 ptmn_y VARCHAR(6) NOT NULL DEFAULT'',
 created DATETIME NOT NULL,
 created_by INT UNSIGNED NOT NULL,
 modified DATETIME NOT NULL,
 modified_by INT UNSIGNED NOT NULL,
 deleted BOOLEAN NOT NULL DEFAULT 0,
 deleted_date DATETIME DEFAULT NULL,
 version_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 version_created DATETIME NOT NULL
)Engine=InnoDb;

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_gastro_cap_bladder_specimen','','', "StructurePermissibleValuesCustom::getCustomDropdown('cap bladder specimen')");
INSERT INTO structure_permissible_values_custom_controls(name, flag_active, values_max_length) VALUES ('cap bladder specimen', 1, 50);
INSERT INTO structure_permissible_values_customs (control_id, value, en, fr) VALUES
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap bladder specimen'), 'bladder', '', ''),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap bladder specimen'), 'not specified', '', '');

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_gastro_cap_bladder_procedure','','', "StructurePermissibleValuesCustom::getCustomDropdown('cap bladder procedure')");
INSERT INTO structure_permissible_values_custom_controls(name, flag_active, values_max_length) VALUES ('cap bladder procedure', 1, 50);
INSERT INTO structure_permissible_values_customs (control_id, value, en, fr) VALUES
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap bladder procedure'), 'Partial cystectomy', '', ''),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap bladder procedure'), 'Total cystectomy', '', ''),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap bladder procedure'), 'Radical cystectomy', '', ''),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap bladder procedure'), 'Radical cystoprostatectomy', '', ''),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap bladder procedure'), 'Anterior exenteration', '', ''),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap bladder procedure'), 'Not specified', '', '');

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_gastro_cap_bladder_histologic_type','','', "StructurePermissibleValuesCustom::getCustomDropdown('cap bladder histologic type')");
INSERT INTO structure_permissible_values_custom_controls(name, flag_active, values_max_length) VALUES ('cap bladder histologic type', 1, 50);
INSERT INTO structure_permissible_values_customs (control_id, value, en, fr) VALUES
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap bladder histologic type'), 'Urothelial (transitional cell) carcinoma', '', ''),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap bladder histologic type'), 'Urothelial (transitional cell) carcinoma with squamous differentiation', '', ''),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap bladder histologic type'), 'Urothelial (transitional cell) carcinoma with glandular differentiation', '', ''),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap bladder histologic type'), 'Urothelial (transitional cell) carcinoma with variant histology (specify)', '', ''),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap bladder histologic type'), 'Squamous cell carcinoma, typical', '', ''),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap bladder histologic type'), 'Squamous cell carcinoma, variant histology (specify)', '', ''),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap bladder histologic type'), 'Adenocarcinoma, typical', '', ''),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap bladder histologic type'), 'Adenocarcinoma, variant histology (specify)', '', ''),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap bladder histologic type'), 'Small cell carcinoma', '', ''),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap bladder histologic type'), 'Undifferentiated carcinoma (specify)', '', ''),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap bladder histologic type'), 'Mixed cell type (specify)', '', ''),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap bladder histologic type'), 'Carcinoma, type cannot be determined', '', '');

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_gastro_bladder_histologic_grade', '', '', null);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
("not applicable", "not applicable"),
("cannot be determined", "cannot be determined");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="qc_gastro_bladder_histologic_grade"),  (SELECT id FROM structure_permissible_values WHERE value="not applicable" AND language_alias="not applicable"), "0", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_gastro_bladder_histologic_grade"),  (SELECT id FROM structure_permissible_values WHERE value="cannot be determined" AND language_alias="cannot be determined"), "0", "1");

INSERT INTO structures(`alias`) VALUES ('qc_gastro_dxd_cap_bladders');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisMaster', 'qc_gastro_dxd_cap_bladders', 'specimen', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_bladder_specimen') , '0', '', '', '', 'specimen', ''), 
('Clinicalannotation', 'DiagnosisMaster', 'qc_gastro_dxd_cap_bladders', 'm_procedure', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_bladder_procedure') , '0', '', '', '', 'procedure', ''), 
('Clinicalannotation', 'DiagnosisMaster', 'qc_gastro_dxd_cap_bladders', 'tumor_site_trigone', 'checkbox',  NULL , '0', '', '', '', 'trigone', ''), 
('Clinicalannotation', 'DiagnosisMaster', 'qc_gastro_dxd_cap_bladders', 'tumor_site_right_lateral', 'checkbox',  NULL , '0', '', '', '', 'right lateral wall', ''), 
('Clinicalannotation', 'DiagnosisMaster', 'qc_gastro_dxd_cap_bladders', 'tumor_site_left_lateral', 'checkbox',  NULL , '0', '', '', '', 'left lateral wall', ''), 
('Clinicalannotation', 'DiagnosisMaster', 'qc_gastro_dxd_cap_bladders', 'tumor_site_anterior', 'checkbox',  NULL , '0', '', '', '', 'anterior wall', ''), 
('Clinicalannotation', 'DiagnosisMaster', 'qc_gastro_dxd_cap_bladders', 'tumor_site_posterior', 'checkbox',  NULL , '0', '', '', '', 'posterior wall', ''), 
('Clinicalannotation', 'DiagnosisMaster', 'qc_gastro_dxd_cap_bladders', 'tumor_site_dome', 'checkbox',  NULL , '0', '', '', '', 'dome', ''), 
('Clinicalannotation', 'DiagnosisMaster', 'qc_gastro_dxd_cap_bladders', 'tumor_site_other', 'checkbox',  NULL , '0', '', '', '', 'other', ''), 
('Clinicalannotation', 'DiagnosisMaster', 'qc_gastro_dxd_cap_bladders', 'tumor_site_other_specify', 'input',  NULL , '0', '', '', '', '', 'specify'), 
('Clinicalannotation', 'DiagnosisMaster', 'qc_gastro_dxd_cap_bladders', 'tumor_site_not_specified', 'checkbox',  NULL , '0', '', '', '', 'not specified', ''), 
('Clinicalannotation', 'DiagnosisMaster', 'qc_gastro_dxd_cap_bladders', 'tumor_size_cannot_determine', 'checkbox',  NULL , '0', '', '', '', 'cannot determine', ''), 
('Clinicalannotation', 'DiagnosisMaster', 'qc_gastro_dxd_cap_bladders', 'tumor_size_greatest_cm', 'float',  NULL , '0', '', '', '', 'greatest dimension (cm)', ''), 
('Clinicalannotation', 'DiagnosisMaster', 'qc_gastro_dxd_cap_bladders', 'tumor_size_add1_cm', 'float',  NULL , '0', '', '', '', 'additional dimensions (cm)', ''), 
('Clinicalannotation', 'DiagnosisMaster', 'qc_gastro_dxd_cap_bladders', 'tumor_size_add2_cm', 'float',  NULL , '0', '', '', '', '', 'x'), 
('Clinicalannotation', 'DiagnosisMaster', 'qc_gastro_dxd_cap_bladders', 'histologic_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_bladder_histologic_type') , '0', '', '', '', 'histologic type', ''), 
('Clinicalannotation', 'DiagnosisMaster', 'qc_gastro_dxd_cap_bladders', 'histologic_type_precision', 'input',  NULL , '0', '', '', '', 'histologic type precision (if any)', ''), 
('Clinicalannotation', 'DiagnosisMaster', 'qc_gastro_dxd_cap_bladders', 'histologic_grade', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_bladder_histologic_grade') , '0', '', '', '', 'histologic grade', ''), 
('Clinicalannotation', 'DiagnosisMaster', 'qc_gastro_dxd_cap_bladders', 'lymph_vascular_invasion', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_not_id_pres_indet') , '0', '', '', '', 'lymph vascular invasion', ''), 
('Clinicalannotation', 'DiagnosisMaster', 'qc_gastro_dxd_cap_bladders', 'ptmn_m', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_not_id_pres_indet') , '0', '', '', '', 'm (multiple primary tumors)', ''), 
('Clinicalannotation', 'DiagnosisMaster', 'qc_gastro_dxd_cap_bladders', 'ptmn_r', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_not_id_pres_indet') , '0', '', '', '', 'r (recurrent)', ''), 
('Clinicalannotation', 'DiagnosisMaster', 'qc_gastro_dxd_cap_bladders', 'ptmn_y', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_not_id_pres_indet') , '0', '', '', '', 'y (post-treatment)', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_bladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '1', '', '1', 'report date', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_bladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='qc_gastro_dxd_cap_bladders' AND `field`='specimen' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_bladder_specimen')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='specimen' AND `language_tag`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_bladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='qc_gastro_dxd_cap_bladders' AND `field`='m_procedure' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_bladder_procedure')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='procedure' AND `language_tag`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_bladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='qc_gastro_dxd_cap_bladders' AND `field`='tumor_site_trigone' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='trigone' AND `language_tag`=''), '1', '4', 'tumor site', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_bladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='qc_gastro_dxd_cap_bladders' AND `field`='tumor_site_right_lateral' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='right lateral wall' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_bladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='qc_gastro_dxd_cap_bladders' AND `field`='tumor_site_left_lateral' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='left lateral wall' AND `language_tag`=''), '1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_bladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='qc_gastro_dxd_cap_bladders' AND `field`='tumor_site_anterior' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='anterior wall' AND `language_tag`=''), '1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_bladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='qc_gastro_dxd_cap_bladders' AND `field`='tumor_site_posterior' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='posterior wall' AND `language_tag`=''), '1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_bladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='qc_gastro_dxd_cap_bladders' AND `field`='tumor_site_dome' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='dome' AND `language_tag`=''), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_bladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='qc_gastro_dxd_cap_bladders' AND `field`='tumor_site_other' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='other' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_bladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='qc_gastro_dxd_cap_bladders' AND `field`='tumor_site_other_specify' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='specify'), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_bladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='qc_gastro_dxd_cap_bladders' AND `field`='tumor_site_not_specified' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='not specified' AND `language_tag`=''), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_bladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='qc_gastro_dxd_cap_bladders' AND `field`='tumor_size_cannot_determine' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='cannot determine' AND `language_tag`=''), '1', '13', 'tumor size', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_bladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='qc_gastro_dxd_cap_bladders' AND `field`='tumor_size_greatest_cm' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='greatest dimension (cm)' AND `language_tag`=''), '1', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_bladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='qc_gastro_dxd_cap_bladders' AND `field`='tumor_size_add1_cm' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='additional dimensions (cm)' AND `language_tag`=''), '1', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_bladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='qc_gastro_dxd_cap_bladders' AND `field`='tumor_size_add2_cm' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='x'), '1', '16', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_bladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='qc_gastro_dxd_cap_bladders' AND `field`='histologic_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_cap_bladder_histologic_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='histologic type' AND `language_tag`=''), '2', '17', 'histology', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_bladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='qc_gastro_dxd_cap_bladders' AND `field`='histologic_type_precision' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='histologic type precision (if any)' AND `language_tag`=''), '2', '18', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_bladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='qc_gastro_dxd_cap_bladders' AND `field`='histologic_grade' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_bladder_histologic_grade')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='histologic grade' AND `language_tag`=''), '2', '19', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_bladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='qc_gastro_dxd_cap_bladders' AND `field`='lymph_vascular_invasion' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_not_id_pres_indet')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='lymph vascular invasion' AND `language_tag`=''), '2', '20', 'lymph', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_bladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='qc_gastro_dxd_cap_bladders' AND `field`='ptmn_m' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_not_id_pres_indet')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='m (multiple primary tumors)' AND `language_tag`=''), '2', '21', 'pTNM', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_bladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='qc_gastro_dxd_cap_bladders' AND `field`='ptmn_r' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_not_id_pres_indet')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='r (recurrent)' AND `language_tag`=''), '2', '22', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_bladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='qc_gastro_dxd_cap_bladders' AND `field`='ptmn_y' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_not_id_pres_indet')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='y (post-treatment)' AND `language_tag`=''), '2', '23', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT INTO diagnosis_controls (controls_type, flag_active, form_alias, detail_tablename, display_order, databrowser_label) VALUES
('cap report - urinary bladder', 1,'qc_gastro_dxd_cap_bladders','qc_gastro_dxd_cap_bladders', 0,'cap report - urinary bladder');