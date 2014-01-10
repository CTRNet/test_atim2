<?php

class TreatmentMasterCustom extends TreatmentMaster {
	var $useTable = 'treatment_masters';
	var $name = 'TreatmentMaster';
	
	
	function summary( $variables=array() ) {
		$return = false;
	
		if ( isset($variables['TreatmentMaster.id']) ) {
			$result = $this->find('first', array('conditions'=>array('TreatmentMaster.id'=>$variables['TreatmentMaster.id'])));
			$title = __($result['TreatmentControl']['tx_method'], TRUE);
			if(isset($result['TreatmentDetail']['transplant_number'])) $title .= ' '.$result['TreatmentDetail']['transplant_number'];
			$return = array(
					'menu'    			=> array( NULL, $title),
					'title'	 			=> array( NULL, $title),
					'data'				=> $result,
					'structure alias'	=> 'treatmentmasters'
			);
		}
	
		return $return;
	}
	
	function beforeSave($options = array()){
		$ret_val = parent::beforeSave();
		if(isset($this->data['TreatmentDetail']['donor_status']) && isset($this->data['TreatmentDetail']['previous_transplant'])) {
			$this->addWritableField(array('transplant_number'));
			$this->data['TreatmentDetail']['transplant_number'] = (($this->data['TreatmentDetail']['donor_status'] == 'alive')? 'DV' : 'DC').($this->data['TreatmentDetail']['previous_transplant']+1);
		}
		return $ret_val;
	}
}

?>