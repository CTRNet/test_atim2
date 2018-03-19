<?php
foreach ($this->request->data as &$tmpNewDataSet) {
    $tmpMaxRes = $this->TmaSlide->find('first', array(
        'conditions' => array(
            'TmaSlide.tma_block_storage_master_id' => $tmpNewDataSet['parent']['Block']['id']
        ),
        'fields' => array(
            'MAX(TmaSlide.qc_tf_cpcbn_section_id) AS last_id'
        )
    ));
    $tmpNewDataSet['children'][0]['TmaSlide']['qc_tf_cpcbn_section_id'] = empty($tmpMaxRes) ? '1' : ($tmpMaxRes[0]['last_id'] + 1);
}