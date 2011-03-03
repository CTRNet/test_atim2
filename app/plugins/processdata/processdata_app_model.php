<?php

class ProcessDataAppModel extends AppModel {
	
	/**
	 * @param int $process_ctrl_id
	 * @return array The fields managed by the process or false if the process_ctrl_id is invalid
	 */
	function getFields($process_ctrl_id){
		$control = AppModel::atimNew("processdata", "ProcessDataControl", true);
		$data = $control->findById($process_ctrl_id);
		if(!empty($data)){
			$detail_model = new AppModel(array('table' => $data['ProcessDataControl']['detail_tablename'], 'name' => "ProcessDataDetail", 'alias' => "ProcessDataDetail"));
			$fields = array_keys($detail_model->_schema);
			return array_diff($fields, array("id", "process_data_master_id", "created", "created_by", "modified", "modified_by", "deleted", "deleted_date"));
		}
		return false;
	}
}

?>
