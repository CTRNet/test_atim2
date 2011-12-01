<?php
$data = $this->SpecimenReviewMaster->redirectIfNonExistent($specimen_review_id, 'hook specimen_reviews_delete_delete', __LINE__, true);
if($data['SpecimenReviewDetail']['file_type']){
	unlink('files/path_'.$data['SpecimenReviewMaster']['id'].'.'.$data['SpecimenReviewDetail']['file_type']);
}
