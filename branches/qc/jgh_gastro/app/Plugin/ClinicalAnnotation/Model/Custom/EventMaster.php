<?php

class EventMasterCustom extends EventMaster {
	var $name = "EventMaster";
	var $useTable = "event_masters";
	
	private $path_nums = array(); //unique path number validation
	
	function validates($options = array()){
		if(isset($this->data['EventDetail']['path_num'])){
			$this->checkDuplicatedPathNumber($this->data);
		}
		parent::validates($options);
		return empty($this->validationErrors);
	}
	
	function checkDuplicatedPathNumber($event_data) {
		// check data structure and get data
		$tmp_arr_to_check = array_values($event_data);
		if((!is_array($event_data)) || (is_array($tmp_arr_to_check) && isset($tmp_arr_to_check[0]['EventMaster']))) {
			AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		$path_num = $event_data['EventDetail']['path_num'];
		if(!strlen($path_num)) return;
		
		// Check duplicated path num into submited record
		if(isset($this->path_nums[$path_num])) {
			$this->validationErrors['path_num'][] = str_replace('%s', $path_num, __('you can not record path number [%s] twice'));
		} else {
			$this->path_nums[$path_num] = '';
		}
	
		// Check duplicated path_num into db
		$id_constraint = '';
		if($this->id) $id_constraint = " AND id != ".$this->id;
		$query = "SELECT count(*) as dupicated_path_num_count FROM __TABLENAME__ INNER JOIN event_masters ON id = event_master_id WHERE deleted <> 1 AND path_num = '$path_num' $id_constraint;";
		foreach(array('qc_gastro_ed_molecular_testing', 'qc_gastro_ed_immunohistochemistry') as $tablename) {
			$res = $this->query(str_replace('__TABLENAME__', $tablename, $query));
			if($res[0][0]['dupicated_path_num_count']) $this->validationErrors['path_num'][] = str_replace('%s', $path_num, __('the path_num [%s] has already been recorded'));
		}
	}
	
	
	
	
	
}

?>