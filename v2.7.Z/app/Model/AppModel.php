<?php
/**
 * Application model for CakePHP.
 *
 * This file is application-wide model file. You can put all
 * application-wide model-related methods here.
 *
 * CakePHP(tm) : Rapid Development Framework (http://cakephp.org)
 * Copyright (c) Cake Software Foundation, Inc. (http://cakefoundation.org)
 *
 * Licensed under The MIT License
 * For full copyright and license information, please see the LICENSE.txt
 * Redistributions of files must retain the above copyright notice.
 *
 * @copyright Copyright (c) Cake Software Foundation, Inc. (http://cakefoundation.org)
 * @link http://cakephp.org CakePHP(tm) Project
 * @package app.Model
 * @since CakePHP(tm) v 0.2.9
 * @license MIT License (http://www.opensource.org/licenses/mit-license.php)
 */
App::uses('Model', 'Model');

/**
 * Application model for Cake.
 *
 * Add your application-wide methods in the class below, your models
 * will inherit them.
 *
 * @package app.Model
 */
class AppModel extends Model
{

    public $actsAs = array(
        'Revision',
        'SoftDeletable',
        'MasterDetail'
    );
    
    // It's important that MasterDetail be after Revision
    public static $autoValidation = null;
    
    // Validation for all models based on the table field length for char/varchar
    public static $accuracyConfig = array();
    
    // tablename -> accuracy fields
    public static $writableFields = array();

    public static $listValues;
    
    public static $requiredFields = array();
    public $notBlankFields=array();

    // tablename -> flag suffix -> fields
    public $checkWritableFields = true;
    
    // whether to check writable fields or not (security check)
    public $writableFieldsMode = null;
    
    // add, edit, addgrid, editgrid, batchedit
    
    // The values in this array can trigger magic actions when applied to a field settings
    private static $magicCodingIcdTriggerArray = array(
        "CodingIcd10Who" => "/CodingIcd/CodingIcd10s/tool/who",
        "CodingIcd10Ca" => "/CodingIcd/CodingIcd10s/tool/ca",
        "CodingIcdo3Morpho" => "/CodingIcd/CodingIcdo3s/tool/morpho",
        "CodingIcdo3Topo" => "/CodingIcd/CodingIcdo3s/tool/topo"
    );

    public $pkeySafeguard = true;
    
    // whether to prevent data to be saved if the data array contains a pkey different than model->id
    private $registeredModels;
    
    // use related to views
    
    /**
     * Used to store the previous model when a model is recreated for detail search
     *
     * @var SampleMaster
     */
    public $previousModel = null;

    private static $lockedViewsUpdate = false;

    private static $cachedViewsUpdate = array();

    private static $cachedViewsDelete = array();

    private static $cachedViewsInsert = array();

    private static $cachedViewsModel = null;
    
    // some model, only provides accc
    const ACCURACY_REPLACE_STR = '%5$s(IF(%2$s = "c", %1$s, IF(%2$s = "d", CONCAT(SUBSTR(%1$s, 1, 7), %3$s), IF(%2$s = "m", CONCAT(SUBSTR(%1$s, 1, 4), %3$s), IF(%2$s = "y", CONCAT(SUBSTR(%1$s, 1, 4), %4$s), IF(%2$s = "h", CONCAT(SUBSTR(%1$s, 1, 10), %3$s), IF(%2$s = "i", CONCAT(SUBSTR(%1$s, 1, 13), %3$s), %1$s)))))))';

    /**
     * If $baseModelName and $detailTable are not null, a new hasOne relationship is created before calling the parent constructor.
     * This is convenient for search based on master/detail detail table.
     *
     * @param bool|unknown_type $id (see parent::__construct)
     * @param unknown_type $table (see parent::__construct)
     * @param unknown_type $ds (see parent::__construct)
     * @param string $baseModelName The base model name of a master/detail model
     * @param string $detailTable The name of the table to use for detail
     * @param AppModel $previousModel The previous model prior to that new creation (purely for convenience)
     * @see parent::__construct
     */
    public function __construct($id = false, $table = null, $ds = null, $baseModelName = null, $detailTable = null, $previousModel = null)
    {
        if ($detailTable != null && $baseModelName != null) {
            $this->hasOne[$baseModelName . 'Detail'] = array(
                'className' => $detailTable,
                'foreignKey' => strtolower($baseModelName) . '_master_id',
                'dependent' => true
            );
            if ($previousModel != null) {
                $this->previousModel = $previousModel;
            }
        }
        parent::__construct($id, $table, $ds);
    }

    /**
     * Finds the uploaded files from the $data array.
     * Update the $data array
     * with the name the stored file will have and returns the $modeFiles
     * directive array to
     *
     * @param $data
     * @return array
     */
    private function filterMoveFiles(&$data)
    {
        $moveFiles = array();
        if (! is_array($data)) {
            return $moveFiles;
        }
        // Keep data in memory to fix issue #3286: Unable to edit and save collection date when field 'acquisition_label' is hidden
        $thisDataTmpBackup = $this->data;
        
        $validationErrors = $this->validationErrors;
        $prevData = $this->id ? $this->read() : null;
        $this->validationErrors = $validationErrors;
        $dir = Configure::read('uploadDirectory');
        foreach ($data as $modelName => $fields) {
            if (! is_array($fields)) {
                continue;
            }
            foreach ($fields as $fieldName => $value) {
                if (is_array($value)) {
                    if (isset($value['option']) && in_array($value['option'], array(
                        'delete',
                        'replace'
                    ))) {
                        if ($prevData[$modelName][$fieldName]) {
                            // delete previous file
                            $ifDelete = Configure::read('deleteUploadedFilePhysically');
                            if (! $ifDelete) {
                                $deleteDirectory = $dir . DS . Configure::read('deleteDirectory');
                                if (! is_dir($deleteDirectory)) {
                                    mkdir($deleteDirectory);
                                }
                                if (file_exists($dir . DS . $prevData[$modelName][$fieldName])) {
                                    copy($dir . DS . $prevData[$modelName][$fieldName], $deleteDirectory . DS . $prevData[$modelName][$fieldName]);
                                }
                            }
                            if (file_exists($dir . '/' . $prevData[$modelName][$fieldName])) {
                                unlink($dir . '/' . $prevData[$modelName][$fieldName]);
                            }
                        }
                    }
                    if (isset($value['name'])) {
                        if (! $value['size']) {
                            // no file
                            $data[$modelName][$fieldName] = $value['name'];
                            continue;
                        }
                        $maxUploadFileSize = Configure::read('maxUploadFileSize');
                        if ($value['size'] > $maxUploadFileSize) {
                            $this->validationErrors = array_merge($this->validationErrors, array(
                                'size' => array(
                                    __('the file size should be less than %d bytes', Configure::read('maxUploadFileSize'))
                                )
                            ));
                            if (file_exists($value['tmp_name'])) {
                                unlink($value['tmp_name']);
                            }
                            if ($prevData[$modelName][$fieldName]) {
                                $data[$modelName][$fieldName] = $prevData[$modelName][$fieldName];
                            } else {
                                $data[$modelName][$fieldName] = null;
                            }
                            return null;
                        }
                        if (! file_exists($value['tmp_name'])) {
                            die('Error with temporary file');
                        }
                        $targetName = $modelName . '.' . $fieldName . '.%%key_increment%%.' . $value['name'];
                        
                        $targetName = $this->getKeyIncrement('atim_internal_file', $targetName);
                        array_push($moveFiles, array(
                            'tmpName' => $value['tmp_name'],
                            'targetName' => $targetName
                        ));
                        $data[$modelName][$fieldName] = $targetName;
                    } elseif (isset($value['option'])) {
                        if (in_array($value['option'], array(
                            'delete',
                            'replace'
                        )) && $prevData[$modelName][$fieldName]) {
                            $data[$modelName][$fieldName] = '';
                            // unlink($dir . '/' . $prevData[$modelName][$fieldName]);
                        } else {
                            unset($data[$modelName][$fieldName]);
                        }
                    }
                }
            }
        }
        
        // Reset data to fix issue #3286: Unable to edit and save collection date when field 'acquisition_label' is hidden
        $this->data = $thisDataTmpBackup;
        
        return $moveFiles;
    }

    /**
     * Takes the move_files array returned by filter_move_files and moves the
     * uploaded files to the configured directory with the set file name.
     *
     * @param $moveFiles
     */
    private function moveFiles($moveFiles)
    {
        if ($moveFiles) {
            // make sure directory exists
            $dir = Configure::read('uploadDirectory');
            if (! is_dir($dir)) {
                mkdir($dir);
            }
            foreach ($moveFiles as $moveFile) {
                $newName = $dir . '/' . $moveFile['targetName'];
                move_uploaded_file($moveFile['tmpName'], $newName);
            }
        }
    }

