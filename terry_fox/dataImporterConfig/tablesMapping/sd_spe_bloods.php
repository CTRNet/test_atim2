<?php
$sd_spe_bloods["app_data"]["pkey"] = "id";
$sd_spe_bloods["app_data"]["file"] = "5";

$sd_spe_bloods["master"]["sample_code"] = "";//Required
$sd_spe_bloods["master"]["collection_id"] = "sample_parent_id";//??

$sd_spe_bloods["app_data"]['additional_queries'][] = "UPDATE sample_masters SET sample_label=CONCAT('S - bankid EDTA'),  sample_code=CONCAT('B - ', id) WHERE id=%%last_master_insert_id%%";
$sd_spe_bloods["app_data"]['additional_queries'][] = "INSERT INTO specimen_details(`id`, `sample_master_id`, `created_by`, `created`, `modified`, `modified_by`) VALUES(%%last_master_insert_id%%, %%last_master_insert_id%%, 1, NOW(), 1, NOW())";

//do not modify this section
$sd_spe_bloods["detail"]["sample_master_id"] = "sample_master_id";

$sd_spe_bloods["master"]["sample_type"] = "@blood";
$sd_spe_bloods["master"]["sample_control_id"] = "@2";
$sd_spe_bloods["master"]["sample_category"] = "@specimen";
//$sd_spe_bloods["master"]["initial_specimen_sample_id"];
$sd_spe_bloods["master"]["initial_specimen_sample_type"] = "@blood";
$sd_spe_bloods["master"]["parent_id"] = ""; //NULL

$sd_spe_bloods["app_data"]['child'][] = "sd_der_blood_cells";
$sd_spe_bloods["app_data"]['child'][] = "sd_der_plasmas";
$sd_spe_bloods["app_data"]['child'][] = "sd_der_pbmcs";
$sd_spe_bloods["app_data"]['child'][] = "sd_der_serums";
$sd_spe_bloods["app_data"]['master_table_name'] = "sample_masters";
$sd_spe_bloods["app_data"]['detail_table_name'] = "sd_spe_bloods";
$sd_spe_bloods["app_data"]['detail_parent_key'] = "sample_master_id";
$sd_spe_bloods["app_data"]['parent_key'] = "collection_id";
$sd_spe_bloods["app_data"]['additional_queries'][] = "UPDATE sample_masters SET initial_specimen_sample_id=%%last_master_insert_id%% WHERE id=%%last_master_insert_id%%";
$tables['sd_spe_bloods'] = $sd_spe_bloods;
//-------------------------------
