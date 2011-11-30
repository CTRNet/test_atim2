<?php
if(isset($specimen_review_data['SpecimenReviewDetail']['file_type']) && !empty($specimen_review_data['SpecimenReviewDetail']['file_type'])){
	$specimen_review_data['0']['file_link'] = $this->Html->link(__('image', true), '/files/path_'.$specimen_review_data['SpecimenReviewMaster']['id'].'.'.$specimen_review_data['SpecimenReviewDetail']['file_type'], array());
}else{
	$specimen_review_data['0']['file_link'] = '';
}
$final_options['data'] = $specimen_review_data; 
