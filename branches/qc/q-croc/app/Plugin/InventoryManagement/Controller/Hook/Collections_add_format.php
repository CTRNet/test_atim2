<?php

	if(!empty($collection_data) && !$need_to_save) {
		if(isset($collection_data['TreatmentMaster']['start_date']) && !empty($collection_data['TreatmentMaster']['start_date'])) {
			$this->set('default_qcroc_collection_date', $collection_data['TreatmentMaster']['start_date']);
			if(in_array($collection_data['TreatmentMaster']['start_date_accuracy'], array('m','d'))) {
				AppController::addWarningMsg(__('the treatment date used as default collection date was rough'));
			}
		}
		$this->set('default_qcroc_protocol', 'Q-CROC-01');
	}
