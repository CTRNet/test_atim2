<?php

foreach($this->data as &$new_data_set) {
	$new_data_set['children'][0]['AliquotMaster']['aliquot_label'] = $this->AliquotMaster->generateDefaultAliquotLabel($new_data_set['parent']['ViewSample']['sample_master_id'], $aliquot_control);
	$new_data_set['children'][0]['AliquotMaster']['qc_hb_stored_by'] = 'louise rousseau';
}

?>