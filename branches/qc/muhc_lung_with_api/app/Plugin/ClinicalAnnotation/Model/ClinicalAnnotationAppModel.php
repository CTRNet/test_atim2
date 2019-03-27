<?php

/**
 * Class ClinicalAnnotationAppModel
 */
class ClinicalAnnotationAppModel extends AppModel
{

    /**
     *
     * @param $id
     * @return mixed
     */
    public function validateIcd10WhoCode($id)
    {
        $icd10Model = AppModel::getInstance('CodingIcd', 'CodingIcd10Who', true);
        return $icd10Model::validateId($id);
    }

    /**
     *
     * @return mixed
     */
    public function getSecondaryIcd10WhoCodesList()
    {
        $icd10Model = AppModel::getInstance('CodingIcd', 'CodingIcd10Who', true);
        return $icd10Model::getSecondaryDiagnosisList();
    }

    /**
     *
     * @param $id
     * @return mixed
     */
    public function validateIcd10CaCode($id)
    {
        $icd10Model = AppModel::getInstance('CodingIcd', 'CodingIcd10Ca', true);
        return $icd10Model::validateId($id);
    }

    /**
     *
     * @param $id
     * @return mixed
     */
    public function validateIcdo3TopoCode($id)
    {
        $icdO3TopoModel = AppModel::getInstance('CodingIcd', 'CodingIcdo3Topo', true);
        return $icdO3TopoModel::validateId($id);
    }

    /**
     *
     * @return mixed
     */
    public function getIcdO3TopoCategoriesCodes()
    {
        $icdO3TopoModel = AppModel::getInstance('CodingIcd', 'CodingIcdo3Topo', true);
        return $icdO3TopoModel::getTopoCategoriesCodes();
    }

    /**
     *
     * @param $id
     * @return mixed
     */
    public function validateIcdo3MorphoCode($id)
    {
        $icdO3MorphoModel = AppModel::getInstance('CodingIcd', 'CodingIcdo3Morpho', true);
        return $icdO3MorphoModel::validateId($id);
    }

    /**
     *
     * @param bool $created
     * @param array $options
     */
    public function afterSave($created, $options = array())
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
                $participantModel->data = array();
                $participantModel->id = $participantId;
                $participantModel->addWritableField(array(
                    'last_modification',
                    'last_modification_ds_id'
                ));
                $participantModel->save(array(
                    'last_modification' => $this->data[$this->name]['modified'],
                    'last_modification_ds_id' => $datamartStructure['DatamartStructure']['id']
                ));
            }
        }
        parent::afterSave($created);
    }
    
    public function getCCLsList()
    {
        $datamartStructureModel = AppModel::getInstance('Datamart', 'DatamartStructure', true);
        $query = "SELECT id1, id2, ceil((flag_active_1_to_2 + flag_active_2_to_1)/2) active , ds2.`model` model, ds2.`plugin` plugin " .
                "FROM `datamart_browsing_controls` dbc " .
                "JOIN `datamart_structures` ds ON ds.id = dbc.id1 " .
                "JOIN `datamart_structures` ds2 ON ds2.id = dbc.id2 " .
                "where ds.model = 'ViewCollection' and ds.plugin = 'InventoryManagement' " .
                "union " .
                "SELECT id1, id2, ceil((flag_active_1_to_2 + flag_active_2_to_1)/2) active, ds.`model` model, ds.`plugin` plugin " .
                "FROM `datamart_browsing_controls` dbc " .
                "JOIN `datamart_structures` ds2 ON ds2.id = dbc.id2 " .
                "JOIN `datamart_structures` ds ON ds.id = dbc.id1 " .
                "where ds2.model = 'ViewCollection' and ds2.plugin = 'InventoryManagement' ";
        $result = $datamartStructureModel->query($query);
        foreach ($result as $k=>$v){
            $result[$v[0]['model']] = $v[0];
            unset ($result[$k]);
        }
        return $result;
    }
    
    public function deleteFromStructuresDeactiveCCLs($cclDatamartData)
    {
        $datamartStructureModel = AppModel::getInstance('Datamart', 'DatamartStructure', true);
        $result = array();
        foreach ($cclDatamartData as $item) {
            if (in_array($item['model'], array('ConsentMaster', 'DiagnosisMaster', 'TreatmentMaster', 'EventMaster')) !== false && $item['plugin'] == 'ClinicalAnnotation' && $item['active'] == '0') {
                $controlModel = str_replace("Master", "Control", $item['model']);
                $query = "UPDATE `structure_formats` sf1 " .
                        "SET " .
                        "sf1.flag_add ='0', sf1.flag_add_readonly ='0', sf1. flag_edit ='0', sf1. flag_edit_readonly ='0', sf1. flag_search ='0', sf1. flag_search_readonly ='0',  " .
                        "sf1. flag_addgrid ='0', sf1. flag_addgrid_readonly ='0', sf1. flag_editgrid ='0', sf1. flag_editgrid_readonly ='0', sf1. flag_summary ='0',  " .
                        "sf1. flag_batchedit ='0', sf1. flag_batchedit_readonly ='0', sf1. flag_index ='0', sf1. flag_detail ='0', sf1. flag_float = '0' " .
                        "where sf1.id in ( " .
                        "select id from ( " .
                        "SELECT sf.id " .
                        "from `structure_fields`  " .
                        "JOIN `structure_formats` sf " .
                        "ON sf.structure_field_id = `structure_fields`.id " .
                        "where  " .
                        "sf.structure_id  = (select id from `structures` where alias = 'clinicalcollectionlinks') and " .
                        "`structure_fields`.model = '" . $item['model'] . "' and `structure_fields`.plugin= '" . $item['plugin'] . "'  " .
                        "OR " .
                        "`structure_fields`.model = '" . $controlModel . "' and `structure_fields`.plugin= '" . $item['plugin'] . "'  " .
                        ") TEMPJOIN) ; ";

                $result [] = $datamartStructureModel->query($query);
            }
        }
        return $result;
    }
}