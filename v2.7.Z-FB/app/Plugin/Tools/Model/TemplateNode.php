<?php

/**
 * Class TemplateNode
 */
class TemplateNode extends ToolsAppModel
{

    public $useTable = 'template_nodes';

    private $nodesStructures = array();

    /**
     * Manage the structures that will be used to create the inventory data (collection, sample, aliquot) defined by the node
     * to limit list of fields to the fields that could be used to set the default values for the futur inventory data creation.
     *
     * @param integer $nodeDatamartStructureId Datamart structure id recorded for the template node.
     * @param integer $nodeControlId Control ID of the inventory data (collection, sample, aliquot) that will be created from node.
     *       
     * @return array Formatted structures (including fields)
     */
    public function getStructuresForNodeDefaultValuesEntry($nodeDatamartStructureId, $nodeControlId)
    {
        // Get all structures that will be used to create the collection element/record defined into the node
        $allStructures = $this->getNodeStructrues($nodeDatamartStructureId, $nodeControlId);
        // Format structure for default values data entry
        foreach ($allStructures['Sfs'] as $k => &$newLinkedStructuresField) {
            // Remove validation
            $newLinkedStructuresField['StructureValidation'] = array();
            // Remove default value
            $newLinkedStructuresField['default'] = '';
            if (! (($newLinkedStructuresField['flag_add'] && ! $newLinkedStructuresField['flag_add_readonly']) || ($newLinkedStructuresField['flag_addgrid'] && ! $newLinkedStructuresField['flag_addgrid_readonly']))) {
                unset($allStructures['Sfs'][$k]);
            }
        }
        return $allStructures;
    }

    /**
     * Generate a string gathering all default values defined for the nodes of a template in a user readable format.
     *
     *
     * @param type $nodeDatamartStructureId
     * @param String $nodeControlId
     *
     *
     * @return String Data gathering formated default values for each node of the template with default values
     */
    public function formatTemplateNodeDefaultValuesForDisplayByControlAndDatamartStructureIdId($nodeDatamartStructureId, $nodeControlId, $defaultValue)
    {
        $nodeLinkedStructures = $this->getNodeStructrues($nodeDatamartStructureId, $nodeControlId);
        $temp = $this->formatDefaultValuesForDisplay($nodeLinkedStructures, $defaultValue);
        return $temp;
    }

    /**
     * Generate an array gathering all default values defined for the nodes of a template in JSON format.
     *
     * @param integer $nodeId The node id of the root
     *       
     * @return array default values in JSON format related to nodeId as the parent node
     */
    public function getDefaultValues($nodeId)
    {
        $templateNodeModel = AppModel::getInstance("Tools", "TemplateNode", true);
        $defaultValuesJSON = array();
        $templateNodes = $templateNodeModel->find('all', array(
            'fields' => array(
                'TemplateNode.id',
                'TemplateNode.default_values'
            ),
            'conditions' => array(
                'TemplateNode.Template_id' => $nodeId,
                'TemplateNode.default_values IS NOT NULL',
                "TemplateNode.default_values != ''"
            )
        ));
        foreach ($templateNodes as $newNode) {
            $defaultValuesJSON[$newNode['TemplateNode']['id']] = $newNode['TemplateNode']['default_values'];
        }
        
        return $defaultValuesJSON;
    }

    /**
     * Generate an array gathering all default values defined for the nodes of a template in a user readable format.
     *
     * @param integer $templateId Id of the collection template
     *       
     * @return array Data gathering formated default values for each node of the template with default values [array('node_id' => string)]
     */
    public function formatTemplateNodeDefaultValuesForDisplay($templateId)
    {
        // Get all template nodes
        $templateNodeModel = AppModel::getInstance("Tools", "TemplateNode", true);
        $templateNodes = $templateNodeModel->find('all', array(
            'conditions' => array(
                'TemplateNode.Template_id' => $templateId,
                'TemplateNode.default_values IS NOT NULL',
                "TemplateNode.default_values != ''"
            )
        ));
        $allFormattedDefaultValues = array();
        foreach ($templateNodes as $newNode) {
            // New template node
            $newNode = $newNode['TemplateNode'];
            $nodeId = $newNode['id'];
            $nodeDefaultValues = json_decode($newNode['default_values'], true);
            // Get all structures that will be used to create the node element (sample or aliquot) for the collection
            $nodeDatamartStructureId = $newNode['datamart_structure_id'];
            $nodeControlId = $newNode['control_id'];
            $nodeLinkedStructures = $this->getNodeStructrues($nodeDatamartStructureId, $nodeControlId);
            // Format node default value
            $allFormattedDefaultValues[$nodeId] = $this->formatDefaultValuesForDisplay($nodeLinkedStructures, $nodeDefaultValues);
        }
        return $allFormattedDefaultValues;
    }

