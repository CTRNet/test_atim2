<?php
if (Configure::read('procure_atim_version') == 'CENTRAL') {
    foreach ($this->request->data as &$tree_node) {
        if (isset($tree_node['AliquotMaster'])) {
            if ($this->Realiquoting->find('count', array(
                'conditions' => array(
                    'Realiquoting.parent_aliquot_master_id' => $tree_node['AliquotMaster']['id'],
                    'Realiquoting.procure_central_is_transfer' => '1'
                ),
                'recursive' => '-1'
            ))) {
                // Aliquot of a bank transferred to the processing site
                $keys_disabled = array_keys($tree_node['css'], 'disabled');
                if (! $keys_disabled) {
                    $tree_node['css'][] = 'transfered_bank_aliquot';
                } else {
                    foreach ($keys_disabled as $new_key)
                        unset($tree_node['css'][$new_key]);
                    $tree_node['css'][] = 'disabled_transfered_bank_aliquot';
                }
            }
        }
    }
}

	
	