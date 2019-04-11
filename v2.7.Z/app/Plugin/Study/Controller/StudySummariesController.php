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
 * Class StudySummariesController
 */
class StudySummariesController extends StudyAppController
{

    public $uses = array(
        'Study.StudySummary',
        
        'ClinicalAnnotation.MiscIdentifier',
        'ClinicalAnnotation.MiscIdentifierControl',
        'InventoryManagement.AliquotMaster',
        'InventoryManagement.AliquotInternalUse',
        'Order.Order',
        'Order.OrderLine'
    );

    public $paginate = array(
        'StudySummary' => array(
            'order' => 'StudySummary.title'
        ),
        'Participant' => array(
            'order' => 'Participant.last_name ASC, Participant.first_name ASC'
        ),
        'MiscIdentifier' => array(
            'order' => 'MiscIdentifier.study_summary_id ASC,MiscIdentifierControl.misc_identifier_name ASC'
        ),
        'ConsentMaster' => array(
            'order' => 'ConsentMaster.date_first_contact ASC'
        ),
        'AliquotMaster' => array(
            'order' => 'AliquotMaster.barcode ASC'
        ),
        'Order' => array(
            'order' => 'Order.date_order_placed DESC'
        ),
        'OrderLine' => array(
            'order' => 'OrderLine.date_required DESC'
        ),
        'TmaSlide' => array(
            'order' => 'TmaSlide.barcode DESC'
        )
    );

    /**
     *
     * @param string $searchId
     */
    public function search($searchId = '')
    {
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('pre_search_handler');
        if ($hookLink) {
            require ($hookLink);
        }
        
        $this->searchHandler($searchId, $this->StudySummary, 'studysummaries', '/Study/StudySummaries/search');
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
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
     * @param $studySummaryId
     */
    public function detail($studySummaryId)
    {
        // MANAGE DATA
        $this->request->data = $this->StudySummary->getOrRedirect($studySummaryId);
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atimMenuVariables', array(
            'StudySummary.id' => $studySummaryId
        ));
        
