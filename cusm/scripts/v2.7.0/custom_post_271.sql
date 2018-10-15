-- -----------------------------------------------------------------------------------------------------------------------------------
-- 
-- -----------------------------------------------------------------------------------------------------------------------------------


Mettre RAMQ et Hospital nbr dans la creation du patient
Affichier no labo dans summary
nom prenom obligatoire
pouvoire modifier bank number

# Label of the aliquots (labelled from 1 to n)
     - Buffy coat :: JS-00-0000 BC
     - Serum :: JS-00-0000 S
     - Plasma :: JS-00-0000 P
     - Tissue in OCT :: JS-00-0000 OCT T/N (all tissues in the initial .xls are in OCT) 
     - Flash Frozen Tissue :: JS-00-0000 FF T/N
     - Tissue in DMSO :: JS-00-0000 CC T/N 
     
Plus generate label into the code 

lab people into colelction

format des boites et racks


-- -------------------------------------------------------------------------------------
-- SOP
-- -------------------------------------------------------------------------------------




TODO:
- Migrer les données du tumor registery. Comes from in CSV file format. Erase all data and rebuild the data. CSV file will be on a share.










UPDATE versions SET branch_build_number = 'xxx' WHERE version_number = '2.7.0';