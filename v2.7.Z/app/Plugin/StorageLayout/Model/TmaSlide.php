<?php

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

    public static $study_model = null;

    private $barcodes = array();
    // barcode validation, key = barcode, value = id
    function validates($options = array())
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

    function validateAndUpdateTmaSlideStorageData()
    {
        $tma_slide_data = & $this->data;
        // Load model
        if (self::$storage == null) {
            self::$storage = AppModel::getInstance("StorageLayout", "StorageMaster", true);
        }
        
        // Launch validation
        if (array_key_exists('FunctionManagement', $tma_slide_data) && array_key_exists('recorded_storage_selection_label', $tma_slide_data['FunctionManagement'])) {
            // Check the tma slide storage definition
            $arr_storage_selection_results = self::$storage->validateAndGetStorageData($tma_slide_data['FunctionManagement']['recorded_storage_selection_label'], $tma_slide_data['TmaSlide']['storage_coord_x'], $tma_slide_data['TmaSlide']['storage_coord_y']);
            
            // Update aliquot data
            $tma_slide_data['TmaSlide']['storage_master_id'] = isset($arr_storage_selection_results['storage_data']['StorageMaster']['id']) ? $arr_storage_selection_results['storage_data']['StorageMaster']['id'] : null;
            if ($arr_storage_selection_results['change_position_x_to_uppercase']) {
                $tma_slide_data['TmaSlide']['storage_coord_x'] = strtoupper($tma_slide_data['TmaSlide']['storage_coord_x']);
            }
            if ($arr_storage_selection_results['change_position_y_to_uppercase']) {
                $tma_slide_data['TmaSlide']['storage_coord_y'] = strtoupper($tma_slide_data['TmaSlide']['storage_coord_y']);
            }
            
            // Set error
            if (! empty($arr_storage_selection_results['storage_definition_error'])) {
                $this->validationErrors['recorded_storage_selection_label'][] = $arr_storage_selection_results['storage_definition_error'];
            }
            if (! empty($arr_storage_selection_results['position_x_error'])) {
                $this->validationErrors['storage_coord_x'][] = $arr_storage_selection_results['position_x_error'];
            }
            if (! empty($arr_storage_selection_results['position_y_error'])) {
                $this->validationErrors['storage_coord_y'][] = $arr_storage_selection_results['position_y_error'];
            }
            
            if (empty($this->validationErrors['recorded_storage_selection_label']) && empty($this->validationErrors['storage_coord_x']) && empty($this->validationErrors['storage_coord_y']) && isset($arr_storage_selection_results['storage_data']['StorageControl']) && $arr_storage_selection_results['storage_data']['StorageControl']['check_conflicts'] && (strlen($tma_slide_data['TmaSlide']['storage_coord_x']) > 0 || strlen($tma_slide_data['TmaSlide']['storage_coord_y']) > 0)) {
                $exception = $this->id ? array(
                    "TmaSlide" => $this->id
                ) : array();
                $position_status = $this->StorageMaster->positionStatusQuick($arr_storage_selection_results['storage_data']['StorageMaster']['id'], array(
                    'x' => $tma_slide_data['TmaSlide']['storage_coord_x'],
                    'y' => $tma_slide_data['TmaSlide']['storage_coord_y']
                ), $exception);
                $msg = null;
                if ($position_status == StorageMaster::POSITION_OCCUPIED) {
                    $msg = __('the storage [%s] already contained something at position [%s, %s]');
                } else 
                    if ($position_status == StorageMaster::POSITION_DOUBLE_SET) {
                        $msg = __('you have set more than one element in storage [%s] at position [%s, %s]');
                    }
                if ($msg != null) {
                    $msg = sprintf($msg, $arr_storage_selection_results['storage_data']['StorageMaster']['selection_label'], $this->data['TmaSlide']['storage_coord_x'], $this->data['TmaSlide']['storage_coord_y']);
                    if ($arr_storage_selection_results['storage_data']['StorageControl']['check_conflicts'] == 1) {
                        AppController::addWarningMsg($msg);
                    } else {
                        $this->validationErrors['parent_storage_coord_x'][] = $msg;
                    }
                }
            }
        } else 
            if ((array_key_exists('storage_coord_x', $tma_slide_data['TmaSlide'])) || (array_key_exists('storage_coord_y', $tma_slide_data['TmaSlide']))) {
                AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
    }

    function isDuplicatedTmaSlideBarcode($tma_slide_data)
    {
        // check data structure
        $tmp_arr_to_check = array_values($tma_slide_data);
        if ((! is_array($tma_slide_data)) || (is_array($tmp_arr_to_check) && isset($tmp_arr_to_check[0]['tma_slide_data']))) {
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $barcode = $tma_slide_data['TmaSlide']['barcode'];
        
        // Check duplicated barcode into submited record
        if (! strlen($barcode)) {
            // Not studied
        } else 
            if (isset($this->barcodes[$barcode])) {
                $this->validationErrors['barcode'][] = str_replace('%s', $barcode, __('you can not record barcode [%s] twice'));
            } else {
                $this->barcodes[$barcode] = '';
            }
        
        // Check duplicated barcode into db
        $criteria = array(
            'TmaSlide.barcode' => $barcode
        );
        $slides_having_duplicated_barcode = $this->find('all', array(
            'conditions' => array(
                'TmaSlide.barcode' => $barcode
            ),
            'recursive' => - 1
        ));
        ;
        if (! empty($slides_having_duplicated_barcode)) {
            foreach ($slides_having_duplicated_barcode as $duplicate) {
                if ((! array_key_exists('id', $tma_slide_data['TmaSlide'])) || ($duplicate['TmaSlide']['id'] != $tma_slide_data['TmaSlide']['id'])) {
                    $this->validationErrors['barcode'][] = str_replace('%s', $barcode, __('the barcode [%s] has already been recorded'));
                }
            }
        }
    }

    function validateAndUpdateTmaSlideStudyData()
    {
        $tma_slide_data = & $this->data;
        
        // check data structure
        $tmp_arr_to_check = array_values($tma_slide_data);
        if ((! is_array($tma_slide_data)) || (is_array($tmp_arr_to_check) && isset($tmp_arr_to_check[0]['TmaSlide']))) {
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Launch validation
        if (array_key_exists('FunctionManagement', $tma_slide_data) && array_key_exists('autocomplete_tma_slide_study_summary_id', $tma_slide_data['FunctionManagement'])) {
            $tma_slide_data['TmaSlide']['study_summary_id'] = null;
            $tma_slide_data['FunctionManagement']['autocomplete_tma_slide_study_summary_id'] = trim($tma_slide_data['FunctionManagement']['autocomplete_tma_slide_study_summary_id']);
            $this->addWritableField(array(
                'study_summary_id'
            ));
            if (strlen($tma_slide_data['FunctionManagement']['autocomplete_tma_slide_study_summary_id'])) {
                // Load model
                if (self::$study_model == null)
                    self::$study_model = AppModel::getInstance("Study", "StudySummary", true);
                    
                    // Check the aliquot internal use study definition
                $arr_study_selection_results = self::$study_model->getStudyIdFromStudyDataAndCode($tma_slide_data['FunctionManagement']['autocomplete_tma_slide_study_summary_id']);
                
                // Set study summary id
                if (isset($arr_study_selection_results['StudySummary'])) {
                    $tma_slide_data['TmaSlide']['study_summary_id'] = $arr_study_selection_results['StudySummary']['id'];
                }
                
                // Set error
                if (isset($arr_study_selection_results['error'])) {
                    $this->validationErrors['autocomplete_tma_slide_study_summary_id'][] = $arr_study_selection_results['error'];
                }
            }
        }
    }

    function allowDeletion($tma_slide_id)
    {
        // Check no use exists
        $tma_slide_use_model = AppModel::getInstance("StorageLayout", "TmaSlideUse", true);
        $nbr_storage_aliquots = $tma_slide_use_model->find('count', array(
            'conditions' => array(
                'TmaSlideUse.tma_slide_id' => $tma_slide_id
            ),
            'recursive' => '-1'
        ));
        if ($nbr_storage_aliquots > 0) {
            return array(
                'allow_deletion' => false,
                'msg' => 'use exists for the deleted tma slide'
            );
        }
        
        // Check tma slide is not linked to an order
        $order_item_model = AppModel::getInstance("Order", "OrderItem", true);
        $nbr_order_items = $order_item_model->find('count', array(
            'conditions' => array(
                'OrderItem.tma_slide_id' => $tma_slide_id
            ),
            'recursive' => '-1'
        ));
        if ($nbr_order_items > 0) {
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