    private function checkRequiredFields($data)
    {
        $conditions = array();
        if (empty($this->id)){
            foreach (self::$requiredFields as $modelALias => $rules) {
                $fields = array();
                foreach ($rules as $field => $rule) {
                    $fields[] = $field;
                }
                $conditions[] = array(
                    "model" => explode("||", $modelALias)[0],
                    "structure_alias" => explode("||", $modelALias)[1],
                    "field" => $fields
                );
            }
            
            if (!empty($conditions)){
                App::uses('Sfs', 'Model');
                $Sfs = new Sfs();
                $sfsData = $Sfs->find("all", array(
                    "conditions" => array('OR' => $conditions)
                ));
                if (!empty($sfsData)){
                    foreach ($sfsData as $sfs) {
                        $alias = strtolower($sfs["Sfs"]["structure_alias"]);
                        $model = $sfs["Sfs"]["model"];
                        $field = $sfs["Sfs"]["field"];
                        $type = isset($_SESSION["aliases"][$alias]["type"])?$_SESSION["aliases"][$alias]["type"]:"";
                        if (!empty($alias) && !empty($type)){
                            $flag = isset($sfs["Sfs"]["flag_" . $type])?$sfs["Sfs"]["flag_" . $type]:1;
                            if (empty($flag)){
                                unset(self::$requiredFields["{$model}||{$alias}"]["{$field}"]);
                            }
                            
                        }
                    }
                }
            }
            foreach (self::$requiredFields as $modelALias => $rules) {
                $model = explode("||", $modelALias)[0];
                $alias = explode("||", $modelALias)[1];
                foreach ($rules as $field => $rule) {
                    if ($this->name == $model || $model == 'FunctionManagement'){
                        if (isset($data[$model])){
                            if (!isset($data[$model][$field])){
                                $data[$model][$field] = "";
                            }
                        }else{
                            $data[$model] = array($field => "");
                        }
                    }
                }
            }
        }
        return $data;
    }
    
    /**
     * Override to prevent saving id directly with the array to avoid hacks
     *
     * @see Model::save()
     * @param null $data
     * @param bool $validate
     * @param array $fieldList
     * @return bool|mixed
     */
    public function save($data = null, $validate = true, $fieldList = array())
    {
        if ($this->pkeySafeguard && ((isset($data[$this->name][$this->primaryKey]) && $this->id != $data[$this->name][$this->primaryKey]) || (isset($data[$this->primaryKey]) && $this->id != $data[$this->primaryKey]))) {
            AppController::addWarningMsg('Pkey safeguard on model ' . $this->name, true);
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            return false;
        }
        
        if (! $validate && ! isset($data[$this->alias]['__validated__']) && ! isset($data['__validated__']) && ! isset($data[$this->alias]['deleted']) && ! isset($data['deleted']) && Configure::read('debug') > 0) {
            AppController::addWarningMsg('saving unvalidated data [' . $this->name . ']', true);
        }
        
        if ((! isset($data[$this->name]) || empty($data[$this->name])) && isset($this->Behaviors->MasterDetail->__settings[$this->name]['is_master_model']) && $this->Behaviors->MasterDetail->__settings[$this->name]['is_master_model'] && isset($data[$this->Behaviors->MasterDetail->__settings[$this->name]['detail_class']])) {
            // Eventum 2619: When there is no master data, details aren't saved
            // properly because cake core flushes them out.
            // NL Comment See notes on eventum $data[$this->name]['-'] = "foo";
            $data[$this->name]['-'] = "foo";
        }
        
        $moveFiles = $this->filterMoveFiles($data);
        $result = parent::save($data, $validate, $fieldList);
        $this->moveFiles($moveFiles);
        
        return $result;
    }

    /**
     * Checks Writable fields, sets trackability, manages floats ("," and ".")
     * and date strings.
     *
     * @param array $options
     * @return bool
     */
    public function beforeSave($options = array())
    {
        if ($this->checkWritableFields) {
            $this->checkWritableFields();
        }
        
        $this->setTrackability();
        $this->checkFloats();
        $this->registerModelsToCheck();
        
        return true;
    }

    /**
     * Removes values not found into AppModel::$writableFields[$this->table]
     * from the saved data set to prevent form hacking.
     * Will use "add" or
     * "edit" filter based on the presence (edit) or absence (add) of
     * $this->id. Use $this->writableFieldsMode to specify other modes.
     */
    private function checkWritableFields()
    {
        if (isset(AppModel::$writableFields[$this->table])) {
            $writableFields = null;
            if ($this->writableFieldsMode) {
                $writableFields = isset(AppModel::$writableFields[$this->table][$this->writableFieldsMode]) ? AppModel::$writableFields[$this->table][$this->writableFieldsMode] : array();
            } elseif ($this->id) {
                $writableFields = isset(AppModel::$writableFields[$this->table]['edit']) ? AppModel::$writableFields[$this->table]['edit'] : array();
            } else {
                $writableFields = isset(AppModel::$writableFields[$this->table]['add']) ? AppModel::$writableFields[$this->table]['add'] : array();
            }
            $writableFields[] = 'modified';
            if ($this->id) {
                $writableFields[] = $this->primaryKey;
            } else {
                $writableFields[] = 'created';
            }
            if (isset(AppModel::$writableFields[$this->table]['all'])) {
                $writableFields = array_merge(AppModel::$writableFields[$this->table]['all'], $writableFields);
            }
            if (isset(AppModel::$writableFields[$this->table]['none'])) {
                $writableFields = array_diff($writableFields, AppModel::$writableFields[$this->table]['none']);
            }
            $schemaKeys = array_keys($this->schema());
            $writableFields = array_intersect($writableFields, $schemaKeys);
            $realFields = isset($this->data[$this->name]) ? array_intersect(array_keys($this->data[$this->name]), $schemaKeys) : array();
            $invalidFields = array_diff($realFields, $writableFields);
            if (! empty($invalidFields)) {
                foreach ($invalidFields as $invalidField) {
                    unset($this->data[$this->name][$invalidField]);
                }
                if (Configure::read('debug') > 0) {
                    AppController::addWarningMsg('Non authorized fields have been removed from the data set prior to saving. (' . implode(',', $invalidFields) . ')', true);
                }
            }
        } elseif (Configure::read('debug') > 0 && isset($this->data[$this->name]) && ! empty($this->data[$this->name])) {
            AppController::addWarningMsg('No Writable fields defined for model ' . $this->name . '.', true);
            $this->data[$this->name] = array();
        }
    }

    /**
     * Sets created_by, modified_by, created and deleted fields.
     */
    private function setTrackability()
    {
        if (! isset($this->Session) || ! $this->Session) {
            if (App::import('Model', 'CakeSession')) {
                $this->Session = new CakeSession();
            }
        }
        
        if ($this->id && $this->Session) {
            // editing an existing entry with an existing session
            unset($this->data[$this->name]['created_by']);
            $this->data[$this->name]['modified_by'] = $this->Session->check('Auth.User.id') ? $this->Session->read('Auth.User.id') : 0;
        } elseif ($this->Session) {
            // creating a new entry with an existing session
            $this->data[$this->name]['created_by'] = $this->Session->check('Auth.User.id') ? $this->Session->read('Auth.User.id') : 0;
            $this->data[$this->name]['modified_by'] = $this->Session->check('Auth.User.id') ? $this->Session->read('Auth.User.id') : 0;
        } elseif ($this->id) {
            // editing an existing entry with no session
            unset($this->data[$this->name]['created_by']);
            $this->data[$this->name]['modified_by'] = 0;
        } else {
            // creating a new entry with no session
            $this->data[$this->name]['created_by'] = 0;
            $this->data[$this->name]['modified_by'] = 0;
        }
        $this->data[$this->name]['modified'] = now(); // CakePHP should do it... doens't work.
    }

    private function registerModelsToCheck()
    {
        $this->registeredModels = array();
        if ($this->registeredView && $this->id) {
            foreach ($this->registeredView as $registeredView => $foreignKeys) {
                list ($pluginName, $modelName) = explode('.', $registeredView);
                $model = AppModel::getInstance($pluginName, $modelName);
                $pkeysToCheck = array();
                $pkeysForDeletion = array();
                foreach ($foreignKeys as $foreignKey) {
                    $atLeastOne = false;
                    
                    foreach (explode("UNION ALL", $model::$tableQuery) as $queryPart) {
                        if (strpos($queryPart, $foreignKey) === false) {
                            continue;
                        }
                        $atLeastOne = true;
                        $tableQuery = str_replace('%%WHERE%%', 'AND ' . $foreignKey . '=' . $this->id, $queryPart);
                        
                        $results = $this->tryCatchQuery($tableQuery);
                        foreach ($results as $result) {
                            $pkeysForDeletion[] = current(current($result));
                            if (method_exists($model, "getPkeyAndModelToCheck")) {
                                $pkeysToCheck[] = $model->getPkeyAndModelToCheck($result);
                            } else {
                                $pkeysToCheck[] = array(
                                    'pkey' => current(current($result)),
                                    'base_model' => $model->baseModel
                                );
                            }
                        }
                    }
                    if (! $atLeastOne) {
                        throw new Exception("No queries part fitted with the foreign key " . $foreignKey);
                    }
                }
                if ($pkeysToCheck) {
                    $this->registeredModels[] = array(
                        'model' => $model,
                        'pkeys_to_check' => $pkeysToCheck,
                        'pkeys_for_deletion' => $pkeysForDeletion
                    );
                }
            }
        }
    }

