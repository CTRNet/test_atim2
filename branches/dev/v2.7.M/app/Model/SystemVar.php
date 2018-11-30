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
 * Class SystemVar
 */
class SystemVar extends Model
{

    public $primaryKey = 'k';

    private static $cache = array();

    /**
     *
     * @param $key
     * @return array|mixed|null
     */
    public function getVar($key)
    {
        if (isset(self::$cache[$key])) {
            return self::$cache[$key];
        }
        
        $val = $this->find('first', array(
            'conditions' => array(
                'k' => $key
            )
        ));
        if ($val) {
            $val = $val['SystemVar']['v'];
            self::$cache[$key] = $val;
        }
        return $val;
    }

    /**
     *
     * @param $key
     * @param $val
     */
    public function setVar($key, $val)
    {
        $this->save(array(
            'k' => $key,
            'v' => $val
        ));
        self::$cache[$key] = $val;
    }
}