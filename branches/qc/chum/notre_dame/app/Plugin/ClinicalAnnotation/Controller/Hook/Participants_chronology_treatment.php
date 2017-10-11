<?php
if (isset($tx['TreatmentMaster']['qc_nd_sardo_tx_detail_summary'])) {
    $chronolgyDataTreatmentStart['chronology_details'] = $tx['TreatmentMaster']['qc_nd_sardo_tx_detail_summary'];
    if ($chronolgyDataTreatmentFinish) {
        $chronolgyDataTreatmentFinish['chronology_details'] = $tx['TreatmentMaster']['qc_nd_sardo_tx_detail_summary'];
    }
}