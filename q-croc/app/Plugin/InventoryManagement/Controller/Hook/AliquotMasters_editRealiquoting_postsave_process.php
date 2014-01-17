<?php

	if(strpos($data['AliquotControl']['detail_form_alias'], 'qcroc_ad_tissue_tubes') !== false) {
		$this->AliquotMaster->updateTimeRemainedInRNAlater($data['AliquotMaster']['collection_id'], $data['AliquotMaster']['sample_master_id'], $data['AliquotMaster']['id']);
	}

?>
