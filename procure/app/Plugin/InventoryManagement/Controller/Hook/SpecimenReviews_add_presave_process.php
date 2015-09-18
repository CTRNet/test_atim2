<?php 

	$specimen_review_data['SpecimenReviewMaster']['procure_created_by_bank'] = Configure::read('procure_bank_id');
	$this->SpecimenReviewMaster->addWritableField(array('procure_created_by_bank'));
	