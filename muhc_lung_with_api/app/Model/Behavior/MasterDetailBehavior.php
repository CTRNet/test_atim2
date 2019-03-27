<?php

/**
 * Class MasterDetailBehavior
 */
class MasterDetailBehavior extends ModelBehavior
{

    public $__settings = array();

    /**
     *
     * @param Model $model
     * @param array $config
     */
    public function setup(Model $model, $config = array())
    {
        if (strpos($model->alias, 'Master') || strpos($model->alias, 'Control') || (isset($model->baseModel) && strpos($model->baseModel, 'Master'))) {
            $modelToUse = null;
            if (isset($model->baseModel)) {
                $modelToUse = AppModel::getInstance($model->basePlugin, $model->baseModel);
            } else {
                $modelToUse = $model;
            }
            
            $defaultClass = $modelToUse->alias;
            $defaultClass = str_replace('Master', '', $defaultClass);
            $defaultClass = str_replace('Control', '', $defaultClass);
            
            $masterClass = $defaultClass . 'Master';
            $masterForeign = Inflector::singularize($modelToUse->table) . '_id';
            
            $controlClass = $defaultClass . 'Control';
            $controlForeign = str_replace('master', 'control', Inflector::singularize($modelToUse->table) . '_id');
            
            $detailClass = $defaultClass . 'Detail';
            $detailTablename = 'detail_tablename';
            $formAlias = 'form_alias';
            
            $isMasterModel = $masterClass == $modelToUse->alias ? true : false;
            $isControlModel = $controlClass == $modelToUse->alias ? true : false;
            $isView = strpos($model->alias, 'View') !== false;
            
            $default = array(
                'master_class' => $masterClass,
                'master_foreign' => $masterForeign,
                
                'control_class' => $controlClass,
                'control_foreign' => $controlForeign,
                
                'detail_class' => $detailClass,
                'detail_field' => $detailTablename,
                'form_alias' => $formAlias,
                
                'is_master_model' => $isMasterModel,
                'is_control_model' => $isControlModel,
                'is_view' => $isView,
                
                'default_class' => $defaultClass
            );
            if ($isControlModel) {
                // for control models, add a virtual field with the full form alias
                $schema = $model->schema();
                if (isset($schema['detail_form_alias'])) {
                    $model->virtualFields['form_alias'] = isset($model->masterFormAlias) ? 'CONCAT("' . $model->masterFormAlias . ',",' . $model->alias . '.detail_form_alias)' : $model->alias . '.detail_form_alias';
                }
            }
        } else {
            
            $default = array(
                'is_master_model' => false,
                'is_control_model' => false,
                'is_view' => strpos($model->alias, 'View') !== false
            );
        }
        
        if (! isset($this->__settings[$model->alias])) {
            $this->__settings[$model->alias] = $default;
        }
        $this->__settings[$model->alias] = am($this->__settings[$model->alias], is_array($config) ? $config : array());
    }

    /**
     *
     * @param Model $model
     * @param mixed $results
     * @param bool $primary
     * @return mixed
     */
    public function afterFind(Model $model, $results, $primary = false)
    {
        // make all SETTINGS into individual VARIABLES, with the KEYS as names
        extract(AppController::convertArrayKeyFromSnakeToCamel($this->__settings[$model->alias]));
        if ($isMasterModel) {
            // set DETAIL if more than ONE result
            if ($primary && isset($results[0][$controlClass][$detailField]) && $model->recursive > 0) {
                $grouping = array(); // group by ctrl ids
                foreach ($results as $key => &$result) {
                    if (! isset($results[$key][$detailClass])) { // the detail model is already defined if it was a find on a specific control_id
                        $detailModelCacheKey = $detailClass . "." . $result[$controlClass][$detailField];
                        if (! isset($grouping[$detailModelCacheKey])) {
                            // caching model (its rougly as fast as grouping queries by detail, see eventum 1120)
                            $grouping[$detailModelCacheKey]['model'] = new AppModel(array(
                                'table' => $result[$controlClass][$detailField],
                                'name' => $detailClass,
                                'alias' => $detailClass . '_' . $result[$controlClass][$detailField]
                            ));
                            $grouping[$detailModelCacheKey]['id_to_index'] = array();
                        }
                        $grouping[$detailModelCacheKey]['id_to_index'][$result[$model->alias][$model->primaryKey]] = $key;
                    }
                }
                
                // data fetch and assoc
                foreach ($grouping as $group) {
                    $idToIndex = $group['id_to_index'];
                    $detailData = $group['model']->find('all', array(
                        'conditions' => array(
                            $masterForeign => array_keys($idToIndex)
                        ),
                        'recursive' => - 1
                    ));
                    $detailDataAlias = $group['model']->name . '_' . $group['model']->table;
                    foreach ($detailData as $detailUnit) {
                        $results[$idToIndex[$detailUnit[$detailDataAlias][$masterForeign]]][$detailClass] = $detailUnit[$detailDataAlias];
                    }
                }
            } elseif (isset($results[$controlClass][$detailField]) && ! isset($results[$detailClass])) {
                // set DETAIL if ONLY one result
                $associated = array();
                
                $detailModel = new AppModel(array(
                    'table' => $results[$controlClass][$detailField],
                    'name' => $detailClass,
                    'alias' => $detailClass,
                    'alias' => $detailClass
                ));
                
                $associated = $detailModel->find(array(
                    $masterForeign => $results[0][$model->alias]['id']
                ), null, null, - 1);
                $results[$detailClass] = $associated[$detailClass];
            }
            
            if ($model->previousModel != null) {
                // a detailed search occured, restore the original model in case it contained some variables that were not copied in the
                // model associated with details
                $model = $model->previousModel;
            }
        }
        return $results;
    }

