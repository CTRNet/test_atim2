<?php

/*
 * Created on 2009-11-26
 * Author NL
 *
 * Offer an example of code override.
 */
class EventMastersControllerCustom extends EventMastersController
{

    public function imageryReport($participantId)
    {
        $conditions = array(
            'EventMaster.participant_id' => $participantId,
            'EventControl.flag_active' => '1',
            "EventControl.event_group LIKE 'imagery'"
        );
        $this->request->data = $this->EventMaster->find('all', array(
            'conditions' => $conditions,
            'order' => 'EventMaster.event_date DESC'
        ));
        $detailLinkParameters = array();
        foreach ($this->request->data as $key => $record) {
            $this->request->data[$key]['EventMaster']['formated_event_date'] = $this->getFormatedDatetimeString($this->request->data[$key]['EventMaster']['event_date']);
        }
        $this->Structures->set('empty');
        $atimMenuVariables['Participant.id'] = $participantId;
        $this->set('atimMenuVariables', $atimMenuVariables);
        $this->set('atimMenu', $this->Menus->get('/ClinicalAnnotation/EventMasters/imageryReport/%%Participant.id%%/'));
    }
}