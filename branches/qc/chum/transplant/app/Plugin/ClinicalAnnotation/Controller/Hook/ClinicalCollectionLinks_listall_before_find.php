<?php
$joins[] = array(
    'table' => 'qc_nd_txd_sardos',
    'alias' => 'TreatmentDetail',
    'type' => 'LEFT',
    'conditions' => array(
        'TreatmentDetail.treatment_master_id = treatment_masters_dup.id'
    )
);