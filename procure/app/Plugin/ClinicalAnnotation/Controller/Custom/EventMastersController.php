<?php

class EventMastersControllerCustom extends EventMastersController
{

    var $paginate = array(
        'EventMaster' => array(
            'limit' => pagination_amount,
            'order' => 'EventMaster.event_date DESC'
        )
    );

    public function listallBasedOnControlId($participantId, $eventControlId, $intervalStartDate = null, $intervalStartDateAccuracy = null, $intervalFinishDate = null, $intervalFinishDateAccuracy = null)
    {
        // *** Specific list display based on control_id
        $participantData = $this->Participant->getOrRedirect($participantId);
        $this->set('atimMenuVariables', array(
            'Participant.id' => $participantId
        ));
        $this->set('atimMenu', $this->Menus->get('/ClinicalAnnotation/EventMasters/listall/Clinical/%%Participant.id%%'));
        $eventControl = $this->EventControl->getOrRedirect($eventControlId);
        $this->Structures->set($eventControl['EventControl']['form_alias']);
        if (is_null($intervalStartDate) && is_null($intervalFinishDate)) {
            // 1- No Date Restriction
            $this->request->data = $this->paginate($this->EventMaster, array(
                'EventMaster.participant_id' => $participantId,
                'EventMaster.event_control_id' => $eventControlId
            ));
        } else {
            // 2- Date Restriction
            $intervalStartDate = preg_match('/^[0-9]{4}\-[0-9]{2}\-[0-9]{2}$/', $intervalStartDate) ? $intervalStartDate : '';
            $intervalFinishDate = preg_match('/^[0-9]{4}\-[0-9]{2}\-[0-9]{2}$/', $intervalFinishDate) ? $intervalFinishDate : '';
            $eventsListConditions = array(
                'EventMaster.participant_id' => $participantId,
                'EventMaster.event_control_id' => $eventControlId
            );
            if ($intervalStartDate && $intervalFinishDate) {
                $eventsListConditions[]['OR'] = array(
                    "EventMaster.event_date IS NULL",
                    "EventMaster.event_date IS NOT NULL AND '$intervalStartDate' <= EventMaster.event_date  AND EventMaster.event_date <= '$intervalFinishDate'"
                );
            } elseif ($intervalStartDate) {
                $eventsListConditions[]['OR'] = array(
                    "EventMaster.event_date IS NULL",
                    "EventMaster.event_date IS NOT NULL AND EventMaster.event_date >= '$intervalStartDate'"
                );
            } elseif ($intervalFinishDate) {
                $eventsListConditions[]['OR'] = array(
                    "EventMaster.event_date IS NULL",
                    "EventMaster.event_date IS NOT NULL AND EventMaster.event_date <= '$intervalFinishDate'"
                );
            }
            $this->request->data = $this->paginate($this->EventMaster, $eventsListConditions);
        }
    }
}