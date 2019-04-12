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
 * This behavior is used to define a minimum on certain view fields when a max is defined.
 * It's useful for spent time calculation because spentTime >= 0 means the value is
 * valid, but spentTime < 0 is an error code. When searching with only a max criterion
 * <= x, results < 0 (errors) must not be returned. This behavior is here to add the
 * minimum >= 0 clause if the minimum is not specified.
 */
class MinMaxBehavior extends ModelBehavior
{

    /**
     *
     * @param Model $model
     * @param array $query
     * @return array
     */
    public function beforeFind(Model $model, $query)
    {
        if (isset($query['conditions'])) {
            $toFix = array(); // contains the model -> fields to fix.
            if (isset($model->registeredView)) {
                // if views are attached, parse each of them
                foreach ($model->registeredView as $pluginModel => $foo) {
                    list ($plugin, $modelName) = explode('.', $pluginModel);
                    $registeredModel = AppModel::getInstance($plugin, $modelName);
                    if (isset($registeredModel::$minValueFields)) {
                        $toFix[$registeredModel->name] = $registeredModel::$minValueFields;
                    }
                }
            } elseif (isset($model::$minValueFields)) {
                // is a view itself
                $toFix[$model->name] = $model::$minValueFields;
            }
            
            $conditions = &$query['conditions'];
            foreach ($toFix as $modelName => $fields) {
                foreach ($fields as $field) {
                    $fieldMax = $modelName . '.' . $field . ' <=';
                    $fieldMin = $modelName . '.' . $field . ' >=';
                    if (isset($conditions[$fieldMax]) && ! isset($conditions[$fieldMin]) && $conditions[$fieldMax] >= 0) {
                        $conditions[$fieldMin] = 0;
                    }
                }
            }
        }
        return $query;
    }
}