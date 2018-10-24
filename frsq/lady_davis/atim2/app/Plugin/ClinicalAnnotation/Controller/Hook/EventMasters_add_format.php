<?php
$this->Structures->set('view_diagnosis,qc_lady_diagnosis_tree_view', 'diagnosisStructure');
$this->set('isImagingEventControl', ($eventControlData['EventControl']['event_type'] == 'imaging')? true : false);