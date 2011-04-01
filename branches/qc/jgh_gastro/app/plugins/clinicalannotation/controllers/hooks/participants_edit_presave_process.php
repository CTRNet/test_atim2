<?php 
unset($this->data['Participant']['id']);
if(strlen($this->data['Participant']['qc_gastro_race_other']) > 0 && $this->data['Participant']['race'] != 'other'){
	$submitted_data_validates = false;
	$this->Participant->validationErrors['qc_gastro_race_other'] = __('you must either select a race and leave the other field blank or select other and fill the other field', true);
}
?>