<?php

	if ( empty($this->request->data) && $display_add_form && $controls['MiscIdentifierControl']['misc_identifier_name'] == 'lab id') {
		$next_lab_id_int = $this->MiscIdentifier->getNextLabId();
		$this->set('next_lab_id', 'DG'.$next_lab_id_int);
	}
	
?>