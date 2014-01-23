<?php
	
	if($is_specimen && isset($this->request->data['SpecimenDetail']['qcroc_collection_time']) 
	&& !empty($this->request->data['SpecimenDetail']['qcroc_collection_time']) 
	&& $collection_data['Collection']['qcroc_collection_date_accuracy'] != 'c') {
		$this->SampleMaster->validationErrors['qcroc_collection_time'][] = 'specimen collection time can not be set when collection date is estimated';
		$submitted_data_validates = false;		
	}
	
	if($is_specimen) {
		switch($this->request->data['SampleControl']['sample_type']) {
			case 'tissue':
				if(strlen($collection_data['Collection']['qcroc_banking_nbr'])) $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
				break;
			case 'blood':
				if(strlen($collection_data['Collection']['qcroc_biopsy_type'])) $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
				break;
			default:
				$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
	}	
	