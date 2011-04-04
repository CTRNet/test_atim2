<?php
$this->Structures->set('qc_gastro_qc_scores', 'qc_gastro_qc_scores');
$score_data = null;
$score_model = AppModel::atimNew("Inventorymanagement", "QcGastroQcScore", true);
if(empty($this->data)){
	$score_data = $score_model->find('all', array('conditions' => array('quality_ctrl_id' => $quality_ctrl_id), 'recursive' => -1));
}else{
	$score_data = $this->data;
	unset($score_data['QualityCtrl']);
}
if(empty($score_data)){
	//display an empty line if there is nothing
	$score_data = array("QcGastroQcScore" => array());
}
$this->set('score_data', $score_data);