    private function updateRegisteredModels()
    {
        foreach ($this->registeredModels as $registeredModel) {
            // try to find the row
            $model = $registeredModel['model'];
            if (self::$lockedViewsUpdate) {
                if (! isset(self::$cachedViewsDelete[$model->table])) {
                    self::$cachedViewsDelete[$model->table] = array();
                }
                if (! isset(self::$cachedViewsDelete[$model->table][$model->primaryKey])) {
                    self::$cachedViewsDelete[$model->table][$model->primaryKey] = array(
                        "pkeys_for_deletion" => array()
                    );
                }
                self::$cachedViewsDelete[$model->table][$model->primaryKey]["pkeys_for_deletion"] = array_merge(self::$cachedViewsDelete[$model->table][$model->primaryKey]["pkeys_for_deletion"], $registeredModel['pkeys_for_deletion']);
            } else {
                $query = sprintf('DELETE FROM %s  WHERE %s IN (%s)', $model->table, $model->primaryKey, implode(',', $registeredModel['pkeys_for_deletion'])); // To fix issue#2980: Edit Storage & View Update
                $this->tryCatchquery($query);
            }
            foreach (explode("UNION ALL", $model::$tableQuery) as $queryPart) {
                $ids = array();
                $baseModel = null;
                for ($i = count($registeredModel['pkeys_to_check']) - 1; $i >= 0; -- $i) {
                    $curr = $registeredModel['pkeys_to_check'][$i];
                    if ($baseModel == null) {
                        // find the base model, once found don't get back in here
                        if (strpos($queryPart, $curr['base_model']) !== false) {
                            $baseModel = $curr['base_model'];
                        } else {
                            continue;
                        }
                    }
                    if ($baseModel == $curr['base_model']) {
                        array_push($ids, $curr['pkey']);
                        $baseModel = $curr['base_model'];
                        // To support new design on OrderItem & ViewAliquotUse: See Issue #3310
                        // unset($registeredModel['pkeys_to_check'][$i]);
                    }
                }
                if ($ids) {
                    if (self::$lockedViewsUpdate) {
                        if (! isset(self::$cachedViewsInsert[$model->table])) {
                            self::$cachedViewsInsert[$model->table] = array();
                        }
                        if (! isset(self::$cachedViewsInsert[$model->table][$baseModel])) {
                            self::$cachedViewsInsert[$model->table][$baseModel] = array();
                        }
                        if (! isset(self::$cachedViewsInsert[$model->table][$baseModel][$queryPart])) {
                            self::$cachedViewsInsert[$model->table][$baseModel][$queryPart] = array(
                                "ids" => array()
                            );
                        }
                        self::$cachedViewsInsert[$model->table][$baseModel][$queryPart]["ids"] = array_merge(self::$cachedViewsInsert[$model->table][$baseModel][$queryPart]["ids"], $ids);
                    } else {
                        $tableQuery = str_replace('%%WHERE%%', 'AND ' . $baseModel . '.id IN(' . implode(", ", $ids) . ')', $queryPart);
                        $query = sprintf('INSERT INTO %s (%s)', $model->table, $tableQuery);
                        $this->tryCatchquery($query);
                    }
                    $registeredModel['pkeys_to_check'] = array_values($registeredModel['pkeys_to_check']); // reindex from 0
                }
            }
        }
    }

    /**
     *
     * @param $data
     * @param $modelName
     */
    private function deleteUploadedFile($data, $modelName)
    {
        $ifDelete = Configure::read('deleteUploadedFilePhysically');
        $dir = Configure::read('uploadDirectory');
        
        foreach ($data[$modelName] as $field => $value) {
            preg_match('/(' . $modelName . ')\.(' . $field . ')\.([0-9]+)\.(.+)/', $value, $matches, PREG_OFFSET_CAPTURE);
            if (! empty($matches)) {
                if (file_exists($dir . DS . $matches[0][0])) {
                    $fileName = $matches[0][0];
                    if (! $ifDelete) {
                        $deleteDirectory = $dir . DS . Configure::read('deleteDirectory');
                        if (! is_dir($deleteDirectory)) {
                            mkdir($deleteDirectory);
                        }
                        if (file_exists($dir . DS . $fileName)) {
                            copy($dir . DS . $fileName, $deleteDirectory . DS . $fileName);
                        }
                        if (file_exists($dir . DS . $fileName)) {
                            unlink($dir . DS . $fileName);
                        }
                        
                        move_uploaded_file($matches[0][0], $deleteDirectory . DS . $fileName);
                    } else {
                        if (file_exists($dir . DS . $fileName)) {
                            unlink($dir . DS . $fileName);
                        }
                    }
                }
            }
        }
    }

    /**
     * Run atimDelete which use soft delete.
     *
     * @param null $modelId
     * @param bool $cascade Set to true to delete records that depend on this record
     * @return bool True on success
     * @internal param int|string $id ID of record to delete
     */
    public function delete($modelId = null, $cascade = true)
    {
        $this->atimDelete($modelId, $cascade);
    }

    /*
     * ATiM 2.0 function
     * used instead of Model->delete, because SoftDelete Behaviour will always return a FALSE
     */
    /**
     *
     * @param $modelId
     * @param bool $cascade
     * @return bool
     */
    public function atimDelete($modelId, $cascade = true)
    {
        $this->id = $modelId;
        $data = $this->read();
        
        $this->registerModelsToCheck();
        
        // delete DATA as normal
        $this->addWritableField('deleted');
        
        parent::delete($modelId, $cascade);
        
        // do a FIND of the same DATA, return FALSE if found or TRUE if not found
        if ($this->read()) {
            return false;
        }
        $this->deleteUploadedFile($data, $this->name);
        $this->updateRegisteredModels();
        return true;
    }

    /*
     * ATiM 2.0 function
     * acts like find('all') but returns array with ID values as arrays key values
     */
    /**
     *
     * @param array $options
     * @return array|bool
     */
    public function atimList($options = array())
    {
        $return = false;
        
        $defaults = array(
            'conditions' => null,
            'fields' => null,
            'order' => null,
            'group' => null,
            'limit' => null,
            'page' => null,
            'recursive' => 1,
            'callbacks' => true
        );
        
        $options = array_merge($defaults, $options);
        
        $results = $this->find('all', $options);
        
        if ($results) {
            $return = array();
            
            foreach ($results as $key => $result) {
                $return[$result[$this->name]['id']] = $result;
            }
        }
        
        return $return;
    }

    /**
     *
     * @param $conditions
     * @param $fields
     * @param $order
     * @param $limit
     * @param $page
     * @param $recursive
     * @param $extra
     * @return array|null
     */
    public function paginate($conditions, $fields, $order, $limit, $page, $recursive, $extra)
    {
        $params = array(
            'fields' => $fields,
            'conditions' => $conditions,
            'order' => $order,
            'limit' => $limit,
            'offset' => $limit * ($page > 0 ? $page - 1 : 0),
            'recursive' => $recursive,
            'extra' => $extra
        );
        
        if (isset($extra['joins'])) {
            $params['joins'] = $extra['joins'];
            unset($extra['joins']);
        }
        return $this->find('all', $params);
    }

    /**
     * Deconstructs a complex data type (array or object) into a single field value.
     * Copied from CakePHP core since alterations were required
     *
     * @param string $field The name of the field to be deconstructed
     * @param mixed $data An array or object to be deconstructed into a field
     * @param boolean $isEnd (for a range search)
     * @param boolean $isSearch If true, date/time will be patched as much as possible
     * @return mixed The resulting data that should be assigned to a field
     */
    public function deconstruct($field, $data, $isEnd = false, $isSearch = false)
    {
        if (! is_array($data)) {
            return $data;
        }
        
        $type = $this->getColumnType($field);
        if (in_array($type, array(
            'datetime',
            'timestamp',
            'date',
            'time'
        ))) {
            $data = array_merge(array(
                "year" => null,
                "month" => null,
                "day" => null,
                "hour" => null,
                "min" => null,
                "sec" => null
            ), $data);
            if (strlen($data['year']) > 0 || strlen($data['month']) > 0 || strlen($data['day']) > 0 || strlen($data['hour']) > 0 || strlen($data['min']) > 0) {
                $gotDate = in_array($type, array(
                    'datetime',
                    'timestamp',
                    'date'
                ));
                $gotTime = in_array($type, array(
                    'datetime',
                    'timestamp',
                    'time'
                ));
                if ($isSearch) {
                    // if search and leading field missing, return
                    if ($gotDate && strlen($data['year']) == 0) {
                        return null;
                    }
                    if ($type == 'time' && strlen($data['hour']) == 0) {
                        return null;
                    }
                }
                
                // manage meridian
                if ($isEnd && isset($data['hour']) && strlen($data['hour']) > 0 && isset($data['meridian']) && strlen($data['meridian']) == 0) {
                    $data['meridian'] = 'pm';
                }
                if (is_numeric($data['hour'])) {
                    // do not alter an invalid hour
                    if (isset($data['hour']) && isset($data['meridian']) && $data['hour'] != 12 && 'pm' == $data['meridian']) {
                        $data['hour'] = $data['hour'] + 12;
                    }
                    if (isset($data['hour']) && isset($data['meridian']) && $data['hour'] == 12 && 'am' == $data['meridian']) {
                        $data['hour'] = '00';
                    }
                }
                
                // patch incomplete values
                if ($isSearch) {
                    if ($gotDate) {
                        if ($isEnd) {
                            if (strlen($data['day']) == 0) {
                                $data['day'] = 31;
                                if (strlen($data['month']) == 0) {
                                    // only patch month if date is patched
                                    $data['month'] = 12;
                                }
                            }
                        } else {
                            if (strlen($data['day']) == 0) {
                                $data['day'] = 1;
                                if (strlen($data['month']) == 0) {
                                    // only patch month if date is patched
                                    $data['month'] = 1;
                                }
                            }
                        }
                    }
                    
                    if (in_array($type, array(
                        'datetime',
                        'timestamp'
                    ))) {
                        if (strlen($data['hour']) == 0 && strlen($data['min']) == 0 && strlen($data['sec']) == 0) {
                            // only patch hour if min and sec are empty
                            $data['hour'] = $isEnd ? 23 : 0;
                        }
                    }
                    
                    if ($gotTime) {
                        if (strlen($data['min']) == 0) {
                            $data['min'] = $isEnd ? 59 : 0;
                        }
                        if (! isset($data['sec']) || strlen($data['sec']) == 0) {
                            $data['sec'] = $isEnd ? 59 : 0;
                        }
                    }
                } else {
                    if (isset($data['year_accuracy'])) {
                        $data['year'] = '±' . $data['year'];
                    }
                    
                    if (! isset($data['sec']) || strlen($data['sec']) == 0) {
                        $data['sec'] = '00';
                    }
                }
                
                if ($gotTime) {
                    foreach (array(
                        'hour',
                        'min',
                        'sec'
                    ) as $key) {
                        if (is_numeric($data[$key])) {
                            $data[$key] = sprintf("%s", $data[$key]);
                        }
                    }
                }
                
                $result = null;
                if ($gotDate && $gotTime) {
                    $result = sprintf("%s-%s-%s %s:%s:%s", $data['year'], $data['month'], $data['day'], $data['hour'], $data['min'], $data['sec']);
                } elseif ($gotDate) {
                    $result = sprintf("%s-%s-%s", $data['year'], $data['month'], $data['day']);
                } else {
                    $result = sprintf("%s:%s:%s", $data['hour'], $data['min'], $data['sec']);
                }
                return $result;
            }
            return "";
        }
        
        return $data;
    }