        $this->Structures->set('empty', 'emptyStructure');
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    public function add()
    {
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atimMenu', $this->Menus->get('/Study/StudySummaries/search'));
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (! empty($this->request->data)) {
            $submittedDataValidates = true;
            // ... special validations
            
            // 3- CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates) {
                if ($this->StudySummary->save($this->request->data)) {
                    $hookLink = $this->hook('postsave_process');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    $this->atimFlash(__('your data has been saved'), '/Study/StudySummaries/detail/' . $this->StudySummary->id);
                }
            }
        }
    }

    /**
     *
     * @param $studySummaryId
     */
    public function edit($studySummaryId)
    {
        // MANAGE DATA
        $studySummaryData = $this->StudySummary->getOrRedirect($studySummaryId);
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atimMenuVariables', array(
            'StudySummary.id' => $studySummaryId
        ));
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($this->request->data)) {
            $this->request->data = $studySummaryData;
        } else {
            $submittedDataValidates = true;
            // ... special validations
            
            // 3- CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates) {
                $this->StudySummary->id = $studySummaryId;
                if ($this->StudySummary->save($this->request->data)) {
                    $hookLink = $this->hook('postsave_process');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    $this->atimFlash(__('your data has been updated'), '/Study/StudySummaries/detail/' . $studySummaryId);
                }
            }
        }
    }

    /**
     *
     * @param $studySummaryId
     */
    public function delete($studySummaryId)
    {
        // MANAGE DATA
        $studySummaryData = $this->StudySummary->getOrRedirect($studySummaryId);
        
        $arrAllowDeletion = $this->StudySummary->allowDeletion($studySummaryId);
        
        // CUSTOM CODE
        $hookLink = $this->hook('delete');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if ($arrAllowDeletion['allow_deletion']) {
            // DELETE DATA
            if ($this->StudySummary->atimDelete($studySummaryId)) {
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                $this->atimFlash(__('your data has been deleted'), '/Study/StudySummaries/search/');
            } else {
                $this->atimFlashError(__('error deleting data - contact administrator'), '/Study/StudySummaries/search/');
            }
        } else {
            $this->atimFlashWarning(__($arrAllowDeletion['msg']), '/Study/StudySummaries/detail/' . $studySummaryId);
        }
    }

    /**
     *
     * @param $studySummaryId
     * @param null $specificListHeader
     */
    public function listAllLinkedRecords($studySummaryId, $specificListHeader = null)
    {
        if (! $this->request->is('ajax')) {
            $this->set('atimMenu', $this->Menus->get('/Study/StudySummaries/listAllLinkedRecords/%%StudySummary.id%%/'));
            $this->set('atimMenuVariables', array(
                'StudySummary.id' => $studySummaryId
            ));
        }
        
        // $linkedRecordsProperties: Keep value to null or false if custom paginate has to be done
        $linkedRecordsProperties = array(
            'participants' => array(
                'ClinicalAnnotation.MiscIdentifier.study_summary_id',
                '/ClinicalAnnotation/MiscIdentifiers/listall/',
                'miscidentifiers_for_participant_search',
                '/ClinicalAnnotation/Participants/profile/%%Participant.id%%',
                'MiscIdentifier'
            ),
            'consents' => array(
                'ClinicalAnnotation.ConsentMaster.study_summary_id',
                '/ClinicalAnnotation/ConsentMasters/listall/',
                'consent_masters,consent_masters_study',
                '/ClinicalAnnotation/ConsentMasters/detail/%%ConsentMaster.participant_id%%/%%ConsentMaster.id%%',
                'ConsentMaster'
            ),
            'aliquots' => array(
                'InventoryManagement.AliquotMaster.study_summary_id',
                '/InventoryManagement/AliquotMasters/detail/',
                'view_aliquot_joined_to_sample_and_collection',
                '/InventoryManagement/AliquotMasters/detail/%%ViewAliquot.collection_id%%/%%ViewAliquot.sample_master_id%%/%%ViewAliquot.aliquot_master_id%%',
                'ViewAliquot'
            ),
            'aliquot uses' => array(
                'InventoryManagement.AliquotInternalUse.study_summary_id',
                '/InventoryManagement/AliquotMasters/detail/',
                'aliquotinternaluses',
                '/InventoryManagement/AliquotMasters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%',
                'ViewAliquotUse'
            ),
            'orders' => array(
                'Order.Order.default_study_summary_id',
                '/Order/Orders/detail/',
                'orders',
                '/Order/Orders/detail/%%Order.id%%',
                'Order'
            ),
            'order lines' => array(
                'Order.OrderLine.study_summary_id',
                '/Order/Orders/detail/',
                'orders,orderlines',
                '/Order/OrderLines/detail/%%Order.id%%/%%OrderLine.id%%',
                'OrderLine'
            ),
            'tma slides' => array(
                'StorageLayout.TmaSlide.study_summary_id',
                '/StorageLayout/TmaSlides/detail/',
                'tma_slides,tma_blocks_for_slide_creation',
                '/StorageLayout/TmaSlides/detail/%%TmaSlide.tma_block_storage_master_id%%/%%TmaSlide.id%%',
                'TmaSlide'
            ),
            'tma slide uses' => array(
                'StorageLayout.TmaSlideUse.study_summary_id',
                '/StorageLayout/TmaSlideUses/listAll/',
                'tma_slide_uses,tma_slides_for_use_creation',
                '/StorageLayout/TmaSlides/detail/%%TmaSlide.tma_block_storage_master_id%%/%%TmaSlide.id%%',
                'TmaSlideUse'
            )
        );

        $hookLink = $this->hook('format_properties');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (! $specificListHeader) {
            
            // Manage All Lists Display
            $this->set('linkedRecordsHeaders', array_keys($linkedRecordsProperties));
            $this->set('linkedRecordsProperties', $linkedRecordsProperties);
            $this->set('studyLLData', $this->StudySummary->getSLLs());
            $this->Structures->set('empty', 'emptyStructure');
        } else {
            
            // Manage Display Of A Specific List
            if (! array_key_exists($specificListHeader, $linkedRecordsProperties))
                $this->redirect('/Pages/err_plugin_system_error', null, true);
            if ($linkedRecordsProperties[$specificListHeader]) {
                list ($pluginModelForeignKey, $permissionLink, $structureAlias, $detailsUrl) = $linkedRecordsProperties[$specificListHeader];
                list ($plugin, $model, $foreignKey) = explode('.', $pluginModelForeignKey);
                if (! isset($this->{$model})) {
                    $this->{$model} = AppModel::getInstance($plugin, $model, true);
                }
                $this->request->data = $this->paginate($this->{$model}, array(
                    "$model.$foreignKey" => $studySummaryId
                ));
                $this->Structures->set($structureAlias);
                $this->set('detailsUrl', $detailsUrl);
                $this->set('permissionLink', $permissionLink);
            } else {
                // Manage custom display
                $hookLink = $this->hook('format_custom_list_display');
                if ($hookLink) {
                    require ($hookLink);
                }
            }
        }
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    public function autocompleteStudy()
    {
        
        // -- NOTE ----------------------------------------------------------
        //
        // This function is linked to functions of the StudySummary model
        // called getStudyIdFromStudyDataAndCode() and
        // getStudyDataAndCodeForDisplay().
        //
        // When you override the autocompleteStudy() function, check
        // if you need to override these functions.
        //
        // ------------------------------------------------------------------
        
        // layout = ajax to avoid printing layout
        $this->layout = 'ajax';
        // debug = 0 to avoid printing debug queries that would break the javascript array
        Configure::write('debug', 0);
        
        // query the database
        $term = str_replace(array(
            "\\",
            '%',
            '_'
        ), array(
            "\\\\",
            '\%',
            '\_'
        ), $_GET['term']);
        $terms = array();
        foreach (explode(' ', $term) as $keyWord) {
            $terms[] = array(
                "StudySummary.title LIKE" => '%' . $keyWord . '%'
            );
        }
        
        $conditions = array(
            'AND' => $terms
        );
        $fields = 'StudySummary.*';
        $order = 'StudySummary.title ASC';
        $joins = array();
        
        $hookLink = $this->hook('query_args');
        if ($hookLink) {
            require ($hookLink);
        }
        
        $data = $this->StudySummary->find('all', array(
            'conditions' => $conditions,
            'fields' => $fields,
            'order' => $order,
            'joins' => $joins,
            'limit' => 10
        ));
        
        // build javascript textual array
        $result = "";
        foreach ($data as $dataUnit) {
            $result .= '"' . str_replace(array(
                '\\',
                '"'
            ), array(
                '\\\\',
                '\"'
            ), $this->StudySummary->getStudyDataAndCodeForDisplay($dataUnit)) . '", ';
        }
        if (sizeof($result) > 0) {
            $result = substr($result, 0, - 2);
        }
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        $this->set('result', "[" . $result . "]");
    }
}