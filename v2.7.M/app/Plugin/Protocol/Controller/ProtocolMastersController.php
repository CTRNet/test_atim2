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
 * Class ProtocolMastersController
 */
class ProtocolMastersController extends ProtocolAppController
{

    public $uses = array(
        'Protocol.ProtocolControl',
        'Protocol.ProtocolMaster'
    );

    public $paginate = array(
        'ProtocolMaster' => array(
            'order' => 'ProtocolMaster.code DESC'
        )
    );

    /**
     *
     * @param int $searchId
     */
    public function search($searchId = 0)
    {
        $this->set('atimMenu', $this->Menus->get("/Protocol/ProtocolMasters/search/"));
        
        $hookLink = $this->hook('pre_search_handler');
        if ($hookLink) {
            require ($hookLink);
        }
        
        $this->searchHandler($searchId, $this->ProtocolMaster, 'protocolmasters', '/Protocol/ProtocolMasters/search');
        $this->set('protocolControls', $this->ProtocolControl->find('all', array(
            'conditions' => array(
                'flag_active' => '1'
            )
        )));
        
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
     * @param $protocolControlId
     */
    public function add($protocolControlId)
    {
        $protocolControlData = $this->ProtocolControl->find('first', array(
            'conditions' => array(
                'ProtocolControl.id' => $protocolControlId
            )
        ));
        if (empty($protocolControlData)) {
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $this->set('atimMenuVariables', array(
            'ProtocolControl.id' => $protocolControlId
        ));
        $this->set('atimMenu', $this->Menus->get("/Protocol/ProtocolMasters/search/"));
        $this->Structures->set($protocolControlData['ProtocolControl']['form_alias']);
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($this->request->data)) {
            $this->request->data = array();
            $this->request->data['ProtocolControl']['tumour_group'] = $protocolControlData['ProtocolControl']['tumour_group'];
            $this->request->data['ProtocolControl']['type'] = $protocolControlData['ProtocolControl']['type'];
        } else {
            
            $this->request->data['ProtocolMaster']['protocol_control_id'] = $protocolControlId;
            
            $submittedDataValidates = true;
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            $this->ProtocolMaster->addWritableField(array(
                'protocol_control_id'
            ));
            if ($submittedDataValidates && $this->ProtocolMaster->save($this->request->data)) {
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                $this->atimFlash(__('your data has been updated'), '/Protocol/ProtocolMasters/detail/' . $this->ProtocolMaster->getLastInsertId());
            }
        }
    }

    /**
     *
     * @param $protocolMasterId
     */
    public function detail($protocolMasterId)
    {
        $protocolData = $this->ProtocolMaster->getOrRedirect($protocolMasterId);
        $this->request->data = $protocolData;
        
        $this->set('atimMenuVariables', array(
            'ProtocolMaster.id' => $protocolMasterId
        ));
        $this->Structures->set($protocolData['ProtocolControl']['form_alias']);
        
        $this->set('displayPrecisions', (empty($protocolData['ProtocolControl']['protocol_extend_control_id']) ? false : true));
        
        $isUsed = $this->ProtocolMaster->isLinkedToTreatment($protocolMasterId);
        if ($isUsed['is_used']) {
            AppController::addWarningMsg(__('warning') . ": " . __($isUsed['msg']));
        }
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     *
     * @param $protocolMasterId
     */
    public function edit($protocolMasterId)
    {
        $protocolData = $this->ProtocolMaster->getOrRedirect($protocolMasterId);
        
        $this->set('atimMenuVariables', array(
            'ProtocolMaster.id' => $protocolMasterId
        ));
        $this->Structures->set($protocolData['ProtocolControl']['form_alias']);
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($this->request->data)) {
            $this->request->data = $protocolData;
            $isUsed = $this->ProtocolMaster->isLinkedToTreatment($protocolMasterId);
            if ($isUsed['is_used']) {
                AppController::addWarningMsg(__('warning') . ": " . __($isUsed['msg']));
            }
            $submittedDataValidates = false;
        } else {
            $submittedDataValidates = true;
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            $this->ProtocolMaster->id = $protocolMasterId;
            if ($submittedDataValidates && $this->ProtocolMaster->save($this->request->data)) {
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                $this->atimFlash(__('your data has been updated'), '/Protocol/ProtocolMasters/detail/' . $protocolMasterId . '/');
            }
        }
    }

    /**
     *
     * @param $protocolMasterId
     */
    public function delete($protocolMasterId)
    {
        $protocolData = $this->ProtocolMaster->getOrRedirect($protocolMasterId);
        
        $arrAllowDeletion = $this->ProtocolMaster->allowDeletion($protocolMasterId);
        
        // CUSTOM CODE
        $hookLink = $this->hook('delete');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if ($arrAllowDeletion['allow_deletion']) {
            if ($this->ProtocolMaster->atimDelete($protocolMasterId)) {
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                $this->atimFlash(__('your data has been deleted'), '/Protocol/ProtocolMasters/search/');
            } else {
                $this->atimFlashError(__('error deleting data - contact administrator'), '/Protocol/ProtocolMasters/detail/' . $protocolMasterId);
            }
        } else {
            $this->atimFlashWarning(__($arrAllowDeletion['msg']), '/Protocol/ProtocolMasters/detail/' . $protocolMasterId);
        }
    }
}