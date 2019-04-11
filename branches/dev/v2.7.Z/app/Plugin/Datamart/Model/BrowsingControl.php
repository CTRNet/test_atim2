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
 * Class BrowsingControl
 */
class BrowsingControl extends DatamartAppModel
{

    public $useTable = 'datamart_browsing_controls';

    /**
     *
     * @param $elem1Id
     * @param null $elemNId
     * @return array|null
     */
    public function find1ToN($elem1Id, $elemNId = null)
    {
        $conditions = array(
            'BrowsingControl.id2' => $elem1Id
        );
        if ($elemNId) {
            $conditions['BrowsingControl.id1'] = $elemNId;
        }
        return $this->find('all', array(
            'conditions' => $conditions
        ));
    }

    /**
     *
     * @param $elemNId
     * @param null $elem1Id
     * @return array|null
     */
    public function findNTo1($elemNId, $elem1Id = null)
    {
        $conditions = array(
            'BrowsingControl.id1' => $elemNId
        );
        if ($elem1Id) {
            $conditions['BrowsingControl.id2'] = $elem1Id;
        }
        return $this->find('all', array(
            'conditions' => $conditions
        ));
    }

    /**
     *
     * @param array $data
     */
    public function completeData(array &$data)
    {
        $datamartStructureModel = AppModel::getInstance('Datamart', 'DatamartStructure', true);
        $datamartStructures = $datamartStructureModel->find('all', array(
            'conditions' => array(
                'DatamartStructure.id' => array(
                    $data['BrowsingControl']['id1'],
                    $data['BrowsingControl']['id2']
                )
            )
        ));
        if ($data['BrowsingControl']['id1'] == $data['BrowsingControl']['id2']) {
            assert(count($datamartStructures) == 1);
            $data['DatamartStructure1'] = $datamartStructures[0]['DatamartStructure'];
            $data['DatamartStructure2'] = $datamartStructures[0]['DatamartStructure'];
        } else {
            assert(count($datamartStructures) == 2);
            if ($data['BrowsingControl']['id1'] == $datamartStructures[0]['DatamartStructure']['id']) {
                $data['DatamartStructure1'] = $datamartStructures[0]['DatamartStructure'];
                $data['DatamartStructure2'] = $datamartStructures[1]['DatamartStructure'];
            } else {
                $data['DatamartStructure1'] = $datamartStructures[1]['DatamartStructure'];
                $data['DatamartStructure2'] = $datamartStructures[0]['DatamartStructure'];
            }
        }
    }

    /**
     *
     * @param String or int $val
     * @return If the value is a model name (string), return the id of the associated DatamartStructure. Otherwise return the value itself.
     */
    private static function getBrowsingStructureId($val)
    {
        if ((int) $val == 0) {
            $datamartStructureModel = AppModel::getInstance('Datamart', 'DatamartStructure');
            $datamartStructure = $datamartStructureModel->find('first', array(
                'conditions' => array(
                    'OR' => array(
                        'DatamartStructure.model' => $val,
                        'DatamartStructure.control_master_model' => $val
                    )
                )
            ));
            assert($datamartStructure);
            $val = $datamartStructure['DatamartStructure']['id'];
        }
        return $val;
    }

    /**
     *
     * @param mixed $a Either a DatamartStructure.id or a model name of the left part of the join.
     * @param mixex $b Either a DatamartStructure.id or a model name of the right part of the join.
     * @param array $idsFilter
     * @return array The join array
     */
    public function getInnerJoinArray($a, $b, array $idsFilter = null)
    {
        $browsingStructureIdA = self::getBrowsingStructureId($a);
        $browsingStructureIdB = self::getBrowsingStructureId($b);
        $data = $this->find('first', array(
            'conditions' => array(
                'BrowsingControl.id1' => $browsingStructureIdA,
                'BrowsingControl.id2' => $browsingStructureIdB
            )
        ));
        if ($data) {
            // n to 1
            $this->completeData($data);
            $modelN = AppModel::getInstance($data['DatamartStructure1']['plugin'], $a == $data['DatamartStructure1']['control_master_model'] ? $a : $data['DatamartStructure1']['model']);
            $model1 = AppModel::getInstance($data['DatamartStructure2']['plugin'], $b == $data['DatamartStructure2']['control_master_model'] ? $b : $data['DatamartStructure2']['model']);
            $modelB = &$model1;
        } else {
            // 1 to n
            $data = $this->find('first', array(
                'conditions' => array(
                    'BrowsingControl.id2' => $browsingStructureIdA,
                    'BrowsingControl.id1' => $browsingStructureIdB
                )
            ));
            if (empty($data)) {
                AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
            assert($data);
            $this->completeData($data);
            $modelN = AppModel::getInstance($data['DatamartStructure1']['plugin'], $b == $data['DatamartStructure1']['control_master_model'] ? $b : $data['DatamartStructure1']['model']);
            $model1 = AppModel::getInstance($data['DatamartStructure2']['plugin'], $a == $data['DatamartStructure2']['control_master_model'] ? $a : $data['DatamartStructure2']['model']);
            $modelB = &$modelN;
        }
        
        $conditions = array(
            $modelN->name . '.' . $data['BrowsingControl']['use_field'] . ' = ' . $model1->name . '.' . $model1->primaryKey
        );
        if ($idsFilter) {
            $conditions[$modelB->name . '.' . $modelB->primaryKey] = $idsFilter;
        }
        
        return array(
            'table' => $modelB->table,
            'alias' => $modelB->name,
            'type' => 'INNER',
            'conditions' => $conditions
        );
    }
}