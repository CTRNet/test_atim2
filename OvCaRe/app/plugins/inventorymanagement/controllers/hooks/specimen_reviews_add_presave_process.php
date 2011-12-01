<?php

$image = null;
if(!empty($ovcare_file_input_data)) {
	if($ovcare_file_input_data['file_input']['tmp_name']) {
		$tmp = getimagesize($ovcare_file_input_data['file_input']['tmp_name']);
		if($tmp === false){
			//not an image
			$submitted_data_validates = false;
			unset($ovcare_file_input_data['file_input']['file_input']);
			$this->SpecimenReviewMaster->validationErrors['file_input'] = __('this is not a valid image file', true);
		}else{
			$image = array_merge($ovcare_file_input_data['file_input'], $tmp);
			$specimen_review_data['SpecimenReviewDetail']['file_type'] = substr($image['mime'], 6);
		}
	}else {
		$submitted_data_validates = false;
		$this->SpecimenReviewMaster->validationErrors['file_input'] = __('this field is required', true).' ('.__('image', true).')';
	}
}
