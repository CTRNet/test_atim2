<?php

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

// Build the csv layout

$csvLayoutData = array();
$errors = array();
if ($data['parent']['StorageControl']['coord_x_type'] == 'list') {
    // Note: $data['parent']['StorageControl']['horizontal_display'] does not exist anymore
    foreach ($data['parent']['list'] as $listItem)
        $csvLayoutData[][0] = array(
            'x_y' => $listItem['StorageCoordinate']['id'] . '_1',
            'display_value' => $listItem['StorageCoordinate']['coordinate_value'],
            'display_value_x' => null,
            'display_value_y' => null
        );
    $xSize = 1;
    $ySize = sizeof($data['parent']['list']);
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
            $errors[] = array(
                "The current box properties are invalid. The storage cells count and the cells count to display doesn't match. Contact ATiM support."
            );
            $errors[] = array(
                "Real storage cells: " . (($data['parent']['StorageControl']['coord_x_size']) * max(1, $data['parent']['StorageControl']['coord_y_size']))
            );
            $errors[] = array(
                "Display cells: " . $xSize * $ySize
            );
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
    if (! $errors) {
        $xAlpha = $data['parent']['StorageControl']['coord_x_type'] == "alphabetical";
        $yAlpha = $data['parent']['StorageControl']['coord_y_type'] == "alphabetical";
        $permuteXY = (isset($data['parent']['StorageControl']['permute_x_y']) && $data['parent']['StorageControl']['permute_x_y'] == 1) ? true : false;
        $horizontalIncrement = $data['parent']['StorageControl']['horizontal_increment'];
        // table display loop and inner loop
        $j = null;
        while (axisLoopCondition($j, $data['parent']['StorageControl']['reverse_y_numbering'], $useHeight)) {
            $csvLayoutLineData = array();
            if (! $oneCoordToDisplayAsTwoAxis) {
                $yVal = $yAlpha ? chr($j + 64) : $j;
            }
            $i = null;
            while (axisLoopCondition($i, $data['parent']['StorageControl']['reverse_x_numbering'], $useWidth)) {
                $useValue = null;
                $displayValue = null;
                $displayValueX = null;
                $displayValueY = null;
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
                    if (! $permuteXY) {
                        $useValue = $xVal . "_" . $yVal;
                        $displayValue = $xVal . "-" . $yVal;
                        $displayValueX = $xVal;
                        $displayValueY = $yVal;
                    } else {
                        $useValue = $yVal . "_" . $xVal;
                        $displayValue = $yVal . "-" . $xVal;
                        $displayValue = $yVal . "-" . $xVal;
                        $displayValueX = $xVal;
                        $displayValueY = $yVal;
                    }
                }
                $csvLayoutLineData[] = array(
                    'x_y' => $useValue,
                    'display_value' => $displayValue,
                    'display_value_x' => $displayValueX,
                    'display_value_y' => $displayValueY
                );
            }
            $csvLayoutData[] = $csvLayoutLineData;
        }
    }
}

