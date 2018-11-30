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
 * Class Rtbform
 */
class Rtbform extends RtbFormAppModel
{

    public $name = 'Rtbform';

    public $useTable = 'rtbforms';

    /**
     *
     * @param array $variables
     * @return array|bool
     */
    public function summary($variables = array())
    {
        $return = false;
        
        if (isset($variables['Rtbform.id'])) {
            
            $result = $this->find('first', array(
                'conditions' => array(
                    'Rtbform.id' => $variables['Rtbform.id']
                )
            ));
            
            $return = array(
                'menu' => array(
                    null,
                    $result['Rtbform']['frmTitle']
                ),
                'title' => array(
                    null,
                    $result['Rtbform']['frmTitle']
                ),
                'data' => $result,
                'structure alias' => 'rtbforms'
            );
        }
        
        return $return;
    }
}