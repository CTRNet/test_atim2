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
 * Class ReproductiveHistory
 */
class ReproductiveHistory extends ClinicalAnnotationAppModel
{

    /**
     *
     * @param array $variables
     * @return bool
     */
    public function summary($variables = array())
    {
        $return = false;
        
        // if ( isset($variables['ReproductiveHistory.id']) ) {
        //
        // $result = $this->find('first', array('conditions'=>array('ReproductiveHistory.id'=>$variables['ReproductiveHistory.id'])));
        //
        // $return = array(
        // 'data' => $result,
        // 'structure alias'=>'reproductivehistories'
        // );
        // }
        
        return $return;
    }
}