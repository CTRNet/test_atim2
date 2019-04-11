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
 * Class LabBookAppModel
 */
class LabBookAppModel extends AppModel
{

    /**
     *
     * @param int $labBookCtrlId
     * @return array The fields managed by the lab book or false if the process_ctrl_id is invalid
     */
    public function getFields($labBookCtrlId)
    {
        $control = AppModel::getInstance("LabBook", "LabBookControl", true);
        $data = $control->findById($labBookCtrlId);
        if (! empty($data)) {
            $detailModel = new AppModel(array(
                'table' => $data['LabBookControl']['detail_tablename'],
                'name' => "LabBookDetail",
                'alias' => "LabBookDetail"
            ));
            $fields = array_keys($detailModel->_schema);
            return array_diff($fields, array(
                "id",
                "lab_book_master_id",
                "created",
                "created_by",
                "modified",
                "modified_by",
                "deleted",
                "deleted_date"
            ));
        }
        return false;
    }
}