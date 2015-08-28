<?php

class AliquotControlCustom extends AliquotControl {
	var $useTable = 'aliquot_controls';
	var $name = 'AliquotControl';
	
	//ATiM PROCURE PROCESSING BANK
	function getTransferredAliquotsDescriptionsList() {
		$transferred_aliquots_descriptions_list = array();
		//Build list of linked sample control ids from roots to nodes
		$sample_types_from_control_ids = array();
		$derivatives_ctrl_ids_from_parent_ctrl_ids = array();
		$samples_ctrl_ids_sequences = array();
		$this->ParentToDerivativeSampleControl = AppModel::getInstance("InventoryManagement", "ParentToDerivativeSampleControl", true);
		foreach($this->ParentToDerivativeSampleControl->find('all', array('conditions' => array('ParentToDerivativeSampleControl.flag_active' => true))) as $new_parent_to_derivative_sample_control) {
			if(!$new_parent_to_derivative_sample_control['ParentSampleControl']['id']) {
				//Specimen
				$samples_ctrl_ids_sequences[] = $new_parent_to_derivative_sample_control['DerivativeControl']['id'];
			} else if($new_parent_to_derivative_sample_control['ParentSampleControl']['id'] != $new_parent_to_derivative_sample_control['DerivativeControl']['id']) {
				//Derivative (no loop possible with previous control)
				$derivatives_ctrl_ids_from_parent_ctrl_ids[$new_parent_to_derivative_sample_control['ParentSampleControl']['id']][] = $new_parent_to_derivative_sample_control['DerivativeControl']['id'];
			}
			if(!array_key_exists($new_parent_to_derivative_sample_control['ParentSampleControl']['id'], $sample_types_from_control_ids)) $sample_types_from_control_ids[$new_parent_to_derivative_sample_control['ParentSampleControl']['id']] = __($new_parent_to_derivative_sample_control['ParentSampleControl']['sample_type']);
			if(!array_key_exists($new_parent_to_derivative_sample_control['DerivativeControl']['id'], $sample_types_from_control_ids)) $sample_types_from_control_ids[$new_parent_to_derivative_sample_control['DerivativeControl']['id']] = __($new_parent_to_derivative_sample_control['DerivativeControl']['sample_type']);
		}
		$sample_types_from_control_ids = array_filter($sample_types_from_control_ids);
		foreach(array_values($samples_ctrl_ids_sequences) as $sample_control_id) $this->addDerivativesCtrlIdsToSampleCtrlIdsSequences($sample_control_id, $sample_control_id, $derivatives_ctrl_ids_from_parent_ctrl_ids, $samples_ctrl_ids_sequences);
		foreach($samples_ctrl_ids_sequences as $new_sequence) {
			$sample_types_sequence = '';
			foreach(explode('-',$new_sequence) as $sample_control_id) $sample_types_sequence .= $sample_types_from_control_ids[$sample_control_id].' / ';
			$transferred_aliquots_descriptions_list[$new_sequence] = $sample_types_sequence;
		}
		//Add the aliquot control ids +/- block type to the list
		$aliquot_ctrl_ids_from_sample_ctrl_ids = array();
		$block_aliquot_control_ids = array();
		foreach($this->find('all', array('conditions' => array('AliquotControl.flag_active' => '1', 'AliquotControl.sample_control_id' => array_keys($sample_types_from_control_ids)))) as $new_aliquot_control) {
			$aliquot_ctrl_ids_from_sample_ctrl_ids[$new_aliquot_control['AliquotControl']['sample_control_id']][$new_aliquot_control['AliquotControl']['id']] = __($new_aliquot_control['AliquotControl']['aliquot_type']);
			if($new_aliquot_control['AliquotControl']['aliquot_type'] == 'block') $block_aliquot_control_ids[] = $new_aliquot_control['AliquotControl']['id'];
		}
		$tmp_transferred_aliquots_descriptions_list = array();
		foreach($transferred_aliquots_descriptions_list as $sample_ctrl_ids_sequence => $sample_types_sequence) {
			$tmp_array = explode('-',$sample_ctrl_ids_sequence);
			$node_sample_control_id = array_pop($tmp_array);
			if(array_key_exists($node_sample_control_id, $aliquot_ctrl_ids_from_sample_ctrl_ids)) {
				foreach($aliquot_ctrl_ids_from_sample_ctrl_ids[$node_sample_control_id]  as $aliquot_control_id => $aliquot_type) {
					$tmp_key = $sample_ctrl_ids_sequence.'#'.$aliquot_control_id.'#';
					$tmp_val = $sample_types_sequence.$aliquot_type;
					
					if(!in_array($aliquot_control_id, $block_aliquot_control_ids)) {
						$tmp_transferred_aliquots_descriptions_list[$tmp_key] = $tmp_val;
					} else {
						$tmp_transferred_aliquots_descriptions_list[$tmp_key.'p'] = $tmp_val.' ('.__('paraffin').')';
						$tmp_transferred_aliquots_descriptions_list[$tmp_key.'f'] = $tmp_val.' ('.__('frozen').')';
					}
				}				
			} else {
				//No aliquot for this sample controls
			}
		}
		$transferred_aliquots_descriptions_list = array_flip($tmp_transferred_aliquots_descriptions_list);
		ksort($transferred_aliquots_descriptions_list);
		$transferred_aliquots_descriptions_list = array_flip($transferred_aliquots_descriptions_list);
		return $transferred_aliquots_descriptions_list;
	}
	
