<?php
if(isset($specimen_review_data['SpecimenReviewDetail']['file_type']) && !empty($specimen_review_data['SpecimenReviewDetail']['file_type'])){
	$image_size = getimagesize('files/path_'.$specimen_review_data['SpecimenReviewMaster']['id'].'.'.$specimen_review_data['SpecimenReviewDetail']['file_type']);
	$index = $image_size[0] > $image_size[1] ? 0 : 1;
	$image = '/files/path_'.$specimen_review_data['SpecimenReviewMaster']['id'].'.'.$specimen_review_data['SpecimenReviewDetail']['file_type'];
	$image_settings = array(
		'alt'	=> '',
		'url'	=> $image
	);
	if($image_size[$index] > 300){
		if($index == 0){
			$image_settings['width'] = 300;
		}else{
			$image_settings['height'] = 300;
		}
	}
	
	$specimen_review_data['0']['file_link'] = $this->Html->image($image, $image_settings);
}else{
	$specimen_review_data['0']['file_link'] = '';
}
$final_options['data'] = $specimen_review_data; 
