-- Run against a 2.4.2 installation

-- Update version information
INSERT INTO `versions` (version_number, date_installed, build_number) VALUES
('2.4.3', NOW(), '4043');

UPDATE structure_fields SET  `type`='integer_positive',  `structure_value_domain`= NULL  WHERE model='ReproductiveHistory' AND tablename='reproductive_histories' AND field='hrt_years_used' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='hrt_years_used');
UPDATE structure_fields SET  `setting`='' WHERE model='ReproductiveHistory' AND tablename='reproductive_histories' AND field='age_at_menopause' AND `type`='integer_positive' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `setting`='' WHERE model='ReproductiveHistory' AND tablename='reproductive_histories' AND field='gravida' AND `type`='integer_positive' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `setting`='' WHERE model='ReproductiveHistory' AND tablename='reproductive_histories' AND field='para' AND `type`='integer_positive' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `setting`='' WHERE model='ReproductiveHistory' AND tablename='reproductive_histories' AND field='age_at_first_parturition' AND `type`='integer_positive' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `setting`='' WHERE model='ReproductiveHistory' AND tablename='reproductive_histories' AND field='age_at_last_parturition' AND `type`='integer_positive' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `setting`='' WHERE model='ReproductiveHistory' AND tablename='reproductive_histories' AND field='age_at_menarche' AND `type`='integer_positive' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `setting`='' WHERE model='ReproductiveHistory' AND tablename='reproductive_histories' AND field='years_on_hormonal_contraceptives' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `setting`='' WHERE model='ReproductiveHistory' AND tablename='reproductive_histories' AND field='hysterectomy_age' AND `type`='integer_positive' AND structure_value_domain  IS NULL ;

UPDATE structure_fields SET  `type`='float_positive' WHERE model='ReproductiveHistory' AND tablename='reproductive_histories' AND field='hrt_years_used' AND `type`='integer_positive' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `type`='float_positive' WHERE model='ReproductiveHistory' AND tablename='reproductive_histories' AND field='years_on_hormonal_contraceptives' AND `type`='input' AND structure_value_domain  IS NULL ;

ALTER TABLE reproductive_histories
 MODIFY hrt_years_used FLOAT UNSIGNED DEFAULT NULL,
 MODIFY years_on_hormonal_contraceptives FLOAT UNSIGNED DEFAULT NULL;
ALTER TABLE reproductive_histories_revs
 MODIFY hrt_years_used FLOAT UNSIGNED DEFAULT NULL,
 MODIFY years_on_hormonal_contraceptives FLOAT UNSIGNED DEFAULT NULL;
 
ALTER TABLE family_histories
 MODIFY participant_id INT NOT NULL;
ALTER TABLE family_histories_revs
 MODIFY participant_id INT NOT NULL;

ALTER TABLE coding_icd_o_3_morphology
 ADD COLUMN source VARCHAR(20) NOT NULL DEFAULT '';
 
UPDATE coding_icd_o_3_morphology SET source='WHO';
 
