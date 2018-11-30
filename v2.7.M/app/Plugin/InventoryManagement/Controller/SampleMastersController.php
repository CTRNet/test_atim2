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
 * Class SampleMastersController
 */
class SampleMastersController extends InventoryManagementAppController
{

    public $components = array();

    public $uses = array(
        'InventoryManagement.Collection',
        
        'InventoryManagement.SampleControl',
        
        'InventoryManagement.SampleMaster',
        'InventoryManagement.ViewSample',
        'InventoryManagement.SampleDetail',
        'InventoryManagement.SpecimenDetail',
        'InventoryManagement.DerivativeDetail',
        
        'InventoryManagement.ParentToDerivativeSampleControl',
        
        'InventoryManagement.AliquotControl',
        'InventoryManagement.AliquotMaster',
        
        'InventoryManagement.SourceAliquot',
        'InventoryManagement.QualityCtrl',
        'InventoryManagement.SpecimenReviewMaster',
        'InventoryManagement.AliquotReviewMaster',
        
        'InventoryManagement.Realiquoting',
        
        'ExternalLink'
    );

    public $paginate = array(
        'SampleMaster' => array(
            'order' => 'SampleMaster.sample_code DESC'
        ),
        'ViewSample' => array(
            'order' => 'ViewSample.sample_code DESC'
        ),
        'AliquotMaster' => array(
            'order' => 'AliquotMaster.barcode DESC'
        )
    );

