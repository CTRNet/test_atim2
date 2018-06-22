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
    
    private $aliquotLabels = array();
    
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
        
        if ($viewSample['ViewSample']['sample_type'] != 'cell pellet') {
            switch ($viewSample['ViewSample']['initial_specimen_sample_type'] . '-' . $viewSample['ViewSample']['sample_type']) {
                // Blood
                case 'blood-blood':
                    $suffix = 'BL';
                    break;
                case 'blood-plasma':
                    $suffix = 'BL-PL';
                    break;
                case 'blood-wbc':
                    $suffix = 'BL-WBC';
                    break;
                    // Bone Marrow
                case 'bone marrow-bone marrow':
                    $suffix = 'BM';
                    break;
                case 'bone marrow-plasma':
                    $suffix = 'BM-PL';
                    break;
                case 'bone marrow-wbc':
                    $suffix = 'BM-WBC';
                    break;
                case 'bone marrow-cd138 cells':
                    $sampleMaster = AppModel::getInstance("InvetoryManagement", "SampleMaster", true);
                    $joins = array(
                        array(
                            'table' => 'tfri_m4s_sd_der_cd138s',
                            'alias' => 'SampleDetail',
                            'type' => 'INNER',
                            'conditions' => array(
                                'SampleDetail.sample_master_id = SampleMaster.id'
                            )
                        )
                    );
                    $sampleData = $sampleMaster->find('first', array(
                        'conditions' => array('SampleMaster.id' => $viewSample['ViewSample']['sample_master_id']),
                        'joins' => $joins, 
                        'recursive' => '-1',
                        'fields' => array('SampleDetail.tfri_m4s_cd_138')
                    ));
                    $suffix = 'CD138'.str_replace(array('p', 'n', 'u'), array('POS', 'NEG', '?'), $sampleData['SampleDetail']['tfri_m4s_cd_138']);
                    switch ($aliquotControlData['AliquotControl']['aliquot_type']) {
                        case 'giemsl slide':
                            $suffix .= ' GiemSL';
                            break;
                        case 'cytosl slide':
                            $suffix .= ' CytoSL';
                            break;
                    }
                    break;
            }
        } else {
            $suffix = $viewSample['ViewSample']['initial_specimen_sample_type'] == 'bone marrow' ? 'BM' : ($viewSample['ViewSample']['initial_specimen_sample_type'] == 'blood' ? 'BL' : '?');
            if ($viewSample['ViewSample']['parent_sample_type'] == 'cd138 cells') {
                $sampleMaster = AppModel::getInstance("InvetoryManagement", "SampleMaster", true);
                $joins = array(
                    array(
                        'table' => 'tfri_m4s_sd_der_cd138s',
                        'alias' => 'SampleDetail',
                        'type' => 'INNER',
                        'conditions' => array(
                            'SampleDetail.sample_master_id = SampleMaster.id'
                        )
                    )
                );
                $sampleData = $sampleMaster->find('first', array(
                    'conditions' => array(
                        'SampleMaster.id' => $viewSample['ViewSample']['parent_id']
                    ),
                    'joins' => $joins,
                    'recursive' => '-1',
                    'fields' => array(
                        'SampleDetail.tfri_m4s_cd_138'
                    )
                ));
                $suffix .= '-CD138' . str_replace(array('p', 'n', 'u'), array( 'POS', 'NEG', '?'), $sampleData['SampleDetail']['tfri_m4s_cd_138']);
            } elseif ($viewSample['ViewSample']['parent_sample_type'] == 'wbc') {
                $suffix .= '-WBC';
            } else {
                $suffix .= '-?';
            }
            $suffix .= '-Cell Pellet';
        }
        
        return $tfriM4sSiteId . '-' . $tfriM4sSitePatientId . '-' . $tfriM4sVisitId . '-' . $suffix;
    }

    /**
     * Generate default aliquot barcode.
     */
    public function regenerateAliquotBarcode()
    {
        $queryToUpdate = "UPDATE aliquot_masters SET barcode = id WHERE barcode IS NULL OR barcode LIKE '';";
        $this->tryCatchQuery($queryToUpdate);
        $this->tryCatchQuery(str_replace("aliquot_masters", "aliquot_masters_revs", $queryToUpdate));
    }
    
    /**
     * Additional validation rule to validate aliquot label.
     *
     * @see Model::validates()
     * @param array $options
     * @return bool
     */
    public function validates($options = array())
    {
        if (isset($this->data['AliquotMaster']['aliquot_label'])) {
            $this->checkDuplicatedAliquotLabel($this->data);
        }
    
        return parent::validates($options);
    }

    /**
     * Check created barcodes are not duplicated and set error if they are.
     *
     * @param $aliquotData
     * @return Following results array:
     *         array(
     * 'is_duplicated_barcode' => TRUE when barcodes are duplicaed,
     * 'messages' => array($message1, $message2, ...)
     * )
     * @internal param Aliquots $aliquotsData data stored into an array having structure like either:*            data stored into an array having structure like either:
     *            - $aliquotsData = array('AliquotMaster' => array(...))
     *            or
     *            - $aliquotsData = array(array('AliquotMaster' => array(...)))
     *
     * @author N. Luc
     * @date 2018-04-03
     */
    public function checkDuplicatedAliquotLabel($aliquotData)
    {
        
        // check data structure
        $tmpArrToCheck = array_values($aliquotData);
        if ((! is_array($aliquotData)) || (is_array($tmpArrToCheck) && isset($tmpArrToCheck[0]['AliquotMaster']))) {
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $aliquotLabel = $aliquotData['AliquotMaster']['aliquot_label'];
        
        // Check duplicated aliquot_label into submited record
        if (! strlen($aliquotLabel)) {
            // Not studied
        } elseif (isset($this->aliquotLabels[$aliquotLabel])) {
            $this->validationErrors['aliquot_label'][] = str_replace('%s', $aliquotLabel, __('you can not record aliquot_label [%s] twice'));
        } else {
            $this->aliquotLabels[$aliquotLabel] = '';
        }
        
        // Check duplicated aliquot_label into db
        $criteria = array(
            'AliquotMaster.aliquot_label' => $aliquotLabel
        );
        $aliquotsHavingDuplicatedBarcode = $this->find('all', array(
            'conditions' => array(
                'AliquotMaster.aliquot_label' => $aliquotLabel
            ),
            'recursive' => - 1
        ));
        ;
        if (! empty($aliquotsHavingDuplicatedBarcode)) {
            foreach ($aliquotsHavingDuplicatedBarcode as $duplicate) {
                if ((! array_key_exists('id', $aliquotData['AliquotMaster'])) || ($duplicate['AliquotMaster']['id'] != $aliquotData['AliquotMaster']['id'])) {
                    $this->validationErrors['aliquot_label'][] = str_replace('%s', $aliquotLabel, __('the aliquot_label [%s] has already been recorded'));
                }
            }
        }
    }
    
}