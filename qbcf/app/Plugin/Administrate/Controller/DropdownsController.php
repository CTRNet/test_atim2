<?php

/**
 * Class DropdownsController
 */
class DropdownsController extends AdministrateAppController
{

    public $uses = array(
        'StructurePermissibleValuesCustom',
        'StructurePermissibleValuesCustomControl'
    );

    public $paginate = array(
        'StructurePermissibleValuesCustomControl' => array(
            'order' => 'StructurePermissibleValuesCustomControl.category ASC, StructurePermissibleValuesCustomControl.name ASC'
        )
    );

    public function index()
    {
        // Nothing to do
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     *
     * @param string $filter
     */
    public function subIndex($filter = 'all')
    {
        if (! in_array($filter, array(
            'all',
            'empty',
            'not_empty'
        )))
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        $counterSortOption = false;
        if (isset($this->passedArgs['sort']) && $this->passedArgs['sort'] == 'Generated.custom_permissible_values_counter') {
            $counterSortOption = $this->passedArgs['direction'];
        }
        $conditions = array(
            'StructurePermissibleValuesCustomControl.flag_active' => '1'
        );
        if ($filter == 'empty')
            $conditions['StructurePermissibleValuesCustomControl.values_counter'] = '0';
        elseif ($filter == 'not_empty')
            $conditions[] = 'StructurePermissibleValuesCustomControl.values_counter != 0';
        $this->request->data = $this->paginate($this->StructurePermissibleValuesCustomControl, $conditions);
        // Add fields list
        foreach ($this->request->data as &$newList) {
            $query = "SELECT DISTINCT
				str.alias AS structure_alias,
				sfi.plugin AS plugin,
				sfi.model AS model,
				sfi.tablename AS tablename,
				sfi.field AS field,
				sfi.structure_value_domain AS structure_value_domain,
				svd.domain_name AS structure_value_domain_name,
				IF((sfo.flag_override_label = '1'),sfo.language_label,sfi.language_label) AS language_label,
				IF((sfo.flag_override_tag = '1'),sfo.language_tag,sfi.language_tag) AS language_tag
				FROM structure_formats sfo
				INNER JOIN structure_fields sfi ON sfo.structure_field_id = sfi.id
				INNER JOIN structures str ON str.id = sfo.structure_id
				INNER JOIN structure_value_domains svd ON svd.id = sfi.structure_value_domain
				WHERE (sfo.flag_add =1 OR sfo.flag_addgrid =1 OR sfo.flag_index =1 OR sfo.flag_detail)
				AND svd.source LIKE 'StructurePermissibleValuesCustom::getCustomDropdown(''" . str_replace("'", "''", $newList['StructurePermissibleValuesCustomControl']['name']) . "'')'";
            $allFieldsData = $this->StructurePermissibleValuesCustomControl->query($query);
            $fieldsList = array();
            foreach ($allFieldsData as $newField) {
                $value = $newField['sfi']['model'] . ' :: ' . __($newField['0']['language_label']) . (strlen($newField['0']['language_tag']) ? ' ' . __($newField['0']['language_label']) : '');
                $fieldsList[$value] = '-';
            }
            ksort($fieldsList);
            $newList['Generated']['fields_linked_to_custom_list'] = implode("\n", array_keys($fieldsList));
        }
        $this->Structures->set("administrate_dropdowns", 'administrate_dropdowns');
    }

    /**
     *
     * @param $controlId
     */
    public function view($controlId)
    {
        $controlData = $this->StructurePermissibleValuesCustomControl->getOrRedirect($controlId);
        $this->set("controlData", $controlData);
        
        $this->request->data = $this->StructurePermissibleValuesCustom->find('all', array(
            'conditions' => array(
                'StructurePermissibleValuesCustom.control_id' => $controlId
            ),
            'order' => array(
                'display_order',
                'value'
            )
        ));
        $this->Structures->set("administrate_dropdown_values", 'administrate_dropdown_values');
    }

