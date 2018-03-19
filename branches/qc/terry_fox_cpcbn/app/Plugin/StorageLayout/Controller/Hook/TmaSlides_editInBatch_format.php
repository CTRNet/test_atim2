<?php
$pasteDisabledStudySummaryId = true;
$pasteDisabledQcTfCpcbnShippingDate = true;
$pasteDisabledQcTfCpcbnClinicalDataVersion = true;
if (sizeof($slidesData) > 1) {
    foreach ($slidesData as $tmpNewData) {
        if (! $tmpNewData['TmaSlide']['study_summary_id'])
            $pasteDisabledStudySummaryId = false;
        if (! $tmpNewData['TmaSlide']['qc_tf_cpcbn_shipping_date'])
            $pasteDisabledQcTfCpcbnShippingDate = false;
        if (! $tmpNewData['TmaSlide']['qc_tf_cpcbn_clinical_data_version'])
            $pasteDisabledQcTfCpcbnClinicalDataVersion = false;
    }
}
$this->set('pasteDisabledStudySummaryId', $pasteDisabledStudySummaryId);
$this->set('pasteDisabledQcTfCpcbnShippingDate', $pasteDisabledQcTfCpcbnShippingDate);
$this->set('pasteDisabledQcTfCpcbnClinicalDataVersion', $pasteDisabledQcTfCpcbnClinicalDataVersion);