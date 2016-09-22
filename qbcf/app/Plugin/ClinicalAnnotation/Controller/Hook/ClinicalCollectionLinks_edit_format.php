<?php 

$this->DiagnosisControl = AppModel::getInstance("ClinicalAnnotation", "DiagnosisControl", true);
$breast_dx_controls = $this->DiagnosisControl->find('first', array('conditions' => array('DiagnosisControl.controls_type' => 'breast')));
$diagnosis_data = $this->DiagnosisMaster->find('threaded', array('conditions' => array('DiagnosisMaster.deleted' => '0', 'DiagnosisMaster.participant_id' => $participant_id, 'DiagnosisMaster.diagnosis_control_id' => $breast_dx_controls['DiagnosisControl']['id'])));
//because diagnosis has a one to many relation with participant, we need to format it
$found_dx = $this->DiagnosisMaster->arrangeThreadedDataForView($diagnosis_data, (isset($data_for_form['Collection']['diagnosis_master_id'])? $data_for_form['Collection']['diagnosis_master_id'] : null), 'Collection');
$this->set( 'diagnosis_data', $diagnosis_data );
$this->set('found_dx', $found_dx);

?>