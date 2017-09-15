<?php

class AliquotMasterCustom extends AliquotMaster
{

    var $name = 'AliquotMaster';

    var $useTable = 'aliquot_masters';

    private $barcodes = array();

    public function checkDuplicatedAliquotBarcode($aliquotData)
    {
        // error on duplicate for the same control id
        // warn on duplicate on cross control id
        
        // check data structure
        $tmpArrToCheck = array_values($aliquotData);
        if ((! is_array($aliquotData)) || (is_array($tmpArrToCheck) && isset($tmpArrToCheck[0]['AliquotMaster']))) {
            AppController::getInstance()->redirect('/pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $barcode = $aliquotData['AliquotMaster']['barcode'];
        $controlId = isset($aliquotData['AliquotMaster']['aliquot_control_id']) ? $aliquotData['AliquotMaster']['aliquot_control_id'] : '';
        
        // Check duplicated barcode into submited record
        if (empty($barcode)) {
            // Not studied
        } else 
            if (isset($this->barcodes[$controlId][$barcode])) {
                $this->validationErrors['barcode'][] = str_replace('%s', $barcode, __('you can not record barcode [%s] twice'));
            } else 
                if (isset($this->barcodes['all'][$barcode])) {
                    AppController::addWarningMsg(sprintf(__('barcode [%s] was created more than once'), $barcode));
                } else {
                    $this->barcodes['all'][$barcode] = '';
                    $this->barcodes[$controlId][$barcode] = '';
                }
        
        // Check duplicated barcode into db
        $aliquotsHavingDuplicatedBarcode = $this->find('all', array(
            'conditions' => array(
                'AliquotMaster.barcode' => $barcode
            ),
            'recursive' => - 1
        ));
        if (! empty($aliquotsHavingDuplicatedBarcode)) {
            // errors on the same ctrl_id
            foreach ($aliquotsHavingDuplicatedBarcode as $duplicate) {
                if ((! array_key_exists('id', $aliquotData['AliquotMaster'])) || ($duplicate['AliquotMaster']['id'] != $aliquotData['AliquotMaster']['id'])) {
                    if ($duplicate['AliquotMaster']['aliquot_control_id'] == $controlId) {
                        $this->validationErrors['barcode'][] = str_replace('%s', $barcode, __('the barcode [%s] has already been recorded'));
                    } else {
                        AppController::addWarningMsg(str_replace('%s', $barcode, __('barcode [%s] was created more than once')));
                    }
                }
            }
        }
    }
}