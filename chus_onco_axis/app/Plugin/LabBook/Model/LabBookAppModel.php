<?php

class LabBookAppModel extends AppModel {
	/**
	 * @param int $lab_book_ctrl_id
	 * @return array The fields managed by the lab book or false if the process_ctrl_id is invalid
	 */
	function getFields($lab_book_ctrl_id){
		$control = AppModel::getInstance("LabBook", "LabBookControl", true);
		$data = $control->findById($lab_book_ctrl_id);
		if(!empty($data)){
			$detail_model = new AppModel(array('table' => $data['LabBookControl']['detail_tablename'], 'name' => "LabBookDetail", 'alias' => "LabBookDetail"));
			$fields = array_keys($detail_model->_schema);
			return array_diff($fields, array("id", "lab_book_master_id", "created", "created_by", "modified", "modified_by", "deleted", "deleted_date"));
		}
		return false;
	}
}

?>
