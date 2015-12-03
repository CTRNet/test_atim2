<?php
	
	if(empty($errors)){
		$tmp_counter = 0;;
		foreach($tma_slides_to_create as &$tmp_new_tma) {
			$tmp_counter++;
			$tmp_new_tma['TmaSlide']['barcode'] = 'tmp-'.$tmp_counter;
		}
		$this->TmaSlide->addWritableField(array('barcode'));
	}
			