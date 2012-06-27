<?php
$previous_sardo_proto = AppController::defineArrayKey($previous_sardo_proto, 'QcNdProtocolBehavior', 'protocol_control_id', true);
$tx_model = AppModel::getInstance('clinicalannotation', 'TreatmentMaster', true);
$tx_ctrl_model = AppModel::getInstance('clinicalannotation', 'TreatmentControl', true);
unset($this->data['ProtocolMaster']); 
unset($this->data['ProtocolControl']);
$found = array();
foreach($this->data as $data_unit){
	if($data_unit['QcNdProtocolBehavior']['protocol_control_id'] == ''){
		continue;
	}
	if(isset($previous_sardo_proto[$data_unit['QcNdProtocolBehavior']['protocol_control_id']])){
		//already exists, remove from the previous list
		unset($previous_sardo_proto[$data_unit['QcNdProtocolBehavior']['protocol_control_id']]);
	}else if(!isset($found[$data_unit['QcNdProtocolBehavior']['protocol_control_id']])){
		//new
		$qc_nd_protocol_behavior_model->id = null;
		$qc_nd_protocol_behavior_model->data = array();
		$qc_nd_protocol_behavior_model->save(array('protocol_master_id' => $protocol_master_id, 'protocol_control_id' => $data_unit['QcNdProtocolBehavior']['protocol_control_id']));
		
		$unclassified_tx = $tx_model->find('all', array(
			'fields'	=> array('COUNT(*) AS c', 'TreatmentMaster.diagnosis_master_id', 'TreatmentMaster.participant_id', 'TreatmentControl.id'),
			'conditions' => array('TreatmentMaster.treatment_control_id' => 11, 'TreatmentMaster.deleted' => 1, 'TreatmentMaster.protocol_master_id' => $protocol_master_id),
			'group'	=> array('TreatmentMaster.diagnosis_master_id')));
		$linked_tx_controls = $tx_ctrl_model->find('all', array('conditions' => array('TreatmentControl.applied_protocol_control_id')));
		foreach($unclassified_tx as $tx){
			foreach($linked_tx_controls as $tx_ctrl){
				//foreach tx, see if the newly binded protocol has a matching tx
				$count = $tx_model->find('count', array('conditions' => array(
					'TreatmentMaster.protocol_master_id' => $protocol_master_id,	
					'TreatmentMaster.diagnosis_master_id' => $tx['TreatmentMaster']['diagnosis_master_id'],
					'TreatmentMaster.treatment_control_id' => $tx_ctrl['TreatmentControl']['id']))
				);
				
				while($count < $tx[0]['c']){
					//create the required amount of tx
					$tx_model->id = null;
					$tx_model->data = array();
					$tx_model->save(array('TreatmentMaster' => array(
						'participant_id' => $tx['TreatmentMaster']['participant_id'],
						'diagnosis_master_id' => $tx['TreatmentMaster']['diagnosis_master_id'],
						'protocol_master_id' => $protocol_master_id,
						'treatment_control_id' => $tx_ctrl['TreatmentControl']['id']
					)));
					++ $count;
				}
			}
		}
	}
	$found[$data_unit['QcNdProtocolBehavior']['protocol_control_id']] = "";
}

//remaining need to be deleted
if($previous_sardo_proto){
	AppController::addWarningMsg("Les traitements liés à ce protocole et invalidés par les changement n'ont pas été suprimés.");
	foreach($previous_sardo_proto as $data_unit){
		$qc_nd_protocol_behavior_model->delete($data_unit['QcNdProtocolBehavior']['id']);
	}
}
