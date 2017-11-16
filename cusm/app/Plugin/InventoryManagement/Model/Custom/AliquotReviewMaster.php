<?php

class AliquotReviewMasterCustom extends AliquotReviewMaster
{

    var $useTable = 'aliquot_review_masters';

    var $name = 'AliquotReviewMaster';

//     public function generateLabelOfReviewedAliquot($aliquotMasterId, $aliquotData = null)
//     {
//         if (! ($aliquotData && isset($aliquotData['AliquotMaster']))) {
//             if (! isset($this->AliquotMaster)) {
//                 $this->AliquotMaster = AppModel::getInstance("InventoryManagement", "AliquotMaster", true);
//             }
//             $aliquotData = $this->AliquotMaster->getOrRedirect($aliquotMasterId);
//         }
//         return $aliquotData['AliquotMaster']['aliquot_label'] . ' [' . (isset($aliquotData['AliquotControl']['aliquot_type']) ? __($aliquotData['AliquotControl']['aliquot_type']) : '') . ' - ' . $aliquotData['AliquotMaster']['barcode'] . ']';
//     }
}