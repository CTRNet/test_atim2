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
 * Class Report
 */
class Report extends DatamartAppModel
{

    public $useTable = 'datamart_reports';

    /**
     *
     * @param array $variables
     * @return array
     */
    public function summary($variables = array())
    {
        $return = array();
        
        if (isset($variables['Report.id']) && (! empty($variables['Report.id']))) {
            $reportData = $this->find('first', array(
                'conditions' => array(
                    'Report.id' => $variables['Report.id']
                ),
                'recursive' => - 1
            ));
            $reportData['Report']['name'] = __($reportData['Report']['name']);
            $reportData['Report']['description'] = __($reportData['Report']['description']);
            if (! empty($reportData)) {
                $return = array(
                    'menu' => array(
                        null,
                        $reportData['Report']['name']
                    ),
                    'title' => array(
                        null,
                        $reportData['Report']['name']
                    ),
                    'structure alias' => 'reports',
                    'data' => $reportData
                );
            }
        }
        
        return $return;
    }
}