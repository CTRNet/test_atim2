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
$links = array(
    'top' => '/Administrate/Dropdowns/configure/' . $atimMenuVariables['StructurePermissibleValuesCustom.control_id'] . '/',
    'radiolist' => array(
        'StructurePermissibleValuesCustom.id' => '%%StructurePermissibleValuesCustom.id%%'
    ),
    'bottom' => array(
        'cancel' => '/Administrate/Dropdowns/view/' . $atimMenuVariables['StructurePermissibleValuesCustom.control_id'] . '/'
    )
);

$desc = __('dropdown_config_desc');
$this->Structures->build($atimStructure, array(
    'type' => 'editgrid',
    'settings' => array(
        'header' => array(
            'title' => '',
            'description' => $desc
        ),
        'pagination' => false
    ),
    'links' => $links
));

?>
<script>
	var dropdownConfig = true;
	var alphabeticalOrderingStr = "<?php echo __('alphabetical ordering'); ?>";
	var alphaOrderChecked = <?php echo $alphaOrder ? "true" : "false"; ?>;
</script>