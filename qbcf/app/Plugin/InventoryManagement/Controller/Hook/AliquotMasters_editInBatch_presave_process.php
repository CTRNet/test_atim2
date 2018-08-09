<?php
if(isset($this->request->data['AliquotDetail']['qbcf_block_selected']) && strlen($this->request->data['AliquotDetail']['qbcf_block_selected'])) {
    $aliquotMasterDataToUpdate['AliquotDetail']['qbcf_block_selected'] = $this->request->data['AliquotDetail']['qbcf_block_selected'];
    if(!$aliquotMasterDataToUpdate['AliquotMaster']){
        !$aliquotMasterDataToUpdate['AliquotMaster']['qbcf_force_update'] = '-';
    }
}