    /**
     *
     * @param $controlId
     */
    public function add($controlId)
    {
        $controlData = $this->StructurePermissibleValuesCustomControl->getOrRedirect($controlId);
        $this->set("controlData", $controlData);
        
        $this->Structures->set("administrate_dropdown_values", 'administrate_dropdown_values');
        if (empty($this->request->data)) {
            $this->request->data = array(
                array(
                    'StructurePermissibleValuesCustom' => array(
                        'value' => ""
                    )
                )
            );
        } else {
            // validate and save
            
            $errorsTracking = array();
            
            // A - Launch Business Rules Validation
            
            $currentValues = array();
            $currentEn = array();
            $currentFr = array();
            $this->StructurePermissibleValuesCustom->schema();
            $maxLength = min($this->StructurePermissibleValuesCustom->_schema['value']['length'], $controlData["StructurePermissibleValuesCustomControl"]["values_max_length"]);
            $break = false;
            $tmp = $this->StructurePermissibleValuesCustom->find('all', array(
                'conditions' => array(
                    'control_id' => $controlId
                ),
                'recursive' => - 1
            ));
            $existingValues = array();
            $existingEn = array();
            $existingFr = array();
            foreach ($tmp as $unit) {
                $existingValues[$unit['StructurePermissibleValuesCustom']['value']] = null;
                $existingEn[$unit['StructurePermissibleValuesCustom']['en']] = null;
                $existingFr[$unit['StructurePermissibleValuesCustom']['fr']] = null;
            }
            
            $rowCounter = 0;
            foreach ($this->request->data as &$dataUnit) {
                $rowCounter ++;
                
                // 1- Check 'value'
                
                $dataUnit['StructurePermissibleValuesCustom'] = array_map("trim", $dataUnit['StructurePermissibleValuesCustom']);
                if (array_key_exists($dataUnit['StructurePermissibleValuesCustom']['value'], $existingValues)) {
                    $errorsTracking['value'][__('a specified %s already exists for that dropdown', __("value"))][] = $rowCounter;
                }
                if (array_key_exists($dataUnit['StructurePermissibleValuesCustom']['value'], $currentValues)) {
                    $errorsTracking['value'][__('you cannot declare the same %s more than once', __("value"))][] = $rowCounter;
                }
                if (strlen($dataUnit['StructurePermissibleValuesCustom']['value']) > $maxLength) {
                    $errorsTracking['value'][__('%s cannot exceed %d characters', __("value"), $maxLength)][] = $rowCounter;
                }
                
                // 2- Check 'en'
                
                if (! (is_null($dataUnit['StructurePermissibleValuesCustom']['en']) || ($dataUnit['StructurePermissibleValuesCustom']['en'] == ''))) {
                    if (array_key_exists($dataUnit['StructurePermissibleValuesCustom']['en'], $existingEn)) {
                        $errorsTracking['en'][__('a specified %s already exists for that dropdown', __("english translation"))][] = $rowCounter;
                    }
                    if (array_key_exists($dataUnit['StructurePermissibleValuesCustom']['en'], $currentEn)) {
                        $errorsTracking['en'][__('you cannot declare the same %s more than once', __("english translation"))][] = $rowCounter;
                    }
                }
                if (strlen($dataUnit['StructurePermissibleValuesCustom']['en']) > $this->StructurePermissibleValuesCustom->_schema['en']['length']) {
                    $errorsTracking['en'][__('%s cannot exceed %d characters', __("english translation"), $this->StructurePermissibleValuesCustom->_schema['en']['length'])][] = $rowCounter;
                }
                
                // 3- Check 'fr'
                
                if (! (is_null($dataUnit['StructurePermissibleValuesCustom']['fr']) || ($dataUnit['StructurePermissibleValuesCustom']['fr'] == ''))) {
                    if (array_key_exists($dataUnit['StructurePermissibleValuesCustom']['fr'], $existingFr)) {
                        $errorsTracking['fr'][__('a specified %s already exists for that dropdown', __("french translation"))][] = $rowCounter;
                    }
                    if (array_key_exists($dataUnit['StructurePermissibleValuesCustom']['fr'], $currentFr)) {
                        $errorsTracking['fr'][__('you cannot declare the same %s more than once', __("french translation"))][] = $rowCounter;
                    }
                }
                if (strlen($dataUnit['StructurePermissibleValuesCustom']['fr']) > $this->StructurePermissibleValuesCustom->_schema['fr']['length']) {
                    $errorsTracking['fr'][__('%s cannot exceed %d characters', __("french translation"), $this->StructurePermissibleValuesCustom->_schema['fr']['length'])][] = $rowCounter;
                }
                
                $currentValues[$dataUnit['StructurePermissibleValuesCustom']['value']] = null;
                $currentEn[$dataUnit['StructurePermissibleValuesCustom']['en']] = null;
                $currentFr[$dataUnit['StructurePermissibleValuesCustom']['fr']] = null;
            }
            unset($dataUnit);
            
            // B - Launch Structure Fields Validation
            
            $rowCounter = 0;
            foreach ($this->request->data as $dataUnit) {
                $rowCounter ++;
                $this->StructurePermissibleValuesCustom->id = null;
                $dataUnit['StructurePermissibleValuesCustom']['control_id'] = $controlId;
                $this->StructurePermissibleValuesCustom->set($dataUnit);
                if (! $this->StructurePermissibleValuesCustom->validates()) {
                    foreach ($this->StructurePermissibleValuesCustom->validationErrors as $field => $msgs) {
                        $msgs = is_array($msgs) ? $msgs : array(
                            $msgs
                        );
                        foreach ($msgs as $msg)
                            $errorsTracking[$field][$msg][] = $rowCounter;
                    }
                }
            }
            
            // Launch Save Process
            if (empty($errorsTracking)) {
                // save all
                $tmpData = AppController::cloneArray($this->request->data);
                $this->StructurePermissibleValuesCustom->addWritableField('control_id');
                $this->StructurePermissibleValuesCustom->writableFieldsMode = 'addgrid';
                while ($dataUnit = array_pop($tmpData)) {
                    $this->StructurePermissibleValuesCustom->id = null;
                    $dataUnit['StructurePermissibleValuesCustom']['control_id'] = $controlId;
                    $this->StructurePermissibleValuesCustom->set($dataUnit);
                    if (! $this->StructurePermissibleValuesCustom->save($dataUnit)) {
                        $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                    }
                }
                $this->atimFlash(__('your data has been updated'), '/Administrate/Dropdowns/view/' . $controlId);
            } else {
                $this->StructurePermissibleValuesCustomControl->validationErrors = array();
                foreach ($errorsTracking as $field => $msgAndLines) {
                    foreach ($msgAndLines as $msg => $lines) {
                        $this->StructurePermissibleValuesCustomControl->validationErrors[$field][] = $msg . ' - ' . str_replace('%s', implode(",", $lines), __('see line %s'));
                    }
                }
            }
        }
    }

