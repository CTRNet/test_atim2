<?php
/** **********************************************************************
 * NBI Project..
 * ***********************************************************************
 *
 * InventoryManagement plugin custom code
 *
 * Class AliquotMasterCustom
 * 
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2018-04-06
 */
 
class AliquotMasterCustom extends AliquotMaster
{
    var $useTable = 'aliquot_masters';
    
    var $name = "AliquotMaster";
    
    private $aliquotLabels = array();
    
    /**
     * Will return an empty array considering that no consent exists into ATiM NBI version.
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
    public function generateDefaultAliquotLabel($viewSample, $aliquotControlData, $parentAliquotLabel = null)
    {
        // Parameters check: Verify parameters have been set
        if (empty($viewSample) || empty($aliquotControlData)) {
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $acquisitionLabel = $viewSample['ViewSample']['acquisition_label'];
        if ($viewSample['ViewSample']['sample_type'] == 'tissue') {
            if ($aliquotControlData['AliquotControl']['aliquot_type'] == 'block') {
                return $acquisitionLabel . 'TI';
            } elseif ($aliquotControlData['AliquotControl']['aliquot_type'] == 'slide') {
                return ($parentAliquotLabel ? $parentAliquotLabel : $acquisitionLabel . 'TI??') . 'SL';
            }
        }
        
        return $acquisitionLabel . '??';
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
     * Check created aliquot labels are not duplicated and set error if they are.
     *
     * @param $aliquotData
     * @return Following results array:
     *         array(
     * 'is_duplicated_barcode' => TRUE when barcodes are duplicaed,
     * 'messages' => array($message1, $message2, ...)
     * )
     * @internal param Aliquots $aliquotsData data stored into an array having structure like either:
     *   data stored into an array having structure like either:
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