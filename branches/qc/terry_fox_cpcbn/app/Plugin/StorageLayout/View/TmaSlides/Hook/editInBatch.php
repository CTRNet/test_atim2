<?php

// --------------------------------------------------------------------------------
// Prevent the paste operation on ...
// --------------------------------------------------------------------------------
$finalOptions['settings']['paste_disabled_fields'] = array(
    'TmaSlide.qc_tf_cpcbn_section_id',
    'TmaSlide.qc_tf_cpcbn_slide_type',
    'TmaSlide.qc_tf_cpcbn_sectionning_date',
    'TmaSlide.qc_tf_cpcbn_thickness',
    'TmaSlide.qc_tf_cpcbn_quality_assessment',
    'TmaSlide.qc_tf_cpcbn_paraffin_protection',
    'TmaSlide.qc_tf_cpcbn_notes'
);
if ($pasteDisabledStudySummaryId)
    $finalOptions['settings']['paste_disabled_fields'][] = 'TmaSlide.study_summary_id';
if ($pasteDisabledQcTfCpcbnShippingDate)
    $finalOptions['settings']['paste_disabled_fields'][] = 'TmaSlide.qc_tf_cpcbn_shipping_date';
if ($pasteDisabledQcTfCpcbnClinicalDataVersion)
    $finalOptions['settings']['paste_disabled_fields'][] = 'TmaSlide.qc_tf_cpcbn_clinical_data_version';