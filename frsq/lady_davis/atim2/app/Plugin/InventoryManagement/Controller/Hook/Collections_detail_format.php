<?php
$tmpControls = array();
foreach ($controls as $key => $newSampContrlData) {
    if ($this->request->data['ViewCollection']['qc_lady_specimen_type'] == $newSampContrlData['SampleControl']['sample_type'])
        $tmpControls[$key] = $newSampContrlData;
}
$this->set('specimenSampleControlsList', $tmpControls);