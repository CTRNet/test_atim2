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
App::uses('ModelBehavior', 'Model');
App::uses('I18n', 'I18n');
App::uses('I18nModel', 'Model');

/**
 * Class OrderByTranslateBehavior
 */
class OrderByTranslateBehavior extends ModelBehavior
{

    private $modelsFieldsAssoc = array();

    /**
     *
     * @param Model $model
     * @param array $config
     */
    public function setup(Model $model, $config = array())
    {
        $current = array();
        foreach ($config as $value) {
            $s = explode(".", $value);
            if (count($s) == 1) {
                $current[] = $model->name . "." . $value;
            } elseif (count($s) == 2) {
                assert($s[0] == $model->name) or die("Left side should be model name in " . $value);
                $current[] = $value;
            } else {
                die("Invalid field " . $value);
            }
        }
        $this->modelsFieldsAssoc[$model->name] = $current;
    }

    /**
     *
     * @param Model $model
     * @param array $query
     * @return array
     */
    public function beforeFind(Model $model, $query)
    {
        $index = 0;
        if (is_array($query['order'])) {
            $query['order'] = array_filter($query['order']);
        }
        $c = count($query['order']);
        if ($c == 0) {
            // do nothing
            return $query;
        }
        assert($c == 1) or die("Only supports a single order by");
        $value = isset($query['order'][0]) && is_array($query['order'][0]) ? $query['order'][0] : $query['order'];
        foreach ($value as $key => $direction) {
            if (is_int($key)) {
                if (strpos($direction, " ") !== false) {
                    list ($key, $direction) = explode(" ", $direction);
                } else {
                    $key = $direction;
                    $direction = "";
                }
            }
            if (in_array($key, $this->modelsFieldsAssoc[$model->name])) {
                $query['joins'][] = array(
                    'table' => 'i18n',
                    'alias' => 'i18n',
                    'type' => 'LEFT',
                    'conditions' => array(
                        sprintf('%s=i18n.id', $key)
                    )
                );
                $lang = substr(CakeSession::read('Config.language'), 0, 2);
                $query['order'][0] = array(
                    'i18n.' . $lang => $direction
                );
            }
        }
        return $query;
    }
}