    /**
     * If there is a single control id condition, returns the id, otherwise
     * false
     *
     * @param Model $model
     * @param unknown $query
     * @return mixed
     */
    public function getSingleControlIdCondition(Model $model, $query)
    {
        extract(AppController::convertArrayKeyFromSnakeToCamel($this->__settings[$model->alias]));
        if (is_array($query['conditions']) && array_key_exists($model->name . "." . $controlForeign, $query['conditions']) && count($query['conditions'][$model->name . "." . $controlForeign]) == 1) {
            return $query['conditions'][$model->name . "." . $controlForeign];
        }
        return false;
    }

    /**
     *
     * @param Model $model
     * @param $controlId
     * @param null $alternateModelName
     * @return array
     */
    public function getDetailJoin(Model $model, $controlId, $alternateModelName = null)
    {
        extract(AppController::convertArrayKeyFromSnakeToCamel($this->__settings[$model->alias]));
        assert($isMasterModel) or die("getDetailJoin can only be called from master model");
        if ($alternateModelName === null) {
            $modelName = $model->name;
            $detailName = $detailClass;
        } else {
            $modelName = $alternateModelName;
            // Use preg_match to fix issue #3287
            if (preg_match('/Master/', $alternateModelName)) {
                $detailName = str_replace("Master", "Detail", $alternateModelName);
            } elseif (preg_match('/^([0-9]+_)/', $alternateModelName, $matches)) {
                $detailName = $matches[1] . $detailClass;
            } else {
                $detailName = $alternateModelName . 'Detail';
            }
        }
        $detailControlName = $model->belongsTo[$defaultClass . "Control"]['className'];
        $plugin = '';
        if (strpos($detailControlName, '.') !== false) {
            list ($plugin, $detailControlName) = explode('.', $detailControlName);
        }
        $detailControl = AppModel::getInstance($plugin, $detailControlName, true);
        $detailInfo = $detailControl->find('first', array(
            'conditions' => array(
                $detailControl->name . ".id" => $controlId
            )
        ));
        assert($detailInfo) or die("detail_info is empty");
        $detailInfo = $detailInfo[$detailControlName];
        return array(
            'table' => $detailInfo['detail_tablename'],
            'alias' => $detailName,
            'type' => 'LEFT',
            'conditions' => array(
                $modelName . "." . $model->primaryKey . " = " . $detailName . "." . $masterForeign
            )
        );
    }

    /**
     *
     * @param Model $model
     * @param array $query
     * @return array|void
     */
    public function beforeFind(Model $model, $query)
    {
        // make all SETTINGS into individual VARIABLES, with the KEYS as names
        extract(AppController::convertArrayKeyFromSnakeToCamel($this->__settings[$model->alias]));
        if ($isMasterModel) {
            if (isset($model->$detailClass) && isset($model->$detailClass->table)) {
                // binding already done via AppController::buildDetailBinding
                return;
            }
            // this is a master/detail. See if the find is made on a specific control id. If so, join the detail table
            $controlId = $model->getSingleControlIdCondition($query);
            if ($controlId !== false) {
                $detailJoin = $model->getDetailJoin($controlId);
                foreach ($query['joins'] as $newJoinToCheck)
                    if ($detailJoin['alias'] == $newJoinToCheck['alias'])
                        $detailJoin = null;
                if ($detailJoin)
                    $query['joins'][] = $detailJoin;
            }
        }
        return $query;
    }

