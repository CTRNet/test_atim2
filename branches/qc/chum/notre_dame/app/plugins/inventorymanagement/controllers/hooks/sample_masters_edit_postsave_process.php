<?php
 	
	// --------------------------------------------------------------------------------
	// Update Derivatives Sample Labels of an updated Specimen
	// -------------------------------------------------------------------------------- 	
	if($is_specimen && ($sample_data['SampleMaster']['sample_label'] != $this->data['SampleMaster']['sample_label'])) {
		$specimen_sample_label = $this->data['SampleMaster']['sample_label'];
				
		// Get bank_participant_identifier	
		$view_collection_model = AppModel::getInstance('Inventorymanagement', 'ViewCollection', true);		
		
		$view_collection = $view_collection_model->find('first', array('conditions' => array('ViewCollection.collection_id' => $collection_id)));
		if(empty($view_collection)) $this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		
		$bank_participant_identifier = empty($view_collection['ViewCollection']['identifier_value'])? '' : $view_collection['ViewCollection']['identifier_value'];			
		
		// Get specimen derivatives list
		$this->SampleMaster->unbindModel(array('belongsTo' => array('Collection'),'hasOne' => array('SpecimenDetail','DerivativeDetail'),'hasMany' => array('AliquotMaster')));
		$specimen_derivatives_list = $this->SampleMaster->find('all', array('conditions' => array('SampleMaster.initial_specimen_sample_id' => $sample_master_id, 'SampleMaster.sample_category' => 'derivative')));
		
		// Update derivative samples label
		foreach($specimen_derivatives_list as $new_derivative) {
			$derivative_data_to_save = array();
			$derivative_data_to_save['SampleMaster']['sample_label'] = 	$this->SampleMaster->createSampleLabel($collection_id, $new_derivative, $bank_participant_identifier, $specimen_sample_label);
		
			$this->SampleMaster->data = array();
			$this->SampleMaster->id = $new_derivative['SampleMaster']['id'];
			if(!$this->SampleMaster->save($derivative_data_to_save)) $this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
	}			
			
?>
