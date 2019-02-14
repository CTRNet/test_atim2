<?php

class AliquotReviewMasterCustom extends AliquotReviewMaster
{

    var $useTable = 'aliquot_review_masters';

    var $name = 'AliquotReviewMaster';

    public function generateLabelOfReviewedAliquot($aliquotMasterId, $aliquotData = null)
    {
        if (! $aliquotData || ! isset($aliquotData['ViewAliquot'])) {
            $ViewAliquotModel = AppModel::getInstance('InventoryManagement', 'ViewAliquot', true);
            $aliquotData = $ViewAliquotModel->find('first', array(
                'conditions' => array(
                    'ViewAliquot.aliquot_master_id' => $aliquotMasterId
                ),
                'recursive' => - 1
            ));
        }
        return $aliquotData['ViewAliquot']['aliquot_label'] . ' [' . $aliquotData['ViewAliquot']['barcode'] . ']';
    }
}