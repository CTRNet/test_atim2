<?php

/**
 * Class StructuresComponent
 */
class StructuresComponent extends Component
{

    public $StructureValueDomain;

    public $controller;

    public static $singleton;

    private $structureAlias;

    public static $dateRange = array(
        "date",
        "datetime",
        "time"
    );

    public static $rangeTypes = array(
        "date",
        "datetime",
        "time",
        "integer",
        "integer_positive",
        "float",
        "float_positive"
    );

    public static $rangeTypesNumber = array(
        "integer",
        "integer_positive",
        "float",
        "float_positive"
    );

    /**
     *
     * @param Controller $controller
     */
    public function initialize(Controller $controller)
    {
        $this->controller = $controller;
        StructuresComponent::$singleton = $this;
    }

    /*
     * Combined function to simplify plugin usage,
     * sets validation for models AND sets atim_structure for view
     * @param $alias Form alias of the new structure
     * @param $structureName Structure name (by default name will be 'atim_structure')
     * @param array $parameters
     */
    /**
     *
     * @param null $alias
     * @param string $structureName
     * @param array $parameters
     */
    public function set($alias = null, $structureName = 'atimStructure', array $parameters = array())
    {
        if (! is_array($alias)) {
            $alias = array_filter(explode(",", $alias));
            // $alias = array_map('AppController::snakeToCamel', array_values($alias));
            if (! $alias) {
                $alias[] = '';
            }
        }
        $parameters = array_merge(array(
            'set_validation' => true, // wheter to set model validations or not
            'model_table_assoc' => array()
        ), // bind a tablename to a model for writable fields
$parameters);
        
        $structure = array(
            'Structure' => array(),
            'Sfs' => array(),
            'Accuracy' => array()
        );
        $allStructures = array();
        
        $validationErrors = array();
        $models = array();
        foreach ($alias as $aliasUnit) {
            $structUnit = $this->getSingleStructure($aliasUnit);
            
            $allStructures[] = $structUnit;
            
            if ($parameters['set_validation']) {
                if (isset($structUnit['rules']) && is_array($structUnit['rules'])) {
                    foreach ($structUnit['rules'] as $model => $rules) {
                        // reset validate for newly loaded structure models
                        if (!$this->controller->{ $model }) {
                            $this->controller->{ $model } = new AppModel();
                        }

                        $models[$model] = $this->controller->{ $model };
                        $this->controller->{ $model }->validate = array();
                        foreach ($rules as $field=> $rls){
                            foreach ($rls as $rule){
                                if ($rule["rule"] == "notBlank"){
                                    if ($model =="FunctionManagement"){
                                        if (!isset($this->controller->data[$model][$field]) || empty($this->controller->data[$model][$field])){
                                            $validationErrors[$field] = $rule['message'];
                                        }else{
                                            if (is_numeric(key($this->controller->data))){
                                                foreach (current($this->controller->data) as $k=>$data) {
                                                    if (isset($data[$model][$field]) && empty($data[$model][$field])){
                                                        $validationErrors[$field] = $rule['message'];
                                                    }                                                
                                                }
                                            }
                                        }
                                    }
                                    $aliasTemp = strtolower($aliasUnit ? trim($aliasUnit) : str_replace('_', '', $this->controller->params['controller']));
                                    if (isset(AppModel::$requiredFields[$model."||".$aliasTemp])){
                                        AppModel::$requiredFields[$model."||".$aliasTemp][$field] = $rule["message"];
                                    }else{
                                        AppModel::$requiredFields[$model."||".$aliasTemp] = array($field => $rule["message"]);
                                    }
                                }
                            }
                            
                        }
                    }
                }
                
                if (isset($structUnit['structure']['Sfs'])) {
                    foreach ($structUnit['structure']['Sfs'] as $sfs) {
                        $tablename = isset($parameters['model_table_assoc'][$sfs['model']]) ? $parameters['model_table_assoc'][$sfs['model']] : $sfs['tablename'];
                        if ($tablename) {
                            foreach (array(
                                'add',
                                'edit',
                                'addgrid',
                                'editgrid',
                                'batchedit'
                            ) as $flag) {
                                if ($sfs['flag_' . $flag] && ! $sfs['flag_' . $flag . '_readonly'] && $sfs['type'] != 'hidden') {
                                    AppModel::$writableFields[$tablename][$flag][] = $sfs['field'];
                                    if ($sfs['type'] == 'date' || $sfs['type'] == 'datetime') {
                                        AppModel::$writableFields[$tablename][$flag][] = $sfs['field'] . '_accuracy';
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            if (isset($structUnit['structure']['Sfs'])) {
                $structure['Sfs'] = array_merge($structUnit['structure']['Sfs'], $structure['Sfs']);
                $structure['Structure'][] = $structUnit['structure']['Structure'];
                $structure['Accuracy'] = array_merge_recursive($structUnit['structure']['Accuracy'], $structure['Accuracy']);
                $structure['Structure']['CodingIcdCheck'] = $structUnit['structure']['Structure']['CodingIcdCheck'];
            }

            if (isset($structUnit['structure']['Sfs']) && is_array($structUnit['structure']['Sfs'])) {
                App::uses('StructureValueDomain', 'Model');
                $this->StructureValueDomain = new StructureValueDomain();
                foreach ($structUnit['structure']['Sfs'] as $sfs) {
                    if (!empty($sfs['StructureValueDomain'])) {
                        $dropdownResult = array('defined' => array(""=>""), 'previously_defined' => array());
                        $this->StructureValueDomain->updateDropdownResult($sfs['StructureValueDomain'], $dropdownResult);
                        foreach ($dropdownResult['defined'] as $key => $value) {
                            AppModel::$listValues[$sfs['model']][$sfs['field'] . "||" . $sfs['language_label']][$key] = $value;
                        }
                    }
                }
            }
        }
        if (!empty($validationErrors)){
            foreach ($models as $modelName => $model) {
                if ($modelName != "FunctionManagement"){
                    foreach ($validationErrors as $field => $errorMessage){
                        $this->controller->{ $modelName }->notBlankFields["FunctionManagement"][$field] = $errorMessage;
                    }
                }
            }
        }
        
        foreach ($allStructures as &$structUnit) {
            if (isset($structUnit['rules']) && is_array($structUnit['rules'])) {
                foreach ($structUnit['rules'] as $model => $rules) {
                    // rules are formatted, apply them
                    $this->controller->{ $model }->validate = array_merge($this->controller->{ $model }->validate, $rules);
                }
            }
        }
        
        if (count($alias) > 1) {
            self::sortStructure($structure);
        } elseif (count($structure['Structure']) == 1) {
            $structure['Structure'] = $structure['Structure'][0];
        }
        $structureName = Inflector::variable($structureName);
        // $structureName = AppController::snakeToCamel($structureName);
        $this->controller->set($structureName, $structure);
    }

    /**
     * Stores data into model accuracy_config.
     * Will be used for validation. Stores the same data into the structure.
     *
     * @param array $structure
     */
    private function updateAccuracyChecks(&$structure)
    {
        $structure['Accuracy'] = array();
        foreach ($structure['Sfs'] as &$field) {
            if (($field['type'] == 'date' || $field['type'] == 'datetime')) {
                $tablename = null;
                $model = AppModel::getInstance($field['plugin'], $field['model'], false);
                if ($model === false) {
                    continue;
                }
                if (empty($model->_schema)) {
                    $model->schema();
                }
                $schema = $model->_schema;
                if ($model !== false && ! empty($schema) && ($field['tablename'] == $model->table || empty($field['tablename']))) {
                    $tablename = $model->table;
                } elseif (! empty($field['tablename'])) {
                    $model = new AppModel(array(
                        'table' => $field['tablename'],
                        'name' => $field['model'],
                        'alias' => $field['model']
                    ));
                    $tablename = $field['tablename'];
                }
                
                if ($tablename != null) {
                    if (! array_key_exists($tablename, AppModel::$accuracyConfig)) {
                        $model->buildAccuracyConfig();
                    }
                    if (isset(AppModel::$accuracyConfig[$tablename][$field['field']])) {
                        $structure['Accuracy'][$field['model']][$field['field']] = $field['field'] . '_accuracy';
                    }
                } elseif ($field['model'] != 'custom' && Configure::read('debug') > 0) {
                    AppController::addWarningMsg('Cannot load model for field with id ' . $field['structure_field_id'] . '. Check field tablename.', true);
                }
            }
        }
    }

    /**
     *
     * @param null $mode
     * @param null $alias
     * @return array|mixed
     */
    public function get($mode = null, $alias = null)
    {
        $result = array(
            'structure' => array(
                'Structure' => array(),
                'Sfs' => array()
            ),
            'rules' => array()
        );
        if (! is_array($alias)) {
            $alias = explode(",", $alias);
        }
        
        foreach ($alias as $aliasUnit) {
            if (! empty($aliasUnit)) {
                $tmp = $this->getSingleStructure($aliasUnit);
                $result['structure']['Sfs'] = array_merge($tmp['structure']['Sfs'], $result['structure']['Sfs']);
                $result['structure']['Structure'][] = $tmp['structure']['Structure'];
                $result['rules'] = array_merge($tmp['rules'], $result['rules']);
            }
        }
        if (count($alias) > 1) {
            self::sortStructure($result['structure']);
        } elseif (count($result['structure']['Structure']) == 1) {
            $result['structure']['Structure'] = $result['structure']['Structure'][0];
        }
        if ($mode == 'rule' || $mode == 'rules') {
            $result = $result['rules'];
        } elseif ($mode == 'form') {
            if (isset($result['structure']['Sfs'])) {
                foreach ($result['structure']['Sfs'] as $sfs) {
                    $tablename = $sfs['tablename'];
                    if ($tablename) {
                        foreach (array(
                            'add',
                            'edit',
                            'addgrid',
                            'editgrid',
                            'batchedit'
                        ) as $flag) {
                            if ($sfs['flag_' . $flag] && ! $sfs['flag_' . $flag . '_readonly'] && $sfs['type'] != 'hidden') {
                                AppModel::$writableFields[$tablename][$flag][] = $sfs['field'];
                                if ($sfs['type'] == 'date' || $sfs['type'] == 'datetime') {
                                    AppModel::$writableFields[$tablename][$flag][] = $sfs['field'] . '_accuracy';
                                }
                            }
                        }
                    }
                }
            }
            $result = $result['structure'];
        }
        
        $this->updateAccuracyChecks($result);
        return $result;
    }

    /**
     *
     * @param null $alias
     * @return array|bool|mixed
     */
    public function getSingleStructure($alias = null)
    {
        $return = array();
        $alias = $alias ? trim(strtolower($alias)) : str_replace('_', '', $this->controller->params['controller']);
        $cacheAlias = $alias . md5($alias); // cake alters the alias so we need to still make it unique
        
        $return = Cache::read($cacheAlias, "structures");
        if ($return === null) {
            $return = false;
            if (Configure::read('debug') == 2) {
                AppController::addWarningMsg('Structure caching issue. (null)', true);
            }
        }
        if (! $return) {
            if ($alias) {
                App::uses('Structure', 'Model');
                $this->ComponentStructure = new Structure();
                
                $result = $this->ComponentStructure->find('first', array(
                    'conditions' => array(
                        'Structure.alias' => $alias
                    ),
                    'recursive' => 5
                ));
                
                if ($result) {
                    $return = $result;
                }
            }
            
            if (Configure::read('debug') == 0) {
                Cache::write($cacheAlias, $return, "structures");
            }
        }
        
        // CodingIcd magic, import every model required for that structure
        if (isset($return['structure']['Sfs'])) {
            foreach (AppModel::getMagicCodingIcdTriggerArray() as $key => $trigger) {
                foreach ($return['structure']['Sfs'] as $sfs) {
                    if (strpos($sfs['setting'], $trigger) !== false) {
                        AppModel::getInstance('CodingIcd', $key, true);
                        $return['structure']['Structure']['CodingIcdCheck'] = true;
                        break;
                    }
                }
                if (! isset($return['structure']['Structure']['CodingIcdCheck'])) {
                    $return['structure']['Structure']['CodingIcdCheck'] = false;
                }
            }
            $this->updateAccuracyChecks($return['structure']);
        }
        
        // seek file fields
        foreach ($return as $structure) {
            if (! isset($structure['Sfs'])) {
                continue;
            }
            foreach ($structure['Sfs'] as $field) {
                if ($field['type'] == 'file') {
                    $prefix = $field['model'] . '.' . $field['field'];
                    $this->controller->allowedFilePrefixes[$prefix] = null;
                }
            }
        }
        
        return $return;
    }

    /**
     * Sorts a structure based on display_column and display_order.
     *
     * @param array $atimStructure
     */
    public static function sortStructure(&$atimStructure)
    {
        if (count($atimStructure['Sfs'])) {
            // Sort the data with ORDER descending, FIELD ascending
            foreach ($atimStructure['Sfs'] as $key => $row) {
                $sortOrder0[$key] = $row['flag_float'];
                $sortOrder1[$key] = $row['display_column'];
                $sortOrder2[$key] = $row['display_order'];
                $sortOrder3[$key] = $row['model'];
            }
            
            // multisort, PHP array
            array_multisort($sortOrder0, SORT_DESC, $sortOrder1, SORT_ASC, $sortOrder2, SORT_ASC, $sortOrder3, SORT_ASC, $atimStructure['Sfs']);
        }
    }

    /**
     *
     * @param null $atimStructure
     * @param bool $autoAccuracy
     * @return array
     */
    public function parseSearchConditions($atimStructure = null, $autoAccuracy = true)
    {
        // conditions to ultimately return
        $conditions = array();
        
        // general search format, after parsing STRUCTURE
        $formFields = array();
        $accuracyFields = array();
        
        // if no STRUCTURE provided, try and get one
        if ($atimStructure === null) {
            $atimStructure = $this->getSingleStructure();
            $atimStructure = $atimStructure['structure'];
        }
        
        // format structure data into SEARCH CONDITONS format
        if (isset($atimStructure['Sfs'])) {
            $cantReadConfidential = ! AppController::getInstance()->Session->read('flag_show_confidential');
            foreach ($atimStructure['Sfs'] as $value) {
                if (! $value['flag_search'] || ($value['flag_confidential'] && $cantReadConfidential)) {
                    // don't waste cpu cycles on non search parameters
                    continue;
                }
                
                // for RANGE values, which should be searched over with a RANGE...
                // it includes numbers, dates, and fields fith the "range" setting. For the later, value _start
                $formFieldsKey = $value['model'] . '.' . $value['field'];
                $valueType = $value['type'];
                $isFloat = in_array($value['type'], array(
                    'float',
                    'float_positive'
                ));
                
                if ((in_array($valueType, self::$rangeTypes) || strpos($value['setting'], "range") !== false) && isset($this->controller->data[$value['model']][$value['field'] . '_start'])) {
                    $keyStart = $formFieldsKey . '_start';
                    $formFields[$keyStart]['plugin'] = $value['plugin'];
                    $formFields[$keyStart]['model'] = $value['model'];
                    $formFields[$keyStart]['field'] = $value['field'];
                    $formFields[$keyStart]['key'] = $formFieldsKey . ' >=';
                    $formFields[$keyStart]['is_float'] = $isFloat;
                    $formFields[$keyStart]['tablename'] = $value['tablename'];
                    
                    $keyEnd = $formFieldsKey . '_end';
                    $formFields[$keyEnd]['plugin'] = $value['plugin'];
                    $formFields[$keyEnd]['model'] = $value['model'];
                    $formFields[$keyEnd]['field'] = $value['field'];
                    $formFields[$keyEnd]['key'] = $formFieldsKey . ' <=';
                    $formFields[$keyEnd]['is_float'] = $isFloat;
                    $formFields[$keyEnd]['tablename'] = $value['tablename'];
                    
                    if (isset($atimStructure['Accuracy'][$value['model']][$value['field']])) {
                        $accuracyFields[] = $keyStart;
                        $accuracyFields[] = $keyEnd;
                        $formFields[$keyStart . '_accuracy']['key'] = $formFieldsKey . '_accuracy';
                        $formFields[$keyEnd . '_accuracy']['key'] = $formFieldsKey . '_accuracy';
                    }
                } elseif (in_array($valueType, self::$rangeTypes)) {
                    $formFields[$formFieldsKey]['plugin'] = $value['plugin'];
                    $formFields[$formFieldsKey]['model'] = $value['model'];
                    $formFields[$formFieldsKey]['field'] = $value['field'];
                    $formFields[$formFieldsKey]['key'] = $formFieldsKey . ' =';
                    $formFields[$formFieldsKey]['is_float'] = $isFloat;
                    $formFields[$formFieldsKey]['tablename'] = $value['tablename'];
                } else {
                    $formFields[$formFieldsKey]['plugin'] = $value['plugin'];
                    $formFields[$formFieldsKey]['model'] = $value['model'];
                    $formFields[$formFieldsKey]['field'] = $value['field'];
                    $formFields[$formFieldsKey]['tablename'] = $value['tablename'];
                    
                    if ($valueType == 'select' || isset($this->controller->data['exact_search'])) {
                        // for SELECT pulldowns, where an EXACT match is required, OR passed in DATA is an array to use the IN SQL keyword
                        $formFields[$formFieldsKey]['key'] = $value['model'] . '.' . $value['field'];
                    } else {
                        // all other types, a generic SQL fragment...
                        $formFields[$formFieldsKey]['key'] = $formFieldsKey . ' LIKE';
                    }
                    
                    $formFields[$formFieldsKey]['is_float'] = $isFloat;
                }
                
                // CocingIcd magic
                $icdCheck = isset($atimStructure['Structure']['CodingIcdCheck']) && $atimStructure['Structure']['CodingIcdCheck'];
                reset($atimStructure['Structure']);
                if (! $icdCheck && is_array(current($atimStructure['Structure']))) {
                    // might be a structure with sub structures
                    foreach ($atimStructure['Structure'] as $subStructure) {
                        if ($subStructure['CodingIcdCheck']) {
                            $icdCheck = true;
                            break;
                        }
                    }
                }
                if ($icdCheck) {
                    foreach (AppModel::getMagicCodingIcdTriggerArray() as $key => $settingLookup) {
                        if (strpos($value['setting'], $settingLookup) !== false) {
                            $formFields[$formFieldsKey]['cast_icd'] = $key;
                            if (strpos($formFields[$formFieldsKey]['key'], " LIKE") !== false) {
                                $formFields[$formFieldsKey]['key'] = str_replace(" LIKE", "", $formFields[$formFieldsKey]['key']);
                                $formFields[$formFieldsKey]['exact'] = false;
                            } else {
                                $formFields[$formFieldsKey]['exact'] = true;
                            }
                            break;
                        }
                    }
                }
            }
        }
        
        App::uses('Sanitize', 'Utility');
        
        // parse DATA to generate SQL conditions
        // use ONLY the form_fields array values IF data for that MODEL.KEY combo was provided
        $plugin = $this->controller->request->params['plugin'];
        $controller = $this->controller->request->params['controller'];
        $action = $this->controller->request->params['action'];
        $param = (isset($this->controller->request->params['pass'][1])) ? $this->controller->request->params['pass'][1] : "";
        if (empty($param)) {
            $_SESSION['post_data'][$plugin][$controller][$action] = removeEmptySubArray($this->controller->data);
        } else {
            $_SESSION['post_data'][$plugin][$controller][$action][$param] = removeEmptySubArray($this->controller->data);
        }
        
        foreach ($this->controller->data as $model => $fields) {
            if (is_array($fields)) {
                foreach ($fields as $key => $data) {
                    $key = str_replace("_with_file_upload", "", $key);
                    $formFieldsKey = $model . '.' . $key;
                    // if MODEL data was passed to this function, use it to generate SQL criteria...
                    if (count($formFields)) {
                        // add search element to CONDITIONS array if not blank & MODEL data included Model/Field info...
                        if ((! empty($data) || $data == "0") && isset($formFields[$formFieldsKey])) {
                            // if CSV file uploaded...
                            if (is_array($data) && isset($this->controller->data[$model][$key . '_with_file_upload']) && $this->controller->data[$model][$key . '_with_file_upload']['tmp_name']) {
                                if (! preg_match('/((\.txt)|(\.csv))$/', $this->controller->data[$model][$key . '_with_file_upload']['name'])) {
                                    $this->controller->redirect('/Pages/err_submitted_file_extension', null, true);
                                } else {
                                    $filename = $this->controller->data[$model][$key . '_with_file_upload']['tmp_name'];
                                    $fileContents = file_get_contents($filename);
                                    $fileContents = preg_replace('/(\x00|\xFE|\xFF)/', '', $fileContents);
                                    file_put_contents($filename, $fileContents);

                                    // set $DATA array based on contents of uploaded FILE
                                    $handle = fopen($this->controller->data[$model][$key . '_with_file_upload']['tmp_name'], "r");
                                    if ($handle) {
                                        unset($data['name'], $data['type'], $data['tmp_name'], $data['error'], $data['size']);
                                        // in each LINE, get FIRST csv value, and attach to DATA array
                                        while (($csvData = fgetcsv($handle, 1000, CSV_SEPARATOR, '"')) !== false) {
                                            if (isset($csvData[0])){
                                                $data[] = $csvData[0];
                                            }
                                        }
                                        fclose($handle);
                                    } else {
                                        $this->controller->redirect('/Pages/err_opening_submitted_file', null, true);
                                    }
                                }
                                $tmpControlerData = $this->controller->data;
                                unset($tmpControlerData[$model][$key . '_with_file_upload']);
                                $this->controller->data = $tmpControlerData;
                            }
                            
                            // use Model->deconstruct method to properly build data array's date/time information from arrays
                            if (is_array($data) && $model != "0") {
                                $formatDataModel = AppModel::getInstance($formFields[$formFieldsKey]['plugin'], $model, true);
                                
                                if ($formatDataModel->table != $formFields[$formFieldsKey]['tablename'] && strpos($model, 'Detail') !== false) {
                                    // reload the model with the proper table if it's a detail model
                                    if (! empty($formFields[$formFieldsKey]['tablename'])) {
                                        $modelName = $formatDataModel->name;
                                        ClassRegistry::removeObject($modelName); // flush the old detail from cache, we'll need to reinstance it
                                        $formatDataModel = new AppModel(array(
                                            'table' => $formFields[$formFieldsKey]['tablename'],
                                            'name' => $modelName,
                                            'alias' => $modelName
                                        ));
                                    } elseif (Configure::read('debug') > 0) {
                                        AppController::addWarningMsg('There is no tablename for field [' . $formFields[$formFieldsKey]['key'] . ']', true);
                                    }
                                }
                                
                                $data = $formatDataModel->deconstruct($formFields[$formFieldsKey]['field'], $data, strpos($key, "_end") == strlen($key) - 4, true);
                                if (is_array($data)) {
                                    $data = array_unique($data);
                                    $data = array_filter($data, "StructuresComponent::myFilter");
                                }
                                
                                if (! count($data)) {
                                    $data = '';
                                }
                            }
                            
                            // if supplied form DATA is not blank/null, add to search conditions, otherwise skip
                            if ($data || $data == "0") {
                                
                                if (isset($formFields[$formFieldsKey]['cast_icd'])) {
                                    // special magical icd case
                                    eval('$instance = ' . $formFields[$formFieldsKey]['cast_icd'] . '::getSingleton();');
                                    $data = $instance->getCastedSearchParams($data, $formFields[$formFieldsKey]['exact']);
                                } elseif (strpos($formFields[$formFieldsKey]['key'], ' LIKE') !== false) {
                                    if (is_array($data)) {
                                        foreach ($data as &$unit) {
                                            $unit = trim(Sanitize::escape($unit));
                                        }
                                        $conditions[] = "(" . $formFields[$formFieldsKey]['key'] . " '%" . implode("%' OR " . $formFields[$formFieldsKey]['key'] . " '%", $data) . "%')";
                                        unset($data);
                                    } else {
                                        $data = '%' . trim(Sanitize::escape($data)) . '%';
                                    }
                                }
                                
                                if (isset($data)) {
                                    if ($autoAccuracy && in_array($formFieldsKey, $accuracyFields)) {
                                        // accuracy treatment
                                        $tmpCond = array();
                                        $tmpCond[] = array(
                                            $formFields[$formFieldsKey]['key'] => $data,
                                            $formFields[$formFieldsKey . '_accuracy']['key'] => array(
                                                'c',
                                                ' '
                                            )
                                        );
                                        if (strpos($data, " ") !== false) {
                                            // datetime
                                            list ($data, $time) = explode(" ", $data);
                                            list ($hour) = explode(":", $time);
                                            $tmpCond[] = array(
                                                $formFields[$formFieldsKey]['key'] => sprintf("%s %s:00:00", $data, $hour),
                                                $formFields[$formFieldsKey . '_accuracy']['key'] => 'i'
                                            );
                                            $tmpCond[] = array(
                                                $formFields[$formFieldsKey]['key'] => $data . " 00:00:00",
                                                $formFields[$formFieldsKey . '_accuracy']['key'] => 'h'
                                            );
                                        }
                                        list ($year, $month) = explode("-", $data);
                                        $tmpCond[] = array(
                                            $formFields[$formFieldsKey]['key'] => sprintf("%s-%s-01 00:00:00", $year, $month),
                                            $formFields[$formFieldsKey . '_accuracy']['key'] => 'd'
                                        );
                                        $tmpCond[] = array(
                                            $formFields[$formFieldsKey]['key'] => sprintf("%s-01-01 00:00:00", $year),
                                            $formFields[$formFieldsKey . '_accuracy']['key'] => array(
                                                'm',
                                                'y'
                                            )
                                        );
                                        $conditions[] = array(
                                            "OR" => $tmpCond
                                        );
                                    } else {
                                        if (is_array($data)) {
                                            foreach ($data as &$unit)
                                                if (is_string($unit))
                                                    $unit = trim($unit);
                                        } elseif (is_string($data)) {
                                            $data = trim($data);
                                        }
                                        $conditions[$formFields[$formFieldsKey]['key']] = $formFields[$formFieldsKey]['is_float'] ? str_replace(',', '.', $data) : $data;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        return $conditions;
    }

    /**
     *
     * @param $val
     * @return bool
     */
    public static function myFilter($val)
    {
        return strlen($val) > 0;
    }

    /**
     *
     * @param null $sql
     * @param null $conditions
     * @return array
     */
    public function parseSqlConditions($sql = null, $conditions = null)
    {
        $sqlWithSearchTerms = $sql;
        $sqlWithoutSearchTerms = $sql;
        if ($conditions === null) {
            foreach ($this->controller->data as $model => $modelValue) {
                foreach ($modelValue as $field => $fieldValue) {
                    if (is_array($fieldValue)) {
                        foreach ($fieldValue as $k => $v) {
                            $fieldValue[$k] = '"' . $v . '"';
                        }
                        $fieldValue = implode(',', $fieldValue);
                    }
                    $sqlWithSearchTerms = str_replace('@@' . $model . '.' . $field . '@@', $fieldValue, $sqlWithSearchTerms);
                    $sqlWithoutSearchTerms = str_replace('@@' . $model . '.' . $field . '@@', '', $sqlWithoutSearchTerms);
                }
            }
        } else {
            // the conditions array is splitted in 3 types
            // 1-[model.field] = value -> replace in the query @@value@@ by value (usually a _start, _end). Convert as 2B
            // 2-[model.field] = array(values) -> it's from a dropdown or it an exact search
            // A-replace ='@@value@@' by IN(values)
            // B-copy model model.field {>|<|<=|>=} @@value@@ for every values
            // 3-[integer] = string of the form "model.field LIKE '%value1%' OR model.field LIKE '%value2%' ..."
            // A-if the query is model.field = ... then use the like form.
            // B-else (the query is model.field {>|<|<=|>=}) do as 2B
            $warningLike = false;
            $warningIn = false;
            $tests = array();
            foreach ($conditions as $strToReplace => $condition) {
                if (is_numeric($strToReplace)) {
                    unset($conditions[$strToReplace]);
                    $condition = substr($condition, 1, - 1); // remove the opening ( and closing )
                                                             // case 3, remove the parenthesis
                    $matches = array();
                    list ($strToReplace) = explode(" ", $condition, 2);
                    // 3A
                    preg_match_all("/[\w\.\`]+[\s]+=[\s]+\"[%]*@@" . $strToReplace . "@@[%]*\"/", $sqlWithSearchTerms, $matches, PREG_OFFSET_CAPTURE);
                    foreach ($matches as $subMatches) {
                        foreach ($subMatches as $match) {
                            $sqlWithSearchTerms = substr($sqlWithSearchTerms, 0, $match[1]) . $condition . substr($sqlWithSearchTerms, $match[1] + strlen($match[0]));
                        }
                    }
                    
                    // reformat the condition as case 2B
                    $parts = explode(" OR ", $condition);
                    $condition = array();
                    foreach ($parts as $part) {
                        list ($value) = explode(" ", $part);
                        $value = substr($value, 2, - 2); // chop opening '% and closing %'
                        $condition[] = $value;
                    }
                    $conditions[$strToReplace] = $condition;
                }
                
                if (is_array($condition)) {
                    // case 2A replace the model.field = "@@value@@" by model.field IN (values)
                    preg_match_all("/[\w\.\`]+[\s]+=[\s]+\"[%]*@@" . $strToReplace . "@@[%]*\"/", $sqlWithSearchTerms, $matches, PREG_OFFSET_CAPTURE);
                    foreach ($matches as $subMatches) {
                        foreach ($subMatches as $match) {
                            list ($modelField) = explode(" ", $match[0], 2);
                            $sqlWithSearchTerms = substr($sqlWithSearchTerms, 0, $match[1]) . $modelField . " IN ('" . implode("', '", $condition) . "') " . substr($sqlWithSearchTerms, $match[1] + strlen($match[0]));
                        }
                    }
                    // remaining replaces to perform
                    $tests = array(
                        "<",
                        "<=",
                        ">",
                        ">="
                    );
                } else {
                    // case 1, convert to case 2B
                    $condition = array(
                        $condition
                    );
                    // remaining replaces to perform
                    $tests = array(
                        "=",
                        "<",
                        "<=",
                        ">",
                        ">="
                    );
                }
                
                // CASE 2B
                foreach ($tests as $test) {
                    preg_match_all("/[\w\.\`]+[\s]+" . $test . "[\s]+\"[%]*@@" . $strToReplace . "@@[%]*\"/", $sqlWithSearchTerms, $matches, PREG_OFFSET_CAPTURE);
                    foreach ($matches as $subMatches) {
                        foreach ($subMatches as $match) {
                            list ($modelField) = explode(" ", $match[0], 2);
                            $formatedCondition = "(" . $modelField . " " . $test . " '" . implode(" OR " . $modelField . " " . $test . " '", $condition) . "')";
                            $sqlWithSearchTerms = substr($sqlWithSearchTerms, 0, $match[1]) . $formatedCondition . substr($sqlWithSearchTerms, $match[1] + strlen($match[0]));
                        }
                    }
                }
                
                // LIKE
                $matches = array();
                preg_match_all("/[\w\.\`]+[\s]+LIKE[\s]+\"[%]*@@" . $strToReplace . "@@[%]*\"/", $sqlWithSearchTerms, $matches, PREG_OFFSET_CAPTURE);
                if (! empty($matches[0]) && ! $warningLike) {
                    $warningLike = true;
                    AppController::addWarningMsg(__("this query is using the LIKE keyword which goes against the ad hoc queries rules"));
                }
                // IN
                $matches = array();
                preg_match_all("/[\w\.\`]+[\s]+IN[\s]+\([\s]*@@" . $strToReplace . "@@[\s]*\)/", $sqlWithSearchTerms, $matches, PREG_OFFSET_CAPTURE);
                if (! empty($matches[0]) && ! $warningIn) {
                    $warningIn = true;
                    AppController::addWarningMsg(__("this query is using the IN keyword which goes against the ad hoc queries rules"));
                }
            }
        }
        
        // whipe what wasn't replaced
        // >, <, <=, >=, =
        $sqlWithSearchTerms = preg_replace('/[\w\.\`]+[\s]+(\>|\<|\>\=|\<\=|\=)\s*"@@[\w\.]+@@"/i', "TRUE", $sqlWithSearchTerms);
        $sqlWithoutSearchTerms = preg_replace('/[\w\.\`]+[\s]+(\>|\<|\>\=|\<\=|\=)\s*"@@[\w\.]+@@"/i', "TRUE", $sqlWithoutSearchTerms);
        
        // LIKE
        $sqlWithSearchTerms = preg_replace('/[\w\.\`]+[\s]+LIKE\s*"[%]*@@[\w\.]+@@[%]*"/i', "TRUE", $sqlWithSearchTerms);
        $sqlWithoutSearchTerms = preg_replace('/[\w\.\`]+[\s]+LIKE\s*"[%]*@@[\w\.]+@@[%]*"/i', "TRUE", $sqlWithoutSearchTerms);
        
        // IN
        $sqlWithSearchTerms = preg_replace('/[\w\.\`]+[\s]+IN\s*\([\s]*@@[\w\.]+@@[\s]*\)/i', 'TRUE', $sqlWithSearchTerms);
        $sqlWithoutSearchTerms = preg_replace('/[\w\.\`]+[\s]+IN\s*\([\s]*@@[\w\.]+@@[\s]*\)/i', 'TRUE', $sqlWithoutSearchTerms);
        
        // remove TRUE
        $sqlWithSearchTerms = preg_replace('/(AND|OR) TRUE/i', "", $sqlWithSearchTerms);
        $sqlWithoutSearchTerms = preg_replace('/(AND|OR) TRUE/i', "", $sqlWithoutSearchTerms);
        
        // return BOTH
        return array(
            $sqlWithSearchTerms,
            $sqlWithoutSearchTerms
        );
    }

    /**
     *
     * @param $id
     * @return mixed
     */
    public function getFormById($id)
    {
        if (! isset($this->ComponentStructure)) {
            // when debug is off, Component_Structure is not initialized
            App::uses('Structure', 'Model');
            $this->ComponentStructure = new Structure();
        }
        $data = $this->ComponentStructure->find('first', array(
            'conditions' => array(
                'Structure.id' => $id
            ),
            'recursive' => - 1
        ));
        $tmp = $this->getSingleStructure($data['structure']['Structure']['alias']);
        return $tmp['structure'];
    }

    /**
     * Retrieves pulldown values from a specified source.
     * The source needs to have translated already
     *
     * @param unknown_type $source
     * @return array
     */
    public static function getPulldownFromSource($source)
    {
        // Get arguments
        $args = null;
        preg_match('(\(\'.*\'\))', $source, $matches);
        if ((sizeof($matches) == 1)) {
            // Args are included into the source
            $args = explode("','", substr($matches[0], 2, (strlen($matches[0]) - 4)));
            $source = str_replace($matches[0], '', $source);
        }
        
        list ($pulldownModel, $pulldownFunction) = explode('::', $source);
        $pulldownPlugin = null;
        if (strpos($pulldownModel, '.') !== false) {
            $combinedPluginModelName = $pulldownModel;
            list ($pulldownPlugin, $pulldownModel) = explode('.', $combinedPluginModelName);
        }
        
        $pulldownResult = array();
        if ($pulldownModel && ($pulldownModelObject = AppModel::getInstance($pulldownPlugin, $pulldownModel, true))) {
            // run model::function
            $pulldownResult = $pulldownModelObject->{$pulldownFunction}($args);
        }
        
        return $pulldownResult;
    }
}