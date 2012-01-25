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