    /**
     *
     * @param Model $model
     * @param bool $created
     * @param array $options
     * @return bool|mixed
     */
    public function afterSave(Model $model, $created, $options = array())
    {
        // make all SETTINGS into individual VARIABLES, with the KEYS as names
        extract(AppController::convertArrayKeyFromSnakeToCamel($this->__settings[$model->alias]));
        if (! $isView && ($isMasterModel || $isControlModel)) {
            // get DETAIL table name and create DETAIL model object
            $associated = $model->find('first', array(
                'conditions' => array(
                    $masterClass . '.id' => $model->id,
                    $masterClass . '.deleted' => array(
                        '0',
                        '1'
                    )
                ),
                'recursive' => 0
            ));
            assert($associated) or die('MasterDetailBehavior afterSave failed to fetch control details');
            $table = $associated[$controlClass][$detailField];
            $detailModel = new AppModel(array(
                'table' => $table,
                'name' => $detailClass,
                'alias' => $detailClass . '_' . $table,
                'primaryKey' => $masterForeign
            ));
            $detailModel->writableFieldsMode = $model->writableFieldsMode;
            $detailModel->checkWritableFields = $model->checkWritableFields;
            $detailModel->primaryKey = $masterForeign;
            foreach ($detailModel->actsAs as $key => $data) {
                if (is_array($data)) {
                    $behavior = $key;
                    $config = $data;
                } else {
                    $behavior = $data;
                    $config = null;
                }
                $detailModel->Behaviors->load($behavior, $config);
                $detailModel->Behaviors->$behavior->setup($detailModel, $config);
            }
            
            $detailModel->id = $model->id;
            $model->data[$detailClass][$masterForeign] = $model->id;
            $detailModel->versionId = $model->versionId;
            
            // save detail DATA
            if ((isset($detailModel->id) && $detailModel->id && ! $created) || $created) {
                $result = $detailModel->save($model->data[$detailClass], false); // validation should have already been done
            } else {
                $result = true;
            }
            
            return $result;
        } else {}
    }

    /**
     *
     * @param Model $model
     * @param bool $cascade
     * @return bool
     */
    public function beforeDelete(Model $model, $cascade = true)
    {
        // make all SETTINGS into individual VARIABLES, with the KEYS as names
        extract(AppController::convertArrayKeyFromSnakeToCamel($this->__settings[$model->alias]));
        
        if ($isMasterModel && ! isset($model->baseModel)) {
            // get DETAIL table name and create DETAIL model object
            $prevData = $model->data;
            $associated = $model->read();
            $detailModel = new AppModel(array(
                'table' => $associated[$controlClass][$detailField],
                'name' => $detailClass,
                'alias' => $detailClass
            ));
            $detailModel->Behaviors->Revision->setup($detailModel);
            // set ID (for edit, blank for add) and model object NAME/ALIAS for save
            if (isset($associated[$detailClass]) && count($associated[$detailClass])) {
                $detailModel->id = $associated[$detailClass]['id'];
            }
            
            // delete detail DATA
            $result = $detailModel->atimDelete($detailModel->id);
            
            $model->data = $prevData;
            
            return $result;
        }
        
        return true;
    }

    /**
     *
     * @param Model $model
     * @return null
     */
    public function getControlName(Model $model)
    {
        if (isset($model->baseModel)) {
            $model = AppModel::getInstance($model->basePlugin, $model->baseModel, true);
        }
        return isset($this->__settings[$model->alias]['control_class']) ? $this->__settings[$model->alias]['control_class'] : null;
    }

    /**
     *
     * @param Model $model
     * @return null
     */
    public function getControlForeign(Model $model)
    {
        if (isset($model->baseModel)) {
            $model = AppModel::getInstance($model->basePlugin, $model->baseModel, true);
        }
        return isset($this->__settings[$model->alias]['control_foreign']) ? $this->__settings[$model->alias]['control_foreign'] : null;
    }

    /**
     * Meant to counter the fact that behavior afterFind is NOT called for non primary models
     * and to manually add the form_alias since virutalFields do not work for associated
     * models.
     *
     * @param Model $model
     * @param unknown_type $results
     * @param unknown_type $primary
     * @return unknown_type
     */
    public function applyMasterFormAlias(Model $model, $results, $primary)
    {
        if (! $primary && isset($results[0][$model->alias]['detail_form_alias'])) {
            foreach ($results as &$row) {
                $row[$model->alias]['form_alias'] = $model->masterFormAlias . ',' . $row[$model->alias]['detail_form_alias'];
            }
        }
        return $results;
    }

    /**
     *
     * @param $model
     * @param $controlId
     * @return AppModel
     * @throws Exception
     */
    public function getDetailModel($model, $controlId)
    {
        extract(AppController::convertArrayKeyFromSnakeToCamel($this->__settings[$model->alias]));
        if (! $isMasterModel) {
            throw new Exception("Must be called from master model");
        }
        
        $detailControlName = $model->belongsTo[$defaultClass . "Control"]['className'];
        $plugin = '';
        if (strpos($detailControlName, '.') !== false) {
            list ($plugin, $detailControlName) = explode('.', $detailControlName);
        }
        $detailControl = AppModel::getInstance($plugin, $detailControlName, true);
        $detailInfo = $detailControl->find('first', array(
            'conditions' => array(
                $detailControl->name . ".id" => $controlId
            )
        ));
        return new AppModel(array(
            'table' => $detailInfo[$detailControl->name]['detail_tablename'],
            'name' => $detailClass,
            'alias' => $detailClass
        ));
    }
}