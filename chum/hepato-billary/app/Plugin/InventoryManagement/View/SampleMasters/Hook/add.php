<?php
if ($qcHbSampleCode && ! strlen($finalOptions['override']['SpecimenDetail.qc_hb_sample_code'])) {
    $finalOptions['override']['SpecimenDetail.qc_hb_sample_code'] = $qcHbSampleCode;
}