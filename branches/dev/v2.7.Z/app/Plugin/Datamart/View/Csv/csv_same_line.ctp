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
// used by browser
header('Content-Type: application/csv');
$csv = $this->Csv;

if ($csvHeader) {
    $csv::$nodesInfo = $nodesInfo;
    $csv::$structures = $structuresArray;
}
$this->Structures->build(array(), array(
    'type' => 'csv',
    'settings' => array(
        'csv_header' => $csvHeader,
        'all_fields' => AppController::getInstance()->csvConfig['type'] == 'all'
    )
));

ob_flush();