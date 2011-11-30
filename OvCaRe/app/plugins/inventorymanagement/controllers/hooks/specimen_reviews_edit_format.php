<?php
if(isset($this->data[0]['file_input'])){
	$tmp = getimagesize($this->data[0]['file_input']['tmp_name']);
	if($tmp === false){
		//not an image
		unset($this->data[0]['file_input']);
	}else{
		$image = array_merge($this->data[0]['file_input'], $tmp);
		$this->data['SpecimenReviewDetail']['file_type'] = substr($image['mime'], 6);
	}
}