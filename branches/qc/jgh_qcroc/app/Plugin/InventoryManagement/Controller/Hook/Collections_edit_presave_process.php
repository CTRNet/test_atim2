<?php 
	
	$sample_types = $this->Collection->tryCatchQuery("SELECT DISTINCT SampleControl.sample_type 
		FROM sample_masters SampleMaster 
		INNER JOIN sample_controls SampleControl ON SampleControl.id = SampleMaster.sample_control_id
		WHERE SampleMaster.deleted <> 1 AND SampleMaster.collection_id = $collection_id AND SampleControl.sample_category = 'specimen'");
	if(sizeof($sample_types) > 1) {
		$this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true);
	} else if(sizeof($sample_types) == 1) {
		$collection_sample_type = $sample_types['0']['SampleControl']['sample_type'];
		if($collection_sample_type != $this->Collection->getCollectionSampleTypeBasedOnCollectionType($this->request->data['Collection']['qcroc_collection_type'])) {
			$submitted_data_validates = false;
			$this->Collection->validationErrors['qcroc_collection_type'][] = __('this collection type can not be associated to the collected sample type');
		}
	}
	