if (! $errors) {
    
    // Build array gathering cell content labels from x_y values
    
    $xYValuesToCellContentLabels = array();
    foreach ($data['children'] as $newContent)
        $xYValuesToCellContentLabels[$newContent['DisplayData']['x'] . "_" . $newContent['DisplayData']['y']][] = $newContent['DisplayData']['label'];
        
        // Build csv data
    
    $csvData = array();
    if ($data['parent']['StorageControl']['coord_y_type']) {
        // Two dimensions layout with both x and y coordinates tracked
        $firstLineRecord = true;
        foreach ($csvLayoutData as $csvLayoutLineData) {
            $xHeaders = array(
                ''
            );
            $yHeader = '';
            $csvLineContentData = array();
            foreach ($csvLayoutLineData as $csvLayoutCellData) {
                $xHeaders[] = $csvLayoutCellData['display_value_x'];
                $yHeader = $csvLayoutCellData['display_value_y'];
                $csvLineContentData[] = isset($xYValuesToCellContentLabels[$csvLayoutCellData['x_y']]) ? implode(' / ', $xYValuesToCellContentLabels[$csvLayoutCellData['x_y']]) : '';
                unset($xYValuesToCellContentLabels[$csvLayoutCellData['x_y']]);
            }
            if ($firstLineRecord)
                $csvData[] = $xHeaders;
            $firstLineRecord = false;
            array_unshift($csvLineContentData, $yHeader);
            $csvData[] = $csvLineContentData;
        }
    } else {
        if (sizeof($csvLayoutData) == 1) {
            // One dimension layout display as a line with only x coordinates tracked
            foreach ($csvLayoutData[0] as $csvLayoutCellData) {
                // Position
                $csvData[0][] = $csvLayoutCellData['display_value'];
                // Content
                $csvData[1][] = isset($xYValuesToCellContentLabels[$csvLayoutCellData['x_y']]) ? implode(' / ', $xYValuesToCellContentLabels[$csvLayoutCellData['x_y']]) : '';
                unset($xYValuesToCellContentLabels[$csvLayoutCellData['x_y']]);
            }
        } elseif (sizeof($csvLayoutData[0]) == 1) {
            // One dimension layout display as a column with only x coordinates tracked
            foreach ($csvLayoutData as $csvLayoutLineData) {
                $csvLayoutCellData = $csvLayoutLineData[0];
                $csvData[] = array(
                    $csvLayoutCellData['display_value'],
                    (isset($xYValuesToCellContentLabels[$csvLayoutCellData['x_y']]) ? implode(' / ', $xYValuesToCellContentLabels[$csvLayoutCellData['x_y']]) : '')
                );
                unset($xYValuesToCellContentLabels[$csvLayoutCellData['x_y']]);
            }
        } else {
            // Two dimensions layout with only x coordinates tracked
            foreach ($csvLayoutData as $csvLayoutLineData) {
                $csvPostionsData = array();
                $csvLineContentData = array();
                foreach ($csvLayoutLineData as $csvLayoutCellData) {
                    $csvPostionsData[] = $csvLayoutCellData['display_value'];
                    $csvLineContentData[] = isset($xYValuesToCellContentLabels[$csvLayoutCellData['x_y']]) ? implode(' / ', $xYValuesToCellContentLabels[$csvLayoutCellData['x_y']]) : '';
                    unset($xYValuesToCellContentLabels[$csvLayoutCellData['x_y']]);
                }
                $csvData[] = $csvPostionsData;
                $csvData[] = $csvLineContentData;
            }
        }
    }
    
    // Add unpositionned content to csv data
    
    if ($xYValuesToCellContentLabels) {
        $unclassifiedLabels = array();
        foreach ($xYValuesToCellContentLabels as $newLabels)
            $unclassifiedLabels = array_merge($unclassifiedLabels, $newLabels);
        $csvData[] = array(
            ''
        ); // Add empty row
        $first = true;
        foreach ($unclassifiedLabels as $unclassifiedLabel) {
            $csvData[] = array(
                $first ? __("unclassified") : '',
                $unclassifiedLabel
            );
            $first = false;
        }
    }
} else {
    // Error Display
    $csvData = $errors;
}

// Launch CSV creation

if (isset(AppController::getInstance()->csvConfig))
    $this->Csv->csvSeparator = AppController::getInstance()->csvConfig['define_csv_separator'];
$this->Csv->addRow(array(
    __('storage'),
    $data['parent']['StorageControl']['translated_storage_type'] . ' : ' . $data['parent']['StorageMaster']['short_label']
));
$this->Csv->addRow(array(
    ''
));
foreach ($csvData as $newDataLine)
    $this->Csv->addRow($newDataLine);
echo $this->Csv->render(true, isset(AppController::getInstance()->csvConfig) ? AppController::getInstance()->csvConfig['define_csv_encoding'] : CSV_ENCODING);
exit();