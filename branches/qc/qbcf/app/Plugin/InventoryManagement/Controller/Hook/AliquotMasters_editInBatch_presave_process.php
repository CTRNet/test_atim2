<?php
if(isset($this->request->data['AliquotDetail']['qbcf_block_selected']) && strlen($this->request->data['AliquotDetail']['qbcf_block_selected'])) {
    $aliquot_master_data_to_update['AliquotDetail']['qbcf_block_selected'] = $this->request->data['AliquotDetail']['qbcf_block_selected'];
    if(!$aliquot_master_data_to_update['AliquotMaster']){
        !$aliquot_master_data_to_update['AliquotMaster']['qbcf_force_update'] = '-';
    }
}