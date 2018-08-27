<?php
if (in_array($createdSampleStructureOverride['SampleControl.sample_type'], array(
    'dna',
    'rna'
))) {
    if (isset($finalOptionsParent['data']['AliquotDetail']['cell_passage_number'])) {
        $finalOptionsChildren['override']['SampleDetail.source_cell_passage_number'] = $finalOptionsParent['data']['AliquotDetail']['cell_passage_number'];
    }
    
    if (isset($finalOptionsParent['data']['StorageMaster']['temperature'])) {
        $finalOptionsChildren['override']['SampleDetail.source_temperature'] = $finalOptionsParent['data']['StorageMaster']['temperature'];
        $finalOptionsChildren['override']['SampleDetail.source_temp_unit'] = $finalOptionsParent['data']['StorageMaster']['temp_unit'];
    }
    
    if (isset($finalOptionsParent['data']['AliquotDetail']['tmp_storage_solution'])) {
        $finalOptionsChildren['override']['SampleDetail.tmp_source_milieu'] = $finalOptionsParent['data']['AliquotDetail']['tmp_storage_solution'];
    }
    
    if (isset($finalOptionsParent['data']['AliquotDetail']['tmp_storage_mothod'])) {
        $finalOptionsChildren['override']['SampleDetail.tmp_source_storage_method'] = $finalOptionsParent['data']['AliquotDetail']['tmp_storage_method'];
    }
}