	function addDerivativesCtrlIdsToSampleCtrlIdsSequences($studied_sample_control_id, $sample_ctrl_ids_sequence_from_root_to_studied_id, &$derivatives_ctrl_ids_from_parent_ctrl_ids, &$samples_ctrl_ids_sequences) {
		if(array_key_exists($studied_sample_control_id, $derivatives_ctrl_ids_from_parent_ctrl_ids)) {
			foreach($derivatives_ctrl_ids_from_parent_ctrl_ids[$studied_sample_control_id] as $new_derivative_control_id) {
				$samples_ctrl_ids_sequences[] = $sample_ctrl_ids_sequence_from_root_to_studied_id.'-'.$new_derivative_control_id;
				$this->addDerivativesCtrlIdsToSampleCtrlIdsSequences($new_derivative_control_id, $sample_ctrl_ids_sequence_from_root_to_studied_id.'-'.$new_derivative_control_id, $derivatives_ctrl_ids_from_parent_ctrl_ids, $samples_ctrl_ids_sequences);
			}
		} else {
			//No derivative can be created from this sample controls (see ParentToDerivativeSampleControl): No additional record 
		}
	}
	
	function getSampleAliquotCtrlIdsSequence($aliquot_master_id) {
		$aliquot_master_model = AppModel::getInstance("InventoryManagement", "AliquotMaster", true);
		$sample_master_model = AppModel::getInstance("InventoryManagement", "SampleMaster", true);
		$aliquot_data = $aliquot_master_model->find('first', array('conditions' => array('AliquotMaster.id' => $aliquot_master_id), 'recursive' => '0'));
		if($aliquot_data) {
			$parent_sample_data = $aliquot_data;
			$sample_control_ids = array($parent_sample_data['SampleMaster']['sample_control_id']);
			while($parent_sample_data = $sample_master_model->find('first', array('conditions' => array('SampleMaster.id' => $parent_sample_data['SampleMaster']['parent_id']), 'recursive' => '-1'))) {
				$sample_control_ids[] = $parent_sample_data['SampleMaster']['sample_control_id'];
			}
			$sample_control_ids = array_reverse($sample_control_ids);
			$res = array(
				implode('-',$sample_control_ids),
				$aliquot_data['AliquotControl']['id'],
				$aliquot_data['AliquotControl']['aliquot_type'] == 'block'? substr($aliquot_data['AliquotDetail']['block_type'],0,1): '');
			return implode('#',$res);
		}
		return '';
	}
}