    /**
     * Replace the %%key_increment%% part of a string with the key increment value
     *
     * @param string $key - The key to seek in the database
     * @param string $str - The string where to put the value. %%key_increment%% will be replaced by the value.
     * @param int $padToLength - The min length of the key increment part. If the retrieved key is too short, 0 will be prepended.
     * @return string The string with the replaced value or false when SQL error happens
     */
    public function getKeyIncrement($key, $str, $padToLength = 0)
    {
        $this->query('LOCK TABLE key_increments WRITE');
        $result = $this->query('SELECT key_value FROM key_increments WHERE key_name="' . $key . '"');
        if (empty($result)) {
            $this->query('UNLOCK TABLES');
            return false;
        }
        try {
            $this->query('UPDATE key_increments set key_value = key_value + 1 WHERE key_name="' . $key . '"');
        } catch (Exception $e) {
            $this->query('UNLOCK TABLES');
            return false;
        }
        $this->query('UNLOCK TABLES');
        return str_replace("%%key_increment%%", str_pad($result[0]['key_increments']['key_value'], $padToLength, '0', STR_PAD_LEFT), $str);
    }

    /**
     *
     * @return array
     */
    public static function getMagicCodingIcdTriggerArray()
    {
        return self::$magicCodingIcdTriggerArray;
    }

    public function buildAccuracyConfig()
    {
        $tmpAcc = array();
        if (! isset($this->_schema) && $this->table) {
            $this->schema();
        }
        if (isset($this->_schema)) {
            foreach ($this->_schema as $fieldName => $foo) {
                if (strpos($fieldName, "_accuracy") === strlen($fieldName) - 9) {
                    $tmpAcc[substr($fieldName, 0, strlen($fieldName) - 9)] = $fieldName;
                }
            }
        } else {
            AppController::addWarningMsg('failed to build accuracy config for model [' . $this->name . '] because there is no schema. ' . 'To avoid this warning message you can add an empty array as a schema to your model. Eg.: <code>$model->_schema = array();</code>');
        }
        self::$accuracyConfig[$this->table] = $tmpAcc;
    }

    private function setDataAccuracy()
    {
        if (! array_key_exists($this->table, self::$accuracyConfig)) {
            // build accuracy settings for that table
            $this->buildAccuracyConfig();
        }
        
        foreach (self::$accuracyConfig[$this->table] as $dateField => $accuracyField) {
            if (! isset($this->data[$this->name][$dateField])) {
                continue;
            }
            
            $current = &$this->data[$this->name][$dateField];
            if (empty($current)) {
                $this->data[$this->name][$accuracyField] = '';
                $current = null;
            } else {
                list ($year, $month, $day) = explode("-", trim($current));
                $hour = null;
                $minute = null;
                $time = null;
                if (strpos($day, ' ') !== false) {
                    list ($day, $time) = explode(" ", $day);
                    list ($hour, $minute) = explode(":", $time);
                }
                
                // used to avoid altering the date when its invalid
                $goToNextField = false;
                $plusMinus = false;
                if (strpos($year, '±') === 0) {
                    $plusMinus = true;
                    $year = substr($year, 2);
                    $month = $day = $hour = $minute = null;
                }
                
                $emptyFound = false;
                foreach (array(
                    $year,
                    $month,
                    $day,
                    $hour,
                    $minute
                ) as $field) {
                    if (! empty($field) && ! is_numeric($field)) {
                        $goToNextField = true;
                        break;
                    }
                    if (strlen($field) == 0) {
                        $emptyFound = true;
                    } elseif ($emptyFound) {
                        // example: Entered 2010--02 -> Invalid date is skiped here and get caught at validation level
                        $goToNextField = true;
                        break;
                    }
                }
                if ($goToNextField) {
                    continue; // if one of them is not empty AND not numeric
                }
                
                if (! empty($year)) {
                    if ($plusMinus || (empty($month) && empty($day) && empty($hour) && empty($minute))) {
                        $month = '01';
                        $day = '01';
                        $hour = '00';
                        $minute = '00';
                        if ($plusMinus) {
                            $this->data[$this->name][$accuracyField] = 'y';
                        } else {
                            $this->data[$this->name][$accuracyField] = 'm';
                        }
                    } elseif (empty($day) && empty($hour) && empty($minute)) {
                        $day = '01';
                        $hour = '00';
                        $minute = '00';
                        $this->data[$this->name][$accuracyField] = 'd';
                    } elseif (empty($time)) {
                        $this->data[$this->name][$accuracyField] = 'c';
                    } elseif (! strlen($hour) && ! strlen($minute)) {
                        $hour = '00';
                        $minute = '00';
                        $this->data[$this->name][$accuracyField] = 'h';
                    } elseif (! strlen($minute)) {
                        $minute = '00';
                        $this->data[$this->name][$accuracyField] = 'i';
                    } else {
                        $this->data[$this->name][$accuracyField] = 'c';
                    }
                    $current = sprintf("%s-%02s-%02s", $year, $month, $day);
                    if (! empty($time)) {
                        $current .= sprintf(" %02s:%02s:00", $hour, $minute);
                    }
                }
            }
        }
    }

