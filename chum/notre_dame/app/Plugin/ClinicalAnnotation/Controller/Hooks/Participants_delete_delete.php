<?php
	
	if ($arr_allow_deletion['allow_deletion']) {
		if ( $this->Participant->atim_delete( $participant_id ) ) {
			$this->atimFlash('your data has been deleted', '/clinicalannotation/misc_identifiers/search/');
		} else {
			$this->flash( 'error deleting data - contact administrator', '/clinicalannotation/misc_identifiers/search/');
		}
	} else {
		$this->flash( $arr_allow_deletion['msg'], '/clinicalannotation/participants/profile/'.$participant_id.'/');
	}
	return;
			
?>