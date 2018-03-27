<?php
/** **********************************************************************
 * TFRI-M4S Project.
 * ***********************************************************************
 *
 * InventoryManagement plugin custom code
 *
 * Class AliquotMasterCustom
 * 
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2018-03-16
 */
 
class AliquotMasterCustom extends AliquotMaster
{
    var $useTable = 'aliquot_masters';
    
    var $name = "AliquotMaster";
    
    /**
     * Will return an empty array considering that no consent exists into TFRI-M4S version.
     *
     * @param array $aliquot
     *            with either a key 'id' referring to an array
     *            of ids, or a key 'data' referring to AliquotMaster.
     * @param If|string $modelName If
     *            the aliquot array contains data, the model name
     *            to use.
     * @return an array having unconsented aliquot as key and their consent
     *         status as value. This function refers to
     *         ViewCollection->getUnconsentedCollections.
     */
    public function getUnconsentedAliquots(array $aliquot, $modelName = 'AliquotMaster')
    {
        return array();
    }

    /**
     * Generate default aliquot label.
     *
     * @param array $viewSample
     *            View data of the sample of the created aliquot.
     * @param array $aliquotControlData
     *            Control data of the created aliquot
     * @return string Default aliquot label.
     */
    public function generateDefaultAliquotLabel($viewSample, $aliquotControlData)
    {
        // Parameters check: Verify parameters have been set
        if (empty($viewSample) || empty($aliquotControlData)) {
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $structurePermissibleValuesCustom = AppModel::getInstance("", "StructurePermissibleValuesCustom", true);
        $tfriM4sSiteId = $structurePermissibleValuesCustom->getTranslatedCustomDropdownValue('TFRI 4MS Site IDs', $viewSample['ViewSample']['tfri_m4s_site_id']);
        $tfriM4sVisitId = $viewSample['ViewSample']['tfri_m4s_visit_id'];
        $tfriM4sSitePatientId = $viewSample['ViewSample']['tfri_m4s_site_patient_id'];
        $suffix = '?';
        switch ($viewSample['ViewSample']['initial_specimen_sample_type'] . '-' . $viewSample['ViewSample']['sample_type']) {
            // Blood
            case 'blood-blood':
                $suffix = 'BL';
                break;
            case 'blood-plasma':
                $suffix = 'BL-PL';
                break;
            case 'blood-pbmc':
                $suffix = 'BL-WBC';
                break;
            // Bone Marrow
            case 'bone marrow-bone marrow':
                $suffix = 'BM';
                break;
            case 'bone marrow-plasma':
                $suffix = 'BM-PL';
                break;
            case 'bone marrow-pbmc':
                $suffix = 'BM-WBC';
                break;
            case 'bone marrow-b cell':
                $sampleMaster = AppModel::getInstance("InvetoryManagement", "SampleMaster", true);
                $joins = array(
                    array(
                        'table' => 'sd_der_b_cells',
                        'alias' => 'SampleDetail',
                        'type' => 'INNER',
                        'conditions' => array(
                            'SampleDetail.sample_master_id = SampleMaster.id'
                        )
                    )
                );
                $sampleData = $sampleMaster->find('first', array(
                    'conditions' => array('SampleMaster.id' => $viewSample['ViewSample']['sample_master_id']), 
                    'joins' => $joins, 'recursive' => '-1', 
                    'fields' => array('SampleDetail.tfri_m4s_cd_138')
                ));
                $suffix = 'CD138'.str_replace(array('p', 'n', 'u'), array('POS', 'NEG', '?'), $sampleData['SampleDetail']['tfri_m4s_cd_138']);
                if ($aliquotControlData['AliquotControl']['aliquot_type'] == 'slide') {
                    $suffix .= ' GiemSL?CytoSL';
                }
                break;
        }
        
        return $tfriM4sSiteId . '-' . $tfriM4sVisitId . '-' . $tfriM4sSitePatientId . '-' . $suffix;
    }

    /**
     * Generate default aliquot barcode.
     */
    public function regenerateAliquotBarcode()
    {
        $queryToUpdate = "UPDATE aliquot_masters SET barcode = CONCAT('tmp#',id) WHERE barcode IS NULL OR barcode LIKE '';";
        $this->tryCatchQuery($queryToUpdate);
        $this->tryCatchQuery(str_replace("aliquot_masters", "aliquot_masters_revs", $queryToUpdate));
    }

}