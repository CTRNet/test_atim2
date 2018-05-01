<?php
/** **********************************************************************
 * TFRI-M4S Project.
 * ***********************************************************************
 *
 * InventoryManagement plugin custom code
 *
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2018-03-16
 */

// Set default aliquot label(s)
$defaultAliquotValues = array();
foreach ($samples as $viewSample) {
    $defaultAliquotLabel = $this->AliquotMaster->generateDefaultAliquotLabel($viewSample, $aliquotControl);
    $defaultAliquotValues[$viewSample['ViewSample']['sample_master_id']]['AliquotMaster.aliquot_label'] = $defaultAliquotLabel;
    switch ($aliquotControl['AliquotControl']['aliquot_type']) {
        case 'giemsl slide':
            $defaultAliquotValues[$viewSample['ViewSample']['sample_master_id']]['AliquotDetail.tfri_m4s_staining'] = 'giemsa';
            break;
        case 'cytosl slide':
            $defaultAliquotValues[$viewSample['ViewSample']['sample_master_id']]['AliquotDetail.tfri_m4s_method'] = 'cytospin';
            break;
    }
}
$this->set('defaultAliquotValues', $defaultAliquotValues);