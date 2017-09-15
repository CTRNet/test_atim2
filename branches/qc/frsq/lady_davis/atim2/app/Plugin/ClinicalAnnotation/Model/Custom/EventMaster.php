<?php

class EventMasterCustom extends EventMaster
{

    var $name = "EventMaster";

    var $tableName = "event_masters";

    function afterSave($created, $options = Array())
    {
        $DiagnosisMaster = AppModel::getInstance("ClinicalAnnotation", "DiagnosisMaster", true);
        if (isset($this->data['EventMaster']['diagnosis_master_id']) && $this->data['EventMaster']['diagnosis_master_id'])
            $DiagnosisMaster->validateLaterality($this->data['EventMaster']['diagnosis_master_id']);
        parent::afterSave($created);
    }
}

?>