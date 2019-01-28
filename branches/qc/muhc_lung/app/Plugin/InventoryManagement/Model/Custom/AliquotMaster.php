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
    
    private $sampleModel = null;
    
    public function regenerateAliquotBarcode()
    {
        $queryToUpdate = "UPDATE aliquot_masters SET barcode = CONCAT('ATiM#', id) WHERE barcode IS NULL OR barcode LIKE '';";
        $this->tryCatchQuery($queryToUpdate);
        $this->tryCatchQuery(str_replace("aliquot_masters", "aliquot_masters_revs", $queryToUpdate));
    }

    public function getDefaultAliquotLabel($viewSample, $nodeDefaultValues = array())
    {
        if (! isset($this->sampleModel)) {
            $this->sampleModel = AppModel::getInstance('InventoryManagement', 'SampleMaster', true);
        }
        
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
            case 'tissue':
                $tubeSuffix = '?';
                if ($nodeDefaultValues) {
                    if (isset($nodeDefaultValues['AliquotDetail.cusm_storage_solution']) && $nodeDefaultValues['AliquotDetail.cusm_storage_solution'] == 'OCT') {
                        $tubeSuffix = 'OCT';
                    } elseif (isset($nodeDefaultValues['AliquotDetail.cusm_storage_method']) && $nodeDefaultValues['AliquotDetail.cusm_storage_method'] == 'OCT') {
                        $tubeSuffix = 'CC';
                    } elseif (isset($nodeDefaultValues['AliquotDetail.cusm_storage_method']) && $nodeDefaultValues['AliquotDetail.cusm_storage_method'] == 'flash freeze') {
                        $tubeSuffix = 'FF';
                    }
                }
                $sampleData = $this->sampleModel->find('first', array(
                    'conditions' => array(
                        'SampleMaster.id' => $viewSample['ViewSample']['sample_master_id']
                    ),
                    'recursive' => 0
                ));
                switch ($sampleData['SampleDetail']['tissue_nature']) {
                    case 'normal':
                        $tubeSuffix .= ' N';
                        break;
                    case 'tumor':
                        $tubeSuffix .= ' T';
                        break;
                    case 'benign':
                        $tubeSuffix .= ' B';
                        break;
                    case 'unknown':
                    case 'metastatic':
                        break;
                }
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