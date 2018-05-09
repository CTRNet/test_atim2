<?php

/**
 * Class TemplateNode
 */
class TemplateNode extends AppModel
{

    public $useTable = 'template_nodes';

    private $collectionTemplateNodesStructuresFields = array();

    /**
     * Fomrat the default values defined for each node of a collection tempalte
     * to be displayed in collection tree view.
     *
     * @param integer $templateId
     *            Id of the colelction template
     *            
     * @return array $allFormattedDefaultValues Data gathering formated default values for each node of the template with default values [array('node_id' => string)]
     */
    public function formatTemplateNodeDefaultValuesForDisplay($templateId)
    {
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
            $newNode = $newNode['TemplateNode'];
            $nodeId = $newNode['id'];
            $nodeDefaultValues = json_decode($newNode['default_values'], true);
            ;
            $nodeDatamartStructureId = $newNode['datamart_structure_id'];
            $nodeControlId = $newNode['control_id'];
            
            // Get all structures that will be used to create the collection element/record defined into the node
            $datamartStructureModel = AppModel::getInstance('Datamart', 'DatamartStructure');
            $browserModel = AppModel::getInstance("Datamart", "Browser", true);
            $nodeDatamartStructureData = $datamartStructureModel->findById($nodeDatamartStructureId);
            $nodeDatamartStructureData = $nodeDatamartStructureData['DatamartStructure'];
            $nodeDatamartStructureMainModelData = AppModel::getInstance($nodeDatamartStructureData['plugin'], $nodeDatamartStructureData['model'], true);
            $nodeLinkedControlData = $browserModel->getAlternateStructureInfo($nodeDatamartStructureData['plugin'], $nodeDatamartStructureMainModelData->getControlName(), $nodeControlId);
            $structuresComponent = AppController::getInstance()->Structures;
            $nodeLinkedStructures = $structuresComponent->get('form', $nodeLinkedControlData['form_alias']);
            $tmpModels = array();
            
            // Build fields properties array
            $structurePermissibleValuesCustomModel = AppModel::getInstance("", "StructurePermissibleValuesCustom", true);
            App::uses('StructureValueDomain', 'Model');
            $tructureValueDomainModel = new StructureValueDomain();
            foreach ($nodeLinkedStructures['Sfs'] as $newLinkedStructuresField) {
                $mainFieldKey = $newLinkedStructuresField['model'] . '.' . $newLinkedStructuresField['field'];
                if (! isset($this->collectionTemplateNodesStructuresFields[$mainFieldKey]) && (($newLinkedStructuresField['flag_add'] && ! $newLinkedStructuresField['flag_add_readonly']) || ($newLinkedStructuresField['flag_edit'] && ! $newLinkedStructuresField['flag_edit_readonly']))) {
                    // Manage Label
                    $newLinkedStructuresField['language_label'] = array(
                        __($newLinkedStructuresField['language_label']),
                        __($newLinkedStructuresField['language_tag'])
                    );
                    $newLinkedStructuresField['language_label'] = array_filter($newLinkedStructuresField['language_label']);
                    $newLinkedStructuresField['language_label'] = implode(' - ', $newLinkedStructuresField['language_label']);
                    // Manage list of values
                    $structureValueDomainValues = array();
                    if (isset($newLinkedStructuresField['StructureValueDomain']['domain_name'])) {
                        if (strlen($newLinkedStructuresField['StructureValueDomain']['source'])) {
                            $structureValueDomainValues = $structuresComponent::getPulldownFromSource($newLinkedStructuresField['StructureValueDomain']['source']);
                            if (array_key_exists('defined', $structureValueDomainValues) && array_key_exists('previously_defined', $structureValueDomainValues)) {
                                $structureValueDomainValues = array_merge($structureValueDomainValues['defined'], $structureValueDomainValues['previously_defined']);
                            }
                        } else {
                            $queryCriteria = array(
                                'recursive' => 2,
                                'conditions' => array(
                                    'StructureValueDomain.domain_name' => $newLinkedStructuresField['StructureValueDomain']['domain_name']
                                )
                            );
                            $structurePermissibleValueTmp = $tructureValueDomainModel->find('first', $queryCriteria);
                            foreach ($structurePermissibleValueTmp['StructurePermissibleValue'] as $newValue) {
                                if ($newValue['flag_active']) {
                                    $structureValueDomainValues[$newValue['value']] = __($newValue['language_alias']);
                                }
                            }
                        }
                    } elseif ($newLinkedStructuresField['type'] == 'yes_no') {
                        $structureValueDomainValues['y'] = __('yes');
                        $structureValueDomainValues['n'] = __('no');
                    }
                    $this->collectionTemplateNodesStructuresFields[$mainFieldKey] = array(
                        'model' => $newLinkedStructuresField['model'],
                        'field' => $newLinkedStructuresField['field'],
                        'type' => $newLinkedStructuresField['type'],
                        'language_label' => $newLinkedStructuresField['language_label'],
                        'type' => $newLinkedStructuresField['type'],
                        'structure_value_domain_values' => $structureValueDomainValues
                    );
                }
            }
            
            // Build formatted string of default values
            $formattedNodeDefaultValues = array();
            foreach ($nodeDefaultValues as $model => $fields) {
                foreach ($fields as $field => $value) {
                    if (isset($this->collectionTemplateNodesStructuresFields[$model . '.' . $field])) {
                        // Default Value Field matchs field of the structrues linked to the node
                        // Format data
                        $tmpCollectionTemplateNodesStructuresField = $this->collectionTemplateNodesStructuresFields[$model . '.' . $field];
                        if (! empty($tmpCollectionTemplateNodesStructuresField['structure_value_domain_values'])) {
                            $value = isset($tmpCollectionTemplateNodesStructuresField['structure_value_domain_values'][$value]) ? $tmpCollectionTemplateNodesStructuresField['structure_value_domain_values'][$value] : $value;
                        } elseif (in_array($tmpCollectionTemplateNodesStructuresField['type'], array(
                            'date',
                            'datetime'
                        ))) {
                            $dateAccuracy = 'c';
                            if (isset($fields[$field . '_accuracy'])) {
                                $dateAccuracy = $nodeDefaultValues[$model][$field . '_accuracy'];
                            }
                            switch ($dateAccuracy) {
                                case 'i':
                                    $value = substr($value, 0, 13);
                                    break;
                                case 'h':
                                    $value = substr($value, 0, 10);
                                    break;
                                case 'd':
                                    $value = substr($value, 0, 7);
                                    break;
                                case 'm':
                                    $value = substr($value, 0, 4);
                                    break;
                                case 'y':
                                    $value = '±' . substr($value, 0, 4);
                                    break;
                                default:
                                    break;
                            }
                        }
                        $formattedNodeDefaultValues[] = $tmpCollectionTemplateNodesStructuresField['language_label'] . " = [$value]";
                    } else {
                        // Default Value Field does not match field of the structrues linked to the node: Display field as is
                        if (! preg_match('/_accuracy/', $field)) {
                            $formattedNodeDefaultValues[$nodeId] = "$field = [$value]";
                        }
                    }
                }
            }
            // Fomat array of default value to string
            $allFormattedDefaultValues[$nodeId] = implode(' + ', $formattedNodeDefaultValues);
            $maxLgt = 250;
            if (strlen($allFormattedDefaultValues[$nodeId]) > ($maxLgt + 4)) {
                $allFormattedDefaultValues[$nodeId] = substr($allFormattedDefaultValues[$nodeId], 0, $maxLgt) . ' ...';
            }
        }
        return $allFormattedDefaultValues;
    }
}