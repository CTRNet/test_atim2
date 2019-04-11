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
 * Class Material
 */
class Material extends AppModel
{

    public $name = 'Material';

    public $useTable = 'materials';

    /**
     *
     * @param array $variables
     * @return array|bool
     */
    public function summary($variables = array())
    {
        $return = false;
        
        if (isset($variables['Material.id'])) {
            
            $result = $this->find('first', array(
                'conditions' => array(
                    'Material.id' => $variables['Material.id']
                )
            ));
            
            $return = array(
                'menu' => array(
                    null,
                    $result['Material']['item_name']
                ),
                'title' => array(
                    null,
                    $result['Material']['item_name']
                ),
                'data' => $result,
                'structure alias' => 'materials'
            );
        }
        
        return $return;
    }
}