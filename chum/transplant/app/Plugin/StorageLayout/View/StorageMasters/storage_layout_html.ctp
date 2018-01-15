<?php

/**
 * Increments/decrements the var according to the reverseOrder option and returns true/false based on reverseOrder and the limit
 * @param unknown_type $var The variable to loop on, must be null on the first iteration
 * @param unknown_type $reverseOrder True to reverse the order
 * @param unknown_type $limit The limit of the axis
 * @return true if you must continue to loop, false otherwise
 * @alter Increments/decrements the value of var
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
<div style="display: table-cell; vertical-align: top;">
	<ul style='margin-right: 10px';>
		<li><span class="button RecycleStorage" style='width: 80%;'><span
				class="ui-icon ui-icon-refresh"></span><?php echo(__("unclassify all storage's items")); ?></span></li>
		<li><span class="button TrashStorage" style='width: 80%;'><span
				class="ui-icon ui-icon-close"></span><?php echo(__("remove all storage's items")); ?></span></li>
	</ul>
</div>
<div
	style="display: table-cell; padding-top: -10px; vertical-align: top;">
	<div>
		<h4 class="ui-widget-header">
			<span class='help storage'>
				<div><?php echo __('help_storage_layout_storage') ?></div>
			</span> <span class="ui-icon ui-icon-calculator" style="float: left;"></span>
			<?php echo $data['parent']['StorageControl']['translated_storage_type'] , ' : ' , $data['parent']['StorageMaster']['short_label']; ?>
		</h4>
		<table class='storageLayout' style="width: 100%;">
<?php
if ($data['parent']['StorageControl']['coord_x_type'] == 'list') {
    if (isset($data['parent']['StorageControl']['horizontal_display']) && $data['parent']['StorageControl']['horizontal_display']) {
        echo ("<tr>");
        foreach ($data['parent']['list'] as $listItem) {
            echo ("<td class='droppable mycell'>" . '<b>' . $listItem['StorageCoordinate']['coordinate_value'] . '</b>' . '<ul id="s_' . $atimMenuVariables['StorageMaster.id'] . '_c_' . $listItem['StorageCoordinate']['id'] . '_1"/>' . '</td>');
        }
        echo ("</tr>\n");
    } else {
        foreach ($data['parent']['list'] as $listItem) {
            echo ("<tr><td class='droppable mycell'>" . '<b>' . $listItem['StorageCoordinate']['coordinate_value'] . '</b>' . '<ul id="s_' . $atimMenuVariables['StorageMaster.id'] . '_c_' . $listItem['StorageCoordinate']['id'] . '_1"/>' . "</td></tr>\n");
        }
    }
} else {
    $xSize = $data['parent']['StorageControl']['coord_x_size'];
    $ySize = $data['parent']['StorageControl']['coord_y_size'];
    if ((strlen($xSize) == 0 || strlen($ySize) == 0) && ($data['parent']['StorageControl']['display_x_size'] > 0 || $data['parent']['StorageControl']['display_y_size'] > 0)) {
        // continuous numbering with 2 dimensions
        $useWidth = $ySize = max(1, $data['parent']['StorageControl']['display_x_size']);
        $useHeight = $xSize = max(1, $data['parent']['StorageControl']['display_y_size']);
        $oneCoordToDisplayAsTwoAxis = true;
        // Validate that the number of displayed cells is the same as the number of actual cells
        if (max(1, $data['parent']['StorageControl']['coord_x_size']) * max(1, $data['parent']['StorageControl']['coord_y_size']) != $xSize * $ySize) {
            echo ("The current box properties are invalid. The storage cells count and the cells count to display doesn't match. Contact ATiM support.<br/>");
            echo ("Real storage cells: " . (($data['parent']['StorageControl']['coord_x_size']) * max(1, $data['parent']['StorageControl']['coord_y_size'])) . "<br/>");
            echo ("Display cells: " . $xSize * $ySize . "<br/>");
            print_r($data['parent']['StorageControl']);
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
    $xAlpha = $data['parent']['StorageControl']['coord_x_type'] == "alphabetical";
    $yAlpha = $data['parent']['StorageControl']['coord_y_type'] == "alphabetical";
    $horizontalIncrement = $data['parent']['StorageControl']['horizontal_increment'];
    // table display loop and inner loop
    $j = null;
    while (axisLoopCondition($j, $data['parent']['StorageControl']['reverse_y_numbering'], $useHeight)) {
        echo ("<tr>");
        if (! $oneCoordToDisplayAsTwoAxis) {
            $yVal = $yAlpha ? chr($j + 64) : $j;
        }
        $i = null;
        while (axisLoopCondition($i, $data['parent']['StorageControl']['reverse_x_numbering'], $useWidth)) {
            if ($oneCoordToDisplayAsTwoAxis) {
                if ($horizontalIncrement) {
                    $displayValue = ($j - 1) * $ySize + $i;
                } else {
                    $displayValue = ($i - 1) * $xSize + $j;
                }
                $displayValue = $xAlpha ? chr($displayValue + 64) : $displayValue;
                $useValue = $displayValue . "_1"; // static y = 1
            } else {
                $xVal = $xAlpha ? chr($i + 64) : $i;
                $useValue = $xVal . "_" . $yVal;
                if ($useHeight == 1) {
                    $displayValue = $xVal;
                } elseif ($useWidth == 1) {
                        $displayValue = $yVal;
                    } else {
                        $displayValue = $xVal . "-" . $yVal;
                    }
            }
            echo ("<td class='droppable'>" . '<b>' . $displayValue . "</b><ul id='s_" . $atimMenuVariables['StorageMaster.id'] . "_c_" . $useValue . "' /></td>");
        }
        echo ("</tr>\n");
    }
}

// NOTE: No hook supported!

?>
		</table>
	</div>
</div>
<div style="display: table-cell; vertical-align: top;">
	<ul class='trash_n_unclass'>
		<li class='trash_n_unclass'>
			<div
				style="width: 100%; border: solid 1px; display: inline-block; vertical-align: top;">
				<h4 class="ui-widget-header" style="white-space: nowrap;">
					<span class="ui-icon ui-icon-refresh" style="float: left;"></span><?php echo(__("unclassified")); ?>
					<span class='help storage'>
						<div><?php echo __('help_storage_layout_unclassified') ?></div>
					</span>
				</h4>
				<div class="droppable"
					style="padding-top: 5px; border: solid 1px transparent;">
					<ul
						id="s_<?php echo $atimMenuVariables['StorageMaster.id']; ?>_c_u_u"
						class="unclassified" style="margin-right: 5px;"></ul>
					<span class="button TrashUnclassified"><span
						class="ui-icon ui-icon-close" style="float: left;"></span><?php echo(__("remove all unclassified")); ?></span>
				</div>
			</div>
		</li>
		<li class='trash_n_unclass'>
			<div
				style="width: 100%; border: solid 1px; display: inline-block; vertical-align: top;">
				<h4 class="ui-widget-header" style="white-space: nowrap;">
					<span class="ui-icon ui-icon-close" style="float: left;"></span><?php echo(__("remove")); ?>
					<span class='help storage'>
						<div><?php echo __('help_storage_layout_remove') ?></div>
					</span>
				</h4>
				<div class="droppable"
					style="padding-top: 5px; border: solid 1px transparent;">
					<ul id="s_t_c_t_t" class="trash" style="margin-right: 5px;"></ul>
					<span class="button RecycleTrash"><span
						class="ui-icon ui-icon-refresh" style="float: left;"></span><?php echo(__("unclassify all removed")); ?></span>
				</div>
			</div>
		</li>
	</ul>
</div>
<?php
$content = ob_get_clean();

$childrenDisplay = array();
foreach ($data['children'] as $childrenArray) {
    $childrenDisplay[] = $childrenArray['DisplayData'];
}

echo json_encode(array(
    'valid' => 1,
    'content' => $content,
    'positions' => $childrenDisplay,
    'check_conflicts' => $data['parent']['StorageControl']['check_conflicts']
));