UPDATE structure_fields SET  `flag_confidential`='1' WHERE model='Participant' AND tablename='participants' AND field='date_of_birth' AND `type`='date' AND structure_value_domain  IS NULL ;

UPDATE `versions` SET branch_build_number = '5226' WHERE version_number = '2.5.4';
