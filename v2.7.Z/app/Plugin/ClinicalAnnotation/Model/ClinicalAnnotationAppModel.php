<?php

class ClinicalAnnotationAppModel extends AppModel
{

    function validateIcd10WhoCode($id)
    {
        $icd10Model = AppModel::getInstance('CodingIcd', 'CodingIcd10Who', true);
        return $icd10Model::validateId($id);
    }

    function getSecondaryIcd10WhoCodesList()
    {
        $icd10Model = AppModel::getInstance('CodingIcd', 'CodingIcd10Who', true);
        return $icd10Model::getSecondaryDiagnosisList();
    }

    function validateIcd10CaCode($id)
    {
        $icd10Model = AppModel::getInstance('CodingIcd', 'CodingIcd10Ca', true);
        return $icd10Model::validateId($id);
    }

    function validateIcdo3TopoCode($id)
    {
        $icdO3TopoModel = AppModel::getInstance('CodingIcd', 'CodingIcdo3Topo', true);
        return $icdO3TopoModel::validateId($id);
    }

    function getIcdO3TopoCategoriesCodes()
    {
        $icdO3TopoModel = AppModel::getInstance('CodingIcd', 'CodingIcdo3Topo', true);
        return $icdO3TopoModel::getTopoCategoriesCodes();
    }

    function validateIcdo3MorphoCode($id)
    {
        $icdO3MorphoModel = AppModel::getInstance('CodingIcd', 'CodingIcdo3Morpho', true);
        return $icdO3MorphoModel::validateId($id);
    }

    function afterSave($created, $options = Array())
    {
        if ($this->name != 'Participant') {
            // manages Participant.last_modification and Participant.last_modification_ds_id
            if (isset($this->data[$this->name]['deleted']) && $this->data[$this->name]['deleted']) {
                // retrieve participant after a delete operation
                assert($this->id);
                $this->data = $this->find('first', array(
                    'conditions' => array(
                        $this->name . '.' . $this->primaryKey => $this->id,
                        $this->name . '.deleted' => 1
                    )
                ));
            }
            
            $participantId = null;
            $name = $this->name;
            if (isset($this->data[$this->name]['participant_id'])) {
                $participantId = $this->data[$this->name]['participant_id'];
            } elseif ($this->name == 'TreatmentExtendMaster') {
                $treatmentMaster = AppModel::getInstance('ClinicalAnnotation', 'TreatmentMaster', true);
                $txData = $treatmentMaster->find('first', array(
                    'conditions' => array(
                        'TreatmentMaster.id' => $this->data['TreatmentExtendMaster']['treatment_master_id']
                    ),
                    'fields' => array(
                        'TreatmentMaster.participant_id'
                    )
                ));
                $participantId = $txData['TreatmentMaster']['participant_id'];
                $name = 'TreatmentMaster';
            } else {
                $prevData = $this->data;
                $currData = $this->findById($this->id);
                $this->data = $prevData;
                $participantId = null;
                if (isset($currData[$this->name]) && isset($currData[$this->name]['participant_id']))
                    $participantId = $currData[$this->name]['participant_id'];
            }
            $datamartStructureModel = AppModel::getInstance('Datamart', 'DatamartStructure', true);
            $datamartStructure = $datamartStructureModel->find('first', array(
                'conditions' => array(
                    'DatamartStructure.model' => $name
                )
            ));
            if (! $datamartStructure) {
                AppController::getInstance()->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
            if ($participantId) {
                $participantModel = AppModel::getInstance('ClinicalAnnotation', 'Participant', true);
                $participantModel->checkWritableFields = false;
                $participantModel->data = array();
                $participantModel->id = $participantId;
                $participantModel->save(array(
                    'last_modification' => $this->data[$this->name]['modified'],
                    'last_modification_ds_id' => $datamartStructure['DatamartStructure']['id']
                ));
                $participantModel->checkWritableFields = true;
            }
        }
        parent::afterSave($created);
    }
}