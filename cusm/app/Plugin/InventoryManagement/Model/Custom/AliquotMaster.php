<?php
/** **********************************************************************
 * CUSM
 * ***********************************************************************
 *
 * Inventory Management plugin custom code
 * 
 * @author N. Luc - CTRNet (nicol.luc@gmail.com)
 * @since 2018-10-15
 */
 
class AliquotMasterCustom extends AliquotMaster
{

    var $useTable = 'aliquot_masters';

    var $name = 'AliquotMaster';

    public function regenerateAliquotBarcode()
    {
        $queryToUpdate = "UPDATE aliquot_masters SET barcode = CONCAT('ATiM#', id) WHERE barcode IS NULL OR barcode LIKE '';";
        $this->tryCatchQuery($queryToUpdate);
        $this->tryCatchQuery(str_replace("aliquot_masters", "aliquot_masters_revs", $queryToUpdate));
    }

    public function getDefaultAliquotLabel($viewSample)
    {
        $participantBankIdentifier = isset($viewSample['ViewSample']['identifier_value']) ? $viewSample['ViewSample']['identifier_value'] : '?';
        $tubeSuffix = '?';
        switch ($viewSample['ViewSample']['sample_type']) {
            case 'buffy coat':
                $tubeSuffix = 'BC';
                break;
            case 'plasma':
                $tubeSuffix = 'P';
                break;
            case 'serum':
                $tubeSuffix = 'S';
                break;
        }
        return "$participantBankIdentifier $tubeSuffix";
    }
    
    public function summary($variables = array())
    {
        $return = false;
    
        if (isset($variables['Collection.id']) && isset($variables['SampleMaster.id']) && isset($variables['AliquotMaster.id'])) {
    
            $result = $this->find('first', array(
                'conditions' => array(
                    'AliquotMaster.collection_id' => $variables['Collection.id'],
                    'AliquotMaster.sample_master_id' => $variables['SampleMaster.id'],
                    'AliquotMaster.id' => $variables['AliquotMaster.id']
                )
            ));
            if (! isset($result['AliquotMaster']['storage_coord_y'])) {
                $result['AliquotMaster']['storage_coord_y'] = "";
            }
            $return = array(
                'menu' => array(
                    null,
                    __($result['AliquotControl']['aliquot_type']) . ' : ' . $result['AliquotMaster']['aliquot_label']
                ),
                'title' => array(
                    null,
                    __($result['AliquotControl']['aliquot_type']) . ' : ' . $result['AliquotMaster']['aliquot_label']
                ),
                'data' => $result,
                'structure alias' => 'aliquot_masters'
            );
        }
    
        return $return;
    }
}