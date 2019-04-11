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
 * Class StructurePermissibleValuesCustom
 */
class StructurePermissibleValuesCustom extends AppModel
{

    public $name = 'StructurePermissibleValuesCustom';

    public $belongsTo = array(
        'StructurePermissibleValuesCustomControl' => array(
            'className' => 'StructurePermissibleValuesCustomControl',
            'foreignKey' => 'control_id'
        )
    );

    private static $instance = null;

    protected static $lang = null;

    /**
     *
     * @return null|string
     */
    static protected function getLanguage()
    {
        if (self::$lang == null) {
            $tmpL10n = new L10n();
            $tmpL10nMap = $tmpL10n->map();
            self::$lang = isset($tmpL10nMap[$_SESSION['Config']['language']]) ? $tmpL10nMap[$_SESSION['Config']['language']] : '';
        }
        return self::$lang;
    }

    /**
     *
     * @param array $args
     * @return array
     */
    public function getCustomDropdown(array $args)
    {
        $controlName = null;
        if (sizeof($args) == 1) {
            $controlName = $args['0'];
        }
        
        $lang = self::getLanguage();
        if (! $lang)
            $lang = 'en';
        
        if (self::$instance == null) {
            self::$instance = new StructurePermissibleValuesCustom();
            self::$instance->cacheQueries = true;
        }
        $conditions = array(
            'StructurePermissibleValuesCustomControl.name' => $controlName
        );
        $data = self::$instance->find('all', array(
            'conditions' => $conditions,
            'order' => array(
                'StructurePermissibleValuesCustom.display_order',
                'StructurePermissibleValuesCustom.' . $lang
            )
        ));
        $result = array(
            "defined" => array(),
            "previously_defined" => array()
        );
        if (empty($data)) {
            return $result;
        }
        
        $result = array(
            "defined" => array(),
            "previously_defined" => array()
        );
        foreach ($data as $dataUnit) {
            $value = $dataUnit['StructurePermissibleValuesCustom']['value'];
            $translatedValue = (isset($dataUnit['StructurePermissibleValuesCustom'][$lang]) && (! empty($dataUnit['StructurePermissibleValuesCustom'][$lang]))) ? $dataUnit['StructurePermissibleValuesCustom'][$lang] : $value;
            if ($dataUnit['StructurePermissibleValuesCustom']['use_as_input']) {
                $result['defined'][$value] = $translatedValue;
            } else {
                $result['previously_defined'][$value] = $translatedValue;
            }
        }
        if ($data[0]['StructurePermissibleValuesCustom']['display_order'] == 0) {
            // sort alphabetically
            natcasesort($result['defined']);
            natcasesort($result['previously_defined']);
        }
        
        return $result;
    }

    /**
     *
     * @param $controlName
     * @param $value
     * @return bool
     */
    public function getTranslatedCustomDropdownValue($controlName, $value)
    {
        $lang = self::getLanguage();
        
        if (self::$instance == null) {
            self::$instance = new StructurePermissibleValuesCustom();
            self::$instance->cacheQueries = true;
        }
        $conditions = array(
            'StructurePermissibleValuesCustomControl.name' => $controlName,
            'StructurePermissibleValuesCustom.value' => $value
        );
        $data = self::$instance->find('first', array(
            'conditions' => $conditions
        ));
        if (empty($data)) {
            return false;
        }
        return (isset($data['StructurePermissibleValuesCustom'][$lang]) && (! empty($data['StructurePermissibleValuesCustom'][$lang]))) ? $data['StructurePermissibleValuesCustom'][$lang] : $value;
    }

    /**
     *
     * @param bool $created
     * @param array $options
     */
    public function afterSave($created, $options = array())
    {
        $controlId = null;
        if (isset($this->data['StructurePermissibleValuesCustom']['control_id'])) {
            $controlId = $this->data['StructurePermissibleValuesCustom']['control_id'];
        } elseif ($this->id) {
            $controlId = $this->find('first', array(
                'conditions' => array(
                    'StructurePermissibleValuesCustom.id' => $this->id
                ),
                'fields' => array(
                    'StructurePermissibleValuesCustom.control_id'
                )
            ));
            $controlId = $controlId['StructurePermissibleValuesCustom']['control_id'];
        }
        if ($controlId) {
            $valuesCounter = $this->find('count', array(
                'conditions' => array(
                    'StructurePermissibleValuesCustom.control_id' => $controlId
                )
            ));
            $valuesUsedAsInputCounter = $this->find('count', array(
                'conditions' => array(
                    'StructurePermissibleValuesCustom.control_id' => $controlId,
                    'StructurePermissibleValuesCustom.use_as_input' => '1'
                )
            ));
            $structurePermissibleValuesCustomControl = AppModel::getInstance('', 'StructurePermissibleValuesCustomControl');
            $this->tryCatchQuery("UPDATE structure_permissible_values_custom_controls SET values_counter = $valuesCounter, values_used_as_input_counter = $valuesUsedAsInputCounter WHERE id = $controlId;");
        }
        parent::afterSave($created, $options);
    }
}