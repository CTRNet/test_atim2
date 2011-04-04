<?php
$score_model = AppModel::atimNew("Inventorymanagement", "QcGastroQcScore", true);
unset($this->data['QualityCtrl']);
foreach($this->data as $data_line){
	if(strlen($data_line['QcGastroQcScore']['score']) > 0){
		$score_model->id = null;
		$data_line['QcGastroQcScore']['quality_ctrl_id'] = $qc_id;
		$score_model->data = $data_line;
		$score_model->save();
	}
}
