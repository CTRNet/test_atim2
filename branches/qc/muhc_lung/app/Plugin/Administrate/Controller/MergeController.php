<?php

/**
 * Class MergeController
 */
class MergeController extends AdministrateAppController
{

    public function index()
    {
        $this->Structures->set('merge_index');
        AppController::addWarningMsg(__('merge operations are not reversible'));
    }

    public function mergeCollections()
    {
        $this->set('atimMenu', $this->Menus->get('/Administrate/Merge/index/'));
        
        if ($this->request->data && $this->request->data['from'] && $this->request->data['to']) {
            if ($this->request->data['from'] == $this->request->data['to']) {
                $this->set('validationError', __('you cannot merge an item within itself'));
            } else {
                // merge!!
                $regexp = '#([\d]+)(/)?$#';
                $from = array();
                $to = array();
                assert(preg_match($regexp, $this->request->data['from'], $from));
                assert(preg_match($regexp, $this->request->data['to'], $to));
                $from = $from[1];
                $to = $to[1];
                
                $toUpdate = array(
                    AppModel::getInstance('InventoryManagement', 'AliquotMaster'),
                    AppModel::getInstance('InventoryManagement', 'SampleMaster'),
                    AppModel::getInstance('InventoryManagement', 'SpecimenReviewMaster')
                );
                
                // update 1 by 1 to trigger right behavior + view updates properly
                foreach ($toUpdate as $model) {
                    $ids = $model->find('list', array(
                        'conditions' => array(
                            $model->name . '.collection_id' => $from
                        )
                    ));
                    $update = array(
                        $model->name => array(
                            'collection_id' => $to
                        )
                    );
                    $model->checkWritableFields = false;
                    foreach ($ids as $id) {
                        $model->id = $id;
                        $model->save($update, false);
                    }
                }
                
                $collectionModel = AppModel::getInstance('InventoryManagement', 'Collection');
                $collectionModel->atimDelete($from);
                $this->atimFlash(__('merge complete'), '/Administrate/Merge/index/');
            }
        }
    }

    public function mergeParticipants()
    {
        $this->set('atimMenu', $this->Menus->get('/Administrate/Merge/index/'));
        
        if ($this->request->data && $this->request->data['from'] && $this->request->data['to']) {
            if ($this->request->data['from'] == $this->request->data['to']) {
                $this->set('validationError', __('you cannot merge an item within itself'));
            } else {
                // merge!!
                $regexp = '#([\d]+)(/)?$#';
                $from = array();
                $to = array();
                assert(preg_match($regexp, $this->request->data['from'], $from));
                assert(preg_match($regexp, $this->request->data['to'], $to));
                $from = $from[1];
                $to = $to[1];
                
                // identifiers
                $identifiersModel = AppModel::getInstance('ClinicalAnnotation', 'MiscIdentifier');
                $identifiers = $identifiersModel->find('all', array(
                    'conditions' => array(
                        'MiscIdentifier.participant_id' => $from
                    )
                ));
                $identifiersModel->checkWritableFields = false;
                $update = array(
                    'MiscIdentifier' => array(
                        'participant_id' => $to
                    )
                );
                $conflicts = 0;
                foreach ($identifiers as $identifier) {
                    $proceed = false;
                    if ($identifier['MiscIdentifierControl']['flag_once_per_participant']) {
                        if (! $identifiersModel->find('first', array(
                            'conditions' => array(
                                'MiscIdentifier.misc_identifier_control_id' => $identifier['MiscIdentifierControl']['id'],
                                'MiscIdentifier.participant_id' => $to
                            )
                        ))) {
                            $proceed = true;
                        }
                    } else {
                        $proceed = true;
                    }
                    
                    if ($proceed) {
                        $identifiersModel->id = $identifier['MiscIdentifier']['id'];
                        $identifiersModel->save($update);
                    } else {
                        ++ $conflicts;
                    }
                }
                
                if ($conflicts) {
                    AppController::addWarningMsg(__('some identifiers were not merge because they were conflicting') . ' (' . $conflicts . ')');
                }
                
                $toUpdate = array(
                    AppModel::getInstance('InventoryManagement', 'Collection'),
                    AppModel::getInstance('ClinicalAnnotation', 'ConsentMaster'),
                    AppModel::getInstance('ClinicalAnnotation', 'DiagnosisMaster'),
                    AppModel::getInstance('ClinicalAnnotation', 'EventMaster'),
                    AppModel::getInstance('ClinicalAnnotation', 'FamilyHistory'),
                    AppModel::getInstance('ClinicalAnnotation', 'ParticipantContact'),
                    AppModel::getInstance('ClinicalAnnotation', 'ParticipantMessage'),
                    AppModel::getInstance('ClinicalAnnotation', 'ReproductiveHistory'),
                    AppModel::getInstance('ClinicalAnnotation', 'TreatmentMaster')
                );
                
                // update 1 by 1 to trigger right behavior + view updates properly
                foreach ($toUpdate as $model) {
                    // forcing fields value or ParticipantMessage doesnt work
                    $ids = $model->find('list', array(
                        'fields' => array(
                            $model->name . '.' . $model->primaryKey
                        ),
                        'conditions' => array(
                            $model->name . '.participant_id' => $from
                        )
                    ));
                    $update = array(
                        $model->name => array(
                            'participant_id' => $to
                        )
                    );
                    $model->checkWritableFields = false;
                    foreach ($ids as $id) {
                        $model->id = $id;
                        $model->save($update, false);
                    }
                }
                
                $this->atimFlash(__('merge complete') . '. ' . __('delete unmerged identifiers and profile of the merged participant') . '.', '/ClinicalAnnotation/Participants/profile/' . $from);
            }
        }
    }
}