    /**
     *
     * @param array $options
     * @return bool
     */
    public function validates($options = array())
    {
        $this->data = $this->checkRequiredFields($this->data);
        if (! $this->_schema) {
            $this->schema();
        }
        if (! isset(self::$autoValidation[$this->name]) && isset($this->Behaviors->MasterDetail) && (strpos($this->name, 'Detail') === false || ! array_key_exists(str_replace('Detail', 'Master', $this->name), $this->Behaviors->MasterDetail->__settings))) {
            // build master validation (detail validation are built within the validation function)
            self::buildAutoValidation($this->name, $this);
            if (array_key_exists($this->name, self::$autoValidation)) {
                $this->validate = array_merge_recursive($this->validate, self::$autoValidation[$this->name]);
            }
        }
        $this->setDataAccuracy();
        
        if (isset($this->Behaviors->MasterDetail->__settings[$this->name]['is_master_model']) && $this->Behaviors->MasterDetail->__settings[$this->name]['is_master_model']) {
            // master detail, validate the details part
            $settings = $this->Behaviors->MasterDetail->__settings[$this->name];
            $masterClass = $settings['master_class'];
            $controlForeign = $settings['control_foreign'];
            $controlClass = $settings['control_class'];
            $detailClass = $settings['detail_class'];
            $formAlias = $settings['form_alias'];
            $detailField = $settings['detail_field'];
            
            $associated = null;
            if (isset($this->data[$masterClass][$controlForeign]) && $this->data[$masterClass][$controlForeign]) {
                // use CONTROL_ID to get control row
                $associated = $this->$controlClass->find('first', array(
                    'conditions' => array(
                        $controlClass . '.id' => $this->data[$masterClass][$controlForeign]
                    )
                ));
            } elseif (isset($this->id) && is_numeric($this->id)) {
                // else, if EDIT, use MODEL.ID to get row and find CONTROL_ID that way...
                $associated = $this->find('first', array(
                    'conditions' => array(
                        $masterClass . '.id' => $this->id
                    )
                ));
            } elseif (isset($this->data[$masterClass]['id']) && is_numeric($this->data[$masterClass]['id'])) {
                // else, (still EDIT), use use data[master_model][id] to get row and find CONTROL_ID that way...
                $associated = $this->find('first', array(
                    'conditions' => array(
                        $masterClass . '.id' => $model->data[$this]['id']
                    )
                ));
            }
            
            if ($associated == null || empty($associated)) {
                // FAIL!, we ABSOLUTELY WANT validations
                AppController::getInstance()->redirect('/Pages/err_internal?p[]=' . __CLASS__ . " @ line " . __LINE__ . " (the detail control id was not found for " . $masterClass . ")", null, true);
                exit();
            }
            
            $useFormAlias = $associated[$controlClass][$formAlias];
            $useTableName = $associated[$controlClass][$detailField];
            if ($useFormAlias) {
                $pluginName = $this->getPluginName();
                $detailClassInstance = AppModel::getInstance($pluginName, $detailClass);
                if ($detailClassInstance->useTable == false) {
                    $detailClassInstance->useTable = $useTableName;
                } elseif ($detailClassInstance->useTable != $useTableName) {
                    ClassRegistry::removeObject($detailClassInstance->alias);
                    $detailClassInstance = AppModel::getInstance($pluginName, $detailClass);
                    $detailClassInstance->useTable = $useTableName;
                }
                assert($detailClassInstance->useTable == $useTableName);
                if (isset(AppController::getInstance()->{$detailClass}) && (! isset($params['validate']) || $params['validate'])) {
                    // attach auto validation
                    $autoValidationName = $detailClass . $associated[$controlClass]['id'];
                    
                    if (! isset(self::$autoValidation[$autoValidationName])) {
                        // build detail validation on the fly
                        $this->buildAutoValidation($autoValidationName, $detailClassInstance);
                    }
                    
                    $detailClassInstance->validate = AppController::getInstance()->{$detailClass}->validate;

                    foreach (self::$autoValidation[$autoValidationName] as $fieldName => $rules) {
                        if (! isset($detailClassInstance->validate[$fieldName])) {
                            $detailClassInstance->validate[$fieldName] = array();
                        }
                        $detailClassInstance->validate[$fieldName] = array_merge($detailClassInstance->validate[$fieldName], $rules);
                    }
                    $detailClassInstance->set(isset($this->data[$detailClass]) ? $this->data[$detailClass] : array());

                    $detailClassInstance->primaryKey = $settings['master_foreign'];
                    if (isset($associated[$detailClass][$detailClassInstance->primaryKey])){
                        $detailClassInstance->id = $associated[$detailClass][$detailClassInstance->primaryKey];
                    }

                    $this->checkMasterDetailRequiredFields($this, $detailClassInstance);

                    $validDetailClass = $detailClassInstance->validates();
                    
                    $this->checkMasterDetailRequiredFields($this, $detailClassInstance);

                    if ($detailClassInstance->data) {
                        $this->data = array_merge($this->data, $detailClassInstance->data);
                    }
                    if (! $validDetailClass) {
                        // put details validation errors in the master model
                        $this->validationErrors = array_merge($this->validationErrors, $detailClassInstance->validationErrors);
                    }
                }
            }
        }
        
        $this->checkFloats();
        
        $this->checkList();
        
        parent::validates($options);
        
        if (!empty($this->notBlankFields)){
            $modelTemp = "FunctionManagement";
            foreach ($this->notBlankFields[$modelTemp] as $field => $message) {
                if (isset($this->data[$modelTemp][$field]) && empty($this->data[$modelTemp][$field])){
                    if (!isset($this->validationErrors[$field]) || in_array($message, $this->validationErrors[$field])===false){
                        $this->validationErrors[$field][]= $message;
                    }
                }
            }
        }
        
        if (count($this->validationErrors) == 0) {
            $this->data[$this->alias]['__validated__'] = true;
            return true;
        }
        return false;
    }
    
    private function checkList()
    {
        $name = $this->name;
        $data = $this->data;
        if (isset (self::$listValues[$name])){
            $lists = self::$listValues[$name];
            foreach ($lists as $fieldLabel => $list) {
                $field = explode("||", $fieldLabel)[0];
                $label = explode("||", $fieldLabel)[1];
                if (isset($data[$name][$field]) && !empty($data[$name][$field])){
                    if (!isset($list[$data[$name][$field]])){
                        $message = __('the value is not part of the list [%s]', $label);
                        if (!isset($this->validationErrors[$field]) || in_array($message, $this->validationErrors[$field])===false){
                            $this->validationErrors[$field][]= $message;
                        }elseif (isset($this->validationErrors[$field])){
                            $this->validationErrors[$field][]= $message;
                        }
                    }
                }
            }
        }
    }

    private function checkMasterDetailRequiredFields(&$master, &$detail)
    {
        if (!empty(self::$requiredFields['FunctionManagement'])) {
            foreach (self::$requiredFields['FunctionManagement']as $field => $message) {
                if (!isset($master->notBlankFields['FunctionManagement'][$field])) {
                    if (isset($master->notBlankFields['FunctionManagement'])) {
                        $master->notBlankFields['FunctionManagement'][$field] = $message;
                    } else {
                        $master->notBlankFields['FunctionManagement'] = array($field, $message);
                    }
                }

                if (isset($detail->data['FunctionManagement'][$field])) {
                    if (empty($master->data['FunctionManagement'][$field]) && !$master->id) {
                        if (isset($master->data['FunctionManagement'][$field])) {
                            $master->data['FunctionManagement'][$field] = $detail->data['FunctionManagement'][$field];
                        } else {
                            $master->data['FunctionManagement'] = array($field, $detail->data['FunctionManagement'][$field]);
                        }
                    }
                }

                unset($detail->notBlankFields['FunctionManagement'][$field]);
                unset($detail->data['FunctionManagement'][$field]);
            }
            if (empty($detail->notBlankFields['FunctionManagement'])) {
                unset($detail->notBlankFields['FunctionManagement']);
            }

            if (empty($detail->data['FunctionManagement'])) {
                unset($detail->data['FunctionManagement']);
            }
        }
    }
    
    /**
     *
     * @param $pluginName
     * @param $className
     * @param bool $errorViewOnNull
     * @return bool|mixed|null|object
     */
    public static function getInstance($pluginName, $className, $errorViewOnNull = true)
    {
        $instance = ClassRegistry::getObject($className);
        if ($instance !== false && $instance instanceof $className) {
            return $instance;
        }
        
        if ($pluginName != null && strlen($pluginName) > 0) {
            $pluginName .= ".";
        }
        
        $importName = (strlen($pluginName) > 0 ? $pluginName : "") . $className;
        if (class_exists($className, false) || App::import('Model', $importName)) {
            $instance = ClassRegistry::init($pluginName . $className, true);
            
            if (($bogusModel = ClassRegistry::getObject('Model')) != false && $bogusModel->alias == $className) {
                // fix a cakephp2 issue where the "Model" model is bogusly created with the alias of the model we just initialized
                ClassRegistry::removeObject('Model');
            }
        }
        if ($instance === false && $errorViewOnNull) {
            if (Configure::read('debug') > 0) {
                pr(AppController::getStackTrace());
                die('died in AppModel::getInstance [' . $pluginName . $className . '] <br>' . '(If you are displaying a form with master & detail fields, please check structure_fields.plugin is not empty) <br>' . ('(If getInstance() is called by function fetchSummary(), please validate that the plugin is defined for the menus.use_summary field as follow : {Plugin}.{Model}::summary)'));
            } else {
                AppController::getInstance()->redirect('/Pages/err_model_import_failed?p[]=' . $className, null, true);
            }
        }
        
        return $instance;
    }

    /**
     * Use this function to instantiate extend models.
     * It loads it based on the
     * table_name and and configures the shadow model
     *
     * @param class $class The class to instantiate
     * @param string $tableName The table to use
     * @return The instantiated class
     */
    public static function atimInstantiateExtend($class, $tableName)
    {
        ClassRegistry::removeObject($class->name);
        $extend = new $class(false, $tableName);
        $extend->Behaviors->Revision->setup($extend); // activate shadow model
        return $extend;
    }

