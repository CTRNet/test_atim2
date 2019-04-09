<?php  
/*
INSERT INTO participants
(created, created_by, modified, modified_by, last_modification, bc_nbi_phn_number)
VALUES
('2019-04-04 11:46:02', '1', '2019-04-04 11:46:02', '1',  '2019-04-04 11:46:02','9358641822'),
('2019-04-04 11:46:02', '1', '2019-04-04 11:46:02', '1',  '2019-04-04 11:46:02','9525505437'),
('2019-04-04 11:46:02', '1', '2019-04-04 11:46:02', '1',  '2019-04-04 11:46:02','9684262337'),
('2019-04-04 11:46:02', '1', '2019-04-04 11:46:02', '1',  '2019-04-04 11:46:02','9970459339'),
('2019-04-04 11:46:02', '1', '2019-04-04 11:46:02', '1',  '2019-04-04 11:46:02','9291988476'),
('2019-04-04 11:46:02', '1', '2019-04-04 11:46:02', '1',  '2019-04-04 11:46:02','9509213673'),
('2019-04-04 11:46:02', '1', '2019-04-04 11:46:02', '1',  '2019-04-04 11:46:02','9250509373'),
('2019-04-04 11:46:02', '1', '2019-04-04 11:46:02', '1',  '2019-04-04 11:46:02','9182724932'),
('2019-04-04 11:46:02', '1', '2019-04-04 11:46:02', '1',  '2019-04-04 11:46:02','9777292502'),
('2019-04-04 11:46:02', '1', '2019-04-04 11:46:02', '1',  '2019-04-04 11:46:02','9712708778'),
('2019-04-04 11:46:02', '1', '2019-04-04 11:46:02', '1',  '2019-04-04 11:46:02','9174052051'),
('2019-04-04 11:46:02', '1', '2019-04-04 11:46:02', '1',  '2019-04-04 11:46:02','9327719261'),
('2019-04-04 11:46:02', '1', '2019-04-04 11:46:02', '1',  '2019-04-04 11:46:02','9159101020'),
('2019-04-04 11:46:02', '1', '2019-04-04 11:46:02', '1',  '2019-04-04 11:46:02','9754472075'),
('2019-04-04 11:46:02', '1', '2019-04-04 11:46:02', '1',  '2019-04-04 11:46:02','9370645995'),
('2019-04-04 11:46:02', '1', '2019-04-04 11:46:02', '1',  '2019-04-04 11:46:02','9986216759'),
('2019-04-04 11:46:02', '1', '2019-04-04 11:46:02', '1',  '2019-04-04 11:46:02','9422879347'),
('2019-04-04 11:46:02', '1', '2019-04-04 11:46:02', '1',  '2019-04-04 11:46:02','9490293186'),
('2019-04-04 11:46:02', '1', '2019-04-04 11:46:02', '1',  '2019-04-04 11:46:02','9603823172'),
('2019-04-04 11:46:02', '1', '2019-04-04 11:46:02', '1',  '2019-04-04 11:46:02','9117038287'),
('2019-04-04 11:46:02', '1', '2019-04-04 11:46:02', '1',  '2019-04-04 11:46:02','9244246128'),
('2019-04-04 11:46:02', '1', '2019-04-04 11:46:02', '1',  '2019-04-04 11:46:02','9185926465'),
('2019-04-04 11:46:02', '1', '2019-04-04 11:46:02', '1',  '2019-04-04 11:46:02','9919365701'),
('2019-04-04 11:46:02', '1', '2019-04-04 11:46:02', '1',  '2019-04-04 11:46:02','9258629237'),
('2019-04-04 11:46:02', '1', '2019-04-04 11:46:02', '1',  '2019-04-04 11:46:02','9840727587'),
('2019-04-04 11:46:02', '1', '2019-04-04 11:46:02', '1',  '2019-04-04 11:46:02','9351784163'),
('2019-04-04 11:46:02', '1', '2019-04-04 11:46:02', '1',  '2019-04-04 11:46:02','9617888471'),
('2019-04-04 11:46:02', '1', '2019-04-04 11:46:02', '1',  '2019-04-04 11:46:02','9106615384'),
('2019-04-04 11:46:02', '1', '2019-04-04 11:46:02', '1',  '2019-04-04 11:46:02','9707087866');

INSERT INTO participants
(created, created_by, modified, modified_by, last_modification, bc_nbi_phn_number)
VALUES
('2019-04-04 11:46:02', '1', '2019-04-04 11:46:02', '1',  '2019-04-04 11:46:02','9434756388');

UPDATE participants SET participant_identifier = id;
UPDATE users SET permissions_regenerated = 0;
 */
 
//-------------------------------------------------------------------------------------------------------------------------
// CONFIG
//-------------------------------------------------------------------------------------------------------------------------

// Database

$db_user    = "root";
$db_pwd     = "";
$db_schema	= "nbi";

$file_path = "C:/__NicolasLuc/Server/www/nbi/scripts/v2.7.0/";
$file_name = 'data_to_migrate_30_participants_ex.csv';

$migrationUserName = 'administrator';
//TODO $migrationUserName = 'BccaTumorRegistry';

//-------------------------------------------------------------------------------------------------------------------------
// DATABASE CONNECTION
//-------------------------------------------------------------------------------------------------------------------------

$db_ip				= "localhost";
$db_port 			= "";
$db_charset			= "utf8";

global $db_connection;
$db_connection = @mysqli_connect(
    $db_ip.(!empty($db_port)? ":".$db_port : ''),
    $db_user,
    $db_pwd
) or die("DB connection: Could not connect to MySQL [".$db_ip.(!empty($db_port)? ":".$db_port : '')." / $db_user]");
if(!mysqli_set_charset($db_connection, $db_charset)){
    importDie("DB connection: Invalid charset", false);
}
@mysqli_select_db($db_connection, $db_schema) or migrationDie("DB connection: DB selection failed [$db_schema]. Error Line #".__LINE__.".");
mysqli_autocommit ($db_connection , false);

global $created;
$query = "SELECT NOW() as creation_date FROM aros LIMIT 0,1;";
$res =  getSelectQueryResult($query);
$created = $res[0]['creation_date'];
if(empty($created)) migrationDie("ERR#".__LINE__.".");

global $created_by;
$query = "SELECT id FROM users WHERE username = '$migrationUserName';";
$res =  getSelectQueryResult($query);
$created_by = $res[0]['id'];
if(empty($created_by)) migrationDie("ERR#".__LINE__.".");

//-------------------------------------------------------------------------------------------------------------------------
// MAIN CODE
//-------------------------------------------------------------------------------------------------------------------------

// Main info display
//-------------------------------------------------------------------------------------------------------------------------

$is_test = false;
if(isset($argv[1])) {
    if($argv[1] == 'test') {
        $is_test = true;
    } else {
        migrationDie('ERR ARG : '.$argv[1].' (should be test or nothing). ERR#'.__LINE__.".");
    }
}

pr('--------------------------------------------------------------------------------------------------------------');
pr('--');
pr('-- ATIM NBI: BCCA Tumor Registry Data Migration');
pr('--');
pr("-- Date : $created");
pr("-- File : $file_name");
if($is_test) pr("-- Warning : Test, no commit!");
pr('--');
pr('--------------------------------------------------------------------------------------------------------------');

// Get controls data
//-------------------------------------------------------------------------------------------------------------------------

global $atim_controls;
$atim_controls = getControlsData();
pr($atim_controls);

if(true) {
    $queries = array(
        "TRUNCATE ".$atim_controls['diagnosis_controls']['primary-bcca tumor registry']['detail_tablename'],
        "UPDATE diagnosis_masters SET parent_id = NULL",
        "DELETE FROM diagnosis_masters",
    );
    foreach($queries as $new_query) customQuery($new_query);      
}

// Read file
//-------------------------------------------------------------------------------------------------------------------------

global $modified_database_tables_list;
$modified_database_tables_list = array();

global $domains_values;
$domains_values = array();

global $atim_icd_codes_validations;
$atim_icd_codes_validations= array();

$handle = fopen($file_path.$file_name, 'r');
if(!$handle) migrationDie("ERR#".__LINE__.".");

//$import_summary = array();

