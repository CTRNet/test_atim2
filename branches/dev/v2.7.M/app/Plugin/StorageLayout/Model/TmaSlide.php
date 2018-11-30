<?php
 /**
 *
 * ATiM - Advanced Tissue Management Application
 * Copyright (c) Canadian Tissue Repository Network (http://www.ctrnet.ca)
 *
 * Licensed under GNU General Public License
 * For full copyright and license information, please see the LICENSE.txt
 * Redistributions of files must retain the above copyright notice.
 *
 * @author        Canadian Tissue Repository Network <info@ctrnet.ca>
 * @copyright     Copyright (c) Canadian Tissue Repository Network (http://www.ctrnet.ca)
 * @link          http://www.ctrnet.ca
 * @since         ATiM v 2
 * @license       http://www.gnu.org/licenses  GNU General Public License
 */

/**
 * Class TmaSlide
 */
class TmaSlide extends StorageLayoutAppModel
{

    public $belongsTo = array(
        'StorageMaster' => array(
            'className' => 'StorageLayout.StorageMaster',
            'foreignKey' => 'storage_master_id'
        ),
        'Block' => array(
            'className' => 'StorageLayout.StorageMaster',
            'foreignKey' => 'tma_block_storage_master_id'
        ),
        'StudySummary' => array(
            'className' => 'Study.StudySummary',
            'foreignKey' => 'study_summary_id'
        )
    );

    public $actsAs = array(
        'StoredItem'
    );

    public static $storage = null;

    public static $studyModel = null;

    private $barcodes = array();
    
    // barcode validation, key = barcode, value = id
    
    /**
     *
     * @param array $options
     * @return bool
     */
    public function validates($options = array())
    {
        if (isset($this->data['TmaSlide']['in_stock']) && $this->data['TmaSlide']['in_stock'] == 'no' && (! empty($this->data['TmaSlide']['storage_master_id']) || ! empty($this->data['FunctionManagement']['recorded_storage_selection_label']))) {
            $this->validationErrors['in_stock'][] = 'a tma slide being not in stock can not be linked to a storage';
        }
        
        $this->validateAndUpdateTmaSlideStorageData();
        
        if (isset($this->data['TmaSlide']['barcode'])) {
            $this->isDuplicatedTmaSlideBarcode($this->data);
        }
        
        $this->validateAndUpdateTmaSlideStudyData();
        
        return parent::validates($options);
    }

