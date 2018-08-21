<?php
$tmpQbcfAliquotMasterIds = array();
if (isset($this->request->data['ViewAliquot']['aliquot_master_id'])) {
    $tmpQbcfAliquotMasterIds = array_filter($this->request->data['ViewAliquot']['aliquot_master_id']);
} elseif (isset($this->request->data['aliquot_ids'])) {
    $tmpQbcfAliquotMasterIds = explode(',', $this->request->data['aliquot_ids']);
}
if ($tmpQbcfAliquotMasterIds) {
    $tmpAliquotControls = $this->AliquotMaster->find('all', array(
        'conditions' => array(
            'AliquotMaster.id' => $tmpQbcfAliquotMasterIds
        ),
        'fields' => array(
            "DISTINCT CONCAT(SampleControl.sample_type,'-',AliquotControl.aliquot_type) AS sample_aliquot_types"
        )
    ));
    if (sizeof($tmpAliquotControls) == '1' && $tmpAliquotControls[0][0]['sample_aliquot_types'] == 'tissue-block') {
        $this->Structures->set('aliquot_master_edit_in_batchs,qbcf_ad_spec_tiss_blocks');
    }
}