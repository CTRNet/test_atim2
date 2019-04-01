<?php

/**
 * Class Structure
 */
class Structure extends AppModel
{

    public $name = 'Structure';

    public $actsAs = array(
        'Containable'
    );

    public $hasMany = array(
        'StructureFormat' => array(
            'order' => array(
                'StructureFormat.flag_float DESC',
                'StructureFormat.display_column ASC, StructureFormat.display_order ASC'
            )
        ),
        'Sfs' => array(
            'order' => array(
                'Sfs.flag_float DESC',
                'Sfs.display_column ASC, Sfs.display_order ASC'
            )
        )
    );

    private $simple = true;

    /**
     * Structure constructor.
     */
    public function __construct()
    {
        parent::__construct();
        $this->setModeSimplified();
    }

    public function setModeComplete()
    {
        $this->contain(array(
            'StructureFormat' => array(
                'StructureField' => array(
                    'StructureValidation',
                    'StructureValueDomain'
                )
            )
        ));
        $this->simple = false;
    }

    public function setModeSimplified()
    {
        $this->contain(array(
            'Sfs' => array(
                'StructureValidation',
                'StructureValueDomain'
            )
        ));
        App::uses('StructureValidation', 'Model');
        $this->StructureValidation = new StructureValidation();
        $this->simple = true;
    }

    /**
     *
     * @param null $conditions
     * @param array $fields
     * @param null $order
     * @param null $recursive
     * @return array
     */
    public function find($conditions = null, $fields = array(), $order = null, $recursive = null)
    {
        $structure = parent::find('first', $fields, $order, $recursive);
        $rules = array();
        if ($structure) {
            $fieldsIds = array(
                0
            );
            if ($this->simple && isset($structure['Sfs'])) {
                // if recursive = -1, there is no Sfs
                foreach ($structure['Sfs'] as $sfs) {
                    $fieldsIds[] = $sfs['structure_field_id'];
                }
                $validations = $this->StructureValidation->find('all', array(
                    'conditions' => ('StructureValidation.structure_field_id IN(' . implode(", ", $fieldsIds) . ')')
                ));
                foreach ($validations as $validation) {
                    foreach ($structure['Sfs'] as &$sfs) {
                        if ($sfs['structure_field_id'] == $validation['StructureValidation']['structure_field_id']) {
                            $sfs['StructureValidation'][] = $validation['StructureValidation'];
                        }
                    }
                    unset($sfs);
                }
            }
            
            $rules = array();
            
            if (($this->simple && isset($structure['Sfs'])) || (! $this->simple && isset($structure['StructureFormat']))) {
                foreach ($structure[$this->simple ? 'Sfs' : 'StructureFormat'] as $sf) {
                    $autoValidation = isset(AppModel::$autoValidation[$sf['model']]) ? AppModel::$autoValidation[$sf['model']] : array();
                    if (! isset($rules[$sf['model']])) {
                        $rules[$sf['model']] = array();
                    }
                    $tmpType = $sf['type'];
                    $tmpRule = null;
                    $tmpMsg = null;
                    if ($tmpType == "integer") {
                        $tmpRule = VALID_INTEGER;
                        $tmpMsg = "error_must_be_integer";
                    } elseif ($tmpType == "integer_positive") {
                        $tmpRule = VALID_INTEGER_POSITIVE;
                        $tmpMsg = "error_must_be_positive_integer";
                    } elseif ($tmpType == "float" || $tmpType == "number") {
                        $tmpRule = VALID_FLOAT;
                        $tmpMsg = "error_must_be_float";
                    } elseif ($tmpType == "float_positive") {
                        $tmpRule = VALID_FLOAT_POSITIVE;
                        $tmpMsg = "error_must_be_positive_float";
                    } elseif ($tmpType == "datetime") {
                        $tmpRule = VALID_DATETIME_YMD;
                        $tmpMsg = "invalid datetime";
                    } elseif ($tmpType == "date") {
                        $tmpRule = "date";
                        $tmpMsg = "invalid date";
                    } elseif ($tmpType == "time") {
                        $tmpRule = VALID_24TIME;
                        $tmpMsg = "this is not a time";
                    }
                    if ($tmpRule != null) {
                        $sf['StructureValidation'][] = array(
                            'structure_field_id' => $sf['structure_field_id'],
                            'rule' => $tmpRule,
                            'on_action' => null,
                            'language_message' => $tmpMsg
                        );
                    }
                    if (! $this->simple) {
                        $sf['StructureValidation'] = array_merge($sf['StructureValidation'], $sf['StructureField']['StructureValidation']);
                    }
                    if (isset($sf['StructureValidation'])){
                        foreach ($sf['StructureValidation'] as $validation) {
                            $rule = array();
                            if (($validation['rule'] == VALID_FLOAT) || ($validation['rule'] == VALID_FLOAT_POSITIVE)) {
                                // To support coma as decimal separator
                                $rule[0] = $validation['rule'];
                            } elseif (strlen($validation['rule']) > 0) {
                                $rule = explode(',', $validation['rule']);
                                if ($rule[0] == 'custom') {
                                    $rule = array(
                                        'custom',
                                        substr($validation['rule'], strpos($validation['rule'], ',') + 1)
                                    );
                                }
                            }

                            if (count($rule) == 1) {
                                $rule = $rule[0];
                            } elseif (count($rule) == 0) {
                                if (Configure::read('debug') > 0) {
                                    AppController::addWarningMsg(__("the validation with id [%d] is invalid. a rule must be defined", $validation['id']));
                                }
                                continue;
                            }

                            $notEmpty = $rule == 'notBlank';
                            $ruleArray = array(
                                'rule' => $rule,
                                'allowEmpty' => ! $notEmpty
                            );

                            if ($validation['on_action']) {
                                if (in_array($validation['on_action'], array(
                                    'create',
                                    'update'
                                ))) {
                                    $ruleArray['on'] = $validation['on_action'];
                                } elseif (Configure::read('debug') > 0) {
                                    AppController::addWarningMsg('Invalid on_action for validation rule with id [' . $validation['id'] . ']. Current value: [' . $validation['on_action'] . ']. Expected: [create], [update] or empty.', true);
                                }
                            }
                            if ($validation['language_message']) {
                                $ruleArray['message'] = __($validation['language_message']);
                            } elseif ($ruleArray['rule'] == 'notBlank') {
                                $ruleArray['message'] = __("this field is required");
                            } elseif ($ruleArray['rule'] == 'isUnique') {
                                $ruleArray['message'] = __("this field must be unique");
                            }

                            if (strlen($sf['language_label']) > 0 && isset($ruleArray['message'])) {
                                $ruleArray['message'] .= " (" . __($sf['language_label']) . ")";
                            }

                            if (! isset($rules[$sf['model']][$sf['field']])) {
                                $rules[$sf['model']][$sf['field']] = array();
                            }

                            if ($notEmpty) {
                                // the not empty rule must be the first one or cakes will ignore it
                                array_unshift($rules[$sf['model']][$sf['field']], $ruleArray);
                            } else {
                                $rules[$sf['model']][$sf['field']][] = $ruleArray;
                            }
                        }
                    }
                    
                    if (isset($autoValidation[$sf['field']])) {
                        foreach ($autoValidation[$sf['field']] as $ruleArray) {
                            $ruleArray['message'] .= " (" . __($sf['language_label']) . ")";
                            $rules[$sf['model']][$sf['field']][] = $ruleArray;
                        }
                    }
                }
            }
        }
        
        return array(
            'structure' => $structure,
            'rules' => $rules
        );
    }
}