ALTER TABLE coding_icd9_v2 ENGINE = MyISAM;
ALTER TABLE coding_icd9_v2
 ADD PRIMARY KEY (id),
 ADD FULLTEXT `en_title` (`en_title`),
 ADD FULLTEXT `fr_title` (`fr_title`),
 ADD FULLTEXT `en_sub_title` (`en_sub_title`),
 ADD FULLTEXT `fr_sub_title` (`fr_sub_title`),
 ADD FULLTEXT `en_description` (`en_description`),
 ADD FULLTEXT `fr_description` (`fr_description`);