    /**
     * Builds automatic string length and float validations based on the field type
     *
     * @param string $useName The name under which to record the validations
     * @param Model $model The model to base the validations on
     */
    public static function buildAutoValidation($useName, Model $model)
    {
        if (! is_array($model->_schema)) {
            $model->schema();
        }
        if (is_array($model->_schema)) {
            $autoValidation = array();
            foreach ($model->_schema as $fieldName => $fieldData) {
                // debug($fieldData);
                switch ($fieldData['type']) {
                    case 'string':
                        $autoValidation[$fieldName][] = array(
                            'rule' => array(
                                "maxLength",
                                $fieldData['length']
                            ),
                            'allowEmpty' => true,
                            'required' => null,
                            'message' => __("the string length must not exceed %d characters", $fieldData['length'])
                        );
                        break;
                    case 'float':
                        $min = "-1000000000";
                        $max = "1000000000"; // arbitrary limit
                        if ($fieldData['length']) {
                            list ($m, $d) = explode(',', $fieldData['length']);
                            $max = str_repeat('9', $m - $d) . "." . str_repeat('9', $d);
                            $min = - 1 * $max;
                        } elseif ($fieldData['atim_type'] == 'float unsigned') {
                            $min = "0";
                        }
                        $autoValidation[$fieldName][] = array(
                            'rule' => array(
                                'range',
                                (int) $min - 1,
                                (int) $max + 1
                            ),
                            'allowEmpty' => true,
                            'required' => null,
                            'message' => __("the value must be between %g and %g", $min, $max)
                        );
                        break;
                    case 'integer':
                        $rule = null;
                        if (strpos($fieldData['atim_type'], 'int') === 0) {
                            if (strpos($fieldData['atim_type'], 'unsigned') === false) {
                                $rule = array(
                                    'range',
                                    - 2147483649,
                                    2147483648
                                );
                            } else {
                                $rule = array(
                                    'range',
                                    - 1,
                                    4294967295
                                );
                            }
                        } elseif (strpos($fieldData['atim_type'], 'tinyint') === 0) {
                            if (strpos($fieldData['atim_type'], 'unsigned') === false) {
                                $rule = array(
                                    'range',
                                    - 129,
                                    128
                                );
                            } else {
                                $rule = array(
                                    'range',
                                    - 1,
                                    256
                                );
                            }
                        } elseif (strpos($fieldData['atim_type'], 'smallint') === 0) {
                            if (strpos($fieldData['atim_type'], 'unsigned') === false) {
                                $rule = array(
                                    'range',
                                    - 32769,
                                    32768
                                );
                            } else {
                                $rule = array(
                                    'range',
                                    - 1,
                                    65536
                                );
                            }
                        } elseif (strpos($fieldData['atim_type'], 'mediumint') === 0) {
                            if (strpos($fieldData['atim_type'], 'unsigned') === false) {
                                $rule = array(
                                    'range',
                                    - 8388609,
                                    8388608
                                );
                            } else {
                                $rule = array(
                                    'range',
                                    - 1,
                                    16777216
                                );
                            }
                        } elseif (strpos($fieldData['atim_type'], 'bigint') === 0) {
                            if (strpos($fieldData['atim_type'], 'unsigned') === false) {
                                $rule = array(
                                    'range',
                                    - 9223372036854775809,
                                    9223372036854775808
                                );
                            } else {
                                $rule = array(
                                    'range',
                                    - 1,
                                    18446744073709551615
                                );
                            }
                        } else {
                            AppController::addWarningMsg('Unknown integer type for field [' . $model->name . '.' . $fieldName, true);
                        }
                        if ($rule) {
                            $autoValidation[$fieldName][] = array(
                                'rule' => $rule,
                                'allowEmpty' => true,
                                'required' => null,
                                'message' => __("the value must be between %g and %g", $rule[1] + 1, $rule[2] - 1)
                            );
                        }
                        break;
                    default:
                        break;
                }
            }
            self::$autoValidation[$useName] = $autoValidation;
        }
    }

    /**
     * Searches recursively for field in CakePHP SQL conditions
     *
     * @param string $field The field to look for
     * @param array $conditions CakePHP SQL conditionnal array
     * @return true if the field was found
     */
    public static function isFieldUsedAsCondition($field, array $conditions)
    {
        foreach ($conditions as $key => $value) {
            $isArray = is_array($value);
            $pos1 = strpos($key, $field);
            $pos2 = strpos($key, " ");
            if ($pos1 !== false && ($pos2 === false || $pos1 < $pos2)) {
                return true;
            }
            if ($isArray) {
                if (self::isFieldUsedAsCondition($field, $value)) {
                    return true;
                }
            } else {
                $pos1 = strpos($value, $field);
                $pos2 = strpos($value, " ");
                if ($pos1 !== false && ($pos2 === false || $pos1 < $pos2)) {
                    return true;
                }
            }
        }
        return false;
    }

    /**
     * Return the spent time between 2 dates.
     *
     * Notes: The supported date format is YYYY-MM-DD HH:MM:SS
     *
     * @param $startDatetime Start date and time
     * @param $endDatetime End date and time
     *       
     * @return Return an array that contains the spent time
     *         or an error message when the spent time can not be calculated.
     *         The sturcture of the array is defined below:
     *         Array (
     *         'message' => '',
     *         'years' => '0',
     *         'months' => '0',
     *         'days' => '0',
     *         'hours' => '0',
     *         'minutes' => '0'
     *         'total_days' => '0'
     *         )
     *        
     * @author N. Luc
     * @since 2007-06-20
     */
    public static function getSpentTime($startDatetime, $endDatetime)
    {
        $arrSpentTime = array(
            'message' => null,
            'years' => '0',
            'month' => '0',
            'days' => '0',
            'hours' => '0',
            'minutes' => '0',
            'total_days' => '0'
        );
        
        if (preg_match('/^[0-9]{4}\-[0-9]{2}\-[0-9]{2}$/', $startDatetime))
            $startDatetime .= ' 00:00:00';
        $startDatetime = str_replace('0000-00-00 00:00:00', '', $startDatetime);
        if (preg_match('/^[0-9]{4}\-[0-9]{2}\-[0-9]{2}$/', $endDatetime))
            $endDatetime .= ' 00:00:00';
        $endDatetime = str_replace('0000-00-00 00:00:00', '', $endDatetime);
        
        $datetimePattern = '/^((19)|(20))[0-9]{2}\-((0[1-9])|(1[0-2]))-((0[1-9])|([12][0-9])|(3[01]))\ ((0[0-9])|([1-5][0-9])|(60))(:((0[0-9])|([1-5][0-9])|(60))){2}$/';
        // Verfiy date is not empty
        if (empty($startDatetime) || empty($endDatetime)) {
            // At least one date is missing to continue
            $arrSpentTime['message'] = 'missing date';
        } elseif (! preg_match($datetimePattern, $startDatetime) || ! preg_match($datetimePattern, $endDatetime)) {
            // Error in the date
            $arrSpentTime['message'] = 'error in the date definitions';
        } elseif ($datetimePattern == $endDatetime) {
            // Nothing to change to $arrSpentTime
            $arrSpentTime['message'] = '0';
        } else {
            $startDatetimeOb = new DateTime($startDatetime);
            $endDatetimeOb = new DateTime($endDatetime);
            $interval = $startDatetimeOb->diff($endDatetimeOb);
            if ($interval->invert) {
                // Error in the date
                $arrSpentTime['message'] = 'error in the date definitions';
            } else {
                // Return spend time
                $arrSpentTime['years'] = $interval->y;
                $arrSpentTime['months'] = $interval->m;
                $arrSpentTime['days'] = $interval->d;
                $arrSpentTime['hours'] = $interval->h;
                $arrSpentTime['minutes'] = $interval->i;
                $arrSpentTime['total_days'] = $interval->days;
            }
        }
        
        return $arrSpentTime;
    }

    /**
     * Return time stamp of a date.
     *
     * Notes: The supported date format is YYYY-MM-DD HH:MM:SS
     *
     * @param $dateString Date
     *
     * @return Return time stamp of the date.
     *        
     * @author N. Luc
     * @since 2007-06-20
     */
    public static function getTimeStamp($dateString)
    {
        list ($date, $time) = explode(' ', $dateString);
        list ($year, $month, $day) = explode('-', $date);
        list ($hour, $minute, $second) = explode(':', $time);
        
        return mktime($hour, $minute, $second, $month, $day, $year);
    }

    /**
     *
     * @param $spentTimeData
     * @param bool $withTime
     * @return mixed|string
     */
    public static function manageSpentTimeDataDisplay($spentTimeData, $withTime = true)
    {
        $spentTimeMsg = '';
        if (! empty($spentTimeData)) {
            if (! is_null($spentTimeData['message'])) {
                if ($spentTimeData['message'] == '0') {
                    $spentTimeMsg = $spentTimeData['message'];
                } else {
                    $spentTimeMsg = __($spentTimeData['message']);
                }
            } else {
                if ($withTime) {
                    $spentTimeMsg = AppModel::translateDateValueAndUnit($spentTimeData, 'total_days') . AppModel::translateDateValueAndUnit($spentTimeData, 'hours') . AppModel::translateDateValueAndUnit($spentTimeData, 'minutes');
                } else {
                    $spentTimeMsg = AppModel::translateDateValueAndUnit($spentTimeData, 'years') . AppModel::translateDateValueAndUnit($spentTimeData, 'months') . AppModel::translateDateValueAndUnit($spentTimeData, 'days');
                }
            }
        }
        
        return $spentTimeMsg;
    }

    /**
     *
     * @param $spentTimeData
     * @param $timeUnit
     * @return string
     */
    public static function translateDateValueAndUnit($spentTimeData, $timeUnit)
    {
        if (array_key_exists($timeUnit, $spentTimeData)) {
            return (((! empty($spentTimeData[$timeUnit])) && ($spentTimeData[$timeUnit] != '00')) ? ($spentTimeData[$timeUnit] . ' ' . ($spentTimeData[$timeUnit] == 1 ? __(substr($timeUnit, 0, - 1)) : __($timeUnit)) . ' ') : '');
        }
        return '#err#';
    }

    /**
     * Uses the same url sorting options as cakephp paginator uses to sort a data array
     *
     * @param array $data The data to sort
     * @param array $passedArgs The controller passed arguments. (From the controller, $this->passedArgs)
     * @return The data sorted if the passed_args were compatible with it
     */
    public static function sortWithUrl(array $data, array $passedArgs)
    {
        $order = array();
        if (isset($passedArgs['sort'])) {
            $result = array();
            list ($sortModel, $sortField) = explode(".", $passedArgs['sort']);
            $i = 0;
            foreach ($data as $dataUnit) {
                if (isset($dataUnit[$sortModel]) && isset($dataUnit[$sortModel][$sortField])) {
                    $result[sprintf("%s%04d", $dataUnit[$sortModel][$sortField], ++ $i)] = $dataUnit;
                } else {
                    $result[sprintf("%04d", ++ $i)] = $dataUnit;
                }
            }
            ksort($result);
            if (isset($passedArgs['direction']) && $passedArgs['direction'] == 'desc') {
                $result = array_reverse($result);
            }
            return $result;
        }
        return $data;
    }

