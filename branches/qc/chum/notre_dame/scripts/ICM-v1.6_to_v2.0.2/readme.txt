#######################################################################
#                                                                     #
#                    ATiM ICM Data Instruction                        #
#                                                                     #
#######################################################################

-- Check data executing queries of 0-CheckScriptsBeforeUpgrade.sql

-- Execute following line on server

iconv -f utf8 -t iso8859-1 1-AddNewTablesToExistingDb_v2.0.1.sql -o 1-conv.sql
iconv -f utf8 -t iso8859-1 2-AlterTablesOfExistingDb_v2.0.1.sql -o 2-conv.sql
iconv -f utf8 -t iso8859-1 3-LoadAllTrunkApplicationData_v2.0.1.sql -o 3-conv.sql
iconv -f utf8 -t iso8859-1 4-atim_v2.0.2_upgrade.sql -o 4-conv.sql
iconv -f utf8 -t iso8859-1 5-atim_v2.0.2A_upgrade.sql -o 5-conv.sql
iconv -f utf8 -t iso8859-1 6-LoadCustomApplicationData_v2.0.2A.sql -o 6-conv.sql

mysqldump -u root -p ATiM > ATiM_utf8.sql
iconv -c -f utf8 -t iso8859-1 ATiM_utf8.sql -o ATiM_iso8859-1.sql

-- Execute following line on mysql

source ATiM_iso8859-1.sql
source 1-conv.sql
source ...

#######################################################################
#                                                                     #
#                       ATiM ICM Data Issues                           #
#                                                                     #
#######################################################################

-- ce qui marche pas
mysqldump -u root -p ATiM aliquot_masters --where="id = '3955'"> ATiM_aliquot_utf8.sql
iconv -f utf8 -t iso8859-1 ATiM_aliquot_utf8.sql -o ATiM_aliquot_iso8859-1.sql
iconv: illegal input sequence at position 3672
-- probleme avec le caracter suivant Ã‰

