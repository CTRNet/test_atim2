<?php 
	
	if(isset($chum_patho_default_category[$parent['AliquotMaster']['id']])) {
		$final_options_children['override']['AliquotDetail.chum_patho_category'] = $chum_patho_default_category[$parent['AliquotMaster']['id']];
	}
	
?>
