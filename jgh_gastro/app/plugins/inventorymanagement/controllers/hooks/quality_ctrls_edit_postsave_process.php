<?php
unset($this->data['QualityCtrl']);
$score_data_ids = $score_model->find('list', array('conditions' => array('quality_ctrl_id' => $quality_ctrl_id), 'recursive' => -1));
$saved_ids = array();
foreach($this->data as $data_line){
	if(strlen($data_line['QcGastroQcScore']['score']) > 0){
		if(strlen($data_line['QcGastroQcScore']['score'])){
			$score_model->id = $data_line['QcGastroQcScore']['id'];
			$saved_ids[] = $data_line['QcGastroQcScore']['id'];
		}else{
			$score_model->id = null;
		}
		$data_line['QcGastroQcScore']['quality_ctrl_id'] = $quality_ctrl_id;
		$score_model->data = $data_line;
		$score_model->save();
	}
}

//delete missing ids
$missing_ids = array_diff($score_data_ids, $saved_ids);
foreach($missing_ids as $missing_id){
	$score_model->atim_delete($missing_id);
}
?>