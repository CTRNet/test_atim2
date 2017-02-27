<?php 

	$specimen_review_data['SpecimenReviewMaster']['procure_created_by_bank'] = Configure::read('procure_bank_id');
	$this->SpecimenReviewMaster->addWritableField(array('procure_created_by_bank'));
	
	foreach($aliquot_review_data as &$procure_new_aliquot_review_to_save) {
		$procure_new_aliquot_review_to_save['AliquotReviewMaster']['procure_created_by_bank'] = Configure::read('procure_bank_id');
	}
	$this->AliquotReviewMaster->addWritableField(array('procure_created_by_bank'));
	
