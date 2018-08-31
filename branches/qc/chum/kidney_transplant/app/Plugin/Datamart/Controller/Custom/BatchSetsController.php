<?php

class BatchSetsControllerCustom extends BatchSetsController
{

    /**
     *
     * @param $batchSetId
     */
    public function listall($batchSetId)
    {
        parent::listall($batchSetId);
        $batchSet = $this->BatchSet->getOrRedirect($batchSetId);
        if (in_array($batchSet['DatamartStructure']['model'], array(
            'ViewSample',
            'ViewAliquot'
        ))) {
            pr('la');
            $lookupIds = array();
            foreach ($batchSet['BatchId'] as $fields) {
                $lookupIds[] = $fields['lookup_id'];
            }
            $tmpModel = AppModel::getInstance($batchSet['DatamartStructure']['plugin'], $batchSet['DatamartStructure']['model'], true);
            $batchSetBiohazard = $tmpModel->find('first', array(
                'conditions' => array(
                    $batchSet['DatamartStructure']['model'] . '.' . ($batchSet['DatamartStructure']['model'] == 'ViewSample' ? 'sample_master_id' : 'aliquot_master_id') => $lookupIds
                ),
                'fields' => array(
                    'GROUP_CONCAT(DISTINCT IFNULL(' . $batchSet['DatamartStructure']['model'] . '.chum_kidney_transp_biohazard,"") SEPARATOR "") AS res_biohazard'
                )
            ));
            if (preg_match('/u/', $batchSetBiohazard[0]['res_biohazard'])) {
                AppController::addWarningMsg(__('at least one aliquot/sample is not linked to a collection - biological hazard can not be evaluated'));
            }
            if (preg_match('/y/', $batchSetBiohazard[0]['res_biohazard'])) {
                AppController::addWarningMsg(__('at least one aliquot/sample presents a confirmed biological hazard'));
            }
        }
    }
}