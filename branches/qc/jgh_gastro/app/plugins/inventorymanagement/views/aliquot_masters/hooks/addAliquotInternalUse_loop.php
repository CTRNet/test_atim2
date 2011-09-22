<?php 

	// --------------------------------------------------------------------------------
	//Add thickness and number of slices to tissue
	//v234 Revised
	//--------------------------------------------------------------------------
	if((isset($data_unit['parent']['SampleMaster']['sample_type']) && ($data_unit['parent']['SampleMaster']['sample_type'] == 'tissue')) 
	|| (isset($data_unit['children'][0]['AliquotInternalUse']) && array_key_exists('qc_gastro_number_of_slices', $data_unit['children'][0]['AliquotInternalUse']))) {
		if(empty($data_unit['parent']['AliquotControl']['volume_unit'])){
			$final_structure_children = $tissueinternaluses_structure;
		}else{
			//$final_structure_children = $tissueinternaluses_volume_structure;
			$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
	}
	
?>