    /**
     * Generic function made to be overriden in model/custom models.
     *
     * @param int $id The db id of the element to allow the deletion of
     * @return array with two keys, one being allow_detion, a boolean telling
     *         whether the element can be deleted or not and the second one being msg,
     *         a string that telles why, if relevant, the element cannot be deleted.
     */
    public function allowDeletion($id)
    {
        return array(
            'allow_deletion' => true,
            'msg' => ''
        );
    }

    /**
     * Redirects to the missing data page if a model id cannot be fetched
     *
     * @param int $id
     * @param string $method The method name to display in the error message
     * @param string $line The line number to display in the error message
     * @param bool $return Returns the data line if it exists
     * @return null if $return is true and the data exists, the data, null otherwise
     * @deprecated Use getOrRedirect instead. TODO: Remove in ATiM 2.6
     */
    public function redirectIfNonExistent($id, $method, $line, $return = false)
    {
        $this->id = $id;
        if ($result = $this->read()) {
            if ($return) {
                return $result;
            }
        } else {
            AppController::getInstance()->redirect('/Pages/err_plugin_no_data?method=' . $method . ',line=' . $line, null, true);
        }
        return null;
    }

    /**
     * Tries to fetch model data.
     * If it doesn't exists, redirects to an error page.
     *
     * @param string $id The model primary key to fetch
     * @return The model data if it succeeds
     */
    public function getOrRedirect($id)
    {
        $this->id = $id;
        if ($result = $this->read()) {
            return $result;
        }
        $bt = debug_backtrace();
        AppController::getInstance()->redirect('/Pages/err_plugin_no_data?method=' . $bt[1]['function'] . ',line=' . $bt[0]['line'], null, true);
        return null;
    }

    /**
     *
     * @param $field
     * @param null $tablename
     * @param $add
     */
    private function updateWritableField($field, $tablename = null, $add)
    {
        $addInto = null;
        $removeFrom = null;
        if ($add) {
            $addInto = 'all';
            $removeFrom = 'none';
        } else {
            $addInto = 'none';
            $removeFrom = 'all';
        }
        $tablename = $tablename ?  : $this->table;
        if (! isset(AppModel::$writableFields[$tablename][$addInto])) {
            AppModel::$writableFields[$tablename][$addInto] = array();
        }
        if (! is_array($field)) {
            $field = array(
                $field
            );
        }
        AppModel::$writableFields[$tablename][$addInto] = array_unique(array_merge(AppModel::$writableFields[$tablename][$addInto], $field));
        
        if (isset(AppModel::$writableFields[$this->table][$removeFrom])) {
            AppModel::$writableFields[$this->table][$removeFrom] = array_diff(AppModel::$writableFields[$this->table][$removeFrom], $field);
        }
    }

    /**
     * Add fields to the current model table Writable fields array.
     *
     * @param mixed $field A single field or an array of fields.
     * @param string $tablename The tablename to allow the fields to be written to.
     */
    public function addWritableField($field, $tablename = null)
    {
        $this->updateWritableField($field, $tablename, true);
    }

    /**
     *
     * @param $field
     * @param null $tablename
     */
    public function removeWritableField($field, $tablename = null)
    {
        $this->updateWritableField($field, $tablename, false);
    }

    /**
     * Called by structure builder to get the browsing filter dropdowns
     *
     * @return array (array formated for dropdown)
     */
    public function getBrowsingFilter()
    {
        $result = array();
        if (isset($this->browsingSearchDropdownInfo['browsing_filter'])) {
            foreach ($this->browsingSearchDropdownInfo['browsing_filter'] as $key => $details) {
                $result[$key] = __($details['lang']);
            }
        }
        return $result;
    }

    /**
     * Gets the model browsing_search_dropdown_info[field_name].
     * Searches into
     * base model when called from a view.
     *
     * @param string $fieldName
     * @return array if the field config is found, null otherwise
     */
    public function getBrowsingAdvSearchArray($fieldName)
    {
        if (isset($this->browsingSearchDropdownInfo[$fieldName])) {
            return $this->browsingSearchDropdownInfo[$fieldName];
        }
        if (isset($this->baseModel)) {
            $baseModel = AppModel::getInstance($this->basePlugin, $this->baseModel, true);
            return $baseModel->getBrowsingAdvSearchArray($fieldName);
        }
        return null;
    }

    /**
     * Called by structure builder to get the browsing advanced search fields.
     *
     * @param array $fieldName
     * @return array An array formated for dropdown use
     */
    public function getBrowsingAdvSearch($fieldName)
    {
        $fieldName = $fieldName[0];
        $result = array();
        if (isset($this->browsingSearchDropdownInfo[$fieldName]) && Browser::$cache['current_node_id'] != 0) {
            $browserModel = AppModel::getInstance('Datamart', 'Browser', 'true');
            
            $datamartStructure = AppModel::getInstance('Datamart', 'DatamartStructure', true);
            $sfsModel = AppModel::getInstance('', 'Sfs', true);
            $dmStructures = $datamartStructure->find('all');
            $dmStructures = AppController::defineArrayKey($dmStructures, 'DatamartStructure', 'model', true);
            
            if (! isset(Browser::$cache['path'])) {
                $browsingResultModel = AppModel::getInstance('Datamart', 'BrowsingResult', true);
                $path = $browsingResultModel->getPath(Browser::$cache['current_node_id'], null, 0);
                Browser::$cache['allowed_models'] = array();
                while ($current = array_pop($path)) {
                    if ($current['BrowsingResult']['raw']) {
                        if (array_key_exists($current['DatamartStructure']['model'], Browser::$cache['allowed_models'])) {
                            break;
                        }
                        Browser::$cache['allowed_models'][$current['DatamartStructure']['model']] = null;
                    }
                }
            }
            foreach ($this->browsingSearchDropdownInfo[$fieldName] as $key => $option) {
                if (array_key_exists($option['model'], Browser::$cache['allowed_models'])) {
                    $sfs = $sfsModel->find('first', array(
                        'fields' => array(
                            'language_label'
                        ),
                        'conditions' => array(
                            'Sfs.field' => $option['field'],
                            'Sfs.model' => $option['model']
                        ),
                        'recursive' => - 1
                    ));
                    $result[$key] = $option['relation'] . ' ' . __($dmStructures[$option['model']]['DatamartStructure']['display_name']) . ' ' . __($sfs['Sfs']['language_label']);
                }
            }
        }
        
        return $result;
    }

    /**
     *
     * @return array
     */
    public function getOwnershipConditions()
    {
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
        return array(
            'OR' => array(
                array(
                    $this->name . '.sharing_status' => 'user',
                    $this->name . '.user_id' => AppController::getInstance()->Session->read('Auth.User.id')
                ),
                array(
                    $this->name . '.sharing_status' => array(
                        'group',
                        'bank'
                    ),
                    $this->name . '.group_id' => AppController::getInstance()->Session->read('Auth.User.group_id')
                ),
                array(
                    $this->name . '.sharing_status' => 'bank',
                    $this->name . '.group_id' => $userBankGroupIds
                ),
                array(
                    $this->name . '.sharing_status' => 'all'
                )
            )
        );
    }

    /**
     *
     * @param mixed $results
     * @param bool $primary
     * @return mixed
     */
    public function afterFind($results, $primary = false)
    {
        if (isset($this->fieldsReplace) && isset($results[0][$this->name])) {
            $currentFieldsReplace = $this->fieldsReplace;
            foreach ($currentFieldsReplace as $fieldName => $options) {
                if (isset($results[0][$this->name]) && ! array_key_exists($fieldName, $results[0][$this->name])) {
                    unset($currentFieldsReplace[$fieldName]);
                }
            }
            foreach ($results as &$result) {
                foreach ($currentFieldsReplace as $fieldName => $options) {
                    if (isset($options['msg'][$result[$this->name][$fieldName]])) {
                        $result[$this->name][$fieldName] = $options['msg'][$result[$this->name][$fieldName]];
                    } elseif ($options['type'] == 'spentTime') {
                        $remainder = $result[$this->name][$fieldName];
                        $time['minutes'] = $remainder % 60;
                        $remainder = ($remainder - $time['minutes']) / 60;
                        $time['hours'] = $remainder % 24;
                        $time['days'] = ($remainder - $time['hours']) / 24;
                        $spentTime = AppModel::translateDateValueAndUnit($time, 'days') . '' . AppModel::translateDateValueAndUnit($time, 'hours') . AppModel::translateDateValueAndUnit($time, 'minutes');
                        $result[$this->name][$fieldName] = $spentTime ?  : 0;
                    }
                }
            }
        }
        return $results;
    }

