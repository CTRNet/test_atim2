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
 * Class ToolsAppModel
 */
class ToolsAppModel extends AppModel
{

    public static $sharing = array(
        'user' => 0,
        'group' => 1,
        'bank' => 2,
        'all' => 3
    );

    private $collectionToolsStructuresFields = array();

    /**
     * Get template(s) or Collection Protocols list based on use definition.
     * When $toolId is set, system defined if tool properties can be edited or not by the user.
     *
     * Rules:
     * ## 1 - Edition
     * . A tool can only be edited when this one is not a system tool (flag_system != 1 - this rule is apply to all following rules)
     * . An administrator can edit all tools
     * . A user can edit all tools he created
     * . A tool with owner equal to 'user' can only be edited by user who created the tool (and the administrators)
     * . A tool with owner equal to 'group' can only be edited by the users of the group of the user who created the tool (and the administrators)
     * (Note: If the user changed from group, the group to consider is the group the user was linked the day of the tool creation)
     * . A tool with owner equal to 'bank' can only be edited by
     * either the users of groups linked to the same bank than the group of the user who created the tool
     * or by the users of the group of the user who created the tool (in case group is not linked to a bank)
     * (or the administrators)
     * (Note: If the user changed from group, the group to consider is the group the user was linked the day of the tool creation)
     * . A tool with owner equal to 'all' can be edited by all user
     * ## 2 - Use
     * . A tool can only be used when this one is active (flag_active = 1 - this rule is apply to all following rules)
     * . A tool with visibility equal to 'user' can only be used by user who created the tool
     * . A tool with visibility equal to 'group' by the users of the group of the user who created the tool
     * (Note: If the user changed from group, the group to consider is the group the user was linked the day of the tool creation)
     * . A tool with visibility equal to 'bank' can only be used by
     * either the users of groups linked to the same bank than the group of the user who created the tool
     * or by the users of the group of the user who created the tool (in case group is not linked to a bank)
     * (Note: If the user changed from group, the group to consider is the group the user was linked the day of the tool creation)
     * . A tool with visibility equal to 'all' can be used by all users
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
        
        $userBankId = AppController::getInstance()->Session->read('Auth.User.Group.bank_id');
        $userBankGroupIds = array(
            '-1'
        );
        if ($userBankId) {
            $bankModel = AppModel::getInstance('Administrate', 'Bank', true);
            $tmpBankGroupIds = $bankModel->getBankGroupIds($userBankId);
            if ($tmpBankGroupIds) {
                $userBankGroupIds = $tmpBankGroupIds;
            }
        }
        
        // Conditions
        
        $allConditions = array();
        
        $allConditions['all'] = array(
            'TRUE'
        );
        
        $allConditions['edition'] = (AppController::getInstance()->Session->read('Auth.User.group_id') == '1') ?
            // Admin can work on all templates
            array(
				'TRUE'
			) :
            // Set specific conditions for non admin group
            array(
                'OR' => array(
                    array(
                        $modelName . '.user_id' => AppController::getInstance()->Session->read('Auth.User.id')
                    ),
                    array(
                        $modelName . '.owner' => 'user',
                        $modelName . '.user_id' => AppController::getInstance()->Session->read('Auth.User.id')
                    ),
                    // Bank owner condition added if group of the user is not linked to a bank
                    array(
                        $modelName . '.owner' => array(
                            'group',
                            'bank'
                        ),
                        $modelName . '.group_id' => AppController::getInstance()->Session->read('Auth.User.group_id')
                    ),
                    array(
                        $modelName . '.owner' => 'bank',
                        $modelName . '.group_id' => $userBankGroupIds
                    ),
                    array(
                        $modelName . '.owner' => 'all'
                    )
                ),
                // Both active and inactive template
                $modelName . '.flag_system' => false
            );
        if ($toolId) {
            $allConditions['edition'][$modelName . '.id'] = $toolId;
        }
        
        $allConditions['use'] = array(
            'OR' => array(
                array(
                    $modelName . '.visibility' => 'user',
                    $modelName . '.user_id' => AppController::getInstance()->Session->read('Auth.User.id')
                ),
                // Bank visibility condition added if group of the user is not linked to a bank
                array(
                    $modelName . '.visibility' => array(
                        'group',
                        'bank'
                    ),
                    $modelName . '.group_id' => AppController::getInstance()->Session->read('Auth.User.group_id')
                ),
                array(
                    $modelName . '.visibility' => 'bank',
                    $modelName . '.group_id' => $userBankGroupIds
                ),
                array(
                    $modelName . '.visibility' => 'all'
                )
            ),
            $modelName . '.flag_active' => 1
        );
        
        $allConditions['list all'] = array(
            'OR' => array(
                $allConditions['use'],
                $allConditions['edition']
            )
        );
        
        $allConditions['use']['OR'][] = array(
            $modelName . '.flag_system' => true
        );
        
        if (! array_key_exists($useDefintion, $allConditions)) {
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        $conditions = $allConditions[$useDefintion];
        $findType = $toolId ? 'first' : 'all';
        
        // Find data
        
        $tools = $this->find($findType, array(
            'conditions' => $conditions
        ));
        
        if ($findType == 'first') {
            $tools[$modelName]['allow_properties_edition'] = $tools ? true : false;
        }
        
        return $tools;
    }

    /**
     * Validate and set owner value.
     *
     * @param array $toolData Data of the recorded template or collection protocol
     *       
     * @return null
     */
    public function setOwner(&$toolData)
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
    }

    /**
     * Generate a string gathering default values defined for the template node or protocol collection in a user readable format.
     * String combines translated labels of the fields of the structures that will be used to create the inventory data (collection, sample, aliquot)
     * into the Inventory Management module and the default values.
     *
     * @param string $linkedStructures Alias of the structures that will be used to create the inventory data (collection, sample, aliquot)
     * @param array $defaultValues Default values that will be initially displayed
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
                        $tmpDateTimeArray = array(
                            'year' => '',
                            'month' => '',
                            'day' => '',
                            'hour' => '',
                            'min' => ''
                        );
                        $tmpDateTimeArray = array_merge($tmpDateTimeArray, $value);
                        $formattedDate = AppController::getFormatedDateString($tmpDateTimeArray['year'], $tmpDateTimeArray['month'], $tmpDateTimeArray['day'], false);
                        $formattedTime = ($tmpDateTimeArray['hour'] || $tmpDateTimeArray['min']) ? ' ' . AppController::getFormatedTimeString($tmpDateTimeArray['hour'], $tmpDateTimeArray['min'], false) : '';
                        $value = $formattedDate . $formattedTime;
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