    public function validateAndUpdateTmaSlideStorageData()
    {
        $tmaSlideData = & $this->data;
        // Load model
        if (self::$storage == null) {
            self::$storage = AppModel::getInstance("StorageLayout", "StorageMaster", true);
        }
        
        // Launch validation
        if (array_key_exists('FunctionManagement', $tmaSlideData) && array_key_exists('recorded_storage_selection_label', $tmaSlideData['FunctionManagement'])) {
            // Check the tma slide storage definition
            $arrStorageSelectionResults = self::$storage->validateAndGetStorageData($tmaSlideData['FunctionManagement']['recorded_storage_selection_label'], $tmaSlideData['TmaSlide']['storage_coord_x'], $tmaSlideData['TmaSlide']['storage_coord_y']);
            
            // Update aliquot data
            $tmaSlideData['TmaSlide']['storage_master_id'] = isset($arrStorageSelectionResults['storage_data']['StorageMaster']['id']) ? $arrStorageSelectionResults['storage_data']['StorageMaster']['id'] : null;
            if ($arrStorageSelectionResults['change_position_x_to_uppercase']) {
                $tmaSlideData['TmaSlide']['storage_coord_x'] = strtoupper($tmaSlideData['TmaSlide']['storage_coord_x']);
            }
            if ($arrStorageSelectionResults['change_position_y_to_uppercase']) {
                $tmaSlideData['TmaSlide']['storage_coord_y'] = strtoupper($tmaSlideData['TmaSlide']['storage_coord_y']);
            }
            
            // Set error
            if (! empty($arrStorageSelectionResults['storage_definition_error'])) {
                $this->validationErrors['recorded_storage_selection_label'][] = $arrStorageSelectionResults['storage_definition_error'];
            }
            if (! empty($arrStorageSelectionResults['position_x_error'])) {
                $this->validationErrors['storage_coord_x'][] = $arrStorageSelectionResults['position_x_error'];
            }
            if (! empty($arrStorageSelectionResults['position_y_error'])) {
                $this->validationErrors['storage_coord_y'][] = $arrStorageSelectionResults['position_y_error'];
            }
            
            if (empty($this->validationErrors['recorded_storage_selection_label']) && empty($this->validationErrors['storage_coord_x']) && empty($this->validationErrors['storage_coord_y']) && isset($arrStorageSelectionResults['storage_data']['StorageControl']) && $arrStorageSelectionResults['storage_data']['StorageControl']['check_conflicts'] && (strlen($tmaSlideData['TmaSlide']['storage_coord_x']) > 0 || strlen($tmaSlideData['TmaSlide']['storage_coord_y']) > 0)) {
                $exception = $this->id ? array(
                    "TmaSlide" => $this->id
                ) : array();
                $positionStatus = $this->StorageMaster->positionStatusQuick($arrStorageSelectionResults['storage_data']['StorageMaster']['id'], array(
                    'x' => $tmaSlideData['TmaSlide']['storage_coord_x'],
                    'y' => $tmaSlideData['TmaSlide']['storage_coord_y']
                ), $exception);
                $msg = null;
                if ($positionStatus == StorageMaster::POSITION_OCCUPIED) {
                    $msg = __('the storage [%s] already contained something at position [%s, %s]');
                } elseif ($positionStatus == StorageMaster::POSITION_DOUBLE_SET) {
                    $msg = __('you have set more than one element in storage [%s] at position [%s, %s]');
                }
                if ($msg != null) {
                    $msg = sprintf($msg, $arrStorageSelectionResults['storage_data']['StorageMaster']['selection_label'], $this->data['TmaSlide']['storage_coord_x'], $this->data['TmaSlide']['storage_coord_y']);
                    if ($arrStorageSelectionResults['storage_data']['StorageControl']['check_conflicts'] == 1) {
                        AppController::addWarningMsg($msg);
                    } else {
                        $this->validationErrors['parent_storage_coord_x'][] = $msg;
                    }
                }
            }
        } elseif ((array_key_exists('storage_coord_x', $tmaSlideData['TmaSlide'])) || (array_key_exists('storage_coord_y', $tmaSlideData['TmaSlide']))) {
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
    }

    /**
     *
     * @param $tmaSlideData
     */
    public function isDuplicatedTmaSlideBarcode($tmaSlideData)
    {
        // check data structure
        $tmpArrToCheck = array_values($tmaSlideData);
        if ((! is_array($tmaSlideData)) || (is_array($tmpArrToCheck) && isset($tmpArrToCheck[0]['tma_slide_data']))) {
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $barcode = $tmaSlideData['TmaSlide']['barcode'];
        
        // Check duplicated barcode into submited record
        if (! strlen($barcode)) {
            // Not studied
        } elseif (isset($this->barcodes[$barcode])) {
            $this->validationErrors['barcode'][] = str_replace('%s', $barcode, __('you can not record barcode [%s] twice'));
        } else {
            $this->barcodes[$barcode] = '';
        }
        
        // Check duplicated barcode into db
        $criteria = array(
            'TmaSlide.barcode' => $barcode
        );
        $slidesHavingDuplicatedBarcode = $this->find('all', array(
            'conditions' => array(
                'TmaSlide.barcode' => $barcode
            ),
            'recursive' => - 1
        ));
        ;
        if (! empty($slidesHavingDuplicatedBarcode)) {
            foreach ($slidesHavingDuplicatedBarcode as $duplicate) {
                if ((! array_key_exists('id', $tmaSlideData['TmaSlide'])) || ($duplicate['TmaSlide']['id'] != $tmaSlideData['TmaSlide']['id'])) {
                    $this->validationErrors['barcode'][] = str_replace('%s', $barcode, __('the barcode [%s] has already been recorded'));
                }
            }
        }
    }

    public function validateAndUpdateTmaSlideStudyData()
    {
        $tmaSlideData = & $this->data;
        
        // check data structure
        $tmpArrToCheck = array_values($tmaSlideData);
        if ((! is_array($tmaSlideData)) || (is_array($tmpArrToCheck) && isset($tmpArrToCheck[0]['TmaSlide']))) {
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Launch validation
        if (array_key_exists('FunctionManagement', $tmaSlideData) && array_key_exists('autocomplete_tma_slide_study_summary_id', $tmaSlideData['FunctionManagement'])) {
            $tmaSlideData['TmaSlide']['study_summary_id'] = null;
            $tmaSlideData['FunctionManagement']['autocomplete_tma_slide_study_summary_id'] = trim($tmaSlideData['FunctionManagement']['autocomplete_tma_slide_study_summary_id']);
            $this->addWritableField(array(
                'study_summary_id'
            ));
            if (strlen($tmaSlideData['FunctionManagement']['autocomplete_tma_slide_study_summary_id'])) {
                // Load model
                if (self::$studyModel == null)
                    self::$studyModel = AppModel::getInstance("Study", "StudySummary", true);
                    
                    // Check the aliquot internal use study definition
                $arrStudySelectionResults = self::$studyModel->getStudyIdFromStudyDataAndCode($tmaSlideData['FunctionManagement']['autocomplete_tma_slide_study_summary_id']);
                
                // Set study summary id
                if (isset($arrStudySelectionResults['StudySummary'])) {
                    $tmaSlideData['TmaSlide']['study_summary_id'] = $arrStudySelectionResults['StudySummary']['id'];
                }
                
                // Set error
                if (isset($arrStudySelectionResults['error'])) {
                    $this->validationErrors['autocomplete_tma_slide_study_summary_id'][] = $arrStudySelectionResults['error'];
                }
            }
        }
    }

    /**
     *
     * @param int $tmaSlideId
     * @return array
     */
    public function allowDeletion($tmaSlideId)
    {
        // Check no use exists
        $tmaSlideUseModel = AppModel::getInstance("StorageLayout", "TmaSlideUse", true);
        $nbrStorageAliquots = $tmaSlideUseModel->find('count', array(
            'conditions' => array(
                'TmaSlideUse.tma_slide_id' => $tmaSlideId
            ),
            'recursive' => - 1
        ));
        if ($nbrStorageAliquots > 0) {
            return array(
                'allow_deletion' => false,
                'msg' => 'use exists for the deleted tma slide'
            );
        }
        
        // Check tma slide is not linked to an order
        $orderItemModel = AppModel::getInstance("Order", "OrderItem", true);
        $nbrOrderItems = $orderItemModel->find('count', array(
            'conditions' => array(
                'OrderItem.tma_slide_id' => $tmaSlideId
            ),
            'recursive' => - 1
        ));
        if ($nbrOrderItems > 0) {
            return array(
                'allow_deletion' => false,
                'msg' => 'order exists for the deleted tma slide'
            );
        }
        
        return array(
            'allow_deletion' => true,
            'msg' => ''
        );
    }
}