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

if ($storageControlData['StorageCtrl']['flag_active'] == 0){
    $structureLinks = array(
        'bottom' => array(
            'edit' => '/Administrate/StorageControls/edit/' . $atimMenuVariables['StorageCtrl.id'] . '/',
            'copy for new storage control' => array(
                'link' => '/Administrate/StorageControls/add/0/' . $atimMenuVariables['StorageCtrl.id'] . '/',
                'icon' => 'duplicate'
            ),
            'activate' => array(
                'link' => '/Administrate/StorageControls/changeActiveStatus/' . $atimMenuVariables['StorageCtrl.id'] . '/seeStorageLayout/',
                'icon' => 'confirm'
            ),
            'delete' => '/Administrate/StorageControls/delete/' . $atimMenuVariables['StorageCtrl.id'] . '/'
        )
    );  
} else {
    $structureLinks = array(
        'bottom' => array(
            'edit' => '/Administrate/StorageControls/edit/' . $atimMenuVariables['StorageCtrl.id'] . '/',
            'copy for new storage control' => array(
                'link' => '/Administrate/StorageControls/add/0/' . $atimMenuVariables['StorageCtrl.id'] . '/',
                'icon' => 'duplicate'
            ),
            'desactivate' => array(
                'link' => '/Administrate/StorageControls/changeActiveStatus/' . $atimMenuVariables['StorageCtrl.id'] . '/seeStorageLayout/',
                'icon' => 'confirm'
            ),
            'delete' => '/Administrate/StorageControls/delete/' . $atimMenuVariables['StorageCtrl.id'] . '/'
        )
    );

}


// 1 ** DISPLAY STORAGE CONTROL DATA **

$settings = array(
    'actions' => false
);
$finalOptions = array(
    'data' => $storageControlData,
    'type' => 'detail',
    'settings' => $settings,
    'links' => $structureLinks
);
$finalAtimStructure = $atimStructure;

$hookLink = $this->Structures->hook('detail');
if ($hookLink) {
    require ($hookLink);
}

$this->Structures->build($finalAtimStructure, $finalOptions);

// 2 ** DISPLAY STORAGE LAYOUT **

/**
 * Increments/decrements the var according to the reverseOrder option and returns true/false based on reverseOrder and the limit
 *
 * @param unknown_type $var The variable to loop on, must be null on the first iteration
 * @param unknown_type $reverseOrder True to reverse the order
 * @param unknown_type $limit The limit of the axis
 * @return true if you must continue to loop, false otherwise
 *         @alter Increments/decrements the value of var
 */
function axisLoopCondition(&$var, $reverseOrder, $limit)
{
    if ($var == null) {
        if ($reverseOrder) {
            $var = $limit;
        } else {
            $var = 1;
        }
    } else {
        if ($reverseOrder) {
            -- $var;
        } else {
            ++ $var;
        }
    }
    return $var > 0 && $var <= $limit;
}

ob_start();
?>



<div
	style="display: table-cell; padding-top: -10px; vertical-align: top;">
	<div>
		<h4 class="ui-widget-header">
			<span class='help storage'>
				<div><?php echo __('help_storage_layout_storage') ?></div>
			</span> <span class="ui-icon ui-icon-calculator" style="float: left;"></span>
			<?php echo __('storage layout'). ' : '. $translatedStorageType?>
		</h4>
		<table class='storageLayout' style="width: 100%;">
		

<?php
$xSize = $storageControlData['StorageCtrl']['coord_x_size'];
$ySize = $storageControlData['StorageCtrl']['coord_y_size'];
if ((strlen($xSize) == 0 || strlen($ySize) == 0) && ($storageControlData['StorageCtrl']['display_x_size'] > 0 || $storageControlData['StorageCtrl']['display_y_size'] > 0)) {
    // continuous numbering with 2 dimensions
    $useWidth = $ySize = max(1, $storageControlData['StorageCtrl']['display_x_size']);
    $useHeight = $xSize = max(1, $storageControlData['StorageCtrl']['display_y_size']);
    $oneCoordToDisplayAsTwoAxis = true;
    // Validate that the number of displayed cells is the same as the number of actual cells
    if (max(1, $storageControlData['StorageCtrl']['coord_x_size']) * max(1, $storageControlData['StorageCtrl']['coord_y_size']) != $xSize * $ySize) {
        echo ("The current box properties are invalid. The storage cells count and the cells count to display doesn't match. Contact ATiM support.<br/>");
        echo ("Real storage cells: " . (($storageControlData['StorageCtrl']['coord_x_size']) * max(1, $storageControlData['StorageCtrl']['coord_y_size'])) . "<br/>");
        echo ("Display cells: " . $xSize * $ySize . "<br/>");
        print_r($storageControlData['StorageCtrl']);
        exit();
    }
} else {
    $oneCoordToDisplayAsTwoAxis = false;
    if (strlen($xSize) == 0 || $xSize < 1) {
        $xSize = 1;
    }
    if (strlen($ySize) == 0 || $ySize < 1) {
        $ySize = 1;
    }
    $useWidth = $xSize;
    $useHeight = $ySize;
}
$xAlpha = $storageControlData['StorageCtrl']['coord_x_type'] == "alphabetical";
$yAlpha = $storageControlData['StorageCtrl']['coord_y_type'] == "alphabetical";
$permuteXY = (isset($storageControlData['StorageCtrl']['permute_x_y']) && $storageControlData['StorageCtrl']['permute_x_y'] == 1) ? true : false;
$horizontalIncrement = $storageControlData['StorageCtrl']['horizontal_increment'];
// table display loop and inner loop
$j = null;
while (axisLoopCondition($j, $storageControlData['StorageCtrl']['reverse_y_numbering'], $useHeight)) {
    echo ("<tr>");
    if (! $oneCoordToDisplayAsTwoAxis) {
        $yVal = $yAlpha ? chr($j + 64) : $j;
    }
    $i = null;
    while (axisLoopCondition($i, $storageControlData['StorageCtrl']['reverse_x_numbering'], $useWidth)) {
        if ($oneCoordToDisplayAsTwoAxis) {
            if ($horizontalIncrement) {
                $displayValue = ($j - 1) * $ySize + $i;
            } else {
                $displayValue = ($i - 1) * $xSize + $j;
            }
            $displayValue = $xAlpha ? chr($displayValue + 64) : $displayValue;
        } else {
            $xVal = $xAlpha ? chr($i + 64) : $i;
            if (! $permuteXY) {
                $displayValue = $xVal . "-" . $yVal;
            } else {
                $displayValue = $yVal . "-" . $xVal;
            }
        }
        echo ("<td style='display: table-cell;'><b>" . $displayValue . "</b></td>");
    }
    echo ("</tr>\n");
}

// NOTE: No hook supported!
?>
</table>
	</div>
</div>

<?php

$content = ob_get_clean();

$settings = array(
    'header' => __('storage layout', null),
    'actions' => true
);
$finalOptions = array(
    'data' => array(),
    'type' => 'detail',
    'settings' => $settings,
    'extras' => $noLayoutMsg ? __($noLayoutMsg) : $content,
    'links' => $structureLinks
);

$hookLink = $this->Structures->hook('layout');
if ($hookLink) {
    require ($hookLink);
}

$this->Structures->build($emptyStructure, $finalOptions);