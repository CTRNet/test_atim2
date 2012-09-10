<?php

if(in_array($created_sample_override_data['SampleControl.sample_type'], array('dna','rna'))) {
	if(isset($final_options_parent['data']['AliquotDetail']['cell_passage_number'])){
		$final_options_children['override']['SampleDetail.source_cell_passage_number'] = $final_options_parent['data']['AliquotDetail']['cell_passage_number']; 
	}

	if(isset($final_options_parent['data']['StorageMaster']['temperature'])){
		$final_options_children['override']['SampleDetail.source_temperature'] = $final_options_parent['data']['StorageMaster']['temperature']; 
		$final_options_children['override']['SampleDetail.source_temp_unit'] = $final_options_parent['data']['StorageMaster']['temp_unit']; 
	}
	
	if(isset($final_options_parent['data']['AliquotDetail']['tmp_storage_solution'])){
		$final_options_children['override']['SampleDetail.tmp_source_milieu'] = $final_options_parent['data']['AliquotDetail']['tmp_storage_solution']; 
	}
	
	if(isset($final_options_parent['data']['AliquotDetail']['tmp_storage_mothod'])){
		$final_options_children['override']['SampleDetail.tmp_source_storage_method'] = $final_options_parent['data']['AliquotDetail']['tmp_storage_method']; 
	}
}
