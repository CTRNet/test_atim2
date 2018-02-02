<?php

// --------------------------------------------------------------------------------
// Generate buttons 'add medical history summary' & 'add medical imaging summary'
// --------------------------------------------------------------------------------
if (! $eventControlId) {
    $eventControlsForAddLinks = array();
    $summaryEventButton = array();
    foreach ($eventControls as $id => $newControl) {
        if (in_array($newControl['EventControl']['detail_tablename'], array(
            'qc_hb_ed_hepatobiliary_med_hist_record_summaries',
            'qc_hb_ed_medical_imaging_record_summaries',
            'qc_hb_ed_score_fongs',
            'qc_hb_ed_score_child_pughs'
        ))) {
            $summaryEventButton[] = array(
                'title' => __($newControl['EventControl']['event_type']) . (empty($newControl['EventControl']['disease_site']) ? '' : ' - ' . __($newControl['EventControl']['disease_site'])),
                'link' => '/ClinicalAnnotation/EventMasters/add/' . $participantId . '/' . $newControl['EventControl']['id']
            );
        } else {
            $eventControlsForAddLinks[$id] = $newControl;
        }
    }
    if (sizeof($eventControls) != sizeof($eventControlsForAddLinks)) {
        $addLinks = $this->EventControl->buildAddLinks($eventControlsForAddLinks, $participantId, $eventGroup);
        $this->set('addLinks', $addLinks);
    }
    if (! empty($summaryEventButton))
        $this->set('summaryEventButton', $summaryEventButton);
}

if ($eventControlId == '-1') {
    // 2 - DISPLAY ALL EVENTS THAT SHOULD BE DISPLAYED IN MASTER VIEW
    $this->Structures->set('eventmasters,qc_hb_imaging_result,qc_hb_imaging_dateNSummary');
}
