<?php 

	foreach($tma_slides_to_create as &$tmp_slide) {
		$tmp_slide['TmaSlide']['procure_created_by_bank'] = Configure::read('procure_bank_id');
	}
	$this->TmaSlide->addWritableField(array('procure_created_by_bank'));
	