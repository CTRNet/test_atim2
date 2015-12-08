<?php

class TreatmentMasterCustom extends TreatmentMaster {
	var $useTable = 'treatment_masters';
	var $name = 'TreatmentMaster';
	
	function beforeSave($options = array()){
		if(array_key_exists('TreatmentDetail', $this->data) && array_key_exists('her2_fish', $this->data['TreatmentDetail'])) {
			
			$her2_fish = $this->data['TreatmentDetail']['her2_fish'];
			$her2_ihc = $this->data['TreatmentDetail']['her2_ihc'];
			$er_overall = $this->data['TreatmentDetail']['er_overall'];
			$pr_overall = $this->data['TreatmentDetail']['pr_overall'];
			
			// TNBC
			$her_2_status = '';
			switch($her2_fish) {
				case 'positive':
					$her_2_status = 'positive';
					break;
				case 'negative':
					$her_2_status = 'negative';
					break;
				case 'equivocal':
					if($her2_ihc == 'positive') $her_2_status = 'positive';
					if($her2_ihc == 'negative') $her_2_status = 'equivocal';
					break;
				case 'unknown':
					if($her2_ihc == 'positive') $her_2_status = 'positive';
					if($her2_ihc == 'negative') $her_2_status = 'negative';
			}
			
			// HER2 Status
			$tnbc = '';
			if($her_2_status == 'negative' && $er_overall == 'negative' && $pr_overall == 'negative' ) {
				$tnbc = 'yes';
			} else if($her_2_status == 'positive' || $er_overall == 'positive' || $pr_overall == 'positive' ) {
				$tnbc = 'no';
			} else if($her_2_status == 'unknown' || $er_overall == 'unknown' || $pr_overall == 'unknown' ) {
				$tnbc = 'unknown';
			} else if($her_2_status == 'equivocal' && $er_overall == 'negative' && $pr_overall == 'negative' ) {
				$tnbc = 'equivocal';
			}

			$this->data['TreatmentDetail']['tnbc'] = $tnbc;
			$this->data['TreatmentDetail']['her_2_status'] = $her_2_status;
			$this->addWritableField(array('tnbc', 'her_2_status'));
		}
		$ret_val = parent::beforeSave($options);
		return $ret_val; 
	}
}
			
?>