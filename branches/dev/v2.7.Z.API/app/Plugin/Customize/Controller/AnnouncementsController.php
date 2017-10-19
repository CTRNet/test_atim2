<?php

/**
 * Class AnnouncementsController
 */
class AnnouncementsController extends CustomizeAppController
{

    public $uses = array(
        'Announcement'
    );

    public $paginate = array(
        'Announcement' => array(
            'order' => 'Announcement.date DESC'
        )
    );

    /**
     * @param string $listType
     */
    public function index($listType = '')
    {
        $this->set('listType', $listType);
        
        if (! in_array($listType, array(
            'all',
            'current'
        ))) {
            
            // Nothing to do
            
            // CUSTOM CODE: FORMAT DISPLAY DATA
            $hookLink = $this->hook('format');
            if ($hookLink) {
                require ($hookLink);
            }
        } else {
            
            $conditions = array(
                'OR' => array(
                    array(
                        'Announcement.bank_id' => $_SESSION['Auth']['User']['Group']['bank_id']? $_SESSION['Auth']['User']['Group']['bank_id'] : '-1'
                    ),
                    array(
                        'Announcement.user_id' => $_SESSION['Auth']['User']['id']
                    )
                )
            );
            
            if ($listType == 'current') {
                $conditions = array(
                    $conditions,
                    array(
                        'OR' => array(
                            array(
                                "Announcement.date = '" . date("Y-m-d") . "'"
                            ),
                            array(
                                "Announcement.date_start <= '" . date("Y-m-d") . "'",
                                "Announcement.date_end >= '" . date("Y-m-d") . "'"
                            )
                        )
                    )
                );
            }
            
            // CUSTOM CODE: FORMAT DISPLAY DATA
            $hookLink = $this->hook('format_conditions');
            if ($hookLink) {
                require ($hookLink);
            }
            
            $this->request->data = $this->paginate($this->Announcement, $conditions);
            
            // CUSTOM CODE: FORMAT DISPLAY DATA
            $hookLink = $this->hook('format_all_and_current');
            if ($hookLink) {
                require ($hookLink);
            }
        }
    }

    /**
     * @param null $announcementId
     */
    public function detail($announcementId = null)
    {
        $this->request->data = $this->Announcement->getOrRedirect($announcementId);
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }
}