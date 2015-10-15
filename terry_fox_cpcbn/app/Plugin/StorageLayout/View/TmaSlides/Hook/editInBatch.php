<?php 

	// --------------------------------------------------------------------------------
	// Prevent the paste operation on ...
	// -------------------------------------------------------------------------------- 
	$final_options['settings']['paste_disabled_fields'] = array(
		'TmaSlide.qc_tf_cpcbn_section_id',
		'TmaSlide.qc_tf_cpcbn_slide_type',
		'TmaSlide.qc_tf_cpcbn_sectionning_date',
		'TmaSlide.qc_tf_cpcbn_thickness',
		'TmaSlide.qc_tf_cpcbn_quality_assessment',
		'TmaSlide.qc_tf_cpcbn_paraffin_protection',
		'TmaSlide.qc_tf_cpcbn_notes');	
	if($paste_disabled_study_summary_id) $final_options['settings']['paste_disabled_fields'][] = 'TmaSlide.study_summary_id';
	if($paste_disabled_qc_tf_cpcbn_shipping_date) $final_options['settings']['paste_disabled_fields'][] = 'TmaSlide.qc_tf_cpcbn_shipping_date';
	if($paste_disabled_qc_tf_cpcbn_clinical_data_version) $final_options['settings']['paste_disabled_fields'][] = 'TmaSlide.qc_tf_cpcbn_clinical_data_version';

?>
