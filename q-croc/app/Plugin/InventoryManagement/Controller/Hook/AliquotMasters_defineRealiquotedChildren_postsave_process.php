<?php
	
	if($parent_aliquot_ctrl['AliquotControl']['aliquot_type'] == 'tube'
	&& $child_aliquot_ctrl['AliquotControl']['aliquot_type'] == 'block'
	&& (strpos($parent_aliquot_ctrl['AliquotControl']['detail_form_alias'], 'qcroc_ad_tissue_tubes') !== false)) {
		$aliquots_already_updated = array();
		foreach($this->request->data as $tmp_new_set) {
			$tmp_key = $tmp_new_set['parent']['AliquotMaster']['collection_id'].'-'.$tmp_new_set['parent']['AliquotMaster']['sample_master_id'].'-'.$tmp_new_set['parent']['AliquotMaster']['id'];
			if(!in_array($tmp_key, $aliquots_already_updated)) {
				$this->AliquotMaster->updateTimeRemainedInRNAlater($tmp_new_set['parent']['AliquotMaster']['collection_id'], $tmp_new_set['parent']['AliquotMaster']['sample_master_id'], $tmp_new_set['parent']['AliquotMaster']['id']);
			}
			$aliquots_already_updated[] = $tmp_key;
		}
	}
	

?>
