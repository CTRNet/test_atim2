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
$chronology['Accuracy']['custom']['date'] = 'date_accuracy';

$finalAtimStructure = $chronology;

$links = array(
    'index' => array(
        'view data' => array(
            'link' => '%%custom.link%%',
            'icon' => 'jsChronology'
        ),
        'access to data' => array(
            'link' => '%%custom.link%%',
            'icon' => 'detail'
        )
    )
);

$finalOptions = array(
    'settings' => array(
        'pagination' => false
    ),
    'type' => 'index',
    'links' => $links,
    'extras' => array(
        10 => '<div id="frame">vive mich</div>'
    )
);

$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

$this->Structures->build($finalAtimStructure, $finalOptions);
?>
<script>
    var columnLarge = true;
</script>