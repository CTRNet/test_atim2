<?php
	
	if($sample_data['SampleControl']['sample_type'] == 'tissue' 
	&& (($sample_data['SpecimenDetail']['qcroc_collection_time'] != $this->request->data['SpecimenDetail']['qcroc_collection_time']) || ($sample_data['SampleDetail']['qcroc_tissue_storage_solution'] != $this->request->data['SampleDetail']['qcroc_tissue_storage_solution']))) {
		$this->AliquotMaster->updateTimeRemainedInRNAlater($collection_id, $sample_master_id);
	}
	