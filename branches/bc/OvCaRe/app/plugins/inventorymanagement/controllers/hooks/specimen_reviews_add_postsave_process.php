<?php
if(isset($image)){
	assert(move_uploaded_file($image['tmp_name'], 'files/path_'.$this->SpecimenReviewMaster->id.'.'.substr($image['mime'], 6)));
}