    /**
     * Get structures and fields that will be used to create the futur inventory data (collection, sample, aliquot) defined by the node
     *
     * @param integer $nodeDatamartStructureId Datamart structure id recorded for the template node.
     * @param integer $nodeControlId Control ID of the inventory data (collection, sample, aliquot) that will be created from node.
     *       
     * @return array Structures (including fields) that will be used to create the futur inventory data
     */
    public function getNodeStructrues($nodeDatamartStructureId, $nodeControlId)
    {
        $key = $nodeDatamartStructureId . '/' . $nodeControlId;
        if (! isset($this->nodesStructures[$key])) {
            $datamartStructureModel = AppModel::getInstance('Datamart', 'DatamartStructure');
            $browserModel = AppModel::getInstance("Datamart", "Browser", true);
            $nodeDatamartStructureData = $datamartStructureModel->findById($nodeDatamartStructureId);
            $nodeDatamartStructureData = $nodeDatamartStructureData['DatamartStructure'];
            $nodeDatamartStructureMainModelData = AppModel::getInstance($nodeDatamartStructureData['plugin'], $nodeDatamartStructureData['model'], true);
            $nodeLinkedControlData = $browserModel->getAlternateStructureInfo($nodeDatamartStructureData['plugin'], $nodeDatamartStructureMainModelData->getControlName(), $nodeControlId);
            $structuresComponent = AppController::getInstance()->Structures;
            $this->nodesStructures[$key] = $structuresComponent->get('form', $nodeLinkedControlData['form_alias']);
        }
        return $this->nodesStructures[$key];
    }

    /**
     * Format the default values enterred for a created/modified template node.
     *
     * @param string $nodeDefaultValues Node default values in JSON format.
     *       
     * @return string Formatted default values in JSON format
     */
    public function fromateNodeDefaultValuesToSave($nodeDefaultValues)
    {
        $nodeDefaultValues = json_decode($nodeDefaultValues, true);
        $dateFields = array();
        foreach ($nodeDefaultValues as $tmpModel => $tmpData) {
            foreach ($tmpData as $tmpField => $tmpValue) {
                if (preg_match('/^(.+)\[((year)|(month)|(day)|(hour)|(min))]$/', $tmpField, $matches)) {
                    $nodeDefaultValues[$tmpModel][$matches[1]][$matches[2]] = $tmpValue;
                    unset($nodeDefaultValues[$tmpModel][$tmpField]);
                    $dateFields[$tmpModel . '.' . $matches[1]] = array(
                        $tmpModel,
                        $matches[1]
                    );
                }
            }
        }
        foreach ($dateFields as $modelField) {
            list ($dateModel, $dateField) = $modelField;
            $dateToManage = array_merge(array(
                "year" => null,
                "month" => null,
                "day" => null,
                "hour" => null,
                "min" => null,
                "sec" => null
            ), $nodeDefaultValues[$dateModel][$dateField]);
            $dateFinal = '';
            if ($dateToManage['year']) {
                $dateFinal = $dateToManage['year'];
                if ($dateToManage['month']) {
                    $dateFinal .= '-' . $dateToManage['month'];
                    if ($dateToManage['day']) {
                        $dateFinal .= '-' . $dateToManage['day'];
                        if ($dateToManage['hour']) {
                            $dateFinal .= ' ' . $dateToManage['hour'];
                            if ($dateToManage['min']) {
                                $dateFinal .= ' ' . $dateToManage['min'];
                                if ($dateToManage['sec']) {
                                    $dateFinal .= ' ' . $dateToManage['sec'];
                                }
                            }
                        }
                    }
                }
                $nodeDefaultValues[$dateModel][$dateField] = $dateFinal;
            } else {
                unset($nodeDefaultValues[$dateModel][$dateField]);
            }
        }
        return json_encode($nodeDefaultValues);
    }
}