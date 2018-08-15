<?php

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