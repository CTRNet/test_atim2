<?php
$tmp_qbcf_aliquot_master_ids = array();
if(isset($this->request->data['ViewAliquot']['aliquot_master_id'])) {
    $tmp_qbcf_aliquot_master_ids = array_filter($this->request->data['ViewAliquot']['aliquot_master_id']);
} elseif(isset($this->request->data['aliquot_ids'])) {
    $tmp_qbcf_aliquot_master_ids = explode(',', $this->request->data['aliquot_ids']);
}
if($tmp_qbcf_aliquot_master_ids) {
    $tmp_aliquot_controls = $this->AliquotMaster->find('all', array('conditions' => array('AliquotMaster.id' => $tmp_qbcf_aliquot_master_ids), 'fields' => array("DISTINCT CONCAT(SampleControl.sample_type,'-',AliquotControl.aliquot_type) AS sample_aliquot_types")));
    if(sizeof($tmp_aliquot_controls) == '1' && $tmp_aliquot_controls[0][0]['sample_aliquot_types'] == 'tissue-block') {
        $this->Structures->set('aliquot_master_edit_in_batchs,qbcf_ad_spec_tiss_blocks'); 
    }
}