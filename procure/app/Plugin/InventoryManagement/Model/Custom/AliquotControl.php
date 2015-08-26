<?php

class AliquotControlCustom extends AliquotControl {
	var $useTable = 'aliquot_controls';
	var $name = 'AliquotControl';
	
	var $description_separator = ' / ';
	
	//ATiM PROCURE PROCESSING BANK
	function getTransferredAliquotsDescriptionsList() {
		//Build list of linked sample types from roots to nodes
		$transferred_samples_descriptions_list = array();
		$derivatives_control_data_from_parent_control_id = array();
		$this->ParentToDerivativeSampleControl = AppModel::getInstance("InventoryManagement", "ParentToDerivativeSampleControl", true);
		$conditions = array('ParentToDerivativeSampleControl.flag_active' => true);
		foreach($this->ParentToDerivativeSampleControl->find('all', array('conditions' => $conditions)) as $new_parent_to_derivative_sample_control_link) {
			if(!$new_parent_to_derivative_sample_control_link['ParentSampleControl']['id']) {
				$transferred_samples_descriptions_list[$new_parent_to_derivative_sample_control_link['DerivativeControl']['id']] = $new_parent_to_derivative_sample_control_link['DerivativeControl']['sample_type'];
			} else if($new_parent_to_derivative_sample_control_link['ParentSampleControl']['id'] != $new_parent_to_derivative_sample_control_link['DerivativeControl']['id']) {
				$derivatives_control_data_from_parent_control_id[$new_parent_to_derivative_sample_control_link['ParentSampleControl']['id']][] = $new_parent_to_derivative_sample_control_link['DerivativeControl'];
			}
		}
		$specimen_types_from_ids = $transferred_samples_descriptions_list;
		foreach($specimen_types_from_ids as $sample_control_id => $sample_type) $this->addDerivativesToTransferredSamplesDescriptionsList($sample_control_id, $sample_control_id, $sample_type, $derivatives_control_data_from_parent_control_id, $transferred_samples_descriptions_list);
		//Get list of aliquot controls
		$all_aliquot_controls_from_sample_control_ids = array();
		foreach($this->find('all', array('conditions' => array('AliquotControl.flag_active' => '1'))) as $new_aliquot_control) {
			$all_aliquot_controls_from_sample_control_ids[$new_aliquot_control['AliquotControl']['sample_control_id']][] = $new_aliquot_control['AliquotControl']['aliquot_type'];
		}
		//Add aliquot type to build the list of transferred aliquots descriptions
		$transferred_aliquots_descriptions_list = array();
		foreach($transferred_samples_descriptions_list as $linked_sample_control_ids => $linked_sample_types) {
			$tmp_data = explode($this->description_separator,$linked_sample_control_ids);
			$tmp_data = array_reverse($tmp_data);
			$node_sample_control_id =  array_shift($tmp_data);
			if(array_key_exists($node_sample_control_id, $all_aliquot_controls_from_sample_control_ids)) {
				foreach($all_aliquot_controls_from_sample_control_ids[$node_sample_control_id] as $aliquot_type) {
					$key = $linked_sample_types.$this->description_separator.$aliquot_type;
					$translated_key = array();
					foreach(explode($this->description_separator, $key) as $new_element_to_translate) $translated_key[] = __($new_element_to_translate);
					$translated_key = implode($this->description_separator, $translated_key);
					if($aliquot_type != 'block') {
						$transferred_aliquots_descriptions_list[$key] = $translated_key;
					} else {
						$transferred_aliquots_descriptions_list[$key." (paraffin)"] = $translated_key.' ('.__('paraffin').')';
						$transferred_aliquots_descriptions_list[$key." (frozen)"] = $translated_key.' ('.__('frozen').')';
					}
				}
			}
		}
		$transferred_aliquots_descriptions_list = array_flip($transferred_aliquots_descriptions_list);
		ksort($transferred_aliquots_descriptions_list);
		$transferred_aliquots_descriptions_list = array_flip($transferred_aliquots_descriptions_list);
		return $transferred_aliquots_descriptions_list;
	}
	
	function addDerivativesToTransferredSamplesDescriptionsList($parent_sample_control_id, $all_parents_sample_control_ids, $all_parents_sample_types, $derivatives_control_data_from_parent_control_id, &$transferred_samples_descriptions_list) {
		if(array_key_exists($parent_sample_control_id, $derivatives_control_data_from_parent_control_id)) {
			foreach($derivatives_control_data_from_parent_control_id[$parent_sample_control_id] as $new_derivative_control) {
				$transferred_samples_descriptions_list[$all_parents_sample_control_ids.$this->description_separator.$new_derivative_control['id']] = $all_parents_sample_types.$this->description_separator.$new_derivative_control['sample_type'];
				$this->addDerivativesToTransferredSamplesDescriptionsList($new_derivative_control['id'], $all_parents_sample_control_ids.$this->description_separator.$new_derivative_control['id'], $all_parents_sample_types.$this->description_separator.$new_derivative_control['sample_type'], $derivatives_control_data_from_parent_control_id, $transferred_samples_descriptions_list);
			}
		}
	}

	function formatTransferredAliquotsDescriptionToArray($aliquot_description) {
		$formatted_descriptions = array();
		$tmp_descriptions_element_template = array('sample_type' => null, 'aliquot_type' => null, 'block_type' => null);
		$all_descriptions = array_reverse(explode($this->description_separator, $aliquot_description));
		if(sizeof($all_descriptions) < 2) AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);		
		$counter = 0;
		while($new_description = array_shift($all_descriptions)) {
			$counter++;
			switch($counter) {
				case '1':
					$formatted_descriptions[0] = $tmp_descriptions_element_template;
					if(preg_match('/^(.+)\ \(((paraffin)|(frozen))\)$/', $new_description, $matches)) {
						$formatted_descriptions[0] = array_merge($tmp_descriptions_element_template, array('aliquot_type' => $matches[1], 'block_type' => $matches[2]));
					} else {
						$formatted_descriptions[0] = array_merge($tmp_descriptions_element_template, array('aliquot_type' => $new_description));
					}
					break;
				case '2':
					$formatted_descriptions[0]['sample_type'] = $new_description;
					break;
				default:
					$formatted_descriptions[] = array_merge($tmp_descriptions_element_template, array('sample_type' => $new_description));
			}
		}
		return array_reverse($formatted_descriptions);
	}
	//END ATiM PROCURE PROCESSING BANK
}
