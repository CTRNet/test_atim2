<?php

class EventControlCustom extends EventControl
{

    var $useTable = 'event_controls';

    var $name = "EventControl";

    var $modifiableEventTypes = array(
        'ca125',
        'ccf follow-up',
        'fides clinic follow-up',
        'genetic test',
        'ghadirian form',
        'immuncarta',
        'megaprofiling',
        'other marker',
        'prostate nodule review',
        'prostate pathology review',
        'psa',
        'scc',
        'vph'
    );

    public function buildAddLinks($eventCtrlData, $participantId, $eventGroup)
    {
        $links = array();
        foreach ($eventCtrlData as $eventCtrl) {
            if (in_array($eventCtrl['EventControl']['event_type'], $this->modifiableEventTypes)) {
                $links[] = array(
                    'order' => $eventCtrl['EventControl']['display_order'],
                    'label' => __($eventCtrl['EventControl']['event_type']) . (empty($eventCtrl['EventControl']['disease_site']) ? '' : ' - ' . __($eventCtrl['EventControl']['disease_site'])),
                    'link' => '/ClinicalAnnotation/EventMasters/add/' . $participantId . '/' . $eventCtrl['EventControl']['id']
                );
            }
        }
        AppController::buildBottomMenuOptions($links);
        return $links;
    }
}