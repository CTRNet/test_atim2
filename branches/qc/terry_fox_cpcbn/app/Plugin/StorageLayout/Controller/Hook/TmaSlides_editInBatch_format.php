<?php
$pasteDisabledStudySummaryId = true;
$pasteDisabledQcTfCpcbnShippingDate = false;
$pasteDisabledQcTfCpcbnClinicalDataVersion = false;
if ($initialSlideData && sizeof($initialSlideData) > 1) {
    foreach ($initialSlideData as $tmpNewData) {
        if (! $tmpNewData['TmaSlide']['study_summary_id'])
            $pasteDisabledStudySummaryId = false;
        if ($tmpNewData['TmaSlide']['qc_tf_cpcbn_shipping_date'])
            $pasteDisabledQcTfCpcbnShippingDate = true;
        if ($tmpNewData['TmaSlide']['qc_tf_cpcbn_clinical_data_version'])
            $pasteDisabledQcTfCpcbnClinicalDataVersion = true;
    }
}
$this->set('pasteDisabledStudySummaryId', $pasteDisabledStudySummaryId);
$this->set('pasteDisabledQcTfCpcbnShippingDate', $pasteDisabledQcTfCpcbnShippingDate);
$this->set('pasteDisabledQcTfCpcbnClinicalDataVersion', $pasteDisabledQcTfCpcbnClinicalDataVersion);