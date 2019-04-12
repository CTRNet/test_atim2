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
 * Class SopControl
 */
class SopControl extends SopAppModel
{

    public $useTable = 'sop_controls';

    public $masterFormAlias = 'sopmasters';

    /**
     *
     * @return array
     */
    public function getTypePermissibleValues()
    {
        $result = array();
        
        // Build tmp array to sort according to translated value
        foreach ($this->find('all', array(
            'conditions' => array(
                'flag_active = 1'
            )
        )) as $sopControl) {
            $result[$sopControl['SopControl']['type']] = __($sopControl['SopControl']['type']);
        }
        natcasesort($result);
        
        return $result;
    }

    /**
     *
     * @return array
     */
    public function getGroupPermissibleValues()
    {
        $result = array();
        
        // Build tmp array to sort according to translated value
        foreach ($this->find('all', array(
            'conditions' => array(
                'flag_active = 1'
            )
        )) as $sopControl) {
            $result[$sopControl['SopControl']['sop_group']] = __($sopControl['SopControl']['sop_group']);
        }
        natcasesort($result);
        
        return $result;
    }

    /**
     *
     * @param mixed $results
     * @param bool $primary
     * @return mixed
     */
    public function afterFind($results, $primary = false)
    {
        return $this->applyMasterFormAlias($results, $primary);
    }
}