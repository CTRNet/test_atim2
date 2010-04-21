<?php
	
	// --------------------------------------------------------------------------------
	// Set default data
	// -------------------------------------------------------------------------------- 	
 	if(isset($default_origin)) { 
 		$final_options['override']['DiagnosisMaster.dx_origin'] = $default_origin;
 	}
 	 if(isset($default_tnm_version)) { 
 		$final_options['override']['DiagnosisDetail.ptnm_version'] = $default_tnm_version;
 	}
 	
?>
