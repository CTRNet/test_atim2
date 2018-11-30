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
$structureLinks = array(
    'index' => array(
        'detail' => '/Sop/SopExtends/detail/' . $atimMenuVariables['SopMaster.id'] . '/%%SopExtend.id%%/'
    ),
    'bottom' => array(
        'add' => '/Sop/SopExtends/add/' . $atimMenuVariables['SopMaster.id'] . '/'
    )
);

$structureOverride = array(
    'SopExtend.material_id' => $materialList
);
$this->Structures->build($atimStructure, array(
    'type' => 'index',
    'links' => $structureLinks,
    'override' => $structureOverride
));