$header = array();
$personal_health_num_check = array();
$line_counter = 0;
while (($row = fgetcsv($handle, 1000000, ';')) !== FALSE)
{
    foreach($row as &$new_cell_value) $new_cell_value = utf8_encode($new_cell_value);
    
    $line_counter++;
    if(!$header) {
        $header = $row;
    } else {
        if(sizeof($row) != sizeof($header)) migrationDie("ERR#".__LINE__.".");
        
        pr("\n== LINE $line_counter =============================\n");
        
        // Get PHN#
                
        $csv_data = array_combine($header, $row);
        foreach($csv_data as &$csv_value) {
            $csv_value = trim($csv_value);
        }
        $personal_health_num = $csv_data['personal_health_num'];
        if(!$personal_health_num) {
            pr("ERR#".__LINE__.". Details : PHN# not defined into csv line #$line_counter. No data of the line will be migrated.");
            continue;
        } else if(isset($personal_health_num_check[$personal_health_num])) {
            pr("ERR#".__LINE__.". Details : PHN# $personal_health_num. No data of the line will be migrated.");
            continue;
        }
        
        // Participant profile
        //-------------------------------------------------------------------------------------------------------------------------
                
        // Get ATiM participant data
        
        $query = "SELECT * FROM participants WHERE bc_nbi_phn_number = '$personal_health_num' AND deleted <> 1;";
        $atim_participant_data = getSelectQueryResult($query);
        if(!$atim_participant_data) {
            pr("\nERR#".__LINE__.". Details : Participant PHN# $personal_health_num does not exist into ATiM. Line won't be migrated. See file line #$line_counter.");
            continue;
        } elseif(sizeof($atim_participant_data)!= 1) {
            pr("\nERR#".__LINE__.". Details : PHN# $personal_health_num.");
            continue;
        }
        $atim_participant_data = $atim_participant_data[0];
        $participant_id = $atim_participant_data['id'];
        
        // Get CSV participant data
        
        $csv_participant_data = array();
        $participant_fields_to_fields_properties = array(
            array('sex', 'sex', 'select', 'sex', array(''), array('')),
            array('date_of_birth', 'birth_date', 'date', null, null, null),
            array('first_name', 'fst_name', 'input', null, null, null),
            array('middle_name', 'snd_name', 'input', null, null, null),
            array('last_name', 'surname', 'input', null, null, null),
            array('bc_nbi_bc_cancer_agency_id', 'agency_id', 'input', null, null, null),
            array('date_of_death', 'death_date', 'date', null, null, null),
            array('bc_nbi_last_attended_appt', 'last_attended_appt', 'date', null, null, null),
            array('bc_nbi_last_contact_date', 'last_contact_date', 'date', null, null, null),
            array('bc_nbi_statmar18', 'statmar18', 'input', null, null, null),
            array('bc_nbi_bcca_cod_icd89', 'bcca_cod', 'input', null, null, null),
            array('bc_nbi_bcca_cod_icd89_desc', 'bcca_cod_desc', 'input', null, null, null),
            array('bc_nbi_death_cause_original_icd_89', 'death_cause_original', 'input', null, null, null),
            array('bc_nbi_death_cause_original_icd_89_desc', 'death_cause_orig_desc', 'input', null, null, null),
            array('bc_nbi_death_sec_cause_89', 'death_sec_cause', 'input', null, null, null),
            array('bc_nbi_death_sec_cause_89_desc', 'death_sec_cause_desc', 'input', null, null, null),
            array('cod_icd10_code', 'bcca_cod', 'icd10_who', null, null, null),
            array('secondary_cod_icd10_code', 'death_sec_cause', 'icd10_who', null, null, null),
            array('bc_nbi_death_cause_original_icd_10', 'death_cause_original', 'icd10_who', null, null, null)
        );
        $accuracy_to_add = array();
        foreach($participant_fields_to_fields_properties as $new_field_properties) {
            list($atim_field, $csv_field, $field_type, $structure_value_domain_name, $str_replace1, $str_replace2) = $new_field_properties; 
            switch($field_type) {
                case 'input':
                    $csv_participant_data[$atim_field] = $csv_data[$csv_field];
                    break;
                case 'date':
                    $csv_participant_data[$atim_field] = validateAndGetDate($csv_data[$csv_field], $csv_field, $line_counter);
                    if($csv_participant_data[$atim_field] && array_key_exists($atim_field."_accuracy", $atim_participant_data)) {
                        $accuracy_to_add[$atim_field."_accuracy"] = 'c';
                    }
                    break;
                case 'select':
                    $csv_participant_data[$atim_field] = validateAndGetStructureDomainValue(str_replace($str_replace1, $str_replace2, $csv_data[$csv_field]), $structure_value_domain_name, $csv_field, $line_counter);
                    break;
                case 'icd10_who':    
                    $csv_participant_data[$atim_field] = $csv_data[$csv_field];
                    validateIcdCodeExists($csv_data[$csv_field], $field_type, $csv_field, $line_counter);
                    break;
                default:
                    pr("ERR#".__LINE__.". Details : Type of ATiM field unknown $field_type.");
            }
        }
        // Vital Status
        // brdeath {1 = death from breast ca}, {2 = death from other than br ca}, {3 = alive}, {9 = unknown cause of death}
        // pat_status {A = alive}, {D = deceased}
        $atim_field = 'vital_status';
        $csv_brdeath = $csv_data['brdeath'];
        $csv_pat_status = $csv_data['pat_status'];
        if(!in_array($csv_brdeath, array('1', '2', '3', '9', ''))) {
            pr("Wrong excel value '$csv_brdeath' for field 'brdeath'. Value is not part of the ATiM list 'vital_status (health_status)'. Value won't be migrated or used for the migration. See line $line_counter.");
            $csv_brdeath = '';
        }
        if(!in_array($csv_pat_status, array('A', 'D', ''))) {
            pr("Wrong excel value '$csv_pat_status' for field 'pat_status'. Value is not part of the ATiM list 'vital_status (health_status)'. Value won't be migrated or used for the migration. See line $line_counter.");
            $csv_pat_status = '';
        }
        if(!strlen($csv_brdeath.$csv_pat_status)) {
            $csv_participant_data[$atim_field] = 'unknown';
        } elseif(!$csv_brdeath) {
            $csv_participant_data[$atim_field] = ($csv_pat_status == 'A')? 'alive' : 'deceased';
        } elseif(!$csv_pat_status) {
            $csv_participant_data[$atim_field] = str_replace(
                array('1', '2', '3', '9'),
                array('death from breast cancer', 'death from other than breast cancer', 'alive', 'deceased'),
                $csv_brdeath);
        } else {
            $status_error = true;
            if($csv_pat_status == 'A') {
                if($csv_brdeath == '3') {
                    $status_error = false;
                }
            } else {
                if($csv_brdeath != '3') {
                    $status_error = false;
                    $csv_participant_data[$atim_field] = str_replace(
                        array('1', '2', '3', '9'),
                        array('death from breast cancer', 'death from other than breast cancer', 'alive', 'deceased'),
                        $csv_brdeath);
                } 
            }
            if($status_error) {
                pr("Excel values for field 'pat_status' ($csv_pat_status) and 'brdeath' ($csv_brdeath) make no sens. Value won't be migrated or used for the migration. See line $line_counter.");
            }
        }
        
        // Manage participant profile data update
        $participant_data_to_update = array();
        foreach($csv_participant_data as $atim_field => $csv_value) {
            if(!strlen($atim_participant_data[$atim_field])) {
                $participant_data_to_update[$atim_field] =  $csv_value;
            } else if(!strlen($atim_participant_data[$atim_field]) != $csv_value) {
                pr("ATiM value '".$atim_participant_data[$atim_field]."' for field '$atim_field' is different than the XLS value '$csv_value'. Value won't be updated. See line $line_counter.");
            }
        }
        $participant_data_to_update['bc_nbi_retrospective_bank'] = 'y';
        $participant_data_to_update = array_merge($participant_data_to_update, $accuracy_to_add);
        
        updateTableData($participant_id, array('participants' => $participant_data_to_update));
        	
        // Diagnosis
        //-------------------------------------------------------------------------------------------------------------------------
        
        $csv_diagnosis_data = array();
        $diagnosis_fields_to_fields_properties = array(
            'DiagnosisMaster' => array(
                array('dx_date', 'diagnosis_date', 'date', null, null, null),
                array('tumour_grade', 'grade', 'select', 'bc_nbi_bcca_tumour_grade', array(''), array('')),
                array('topography', 'site', 'icd_o_3_topography', null, null, null)
            ),
            'DiagnosisDetail' => array(  
                array('bc_nbi_bcca_behavior_desc', 'behaviour_desc', 'input', null, null, null),
                array('bc_nbi_bcca_br_ant_tiss_onco_desc', 'br_ant_tiss_onco_desc', 'input', null, null, null),
                array('bc_nbi_bcca_br_clipmarkingbxcavity_onco_desc', 'br_clipmarkingbxcavity_onco_desc', 'input', null, null, null),
                array('bc_nbi_bcca_br_closeposmargintype_onco_desc', 'br_closeposmargintype_onco_desc', 'input', null, null, null),
                array('bc_nbi_bcca_br_grade_type_p00005_desc', 'br_grade_type_p00005_desc', 'input', null, null, null),
                array('bc_nbi_bcca_br_her2neulabatrecur_onco_desc', 'br_her2neulabatrecur_onco_desc', 'input', null, null, null),
                array('bc_nbi_bcca_br_immunotherapy_p00005_desc', 'br_immunotherapy_p00005_desc', 'input', null, null, null),
                array('bc_nbi_bcca_br_initl_chemoreg_onco_desc', 'br_initl_chemoreg_onco_desc', 'input', null, null, null),
                array('bc_nbi_bcca_br_initl_chemotype_p00005_desc', 'br_initl_chemo_type_p00005_desc', 'input', null, null, null),
                array('bc_nbi_bcca_br_initl_horm_type_p00005_desc', 'br_initl_horm_type_p00005_desc', 'input', null, null, null),
                array('bc_nbi_bcca_br_initl_hormreg_onco_desc', 'br_initl_hormreg_onco_desc', 'input', null, null, null),
                array('bc_nbi_bcca_br_initl_targtherapy_onco_desc', 'br_initl_targtherapy_onco_desc', 'input', null, null, null),
                array('bc_nbi_bcca_br_multicentbrstca_onco_desc', 'br_multicentbrstca_onco_desc', 'input', null, null, null),
                array('bc_nbi_bcca_br_multifocbrstca_onco_desc', 'br_multifocbrstca_onco_desc', 'input', null, null, null),
                array('bc_nbi_bcca_br_overlap_lesion_onco_desc', 'br_overlap_lesion_onco_desc', 'input', null, null, null),
                array('bc_nbi_bcca_br_postr_deepmarg_onco_desc', 'br_postr_deepmarg_onco_desc', 'input', null, null, null),
                array('bc_nbi_bcca_br_radiologicconfirmFWL_onco_desc', 'br_radiologicconfirmFWL_onco_desc', 'input', null, null, null),
                array('bc_nbi_bcca_br_surgspecimenoriented_onco_desc', 'br_surgspecimenoriented_onco_desc', 'input', null, null, null),
                array('bc_nbi_bcca_cN', 'cN', 'input', null, null, null),
                array('bc_nbi_bcca_COL_AJCC_Edition', 'COL_AJCC_Edition', 'input', null, null, null),
                array('bc_nbi_bcca_cT', 'cT', 'input', null, null, null),
                array('bc_nbi_bcca_diag_type_desc', 'diag_type_desc', 'input', null, null, null),
                array('bc_nbi_bcca_dx_hlth_auth_desc', 'dx_hlth_auth_desc', 'input', null, null, null),
                array('bc_nbi_bcca_dx_hsda_desc', 'dx_hsda_desc', 'input', null, null, null),
                array('bc_nbi_bcca_dx_lha_desc', 'dx_lha_desc', 'input', null, null, null),
                array('bc_nbi_bcca_dx_post_code', 'dx_post_code', 'input', null, null, null),
                array('bc_nbi_bcca_grade_desc', 'grade_desc', 'input', null, null, null),
                array('bc_nbi_bcca_hist1_desc', 'hist1_desc', 'input', null, null, null),
                array('bc_nbi_bcca_hist2_desc', 'hist2_desc', 'input', null, null, null),
                array('bc_nbi_bcca_hist3_desc', 'hist3_desc', 'input', null, null, null),
                array('bc_nbi_bcca_laterality_desc', 'laterality_desc', 'input', null, null, null),
                array('bc_nbi_bcca_loc_at_admit_desc', 'loc_at_admit_desc', 'input', null, null, null),
                array('bc_nbi_bcca_loc_at_diag_desc', 'loc_at_diag_desc', 'input', null, null, null),
                array('bc_nbi_bcca_M1sitedx_desc', 'M1sitedx_desc', 'input', null, null, null),
                array('bc_nbi_bcca_not_treated_desc', 'not_treated_desc', 'input', null, null, null),
                array('bc_nbi_bcca_performance_status_desc', 'performance_status_desc', 'input', null, null, null),
                array('bc_nbi_bcca_pN', 'pN', 'input', null, null, null),
                array('bc_nbi_bcca_pT', 'pT', 'input', null, null, null),
                array('bc_nbi_bcca_reg_site_desc', 'regsite_desc', 'input', null, null, null),
                array('bc_nbi_bcca_site_desc', 'site_desc', 'input', null, null, null),
                array('bc_nbi_bcca_status_at_referral_desc', 'status_at_referral_desc', 'input', null, null, null),
                array('bc_nbi_bcca_tnm_clin_m', 'tnm_clin_m', 'input', null, null, null),
                array('bc_nbi_bcca_tnm_clin_m_desc', 'tnm_clin_m_desc', 'input', null, null, null),
                array('bc_nbi_bcca_tnm_clin_n', 'tnm_clin_n', 'input', null, null, null),
                array('bc_nbi_bcca_tnm_clin_n_desc', 'tnm_clin_n_desc', 'input', null, null, null),
                array('bc_nbi_bcca_tnm_clin_t_desc', 'tnm_clin_t_desc', 'input', null, null, null),
                array('bc_nbi_bcca_tnm_surg_m_desc', 'tnm_surg_m_desc', 'input', null, null, null),
                array('bc_nbi_bcca_tnm_surg_n_desc', 'tnm_surg_n_desc', 'input', null, null, null),
                array('bc_nbi_bcca_tnm_surg_t_desc', 'tnm_surg_t_desc', 'input', null, null, null),
                
                array('bc_nbi_bcca_overall_clin_stg', 'overall_clin_stg', 'integer', null, null, null),
                array('bc_nbi_bcca_overall_path_stg', 'overall_path_stg', 'integer', null, null, null),
                array('bc_nbi_bcca_overall_stg', 'overall_stg', 'integer', null, null, null),
                array('bc_nbi_bcca_site_num', 'site_num', 'integer', null, null, null),
                array('bc_nbi_bcca_totsentnodes', 'totsentnodes', 'integer', null, null, null),
                
                array('bc_nbi_bcca_dist_site_desc', 'distsite_desc', 'textarea', null, null, null),
                array('bc_nbi_bcca_loc_site_desc', 'locsite_desc', 'textarea', null, null, null),
                
                array('bc_nbi_bcca_br_sentinel_lymph_node_bx_date_p00005', 'br_sentinel_ln_bx_date_p00005', 'date', null, null, null),
                array('bc_nbi_bcca_dist_date', 'DISTDATE', 'date', null, null, null),
                array('bc_nbi_bcca_fst_relapse_date', 'fst_relapse_date', 'date', null, null, null),
                array('bc_nbi_bcca_fst_treat_date', 'fst_treat_date', 'date', null, null, null),
                array('bc_nbi_bcca_her2_date', 'br_her2_date_p00005', 'date', null, null, null),
                array('bc_nbi_bcca_loc_date', 'LOCDATE', 'date', null, null, null),
                array('bc_nbi_bcca_locoreg_relapse_date', 'locoreg_relapse_date', 'date', null, null, null),
                array('bc_nbi_bcca_M1DXDATE', 'M1DXDATE', 'date', null, null, null),
                array('bc_nbi_bcca_reg_date', 'REGDATE', 'date', null, null, null),
                array('bc_nbi_bcca_site_admit_date', 'site_admit_date', 'date', null, null, null),
                
                array('bc_nbi_bcca_dist_ind', 'DISTIND', 'checkbox', null, null, null),
                array('bc_nbi_bcca_loc_ind', 'LOCIND', 'checkbox', null, null, null),
                array('bc_nbi_bcca_neoadjuvant', 'neoadjuvant', 'checkbox', null, null, null),
                array('bc_nbi_bcca_reg_ind', 'REGIND', 'checkbox', null, null, null),
                
                array('bc_nbi_bcca_behavior', 'behavior', 'select', 'bc_nbi_bcca_tumour_behavior', array(''), array('')),
                array('bc_nbi_bcca_br_ant_tiss_onco', 'br_ant_tiss_onco', 'select', 'bc_nbi_bcca_br_ant_tiss_onco', array(''), array('')),
                array('bc_nbi_bcca_br_clipmarkingbxcavity_onco', 'br_clipmarkingbxcavity_onco', 'select', 'bc_nbi_bcca_br_clipmarkingbxcavity_onco', array(''), array('')),
                array('bc_nbi_bcca_br_closeposmargintype_onco', 'br_closeposmargintype_onco', 'select', 'bc_nbi_bcca_br_closeposmargintype_onco', array(''), array('')),
                array('bc_nbi_bcca_br_grade_type_p00005', 'br_grade_type_p00005', 'select', 'bc_nbi_bcca_br_grade_type', array(''), array('')),
                array('bc_nbi_bcca_br_her2neulabatrecur_onco', 'br_her2neulabatrecur_onco', 'select', 'bc_nbi_bcca_br_her2neulabatrecur_onco', array(''), array('')),
                array('bc_nbi_bcca_br_immunotherapy_p00005', 'br_immunotherapy_p00005', 'select', 'bc_nbi_bcca_br_immunotherapy_p00005', array(''), array('')),
                array('bc_nbi_bcca_br_initl_chemoreg', 'br_initl_chemoreg', 'select', 'bc_nbi_bcca_br_initl_chemoreg', array(''), array('')),
                array('bc_nbi_bcca_br_initl_chemoreg_onco', 'br_initl_chemoreg_onco', 'select', 'bc_nbi_bcca_br_initl_chemoreg', array(''), array('')),
                array('bc_nbi_bcca_br_initl_chemotype_p00005', 'br_initl_chemo_type_p00005', 'select', 'bc_nbi_bcca_br_initl_chemo_type_p00005', array(''), array('')),
                array('bc_nbi_bcca_br_initl_horm_type_p00005', 'br_initl_horm_type_p00005', 'select', 'bc_nbi_bcca_br_initl_horm_type_p00005', array(''), array('')),
                array('bc_nbi_bcca_br_initl_hormreg', 'br_initl_hormreg', 'select', 'bc_nbi_bcca_br_initl_hormreg', array(''), array('')),
                array('bc_nbi_bcca_br_initl_hormreg_onco', 'br_initl_hormreg_onco', 'select', 'bc_nbi_bcca_br_initl_hormreg', array(''), array('')),
                array('bc_nbi_bcca_br_initl_targtherapy_onco', 'br_initl_targtherapy_onco', 'select', 'bc_nbi_bcca_br_initl_targthx', array(''), array('')),
                array('bc_nbi_bcca_br_initl_targthx', 'br_initl_targthx', 'select', 'bc_nbi_bcca_br_initl_targthx', array(''), array('')),
                array('bc_nbi_bcca_br_multicentbrstca_onco', 'br_multicentbrstca_onco', 'select', 'bc_nbi_bcca_br_multicentbrstca_onco', array(''), array('')),
                array('bc_nbi_bcca_br_multifocbrstca_onco', 'br_multifocbrstca_onco', 'select', 'bc_nbi_bcca_br_multifocbrstca_onco', array(''), array('')),
                array('bc_nbi_bcca_br_overlap_lesion_onco', 'br_overlap_lesion_onco', 'select', 'bc_nbi_bcca_br_overlap_lesion_onco', array(''), array('')),
                array('bc_nbi_bcca_br_postr_deepmarg_onco', 'br_postr_deepmarg_onco', 'select', 'bc_nbi_bcca_br_postr_deepmarg_onco', array(''), array('')),
                array('bc_nbi_bcca_br_radiologicconfirmFWL_onco', 'br_radiologicconfirmFWL_onco', 'select', 'bc_nbi_bcca_br_radiologicconfirmFWL_onco', array(''), array('')),
                array('bc_nbi_bcca_br_surgspecimenoriented_onco', 'br_surgspecimenoriented_onco', 'select', 'bc_nbi_bcca_br_surgspecimenoriented_onco', array(''), array('')),
                array('bc_nbi_bcca_COL_AJCC_M_clin', 'COL_AJCC_M_clin', 'select', 'bc_nbi_bcca_COL_AJCC_M_clin', array(''), array('')),
                array('bc_nbi_bcca_COL_AJCC_M_path', 'COL_AJCC_M_path', 'select', 'bc_nbi_bcca_COL_AJCC_M_path', array(''), array('')),
                array('bc_nbi_bcca_COL_AJCC_N_clin', 'COL_AJCC_N_clin', 'select', 'bc_nbi_bcca_COL_AJCC_N_clin', array(''), array('')),
                array('bc_nbi_bcca_COL_AJCC_N_path', 'COL_AJCC_N_path', 'select', 'bc_nbi_bcca_COL_AJCC_N_path', array(''), array('')),
                array('bc_nbi_bcca_COL_AJCC_T_clin', 'COL_AJCC_T_clin', 'select', 'bc_nbi_bcca_COL_AJCC_T_clin', array(''), array('')),
                array('bc_nbi_bcca_COL_AJCC_T_path', 'COL_AJCC_T_path', 'select', 'bc_nbi_bcca_COL_AJCC_T_path', array(''), array('')),
                array('bc_nbi_bcca_COL_nodes', 'COL_nodes', 'select', 'bc_nbi_bcca_COL_nodes', array(''), array('')),
                array('bc_nbi_bcca_COL_nodes_eval', 'COL_nodes_eval', 'select', 'bc_nbi_bcca_COL_nodes_eval', array(''), array('')),
                array('bc_nbi_bcca_col_ssf10', 'col_ssf10', 'select', 'bc_nbi_bcca_col_ssf10', array(''), array('')),
                array('bc_nbi_bcca_col_ssf11', 'col_ssf11', 'select', 'bc_nbi_bcca_col_ssf11', array(''), array('')),
                array('bc_nbi_bcca_col_ssf12', 'col_ssf12', 'select', 'bc_nbi_bcca_col_ssf12', array(''), array('')),
                array('bc_nbi_bcca_col_ssf13', 'col_ssf13', 'select', 'bc_nbi_bcca_col_ssf13', array(''), array('')),
                array('bc_nbi_bcca_col_ssf14', 'col_ssf14', 'select', 'bc_nbi_bcca_col_ssf14', array(''), array('')),
                array('bc_nbi_bcca_col_ssf16', 'col_ssf16', 'select', 'bc_nbi_bcca_col_ssf16', array(''), array('')),
                array('bc_nbi_bcca_col_ssf19', 'col_ssf19', 'select', 'bc_nbi_bcca_col_ssf19', array(''), array('')),
                array('bc_nbi_bcca_col_ssf22', 'col_ssf22', 'select', 'bc_nbi_bcca_col_ssf22', array(''), array('')),
                array('bc_nbi_bcca_col_ssf23', 'col_ssf23', 'select', 'bc_nbi_bcca_col_ssf23', array(''), array('')),
                array('bc_nbi_bcca_col_ssf3', 'col_ssf3', 'select', 'bc_nbi_bcca_col_ssf3', array(''), array('')),
                array('bc_nbi_bcca_col_ssf4', 'col_ssf4', 'select', 'bc_nbi_bcca_col_ssf4', array(''), array('')),
                array('bc_nbi_bcca_col_ssf5', 'col_ssf5', 'select', 'bc_nbi_bcca_col_ssf5', array(''), array('')),
                array('bc_nbi_bcca_col_ssf6', 'col_ssf6', 'select', 'bc_nbi_bcca_col_ssf6', array(''), array('')),
                array('bc_nbi_bcca_col_ssf7', 'col_ssf7', 'select', 'bc_nbi_bcca_col_ssf7', array(''), array('')),
                array('bc_nbi_bcca_col_ssf8', 'col_ssf8', 'select', 'bc_nbi_bcca_col_ssf8', array(''), array('')),
                array('bc_nbi_bcca_col_ssf9', 'col_ssf9', 'select', 'bc_nbi_bcca_col_ssf9', array(''), array('')),
                array('bc_nbi_bcca_dataset', 'dataset', 'select', 'bc_nbi_bcca_dataset', array(''), array('')),
                array('bc_nbi_bcca_diag_type', 'diag_type', 'select', 'bc_nbi_bcca_diag_type', array(''), array('')),
                array('bc_nbi_bcca_dx_hlth_auth', 'dx_hlth_auth', 'select', 'bc_nbi_bcca_hlth_auth', array(''), array('')),
                array('bc_nbi_bcca_dx_hsda', 'dx_hsda', 'select', 'bc_nbi_bcca_hsda', array(''), array('')),
                array('bc_nbi_bcca_dx_hsda_cc', 'dx_hsda_cc', 'select', 'bc_nbi_bcca_cancer_center', array(''), array('')),
                array('bc_nbi_bcca_dx_lha_cc', 'dx_lha_cc', 'select', 'bc_nbi_bcca_cancer_center', array(''), array('')),
                array('bc_nbi_bcca_dx_local_health_area', 'dx_local_health_area', 'select', 'bc_nbi_bcca_local_health_area', array(''), array('')),
                array('bc_nbi_bcca_ECE_final', 'ECE_final', 'select', 'bc_nbi_bcca_ECE_final', array(''), array('')),
                array('bc_nbi_bcca_er', 'er', 'select', 'bc_nbi_bcca_er_status', array(''), array('')),
                array('bc_nbi_bcca_erposneg', 'erposneg', 'select', 'bc_nbi_bcca_neg_pos_unknown', array(''), array('')),
                array('bc_nbi_bcca_final_margins', 'final_margins', 'select', 'bc_nbi_bcca_neg_pos_close_unknown', array(''), array('')),
                array('bc_nbi_bcca_her2_final', 'her2_final', 'select', 'bc_nbi_bcca_neg_pos_unknown', array(''), array('')),
                array('bc_nbi_bcca_her2lab_initdx', 'her2lab_initdx', 'select', 'bc_nbi_bcca_her2neulab_initdx', array(''), array('')),
                array('bc_nbi_bcca_her2tissuesite', 'her2tissuesite', 'select', 'bc_nbi_bcca_her2_tissuesite', array(''), array('')),
                array('bc_nbi_bcca_init_chemo', 'init_chemo', 'select', 'bc_nbi_bcca_init_chemo', array(''), array('')),
                array('bc_nbi_bcca_init_horm', 'init_horm', 'select', 'bc_nbi_bcca_init_horm', array(''), array('')),
                array('bc_nbi_bcca_init_targ_therapy', 'init_targ_therapy', 'select', 'bc_nbi_bcca_br_initl_targthx_yn', array(''), array('')),
                array('bc_nbi_bcca_laterality', 'laterality', 'select', 'bc_nbi_bcca_laterality', array(''), array('')),
                array('bc_nbi_bcca_loc_at_admit', 'loc_at_admit', 'select', 'bc_nbi_bcca_loc_at_admit & location', array(''), array('')),
                array('bc_nbi_bcca_loc_at_diag', 'loc_at_diag', 'select', 'bc_nbi_bcca_loc_at_diag', array(''), array('')),
                array('bc_nbi_bcca_loc_type', 'LOCTYPE', 'select', 'bc_nbi_bcca_loc_type', array(''), array('')),
                array('bc_nbi_bcca_localtx', 'localtx', 'select', 'bc_nbi_bcca_localtx', array(''), array('')),
                array('bc_nbi_bcca_lvn_final', 'lvn_final', 'select', 'bc_nbi_bcca_neg_pos_unknown', array(''), array('')),
                array('bc_nbi_bcca_M_STG', 'M_STG', 'select', 'bc_nbi_bcca_M_STG', array(''), array('')),
                array('bc_nbi_bcca_M1atDx', 'M1atDx', 'select', 'bc_nbi_bcca_M1atDx', array(''), array('')),
                array('bc_nbi_bcca_negsentnodes', 'negsentnodes', 'select', 'bc_nbi_bcca_sentnodes', array(''), array('')),
                array('bc_nbi_bcca_nodestat', 'nodestat', 'select', 'bc_nbi_bcca_nodestat', array(''), array('')),
                array('bc_nbi_bcca_not_treated', 'not_treated', 'select', 'bc_nbi_bcca_not_treated', array(''), array('')),
                array('bc_nbi_bcca_number_fst_deg_relatives', 'number_fst_deg_relatives', 'select', 'bc_nbi_bcca_num_fst_deg_relatives', array(''), array('')),
                array('bc_nbi_bcca_performance_status', 'performance_status', 'select', 'bc_nbi_bcca_performance_status', array(''), array('')),
                array('bc_nbi_bcca_pgrposneg', 'pgrposneg', 'select', 'bc_nbi_bcca_neg_pos_unknown', array(''), array('')),
                array('bc_nbi_bcca_posnodes', 'posnodes', 'select', 'bc_nbi_bcca_posnodes', array(''), array('')),
                array('bc_nbi_bcca_possentnodes', 'possentnodes', 'select', 'bc_nbi_bcca_sentnodes', array(''), array('')),
                array('bc_nbi_bcca_recon_final', 'recon_final', 'select', 'bc_nbi_bcca_recon_final', array(''), array('')),
                array('bc_nbi_bcca_ref', 'ref', 'select', 'bc_nbi_bcca_ref', array(''), array('')),
                array('bc_nbi_bcca_registry_group', 'registry_group', 'select', 'bc_nbi_bcca_registry_group', array(''), array('')),
                array('bc_nbi_bcca_SLNB', 'SLNB', 'select', 'bc_nbi_bcca_SLNB', array(''), array('')),
                array('bc_nbi_bcca_SLNB_YesNo', 'SLNB_YesNo', 'select', 'bc_nbi_bcca_SLNB_yes_no', array(''), array('')),
                array('bc_nbi_bcca_status_at_referral', 'status_at_referral', 'select', 'bc_nbi_bcca_status_at_referral', array(''), array('')),
                array('bc_nbi_bcca_systx', 'systx', 'select', 'bc_nbi_bcca_systx', array(''), array('')),
                array('bc_nbi_bcca_tnm_clin_t', 'tnm_clin_t', 'select', 'bc_nbi_bcca_tnm_clin_t', array(''), array('')),
                array('bc_nbi_bcca_tnm_clin_yr', 'tnm_clin_yr', 'select', 'bc_nbi_bcca_UICC_TNM_staging_system', array(''), array('')),
                array('bc_nbi_bcca_tnm_surg_m', 'tnm_surg_m', 'select', 'bc_nbi_bcca_tnm_surg_m', array(''), array('')),
                array('bc_nbi_bcca_tnm_surg_n', 'tnm_surg_n', 'select', 'bc_nbi_bcca_tnm_surg_n', array(''), array('')),
                array('bc_nbi_bcca_tnm_surg_t', 'tnm_surg_t', 'select', 'bc_nbi_bcca_tnm_surg_t', array(''), array('')),
                array('bc_nbi_bcca_tnm_surg_yr', 'tnm_surg_yr', 'select', 'bc_nbi_bcca_UICC_TNM_staging_system', array(''), array('')),
                array('bc_nbi_bcca_totnodes', 'totnodes', 'select', 'bc_nbi_bcca_totnodes', array(''), array('')),
                array('bc_nbi_bcca_tum_size', 'tum_size', 'select', 'bc_nbi_bcca_tum_size', array(''), array('')),

                array('bc_nbi_bcca_dist_site', 'DISTSITE', 'icd_o_3_topography', null, null, null),
                array('bc_nbi_bcca_hist1', 'hist1', 'icd_o_3_morphology', null, null, null),
                array('bc_nbi_bcca_hist2', 'hist2', 'icd_o_3_morphology', null, null, null),
                array('bc_nbi_bcca_hist3', 'hist3', 'icd_o_3_morphology', null, null, null),
                array('bc_nbi_bcca_loc_site', 'LOCSITE', 'icd_o_3_topography', null, null, null),
                array('bc_nbi_bcca_M1SITEDX', 'M1SITEDX', 'icd_o_3_topography', null, null, null),
                array('bc_nbi_bcca_reg_site', 'REGSITE', 'icd_o_3_topography', null, null, null) 
            )
        );
        
        $diagnosis_to_create = false;
        foreach(array('DiagnosisMaster', 'DiagnosisDetail') as $model) {
            $accuracy_to_add = array();
            foreach($diagnosis_fields_to_fields_properties[$model] as $new_field_properties) {
                list($atim_field, $csv_field, $field_type, $structure_value_domain_name, $str_replace1, $str_replace2) = $new_field_properties;
                if(strlen($csv_data[$csv_field])) {
                    $diagnosis_to_create = true;
                    switch($field_type) {
                        case 'input':
                        case 'textarea':
                            $csv_diagnosis_data[$model][$atim_field] = $csv_data[$csv_field];
                            break;
                        case 'date':
                            $csv_diagnosis_data[$model][$atim_field] = validateAndGetDate($csv_data[$csv_field], $csv_field, $line_counter);
                            if($csv_diagnosis_data[$model][$atim_field] && array_key_exists($atim_field."_accuracy", $atim_participant_data)) {
                                $accuracy_to_add[$atim_field."_accuracy"] = 'c';
                            }
                            break;
                        case 'select':
                            $csv_diagnosis_data[$model][$atim_field] = validateAndGetStructureDomainValue(str_replace($str_replace1, $str_replace2, $csv_data[$csv_field]), $structure_value_domain_name, $csv_field, $line_counter);
                            break;
                        case 'icd10_who':
                        case 'icd_o_3_topography':
                        case 'icd_o_3_morphology':
                            $csv_participant_data[$atim_field] = $csv_data[$csv_field];
                            validateIcdCodeExists($csv_data[$csv_field], $field_type, $csv_field, $line_counter);
                            break;                          
                        case 'integer':
                        case 'integer_positive':
                            $csv_diagnosis_data[$model][$atim_field] = validateIntegerPositive($csv_data[$csv_field], $csv_field, $line_counter);
                            break;
                        case 'checkbox':
                            $csv_diagnosis_data[$model][$atim_field] = validateCheckBox($csv_data[$csv_field], $csv_field, $line_counter);
                            break;
                        default:
                            pr("ERR#".__LINE__.". Details : Type of ATiM field unknown $field_type.");
                    }
                }
            }
            $csv_diagnosis_data = array_merge($csv_diagnosis_data, $accuracy_to_add);
        }
        
        if(isset($csv_participant_data['date_of_birth']) && isset($csv_diagnosis_data['DiagnosisMaster']['dx_date'])) {
            $date_of_birth = new DateTime($csv_participant_data['date_of_birth']);
            $dx_date = new DateTime($csv_diagnosis_data['DiagnosisMaster']['dx_date']);
            $interval = $date_of_birth->diff($dx_date);
            if($interval->invert) {
                pr("ERR#".__LINE__.". Age at dx line $line_counter.");
            } else {
                $csv_diagnosis_data['DiagnosisMaster']['age_at_dx'] = $interval->y;
            }
        }
        if($diagnosis_to_create) {pr($atim_controls['diagnosis_controls']);
            $csv_diagnosis_data['DiagnosisMaster']['participant_id'] = $participant_id;
            $csv_diagnosis_data['DiagnosisMaster']['diagnosis_control_id'] = $atim_controls['diagnosis_controls']['primary-bcca tumor registry']['id'];
            
            pr($csv_diagnosis_data);
            
            customInsertRecord(array(
                'diagnosis_masters' => $csv_diagnosis_data['DiagnosisMaster'],
                $atim_controls['diagnosis_controls']['primary-bcca tumor registry']['detail_tablename'] => $csv_diagnosis_data['DiagnosisDetail']
            ));
        }
        
        // Treatment
        //-------------------------------------------------------------------------------------------------------------------------
        
        // Radio therapy
        
        
 
        
        
        
        | radiotherapy at diagnosis |              |           1 | bc_nbi_txd_radiations_at_dx | bc_nbi_txd_radiations_at_dx |             0 |                        NULL | NULL                         | radiotherapy at diagnosis |                0 |                        NULL |           1 |                         1 |
        |  6 | radiotherapy              |              |           1 | bc_nbi_txd_radiations       | bc_nbi_txd_radiations       |             0 |    
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
}

fclose($handle);

//Insert revs
//----------------------------------------------------


insertIntoRevsBasedOnModifiedValues();

if($is_test) {
    mysqli_rollback($db_connection);
} else {
    mysqli_commit($db_connection);
}

mysqli_close($db_connection);

pr('--------------------------------------------------------------------------------------------------------------');
die('PROCESS DONE');

//-------------------------------------------------------------------------------------------------------------------------
// FUNCTIONS
//-------------------------------------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------------------------------------------
// SYSTEM FUNCTIONS
//-------------------------------------------------------------------------------------------------------------------------

// Messages
//-------------------------------------------------------------------------------------------------------------------------

function migrationDie($error_messages) {
    global $db_connection;
    if(is_array($error_messages)) {
        foreach($error_messages as $msg) pr($msg);
    } else {
        pr($error_messages);
    }
    pr('-------------------------------------------------------------------------------------------------------------------------------------');
    $counter = 0;
    foreach(debug_backtrace() as $debug_data) {
        $counter++;
        pr("$counter- Function ".$debug_data['function']."() [File: ".$debug_data['file']." - Line: ".$debug_data['line']."]");
    }
    mysqli_rollback($db_connection);
    mysqli_close($db_connection);
    die('Please contact your administrator');
}

function pr($var) {
	print_r($var);
	echo "\n";
}

// Data Update/Record
//-------------------------------------------------------------------------------------------------------------------------

function customInsertRecord($tables_data) {
    global $created;
    global $created_by;
    global $atim_controls;
    $record_id = null;
    $main_table_data = array();
    $details_tables_data = array();
    //TODO: Add control on detail table based on _control_id
    if($tables_data) {
        $tables_data_keys = array_keys($tables_data);
        //Flush empty field
        foreach($tables_data as $table_name => $table_fields_and_data) {
            foreach($table_fields_and_data as $field => $data) {
                if(!strlen($data)) unset($tables_data[$table_name][$field]);
            }
        }
        //--1-- Check data
        switch(sizeof($tables_data)) {
            case '1':
                $tmp_tables_data_keys = $tables_data_keys;
                $table_name = array_shift($tmp_tables_data_keys);
                if(preg_match('/_masters$/', $table_name)) migrationDie("ERR_FUNCTION_customInsertRecord(): Detail table is missing to record data into $table_name");
                $main_table_data = array('name' => $table_name, 'data' => $tables_data[$table_name]);
                break;
            case '3':
                $details_table_name = '';
                foreach($tables_data_keys as $table_name) {
                    if(in_array($table_name, array('specimen_details', 'derivative_details'))) {
                        $details_tables_data[] = array('name' => $table_name, 'data' => $tables_data[$table_name]);
                        unset($tables_data[$table_name]);
                    } else if($table_name == 'sample_masters') {
                        $main_table_data = array('name' => $table_name, 'data' => $tables_data[$table_name]);
                        unset($tables_data[$table_name]);
                    } else {
                        $details_table_name = $table_name;
                    }
                }
                if(empty($main_table_data)) migrationDie("ERR_FUNCTION_customInsertRecord(): Table sample_masters is missing (See table names: ".implode(' & ', $tables_data_keys).")");
                if(empty($details_tables_data)) migrationDie("ERR_FUNCTION_customInsertRecord(): Table 'specimen_details' or 'derivative_details' is missing (See table names: ".implode(' & ', $tables_data_keys).")");
                if(sizeof($tables_data) != 1) migrationDie("ERR_FUNCTION_customInsertRecord(): Wrong 3 tables names for a new sample (See table names: ".implode(' & ', $tables_data_keys).")");
                $details_tables_data[] = array('name' => $details_table_name, 'data' => $tables_data[$details_table_name]);
                break;
            case '2':
                $details_table_name = '';
                foreach($tables_data_keys as $table_name) {
                    if(in_array($table_name, array('specimen_details', 'derivative_details', 'sample_masters'))) {
                        migrationDie("ERR_FUNCTION_customInsertRecord(): Table 'sample_masters', 'specimen_details' or 'derivative_details' defined for a record different than Sample or wrong tables definition for a sample creation (See table names: ".implode(' & ', $tables_data_keys).")");
                        exit;
                    } else if(preg_match('/_masters$/', $table_name)) {
                        $main_table_data = array('name' => $table_name, 'data' => $tables_data[$table_name]);
                        unset($tables_data[$table_name]);
                    } else {
                        $details_table_name = $table_name;
                    }
                }
                if(empty($main_table_data)) migrationDie("ERR_FUNCTION_customInsertRecord(): Table %%_masters is missing (See table names: ".implode(' & ', $tables_data_keys).")");
                if(sizeof($tables_data) != 1) migrationDie("ERR_FUNCTION_customInsertRecord(): Wrong 2 tables names for a master/detail model record (See table names: ".implode(' & ', $tables_data_keys).")");
                $details_tables_data[] = array('name' => $details_table_name, 'data' => $tables_data[$details_table_name]);
                break;
            default:
                migrationDie("ERR_FUNCTION_customInsertRecord(): Too many tables passed in arguments: ".implode(', ',$tables_data_keys).".");
        }
        //-- 2 -- Main or master table record
        if(isset($main_table_data['data']['sample_control_id'])) {
            if(!isset($atim_controls['sample_controls']['***id_to_type***'][$main_table_data['data']['sample_control_id']])) migrationDie('ERR_FUNCTION_customInsertRecord(): Unsupported sample control id.');
            $sample_type = $atim_controls['sample_controls']['***id_to_type***'][$main_table_data['data']['sample_control_id']];
            if($atim_controls['sample_controls'][$sample_type]['sample_category'] == 'specimen') {
                if(isset($main_table_data['data']['initial_specimen_sample_id'])) unset($main_table_data['data']['initial_specimen_sample_id']);
                $main_table_data['data']['initial_specimen_sample_type'] = $sample_type;
                if(isset($main_table_data['data']['parent_id'])) unset($main_table_data['data']['parent_id']);
                if(isset($main_table_data['data']['parent_sample_type'])) unset($main_table_data['data']['parent_sample_type']);
                if(!isset($main_table_data['data']['sample_code'])) $main_table_data['data']['sample_code'] = "@@@TO_GENERATE@@";
            } else {
                if(!isset($main_table_data['data']['initial_specimen_sample_id'])) migrationDie('ERR_FUNCTION_customInsertRecord(): Missing sample information : initial_specimen_sample_id.');
                if(!isset($main_table_data['data']['initial_specimen_sample_type'])) migrationDie('ERR_FUNCTION_customInsertRecord(): Missing sample information : initial_specimen_sample_type.');
                if(!isset($main_table_data['data']['parent_id'])) migrationDie('ERR_FUNCTION_customInsertRecord(): Missing sample information : parent_id.');
                if(!isset($main_table_data['data']['parent_sample_type'])) migrationDie('ERR_FUNCTION_customInsertRecord(): Missing sample information : parent_sample_type.');
                if(!isset($main_table_data['data']['sample_code'])) $main_table_data['data']['sample_code'] = "@@@TO_GENERATE@@";
            }
        }
        $main_table_data['data'] = array_merge($main_table_data['data'], array("created" => $created, "created_by" => $created_by, "modified" => "$created", "modified_by" => $created_by));
        $query = "INSERT INTO `".$main_table_data['name']."` (`".implode("`, `", array_keys($main_table_data['data']))."`) VALUES (\"".implode("\", \"", array_values($main_table_data['data']))."\")";
        $record_id = customQuery($query, true);
        if(isset($main_table_data['data']['diagnosis_control_id'])) {
            if(in_array($main_table_data['data']['diagnosis_control_id'], $atim_controls['diagnosis_controls']['***primary_control_ids***'])) {
                customQuery("UPDATE diagnosis_masters SET primary_id=id WHERE id = $record_id;", true);
            } else {
                if(!isset($main_table_data['data']['primary_id']) || !isset($main_table_data['data']['parent_id']))
                    migrationDie('ERR_FUNCTION_customInsertRecord(): Missing diagnosis_masters primary_id or parent_id key.');
            }
        } else if(isset($main_table_data['data']['sample_control_id'])) {
            $sample_type = $atim_controls['sample_controls']['***id_to_type***'][$main_table_data['data']['sample_control_id']];
            $set_strings = array();
            if($atim_controls['sample_controls'][$sample_type]['sample_category'] == 'specimen') $set_strings[] = "initial_specimen_sample_id=id";
            if($main_table_data['data']['sample_code'] == "@@@TO_GENERATE@@") $set_strings[] = "sample_code=id";
            if($set_strings) {
                customQuery("UPDATE sample_masters SET ".implode(',',$set_strings)." WHERE id = $record_id;", true);
            }
        }
        //-- 3 -- Details tables record
        if(isset($main_table_data['data']['sample_control_id'])) {
            if(sizeof($details_tables_data) != 2) migrationDie("ERR_FUNCTION_customInsertRecord(): Table 'specimen_details', 'derivative_details' or 'SampleDetail' is missing (See table names: ".implode(' & ', $tables_data_keys).")");
        } else {
            if(sizeof($details_tables_data) > 2) migrationDie("ERR_FUNCTION_customInsertRecord(): Too many tables are declared (>2) (See table names: ".implode(' & ', $tables_data_keys).")");
        }
        $tmp_detail_tablename = null;
        if($details_tables_data) {
            $foreign_key = str_replace('_masters', '_master_id', $main_table_data['name']);
            foreach($details_tables_data as $detail_table) {
                $detail_table['data'] = array_merge($detail_table['data'], array($foreign_key => $record_id));
                $query = "INSERT INTO `".$detail_table['name']."` (`".implode("`, `", array_keys($detail_table['data']))."`) VALUES (\"".implode("\", \"", array_values($detail_table['data']))."\")";
                customQuery($query, true);
                if(!in_array($detail_table['name'], array('specimen_details', 'derivative_details'))) $tmp_detail_tablename = $detail_table['name'];
            }
        }
        //-- 4 -- Keep updated tables in memory
        addToModifiedDatabaseTablesList($main_table_data['name'], $tmp_detail_tablename);
    }
    return $record_id;
}

/**
 * Update an ATim table record.
 *
 * @param string $id Id of the record to update
 * @param array $tables_data Data to update (see format above)
 */
function updateTableData($id, $tables_data) {
    global $created;
    global $created_by;
    if($tables_data) {
        $tables_data_keys = array_keys($tables_data);
        $to_update = false;
        //Flush empty field
        foreach($tables_data as $table_name => $table_fields_and_data) {
            foreach($table_fields_and_data as $field => $data) {
                if(!strlen($data)) unset($tables_data[$table_name][$field]);
            }
        }
        //Check data passed in args
        $main_or_master_tablename = null;
        switch(sizeof($tables_data)) {
            case '1':
                $tmp_tables_data_keys = $tables_data_keys;
                $main_or_master_tablename = array_shift($tmp_tables_data_keys);
                if(!empty($tables_data[$main_or_master_tablename])) $to_update = true;
                break;
            case '2':
            case '3':
                foreach($tables_data_keys as $table_name) {
                    if(preg_match('/_masters$/', $table_name)) {
                        if(!is_null($main_or_master_tablename)) migrationDie("ERR_FUNCTION_updateTableData(): 2 Master tables passed in arguments: ".implode(', ',$tables_data_keys).".");
                        $main_or_master_tablename = $table_name;
                    }
                    if(!empty($tables_data[$table_name])) $to_update = true;
                }
                if(is_null($main_or_master_tablename)) migrationDie("ERR_FUNCTION_updateTableData(): Master table not passed in arguments: ".implode(', ',$tables_data_keys).".");
                break;
            default:
                migrationDie("ERR_FUNCTION_updateTableData(): Too many tables passed in arguments: ".implode(', ',$tables_data_keys).".");
        }
        if($to_update) {
            //Master/Main Table Update
            $table_name = $main_or_master_tablename;
            $table_data = $tables_data[$main_or_master_tablename];
            unset($tables_data[$main_or_master_tablename]);
            $set_sql_strings = array();
            foreach(array_merge($table_data, array('modified' => $created, 'modified_by' => $created_by))  as $key => $value) $set_sql_strings[] = "`$key` = \"$value\"";
            $query = "UPDATE `$table_name` SET ".implode(', ', $set_sql_strings)." WHERE `id` = $id;";
            customQuery($query);
            //Detail or SpecimenDetail/DerivativeDetail Table Update
            $foreaign_key = str_replace('_masters', '_master_id', $main_or_master_tablename);
            $tmp_detail_tablename = null;
            foreach($tables_data as $table_name => $table_data) {
                if(!empty($table_data)) {
                    $set_sql_strings = array();
                    foreach($table_data  as $key => $value) $set_sql_strings[] = "`$key` = \"$value\"";
                    $query = "UPDATE `$table_name` SET ".implode(', ', $set_sql_strings)." WHERE `$foreaign_key` = $id;";
                    customQuery($query);
                    if(!in_array($table_name, array('specimen_details', 'derivative_details'))) $tmp_detail_tablename = $table_name;
                }
            }
            //Keep updated tables in memory
            addToModifiedDatabaseTablesList($main_or_master_tablename, $tmp_detail_tablename);
        }
    }
}

function addToModifiedDatabaseTablesList($main_table_name, $detail_table_name) {
    global $modified_database_tables_list;
    $key = $main_table_name.'-'.(is_null($detail_table_name)? '' : $detail_table_name);
    $modified_database_tables_list[$key] = array($main_table_name, $detail_table_name);
}

function insertIntoRevsBasedOnModifiedValues($main_tablename = null, $detail_tablename = null) {
    global $created;
    global $created_by;
    global $atim_controls;
    global $modified_database_tables_list;

    $tables_sets_to_update = $modified_database_tables_list;
    if(!is_null($main_tablename)) {
        $key = $main_tablename.'-'.(is_null($detail_tablename)? '' : $detail_tablename);
        $tables_sets_to_update = array($key => array($main_tablename, $detail_tablename));
    }

    //Check masters model alone
    $initial_tables_sets_to_update = $tables_sets_to_update;
    foreach($initial_tables_sets_to_update as $key => $tmp) {
        $matches = array();
        if(preg_match('/^([a-z]+_masters)\-$/', $key, $matches)) {
            $master_table_name = $matches[1];
            $control_table_name = str_replace('_masters', '_controls', $master_table_name);
            if(!isset($atim_controls[$control_table_name])) migrationDie("ERR 778894003 #$master_table_name.$control_table_name");
            foreach($atim_controls[$control_table_name] as $control_data) {
                if(is_array($control_data) && isset($control_data['detail_tablename'])) {
                    $detail_table_name = $control_data['detail_tablename'];
                    $new_key = "$master_table_name-$detail_table_name";
                    if(!isset($tables_sets_to_update[$new_key])) $tables_sets_to_update[$new_key] = array("$master_table_name", "$detail_table_name");
                }
            }
            unset($tables_sets_to_update[$key]);
        }
    }

    //Insert Into Revs
    $insert_queries = array();
    foreach($tables_sets_to_update as $new_tables_set) {
        list($main_tablename, $detail_tablename) = $new_tables_set;
        if(!$detail_tablename) {
            // *** CLASSICAL MODEL ***
            $query = "DESCRIBE $main_tablename;";
            $results = customQuery($query);
            $table_fields = array();
            while($row = $results->fetch_assoc()) {
                if(!in_array($row['Field'], array('created','created_by','modified','modified_by','deleted'))) $table_fields[] = $row['Field'];
            }
            $source_table_fields = (empty($table_fields)? '' : '`'.implode('`, `',$table_fields).'`, ')."`modified_by`, `modified`";
            $revs_table_fields = (empty($table_fields)? '' : '`'.implode('`, `',$table_fields).'`, ').'`modified_by`, `version_created`';
            $insert_queries[] = "INSERT INTO `".$main_tablename."_revs` ($revs_table_fields)
            (SELECT $source_table_fields FROM `$main_tablename` WHERE `modified_by` = '$created_by' AND `modified` = '$created');";
        } else {
            // *** MASTER DETAIL MODEL ***
            if(!preg_match('/^.+\_masters$/', $main_tablename)) migrationDie("ERR_FUNCTION_insertIntoRevsBasedOnModifiedValues(): '$main_tablename' is not a 'Master' table of a MasterDetail model.");
            $foreign_key = str_replace('_masters', '_master_id', $main_tablename);
            //Master table
            $query = "DESCRIBE $main_tablename;";
            $results = customQuery($query);
            $table_fields = array();
            while($row = $results->fetch_assoc()) {
                if(!in_array($row['Field'], array('created','created_by','modified','modified_by','deleted'))) $table_fields[] = $row['Field'];
            }
            $source_table_fields = (empty($table_fields)? '' : 'Master.`'.implode('`, Master.`',$table_fields).'`, ')."Master.`modified_by`, Master.`modified`";
            $revs_table_fields = (empty($table_fields)? '' : '`'.implode('`, `',$table_fields).'`, ').'`modified_by`, `version_created`';
            $insert_queries[] = "INSERT INTO `".$main_tablename."_revs` ($revs_table_fields)
            (SELECT $source_table_fields FROM `$main_tablename` AS Master INNER JOIN $detail_tablename AS Detail ON Master.`id` = Detail.`$foreign_key` WHERE Master.`modified_by` = '$created_by' AND Master.`modified` = '$created');";
            //Detail table
            $all_detail_tablenames = ($main_tablename != 'sample_masters')? array($detail_tablename) : array($detail_tablename, 'specimen_details', 'derivative_details');
            foreach($all_detail_tablenames as $detail_tablename) {
                $query = "DESCRIBE $detail_tablename;";
                $results = customQuery($query);
                $table_fields = array();
                while($row = $results->fetch_assoc()) $table_fields[] = $row['Field'];
                if(!in_array($foreign_key, $table_fields)) migrationDie("ERR_FUNCTION_insertIntoRevsBasedOnModifiedValues(): Foreign Key '$foreign_key' defined based on 'Master' table name '$main_tablename' is not a field of the 'Detail' table '$detail_tablename'.");
                $source_table_fields = (empty($table_fields)? '' : 'Detail.`'.implode('`, Detail.`',$table_fields).'`, ')."Master.`modified`";
                $revs_table_fields = (empty($table_fields)? '' : '`'.implode('`, `',$table_fields).'`, ').'`version_created`';
                $insert_queries[] = "INSERT INTO `".$detail_tablename."_revs` ($revs_table_fields)
                (SELECT $source_table_fields FROM `$main_tablename` AS Master INNER JOIN `$detail_tablename` AS Detail ON Master.`id` = Detail.`$foreign_key` WHERE Master.`modified_by` = '$created_by' AND Master.`modified` = '$created');";
            }
        }
    }
    foreach($insert_queries as $query) {
        customQuery($query, true);
    }
}

function getSelectQueryResult($query) {
    if(!preg_match('/^[\ ]*SELECT/i', $query))  migrationDie(array("ERR_QUERY", "'SELECT' query expected", $query));
    $select_result = array();
    $query_result = customQuery($query);
    while($row = $query_result->fetch_assoc()) {
        $select_result[] = $row;
    }
    return $select_result;
}

function customQuery($query, $insert = false) {
    global $db_connection;
    $query_res = mysqli_query($db_connection, $query) or migrationDie(array("ERR_QUERY", mysqli_error($db_connection), $query));
    return ($insert)? mysqli_insert_id($db_connection) : $query_res;
}

function getControlsData() {
    $atim_controls = array();
    //*** Control : event_controls ***
    $atim_controls['event_controls'] = array();
    foreach(getSelectQueryResult("SELECT id, disease_site, event_type, detail_tablename FROM event_controls WHERE flag_active = 1") as $new_control) $atim_controls['event_controls'][(strlen($new_control['disease_site'])? $new_control['disease_site'].'-': '').$new_control['event_type']] = $new_control;
    //*** Control : diagnosis_controls ***
    $atim_controls['diagnosis_controls'] = array();
    $primary_control_ids = array();
    foreach(getSelectQueryResult("SELECT id, category, controls_type, detail_tablename FROM diagnosis_controls WHERE flag_active = 1") as $new_control) {
        $atim_controls['diagnosis_controls'][$new_control['category'].'-'.$new_control['controls_type']] = $new_control;
        if($new_control['category'] == 'primary') $primary_control_ids[] = $new_control['id'];
    }
    $atim_controls['diagnosis_controls']['***primary_control_ids***'] = $primary_control_ids;
    //*** Control : treatment_controls ***
    $atim_controls['treatment_controls'] = array();
    $query  = "SELECT tc.id, disease_site, tx_method, tc.detail_tablename, applied_protocol_control_id, tec.id AS treatment_extend_control_id, tec.detail_tablename AS treatment_extend_detail_tablename
	FROM treatment_controls tc LEFT JOIN treatment_extend_controls tec ON tc.treatment_extend_control_id = tec.id AND tec.flag_active = 1
	WHERE tc.flag_active = 1";
    foreach(getSelectQueryResult($query) as $new_control) $atim_controls['treatment_controls'][(strlen($new_control['disease_site'])?$new_control['disease_site'].'-':'').$new_control['tx_method']] = $new_control;
    ksort($atim_controls);
    return $atim_controls;
}

// Data Validation
//-------------------------------------------------------------------------------------------------------------------------

function validateAndGetStructureDomainValue($value, $domain_name, $field, $line) {
    global $domains_values;
    if(!array_key_exists($domain_name, $domains_values)) {
        $domains_values[$domain_name] = array();
        $domain_data_results = getSelectQueryResult("SELECT id, source FROM structure_value_domains WHERE domain_name = '$domain_name'");
        if(!empty($domain_data_results)) {
            $domain_data_results = $domain_data_results[0];
            if($domain_data_results['source']) {
                $matches = array();
                if(preg_match('/getCustomDropdown\(\'(.*)\'\)/', $domain_data_results['source'], $matches)) {
                    $query = "SELECT val.value
						FROM structure_permissible_values_custom_controls AS ct
						INNER JOIN structure_permissible_values_customs val ON val.control_id = ct.id
						WHERE ct.name = '".$matches[1]."';";
                    foreach(getSelectQueryResult($query) as $domain_value)  $domains_values[$domain_name][strtolower($domain_value['value'])] = $domain_value['value'];
                } else {
                    migrationDie("ERR_STRUCTURE_DOMAIN: Source value format for domain_name '$domain_name' (".$domain_data_results['source'].") is not supported by the migration process (see field '$field').");
                }
            } else {
                $query = "SELECT val.value
					FROM structure_permissible_values val
					INNER JOIN structure_value_domains_permissible_values link ON link.structure_permissible_value_id = val.id
					WHERE link.structure_value_domain_id = ".$domain_data_results['id']." AND link.flag_active = '1';";
                foreach(getSelectQueryResult($query) as $domain_value) $domains_values[$domain_name][strtolower($domain_value['value'])] = $domain_value['value'];
            }
        } else {
            migrationDie("ERR_STRUCTURE_DOMAIN: Source value format for domain_name '$domain_name' is not supported by the migration process (see field '$field').");
        }
    }
    if(strlen($value)) {
        if(array_key_exists(strtolower($value), $domains_values[$domain_name])) {
            $value = $domains_values[$domain_name][strtolower($value)];	//To set the right case
        } else {
            pr("LIST ($domain_name) :: Wrong excel value '$value' for field '$field'. Value won't be migrated. See line $line.");
            $value = '';
        }
    }
    return $value;
}

function validateAndGetDate($value, $field, $line) {
    if(strlen($value)) {
        $matches = array();
        if(preg_match('/^(([1-9])|([1-2][0-9])|(3[01]))\-([A-Z][a-z]{2})\-((19[0-9]{2})|(20[0-9]{2}))$/', $value, $matches)) {
            $day = $matches[1];
            if(strlen($day) == 1) $day = "0$day";
            $month = str_replace(
                array('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'),
                array('01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'),
                $matches[5]);
            $year = $matches[6];
            if(preg_match('/^((19[0-9]{2})|(20[0-9]{2}))\-((0[1-9])|(1[0-2]))\-((0[1-9])|([1-2][0-9])|(3[01]))$/', "$year-$month-$day")) {
                return "$year-$month-$day";
            }
        }
        if(preg_match('/^((0[1-9])|([1-2][0-9])|(3[01]))((0[1-9])|([1][0-2]))(([2-9][0-9])|([0-1][0-9]))$/', $value, $matches)) {
            $year = isset($matches[10])? '20'.$matches[8] : '19'.$matches[8];
            $month = $matches[5];
            $day = $matches[1];
            return "$year-$month-$day";
        }
        pr("DATE :: Wrong excel value '$value' for field '$field' line $line. Value won't be migrated.");
        $value = '';
    }
    return $value;
}

function validateIcdCodeExists($value, $coding_system, $field, $line) {
    global $atim_icd_codes_validations;
    /*
     * 
     coding_icd10_ca
     coding_icd10_who
     coding_icd_o_2_morphology
     coding_icd_o_3_morphology
     coding_icd_o_3_topography
     */
     if(strlen($value)) {
        if(!isset($atim_icd_codes_validations[$coding_system]) || !array_key_exists($value, $atim_icd_codes_validations[$coding_system])) {
            $query = "SELECT id FROM coding_".$coding_system." WHERE id = '$value';";
            $atim_icd_codes_validations[$coding_system][$value] = getSelectQueryResult($query)? true : false;
        }
        if(!$atim_icd_codes_validations[$coding_system][$value]) {
            pr("ICD: Wrong ".str_replace('_', '-', $coding_system)." excel code '$value' for field '$field'. Value will be migrated but please validate. See line $line.");
        }
     }
}

function validateIntegerPositive($value, $field, $line) {
    if(strlen($value)) {
        if(!preg_match('/^[1-9]+$/', $value, $matches)) {
            pr("INTEGER: Wrong excel value '$value' for field '$field' line $line. Value won't be migrated.");
            $value = '';
        }
    }
    return $value;
}

function validateCheckBox($value, $field, $line) {
    if(strlen($value)) {
        if(!preg_match('/^1$/', $value, $matches)) {
            pr("CHECKBOX: Wrong excel value '$value' for field '$field' line $line. Value won't be migrated.");
            $value = '';
        }
    }
    return $value;
}
     
?>