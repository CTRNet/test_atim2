<?php

/**
 * Class ToolsAppModel
 */
class ToolsAppModel extends AppModel
{

    public static $sharing = array(
        'user' => 0,
        'bank' => 1,
        'all' => 2
    );

    private $collectionToolsStructuresFields = array();

    /**
     * Get template(s) or Collection Protocols list based on use definition.
     * When $toolId is set, system defined if tool properties can be edited or not by the user.
     * (Only user who created the template/collection protocol or administrators can change template properties or delete the tool)
     *
     * @param string $useDefintion            
     * @param null $toolId            
     *
     * @return array|null
     */
    public function getTools($useDefintion, $toolId = null)
    {
        $modelName = $this->name;
        if (! in_array($modelName, array(
            'Template',
            'CollectionProtocol'
        ))) {
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        if (is_array($useDefintion)) {
            $useDefintion = $useDefintion[0];
        }
        
        $conditions = array();
        $findType = $toolId ? 'first' : 'all';
        switch ($useDefintion) {
            case 'template all':
            case 'protocol all':
                // No condition
                break;
            
            case 'template edition':
            case 'protocol edition':
                $conditions = array(
                    'OR' => array(
                        array(
                            $modelName . '.owner' => 'user',
                            $modelName . '.owning_entity_id' => AppController::getInstance()->Session->read('Auth.User.id')
                        ),
                        array(
                            $modelName . '.owner' => 'bank',
                            $modelName . '.owning_entity_id' => AppController::getInstance()->Session->read('Auth.User.group_id')
                        ),
                        array(
                            $modelName . '.owner' => 'all'
                        )
                    ),
                    // Both active and inactive template
                    $modelName . '.flag_system' => false
                );
                if (AppController::getInstance()->Session->read('Auth.User.group_id') == '1')
                    unset($conditions['OR']); // Admin can work on all templates
                if ($toolId)
                    $conditions[$modelName . '.id'] = $toolId;
                break;
            
            case 'template use':
            case 'protocol use':
                $conditions = array(
                    'OR' => array(
                        array(
                            $modelName . '.visibility' => 'user',
                            $modelName . '.visible_entity_id' => AppController::getInstance()->Session->read('Auth.User.id')
                        ),
                        array(
                            $modelName . '.visibility' => 'bank',
                            $modelName . '.visible_entity_id' => AppController::getInstance()->Session->read('Auth.User.group_id')
                        ),
                        array(
                            $modelName . '.visibility' => 'all'
                        ),
                        array(
                            $modelName . '.flag_system' => true
                        )
                    ),
                    $modelName . '.flag_active' => 1
                );
                break;
            
            default:
                AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $templates = $this->find($findType, array(
            'conditions' => $conditions
        ));
        if ($templates && $findType == 'first') {
            $templates[$modelName]['allow_properties_edition'] = ((AppController::getInstance()->Session->read('Auth.User.group_id') == 1) || (AppController::getInstance()->Session->read('Auth.User.id') == $templates[$modelName]['created_by']));
        }
        return $templates;
    }

    /**
     * Complete the fields 'owning_entity_id' and 'visible_entity_id' of the recorded tool.
     *
     * @param array $toolData
     *            Data of the recorded template or collection protocol
     * @param integer $createdBy
     *            Id of the user who is creating the record
     *            
     * @return null
     */
    public function setOwnerAndVisibility(&$toolData, $createdBy = null)
    {
        $modelName = $this->name;
        if (! in_array($modelName, array(
            'Template',
            'CollectionProtocol'
        ))) {
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        if (ToolsAppModel::$sharing[$toolData[$modelName]['visibility']] < ToolsAppModel::$sharing[$toolData[$modelName]['owner']]) {
            $toolData[$modelName]['owner'] = $toolData[$modelName]['visibility'];
            AppController::addWarningMsg(__('visibility reduced to owner level'));
        }
        
        // Get tool user & group ids--------------
        $templateUserId = AppController::getInstance()->Session->read('Auth.User.id');
        $templateGroupId = AppController::getInstance()->Session->read('Auth.User.group_id');
        if ($createdBy && $createdBy != $templateUserId) {
            // Get real tool owner and group in case admiistrator is changing data
            $templateUserId = $createdBy;
            
            $userModel = AppModel::getInstance("", "User", true);
            $templateUserData = $userModel->find('first', array(
                'conditions' => array(
                    'User.id' => $createdBy,
                    'User.deleted' => array(
                        0,
                        1
                    )
                )
            ));
            $templateUserId = $templateUserData['User']['id'];
            $templateGroupId = $templateUserData['Group']['id'];
        }
        
        // update entities----------
        $toolData[$modelName]['owning_entity_id'] = null;
        $toolData[$modelName]['visible_entity_id'] = null;
        $tmp = array(
            'owner' => array(
                $toolData[$modelName]['owner'] => &$toolData[$modelName]['owning_entity_id']
            ),
            'visibility' => array(
                $toolData[$modelName]['visibility'] => &$toolData[$modelName]['visible_entity_id']
            )
        );
        
        foreach ($tmp as $level) {
            foreach ($level as $sharing => &$value) {
                switch ($sharing) {
                    case "user":
                        $value = $templateUserId;
                        break;
                    case "bank":
                        $value = $templateGroupId;
                        break;
                    case "all":
                        $value = '0';
                        break;
                    default:
                        AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
            }
        }
        
        $this->addWritableField(array(
            'owning_entity_id',
            'visible_entity_id'
        ));
    }

    /**
     * Generate a string gathering default values defined for the template node or protocol collection in a user readable format.
     * String combines translated labels of the fields of the structures that will be used to create the inventory data (collection, sample, aliquot)
     * into the Inventory Management module and the default values.
     *
     * @param string $linkedStructures
     *            Alias of the structures that will be used to create the inventory data (collection, sample, aliquot)
     * @param array $defaultValues
     *            Default values that will be initially displayed
     *            
     * @return string Formated string with the default values
     */
    public function formatDefaultValuesForDisplay($linkedStructures, $defaultValues)
    {
        // Build an array gathering tranlated labels and lists of values for the fields of the structures
        // that will be used to create the inventory data (collection, sample, aliquot).
        $structuresComponent = AppController::getInstance()->Structures;
        $structurePermissibleValuesCustomModel = AppModel::getInstance("", "StructurePermissibleValuesCustom", true);
        App::uses('StructureValueDomain', 'Model');
        $tructureValueDomainModel = new StructureValueDomain();
        foreach ($linkedStructures['Sfs'] as $newLinkedStructuresField) {
            $mainFieldKey = $newLinkedStructuresField['model'] . '.' . $newLinkedStructuresField['field'];
            if (! isset($this->collectionToolsStructuresFields[$mainFieldKey]) && (($newLinkedStructuresField['flag_add'] && ! $newLinkedStructuresField['flag_add_readonly']) || ($newLinkedStructuresField['flag_edit'] && ! $newLinkedStructuresField['flag_edit_readonly']))) {
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
                            $structureValueDomainValues = $structureValueDomainValues['defined'] + $structureValueDomainValues['previously_defined'];
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
                } elseif ($newLinkedStructuresField['type'] == 'checkbox') {
                    $structureValueDomainValues['1'] = __('yes');
                    $structureValueDomainValues['0'] = __('no');
                }
                $this->collectionToolsStructuresFields[$mainFieldKey] = array(
                    'model' => $newLinkedStructuresField['model'],
                    'field' => $newLinkedStructuresField['field'],
                    'type' => $newLinkedStructuresField['type'],
                    'language_label' => $newLinkedStructuresField['language_label'],
                    'type' => $newLinkedStructuresField['type'],
                    'structure_value_domain_values' => $structureValueDomainValues
                );
            }
        }
        // Build formatted string of default values gathering tranlsated lables and list of values of the structures fields
        // and default value.
        $formattedDefaultValues = array();
        foreach ($defaultValues as $model => $fields) {
            foreach ($fields as $field => $value) {
                if (isset($this->collectionToolsStructuresFields[$model . '.' . $field])) {
                    // Default value field matchs field of the structrues linked to the inventory data (collection, sample, aliquot) :Format default value
                    $tmpCollectionTemplateNodesStructuresField = $this->collectionToolsStructuresFields[$model . '.' . $field];
                    if (! empty($tmpCollectionTemplateNodesStructuresField['structure_value_domain_values'])) {
                        $value = isset($tmpCollectionTemplateNodesStructuresField['structure_value_domain_values'][$value]) ? $tmpCollectionTemplateNodesStructuresField['structure_value_domain_values'][$value] : $value;
                    } elseif (in_array($tmpCollectionTemplateNodesStructuresField['type'], array(
                        'date',
                        'datetime'
                    ))) {
                        $formattedDate = AppController::getFormatedDateString($value['year'], $value['month'], $value['day'], false);
                        $formattedTime = AppController::getFormatedTimeString($value['hour'], $value['min'], false);
                        $value = $formattedDate . ' ' . $formattedTime;
                    }
                    $formattedDefaultValues[] = $tmpCollectionTemplateNodesStructuresField['language_label'] . " = [$value]";
                } else {
                    // Default Value Field does not match field of the structrues: Display field as is
                    if (! preg_match('/_accuracy/', $field)) {
                        $formattedDefaultValues[] = "$field = [$value]";
                    }
                }
            }
        }
        // Generate string
        $formattedDefaultValues = implode(' & ', $formattedDefaultValues);
        return $formattedDefaultValues;
    }
}