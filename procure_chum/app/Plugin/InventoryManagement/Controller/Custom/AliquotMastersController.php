<?php

class AliquotMastersControllerCustom extends AliquotMastersController
{

    public function editBarcodeAndLabel()
    {
        
        // GET DATA
        $initialDisplay = false;
        $aliquotIds = array();
        
        $this->setUrlToCancel();
        $urlToCancel = $this->request->data['url_to_cancel'];
        unset($this->request->data['url_to_cancel']);
        
        if (isset($this->request->data['ViewAliquot']['aliquot_master_id'])) {
            // Action launched from the databrowser:
            if ($this->request->data['ViewAliquot']['aliquot_master_id'] == 'all' && isset($this->request->data['node'])) {
                $this->BrowsingResult = AppModel::getInstance('Datamart', 'BrowsingResult', true);
                $browsingResult = $this->BrowsingResult->find('first', array(
                    'conditions' => array(
                        'BrowsingResult.id' => $this->request->data['node']['id']
                    )
                ));
                $this->request->data['ViewAliquot']['aliquot_master_id'] = explode(",", $browsingResult['BrowsingResult']['id_csv']);
            }
            $aliquotIds = array_filter($this->request->data['ViewAliquot']['aliquot_master_id']);
            $initialDisplay = true;
        } elseif (isset($this->request->data['aliquot_ids_to_update'])) {
            // Data submited
            $aliquotIds = array_filter(explode(',', $this->request->data['aliquot_ids_to_update']));
            unset($this->request->data['aliquot_ids_to_update']);
        }
        
        $aliquotData = $this->AliquotMaster->find('all', array(
            'conditions' => array(
                'AliquotMaster.id' => $aliquotIds
            )
        ));
        $displayLimit = Configure::read('AliquotModification_processed_items_limit');
        if (empty($aliquotData)) {
            $this->atimFlashError((__('you have been redirected automatically') . ' (#' . __LINE__ . ')'), $urlToCancel, 5);
            return;
        } elseif (sizeof($aliquotData) > $displayLimit) {
            $this->atimFlashError(__("batch init - number of submitted records too big") . " (>$displayLimit)", $urlToCancel, 5);
            return;
        }
        $this->AliquotMaster->sortForDisplay($aliquotData, $aliquotIds);
        
        $aliquotsUsedBarcode = array();
        $aliquotsUsed = $this->AliquotInternalUse->find('all', array(
            'conditions' => array(
                'AliquotInternalUse.aliquot_master_id' => $aliquotIds,
                'AliquotInternalUse.type' => 'sent to processing site ps3'
            )
        ));
        foreach ($aliquotsUsed as $newUse) {
            $aliquotsUsedBarcode[] = $newUse['AliquotMaster']['barcode'];
        }
        if (! empty($aliquotsUsedBarcode))
            AppController::addWarningMsg(__('you are editing aliquots that have already been sent to processing site') . '. ' . str_replace('%s', '[' . implode('] ,[', $aliquotsUsedBarcode) . ']', __('see # %s')));
        
        $currentBarcodeToAliquotMasterId = array();
        $currentBarcodeToProcureCreatedByBank = array();
        foreach ($aliquotData as $newAliquot) {
            if (isset($currentBarcodeToAliquotMasterId[$newAliquot['AliquotMaster']['barcode']])) {
                $this->atimFlashError((__('you can not edit 2 aliquots with the same barcode')), $urlToCancel, 5);
                return;
            }
            $currentBarcodeToAliquotMasterId[$newAliquot['AliquotMaster']['barcode']] = $newAliquot['AliquotMaster']['id'];
            $currentBarcodeToProcureCreatedByBank[$newAliquot['AliquotMaster']['barcode']] = $newAliquot['AliquotMaster']['procure_created_by_bank'];
        }
        
        $this->set('aliquotIdsToUpdate', implode(',', $aliquotIds));
        
        // SET MENU AND STRUCTURE DATA
        
        $this->set('atimMenu', $this->Menus->get('/InventoryManagement/'));
        $this->Structures->set('procure_aliquot_barcode_and_label_update');
        
        $this->set('urlToCancel', $urlToCancel);
        
        // MANAGE DATA
        
        if ($initialDisplay) {
            
            // Initial Display
            $this->request->data = $aliquotData;
        } else {
            
            // Launch validation
            $errors = array();
            $recordCounter = 0;
            foreach ($this->request->data as $key => $newStudiedAliquot) {
                $recordCounter ++;
                // Get order item id
                if (! isset($currentBarcodeToAliquotMasterId[$newStudiedAliquot['ViewAliquot']['barcode']])) {
                    $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
                $newStudiedAliquot['AliquotMaster']['id'] = $currentBarcodeToAliquotMasterId[$newStudiedAliquot['ViewAliquot']['barcode']];
                $this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous data ***
                $this->AliquotMaster->id = $newStudiedAliquot['AliquotMaster']['id'];
                $this->AliquotMaster->set($newStudiedAliquot);
                $newStudiedAliquot = $this->AliquotMaster->data;
                if (! $this->AliquotMaster->validates()) {
                    foreach ($this->AliquotMaster->validationErrors as $field => $msgs) {
                        $msgs = is_array($msgs) ? $msgs : array(
                            $msgs
                        );
                        foreach ($msgs as $msg)
                            $errors['AliquotMaster'][$field][$msg][] = $recordCounter;
                    }
                }
                if (! isset($currentBarcodeToProcureCreatedByBank[$newStudiedAliquot['ViewAliquot']['barcode']])) {
                    $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
                $procureCreatedByBank = $currentBarcodeToProcureCreatedByBank[$newStudiedAliquot['ViewAliquot']['barcode']];
                $barcodeError = $this->AliquotMaster->validateBarcode(false, $newStudiedAliquot['AliquotMaster']['barcode'], $procureCreatedByBank, $newStudiedAliquot['ViewAliquot']['participant_identifier'], $newStudiedAliquot['ViewAliquot']['procure_visit']);
                if ($barcodeError)
                    $errors['AliquotMaster']['barcode'][__($barcodeError)][] = $recordCounter;
                    // Reset data
                $this->request->data[$key] = $newStudiedAliquot;
            }
            
            if (empty($errors)) {
                // Launch save process
                $this->AliquotMaster->writableFieldsMode = 'editgrid';
                foreach ($this->request->data as $newStudiedAliquotToSave) {
                    // Save data
                    $this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous data ***
                    $this->AliquotMaster->id = $newStudiedAliquotToSave['AliquotMaster']['id'];
                    if (! $this->AliquotMaster->save($newStudiedAliquotToSave['AliquotMaster'], false)) {
                        $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                    }
                }
                // Create batch set
                $datamartStructure = AppModel::getInstance("Datamart", "DatamartStructure", true);
                $batchSetModel = AppModel::getInstance('Datamart', 'BatchSet', true);
                $batchSetData = array(
                    'BatchSet' => array(
                        'datamart_structure_id' => $datamartStructure->getIdByModelName('ViewAliquot'),
                        'flag_tmp' => true
                    )
                );
                $batchSetModel->checkWritableFields = false;
                $batchSetModel->saveWithIds($batchSetData, $aliquotIds);
                $this->atimFlash(__('your data has been saved'), '/Datamart/BatchSets/listall/' . $batchSetModel->getLastInsertId());
            } else {
                // Set error message
                foreach ($errors as $model => $fieldMessages) {
                    $this->{$model}->validationErrors = array();
                    foreach ($fieldMessages as $field => $messages) {
                        foreach ($messages as $message => $linesNbr) {
                            if (! array_key_exists($field, $this->{$model}->validationErrors)) {
                                $this->{$model}->validationErrors[$field][] = $message . ' - ' . str_replace('%s', implode(',', $linesNbr), __('see line %s'));
                            } else {
                                $this->{$model}->validationErrors[][] = $message . ' - ' . str_replace('%s', implode(',', $linesNbr), __('see line %s'));
                            }
                        }
                    }
                }
            }
        }
    }
}