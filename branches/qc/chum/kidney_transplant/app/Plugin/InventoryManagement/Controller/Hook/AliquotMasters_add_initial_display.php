<?php
foreach ($this->request->data as &$newSampleRecord) {
    if (isset($defaultAliquotLabels[$newSampleRecord['parent']['ViewSample']['sample_master_id']])) {
        $labelNbrPrefix = $defaultAliquotLabels[$newSampleRecord['parent']['ViewSample']['sample_master_id']]['label_nbr_prefix'];
        $nbrOfAliquots = sizeof($newSampleRecord['children']);
        $aliquotCounter = 0;
        foreach ($newSampleRecord['children'] as &$newAliquotRecord) {
            $aliquotCounter ++;
            $newAliquotRecord['AliquotMaster']['chum_kidney_transp_aliquot_nbr'] = (strlen($labelNbrPrefix) ? "$labelNbrPrefix " : "") . "$aliquotCounter/$nbrOfAliquots";
        }
    }
}
