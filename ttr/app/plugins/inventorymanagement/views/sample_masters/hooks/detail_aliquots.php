<?php
if($sample_master_data['SampleMaster']['sample_control_id'] == 2){
	$final_options['links']['bottom']['batch entry'] = "/inventorymanagement/bc_ttr_batch_entry/blood/".$atim_menu_variables['SampleMaster.id']."/";
}else if($sample_master_data['SampleMaster']['sample_control_id'] == 3){
	$final_options['links']['bottom']['batch entry'] = "/inventorymanagement/bc_ttr_batch_entry/tissue/".$atim_menu_variables['SampleMaster.id']."/";
}
?>