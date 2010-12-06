<?php

class DatamartAppModel extends AppModel {
	/**
	 * Builds the action dropdown actions
	 * @param string $plugin
	 * @param string $model_name The model to use to fetch the data
	 * @param string $model_pkey The key to use to fetch the data
	 * @param string $structure_alias The structure to render the data
	 * @param string $data_model The model to look for in the data array (for csv linking)
	 * @param string $data_pkey The pkey to look for in the data array (for csv linking)
	 */	
	function getDropdownOptions($plugin_name, $model_name, $model_pkey, $structure_name, $data_model, $data_pkey){
		$batch_set = AppModel::atimNew("datamart", "BatchSet", true);
		$datamart_structures = AppModel::atimNew("datamart", "DatamartStructure", true);
		$d_struct = $datamart_structures->find('first', array('conditions' => array('DatamartStructure.plugin' => $plugin_name, 'DatamartStructure.model' => $model_name)));
		$datamart_structure_id = count($d_struct) ? $d_struct['DatamartStructure']['id'] : 0;
		$compatible_batch_sets = $batch_set->getCompatibleBatchSets($plugin_name, $model_name, $datamart_structure_id);
		$batch_set_menu[] = array(
			'value' => '0',
			'default' => __('create batchset', true),
			'action' => 'datamart/batch_sets/add/'
		);
		foreach($compatible_batch_sets as $batch_set){
			$batch_set_menu[] = array(
				'value' => '0',
				'default' => __('add to compatible batchset', true). " [".$batch_set['BatchSet']['title']."]",
				'action' => 'datamart/batch_sets/add/'.$batch_set['BatchSet']['id']
			);
		}
		$result = array();
		$result[] = array(
			'value' => '0',
			'default' => __('batchset', true),
			'children' => $batch_set_menu
		);
		
		$structure_functions = AppModel::atimNew("datamart", "DatamartStructureFunction", true);
		$functions = $structure_functions->find('all', array('conditions' => array('DatamartStructureFunction.datamart_structure_id' => $datamart_structure_id, 'DatamartStructureFunction.flag_active' => true)));
		if(count($functions)){
			$functions_menu = array();
			foreach($functions as $function){
				$functions_menu[] = array(
					'value' 	=> '0',
					'default' 	=> __($function['DatamartStructureFunction']['label'], true),
					'action'	=> $function['DatamartStructureFunction']['link']
				);
			}
			$result[] = array(
				'value' => '0',
				'default' => __('batch actions', true),
				'children' => $functions_menu
			);
		}
		$csv_action = 'csv/csv/'.$plugin_name.'/'.$model_name.'/'.$model_pkey.'/'.$structure_name.'/';
		if(strlen($data_model)){
			$csv_action .= $data_model.'/';
			if(strlen($data_pkey)){
				$csv_action .= $data_pkey.'/';
			}
		}
		$result[] = array(
			'value' => '0',
			'default' => __('export as CSV file (comma-separated values)', true),
			'action' => $csv_action
		);
		
		return $result;
	}
}

?>