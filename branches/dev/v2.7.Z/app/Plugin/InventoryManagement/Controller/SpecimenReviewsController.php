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
 * Class SpecimenReviewsController
 */
class SpecimenReviewsController extends InventoryManagementAppController
{

    public $components = array();

    public $uses = array(
        'InventoryManagement.Collection',
        'InventoryManagement.SampleMaster',
        
        'InventoryManagement.SpecimenReviewControl',
        'InventoryManagement.SpecimenReviewMaster',
        'InventoryManagement.SpecimenReviewDetail',
        
        'InventoryManagement.AliquotMaster',
        'InventoryManagement.AliquotReviewControl',
        'InventoryManagement.AliquotReviewMaster',
        'InventoryManagement.AliquotReviewDetail'
    );

    public $paginate = array(
        'SpecimenReviewMaster' => array(
            'order' => 'SpecimenReviewMaster.review_date ASC'
        ),
        'AliquotReviewMaster' => array(
            'order' => 'AliquotReviewMaster.review_code DESC'
        )
    );

    /**
     *
     * @param $collectionId
     * @param $sampleMasterId
     */
    public function listAll($collectionId, $sampleMasterId)
    {
        // MANAGE DATA
        $sampleData = $this->SampleMaster->find('first', array(
            'conditions' => array(
                'SampleMaster.collection_id' => $collectionId,
                'SampleMaster.id' => $sampleMasterId
            ),
            'recursive' => - 1
        ));
        if (empty($sampleData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $this->request->data = $this->paginate($this->SpecimenReviewMaster, array(
            'SpecimenReviewMaster.sample_master_id' => $sampleMasterId
        ));
        
        // Set list of available review
        $reviewControls = $this->SpecimenReviewControl->find('all', array(
            'conditions' => array(
                'SpecimenReviewControl.sample_control_id' => $sampleData['SampleMaster']['sample_control_id'],
                'SpecimenReviewControl.flag_active' => '1'
            )
        ));
        $this->set('reviewControls', $reviewControls);
        if (empty($reviewControls)) {
            $this->SpecimenReviewControl->validationErrors[][] = 'no path review exists for this type of sample';
        }
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        $this->set('atimMenu', $this->Menus->get('/InventoryManagement/SpecimenReviews/listAll/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%'));
        
        $this->set('atimMenuVariables', array(
            'Collection.id' => $sampleData['SampleMaster']['collection_id'],
            'SampleMaster.id' => $sampleMasterId,
            'SampleMaster.initial_specimen_sample_id' => $sampleData['SampleMaster']['initial_specimen_sample_id']
        ));
        
        $this->Structures->set('specimen_review_masters');
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     *
     * @param $collectionId
     * @param $sampleMasterId
     * @param $specimenReviewControlId
     */
    public function add($collectionId, $sampleMasterId, $specimenReviewControlId)
    {
        // MANAGE DATA
        $sampleData = $this->SampleMaster->find('first', array(
            'conditions' => array(
                'SampleMaster.collection_id' => $collectionId,
                'SampleMaster.id' => $sampleMasterId
            ),
            'recursive' => - 1
        ));
        if (empty($sampleData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $criteria = array(
            'SpecimenReviewControl.id' => $specimenReviewControlId,
            'SpecimenReviewControl.sample_control_id' => $sampleData['SampleMaster']['sample_control_id'],
            'SpecimenReviewControl.flag_active' => '1'
        );
        $reviewControlData = $this->SpecimenReviewControl->find('first', array(
            'conditions' => $criteria,
            'recursive' => 2
        ));
        
        if (empty($reviewControlData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $this->set('reviewControlData', $reviewControlData);
        
        $isAliquotReviewDefined = false;
        if (array_key_exists('flag_active', $reviewControlData['AliquotReviewControl']) && $reviewControlData['AliquotReviewControl']['flag_active']) {
            $isAliquotReviewDefined = true;
        }
        $this->set('isAliquotReviewDefined', $isAliquotReviewDefined);
        
        // Set available aliquot
        if ($isAliquotReviewDefined) {
            $this->set('aliquotList', $this->AliquotReviewMaster->getAliquotListForReview($sampleMasterId, (($reviewControlData['AliquotReviewControl']['aliquot_type_restriction'] == 'all') ? null : $reviewControlData['AliquotReviewControl']['aliquot_type_restriction'])));
        }
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        $this->set('atimMenu', $this->Menus->get('/InventoryManagement/SpecimenReviews/listAll/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%'));
        
        $this->set('atimMenuVariables', array(
            'Collection.id' => $sampleData['SampleMaster']['collection_id'],
            'SampleMaster.id' => $sampleMasterId,
            'SampleMaster.initial_specimen_sample_id' => $sampleData['SampleMaster']['initial_specimen_sample_id'],
            'SpecimenReviewControl.id' => $specimenReviewControlId
        ));
        
        $this->Structures->set($reviewControlData['SpecimenReviewControl']['form_alias'], 'specimen_review_structure');
        if ($isAliquotReviewDefined) {
            $this->Structures->set('empty', 'emptyStructure');
            $this->Structures->set($reviewControlData['AliquotReviewControl']['form_alias'], 'aliquot_review_structure');
        }
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($this->request->data)) {
            $this->request->data = null;
            $this->set('specimenReviewData', array());
            $this->set('aliquotReviewData', array());
            
            $hookLink = $this->hook('initial_display');
            if ($hookLink) {
                require ($hookLink);
            }
        } else {
            // reset array
            $specimenReviewData['SpecimenReviewMaster'] = $this->request->data['SpecimenReviewMaster'];
            $specimenReviewData['SpecimenReviewDetail'] = array_key_exists('SpecimenReviewDetail', $this->request->data) ? $this->request->data['SpecimenReviewDetail'] : array();
            unset($this->request->data['SpecimenReviewMaster']);
            unset($this->request->data['SpecimenReviewDetail']);
            $aliquotReviewData = $this->request->data;
            $this->request->data = null;
            
            $specimenReviewData['SpecimenReviewMaster']['specimen_review_control_id'] = $specimenReviewControlId;
            $specimenReviewData['SpecimenReviewMaster']['collection_id'] = $collectionId;
            $specimenReviewData['SpecimenReviewMaster']['sample_master_id'] = $sampleMasterId;
            
            foreach ($aliquotReviewData as $key => $newAliquotReview) {
                $aliquotReviewData[$key]['AliquotReviewMaster']['aliquot_review_control_id'] = $reviewControlData['AliquotReviewControl']['id'];
            }
            
            $this->set('specimenReviewData', $specimenReviewData);
            $this->set('aliquotReviewData', $aliquotReviewData);
            
            // LAUNCH SPECIAL VALIDATION PROCESS
            $submittedDataValidates = true;
            
            // Validate specimen review
            $this->SpecimenReviewMaster->set($specimenReviewData);
            $submittedDataValidates = ($this->SpecimenReviewMaster->validates()) ? $submittedDataValidates : false;
            $specimenReviewData = $this->SpecimenReviewMaster->data;
            
            // Validate aliquot review
            if ($isAliquotReviewDefined) {
                $allAliquotReviewMasterErrors = array();
                foreach ($aliquotReviewData as &$newAliquotReview) {
                    // Aliquot Review Master
                    unset($newAliquotReview['AliquotReviewMaster']['id']);
                    $this->AliquotReviewMaster->set($newAliquotReview);
                    $submittedDataValidates = ($this->AliquotReviewMaster->validates()) ? $submittedDataValidates : false;
                    $allAliquotReviewMasterErrors = array_merge($allAliquotReviewMasterErrors, $this->AliquotReviewMaster->validationErrors);
                    $newAliquotReview = $this->AliquotReviewMaster->data;
                }
                if (! empty($allAliquotReviewMasterErrors)) {
                    $this->AliquotReviewMaster->validationErrors = array();
                    foreach ($allAliquotReviewMasterErrors as $field => $msgs) {
                        $msgs = is_array($msgs) ? $msgs : array(
                            $msgs
                        );
                        foreach ($msgs as $errorMessage)
                            $this->AliquotReviewMaster->validationErrors[$field][] = $errorMessage;
                    }
                }
            }
            
            // CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            // LAUNCH SAVE PROCESS
            if ($submittedDataValidates) {
                
                // Set additional specimen review data and save
                unset($specimenReviewData['SpecimenReviewMaster']['id']);
                $this->SpecimenReviewMaster->addWritableField(array(
                    'specimen_review_control_id',
                    'collection_id',
                    'sample_master_id'
                ));
                if (! $this->SpecimenReviewMaster->save($specimenReviewData, false)) {
                    $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
                $specimenReviewMasterId = $this->SpecimenReviewMaster->id;
                
                $studiedAliquotMasterIds = array();
                if ($isAliquotReviewDefined) {
                    $this->AliquotReviewMaster->writableFieldsMode = 'addgrid';
                    $this->AliquotReviewMaster->addWritableField(array(
                        'aliquot_review_control_id',
                        'specimen_review_master_id'
                    ));
                    foreach ($aliquotReviewData as $newAliquotReviewToSave) {
                        // Save aliquot review
                        $this->AliquotReviewMaster->id = null;
                        $this->AliquotReviewMaster->data = array(); // *** To guaranty no merge will be done with previous data ***
                        unset($newAliquotReviewToSave['AliquotReviewMaster']['id']);
                        $newAliquotReviewToSave['AliquotReviewMaster']['specimen_review_master_id'] = $specimenReviewMasterId;
                        if (! $this->AliquotReviewMaster->save($newAliquotReviewToSave, false)) {
                            $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                        }
                        
                        // Track aliquot to update
                        if (! empty($newAliquotReviewToSave['AliquotReviewMaster']['aliquot_master_id'])) {
                            $studiedAliquotMasterIds[] = $newAliquotReviewToSave['AliquotReviewMaster']['aliquot_master_id'];
                        }
                    }
                }
                
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                $this->atimFlash(__('your data has been saved'), '/InventoryManagement/SpecimenReviews/detail/' . $collectionId . '/' . $sampleMasterId . '/' . $specimenReviewMasterId);
            }
        }
    }

    /**
     *
     * @param $collectionId
     * @param $sampleMasterId
     * @param $specimenReviewId
     * @param bool $aliquotMasterIdFromTreeView
     */
    public function detail($collectionId, $sampleMasterId, $specimenReviewId, $aliquotMasterIdFromTreeView = false)
    {
        
        // MANAGE DATA
        $this->request->data = null;
        
        $sampleData = $this->SampleMaster->find('first', array(
            'conditions' => array(
                'SampleMaster.collection_id' => $collectionId,
                'SampleMaster.id' => $sampleMasterId
            ),
            'recursive' => - 1
        ));
        if (empty($sampleData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Get specimen review data
        $criteria = array(
            'SpecimenReviewMaster.id' => $specimenReviewId,
            'SpecimenReviewMaster.collection_id' => $collectionId,
            'SpecimenReviewMaster.sample_master_id' => $sampleMasterId
        );
        $specimenReviewData = $this->SpecimenReviewMaster->find('first', array(
            'conditions' => $criteria,
            'recursive' => 2
        ));
        if (empty($specimenReviewData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        $this->set('specimenReviewData', $specimenReviewData);
        
        $isAliquotReviewDefined = false;
        if (array_key_exists('flag_active', $specimenReviewData['SpecimenReviewControl']['AliquotReviewControl']) && $specimenReviewData['SpecimenReviewControl']['AliquotReviewControl']['flag_active']) {
            $isAliquotReviewDefined = true;
        }
        $this->set('isAliquotReviewDefined', $isAliquotReviewDefined);
        
        // Get Aliquot Review Data
        if ($isAliquotReviewDefined) {
            $criteria = array(
                'AliquotReviewMaster.specimen_review_master_id' => $specimenReviewId,
                'AliquotReviewMaster.aliquot_review_control_id' => $specimenReviewData['SpecimenReviewControl']['AliquotReviewControl']['id']
            );
            if ($aliquotMasterIdFromTreeView)
                $criteria['AliquotReviewMaster.aliquot_master_id'] = $aliquotMasterIdFromTreeView;
            $aliquotReviewData = $this->AliquotReviewMaster->find('all', array(
                'conditions' => $criteria
            ));
            $this->set('aliquotReviewData', $aliquotReviewData);
        }
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        $this->set('atimMenu', $this->Menus->get('/InventoryManagement/SpecimenReviews/listAll/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%'));
        
        $this->set('atimMenuVariables', array(
            'Collection.id' => $sampleData['SampleMaster']['collection_id'],
            'SampleMaster.id' => $sampleMasterId,
            'SampleMaster.initial_specimen_sample_id' => $sampleData['SampleMaster']['initial_specimen_sample_id'],
            'SpecimenReviewMaster.id' => $specimenReviewId
        ));
        
        $this->Structures->set($specimenReviewData['SpecimenReviewControl']['form_alias'], 'specimen_review_structure');
        if ($isAliquotReviewDefined) {
            $this->Structures->set('empty', 'emptyStructure');
            $this->Structures->set($specimenReviewData['SpecimenReviewControl']['AliquotReviewControl']['form_alias'], 'aliquot_review_structure');
        }
        
        $this->set('aliquotMasterIdFromTreeView', $aliquotMasterIdFromTreeView);
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     *
     * @param $collectionId
     * @param $sampleMasterId
     * @param $specimenReviewId
     * @param bool $undo
     */
    public function edit($collectionId, $sampleMasterId, $specimenReviewId, $undo = false)
    {
        // MANAGE DATA
        
        // Get sample data
        $sampleData = $this->SampleMaster->find('first', array(
            'conditions' => array(
                'SampleMaster.collection_id' => $collectionId,
                'SampleMaster.id' => $sampleMasterId
            ),
            'recursive' => - 1
        ));
        if (empty($sampleData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Get specimen review data
        $criteria = array(
            'SpecimenReviewMaster.id' => $specimenReviewId,
            'SpecimenReviewMaster.collection_id' => $collectionId,
            'SpecimenReviewMaster.sample_master_id' => $sampleMasterId
        );
        $initialSpecimenReviewData = $this->SpecimenReviewMaster->find('first', array(
            'conditions' => $criteria,
            'recursive' => 2
        ));
        if (empty($initialSpecimenReviewData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $isAliquotReviewDefined = false;
        if (array_key_exists('flag_active', $initialSpecimenReviewData['SpecimenReviewControl']['AliquotReviewControl']) && $initialSpecimenReviewData['SpecimenReviewControl']['AliquotReviewControl']['flag_active']) {
            $isAliquotReviewDefined = true;
        }
        $this->set('isAliquotReviewDefined', $isAliquotReviewDefined);
        
        $reviewControlData = array(
            'SpecimenReviewControl' => $initialSpecimenReviewData['SpecimenReviewControl']
        );
        $this->set('reviewControlData', $reviewControlData);
        
        // Get Aliquot Review Data
        $initialAliquotReviewDataList = array();
        if ($isAliquotReviewDefined) {
            $criteria = array(
                'AliquotReviewMaster.specimen_review_master_id' => $specimenReviewId,
                'AliquotReviewMaster.aliquot_review_control_id' => $initialSpecimenReviewData['SpecimenReviewControl']['AliquotReviewControl']['id']
            );
            $initialAliquotReviewDataList = $this->AliquotReviewMaster->find('all', array(
                'conditions' => $criteria
            ));
            
            // Set available aliquot
            $this->set('aliquotList', $this->AliquotReviewMaster->getAliquotListForReview($sampleMasterId, (($initialSpecimenReviewData['SpecimenReviewControl']['AliquotReviewControl']['aliquot_type_restriction'] == 'all') ? null : $initialSpecimenReviewData['SpecimenReviewControl']['AliquotReviewControl']['aliquot_type_restriction'])));
        }
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        $this->set('atimMenu', $this->Menus->get('/InventoryManagement/SpecimenReviews/listAll/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%'));
        
        $this->set('atimMenuVariables', array(
            'Collection.id' => $sampleData['SampleMaster']['collection_id'],
            'SampleMaster.id' => $sampleMasterId,
            'SampleMaster.initial_specimen_sample_id' => $sampleData['SampleMaster']['initial_specimen_sample_id'],
            'SpecimenReviewMaster.id' => $specimenReviewId
        ));
        
        $this->Structures->set($initialSpecimenReviewData['SpecimenReviewControl']['form_alias'], 'specimen_review_structure');
        if ($isAliquotReviewDefined) {
            $this->Structures->set('empty', 'emptyStructure');
            $this->Structures->set($initialSpecimenReviewData['SpecimenReviewControl']['AliquotReviewControl']['form_alias'], 'aliquot_review_structure');
        }
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($this->request->data) || $undo) {
            $this->request->data = null;
            $this->set('specimenReviewData', $initialSpecimenReviewData);
            $this->set('aliquotReviewData', $initialAliquotReviewDataList);
            
            $hookLink = $this->hook('initial_display');
            if ($hookLink) {
                require ($hookLink);
            }
        } else {
            // reset array
            $specimenReviewData['SpecimenReviewMaster'] = $this->request->data['SpecimenReviewMaster'];
            $specimenReviewData['SpecimenReviewDetail'] = array_key_exists('SpecimenReviewDetail', $this->request->data) ? $this->request->data['SpecimenReviewDetail'] : array();
            unset($this->request->data['SpecimenReviewMaster']);
            unset($this->request->data['SpecimenReviewDetail']);
            $aliquotReviewData = array_values($this->request->data); // compact the array as some key might be missing
            $this->request->data = null;
            
            $this->set('specimenReviewData', $specimenReviewData);
            $this->set('aliquotReviewData', $aliquotReviewData);
            
            // LAUNCH SPECIAL VALIDATION PROCESS
            // Validate specimen review
            $this->SpecimenReviewMaster->set($specimenReviewData);
            $this->SpecimenReviewMaster->id = $specimenReviewId;
            $submittedDataValidates = $this->SpecimenReviewMaster->validates();
            $specimenReviewData = $this->SpecimenReviewMaster->data;
            
            // Validate aliquot review
            if ($isAliquotReviewDefined) {
                $allAliquotReviewMasterErrors = array();
                foreach ($aliquotReviewData as $key => &$newAliquotReview) {
                    // Aliquot Review Master
                    if ($newAliquotReview['AliquotReviewMaster']['id']) {
                        $tmp = $this->AliquotReviewMaster->getOrRedirect($newAliquotReview['AliquotReviewMaster']['id']);
                        if (! $tmp || $tmp['AliquotReviewMaster']['specimen_review_master_id'] != $specimenReviewId) {
                            // hack attempt or deleted prior to save
                            unset($aliquotReviewData[$key]);
                        }
                    } else {
                        $newAliquotReview['AliquotReviewMaster']['aliquot_review_control_id'] = $reviewControlData['SpecimenReviewControl']['AliquotReviewControl']['id'];
                        $newAliquotReview['AliquotReviewMaster']['specimen_review_master_id'] = $specimenReviewId;
                    }
                    $this->AliquotReviewMaster->data = array();
                    $this->AliquotReviewMaster->set($newAliquotReview);
                    $submittedDataValidates = $this->AliquotReviewMaster->validates() && $submittedDataValidates;
                    $newAliquotReview = $this->AliquotReviewMaster->data;
                    $allAliquotReviewMasterErrors = array_merge($allAliquotReviewMasterErrors, $this->AliquotReviewMaster->validationErrors);
                }
                if (! empty($allAliquotReviewMasterErrors)) {
                    $this->AliquotReviewMaster->validationErrors = array();
                    foreach ($allAliquotReviewMasterErrors as $field => $msgs) {
                        $msgs = is_array($msgs) ? $msgs : array(
                            $msgs
                        );
                        foreach ($msgs as $errorMessage)
                            $this->AliquotReviewMaster->validationErrors[$field][] = $errorMessage;
                    }
                }
            }
            
            // CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            // LAUNCH SAVE PROCESS
            if ($submittedDataValidates) {
                // Set additional specimen review data and save
                $this->SpecimenReviewMaster->id = $specimenReviewId;
                if (! $this->SpecimenReviewMaster->save($specimenReviewData, false)) {
                    $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
                
                if ($isAliquotReviewDefined) {
                    // Build aliquot review array with id = key
                    $initialAliquotReviewDataFromId = array();
                    $aliquotIdsToUpdate = array();
                    
                    foreach ($initialAliquotReviewDataList as $initialAliquotReview) {
                        $initialAliquotReviewDataFromId[$initialAliquotReview['AliquotReviewMaster']['id']] = array(
                            'AliquotReviewMaster' => $initialAliquotReview['AliquotReviewMaster']
                        );
                        
                        // Track aliquot that should be udpated
                        $studiedAliquotMasterId = $initialAliquotReview['AliquotReviewMaster']['aliquot_master_id'];
                        if (! empty($studiedAliquotMasterId)) {
                            $aliquotIdsToUpdate[$studiedAliquotMasterId] = $studiedAliquotMasterId;
                        }
                    }
                    
                    // Launch process to update/create/delete aliquot review
                    $this->AliquotReviewMaster->writableFieldsMode = 'editgrid';
                    foreach ($aliquotReviewData as $key => $submittedAliquotReview) {
                        // Track aliquot that should be udpated
                        $studiedAliquotMasterId = $submittedAliquotReview['AliquotReviewMaster']['aliquot_master_id'];
                        if (! empty($studiedAliquotMasterId)) {
                            $aliquotIdsToUpdate[$studiedAliquotMasterId] = $studiedAliquotMasterId;
                        }
                        
                        if (isset($initialAliquotReviewDataFromId[$submittedAliquotReview['AliquotReviewMaster']['id']])) {
                            
                            // ---------------------------------------------------------------------------
                            // 1- Existing aliquot review to update
                            // ---------------------------------------------------------------------------
                            
                            $aliquotReviewId = $submittedAliquotReview['AliquotReviewMaster']['id'];
                            $initialAliquotReview = $initialAliquotReviewDataFromId[$aliquotReviewId];
                            unset($initialAliquotReviewDataFromId[$aliquotReviewId]);
                            
                            $this->AliquotReviewMaster->data = array();
                            $this->AliquotReviewMaster->id = $aliquotReviewId;
                            if (! $this->AliquotReviewMaster->save($submittedAliquotReview, false)) {
                                $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                            }
                        } else {
                            
                            // ---------------------------------------------------------------------------
                            // 2- New aliquot review to create
                            // ---------------------------------------------------------------------------
                            
                            $this->AliquotReviewMaster->data = array();
                            $this->AliquotReviewMaster->id = null;
                            unset($submittedAliquotReview['AliquotReviewMaster']['id']);
                            $this->AliquotReviewMaster->addWritableField(array(
                                'aliquot_review_control_id',
                                'specimen_review_master_id'
                            ));
                            if (! $this->AliquotReviewMaster->save($submittedAliquotReview, false)) {
                                $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                            }
                            $this->AliquotReviewMaster->removeWritableField(array(
                                'aliquot_review_control_id',
                                'specimen_review_master_id'
                            ));
                        }
                    }
                    
                    // ---------------------------------------------------------------------------
                    // 3- Old aliquot review to delete
                    // ---------------------------------------------------------------------------
                    
                    foreach ($initialAliquotReviewDataFromId as $initialAliquotReviewToDelete) {
                        $aliquotReviewIdToDelete = $initialAliquotReviewToDelete['AliquotReviewMaster']['id'];
                        if (! $this->AliquotReviewMaster->atimDelete($aliquotReviewIdToDelete)) {
                            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                        }
                    }
                }
                
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                $this->atimFlash(__('your data has been saved'), '/InventoryManagement/SpecimenReviews/detail/' . $collectionId . '/' . $sampleMasterId . '/' . $specimenReviewId);
            }
        }
    }

    /**
     *
     * @param $collectionId
     * @param $sampleMasterId
     * @param $specimenReviewId
     */
    public function delete($collectionId, $sampleMasterId, $specimenReviewId)
    {
        // MANAGE DATA
        
        // Get sample data
        $sampleData = $this->SampleMaster->find('first', array(
            'conditions' => array(
                'SampleMaster.collection_id' => $collectionId,
                'SampleMaster.id' => $sampleMasterId
            ),
            'recursive' => - 1
        ));
        if (empty($sampleData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Get specimen review data
        $criteria = array(
            'SpecimenReviewMaster.id' => $specimenReviewId,
            'SpecimenReviewMaster.collection_id' => $collectionId,
            'SpecimenReviewMaster.sample_master_id' => $sampleMasterId
        );
        $specimenReviewData = $this->SpecimenReviewMaster->find('first', array(
            'conditions' => $criteria,
            'recursive' => 2
        ));
        if (empty($specimenReviewData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Get Aliquot Review Data
        $criteria = array(
            'AliquotReviewMaster.specimen_review_master_id' => $specimenReviewId
        );
        $aliquotReviewDataList = $this->AliquotReviewMaster->find('all', array(
            'conditions' => $criteria
        ));
        
        // Check deletion is allowed
        $arrAllowDeletion = $this->SpecimenReviewMaster->allowDeletion($specimenReviewId);
        
        // CUSTOM CODE
        
        $hookLink = $this->hook('delete');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if ($arrAllowDeletion['allow_deletion']) {
            $aliquotIdsToUpdate = array();
            
            // 1- Delete aliquot review
            foreach ($aliquotReviewDataList as $newLinkedReview) {
                // Track aliquot that should be udpated
                $studiedAliquotMasterId = $newLinkedReview['AliquotReviewMaster']['aliquot_master_id'];
                if (! empty($studiedAliquotMasterId))
                    $aliquotIdsToUpdate[$studiedAliquotMasterId] = $studiedAliquotMasterId;
                
                $aliquotReviewIdToDelete = $newLinkedReview['AliquotReviewMaster']['id'];
                if (! $this->AliquotReviewMaster->atimDelete($aliquotReviewIdToDelete)) {
                    $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
            }
            
            // 2- Delete sample review
            if (! $this->SpecimenReviewMaster->atimDelete($specimenReviewId)) {
                $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
            
            $hookLink = $this->hook('postsave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            $this->atimFlash(__('your data has been deleted'), '/InventoryManagement/SpecimenReviews/listAll/' . $collectionId . '/' . $sampleMasterId);
        } else {
            $this->atimFlashWarning(__($arrAllowDeletion['msg']), '/InventoryManagement/SpecimenReviews/detail/' . $collectionId . '/' . $sampleMasterId . '/' . $specimenReviewId);
        }
    }
}