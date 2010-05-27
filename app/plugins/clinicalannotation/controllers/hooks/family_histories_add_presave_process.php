<?php
	/*
	 * Created on 2009-11-26
	 * Author NL
	 *
	 * Offer an example of hooks code for custom code developper.
	 * This hook will be call before to save data to allow custom code to manipulate submitted data:
	 * 	- launch additional validation
	 *    - set additional data
	 
	
	if ( Configure::read('debug') ) { 
		if(($this->data['FamilyHistory']['age_at_dx'] == '-999') || ($this->data['FamilyHistory']['age_at_dx'] == '???')) {
			$this->data['FamilyHistory']['age_at_dx'] = '???';
			$this->FamilyHistory->validationErrors[] = 'looks like my hook example has not been modified';
			$this->FamilyHistory->validationErrors['age_at_dx'] = 'hooks message: age equal -999!!!!';
			$submitted_data_validates = false;
		}
	}
	*/
 	
?>
