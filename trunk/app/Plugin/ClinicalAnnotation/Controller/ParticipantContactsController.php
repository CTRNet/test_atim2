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
 * Class ParticipantContactsController
 */
class ParticipantContactsController extends ClinicalAnnotationAppController
{

    public $uses = array(
        'ClinicalAnnotation.ParticipantContact',
        'ClinicalAnnotation.Participant'
    );

    public $paginate = array(
        'ParticipantContact' => array(
            'order' => 'ParticipantContact.contact_type ASC'
        )
    );

    /**
     *
     * @param $participantId
     */
    public function listall($participantId)
    {
        // MANAGE DATA
        $participantData = $this->Participant->getOrRedirect($participantId);
        
        $this->request->data = $this->paginate($this->ParticipantContact, array(
            'ParticipantContact.participant_id' => $participantId
        ));
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atimMenuVariables', array(
            'Participant.id' => $participantId
        ));
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     *
     * @param $participantId
     * @param $participantContactId
     */
    public function detail($participantId, $participantContactId)
    {
        if (! $participantId && ! $participantContactId) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE DATA
        $participantContactData = $this->ParticipantContact->find('first', array(
            'conditions' => array(
                'ParticipantContact.id' => $participantContactId,
                'ParticipantContact.participant_id' => $participantId
            ),
            'recursive' => - 1
        ));
        if (empty($participantContactData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        if ($participantContactData['ParticipantContact']['confidential'] && ! $this->Session->read('flag_show_confidential')) {
            // Should not happens but in case
            $this->redirect("/Pages/err_confidential");
        }
        $this->request->data = $participantContactData;
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atimMenuVariables', array(
            'Participant.id' => $participantId,
            'ParticipantContact.id' => $participantContactId
        ));
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     *
     * @param $participantId
     */
    public function add($participantId)
    {
        if (! $participantId) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE DATA
        $participantData = $this->Participant->getOrRedirect($participantId);
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atimMenuVariables', array(
            'Participant.id' => $participantId
        ));
        if ($this->Session->read('flag_show_confidential')) {
            $this->Structures->set('participantcontacts,participantcontacts_confidential');
        }
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (! empty($this->request->data)) {
            $this->ParticipantContact->addWritableField('participant_id');
            $this->request->data['ParticipantContact']['participant_id'] = $participantId;
            
            $submittedDataValidates = true;
            // ... special validations
            
            // CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates) {
                if ($this->ParticipantContact->save($this->request->data)) {
                    $hookLink = $this->hook('postsave_process');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    $this->atimFlash(__('your data has been updated'), '/ClinicalAnnotation/ParticipantContacts/detail/' . $participantId . '/' . $this->ParticipantContact->id);
                }
            }
        }
    }

    /**
     *
     * @param $participantId
     * @param $participantContactId
     */
    public function edit($participantId, $participantContactId)
    {
        if (! $participantId && ! $participantContactId) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE DATA
        $participantContactData = $this->ParticipantContact->find('first', array(
            'conditions' => array(
                'ParticipantContact.id' => $participantContactId,
                'ParticipantContact.participant_id' => $participantId
            ),
            'recursive' => - 1
        ));
        if (empty($participantContactData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        if ($participantContactData['ParticipantContact']['confidential'] && ! $this->Session->read('flag_show_confidential')) {
            // Should not happens but in case
            $this->redirect("/Pages/err_confidential");
        } elseif ($this->Session->read('flag_show_confidential')) {
            $this->Structures->set('participantcontacts,participantcontacts_confidential');
        }
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atimMenuVariables', array(
            'Participant.id' => $participantId,
            'ParticipantContact.id' => $participantContactId
        ));
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($this->request->data)) {
            $this->request->data = $participantContactData;
        } else {
            $submittedDataValidates = true;
            // ... special validations
            
            // CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates) {
                $this->ParticipantContact->id = $participantContactId;
                if ($this->ParticipantContact->save($this->request->data)) {
                    $hookLink = $this->hook('postsave_process');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    $this->atimFlash(__('your data has been updated'), '/ClinicalAnnotation/ParticipantContacts/detail/' . $participantId . '/' . $participantContactId);
                }
            }
        }
    }

    /**
     *
     * @param $participantId
     * @param $participantContactId
     */
    public function delete($participantId, $participantContactId)
    {
        if (! $participantId && ! $participantContactId) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE DATA
        $participantContactData = $this->ParticipantContact->find('first', array(
            'conditions' => array(
                'ParticipantContact.id' => $participantContactId,
                'ParticipantContact.participant_id' => $participantId
            ),
            'recursive' => - 1
        ));
        if (empty($participantContactData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        if ($participantContactData['ParticipantContact']['confidential'] && ! $this->Session->read('flag_show_confidential')) {
            AppController::getInstance()->redirect("/Pages/err_confidential");
        }
        
        $arrAllowDeletion = $this->ParticipantContact->allowDeletion($participantContactId);
        
        if ($arrAllowDeletion['allow_deletion']) {
            if ($this->ParticipantContact->atimDelete($participantContactId)) {
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                $this->atimFlash(__('your data has been deleted'), '/ClinicalAnnotation/ParticipantContacts/listall/' . $participantId);
            } else {
                $this->atimFlashError(__('error deleting data - contact administrator'), '/ClinicalAnnotation/ParticipantContacts/listall/' . $participantId);
            }
        } else {
            $this->atimFlashWarning(__($arrAllowDeletion['msg']), '/ClinicalAnnotation/ParticipantContacts/detail/' . $participantId . '/' . $participantContactId);
        }
    }
}