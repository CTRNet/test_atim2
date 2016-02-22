<?php

	foreach($this->request->data as &$tmps_data_set) {
		$tmp_view_aliquot_data = $this->ViewAliquot->find('first', array('conditions' => array('aliquot_master_id' => $tmps_data_set['parent']['AliquotMaster']['id']), 'recursive' => '-1'));
		$tmps_data_set['parent'] = array_merge($tmps_data_set['parent'], $tmp_view_aliquot_data);
	}
	