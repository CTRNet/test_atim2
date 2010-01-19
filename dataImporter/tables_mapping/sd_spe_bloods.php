<?php
$sd_spe_bloods["app_data"]["pkey"] = "no_labo";
$sd_spe_bloods["app_data"]["file"] = "/Users/francois-michellheureux/Desktop/DataForMigration Lady Davies/Sardex_DrBasikData_blood.csv";

$sd_spe_bloods["detail"]["blood_type"] = "";
$sd_spe_bloods["detail"]["collected_tube_nbr"] = "";
$sd_spe_bloods["detail"]["collected_volume"] = "";
$sd_spe_bloods["detail"]["collected_volume_unit"] = "";

$sd_spe_bloods["master"]["sample_code"] = "";
$sd_spe_bloods["master"]["sample_type"] = "";
$sd_spe_bloods["master"]["collection_id"] = "";
$sd_spe_bloods["master"]["sop_master_id"] = "";
$sd_spe_bloods["master"]["product_code"] = "";
$sd_spe_bloods["master"]["is_problematic"] = "";
$sd_spe_bloods["master"]["notes"] = "";


//do not modify this section
$sd_spe_bloods["master"]["sample_control_id"] = "@2";
$sd_spe_bloods["master"]["sample_category"] = "@specimen";
//$sd_spe_bloods["master"]["initial_specimen_sample_id"];
$sd_spe_bloods["master"]["initial_specimen_sample_type"] = "@blood";
$sd_spe_bloods["master"]["parent_id"] = ""; //NULL

$sd_spe_bloods["app_data"]['child'] = array();
$sd_spe_bloods["app_data"]['master_table_name'] = "participants";
$sd_spe_bloods["app_data"]['detail_parent_key'] = "sample_master_id";
$sd_spe_bloods["app_data"]['additional_queries'][] = "UPDATE sample_masters SET initial_specimen_sample_id=id WHERE id=%last_master_insert_id";
$tables['sd_spe_bloods'] = $sd_spe_bloods;
//-------------------------------
