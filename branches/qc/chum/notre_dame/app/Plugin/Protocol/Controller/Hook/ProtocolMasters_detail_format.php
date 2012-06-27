<?php
$this->Structures->set('qc_nd_sardo_protocol', 'qc_nd_sardo_protocol');

$qc_nd_protocol_behavior_model = AppModel::getInstance('protocol', 'QcNdProtocolBehavior');
$previous_sardo_proto = $qc_nd_protocol_behavior_model->find('all', array('conditions' => array('protocol_master_id' => $protocol_master_id)));
$this->set('previous_sardo_proto', $previous_sardo_proto);