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
 * Class UserAnnouncementsController
 */
App::uses('CustomizeAppController', 'Customize.Controller');

class UserAnnouncementsController extends CustomizeAppController
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
     *
     * @param string $listType
     */
    public function index($listType = '')
    {
        $this->set('listType', $listType);
        
        $this->Structures->set('announcements');
        
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
                        'Announcement.bank_id' => $_SESSION['Auth']['User']['Group']['bank_id'] ? $_SESSION['Auth']['User']['Group']['bank_id'] : '-1'
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
     *
     * @param null $announcementId
     */
    public function detail($announcementId = null)
    {
        $this->Structures->set('announcements');
        
        $this->request->data = $this->Announcement->getOrRedirect($announcementId);
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }
}