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
 * Class DatamartAppModel
 */
class DatamartAppModel extends AppModel
{

    /**
     * Builds the action dropdown actions
     *
     * @param $pluginName
     * @param string $modelName The model to use to fetch the data
     * @param string $modelPkey The key to use to fetch the data
     * @param $structureName
     * @param string $dataModel The model to look for in the data array (for csv linking)
     * @param string $dataPkey The pkey to look for in the data array (for csv linking)
     * @param int $batchSetId The id of the current batch set
     * @param boolean $addCsvAction Flag to add csv action (set to true by default)
     * @return array
     * @internal param string $plugin
     * @internal param string $structureAlias The structure to render the data* The structure to render the data
     */
    public function getDropdownOptions($pluginName, $modelName, $modelPkey, $structureName, $dataModel, $dataPkey, $batchSetId = null, $addCsvAction = true)
    {
        $batchSetModel = AppModel::getInstance("Datamart", "BatchSet", true);
        $datamartStructureModel = AppModel::getInstance("Datamart", "DatamartStructure", true);
        $datamartStructureId = $datamartStructureModel->getIdByModelName($dataModel);
        $compatibleBatchSets = $batchSetModel->getCompatibleBatchSets($pluginName, $modelName, $datamartStructureId, $batchSetId);
        $batchSetMenu[] = array(
            'value' => '0',
            'label' => __('create batchset'),
            'value' => 'Datamart/BatchSets/add/'
        );
        $addToBatchSetMenu = array();
        $compareToBatchSetMenu = array();
        foreach ($compatibleBatchSets as $batchSet) {
            $batchSetLabel = str_replace(array(
                '  ',
                "\t",
                "\n",
                "\r"
            ), ' ', $batchSetModel->getBatchSetLabel($batchSet['BatchSet']));
            $addToBatchSetMenu[] = array(
                'value' => '0',
                'label' => $batchSetLabel,
                'value' => 'Datamart/BatchSets/add/' . $batchSet['BatchSet']['id']
            );
            $compareToBatchSetMenu[] = array(
                'value' => '0',
                'label' => $batchSetLabel,
                'value' => 'Datamart/Reports/compareToBatchSetOrNode/batchset/' . $batchSet['BatchSet']['id']
            );
        }
        $batchSetMenu[] = array(
            'value' => '0',
            'label' => __('add to compatible batchset'),
            'children' => $addToBatchSetMenu
        );
        $batchSetMenu[] = array(
            'value' => '0',
            'label' => __('compare to compatible batchset'),
            'children' => $compareToBatchSetMenu
        );
        
        $result = array();
        $result[] = array(
            'value' => '0',
            'label' => __('batchset'),
            'children' => $batchSetMenu
        );
        
        $structureFunctions = AppModel::getInstance("Datamart", "DatamartStructureFunction", true);
        $functions = $structureFunctions->find('all', array(
            'conditions' => array(
                'DatamartStructureFunction.datamart_structure_id' => $datamartStructureId,
                'DatamartStructureFunction.flag_active' => true
            )
        ));
        if (count($functions)) {
            $functionsMenu = array();
            foreach ($functions as $function) {
                if (AppController::checkLinkPermission($function['DatamartStructureFunction']['link'])) {
                    $functionsMenu[] = array(
                        'value' => '0',
                        'label' => __($function['DatamartStructureFunction']['label']),
                        'value' => substr($function['DatamartStructureFunction']['link'], 1)
                    );
                }
            }
            if ($functionsMenu) {
                $result[] = array(
                    'value' => '0',
                    'label' => __('batch actions / reports'),
                    'children' => $functionsMenu
                );
            }
        }
        if ($addCsvAction) {
            $csvAction = 'Datamart/Csv/csv/%d/plugin:' . $pluginName . '/model:' . $modelName . '/modelPkey:' . $modelPkey . '/structure:' . $structureName . '/';
            if (strlen($dataModel)) {
                $csvAction .= 'dataModel:' . $dataModel . '/';
                if (strlen($dataPkey)) {
                    $csvAction .= 'dataPkey:' . $dataPkey . '/';
                }
            }
            $csvAction = "javascript:setCsvPopup('$csvAction');";
            $result[] = array(
                'value' => '0',
                'label' => __('export as CSV file (comma-separated values)'),
                'value' => sprintf($csvAction, 0)
            );
        }
        return $result;
    }
}