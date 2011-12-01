<?php
if(isset($this->data[0]['file_input']) && $this->data[0]['file_input']['tmp_name']){
	$tmp = getimagesize($this->data[0]['file_input']['tmp_name']);
	if($tmp === false){
		//not an image
		$submitted_data_validates = false;
		unset($this->data[0]['file_input']);
		$this->SpecimenReviewMaster->validationErrors['file_input'] = __('this is not a valid image file', true);
	}else{
		$image = array_merge($this->data[0]['file_input'], $tmp);
		$this->data['SpecimenReviewDetail']['file_type'] = substr($image['mime'], 6);
	}
}else if($this->data){
	$submitted_data_validates = false;
	$this->SpecimenReviewMaster->validationErrors['file_input'] = __('this field is required', true).' ('.__('image', true).')';
}
