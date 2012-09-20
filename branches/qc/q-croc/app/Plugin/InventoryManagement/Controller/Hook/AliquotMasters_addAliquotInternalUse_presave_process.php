<?php 

	if($qcroc_is_transfer && empty($errors)) {
		foreach($this->request->data as &$qcroc_tmp_1) {
			foreach($qcroc_tmp_1['children'] as &$qcroc_tmp_2) {
				$qcroc_tmp_2['AliquotInternalUse']['qcroc_is_transfer'] = 1;
			}
		}
		$this->AliquotInternalUse->addWritableField(array('qcroc_is_transfer'));
	}
	
	
	
	

	
	
	