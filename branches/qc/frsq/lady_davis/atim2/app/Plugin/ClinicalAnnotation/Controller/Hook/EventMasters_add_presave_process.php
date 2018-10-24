<?php
if (($eventControlData['EventControl']['event_type'] == 'imaging')) {
    foreach ($this->request->data as &$newEvent) {
        $newEvent['EventMaster']['diagnosis_master_id'] = $newEvent['FunctionManagement']['diagnosis_master_id'];
        unset($newEvent['FunctionManagement']);
    }
}