INSERT INTO coding_icd_o_3_morphology (id, en_description, fr_description, translated) VALUES
("80712", "Sq. cell carcinoma, keratinizing, NOS, in situ", "", 0),
("80722", "Sq. cell carcinoma, lg. cell, non-ker., in situ", "", 0),
("82202", "Adenocarcinoma in situ in familial polyp. coli", "", 0),
("82212", "Adenocarc. in situ in mult. adenomatous polyps", "", 0),
("85232", "Infiltr. duct mixed with other types of carcinoma, in situ", "", 0),
("85613", "Warthin tumor, malignant", "", 0),
("85903", "Ovarian stromal tumor, mal.", "", 0),
("86213", "Granulosa cell-theca cell tumor, mal.", "", 0),
("86323", "Gynandroblastoma, malignant", "", 0),
("86913", "Aortic body tumor, malignant", "", 0),
("86923", "Carotid body tumor, malignant", "", 0),
("87432", "Superficial spreading melanoma, in situ", "", 0),
("91043", "Malignant placental site trophoblastic tumor", "", 0),
("94213", "Pilocytic astrocytoma", "", 0),
("95973", "Primary Cutaneous follicle centre lymphoma", "", 0),
("96883", "T-cell histiocyte rich large B-cell lymphoma", "", 0),
("97123", "Intravascular large B-cell lymphoma", "", 0),
("97243", "SystemicEBV pos. T-cell lymphoproliferative disease of childhood", "", 0),
("97253", "Hydroa vacciniforme-like lymphoma", "", 0),
("97263", "Primary Cutaneous gamma-delta T-cell lymphoma", "", 0),
("97353", "Plasmablastic lymphoma", "", 0),
("97373", "ALK positive large B-cell lymphoma", "", 0),
("97383", "Lrg B-cell lymphoma in HHV8-assoc. multicentric Castleman DZ", "", 0),
("97513", "Langerhans cell histiocytosis, NOS", "", 0),
("97593", "Fibroblastic reticular cell tumor", "", 0),
("98063", "Mixed phenotype acute leukemia with t(9;22)(q34;q11.2);BCR-ABL1", "", 0),
("98073", "Mixed phenotype acute leukemia with t(v;11q23);MLL rearranged", "", 0),
("98083", "Mixed phenotype acute leukemia, B/myeloid, NOS", "", 0),
("98093", "Mixed phenotype acute leukemia, T/myeloid, NOS", "", 0),
("98113", "B lymphoblastic leukemia/lymphoma, NOS", "", 0),
("98123", "Leukemia/lymphoma with t(9;22)(q34;q11.2);BCR-ABL1", "", 0),
("98133", "Leukemia/lymphoma with t(v;11q23);MLL rearranged", "", 0),
("98143", "Leukemia/lymphoma with t(12;21)(p13;q22);TEL-AML1(ETV6-RUNX1)", "", 0),
("98153", "B lymphoblastic leukemia/lymphoma with hyperdiploidy", "", 0),
("98163", "Leukemia/lymphoma with hypodiploidy (hypodiploid ALL)", "", 0),
("98173", "B lymphblastic leukemia/lymphoma with t(5;14)(q31;q32);IL3-IGH", "", 0),
("98183", "Leukemia/lymphoma with t(1;19)(q23;p13.3); E2A PBX1 (TCF3 PBX1)", "", 0),
("98283", "Acute lymphoblastic leukemia, L2 type, NOS", "", 0),
("98313", "T-cell large granular lymphocytic leukemia", "", 0),
("98653", "Acute myeloid leukemia with t(6;9)(p23;q34) DEK-NUP214", "", 0),
("98693", "Acute myeloid leukemia with inv(3)(q21q26.2) or t(3;3)(q21;q26.2);RPN1EVI1", "", 0),
("98983", "Myeloid leukemia associated with Down Syndrome", "", 0),
("99113", "Acute myeloid leukemia (megakaryoblastic) with t(1;22)(p13;q13);RBM15-MLK1", "", 0),
("99653", "Myeloid and lymphoid neoplasms with PDGFRB rearrangement", "", 0),
("99663", "Myeloid and lymphoid neoplasms with PDGFRB re arrangement", "", 0),
("99673", "Myeloid and lymphoid neoplasm with FGFR1 abnormalities", "", 0),
("99713", "Polymorphic PTLD", "", 0),
("99753", "Myelodysplastic/Myeloproliferative neoplasm, unclassifiable", "", 0),
("99913", "Refractory neutropenia", "", 0),
("99923", "Refractory thrombocytopenia", "", 0);

UPDATE coding_icd_o_3_morphology SET source='SEER', fr_description=en_description WHERE source='';

UPDATE aliquot_masters am, (SELECT COUNT(*) AS real_use_counter, aliquot_master_id FROM view_aliquot_uses GROUP BY aliquot_master_id) uses
SET am.use_counter = uses.real_use_counter
WHERE uses.aliquot_master_id = am.id AND am.deleted != 1 AND (am.use_counter != uses.real_use_counter OR am.use_counter IS NULL OR am.use_counter LIKE '');
