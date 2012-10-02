<?php
	
	if(in_array($sample_control_data['SampleControl']['sample_type'], array('pbmc','serum','plasma'))) {
		$this->request->data['DerivativeDetail']['creation_by'] = $parent_sample_data['SpecimenDetail']['reception_by'];
		$this->request->data['DerivativeDetail']['creation_datetime'] = $parent_sample_data['SpecimenDetail']['reception_datetime'];
		$this->request->data['DerivativeDetail']['creation_datetime_accuracy'] = $parent_sample_data['SpecimenDetail']['reception_datetime_accuracy'];
	} else if ($sample_control_data['SampleControl']['sample_type'] == 'blood') {
		$this->request->data['SampleMaster']['sop_master_id'] = $collection_data['Collection']['sop_master_id'];
		$this->request->data['SampleMaster']['qc_lady_sop_followed'] = $collection_data['Collection']['qc_lady_sop_followed'];
		$this->request->data['SampleMaster']['qc_lady_sop_deviations'] = $collection_data['Collection']['qc_lady_sop_deviations'];
	}
	