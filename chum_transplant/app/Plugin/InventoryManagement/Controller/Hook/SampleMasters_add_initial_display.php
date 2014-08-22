<?php

// --------------------------------------------------------------------------------
// Set default aliquot label(s)
// --------------------------------------------------------------------------------

if($parent_sample_data) {
	if($parent_sample_data['SampleControl']['sample_type'] == 'blood') {
		$this->request->data['DerivativeDetail']['creation_datetime'] = $parent_sample_data['SpecimenDetail']['reception_datetime'];
		$this->request->data['DerivativeDetail']['creation_datetime_accuracy'] = $parent_sample_data['SpecimenDetail']['reception_datetime_accuracy'];
		$this->request->data['DerivativeDetail']['creation_by'] = $parent_sample_data['SpecimenDetail']['reception_by'];
	}
} else {
	$last_created_specimen = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleControl.sample_category' => 'specimen'), 'recursive' => 0, 'order' => array('SampleMaster.created DESC')));
	if($last_created_specimen) {
		$this->request->data['SpecimenDetail']['reception_datetime'] = $last_created_specimen['SpecimenDetail']['reception_datetime'];
		$this->request->data['SpecimenDetail']['reception_datetime_accuracy'] = $last_created_specimen['SpecimenDetail']['reception_datetime_accuracy'];
		$this->request->data['SpecimenDetail']['reception_by'] = $last_created_specimen['SpecimenDetail']['reception_by'];
	} else {
		$this->request->data['SpecimenDetail']['reception_datetime'] = $collection_data['Collection']['collection_datetime'];
		$this->request->data['SpecimenDetail']['reception_datetime_accuracy'] = $collection_data['Collection']['collection_datetime_accuracy'];
	}
}