    private function updateRegisteredViews()
    {
        if ($this->registeredView) {
            foreach ($this->registeredView as $registeredView => $foreignKeys) {
                list ($pluginName, $modelName) = explode('.', $registeredView);
                $model = AppModel::getInstance($pluginName, $modelName);
                foreach ($foreignKeys as $foreignKey) {
                    $atLeastOne = false;
                    foreach (explode("UNION ALL", $model::$tableQuery) as $queryPart) {
                        if (strpos($queryPart, $foreignKey) === false) {
                            continue;
                        }
                        $atLeastOne = true;
                        if (self::$lockedViewsUpdate) {
                            if (! isset(self::$cachedViewsUpdate[$model->table])) {
                                self::$cachedViewsUpdate[$model->table] = array();
                            }
                            if (! isset(self::$cachedViewsUpdate[$model->table][$foreignKey])) {
                                self::$cachedViewsUpdate[$model->table][$foreignKey] = array();
                            }
                            if (! isset(self::$cachedViewsUpdate[$model->table][$foreignKey][$queryPart])) {
                                self::$cachedViewsUpdate[$model->table][$foreignKey][$queryPart] = array(
                                    "ids" => array()
                                );
                            }
                            array_push(self::$cachedViewsUpdate[$model->table][$foreignKey][$queryPart]["ids"], $this->id);
                        } else {
                            $tableQuery = str_replace('%%WHERE%%', 'AND ' . $foreignKey . '=' . $this->id, $queryPart);
                            $query = sprintf('REPLACE INTO %s (%s)', $model->table, $tableQuery);
                            $this->tryCatchquery($query);
                        }
                    }
                    if (! $atLeastOne) {
                        throw new Exception("No queries part fitted with the foreign key " . $foreignKey);
                    }
                }
            }
        }
    }

    /**
     *
     * @param bool $created
     * @param array $options
     */
    public function afterSave($created, $options = array())
    {
        $this->updateRegisteredViews();
        $this->updateRegisteredModels();
    }

    /**
     *
     * @param array $in
     */
    public function makeTree(array &$in)
    {
        if (! empty($in)) {
            $startingPkey = $in[0][$this->name][$this->primaryKey];
            $in = AppController::defineArrayKey($in, $this->name, $this->primaryKey, true);
            $toRemove = array();
            foreach ($in as $key => &$part) {
                if ($part[$this->name]['parent_id'] != null && isset($in[$part[$this->name]['parent_id']])) {
                    // parent exists, create link
                    if (! isset($in[$part[$this->name]['parent_id']][$this->name]['children'])) {
                        $in[$part[$this->name]['parent_id']][$this->name]['children'] = array();
                    }
                    $in[$part[$this->name]['parent_id']][$this->name]['children'][] = &$part;
                    $toRemove[] = $key;
                }
            }
            foreach ($toRemove as &$key) {
                unset($in[$key]);
            }
        }
    }

    /**
     *
     * @return mixed|null
     */
    public function getPluginName()
    {
        $class = new ReflectionClass($this);
        $matches = array();
        if (preg_match('#' . str_replace('/', '[\\\/]', '/app/Plugin/([\w\d]+)/') . '#', $class->getFileName(), $matches)) {
            return $matches[1];
        }
        return null;
    }

    /**
     * Updates floats to make them db friendly, based on their db field type.
     * -commas become dots
     * -plus signs are removed
     * -0 is appened to a direct float (eg.: ".52 => 0.52", "-.42 => -0.42")
     * -white spaces are trimmed
     */
    public function checkFloats()
    {
        foreach ($this->_schema as $fieldName => $fieldProperties) {
            $tmpType = $fieldProperties['type'];
            if ($tmpType == "float" || $tmpType == "number" || $tmpType == "float_positive" || $tmpType == "decimal") {
                // Manage float record
                if (isset($this->data[$this->alias][$fieldName])) {
                    $this->data[$this->alias][$fieldName] = str_replace(",", ".", $this->data[$this->alias][$fieldName]);
                    $this->data[$this->alias][$fieldName] = str_replace(" ", "", $this->data[$this->alias][$fieldName]);
                    $this->data[$this->alias][$fieldName] = str_replace("+", "", $this->data[$this->alias][$fieldName]);
                    if (is_numeric($this->data[$this->alias][$fieldName])) {
                        if (strpos($this->data[$this->alias][$fieldName], ".") === 0)
                            $this->data[$this->alias][$fieldName] = "0" . $this->data[$this->alias][$fieldName];
                        if (strpos($this->data[$this->alias][$fieldName], "-.") === 0)
                            $this->data[$this->alias][$fieldName] = "-0" . substr($this->data[$this->alias][$fieldName], 1);
                    }
                }
            }
        }
    }

    /**
     *
     * @param $sql
     * @param bool $cache
     * @return mixed
     */
    public function tryCatchQuery($sql, $cache = false)
    {
        try {
            return parent::query($sql, $cache);
        } catch (Exception $e) {
            if (Configure::read('debug') > 0) {
                pr('QUERY ERROR:');
                pr($sql);
                pr(AppController::getStackTrace());
                exit();
            } else {
                AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
        }
    }

    /**
     * Will sort data based on the given primary key order.
     *
     * @param array $data The data to sort.
     * @param array|string $order The ordered pkeys in either an array or a comma separated string.
     */
    public function sortForDisplay(array &$data, $order)
    {
        $tmpData = AppController::defineArrayKey($data, $this->name, $this->primaryKey, true);
        if (is_string($order)) {
            $order = explode(',', $order);
        }
        $order = array_unique(array_filter($order));
        $data = array();
        foreach ($order as $key) {
            $data[] = $tmpData[$key];
        }
        unset($tmpData);
    }

    public static function acquireBatchViewsUpdateLock()
    {
        if (self::$lockedViewsUpdate) {
            throw new Exception('Deadlock in acquireBatchViewsUpdateLock');
        }
        self::$lockedViewsUpdate = true;
    }

    /**
     *
     * @param $modelTable
     * @param $foreignKey
     * @param $ids
     * @param $queryPart
     */
    public static function manageViewUpdate($modelTable, $foreignKey, $ids, $queryPart)
    {
        if (self::$lockedViewsUpdate) {
            if (! isset(self::$cachedViewsUpdate[$modelTable])) {
                self::$cachedViewsUpdate[$modelTable] = array();
            }
            if (! isset(self::$cachedViewsUpdate[$modelTable][$foreignKey])) {
                self::$cachedViewsUpdate[$modelTable][$foreignKey] = array();
            }
            if (! isset(self::$cachedViewsUpdate[$modelTable][$foreignKey][$queryPart])) {
                self::$cachedViewsUpdate[$modelTable][$foreignKey][$queryPart] = array(
                    "ids" => array()
                );
            }
            self::$cachedViewsUpdate[$modelTable][$foreignKey][$queryPart]["ids"] = array_merge(self::$cachedViewsUpdate[$modelTable][$foreignKey][$queryPart]["ids"], $ids);
        } else {
            $tableQuery = str_replace('%%WHERE%%', 'AND ' . $foreignKey . ' IN (' . implode(',', $ids) . ')', $queryPart);
            $query = sprintf('REPLACE INTO %s (%s)', $modelTable, $tableQuery);
            $pages = AppModel::getInstance("", "Page");
            $pages->tryCatchquery($query);
        }
    }

    public static function releaseBatchViewsUpdateLock()
    {
        // just "some" model to do the work
        $pages = AppModel::getInstance("", "Page");
        foreach (self::$cachedViewsUpdate as $modelTable => $models) {
            foreach ($models as $foreignKey => $queryParts) {
                foreach ($queryParts as $queryPart => $details) {
                    $tableQuery = str_replace('%%WHERE%%', 'AND ' . $foreignKey . ' IN(' . implode(",", array_unique($details['ids'])) . ')', $queryPart);
                    $query = sprintf('REPLACE INTO %s (%s)', $modelTable, $tableQuery);
                    $pages->tryCatchquery($query);
                }
            }
        }
        foreach (self::$cachedViewsDelete as $modelTable => $models) {
            foreach ($models as $primaryKey => $details) {
                $query = sprintf('DELETE FROM %s  WHERE %s IN (%s)', $modelTable, $primaryKey, implode(',', array_unique($details['pkeys_for_deletion']))); // To fix issue#2980: Edit Storage & View Update
                $pages->tryCatchquery($query);
            }
        }
        foreach (self::$cachedViewsInsert as $modelTable => $baseModels) {
            foreach ($baseModels as $baseModel => $queryParts) {
                foreach ($queryParts as $queryPart => $details) {
                    $tableQuery = str_replace('%%WHERE%%', 'AND ' . $baseModel . '.id IN(' . implode(", ", array_unique($details['ids'])) . ')', $queryPart);
                    $query = sprintf('INSERT INTO %s (%s)', $modelTable, $tableQuery);
                    $pages->tryCatchquery($query);
                }
            }
        }
        self::$cachedViewsUpdate = array();
        self::$cachedViewsDelete = array();
        self::$cachedViewsInsert = array();
        self::$lockedViewsUpdate = false;
    }

    /**
     *
     * @return mixed
     */
    public static function getRemoteIPAddress()
    {
        return (! empty($_SERVER['HTTP_CLIENT_IP'])) ? $_SERVER['HTTP_CLIENT_IP'] : ((! empty($_SERVER['HTTP_X_FORWARDED_FOR'])) ? $_SERVER['HTTP_X_FORWARDED_FOR'] : $_SERVER['REMOTE_ADDR']);
    }
}