    /**
     *
     * @param int $searchId
     */
    public function search($searchId = 0)
    {
        $this->set('atimMenu', $this->Menus->get('/InventoryManagement/Collections/search'));
        
        // lazy load
        $this->SampleControl;
        $this->AliquotControl;
        
        $hookLink = $this->hook('pre_search_handler');
        if ($hookLink) {
            require ($hookLink);
        }
        
        $this->searchHandler($searchId, $this->ViewSample, 'view_sample_joined_to_collection', '/InventoryManagement/SampleMasters/search');
        
        $helpUrl = $this->ExternalLink->find('first', array(
            'conditions' => array(
                'name' => 'inventory_elements_defintions'
            )
        ));
        $this->set("helpUrl", $helpUrl['ExternalLink']['link']);
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($searchId)) {
            // index
            $this->render('index');
        }
    }

    /**
     *
     * @param $collectionId
     * @param int $sampleMasterId
     * @param bool $isAjax
     */
    public function contentTreeView($collectionId, $sampleMasterId = 0, $isAjax = false)
    {
        $this->Collection->getOrRedirect($collectionId);
        
        // To sort data based on date
        $tmpArray = array();
        $aS = array(
            '±' => 0,
            'y' => 1,
            'm' => 2,
            'd' => 3,
            'h' => 4,
            'i' => 5,
            'c' => 6,
            '' => 7
        );
        $addToTmpArray = function (array $in, $model, $dateField, $accuracyField) use($aS, &$tmpArray) {
            if ($in[$model][$dateField]) {
                $tmpArray[$in[$model][$dateField] . $aS[$in[$model][$accuracyField]]][] = $in;
            } else {
                $tmpArray[' '][] = $in;
            }
        };
        
        // Main Code
        if ($isAjax) {
            $this->layout = 'ajax';
            Configure::write('debug', 0);
        } else {
            $this->set("specimenSampleControlsList", $this->SampleControl->getPermissibleSamplesArray(null));
            $templateModel = AppModel::getInstance("Tools", "Template", true);
            $templates = $templateModel->getAddFromTemplateMenu($collectionId);
            $this->set('templates', $templates);
        }
        $atimStructure['SampleMaster'] = $this->Structures->get('form', 'sample_masters_for_collection_tree_view');
        $atimStructure['AliquotMaster'] = $this->Structures->get('form', 'aliquot_masters_for_collection_tree_view');
        $atimStructure['SampleUseForCollectionTreeView'] = $this->Structures->get('form', 'sample_uses_for_collection_tree_view');
        
        $this->set('atimStructure', $atimStructure);
        $this->set("collectionId", $collectionId);
        $this->set("isAjax", $isAjax);
        
        $this->SampleMaster->unbindModel(array(
            'belongsTo' => array(
                'Collection'
            ),
            'hasOne' => array(
                'SpecimenDetail'
            ),
            'hasMany' => array(
                'AliquotMaster'
            )
        ), false);
        if ($sampleMasterId == 0) {
            // fetch all
            $this->request->data = $this->SampleMaster->find('all', array(
                'conditions' => array(
                    "SampleMaster.collection_id" => $collectionId,
                    "SampleMaster.parent_id IS NULL"
                ),
                'recursive' => 0
            ));
        } else {
            $this->request->data = $this->SampleMaster->find('all', array(
                'conditions' => array(
                    "SampleMaster.collection_id" => $collectionId,
                    "SampleMaster.parent_id" => $sampleMasterId
                ),
                'order' => 'DerivativeDetail.creation_datetime ASC, SampleMaster.id ASC',
                'recursive' => 0
            ));
            foreach ($this->request->data as &$newSample)
                $newSample['DerivativeDetail']['creation_datetime_accuracy'] = str_replace(array(
                    '',
                    'c',
                    'i'
                ), array(
                    'h',
                    'h',
                    'h'
                ), $newSample['DerivativeDetail']['creation_datetime_accuracy']);
        }
        
        $ids = array();
        foreach ($this->request->data as $unit) {
            $ids[] = $unit['SampleMaster']['id'];
        }
        $ids = array_flip($this->SampleMaster->hasChild($ids)); // array_key_exists is faster than in_array
        foreach ($this->request->data as &$unit) {
            $unit['children'] = array_key_exists($unit['SampleMaster']['id'], $ids);
        }
        
        if ($sampleMasterId != 0) {
            
            // Display aliquots first then all other linked records (sample, quality controls , etc) ordered on dates
            foreach ($this->request->data as $unit2) {
                $addToTmpArray($unit2, 'DerivativeDetail', 'creation_datetime', 'creation_datetime_accuracy');
            }
            $this->request->data = array();
            
            // aliquots that are not realiquots
            $this->AliquotMaster->unbindModel(array(
                'belongsTo' => array(
                    'Collection',
                    'SampleMaster'
                ),
                'hasOne' => array(
                    'SpecimenDetail'
                )
            ), false);
            $aliquotIds = $this->AliquotMaster->find('list', array(
                'fields' => array(
                    'AliquotMaster.id'
                ),
                'conditions' => array(
                    "AliquotMaster.collection_id" => $collectionId,
                    "AliquotMaster.sample_master_id" => $sampleMasterId
                ),
                'recursive' => - 1
            ));
            $aliquotIds = array_diff($aliquotIds, array_unique(array_filter($this->Realiquoting->find('list', array(
                'fields' => array(
                    'Realiquoting.child_aliquot_master_id'
                ),
                'conditions' => array(
                    "Realiquoting.child_aliquot_master_id" => $aliquotIds
                )
            )))));
            $aliquotIdsHasChild = array_flip($this->AliquotMaster->hasChild($aliquotIds));
            
            $aliquotIds[] = 0; // counters Eventum 1353
            $aliquots = $this->AliquotMaster->find('all', array(
                'conditions' => array(
                    "AliquotMaster.id" => $aliquotIds
                ),
                'recursive' => 0
            ));
            $tmaBlockStorageControlIds = array();
            $storageControlModel = AppModel::getInstance("StorageLayout", "StorageControl", true);
            foreach ($aliquots as &$aliquot) {
                $aliquot['children'] = array_key_exists($aliquot['AliquotMaster']['id'], $aliquotIdsHasChild);
                $aliquot['css'][] = $aliquot['AliquotMaster']['in_stock'] == 'no' ? 'disabled' : '';
                // Check aliquot is a TMA core, - To change 'aliquot' icon to 'Tma Block' icon
                if ($aliquot['ViewAliquot']['aliquot_type'] == 'core' && $aliquot['StorageMaster']['id']) {
                    if (! array_key_exists($aliquot['StorageMaster']['storage_control_id'], $tmaBlockStorageControlIds)) {
                        $tmaBlockStorageControlIds[$aliquot['StorageMaster']['storage_control_id']] = $storageControlModel->find('count', array(
                            'conditions' => array(
                                'StorageControl.id' => $aliquot['StorageMaster']['storage_control_id'],
                                'StorageControl.is_tma_block' => 1
                            )
                        ));
                    }
                    if ($tmaBlockStorageControlIds[$aliquot['StorageMaster']['storage_control_id']]) {
                        $aliquot = array_merge(array(
                            'TmaBlock' => $aliquot['StorageMaster']
                        ), $aliquot);
                    }
                }
            }
            $this->request->data = $aliquots;
            
            // Add sample Specimen Review that is not linked to an aliquot
            foreach ($this->SpecimenReviewMaster->find('all', array(
                'conditions' => array(
                    'SpecimenReviewMaster.sample_master_id' => $sampleMasterId
                )
            )) as $newSpecimenReview) {
                $aliquotReviewMasterConditions = array(
                    'AliquotReviewMaster.specimen_review_master_id' => $newSpecimenReview['SpecimenReviewMaster']['id']
                );
                if (! $this->AliquotReviewMaster->find('count', array(
                    'conditions' => $aliquotReviewMasterConditions
                ))) {
                    $formatedSpecimenReviewData = array_merge($newSpecimenReview, array(
                        'Generated' => array(
                            'sample_use_definition' => __('specimen review'),
                            'sample_use_code' => $newSpecimenReview['SpecimenReviewMaster']['review_code'],
                            'sample_use_date' => $newSpecimenReview['SpecimenReviewMaster']['review_date'],
                            'sample_use_date_accuracy' => $newSpecimenReview['SpecimenReviewMaster']['review_date_accuracy']
                        )
                    ));
                    $addToTmpArray($formatedSpecimenReviewData, 'Generated', 'sample_use_date', 'sample_use_date_accuracy');
                }
            }
            
            // Add sample Specimen Review that is not linked to an aliquot
            foreach ($this->QualityCtrl->find('all', array(
                'conditions' => array(
                    'QualityCtrl.sample_master_id' => $sampleMasterId,
                    'QualityCtrl.aliquot_master_id IS NULL'
                )
            )) as $newQualityCtrl) {
                $formatedQualityCtrlData = array_merge($newQualityCtrl, array(
                    'Generated' => array(
                        'sample_use_definition' => __('quality control'),
                        'sample_use_code' => $newQualityCtrl['QualityCtrl']['qc_code'],
                        'sample_use_date' => $newQualityCtrl['QualityCtrl']['date'],
                        'sample_use_date_accuracy' => $newQualityCtrl['QualityCtrl']['date_accuracy']
                    )
                ));
                $addToTmpArray($formatedQualityCtrlData, 'Generated', 'sample_use_date', 'sample_use_date_accuracy');
            }
            
            // *** Sort data ***
            
            // sort the tmpArray by key (key = date)
            ksort($tmpArray);
            $tmpArray2 = array();
            foreach ($tmpArray as $dateWAccu => $elements) {
                $date = substr($dateWAccu, 0, - 1);
                if ($date == 0) {
                    $date = '';
                }
                if (isset($tmpArray2[$date])) {
                    $tmpArray2[$date] = array_merge($tmpArray2[$date], $elements);
                } else {
                    $tmpArray2[$date] = $elements;
                }
            }
            $tmpArray = $tmpArray2;
            
            // transfer the tmpArray into $this->request->data
            foreach ($tmpArray as $key => $values) {
                foreach ($values as $value) {
                    $date = $key;
                    $time = null;
                    if (strpos($date, " ") > 0) {
                        list ($date, $time) = explode(" ", $date);
                    }
                    $this->request->data[] = $value;
                }
            }
        }
        
        // Set menu variables
        $this->set('atimMenuVariables', array(
            'Collection.id' => $collectionId
        ));
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     * List all derivatives samples of a specimen.
     *
     * @param $collectionId ID of the collection
     * @param $specimenSampleMasterId
     * @internal param sample_master_id $specimenSampleId of the specimen* of the specimen
     */
    public function listAllDerivatives($collectionId, $specimenSampleMasterId)
    {
        if ((! $collectionId) || (! $specimenSampleMasterId)) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $specimenData = $this->SampleMaster->find('first', array(
            'conditions' => array(
                'SampleMaster.collection_id' => $collectionId,
                'SampleMaster.id' => $specimenSampleMasterId
            ),
            'recursive' => - 1
        ));
        if (empty($specimenData))
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        
        $derivativesData = array();
        $derivativesData = $this->SampleMaster->find('all', array(
            'conditions' => array(
                'SampleMaster.collection_id' => $collectionId,
                'SampleMaster.initial_specimen_sample_id' => $specimenSampleMasterId,
                'SampleMaster.initial_specimen_sample_id != SampleMaster.id'
            ),
            'recursive' => 0
        ));
        
        if (empty($derivativesData)) {
            $this->Structures->set('sample_masters,sd_undetailed_derivatives', 'no_data_structure');
            $this->request->data = array();
        } else {
            // Data
            $derivativesData = AppController::defineArrayKey($derivativesData, "SampleMaster", "sample_control_id", false);
            $this->set('derivativesData', $derivativesData);
            
            // Structures
            $derivativesStructures = array();
            foreach ($derivativesData as $sampleControlId => $derivatives) {
                $derivativesStructures[$sampleControlId] = $this->Structures->get('form', $derivatives[0]['SampleControl']['form_alias']);
            }
            $this->set('derivativesStructures', $derivativesStructures);
        }
        
        // Set menu variables
        $menuLink = '/InventoryManagement/SampleMasters/listAllDerivatives/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%';
        $this->set('atimMenu', $this->Menus->get($menuLink));
        
        $atimMenuVariables = array(
            'Collection.id' => $collectionId,
            'SampleMaster.initial_specimen_sample_id' => $specimenSampleMasterId
        );
        
        $this->set('atimMenuVariables', $atimMenuVariables);
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     *
     * @param $collectionId
     * @param $sampleMasterId
     * @param int $isFromTreeView
     */
    public function detail($collectionId, $sampleMasterId, $isFromTreeView = 0)
    {
        // $isFromTreeView : 0-Normal, 1-Tree view
        
        // MANAGE DATA
        
        // Get the sample data
        $sampleData = $this->ViewSample->find('first', array(
            'conditions' => array(
                'ViewSample.collection_id' => $collectionId,
                'ViewSample.sample_master_id' => $sampleMasterId
            )
        ));
        if (empty($sampleData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        if (array_key_exists('coll_to_rec_spent_time_msg', $sampleData['ViewSample']))
            $sampleData['SampleMaster']['coll_to_rec_spent_time_msg'] = $sampleData['ViewSample']['coll_to_rec_spent_time_msg'];
        if (array_key_exists('coll_to_creation_spent_time_msg', $sampleData['ViewSample']))
            $sampleData['SampleMaster']['coll_to_creation_spent_time_msg'] = $sampleData['ViewSample']['coll_to_creation_spent_time_msg'];
        
        $isSpecimen = true;
        switch ($sampleData['SampleControl']['sample_category']) {
            case 'specimen':
                // Displayed sample is a specimen
                $isSpecimen = true;
                unset($sampleData['DerivativeDetail']);
                break;
            
            case 'derivative':
                // Displayed sample is a derivative
                $isSpecimen = false;
                unset($sampleData['SpecimenDetail']);
                break;
            
            default:
                $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Get parent sample information
        $parentSampleMasterId = $sampleData['SampleMaster']['parent_id'];
        $parentSampleData = $this->SampleMaster->find('first', array(
            'conditions' => array(
                'SampleMaster.collection_id' => $collectionId,
                'SampleMaster.id' => $parentSampleMasterId
            ),
            'recursive' => 0
        ));
        if (! empty($parentSampleMasterId) && empty($parentSampleData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $this->set('parentSampleDataForDisplay', $this->SampleMaster->formatParentSampleDataForDisplay($parentSampleData));
        $this->set('parentSampleMasterId', $parentSampleMasterId);
        
        // Set sample data
        $this->set('sampleMasterData', $sampleData);
        $this->request->data = array();
        
        // Set sample aliquot list
        $aliquotsData = array();
        if (! $isFromTreeView) {
            $aliquotsData = $this->AliquotMaster->find('all', array(
                'conditions' => array(
                    'AliquotMaster.collection_id' => $collectionId,
                    'AliquotMaster.sample_master_id' => $sampleMasterId
                )
            ));
            $aliquotsData = AppController::defineArrayKey($aliquotsData, "AliquotMaster", "aliquot_control_id", false);
            $this->set('aliquotsData', $aliquotsData);
        }
        
        // Set Lab Book Id
        if (isset($sampleData['DerivativeDetail']['lab_book_master_id']) && ! empty($sampleData['DerivativeDetail']['lab_book_master_id'])) {
            $this->set('labBookMasterId', $sampleData['DerivativeDetail']['lab_book_master_id']);
        }
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        // Get the current menu object.
        $this->setBatchMenu($sampleData);
        
        // Set structure
        $structureName = $sampleData['SampleControl']['form_alias'];
        if (! $isSpecimen) {
            $parentData = $this->SampleMaster->find('first', array(
                'conditions' => array(
                    'SampleMaster.id' => $sampleData['SampleMaster']['parent_id']
                ),
                'fields' => array(
                    'SampleControl.id'
                ),
                'recursive' => 0
            ));
            $tmpData = $this->ParentToDerivativeSampleControl->find('first', array(
                'conditions' => array(
                    'ParentToDerivativeSampleControl.parent_sample_control_id' => $parentData['SampleControl']['id'],
                    'ParentToDerivativeSampleControl.derivative_sample_control_id' => $sampleData['SampleControl']['id']
                ),
                'recursive' => - 1
            ));
            if (! empty($tmpData['ParentToDerivativeSampleControl']['lab_book_control_id'])) {
                $structureName .= ",derivative_lab_book";
            }
        }
        $this->Structures->set($structureName);
        if (! $isFromTreeView) {
            $this->Structures->set('aliquot_masters', 'aliquot_masters_structure');
            
            // parse each group to load the required detailed aliquot structures
            $aliquotsStructures = array();
            foreach ($aliquotsData as $aliquotControlId => $aliquots) {
                $aliquotsStructures[$aliquotControlId] = $this->Structures->get('form', $aliquots[0]['AliquotControl']['form_alias']);
            }
            $this->set('aliquotsStructures', $aliquotsStructures);
        }
        
        // Define if this detail form is displayed into the collection content tree view
        $this->set('isFromTreeView', $isFromTreeView);
        
        // Get all sample control types to build the add to selected button
        $this->set('allowedDerivativeType', $this->SampleControl->getPermissibleSamplesArray($sampleData['SampleControl']['id']));
        
        // Get all aliquot control types to build the add to selected button
        $this->set('allowedAliquotType', $this->AliquotControl->getPermissibleAliquotsArray($sampleData['SampleControl']['id']));
        
        if (! $isSpecimen && ! $isFromTreeView) {
            // derivative aliquot source
            
            $joins = array(
                array(
                    'table' => 'source_aliquots',
                    'alias' => 'SourceAliquot',
                    'type' => 'INNER',
                    'conditions' => array(
                        'AliquotMaster.id = SourceAliquot.aliquot_master_id',
                        'SourceAliquot.deleted != 1',
                        'SourceAliquot.sample_master_id' => $sampleMasterId
                    )
                )
            );
            
            $aliquotSource = $this->AliquotMaster->find('all', array(
                'fields' => '*',
                'conditions' => array(
                    'AliquotMaster.collection_id' => $collectionId
                ),
                'joins' => $joins
            ));
            
            $this->set('aliquotSource', $aliquotSource);
            
            // Set structure
            $this->Structures->set('sourcealiquots,sourcealiquots_volume', 'aliquot_source_struct');
        }
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     *
     * @param $collectionId
     * @param $sampleControlId
     * @param int $parentSampleMasterId
     */
    public function add($collectionId, $sampleControlId, $parentSampleMasterId = 0)
    {
        if ($this->request->is('ajax')) {
            $this->layout = 'ajax';
        }
        
        // MANAGE DATA
        $sampleControlData = array();
        $parentSampleData = array();
        $parentToDerivativeSampleControl = null;
        
        $labBook = null;
        $labBookCtrlId = 0;
        $labBookFields = array();
        
        if ($parentSampleMasterId == 0) {
            // Created sample is a specimen
            $isSpecimen = true;
            
            // Get Control Data
            $sampleControlData = $this->SampleControl->getOrRedirect($sampleControlId);
            
            // Check collection id
            $collectionData = $this->Collection->getOrRedirect($collectionId);
        } else {
            // Created sample is a derivative: Get parent sample information
            $isSpecimen = false;
            
            // Get parent data
            $parentSampleData = $this->SampleMaster->find('first', array(
                'conditions' => array(
                    'SampleMaster.collection_id' => $collectionId,
                    'SampleMaster.id' => $parentSampleMasterId
                ),
                'recursive' => 0
            ));
            if (empty($parentSampleData)) {
                $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
            
            // Get Control Data
            $criteria = array(
                'ParentSampleControl.id' => $parentSampleData['SampleMaster']['sample_control_id'],
                'ParentToDerivativeSampleControl.flag_active' => '1',
                'DerivativeControl.id' => $sampleControlId
            );
            $parentToDerivativeSampleControl = $this->ParentToDerivativeSampleControl->find('first', array(
                'conditions' => $criteria
            ));
            if (empty($parentToDerivativeSampleControl)) {
                $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
            $sampleControlData['SampleControl'] = $parentToDerivativeSampleControl['DerivativeControl'];
            
            // Get Lab Book Ctrl Id & Fields
            $labBook = AppModel::getInstance("LabBook", "LabBookMaster", true);
            $labBookCtrlId = $parentToDerivativeSampleControl['ParentToDerivativeSampleControl']['lab_book_control_id'];
            $labBookFields = $labBook->getFields($labBookCtrlId);
        }
        $this->set("labBookFields", $labBookFields);
        
        // Set parent data
        $this->set('parentSampleDataForDisplay', $this->SampleMaster->formatParentSampleDataForDisplay($parentSampleData));
        $this->set('parentSampleMasterId', $parentSampleMasterId);
        
        // Set new sample control information
        $this->set('sampleControlData', $sampleControlData);
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        // Set menu
        $atimMenuLink = ($isSpecimen ? '/InventoryManagement/Collections/detail/%%Collection.id%%' : '/InventoryManagement/SampleMasters/listAllDerivatives/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%');
        $this->set('atimMenu', $this->Menus->get($atimMenuLink));
        
        $atimMenuVariables = (empty($parentSampleData) ? array(
            'Collection.id' => $collectionId
        ) : array(
            'Collection.id' => $collectionId,
            'SampleMaster.initial_specimen_sample_id' => $parentSampleData['SampleMaster']['initial_specimen_sample_id']
        ));
        
        $this->set('atimMenuVariables', $atimMenuVariables);
        
        // set structure alias based on VALUE from CONTROL table
        $structureName = $sampleControlData['SampleControl']['form_alias'];
        if ($labBookCtrlId != 0) {
            $structureName .= ",derivative_lab_book";
        }
        $this->Structures->set($structureName, 'atim_structure', array(
            'model_table_assoc' => array(
                'SampleDetail' => $sampleControlData['SampleControl']['detail_tablename']
            )
        ));
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        // MANAGE DATA RECORD
        
        if (empty($this->request->data)) {
            $this->request->data = array();
            $this->request->data['SampleControl']['sample_type'] = $sampleControlData['SampleControl']['sample_type'];
            $this->request->data['SampleControl']['sample_category'] = $sampleControlData['SampleControl']['sample_category'];
            
            // Set default reception date
            if ($isSpecimen && ! isset(AppController::getInstance()->passedArgs['templateInitId'])) {
                $defaultReceptionDatetime = null;
                $defaultReceptionDatetimeAccuracy = null;
                if ($this->SampleMaster->find('count', array(
                    'conditions' => array(
                        'SampleMaster.collection_id' => $collectionId
                    )
                )) == 0) {
                    $collection = $this->Collection->find('first', array(
                        'conditions' => array(
                            'Collection.id' => $collectionId
                        )
                    ));
                    $defaultReceptionDatetime = $collection['Collection']['collection_datetime'];
                    $defaultReceptionDatetimeAccuracy = $collection['Collection']['collection_datetime_accuracy'];
                } else {
                    $sample = $this->SampleMaster->find('first', array(
                        'conditions' => array(
                            'SampleMaster.collection_id' => $collectionId,
                            'SampleControl.sample_category' => 'specimen'
                        ),
                        'order' => array(
                            'SpecimenDetail.reception_datetime DESC'
                        )
                    ));
                    $defaultReceptionDatetime = $sample['SpecimenDetail']['reception_datetime'];
                    $defaultReceptionDatetimeAccuracy = $sample['SpecimenDetail']['reception_datetime_accuracy'];
                }
                if ($defaultReceptionDatetime) {
                    $this->request->data['SpecimenDetail']['reception_datetime'] = $defaultReceptionDatetime;
                    $this->request->data['SpecimenDetail']['reception_datetime_accuracy'] = $defaultReceptionDatetimeAccuracy;
                }
            }
            
            // Set default field values defined into the collection template
            if (isset(AppController::getInstance()->passedArgs['nodeIdWithDefaultValues'])) {
                $templateNodeModel = AppModel::getInstance("Tools", "TemplateNode", true);
                $templateNode = $templateNodeModel->find('first', array(
                    'conditions' => array(
                        'TemplateNode.id' => AppController::getInstance()->passedArgs['nodeIdWithDefaultValues']
                    )
                ));
                $templateNodeDefaultValues = array();
                foreach (json_decode($templateNode['TemplateNode']['default_values'], true) as $model => $fieldsValues) {
                    foreach ($fieldsValues as $field => $Value) {
                        if (is_array($Value)) {
                            $tmpDateTimeArray = array(
                                'year' => '',
                                'month' => '',
                                'day' => '',
                                'hour' => '',
                                'min' => '',
                                'sec' => ''
                            );
                            $tmpDateTimeArray = array_merge($tmpDateTimeArray, $Value);
                            $templateNodeDefaultValues["$model.$field"] = sprintf("%s-%s-%s %s:%s:%s", $tmpDateTimeArray['year'], $tmpDateTimeArray['month'], $tmpDateTimeArray['day'], $tmpDateTimeArray['hour'], $tmpDateTimeArray['min'], $tmpDateTimeArray['sec']);
                        } else {
                            $templateNodeDefaultValues["$model.$field"] = $Value;
                        }
                    }
                }
                $this->set('templateNodeDefaultValues', $templateNodeDefaultValues);
            }
            
            $hookLink = $this->hook('initial_display');
            if ($hookLink) {
                require ($hookLink);
            }
        } else {
            // Set additional data
            $this->request->data['SampleMaster']['collection_id'] = $collectionId;
            $this->request->data['SampleMaster']['sample_control_id'] = $sampleControlData['SampleControl']['id'];
            $this->request->data['SampleControl']['sample_type'] = $sampleControlData['SampleControl']['sample_type'];
            
            // Set either specimen or derivative additional data
            if ($isSpecimen) {
                // The created sample is a specimen
                if (isset($this->request->data['SampleMaster']['parent_id'])) {
                    $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
                
                $this->request->data['SampleMaster']['initial_specimen_sample_type'] = $this->request->data['SampleControl']['sample_type'];
                $this->request->data['SampleMaster']['initial_specimen_sample_id'] = null; // ID will be known after sample creation
            } else {
                // The created sample is a derivative
                $this->request->data['SampleMaster']['parent_sample_type'] = $parentSampleData['SampleControl']['sample_type'];
                $this->request->data['SampleMaster']['parent_id'] = $parentSampleData['SampleMaster']['id'];
                $this->SampleMaster->addWritableField(array(
                    'parent_id',
                    'parent_sample_type'
                ));
                
                $this->request->data['SampleMaster']['initial_specimen_sample_type'] = $parentSampleData['SampleMaster']['initial_specimen_sample_type'];
                $this->request->data['SampleMaster']['initial_specimen_sample_id'] = $parentSampleData['SampleMaster']['initial_specimen_sample_id'];
            }
            
            // Validates data
            
            $submittedDataValidates = true;
            
            $this->SampleMaster->set($this->request->data);
            $submittedDataValidates = ($this->SampleMaster->validates()) ? $submittedDataValidates : false;
            $this->request->data = $this->SampleMaster->data;
            
            // for error field highlight in detail
            $this->SampleDetail->validationErrors = $this->SampleMaster->validationErrors;
            
            if ($isSpecimen) {
                $this->SpecimenDetail->set($this->request->data);
                $submittedDataValidates = ($this->SpecimenDetail->validates()) ? $submittedDataValidates : false;
                $this->request->data['SpecimenDetail'] = $this->SpecimenDetail->data['SpecimenDetail'];
            } else {
                $this->DerivativeDetail->set($this->request->data);
                $submittedDataValidates = ($this->DerivativeDetail->validates()) ? $submittedDataValidates : false;
                $this->request->data['DerivativeDetail'] = $this->DerivativeDetail->data['DerivativeDetail'];
                
                // validate and sync lab book
                $msg = $this->SampleMaster->validateLabBook($this->request->data, $labBook, $labBookCtrlId, true);
                $this->DerivativeDetail->addWritableField('lab_book_master_id');
                
                if (strlen($msg) > 0) {
                    $this->DerivativeDetail->validationErrors['lab_book_master_code'][] = $msg;
                    $submittedDataValidates = false;
                }
            }
            
            $this->SampleMaster->addWritableField(array(
                'collection_id',
                'sample_control_id',
                'initial_specimen_sample_type',
                'initial_specimen_sample_id'
            ));
            $this->SampleMaster->addWritableField(array(
                'sample_master_id'
            ), $sampleControlData['SampleControl']['detail_tablename']);
            $this->SampleMaster->addWritableField(array(
                'sample_master_id'
            ), $isSpecimen ? 'specimen_details' : 'derivative_details');
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates) {
                // Save sample data
                $sampleMasterId = null;
                
                if ($this->SampleMaster->save($this->request->data, false)) {
                    
                    $sampleMasterId = $this->SampleMaster->getLastInsertId();
                    
                    // Record additional sample data
                    $queryToUpdate = null;
                    if ($isSpecimen) {
                        $queryToUpdate = "UPDATE sample_masters SET sample_masters.sample_code = sample_masters.id, sample_masters.initial_specimen_sample_id = sample_masters.id WHERE sample_masters.id = $sampleMasterId;";
                    } else {
                        $queryToUpdate = "UPDATE sample_masters SET sample_masters.sample_code = sample_masters.id WHERE sample_masters.id = $sampleMasterId;";
                    }
                    
                    $this->SampleMaster->tryCatchQuery($queryToUpdate);
                    $this->SampleMaster->tryCatchQuery(str_replace("sample_masters", "sample_masters_revs", $queryToUpdate));
                    
                    // Save either specimen or derivative detail
                    if ($isSpecimen) {
                        // SpecimenDetail
                        $this->request->data['SpecimenDetail']['sample_master_id'] = $sampleMasterId;
                        $this->SpecimenDetail->id = $sampleMasterId;
                        if (! $this->SpecimenDetail->save($this->request->data['SpecimenDetail'], false)) {
                            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                        }
                    } else {
                        // DerivativeDetail
                        $this->request->data['DerivativeDetail']['sample_master_id'] = $sampleMasterId;
                        $this->DerivativeDetail->id = $sampleMasterId;
                        if (! $this->DerivativeDetail->save($this->request->data['DerivativeDetail'], false)) {
                            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                        }
                    }
                    
                    $hookLink = $this->hook('postsave_process');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    
                    if ($this->request->is('ajax')) {
                        echo json_encode(array(
                            'goToNext' => true,
                            'display' => '',
                            'id' => $sampleMasterId
                        ));
                        exit();
                    } else {
                        $this->atimFlash(__('your data has been saved'), '/InventoryManagement/SampleMasters/detail/' . $collectionId . '/' . $sampleMasterId);
                    }
                }
            }
        }
        
        $this->set('isSpecimen', $isSpecimen);
        $this->set('isAjax', $this->request->is('ajax'));
    }

    /**
     *
     * @param $collectionId
     * @param $sampleMasterId
     */
    public function edit($collectionId, $sampleMasterId)
    {
        if ((! $collectionId) || (! $sampleMasterId)) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE DATA
        
        // Get the sample data
        
        $this->SampleMaster->unbindModel(array(
            'hasMany' => array(
                'AliquotMaster'
            )
        ));
        $sampleData = $this->SampleMaster->find('first', array(
            'conditions' => array(
                'SampleMaster.collection_id' => $collectionId,
                'SampleMaster.id' => $sampleMasterId
            )
        ));
        if (empty($sampleData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $isSpecimen = true;
        switch ($sampleData['SampleControl']['sample_category']) {
            case 'specimen':
                // Displayed sample is a specimen
                $isSpecimen = true;
                unset($sampleData['DerivativeDetail']);
                break;
            
            case 'derivative':
                // Displayed sample is a derivative
                $isSpecimen = false;
                unset($sampleData['SpecimenDetail']);
                break;
            
            default:
                $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Get parent sample information
        $parentSampleMasterId = $sampleData['SampleMaster']['parent_id'];
        $parentSampleData = $this->SampleMaster->find('first', array(
            'conditions' => array(
                'SampleMaster.collection_id' => $collectionId,
                'SampleMaster.id' => $parentSampleMasterId
            ),
            'recursive' => 0
        ));
        if (! empty($parentSampleMasterId) && empty($parentSampleData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $this->set('parentSampleDataForDisplay', $this->SampleMaster->formatParentSampleDataForDisplay($parentSampleData));
        
        // Manage Lab Book
        
        $labBook = null;
        $labBookCtrlId = 0;
        $labBookFields = array();
        
        if (! $isSpecimen) {
            // Set Lab book data for display
            $labBook = AppModel::getInstance("LabBook", "LabBookMaster", true);
            $labBookCtrlId = $this->ParentToDerivativeSampleControl->getLabBookControlId($parentSampleData['SampleMaster']['sample_control_id'], $sampleData['SampleMaster']['sample_control_id']);
            $labBookFields = $labBook->getFields($labBookCtrlId);
            
            // Set lab book code for initial display
            if (empty($this->request->data) && ! empty($sampleData['DerivativeDetail']['lab_book_master_id'])) {
                $previousLabook = $labBook->find('first', array(
                    'conditions' => array(
                        'id' => $sampleData['DerivativeDetail']['lab_book_master_id']
                    ),
                    'recursive' => - 1
                ));
                if (empty($previousLabook)) {
                    $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
                $sampleData['DerivativeDetail']['lab_book_master_code'] = $previousLabook['LabBookMaster']['code'];
            }
        }
        $this->set("labBookFields", $labBookFields);
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        // Get the current menu object. Needed to disable menu options based on sample category
        $this->setBatchMenu($sampleData);
        
        // Set structure
        $structureName = $sampleData['SampleControl']['form_alias'];
        if ($labBookCtrlId != 0) {
            $structureName .= ",derivative_lab_book";
        }
        $this->Structures->set($structureName, 'atim_structure', array(
            'model_table_assoc' => array(
                'SampleDetail' => $sampleData['SampleControl']['detail_tablename']
            )
        ));
        
        // MANAGE DATA RECORD
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($this->request->data)) {
            $this->request->data = $sampleData;
            
            $hookLink = $this->hook('initial_display');
            if ($hookLink) {
                require ($hookLink);
            }
        } else {
            // Update data
            if (isset($this->request->data['SampleMaster']['parent_id']) && ($sampleData['SampleMaster']['parent_id'] !== $this->request->data['SampleMaster']['parent_id'])) {
                $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
            
            // Validates data
            
            $submittedDataValidates = true;
            
            $this->SampleMaster->set($this->request->data);
            $this->SampleMaster->id = $sampleMasterId;
            $submittedDataValidates = ($this->SampleMaster->validates()) ? $submittedDataValidates : false;
            $this->request->data = $this->SampleMaster->data;
            
            // for error field highlight in detail
            $this->SampleDetail->validationErrors = $this->SampleMaster->validationErrors;
            
            if ($isSpecimen) {
                $this->SpecimenDetail->set($this->request->data);
                $submittedDataValidates = ($this->SpecimenDetail->validates()) ? $submittedDataValidates : false;
                $this->request->data['SpecimenDetail'] = $this->SpecimenDetail->data['SpecimenDetail'];
            } else {
                $this->DerivativeDetail->set($this->request->data);
                $submittedDataValidates = ($this->DerivativeDetail->validates()) ? $submittedDataValidates : false;
                $this->request->data['DerivativeDetail'] = $this->DerivativeDetail->data['DerivativeDetail'];
                
                // validate and sync or not lab book
                if (array_key_exists('sync_with_lab_book_now', $this->request->data)) {
                    $msg = $this->SampleMaster->validateLabBook($this->request->data, $labBook, $labBookCtrlId, $this->request->data[0]['sync_with_lab_book_now']);
                    if (strlen($msg) > 0) {
                        $this->DerivativeDetail->validationErrors['lab_book_master_code'][] = $msg;
                        $submittedDataValidates = false;
                    }
                }
            }
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates) {
                
                // AppModel::acquireBatchViewsUpdateLock(); See issue #2981
                
                // Save sample data
                $this->SampleMaster->id = $sampleMasterId;
                if ($this->SampleMaster->save($this->request->data, false)) {
                    // Save either Specimen or Derivative Details
                    if ($isSpecimen) {
                        // SpecimenDetail
                        $this->SpecimenDetail->id = $sampleMasterId;
                        $this->request->data['SpecimenDetail']['sample_master_id'] = $sampleMasterId;
                        $this->SpecimenDetail->addWritableField(array(
                            'sample_master_id'
                        ));
                        if (! $this->SpecimenDetail->save($this->request->data['SpecimenDetail'], false)) {
                            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                        }
                    } else {
                        // DerivativeDetail
                        $this->DerivativeDetail->id = $sampleMasterId;
                        $this->request->data['DerivativeDetail']['sample_master_id'] = $sampleMasterId;
                        $this->DerivativeDetail->addWritableField(array(
                            'sample_master_id'
                        ));
                        if (! $this->DerivativeDetail->save($this->request->data['DerivativeDetail'], false)) {
                            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                        }
                    }
                    
                    $hookLink = $this->hook('postsave_process');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    
                    $this->atimFlash(__('your data has been updated'), '/InventoryManagement/SampleMasters/detail/' . $collectionId . '/' . $sampleMasterId);
                }
                
                // AppModel::releaseBatchViewsUpdateLock(); See issue #2981
            }
        }
    }

    /**
     *
     * @param $collectionId
     * @param $sampleMasterId
     */
    public function delete($collectionId, $sampleMasterId)
    {
        // Get the sample data
        $sampleData = $this->SampleMaster->find('first', array(
            'conditions' => array(
                'SampleMaster.collection_id' => $collectionId,
                'SampleMaster.id' => $sampleMasterId
            ),
            'recursive' => 0
        ));
        if (empty($sampleData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $isSpecimen = true;
        switch ($sampleData['SampleControl']['sample_category']) {
            case 'specimen':
                // Displayed sample is a specimen
                $isSpecimen = true;
                break;
            
            case 'derivative':
                // Displayed sample is a derivative
                $isSpecimen = false;
                break;
            
            default:
                $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Check deletion is allowed
        $arrAllowDeletion = $this->SampleMaster->allowDeletion($sampleMasterId);
        
        $hookLink = $this->hook('delete');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if ($arrAllowDeletion['allow_deletion']) {
            if ($this->SampleMaster->atimDelete($sampleMasterId)) {
                
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                
                $this->atimFlash(__('your data has been deleted'), '/InventoryManagement/Collections/detail/' . $collectionId);
            } else {
                $this->atimFlashError(__('error deleting data - contact administrator'), '/InventoryManagement/Collections/detail/' . $collectionId);
            }
        } else {
            $this->atimFlashWarning(__($arrAllowDeletion['msg']), '/InventoryManagement/SampleMasters/detail/' . $collectionId . '/' . $sampleMasterId);
        }
    }

    /**
     *
     * @param null $aliquotMasterId
     */
    public function batchDerivativeInit($aliquotMasterId = null)
    {
        // Get Data
        $model = null;
        $key = null;
        
        $urlToCancel = 'javascript:history.go(-1)';
        if (isset($this->request->data['BatchSet']['id'])) {
            $urlToCancel = '/Datamart/BatchSets/listall/' . $this->request->data['BatchSet']['id'];
        } elseif (isset($this->request->data['node']['id'])) {
            $urlToCancel = '/Datamart/Browser/browse/' . $this->request->data['node']['id'];
        }
        
        $this->set('aliquotMasterId', $aliquotMasterId);
        
        $isMenuAlreadySet = false;
        if (isset($this->request->data['SampleMaster'])) {
            $model = 'SampleMaster';
            $key = 'id';
        } elseif (isset($this->request->data['ViewSample'])) {
            $model = 'ViewSample';
            $key = 'sample_master_id';
        } elseif ($aliquotMasterId != null) {
            $model = 'SampleMaster';
            $key = 'id';
            $aliquotMaster = $this->AliquotMaster->findById($aliquotMasterId);
            if (empty($aliquotMaster)) {
                $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
            
            $this->request->data['SampleMaster']['id'] = array(
                $aliquotMaster['SampleMaster']['id']
            );
            $this->set("aliquotIds", $aliquotMasterId);
            $urlToCancel = '/InventoryManagement/AliquotMasters/detail/' . $aliquotMaster['SampleMaster']['collection_id'] . '/' . $aliquotMaster['SampleMaster']['id'] . '/' . $aliquotMasterId;
            $isMenuAlreadySet = true;
            $this->setAliquotMenu($aliquotMaster);
        } elseif (isset($this->request->data['ViewAliquot']) || isset($this->request->data['AliquotMaster'])) {
            // aliquot init case
            $alqModel = 'ViewAliquot';
            $alqKey = 'aliquot_master_id';
            if (isset($this->request->data['AliquotMaster'])) {
                $alqModel = 'AliquotMaster';
                $alqKey = 'id';
            }
            if (isset($this->request->data['node']) && $this->request->data[$alqModel][$alqKey] == 'all') {
                $this->BrowsingResult = AppModel::getInstance('Datamart', 'BrowsingResult', true);
                $browsingResult = $this->BrowsingResult->find('first', array(
                    'conditions' => array(
                        'BrowsingResult.id' => $this->request->data['node']['id']
                    )
                ));
                $this->request->data[$alqModel][$alqKey] = explode(",", $browsingResult['BrowsingResult']['id_csv']);
            }
            $aliquotIds = array_filter($this->request->data[$alqModel][$alqKey]);
            
            if (empty($aliquotIds)) {
                $this->atimFlashWarning(__("batch init no data"), $urlToCancel);
            }
            $aliquotData = $this->AliquotMaster->find('all', array(
                'fields' => array(
                    'AliquotMaster.aliquot_control_id',
                    'AliquotMaster.sample_master_id'
                ),
                'conditions' => array(
                    'AliquotMaster.id' => $aliquotIds
                )
            ));
            
            if (empty($aliquotData)) {
                $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
            
            $ids = array();
            $expectedCtrlId = $aliquotData[0]['AliquotMaster']['aliquot_control_id'];
            foreach ($aliquotData as $aliquotUnit) {
                if ($aliquotUnit['AliquotMaster']['aliquot_control_id'] != $expectedCtrlId) {
                    $this->atimFlashWarning(__("you must select elements with a common type"), $urlToCancel);
                }
                $ids[] = $aliquotUnit['AliquotMaster']['sample_master_id'];
            }
            $this->request->data['SampleMaster'] = array(
                'id' => $ids
            );
            $model = 'SampleMaster';
            $key = 'id';
            $this->set("aliquotIds", implode(",", $aliquotIds));
        } else {
            $this->atimFlashError((__('you have been redirected automatically') . ' (#' . __LINE__ . ')'), $urlToCancel);
            return;
        }
        if (isset($this->request->data['node']) && $this->request->data[$model][$key] == 'all') {
            $this->BrowsingResult = AppModel::getInstance('Datamart', 'BrowsingResult', true);
            $browsingResult = $this->BrowsingResult->find('first', array(
                'conditions' => array(
                    'BrowsingResult.id' => $this->request->data['node']['id']
                )
            ));
            $this->request->data[$model][$key] = explode(",", $browsingResult['BrowsingResult']['id_csv']);
        }
        
        // Set url to redirect
        $this->set('urlToCancel', $urlToCancel);
        
        // Manage data
        $initData = $this->batchInit($this->SampleMaster, $model, $key, "sample_control_id", $this->ParentToDerivativeSampleControl, "parent_sample_control_id", "you cannot create derivatives for this sample type");
        if (array_key_exists('error', $initData)) {
            $this->atimFlashWarning(__($initData['error']), $urlToCancel);
            return;
        }
        
        // Manage structure and menus
        
        foreach ($initData['possibilities'] as $possibility) {
            SampleMaster::$derivativesDropdown[$possibility['DerivativeControl']['id']] = __($possibility['DerivativeControl']['sample_type']);
        }
        
        $this->set('ids', $initData['ids']);
        
        $this->Structures->set('derivative_init');
        if (! $isMenuAlreadySet)
            $this->setBatchMenu(array(
                'SampleMaster' => $initData['ids']
            ));
        $this->set('parentSampleControlId', $initData['control_id']);
        
        $this->set('skipLabBookSelectionStep', true);
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     *
     * @param null $aliquotMasterId
     */
    public function batchDerivativeInit2($aliquotMasterId = null)
    {
        if (! isset($this->request->data['SampleMaster']['ids']) || ! isset($this->request->data['SampleMaster']['sample_control_id']) || ! isset($this->request->data['ParentToDerivativeSampleControl']['parent_sample_control_id'])) {
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        } elseif ($this->request->data['SampleMaster']['sample_control_id'] == '') {
            $this->atimFlashWarning(__("you must select a derivative type"), "javascript:history.back();");
            return;
        }
        
        $this->set('aliquotMasterId', $aliquotMasterId);
        
        $model = empty($this->request->data['SampleMaster']['ids']) ? 'AliquotMaster' : 'SampleMaster';
        if (is_null($aliquotMasterId)) {
            $this->setBatchMenu(array(
                $model => $this->request->data[$model]['ids']
            ));
        } else {
            $aliquotMaster = $this->AliquotMaster->findById($aliquotMasterId);
            if (empty($aliquotMaster))
                $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            $this->setAliquotMenu($aliquotMaster);
        }
        $this->set('sampleMasterIds', $this->request->data['SampleMaster']['ids']);
        $this->set('sampleMasterControlId', $this->request->data['SampleMaster']['sample_control_id']);
        $this->set('parentSampleControlId', $this->request->data['ParentToDerivativeSampleControl']['parent_sample_control_id']);
        $this->setUrlToCancel();
        if (isset($this->request->data['AliquotMaster']['ids'])) {
            $this->set('aliquotMasterIds', $this->request->data['AliquotMaster']['ids']);
        }
        
        $tmp = $this->ParentToDerivativeSampleControl->find('first', array(
            'conditions' => array(
                'ParentToDerivativeSampleControl.parent_sample_control_id' => $this->request->data['ParentToDerivativeSampleControl']['parent_sample_control_id'],
                'ParentToDerivativeSampleControl.derivative_sample_control_id' => $this->request->data['SampleMaster']['sample_control_id']
            ),
            'fields' => array(
                'ParentToDerivativeSampleControl.lab_book_control_id'
            ),
            'recursive' => - 1
        ));
        
        if (is_numeric($tmp['ParentToDerivativeSampleControl']['lab_book_control_id'])) {
            $this->set('labBookControlId', $tmp['ParentToDerivativeSampleControl']['lab_book_control_id']);
            $this->Structures->set('derivative_lab_book');
            AppController::addWarningMsg(__('if no lab book has to be defined for this process, keep fields empty and click submit to continue'));
        } else {
            $this->Structures->set('empty');
            AppController::addWarningMsg(__('no lab book can be applied to the current item(s)') . __('click submit to continue'));
        }
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     *
     * @param null $aliquotMasterId
     */
    public function batchDerivative($aliquotMasterId = null)
    {
        $urlToCancel = isset($this->request->data['url_to_cancel']) ? $this->request->data['url_to_cancel'] : 'javascript:history.go(-1)';
        
        $uniqueAliquotMasterData = null;
        if (! is_null($aliquotMasterId)) {
            $uniqueAliquotMasterData = $this->AliquotMaster->findById($aliquotMasterId);
            if (empty($uniqueAliquotMasterData))
                $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            $urlToCancel = '/InventoryManagement/AliquotMasters/detail/' . $uniqueAliquotMasterData['AliquotMaster']['collection_id'] . '/' . $uniqueAliquotMasterData['AliquotMaster']['sample_master_id'] . '/' . $aliquotMasterId;
        }
        
        $this->set('urlToCancel', $urlToCancel);
        unset($this->request->data['url_to_cancel']);
        
        if (! isset($this->request->data['SampleMaster']['sample_control_id']) || ! isset($this->request->data['ParentToDerivativeSampleControl']['parent_sample_control_id'])) {
            $this->atimFlashError((__('you have been redirected automatically') . ' (#' . __LINE__ . ')'), $urlToCancel);
            return;
        } elseif ($this->request->data['SampleMaster']['sample_control_id'] == '') {
            $this->atimFlashWarning(__("you must select a derivative type"), $urlToCancel);
            return;
        }
        
        $this->set('aliquotMasterId', $aliquotMasterId);
        
        $labBookMasterCode = null;
        $syncWithLabBook = null;
        $labBookFields = null;
        $labBookId = null;
        $parentSampleControlId = $this->request->data['ParentToDerivativeSampleControl']['parent_sample_control_id'];
        unset($this->request->data['ParentToDerivativeSampleControl']);
        if (isset($this->request->data['DerivativeDetail']['lab_book_master_code']) && ! empty($this->request->data['DerivativeDetail']['lab_book_master_code'])) {
            $labBookMasterCode = $this->request->data['DerivativeDetail']['lab_book_master_code'];
            $syncWithLabBook = $this->request->data['DerivativeDetail']['sync_with_lab_book'];
            $labBook = AppModel::getInstance("LabBook", "LabBookMaster", true);
            $labBookExpectedCtrlId = $this->ParentToDerivativeSampleControl->getLabBookControlId($parentSampleControlId, $this->request->data['SampleMaster']['sample_control_id']);
            $foo = array();
            $result = $labBook->syncData($foo, array(), $labBookMasterCode, $labBookExpectedCtrlId);
            
            if (is_numeric($result)) {
                $labBookId = $result;
            } else {
                $this->atimFlashWarning(__($result), $urlToCancel);
                return;
            }
            $labBookData = $labBook->findById($labBookId);
            $labBookFields = $labBook->getFields($labBookData['LabBookControl']['id']);
        }
        $this->set('labBookMasterCode', $labBookMasterCode);
        $this->set('syncWithLabBook', $syncWithLabBook);
        $this->set('labBookFields', $labBookFields);
        unset($this->request->data['DerivativeDetail']);
        
        // Set structures and menu
        $ids = array_key_exists('ids', $this->request->data['SampleMaster']) ? $this->request->data['SampleMaster']['ids'] : $this->request->data['sample_master_ids'];
        $this->set('sampleMasterIds', $ids);
        unset($this->request->data['sample_master_ids']);
        
        if (is_null($aliquotMasterId)) {
            $this->setBatchMenu(array(
                'SampleMaster' => $ids
            ));
        } else {
            $this->setAliquotMenu($uniqueAliquotMasterData);
        }
        
        $childrenControlData = $this->SampleControl->findById($this->request->data['SampleMaster']['sample_control_id']);
        
        $this->Structures->set('view_sample_joined_to_collection', 'sample_info');
        $this->Structures->set(str_replace(",derivative_lab_book", "", $childrenControlData['SampleControl']['form_alias']), 'derivative_structure', array(
            'model_table_assoc' => array(
                'SampleDetail' => $childrenControlData['SampleControl']['detail_tablename']
            )
        ));
        $this->Structures->set(str_replace(",derivative_lab_book", "", $childrenControlData['SampleControl']['form_alias']) . ",sourcealiquots_volume_for_batchderivative", 'derivative_volume_structure');
        $this->Structures->set('used_aliq_in_stock_details', 'sourcealiquots');
        $this->Structures->set('used_aliq_in_stock_details,used_aliq_in_stock_detail_volume', 'aliquots_volume_structure');
        $this->Structures->set('empty', 'emptyStructure');
        
        $this->set('childrenSampleControlId', $this->request->data['SampleMaster']['sample_control_id']);
        $this->set('createdSampleStructureOverride', array(
            'SampleControl.sample_type' => $childrenControlData['SampleControl']['sample_type']
        ));
        $this->set('parentSampleControlId', $parentSampleControlId);
        
        $joins = array(
            array(
                'table' => 'view_samples',
                'alias' => 'ViewSample',
                'type' => 'INNER',
                'conditions' => array(
                    'AliquotMaster.sample_master_id = ViewSample.sample_master_id'
                )
            )
        );
        
        $displayBatchProcessAliqStorageAndInStockDetails = false;
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (isset($this->request->data['SampleMaster']['ids'])) {
            // 1- INITIAL DISPLAY
            $parentSampleDataForDisplay = array();
            $displayLimit = Configure::read('SampleDerivativeCreation_processed_items_limit');
            if (! empty($this->request->data['AliquotMaster']['ids'])) {
                $this->AliquotMaster->unbindModel(array(
                    'belongsTo' => array(
                        'SampleMaster'
                    )
                ));
                $aliquots = $this->AliquotMaster->find('all', array(
                    'conditions' => array(
                        'AliquotMaster.id' => explode(",", $this->request->data['AliquotMaster']['ids'])
                    ),
                    'fields' => array(
                        '*'
                    ),
                    'recursive' => 0,
                    'joins' => $joins
                ));
                if (sizeof($aliquots) > $displayLimit) {
                    $this->atimFlashWarning(__("batch init - number of submitted records too big") . " (>$displayLimit)", $urlToCancel);
                    return;
                }
                $this->AliquotMaster->sortForDisplay($aliquots, $this->request->data['AliquotMaster']['ids']);
                $this->request->data = array();
                foreach ($aliquots as $aliquot) {
                    $this->request->data[] = array(
                        'parent' => $aliquot,
                        'children' => array()
                    );
                    $parentSampleDataForDisplay[] = $aliquot;
                }
                
                $displayBatchProcessAliqStorageAndInStockDetails = sizeof($this->request->data) > 1;
            } else {
                $samples = $this->ViewSample->find('all', array(
                    'conditions' => array(
                        'ViewSample.sample_master_id' => explode(",", $this->request->data['SampleMaster']['ids'])
                    ),
                    'recursive' => - 1
                ));
                if (sizeof($samples) > $displayLimit) {
                    $this->atimFlashWarning(__("batch init - number of submitted records too big") . " (>$displayLimit)", $urlToCancel);
                    return;
                }
                $this->ViewSample->sortForDisplay($samples, $this->request->data['SampleMaster']['ids']);
                $this->request->data = array();
                foreach ($samples as $sample) {
                    $parentSampleDataForDisplay[] = $sample;
                    $this->request->data[] = array(
                        'parent' => $sample,
                        'children' => array()
                    );
                }
            }
            $this->set('parentSampleDataForDisplay', $this->SampleMaster->formatParentSampleDataForDisplay($parentSampleDataForDisplay));
            
            $hookLink = $this->hook('initial_display');
            if ($hookLink) {
                require ($hookLink);
            }
        } else {
            
            // 2- VALIDATE PROCESS
            
            // Parse First Section To Apply To All
            list ($usedAliquotDataToApplyToAll, $errorsOnFirstSectionToApplyToAll) = $this->AliquotMaster->getAliquotDataStorageAndStockToApplyToAll($this->request->data);
            
            unset($this->request->data['FunctionManagement']);
            unset($this->request->data['AliquotMaster']);
            unset($this->request->data['SampleMaster']);
            
            $prevData = $this->request->data;
            if (empty($prevData)) {
                $this->atimFlashWarning(__("at least one data has to be created"), "javascript:history.back();");
                return;
            }
            $this->request->data = array();
            $errors = $errorsOnFirstSectionToApplyToAll;
            $recordCounter = 0;
            $aliquotsData = array();
            $validationIterations = array(
                'SampleMaster',
                'DerivativeDetail',
                'SourceAliquot'
            );
            $setSourceAliquot = false;
            $parentSampleDataForDisplay = array();
            foreach ($prevData as $parentId => &$children) {
                $parent = null;
                $recordCounter ++;
                if (isset($children['AliquotMaster'])) {
                    if ($usedAliquotDataToApplyToAll)
                        $children = array_replace_recursive($children, $usedAliquotDataToApplyToAll);
                    
                    $setSourceAliquot = true;
                    $this->AliquotMaster->unbindModel(array(
                        'belongsTo' => array(
                            'SampleMaster'
                        )
                    ));
                    $parent = $this->AliquotMaster->find('first', array(
                        'conditions' => array(
                            'AliquotMaster.id' => $parentId
                        ),
                        'fields' => array(
                            '*'
                        ),
                        'recursive' => 0,
                        'joins' => $joins
                    ));
                    $parent['AliquotMaster'] = array_merge($parent['AliquotMaster'], $children['AliquotMaster']);
                    $parent['FunctionManagement'] = $children['FunctionManagement'];
                    $children['AliquotMaster']['id'] = $parentId;
                    $tmpStorageCoordX = $children['AliquotMaster']['storage_coord_x'];
                    $tmpStorageCoordY = $children['AliquotMaster']['storage_coord_y'];
                    $this->AliquotMaster->data = array();
                    unset($children['AliquotMaster']['storage_coord_x']);
                    unset($children['AliquotMaster']['storage_coord_y']);
                    $this->AliquotMaster->set($children['AliquotMaster']);
                    $this->AliquotMaster->validates();
                    foreach ($this->AliquotMaster->validationErrors as $field => $msgs) {
                        $msgs = is_array($msgs) ? $msgs : array(
                            $msgs
                        );
                        foreach ($msgs as $msg)
                            $errors[$field][$msg][$recordCounter] = $recordCounter;
                    }
                    $this->AliquotMaster->data['AliquotMaster']['storage_coord_x'] = $tmpStorageCoordX;
                    $this->AliquotMaster->data['AliquotMaster']['storage_coord_y'] = $tmpStorageCoordY;
                    $aliquotsData[] = array(
                        'AliquotMaster' => $this->AliquotMaster->data['AliquotMaster'],
                        'FunctionManagement' => $children['FunctionManagement']
                    );
                    unset($children['AliquotMaster'], $children['FunctionManagement'], $children['AliquotControl'], $children['StorageMaster']);
                } else {
                    $parent = $this->ViewSample->find('first', array(
                        'conditions' => array(
                            'ViewSample.sample_master_id' => $parentId
                        ),
                        'recursive' => - 1
                    ));
                }
                unset($children['ViewSample']);
                
                $newDerivativeCreated = ! empty($children);
                $sampleControlId = $childrenControlData['SampleControl']['id'];
                foreach ($children as &$child) {
                    $child['SampleMaster']['sample_control_id'] = $sampleControlId;
                    $child['SampleMaster']['collection_id'] = $parent['ViewSample']['collection_id'];
                    
                    $child['SampleMaster']['initial_specimen_sample_id'] = $parent['ViewSample']['initial_specimen_sample_id'];
                    $child['SampleMaster']['initial_specimen_sample_type'] = $parent['ViewSample']['initial_specimen_sample_type'];
                    
                    $child['SampleMaster']['parent_sample_type'] = $parent['ViewSample']['sample_type'];
                    
                    $child['DerivativeDetail']['sync_with_lab_book'] = $syncWithLabBook;
                    $child['DerivativeDetail']['lab_book_master_id'] = $labBookId;
                    
                    foreach ($validationIterations as $validationModelName) {
                        if (array_key_exists($validationModelName, $child)) {
                            $validationModel = $this->{$validationModelName};
                            $validationModel->data = array();
                            $validationModel->set($child);
                            if (! $validationModel->validates()) {
                                foreach ($validationModel->validationErrors as $field => $msgs) {
                                    $msgs = is_array($msgs) ? $msgs : array(
                                        $msgs
                                    );
                                    foreach ($msgs as $msg)
                                        $errors[$field][$msg][$recordCounter] = $recordCounter;
                                }
                            }
                            $child = $validationModel->data;
                        }
                    }
                }
                
                if ($labBookId != null) {
                    $labBook->syncData($children, array(
                        "DerivativeDetail"
                    ), $labBookMasterCode);
                }
                $this->request->data[] = array(
                    'parent' => $parent,
                    'children' => $children
                ); // prep data in case validation fails
                if (! $newDerivativeCreated) {
                    $errors[]['at least one child has to be created'][$recordCounter] = $recordCounter;
                }
                $parentSampleDataForDisplay[] = $parent;
            }
            $this->set('parentSampleDataForDisplay', $this->SampleMaster->formatParentSampleDataForDisplay($parentSampleDataForDisplay));
            
            $this->SourceAliquot->validationErrors = null;
            
            $displayBatchProcessAliqStorageAndInStockDetails = sizeof($aliquotsData) > 1;
            if ($usedAliquotDataToApplyToAll) {
                AppController::addWarningMsg(__('fields values of the first section have been applied to all other sections'));
            }
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            // 3- SAVE PROCESS
            
            if (empty($errors)) {
                unset($_SESSION['derivative_batch_process']);
                
                AppModel::acquireBatchViewsUpdateLock();
                
                // save
                $childIds = array();
                
                $this->SampleMaster->addWritableField(array(
                    'parent_id',
                    'sample_control_id',
                    'collection_id',
                    'initial_specimen_sample_id',
                    'initial_specimen_sample_type',
                    'parent_sample_type'
                ));
                $this->SampleMaster->addWritableField(array(
                    'sample_master_id'
                ), $childrenControlData['SampleControl']['detail_tablename']);
                $this->SampleMaster->addWritableField(array(
                    'sample_master_id'
                ), 'derivative_details');
                $this->DerivativeDetail->addWritableField(array(
                    'sync_with_lab_book',
                    'lab_book_master_id',
                    'sample_master_id'
                ));
                $this->SourceAliquot->addWritableField(array(
                    'sample_master_id',
                    'aliquot_master_id',
                    'used_volume'
                ));
                
                foreach ($prevData as $parentId => &$children) {
                    unset($children['ViewSample']);
                    unset($children['StorageMaster']);
                    foreach ($children as &$childToSave) {
                        // save sample master
                        $this->SampleMaster->id = null;
                        $this->SampleMaster->data = array(); // *** To guaranty no merge will be done with previous data ***
                        if (! $this->SampleMaster->save($childToSave, false)) {
                            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                        }
                        $childId = $this->SampleMaster->getLastInsertId();
                        
                        // Update sample code
                        $queryToUpdate = "UPDATE sample_masters SET sample_masters.sample_code = sample_masters.id WHERE sample_masters.id = $childId;";
                        $this->SampleMaster->tryCatchQuery($queryToUpdate);
                        $this->SampleMaster->tryCatchQuery(str_replace("sample_masters", "sample_masters_revs", $queryToUpdate));
                        
                        // Save derivative detail
                        $this->DerivativeDetail->data = array(); // *** To guaranty no merge will be done with previous data ***
                        $this->DerivativeDetail->id = $childId;
                        $childToSave['DerivativeDetail']['sample_master_id'] = $childId;
                        if (! $this->DerivativeDetail->save($childToSave, false)) {
                            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                        }
                        
                        if ($setSourceAliquot) {
                            // record aliquot use -> source_aliquots
                            $this->SourceAliquot->id = null;
                            $this->SourceAliquot->data = array();
                            $this->SourceAliquot->save(array(
                                'SourceAliquot' => array(
                                    'sample_master_id' => $childId,
                                    'aliquot_master_id' => $parentId,
                                    'used_volume' => isset($childToSave['SourceAliquot']['used_volume']) ? $childToSave['SourceAliquot']['used_volume'] : null
                                )
                            ));
                        }
                        
                        $childIds[] = $childId;
                    }
                }
                
                foreach ($aliquotsData as $aliquot) {
                    // update all used aliquots
                    $this->AliquotMaster->data = array();
                    if ($aliquot['FunctionManagement']['remove_from_storage'] || ($aliquot['AliquotMaster']['in_stock'] == 'no')) {
                        // Delete aliquot storage data
                        $aliquot['AliquotMaster']['storage_master_id'] = null;
                        $aliquot['AliquotMaster']['storage_coord_x'] = null;
                        $aliquot['AliquotMaster']['storage_coord_y'] = null;
                        $this->AliquotMaster->addWritableField(array(
                            'storage_master_id',
                            'storage_coord_x',
                            'storage_coord_y'
                        ));
                    } else {
                        $this->AliquotMaster->removeWritableField(array(
                            'storage_master_id',
                            'storage_coord_x',
                            'storage_coord_y'
                        ));
                    }
                    $this->AliquotMaster->id = $aliquot['AliquotMaster']['id'];
                    $this->AliquotMaster->save($aliquot, false);
                    $this->AliquotMaster->updateAliquotVolume($aliquot['AliquotMaster']['id']);
                }
                
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                
                AppModel::releaseBatchViewsUpdateLock();
                
                if (is_null($uniqueAliquotMasterData)) {
                    $datamartStructure = AppModel::getInstance("Datamart", "DatamartStructure", true);
                    $batchSetModel = AppModel::getInstance('Datamart', 'BatchSet', true);
                    $batchSetData = array(
                        'BatchSet' => array(
                            'datamart_structure_id' => $datamartStructure->getIdByModelName('ViewSample'),
                            'flag_tmp' => true
                        )
                    );
                    $batchSetModel->checkWritableFields = false;
                    $batchSetModel->saveWithIds($batchSetData, $childIds);
                    $this->atimFlash(__('your data has been saved'), '/Datamart/BatchSets/listall/' . $batchSetModel->getLastInsertId());
                } else {
                    if (! isset($uniqueAliquotMasterData['AliquotMaster'])) {
                        $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                    }
                    $this->atimFlash(__('your data has been saved'), '/InventoryManagement/SampleMasters/detail/' . $uniqueAliquotMasterData['AliquotMaster']['collection_id'] . '/' . $childIds[0] . '/');
                }
            } else {
                $this->SampleMaster->validationErrors = array();
                $this->SampleDetail->validationErrors = array();
                $this->DerivativeDetail->validationErrors = array();
                $this->AliquotMaster->validationErrors = array();
                $this->SourceAliquot->validationErrors = array();
                
                foreach ($errors as $field => $msgAndLines) {
                    foreach ($msgAndLines as $msg => $lines) {
                        $this->SampleMaster->validationErrors[$field][] = __($msg) . ' - ' . str_replace('%s', implode(",", $lines), __('see # %s'));
                    }
                }
            }
        }
        
        $this->set('displayBatchProcessAliqStorageAndInStockDetails', $displayBatchProcessAliqStorageAndInStockDetails);
        $this->Structures->set('batch_process_aliq_storage_and_in_stock_details', 'batch_process_aliq_storage_and_in_stock_details');
    }
}