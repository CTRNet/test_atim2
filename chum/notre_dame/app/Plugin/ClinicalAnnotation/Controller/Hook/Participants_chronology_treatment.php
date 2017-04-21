<?php 
	
if(isset($tx['Generated']['qc_nd_sardo_tx_detail_summary'])) {
	$chronolgy_data_treatment_start['chronology_details'] = $tx['Generated']['qc_nd_sardo_tx_detail_summary'];
	if($chronolgy_data_treatment_finish){
		$chronolgy_data_treatment_finish['chronology_details'] = $tx['Generated']['qc_nd_sardo_tx_detail_summary'];
	}
}