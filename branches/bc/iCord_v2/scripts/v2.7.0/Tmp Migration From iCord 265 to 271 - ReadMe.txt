-- -----------------------------------------------------------------------------------------------------------------------------------
-- iCord ATiM Migration From  ATiM v2.6.5 (revs 6230/7559) to ATiM v2.7.1 (revs 7393/to define)                                                                                                     --
-- -----------------------------------------------------------------------------------------------------------------------------------
--                                                                                                                                --
-- Notes: Temporary ReadMe file to delete after the migration.                                            --
-- -----------------------------------------------------------------------------------------------------------------------------------

mysql -u {user} -p{password} {database} --default-character-set=utf8 < ./v2.6.0/atim_v2.6.6_upgrade.sql
mysql -u {user} -p{password} {database} --default-character-set=utf8 < ./v2.6.0/atim_v2.6.7_upgrade.sql
mysql -u {user} -p{password} {database} --default-character-set=utf8 < ./v2.6.0/atim_v2.6.8_upgrade.sql

mysql -u {user} -p{password} {database} --default-character-set=utf8 < ./v2.7.0/atim_v2.7.0_upgrade.sql
mysql -u {user} -p{password} {database} --default-character-set=utf8 < ./v2.7.0/atim_v2.7.1_upgrade.sql
mysql -u {user} -p{password} {database} --default-character-set=utf8 < ./v2.7.0/custom_post_271.sql



Create user 'System' for any migration or update by script. Will help to set variable modified for any updated data.
### 8 # Option to copy user logs data to a server file
Order Line?

Reverifier comment le SCI Participant Code est généré? Ai-je supprimer du custom code? Le patient est il créé par un autre system? À valider

Il ya a des repertoires a la racine? Pouvons nous les supprimer
conf
db
hooks
locks

Pourquoi dans consent on a des donnees cliniques?

Il manque des champs en bc ex: Animal Data - General field compresion
Biobank Consent.no data for [ConsentDetail.postmortum_interval]


--   ### 19 # Added new password management features
--   -----------------------------------------------

   ### 6 # Upload file feature
   -----------------------------------------------------------
   
      ### 7 # Charts feature to complete reports
   -----------------------------------------------------------
   
      ### 8 # Option to copy user logs data to a server file
   -----------------------------------------------------------
   
   ### 9 # LDAP
   -----------------------------------------------------------






