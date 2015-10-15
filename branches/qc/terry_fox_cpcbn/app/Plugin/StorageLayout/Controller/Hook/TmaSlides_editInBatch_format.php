<?php 

	$paste_disabled_study_summary_id = true;
	$paste_disabled_qc_tf_cpcbn_shipping_date = true;
	$paste_disabled_qc_tf_cpcbn_clinical_data_version = true;
	if(sizeof($slides_data) > 1) {
		foreach($slides_data as $tmp_new_data) {
			if(!$tmp_new_data['TmaSlide']['study_summary_id']) $paste_disabled_study_summary_id = false;
			if(!$tmp_new_data['TmaSlide']['qc_tf_cpcbn_shipping_date']) $paste_disabled_qc_tf_cpcbn_shipping_date = false;
			if(!$tmp_new_data['TmaSlide']['qc_tf_cpcbn_clinical_data_version']) $paste_disabled_qc_tf_cpcbn_clinical_data_version = false;
		}
	}
	$this->set('paste_disabled_study_summary_id', $paste_disabled_study_summary_id);
	$this->set('paste_disabled_qc_tf_cpcbn_shipping_date', $paste_disabled_qc_tf_cpcbn_shipping_date);
	$this->set('paste_disabled_qc_tf_cpcbn_clinical_data_version', $paste_disabled_qc_tf_cpcbn_clinical_data_version);

?>