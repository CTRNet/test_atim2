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
	 * @param int $batch_set_id The id of the current batch set
	 */	
	function getDropdownOptions($plugin_name, $model_name, $model_pkey, $structure_name, $data_model, $data_pkey, $batch_set_id = null){
		$batch_set = AppModel::getInstance("Datamart", "BatchSet", true);
		$datamart_structure_model = AppModel::getInstance("Datamart", "DatamartStructure", true);
		$datamart_structure_id = $datamart_structure_model->getIdByModelName($data_model); 
		$compatible_batch_sets = $batch_set->getCompatibleBatchSets($plugin_name, $model_name, $datamart_structure_id, $batch_set_id);
		$batch_set_menu[] = array(
			'value' => '0',
			'label' => __('create batchset'),
			'value' => 'Datamart/BatchSets/add/'
		);
		foreach($compatible_batch_sets as $batch_set){
			$batch_set_menu[] = array(
				'value' => '0',
				'label' => __('add to compatible batchset'). " [".$batch_set['BatchSet']['title']."]",
				'value' => 'Datamart/BatchSets/add/'.$batch_set['BatchSet']['id']
			);
		}
		$result = array();
		$result[] = array(
			'value' => '0',
			'label' => __('batchset'),
			'children' => $batch_set_menu
		);
		
		$structure_functions = AppModel::getInstance("Datamart", "DatamartStructureFunction", true);
		$functions = $structure_functions->find('all', array('conditions' => array('DatamartStructureFunction.datamart_structure_id' => $datamart_structure_id, 'DatamartStructureFunction.flag_active' => true)));
		if(count($functions)){
			$functions_menu = array();
			foreach($functions as $function){
				if(AppController::checkLinkPermission($function['DatamartStructureFunction']['link'])){
					$functions_menu[] = array(
						'value' 	=> '0',
						'label' 	=> __($function['DatamartStructureFunction']['label']),
						'value'		=> substr($function['DatamartStructureFunction']['link'], 1)
					);
				}
			}
			if($functions_menu){
				$result[] = array(
					'value' => '0',
					'label' => __('batch actions'),
					'children' => $functions_menu
				);
			}
		}
		$csv_action = 'Datamart/csv/csv/%d/plugin:'.$plugin_name.'/model:'.$model_name.'/modelPkey:'.$model_pkey.'/structure:'.$structure_name.'/';
		if(strlen($data_model)){
			$csv_action .= 'dataModel:'.$data_model.'/';
			if(strlen($data_pkey)){
				$csv_action .= 'dataPkey:'.$data_pkey.'/';
			}
		}
		$csv_action = "javascript:setCsvPopup('$csv_action');";
		$result[] = array(
			'value' => '0',
			'label' => __('export as CSV file (comma-separated values)'),
			'value' => sprintf($csv_action, 0)
		);
		
		return $result;
	}
}

?>
