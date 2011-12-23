<?php

foreach($this->data as &$new_data_set) {
	$new_data_set['children'][0]['AliquotMaster']['aliquot_label'] = $new_data_set['parent']['AliquotMaster']['aliquot_label'];
	$new_data_set['children'][0]['AliquotMaster']['qc_hb_stored_by'] = 'louise rousseau';
}

?>