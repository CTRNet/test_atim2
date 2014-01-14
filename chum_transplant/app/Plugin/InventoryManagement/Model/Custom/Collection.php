<?php

class CollectionCustom extends Collection {
	var $useTable = 'collections';
	var $name = 'Collection';
	
	function beforeSave($options = array()){
		$ret_val = parent::beforeSave($options);
		if(array_key_exists('FunctionManagement', $this->data) && array_key_exists('col_copy_binding_opt', $this->data['FunctionManagement'])) {
			// User is copying a collection
			$this->data['Collection']['acquisition_label'] = 'N/A';
			if($this->data['Collection']['treatment_master_id']) {
				$treatment_model = AppModel::getInstance('ClinicalAnnotation', 'TreatmentMaster');
				$belongsTo = array(
					'belongsTo' => array(
						'Participant' => array(
							'className' => 'ClinicalAnnotation.Participant',
							'foreignKey' => 'participant_id')));
				$treatment_model->bindModel($belongsTo);
				$transplant_data = $treatment_model->find('first', array('conditions'=>array('TreatmentMaster.id' => $this->data['Collection']['treatment_master_id']), 'recursive' => '0'));
				//Set acquisition_label
				$participant_identifier = $transplant_data['Participant']['participant_identifier'];
				$chum_transplant_type = $this->data['Collection']['chum_transplant_type'];
				$donor_number = $transplant_data['TreatmentDetail']['donor_number'];
				$previous_transplant = $transplant_data['TreatmentDetail']['previous_transplant'];
				$this->data['Collection']['acquisition_label'] = $participant_identifier.(($chum_transplant_type == 'donor time 0')?	$donor_number : 'RR'.($previous_transplant+1));
			}
		} else if(array_key_exists('treatment_master_id', $this->data['Collection'])) {
			if($this->id) {
				if($this->data['Collection']['treatment_master_id']) {
					// User is editing a clinical collection link
					$treatment_model = AppModel::getInstance('ClinicalAnnotation', 'TreatmentMaster');
					$belongsTo = array(
						'belongsTo' => array(
							'Participant' => array(
								'className' => 'ClinicalAnnotation.Participant',
								'foreignKey' => 'participant_id')));
					$treatment_model->bindModel($belongsTo);
					$new_transplant_data = $treatment_model->find('first', array('conditions'=>array('TreatmentMaster.id' => $this->data['Collection']['treatment_master_id']), 'recursive' => '0'));
					$db_collection_data = $this->find('first', array('conditions' => array('Collection.id' => $this->id), 'recursive' => '-1'));
					//Set acquisition_label
					$participant_identifier = $new_transplant_data['Participant']['participant_identifier'];
					$chum_transplant_type = $db_collection_data['Collection']['chum_transplant_type'];
					$donor_number = $new_transplant_data['TreatmentDetail']['donor_number'];
					$previous_transplant = $new_transplant_data['TreatmentDetail']['previous_transplant'];
					$this->data['Collection']['acquisition_label'] = $participant_identifier.(($chum_transplant_type == 'donor time 0')?	$donor_number : 'RR'.($previous_transplant+1));
					//$this->writable_fields_mode = 'acquisition_label'; //Added to $options['fieldList'][] in presave hook					
				} else {
					// Link deletion
					$this->data['Collection']['acquisition_label'] = 'N/A';
				}
			} else {
				// Nothing to do, the user is creating collection link for a new collection. Add form will be displayed then managed.
			}			
		} else if(array_key_exists('chum_transplant_type', $this->data['Collection'])) {
			$this->data['Collection']['acquisition_label'] = 'N/A';
			$this->addWritableField('acquisition_label');			
			if($this->id) {
				// Edit unlinked collection
				// Add a collection after clinical collection link creation
				$db_collection_data = $this->find('first', array('conditions' => array('Collection.id' => $this->id), 'recursive' => '-1'));
				if($db_collection_data['Collection']['treatment_master_id']) {
					$treatment_model = AppModel::getInstance('ClinicalAnnotation', 'TreatmentMaster');
					$belongsTo = array(
						'belongsTo' => array(
							'Participant' => array(
								'className' => 'ClinicalAnnotation.Participant',
								'foreignKey' => 'participant_id')));
					$treatment_model->bindModel($belongsTo);
					$transplant_data = $treatment_model->find('first', array('conditions'=>array('TreatmentMaster.id' => $db_collection_data['Collection']['treatment_master_id']), 'recursive' => '0'));
					//Set acquisition_label
					$participant_identifier = $transplant_data['Participant']['participant_identifier'];
					$chum_transplant_type = $this->data['Collection']['chum_transplant_type'];
					$donor_number = $transplant_data['TreatmentDetail']['donor_number'];
					$previous_transplant = $transplant_data['TreatmentDetail']['previous_transplant'];
					$this->data['Collection']['acquisition_label'] = $participant_identifier.(($chum_transplant_type == 'donor time 0')?	$donor_number : 'RR'.($previous_transplant+1));
				}
			}
		}	
		return $ret_val;
	}	
}

?>
