<?php 

$this->DiagnosisControl = AppModel::getInstance("ClinicalAnnotation", "DiagnosisControl", true);
$breast_dx_controls = $this->DiagnosisControl->find('first', array('conditions' => array('DiagnosisControl.controls_type' => 'breast')));
$diagnosis_data = $this->DiagnosisMaster->find('threaded', array('conditions' => array('DiagnosisMaster.participant_id' => $participant_id, 'DiagnosisMaster.diagnosis_control_id' => $breast_dx_controls['DiagnosisControl']['id'])));
$found_dx = false;
if(isset($this->request->data['Collection']['diagnosis_master_id'])){
	$found_dx = $this->DiagnosisMaster->arrangeThreadedDataForView($diagnosis_data, $this->request->data['Collection']['diagnosis_master_id'], 'Collection');
}
$this->set('diagnosis_data', $diagnosis_data );
$this->set('found_dx', $found_dx );

?>