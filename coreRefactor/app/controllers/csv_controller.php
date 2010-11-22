<?php
class CsvController extends AppController {
	var $uses = array();
	
	function csv($plugin, $model, $use_key, $structure_alias){
		if(!App::import('Model', $plugin.".".$model)){
			$this->redirect( '/pages/err_model_import_failed?p[]='.$plugin.".".$model, NULL, TRUE );
		}
		$this->ModelToSearch = new $model;
		
		if(!isset($this->data[$model]) || !isset($this->data[$model][$use_key])){
			$this->redirect( '/pages/err_internal?p[]=failed to find values', NULL, TRUE );
		}
		$ids[] = 0;
		if(!is_array($this->data[$model][$use_key])){
			$this->data[$model][$use_key] = explode(",", $this->data[$model][$use_key]);
		}
		foreach($this->data[$model][$use_key] as $id){
			if($id != 0){
				$ids[] = $id;
			}
		}
		$this->data = $this->ModelToSearch->find('all', array('conditions' => $model.".".$use_key." IN (".implode(",", $ids).")"));
		$this->Structures->set($structure_alias);
		Configure::write('debug', 0);
		$this->layout = false;
	}
}