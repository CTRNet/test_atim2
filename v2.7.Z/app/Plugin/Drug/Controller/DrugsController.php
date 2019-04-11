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
 * Class DrugsController
 */
class DrugsController extends DrugAppController
{

    public $uses = array(
        'Drug.Drug'
    );

    public $paginate = array(
        'Drug' => array(
            'order' => 'Drug.generic_name ASC'
        )
    );

    /**
     *
     * @param int $searchId
     */
    public function search($searchId = 0)
    {
        $hookLink = $this->hook('pre_search_handler');
        if ($hookLink) {
            require ($hookLink);
        }
        
        $this->searchHandler($searchId, $this->Drug, 'drugs', '/Drug/Drugs/search');
        
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

    public function add()
    {
        $this->set('atimMenu', $this->Menus->get('/Drug/Drugs/search/'));
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($this->request->data)) {
            $this->request->data = array(
                array()
            );
            
            $hookLink = $this->hook('initial_display');
            if ($hookLink) {
                require ($hookLink);
            }
        } else {
            
            $errorsTracking = array();
            
            // Validation
            
            $rowCounter = 0;
            foreach ($this->request->data as &$dataUnit) {
                $rowCounter ++;
                $this->Drug->id = null;
                $this->Drug->set($dataUnit);
                if (! $this->Drug->validates()) {
                    foreach ($this->Drug->validationErrors as $field => $msgs) {
                        $msgs = is_array($msgs) ? $msgs : array(
                            $msgs
                        );
                        foreach ($msgs as $msg)
                            $errorsTracking[$field][$msg][] = $rowCounter;
                    }
                }
                $dataUnit = $this->Drug->data;
            }
            unset($dataUnit);
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            // Launch Save Process
            
            if (empty($this->request->data)) {
                $this->Drug->validationErrors[][] = 'at least one record has to be created';
            } elseif (empty($errorsTracking)) {
                AppModel::acquireBatchViewsUpdateLock();
                // save all
                foreach ($this->request->data as $newDataToSave) {
                    $this->Drug->id = null;
                    $this->Drug->data = array();
                    if (! $this->Drug->save($newDataToSave, false))
                        $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
                $hookLink = $this->hook('postsave_process_batch');
                if ($hookLink) {
                    require ($hookLink);
                }
                AppModel::releaseBatchViewsUpdateLock();
                $this->atimFlash(__('your data has been updated'), '/Drug/Drugs/search/');
            } else {
                $this->Drug->validationErrors = array();
                foreach ($errorsTracking as $field => $msgAndLines) {
                    foreach ($msgAndLines as $msg => $lines) {
                        $this->Drug->validationErrors[$field][] = $msg . ' - ' . str_replace('%s', implode(",", $lines), __('see line %s'));
                    }
                }
            }
        }
    }

    /**
     *
     * @param $drugId
     */
    public function edit($drugId)
    {
        $drugData = $this->Drug->getOrRedirect($drugId);
        
        $this->set('atimMenuVariables', array(
            'Drug.id' => $drugId
        ));
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($this->request->data)) {
            $this->request->data = $drugData;
        } else {
            $submittedDataValidates = true;
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates) {
                $this->Drug->id = $drugId;
                if ($this->Drug->save($this->request->data)) {
                    $hookLink = $this->hook('postsave_process');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    $this->atimFlash(__('your data has been updated'), '/Drug/Drugs/detail/' . $drugId);
                }
            }
        }
    }

    /**
     *
     * @param $drugId
     */
    public function detail($drugId)
    {
        $this->request->data = $this->Drug->getOrRedirect($drugId);
        
        $this->set('atimMenuVariables', array(
            'Drug.id' => $drugId
        ));
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     *
     * @param $drugId
     */
    public function delete($drugId)
    {
        $drugData = $this->Drug->getOrRedirect($drugId);
        $arrAllowDeletion = $this->Drug->allowDeletion($drugId);
        
        // CUSTOM CODE
        
        $hookLink = $this->hook('delete');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if ($arrAllowDeletion['allow_deletion']) {
            $this->Drug->data = null;
            if ($this->Drug->atimDelete($drugId)) {
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                $this->atimFlash(__('your data has been deleted'), '/Drug/Drugs/search/');
            } else {
                $this->atimFlashError(__('error deleting data - contact administrator'), '/Drug/Drugs/search/');
            }
        } else {
            $this->atimFlashWarning(__($arrAllowDeletion['msg']), '/Drug/Drugs/detail/' . $drugId);
        }
    }

    public function autocompleteDrug()
    {
        
        // -- NOTE ----------------------------------------------------------
        //
        // This function is linked to functions of the Drug model
        // called getDrugIdFromDrugDataAndCode() and
        // getDrugDataAndCodeForDisplay().
        //
        // When you override the autocompleteDrug() function, check
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
                "Drug.generic_name LIKE" => '%' . $keyWord . '%'
            );
        }
        
        $conditions = array(
            'AND' => $terms
        );
        $fields = 'Drug.*';
        $order = 'Drug.generic_name ASC';
        $joins = array();
        
        $hookLink = $this->hook('query_args');
        if ($hookLink) {
            require ($hookLink);
        }
        
        $data = $this->Drug->find('all', array(
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
            ), $this->Drug->getDrugDataAndCodeForDisplay($dataUnit)) . '", ';
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