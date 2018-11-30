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
 * Class FamilyHistory
 */
class FamilyHistory extends ClinicalAnnotationAppModel
{

    /**
     *
     * @param array $variables
     * @return bool
     */
    public function summary($variables = array())
    {
        $return = false;
        
        // if ( isset($variables['FamilyHistory.id']) ) {
        //
        // $result = $this->find('first', array('conditions'=>array('FamilyHistory.id'=>$variables['FamilyHistory.id'])));
        //
        // $return = array(
        // 'data' => $result,
        // 'structure alias'=>'familyhistories'
        // );
        // }
        
        return $return;
    }

    /**
     * Replaces icd10 empty string to null values to respect foreign keys constraints
     *
     * @param $participantArray
     */
    public function patchIcd10NullValues(&$participantArray)
    {
        if (array_key_exists('primary_icd10_code', $participantArray['FamilyHistory']) && strlen(trim($participantArray['FamilyHistory']['primary_icd10_code'])) == 0) {
            $participantArray['FamilyHistory']['primary_icd10_code'] = null;
        }
    }
}