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
			
			$SpecimenReviewDetailModel = new SpecimenReviewDetail(false, $review_control_data['SpecimenReviewControl']['detail_tablename']);
			$is_not_unique_filename = $SpecimenReviewDetailModel->find('count', array('conditions' => array('SpecimenReviewDetail.file_name' => $image['name'])));	
				
			if($is_not_unique_filename) {
				$submitted_data_validates = false;
				$this->SpecimenReviewMaster->validationErrors['file_input'] = str_replace('%%file_name%%', $image['name'], __('a file with the same file name [%%file_name%%] has already be downloaded', true));
			} else {
				$specimen_review_data['SpecimenReviewDetail']['file_name'] = $image['name'];
				$specimen_review_data['SpecimenReviewDetail']['file_type'] = substr($image['mime'], 6);
			}
		}
	}else {
		$submitted_data_validates = false;
		$this->SpecimenReviewMaster->validationErrors['file_input'] = __('this field is required', true).' ('.__('image', true).')';
	}
}
