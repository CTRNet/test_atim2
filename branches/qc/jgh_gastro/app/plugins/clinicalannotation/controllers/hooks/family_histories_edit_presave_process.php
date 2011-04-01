<?php
if(strlen($this->data['FamilyHistory']['qc_gastro_cancer_type_other']) > 0 && $this->data['FamilyHistory']['qc_gastro_cancer_type'] != 'other'){
	$submitted_data_validates = false;
	$this->FamilyHistory->validationErrors['qc_gastro_cancer_type_other'] = __('you must either select a cancer type and leave the other field blank or select other and fill the other field', true);
}
?>