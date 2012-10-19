<?php
	
	$this->SpecimenReviewMaster->data = array();
	$this->SpecimenReviewMaster->id = $specimen_review_master_id;
	$this->SpecimenReviewMaster->addWritableField(array('review_code'));
	$data_to_udpate = array('SpecimenReviewMaster' => array('review_code' => __($review_control_data['SampleControl']['sample_type']).' - '.__($review_control_data['SpecimenReviewControl']['review_type']). ' sc#'. $specimen_review_master_id));
	if(!$this->SpecimenReviewMaster->save($data_to_udpate, false)) $this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true);
	