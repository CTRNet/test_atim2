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
if (empty($permissionDenied)){
    $structureOverride = array(
        'Config.config_language' => $_SESSION['Config']['language'],
        'Config.define_csv_separator' => CSV_SEPARATOR,
        'Config.define_csv_encoding' => CSV_ENCODING
    );
    $this->Structures->build($atimStructure, array(
        'type' => 'add',
        'links' => array(
            'top' => 'Datamart/Csv/csv/'
        ),
        'override' => $structureOverride,
        'settings' => array(
            'actions' => false
        )
    ));
}