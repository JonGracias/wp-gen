<?php
class NHLController {
    private $apiUrl = "https://api-web.nhle.com/v1/club-schedule-season/WSH/20242025";
    private $scheduleData;

    public function __construct() {
        // You can initialize any properties or dependencies here
    }

    public function getSchedule() {
        // Fetch the schedule data from the NHL API
        $response = @file_get_contents($this->apiUrl);
        if ($response === FALSE) {
            error_log("Error occurred while fetching the NHL schedule.");
            return false;
        }
        $this->scheduleData = json_decode($response, true);
        $this->cacheScheduleData($this->scheduleData);
        return $this->scheduleData;
    }

    private function cacheScheduleData($data) {
        // Cache data to a local file
        file_put_contents(plugin_dir_path(__FILE__) . '../cache/schedule.json', json_encode($data));
    }

    public function getCachedSchedule() {
        if (file_exists(plugin_dir_path(__FILE__) . '../cache/schedule.json')) {
            $data = file_get_contents(plugin_dir_path(__FILE__) . '../cache/schedule.json');
            return json_decode($data, true);
        } else {
            return $this->getSchedule();
        }
    }

    public function displaySchedule() {
        $scheduleData = $this->getSchedule();
        require_once plugin_dir_path(__FILE__) . '../views/schedule.php';
    }
}
