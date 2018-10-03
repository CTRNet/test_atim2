<?php

class EventControlCustom extends EventControl
{

    var $useTable = 'event_controls';

    var $name = 'EventControl';

    public function buildAddLinks($eventCtrlData, $participantId, $eventGroup)
    {
        $links = array();
        foreach ($eventCtrlData as $eventCtrl) {
            $links[] = array(
                'order' => $eventCtrl['EventControl']['display_order'],
                'label' => __($eventCtrl['EventControl']['event_type']),
                'link' => '/ClinicalAnnotation/EventMasters/add/' . $participantId . '/' . $eventCtrl['EventControl']['id']
            );
        }
        AppController::buildBottomMenuOptions($links);
        return $links;
    }
}