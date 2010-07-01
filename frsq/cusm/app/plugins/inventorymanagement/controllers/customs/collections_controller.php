<?php
	 
class CollectionsControllerCustom extends CollectionsController {
	 
	function updateCollectionSampleLabels($collection_data, $qc_cusm_prostate_bank_identifier = null) {
		$collection_id = $collection_data['Collection']['id'];
		
		if(!isset($this->SampleMaster)) {
			App::import('Model', 'Inventorymanagement.SampleMaster');
			$this->SampleMaster = new SampleMaster();
		}
		
		if(!isset($this->ViewCollection)) {
			App::import('Model', 'Inventorymanagement.ViewCollection');
			$this->ViewCollection = new ViewCollection();
		}
		
		// Get qc_cusm_prostate_bank_identifier
		if(is_null($qc_cusm_prostate_bank_identifier)) {
			$collection_view_data = $this->ViewCollection->find('first', array('conditions' => array('ViewCollection.collection_id' => $collection_id)));
			if(empty($collection_view_data)) { $this->redirect('/pages/err_inv_no_data', null, true); }
			$qc_cusm_prostate_bank_identifier = $collection_view_data['ViewCollection']['qc_cusm_prostate_bank_identifier'];			
		}
		$qc_cusm_prostate_bank_identifier = empty($qc_cusm_prostate_bank_identifier)? '' : $qc_cusm_prostate_bank_identifier;

		// Set collection visit
		$qc_cusm_visit_label = $collection_data['Collection']['qc_cusm_visit_label'];
		
		// Get collection samples list
// Following line does not work
//		$this->SampleMaster->contain(array('SampleControl', 'SpecimenDetail', 'DerivativeDetail', 'SampleDetail'));
		$this->SampleMaster->unbindModel(array('hasMany' => array('AliquotMaster'), 'belongsTo' => array('Collection')));
		$collection_samples = $this->SampleMaster->find('all', array('conditions' => array('SampleMaster.collection_id' => $collection_id), 'recursive' => '1'));
		
		// Update collection samples label
		App::import('Controller', 'Inventorymanagement.SampleMasters');
		$SampleMastersCtrl = new SampleMastersControllerCustom();	
		
		foreach($collection_samples as $new_collection_sample) {		
			// Get new label
			$new_sample_label = $SampleMastersCtrl->createSampleLabel($collection_id, $new_collection_sample, $qc_cusm_prostate_bank_identifier, $qc_cusm_visit_label);
				
			// Save new label
			$this->SampleMaster->id = $new_collection_sample['SampleMaster']['id'];
			if(!$this->SampleMaster->save(array('SampleMaster' => array('qc_cusm_sample_label' => $new_sample_label)))) {
				$this->redirect('/pages/err_inv_system_error', null, true);
			}
		}
	}
	
}
	
?>
