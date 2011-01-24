<?php
class CsvController extends AppController {
	var $uses = array();

	/**
	 * Fetches data and returns it in a CSV
	 * @param string $plugin
	 * @param string $model_name The model to use to fetch the data
	 * @param string $model_pkey The key to use to fetch the data
	 * @param string $structure_alias The structure to render the data
	 * @param string $data_model The model to look for in the data array
	 * @param string $data_pkey The pkey to look for in the data array
	 */
	function csv($plugin, $model_name, $model_pkey, $structure_alias, $data_model = null, $data_pkey = null){
		$this->ModelToSearch = AppModel::atimNew($plugin, $model_name, true);
		
		if($data_pkey == null){
			$data_pkey = $model_pkey;
			if($data_model == null){
				$data_model = $model_name;
			}
		}
		
		if(!isset($this->data[$data_model]) || !isset($this->data[$data_model][$data_pkey])){
			$this->redirect( '/pages/err_internal?p[]=failed to find values', NULL, TRUE );
			exit;
		}
		$ids[] = 0;
		if(!is_array($this->data[$data_model][$data_pkey])){
			$this->data[$data_model][$data_pkey] = explode(",", $this->data[$data_model][$data_pkey]);
		}
		foreach($this->data[$data_model][$data_pkey] as $id){
			if($id != 0){
				$ids[] = $id;
			}
		}
		$this->data = $this->ModelToSearch->find('all', array('conditions' => $model_name.".".$model_pkey." IN (".implode(",", $ids).")"));
		$this->Structures->set($structure_alias);
		Configure::write('debug', 0);
		$this->layout = false;
	}
}