    /**
     *
     * @param $controlId
     * @param $valueId
     */
    public function edit($controlId, $valueId)
    {
        $controlData = $this->StructurePermissibleValuesCustomControl->getOrRedirect($controlId);
        $this->set("controlData", $controlData);
        
        $this->set('atimMenuVariables', array(
            'StructurePermissibleValuesCustom.id' => $valueId,
            'StructurePermissibleValuesCustom.control_id' => $controlId
        ));
        
        $valueData = $this->StructurePermissibleValuesCustom->find('first', array(
            'conditions' => array(
                'StructurePermissibleValuesCustom.control_id' => $controlId,
                'StructurePermissibleValuesCustom.id' => $valueId
            )
        ));
        if (empty($valueData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $this->Structures->set("administrate_dropdown_values", 'administrate_dropdown_values');
        
        if (empty($this->request->data)) {
            $this->request->data = $valueData;
        } else {
            $this->StructurePermissibleValuesCustom->id = $valueId;
            $skipSave = false;
            
            // 1- Check 'en'
            
            if (! (is_null($this->request->data['StructurePermissibleValuesCustom']['en']) || ($this->request->data['StructurePermissibleValuesCustom']['en'] == '') || ($this->request->data['StructurePermissibleValuesCustom']['en'] == $valueData['StructurePermissibleValuesCustom']['en']))) {
                $tmp = $this->StructurePermissibleValuesCustom->find('first', array(
                    'conditions' => array(
                        'StructurePermissibleValuesCustom.en' => $this->request->data['StructurePermissibleValuesCustom']['en'],
                        'StructurePermissibleValuesCustom.id != ' . $valueId,
                        'StructurePermissibleValuesCustom.control_id' => $controlId
                    )
                ));
                if (! empty($tmp)) {
                    $this->StructurePermissibleValuesCustom->validationErrors['en'][] = __('a specified %s already exists for that dropdown', __("english translation"));
                    $skipSave = true;
                }
                if (strlen($this->request->data['StructurePermissibleValuesCustom']['en']) > $this->StructurePermissibleValuesCustom->_schema['en']['length']) {
                    $this->StructurePermissibleValuesCustom->validationErrors['en'][] = __('%s cannot exceed %d characters', __("english translation"), $this->StructurePermissibleValuesCustom->_schema['en']['length']);
                    $skipSave = true;
                }
            }
            
            // 2- Check 'fr'
            
            if (! (is_null($this->request->data['StructurePermissibleValuesCustom']['fr']) || ($this->request->data['StructurePermissibleValuesCustom']['fr'] == '') || ($this->request->data['StructurePermissibleValuesCustom']['fr'] == $valueData['StructurePermissibleValuesCustom']['fr']))) {
                $tmp = $this->StructurePermissibleValuesCustom->find('first', array(
                    'conditions' => array(
                        'StructurePermissibleValuesCustom.fr' => $this->request->data['StructurePermissibleValuesCustom']['fr'],
                        'StructurePermissibleValuesCustom.id != ' . $valueId,
                        'StructurePermissibleValuesCustom.control_id' => $controlId
                    )
                ));
                if (! empty($tmp)) {
                    $this->StructurePermissibleValuesCustom->validationErrors['fr'][] = __('a specified %s already exists for that dropdown', __("french translation"));
                    $skipSave = true;
                }
                if (strlen($this->request->data['StructurePermissibleValuesCustom']['fr']) > $this->StructurePermissibleValuesCustom->_schema['fr']['length']) {
                    $this->StructurePermissibleValuesCustom->validationErrors['fr'][] = __('%s cannot exceed %d characters', __("french translation"), $this->StructurePermissibleValuesCustom->_schema['fr']['length']);
                    $skipSave = true;
                }
            }
            
            if (! $skipSave) {
                if (! $this->StructurePermissibleValuesCustom->save($this->request->data)) {
                    $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
                $this->atimFlash(__('your data has been updated'), '/Administrate/Dropdowns/view/' . $controlId);
            }
        }
    }

    /**
     *
     * @param $controlId
     */
    public function configure($controlId)
    {
        $this->Structures->set('administrate_dropdown_values');
        if (empty($this->request->data)) {
            $controlData = $this->StructurePermissibleValuesCustomControl->getOrRedirect($controlId);
            $this->set("controlData", $controlData);
            $this->set('atimMenuVariables', array(
                'StructurePermissibleValuesCustom.control_id' => $controlId
            ));
            
            $this->request->data = $this->StructurePermissibleValuesCustom->find('all', array(
                'conditions' => array(
                    'StructurePermissibleValuesCustom.control_id' => $controlId
                ),
                'recursive' => - 1,
                'order' => array(
                    'display_order',
                    'value'
                )
            ));
            if (empty($this->request->data)) {
                $this->atimFlashWarning(__("you cannot configure an empty list"), "javascript:history.back();");
            }
            $this->set('alphaOrder', $this->request->data[0]['StructurePermissibleValuesCustom']['display_order'] == 0);
        } else {
            $data = array();
            if (isset($this->request->data[0]['default_order'])) {
                foreach ($this->request->data as $unit) {
                    $data[] = array(
                        "id" => $unit['StructurePermissibleValuesCustom']['id'],
                        "display_order" => 0,
                        "use_as_input" => $unit['StructurePermissibleValuesCustom']['use_as_input']
                    );
                }
            } else {
                $order = 1;
                foreach ($this->request->data as $unit) {
                    $data[] = array(
                        "id" => $unit['StructurePermissibleValuesCustom']['id'],
                        "display_order" => $order ++,
                        "use_as_input" => $unit['StructurePermissibleValuesCustom']['use_as_input']
                    );
                }
            }
            
            $ids = $this->StructurePermissibleValuesCustom->find('all', array(
                'conditions' => array(
                    'StructurePermissibleValuesCustom.control_id' => $controlId
                ),
                'recursive' => - 1,
                'fields' => 'id'
            ));
            $ids = AppController::defineArrayKey($ids, 'StructurePermissibleValuesCustom', 'id', true);
            if (count($ids) != count($data)) {
                // hack detected
                $this->redirect('/Pages/err_plugin_system_error', null, true);
            }
            foreach ($data as &$dataUnit) {
                if (! isset($ids[$dataUnit['id']])) {
                    // hack detected
                    $this->redirect('/Pages/err_plugin_system_error', null, true);
                }
            }
            
            $this->StructurePermissibleValuesCustom->addWritableField('display_order');
            $this->StructurePermissibleValuesCustom->writableFieldsMode = 'editgrid';
            $this->StructurePermissibleValuesCustom->getDataSource()->begin();
            foreach ($data as &$dataUnit) {
                $this->StructurePermissibleValuesCustom->data = null;
                $this->StructurePermissibleValuesCustom->id = $dataUnit['id'];
                $this->StructurePermissibleValuesCustom->save($dataUnit);
            }
            $this->StructurePermissibleValuesCustom->getDataSource()->commit();
            $this->atimFlash(__('your data has been updated'), '/Administrate/Dropdowns/view/' . $controlId);
        }
    }
}