<?php
$this->Structures->set('qc_gastro_qc_scores', 'qc_gastro_qc_scores');
$score_model = AppModel::atimNew("Inventorymanagement", "QcGastroQcScore", true);
$this->set('score_data', $score_model->find('all', array('conditions' => array('quality_ctrl_id' => $quality_ctrl_id), 'recursive' => -1)));
