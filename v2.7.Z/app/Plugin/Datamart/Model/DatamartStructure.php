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
 * Class DatamartStructure
 */
class DatamartStructure extends DatamartAppModel
{

    public $useTable = 'datamart_structures';

    /**
     *
     * @param $modelName
     * @return null
     */
    public function getIdByModelName($modelName)
    {
        $data = $this->find('first', array(
            'conditions' => array(
                'OR' => array(
                    'model' => $modelName,
                    'control_master_model' => $modelName
                )
            ),
            'recursive' => - 1,
            'fields' => array(
                'id'
            )
        ));
        if (! empty($data)) {
            return $data['DatamartStructure']['id'];
        }
        
        return null;
    }

    /**
     *
     * @return array
     */
    public function getDisplayNameFromId()
    {
        $result = array();
        
        $data = $this->find('all', array(
            'recursive' => - 1
        ));
        foreach ($data as $newDs) {
            $result[$newDs['DatamartStructure']['id']] = __($newDs['DatamartStructure']['display_name']);
        }
        natcasesort($result);
        
        return $result;
    }

    /**
     * Retrieves the model associated to the id
     *
     * @param int $id
     * @param string $modelName If null, the model defined in the db will be used. If not, $modelName will be.
     * @return AppModel
     */
    public function getModel($id, $modelName = null)
    {
        $d = $this->findById($id);
        return AppModel::getInstance($d['DatamartStructure']['plugin'], $modelName ?  : $d['DatamartStructure']['model']);
    }

    /**
     *
     * @return array
     */
    public function getDisplayNameFromModel()
    {
        $data = $this->find('all', array(
            'conditions' => array(),
            'recursive' => - 1,
            'fields' => array(
                'DatamartStructure.model',
                'DatamartStructure.control_master_model',
                'DatamartStructure.display_name'
            )
        ));
        $results = array();
        foreach ($data as $newRecord) {
            $results[$newRecord['DatamartStructure']['model']] = __($newRecord['DatamartStructure']['display_name']);
            if (isset($newRecord['DatamartStructure']['control_master_model']))
                $results[$newRecord['DatamartStructure']['control_master_model']] = __($newRecord['DatamartStructure']['display_name']);
        }
        return $results;
    }
}