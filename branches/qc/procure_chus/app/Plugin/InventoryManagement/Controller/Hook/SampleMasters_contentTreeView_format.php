<?php
if (Configure::read('procure_atim_version') == 'CENTRAL') {
    foreach ($this->request->data as &$treeNode) {
        if (isset($treeNode['AliquotMaster'])) {
            if ($this->Realiquoting->find('count', array(
                'conditions' => array(
                    'Realiquoting.parent_aliquot_master_id' => $treeNode['AliquotMaster']['id'],
                    'Realiquoting.procure_central_is_transfer' => '1'
                ),
                'recursive' => -1
            ))) {
                // Aliquot of a bank transferred to the processing site
                $keysDisabled = array_keys($treeNode['css'], 'disabled');
                if (! $keysDisabled) {
                    $treeNode['css'][] = 'transfered_bank_aliquot';
                } else {
                    foreach ($keysDisabled as $newKey)
                        unset($treeNode['css'][$newKey]);
                    $treeNode['css'][] = 'disabled_transfered_bank_aliquot';
                }
            }
        }
    }
}