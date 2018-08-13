<?php

/**
 * Class ReusableMiscIdentifiersController
 */
class ReusableMiscIdentifiersController extends AdministrateAppController
{

    public $uses = array(
        'ClinicalAnnotation.MiscIdentifier',
        'ClinicalAnnotation.MiscIdentifierControl'
    );

    public function index()
    {
        $joins = array(
            array(
                'table' => 'misc_identifiers',
                'alias' => 'MiscIdentifier',
                'type' => 'LEFT',
                'conditions' => array(
                    'MiscIdentifierControl.id = MiscIdentifier.misc_identifier_control_id',
                    'MiscIdentifier.participant_id' => null,
                    'MiscIdentifier.deleted' => 1,
                    'MiscIdentifier.tmp_deleted' => 1
                )
            )
        );
        
        $data = $this->MiscIdentifierControl->find('all', array(
            'fields' => array(
                'MiscIdentifierControl.id',
                'MiscIdentifierControl.misc_identifier_name',
                'COUNT(MiscIdentifier.id) AS count'
            ),
            'joins' => $joins,
            'conditions' => array(
                'NOT' => array(
                    'MiscIdentifierControl.autoincrement_name' => ''
                )
            ),
            'group' => array(
                'MiscIdentifierControl.id, MiscIdentifierControl.misc_identifier_name'
            )
        ));
        
        foreach ($data as $unit) {
            $this->request->data[] = array(
                'MiscIdentifierControl' => $unit['MiscIdentifierControl'],
                '0' => array(
                    'count' => $unit[0]['count']
                )
            );
        }
        
        $this->Structures->set('misc_identifier_manage');
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     *
     * @param $miCtrlId
     */
    public function manage($miCtrlId)
    {
        $this->MiscIdentifierControl->getOrRedirect($miCtrlId);
        $miControl = $this->MiscIdentifierControl->findById($miCtrlId);
        if ($miControl['MiscIdentifierControl']['flag_confidential'] && ! $this->Session->read('flag_show_confidential')) {
            AppController::getInstance()->redirect("/Pages/err_confidential");
        }
        
        $this->set('title', $miControl['MiscIdentifierControl']['misc_identifier_name']);
        $this->Structures->set('misc_identifier_value');
        $this->set('atimMenuVariables', array(
            'MiscIdentifierControl.id' => $miCtrlId
        ));
        
        $reusableIdentifiers = $this->MiscIdentifier->find('all', array(
            'conditions' => array(
                'MiscIdentifier.participant_id' => null,
                'MiscIdentifier.misc_identifier_control_id' => $miCtrlId,
                'MiscIdentifier.deleted' => 1,
                'MiscIdentifier.tmp_deleted' => 1
            ),
            'recursive' => - 1
        ));
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (! empty($this->request->data)) {
            
            $submittedDataValidates = true;
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates) {
                $mis = $this->MiscIdentifier->find('all', array(
                    'conditions' => array(
                        'MiscIdentifier.id' => $this->request->data['MiscIdentifier']['selected_id'],
                        'MiscIdentifier.misc_identifier_control_id' => $miCtrlId,
                        'MiscIdentifier.tmp_deleted' => 1,
                        'MiscIdentifier.deleted' => 1
                    ),
                    'recursive' => - 1
                ));
                if (empty($mis)) {
                    AppController::addWarningMsg(__('you need to select at least one item'));
                } else {
                    // $this->MiscIdentifier->query('LOCK TABLE misc_identifiers AS MiscIdentifier WRITE, participants AS Participant WRITE, misc_identifier_controls AS MiscIdentifierControl WRITE, misc_identifiers WRITE, misc_identifiers_revs WRITE');
                    $this->MiscIdentifier->checkWritableFields = false;
                    foreach ($mis as $newIdentifier) {
                        $this->MiscIdentifier->data = $newIdentifier;
                        $this->MiscIdentifier->id = $newIdentifier['MiscIdentifier']['id'];
                        $this->MiscIdentifier->save(array(
                            'tmp_deleted' => 0
                        ));
                    }
                    $hookLink = $this->hook('postsave_process');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    // $this->MiscIdentifier->query('UNLOCK TABLES');
                    $this->atimFlash(__('your data has been saved'), '/Administrate/ReusableMiscIdentifiers/manage/' . $miCtrlId);
                }
            }
        }
        
        $this->request->data = $reusableIdentifiers;
        
        if (empty($this->request->data)) {
            AppController::addWarningMsg(__('there are no unused identifiers of the current type'));
        }
    }
}