<?php
	/*
	 * Created on 2009-11-26
	 * Author NL
	 *
	 * Offer an example of hooks code for custom code developper.
	 * This hook will be call before to display form.
	 */
	
	if ( Configure::read('debug') ) { 	
		if ( empty($this->data) ) { 
				$this->set('example_age_at_diagnosis', '-999');
		} 
	}
 	
?>
