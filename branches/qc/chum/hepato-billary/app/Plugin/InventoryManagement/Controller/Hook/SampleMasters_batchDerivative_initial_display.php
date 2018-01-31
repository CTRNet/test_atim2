<?php
$customCreatedSampleOverrideData = array(
    'DerivativeDetail.creation_site' => 'cr. st-luc',
    'DerivativeDetail.creation_by' => 'louise rousseau'
);
if ($childrenControlData['SampleControl']['sample_type'] == 'tissue suspension') {
    $customCreatedSampleOverrideData['SampleDetail.qc_hb_macs_enzymatic_milieu'] = 'collagenase + dnase';
}
$this->set('customCreatedSampleOverrideData', $customCreatedSampleOverrideData);